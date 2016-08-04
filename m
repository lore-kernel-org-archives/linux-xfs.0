Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 930537CA2
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 19:34:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 13A99AC005
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 17:34:07 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id AeQMLBtxRaGX7MCo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 17:34:02 -0700 (PDT)
Date: Wed, 3 Aug 2016 17:33:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 09/17] common/dmerror: fix mount option issues
Message-ID: <20160804003354.GD25565@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914483353.11762.14647880235199676753.stgit@birch.djwong.org>
	<20160803225004.GB25565@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803225004.GB25565@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, eguan@redhat.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 03, 2016 at 03:50:04PM -0700, Darrick J. Wong wrote:
> Calling _mount doesn't work when we want to add mount options
> such as realtime devices.  Since it's just a normal scratch device
> mount except for the source device, just call _scratch_mount with
> SCRATCH_DEV set to the dmerror device.
> 
> v2: Use the standard _scratch_options for mounting.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/dmerror |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/common/dmerror b/common/dmerror
> index 5ad9994..d05c4c8 100644
> --- a/common/dmerror
> +++ b/common/dmerror
> @@ -41,14 +41,10 @@ _dmerror_init()
>  	DMERROR_TABLE="0 $blk_dev_size error $dm_backing_dev 0"
>  }
>  
> -_dmerror_mount_options()
> -{
> -	echo `_common_dev_mount_options $*` $DMERROR_DEV $SCRATCH_MNT
> -}
> -
>  _dmerror_mount()
>  {
> -	_mount -t $FSTYP `_dmerror_mount_options $*`
> +	_scratch_options mount
> +	$MOUNT_PROG -t $FSTYP `_common_dev_mount_options $*` $SCRATCH_OPTIONS \

...aaand of course the next line accidentally got erased.  Sigh.  v3 it is.

--D

>  }
>  
>  _dmerror_unmount()
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
