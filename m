Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 54AB67F5A
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 11:15:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 432C8304075
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 09:15:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id i1b6FVqhCBGn03ui for
	<xfs@oss.sgi.com>; Mon, 21 Oct 2013 09:15:46 -0700 (PDT)
Message-ID: <5265532E.1060208@redhat.com>
Date: Mon, 21 Oct 2013 11:15:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: stat the dev we're removing to make sure its'
	really gone V3
References: <1382372033-2742-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382372033-2742-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 10/21/13 11:13 AM, Josef Bacik wrote:
> I've been periodically failing btrfs/003 because my box sometimes takes a little
> longer to unregister the device when we remove it and so the output from btrfs
> dev show doesn't match what we are wanting since it still sees the device.  To
> fix this just stat and sleep if we still see the device node and only continue
> once udev or whatever actually removes the device node so that we don't get
> random failures.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


> ---
> V2->V3: actually use the lun local variable.
> 
>  common/rc       | 11 ++++++++++-
>  tests/btrfs/003 |  2 +-
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index b253948..b5eb582 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2093,7 +2093,16 @@ _require_freeze()
>  # ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
>  _devmgt_remove()
>  {
> -	echo 1 > /sys/class/scsi_device/${1}/device/delete || _fail "Remove disk failed"
> +	local lun=$1
> +	local disk=$2
> +
> +	echo 1 > /sys/class/scsi_device/${lun}/device/delete || _fail "Remove disk failed"
> +
> +	stat $disk > /dev/null 2>&1
> +	while [ $? -eq 0 ]; do
> +		sleep 1
> +		stat $disk > /dev/null 2>&1
> +	done
>  }
>  
>  # arg 1 is dev to add and is output of the below eg.
> diff --git a/tests/btrfs/003 b/tests/btrfs/003
> index 262b1d5..15c2cc7 100755
> --- a/tests/btrfs/003
> +++ b/tests/btrfs/003
> @@ -142,7 +142,7 @@ _test_replace()
>  	DEVHTL=`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev`
>  
>  	#fail disk
> -	_devmgt_remove ${DEVHTL}
> +	_devmgt_remove ${DEVHTL} $ds
>  	dev_removed=1
>  
>  	$BTRFS_UTIL_PROG fi show $SCRATCH_DEV | grep "Some devices missing" >> $seqres.full || _fail \
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
