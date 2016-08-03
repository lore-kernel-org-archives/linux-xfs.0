Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ECC307CA2
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 05:38:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E94EAC003
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 03:38:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fMYtmiCzC9uNHX5u (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 03:38:05 -0700 (PDT)
Date: Wed, 3 Aug 2016 18:38:00 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 09/17] common/dmerror: fix mount option issues
Message-ID: <20160803103800.GO27776@eguan.usersys.redhat.com>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914483353.11762.14647880235199676753.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146914483353.11762.14647880235199676753.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 21, 2016 at 04:47:13PM -0700, Darrick J. Wong wrote:
> Calling _mount doesn't work when we want to add mount options
> such as realtime devices.  Since it's just a normal scratch device
> mount except for the source device, just call _scratch_mount with
> SCRATCH_DEV set to the dmerror device.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/dmerror |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> 
> diff --git a/common/dmerror b/common/dmerror
> index 5ad9994..22b9ea9 100644
> --- a/common/dmerror
> +++ b/common/dmerror
> @@ -41,14 +41,9 @@ _dmerror_init()
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
> +	SCRATCH_DEV=$DMERROR_DEV _scratch_mount $*

Perhaps you can add "_scratch_options mount" to _dmerror_mount then
mount with $SCRATCH_OPTIONS? Like what _mount_delay does in
common/dmdelay.

Thanks,
Eryu

>  }
>  
>  _dmerror_unmount()
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
