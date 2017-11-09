Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44388 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753679AbdKII5J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 03:57:09 -0500
Date: Thu, 9 Nov 2017 16:57:05 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 2/4] dmflakey: support error_writes feature for
 dm-flakey
Message-ID: <20171109085705.GW17339@eguan.usersys.redhat.com>
References: <20171109073252.36001-1-houtao1@huawei.com>
 <20171109073252.36001-3-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171109073252.36001-3-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

On Thu, Nov 09, 2017 at 03:32:50PM +0800, Hou Tao wrote:
> Add _require_flakey_with_error_writes() to check the availability of
> dm-flakey target and its error_writes feature, and support for enabling
> FLAKEY_TABLE_ERROR table by passing FLAKEY_ERROR_WRITES to
> _load_flakey_table().
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  common/dmflakey | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/common/dmflakey b/common/dmflakey
> index 16b82d2..845b466 100644
> --- a/common/dmflakey
> +++ b/common/dmflakey
> @@ -20,18 +20,43 @@
>  
>  FLAKEY_ALLOW_WRITES=0
>  FLAKEY_DROP_WRITES=1
> +FLAKEY_ERROR_WRITES=2
>  
>  echo $MOUNT_OPTIONS | grep -q dax
>  if [ $? -eq 0 ]; then
>  	_notrun "Cannot run tests with DAX on dmflakey devices"
>  fi
>  
> +_require_flakey_with_error_writes()
> +{
> +	local SIZE
> +	local TABLE
> +	local NAME=flakey-test
> +
> +	_require_dm_target flakey
> +
> +	SIZE=`blockdev --getsz $SCRATCH_DEV`
> +	TABLE="0 $SIZE flakey $SCRATCH_DEV 0 0 180 1 error_writes"
> +
> +	$DMSETUP_PROG create $NAME --table "$TABLE" >/dev/null 2>&1
> +	if [ $? -ne 0 ]; then
> +		_notrun "This test requires error_writes feature in dm-flakey"
> +	fi
> +	$DMSETUP_PROG mknodes >/dev/null 2>&1
> +
> +	# copy from _cleanup_flakey()
> +	$UDEV_SETTLE_PROG >/dev/null 2>&1
> +	$DMSETUP_PROG remove $NAME >/dev/null 2>&1
> +	$DMSETUP_PROG mknodes >/dev/null 2>&1

How about just call _cleanup_flakey() here?

Thanks,
Eryu

> +}
> +
>  _init_flakey()
>  {
>  	local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
>  	FLAKEY_DEV=/dev/mapper/flakey-test
>  	FLAKEY_TABLE="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 180 0"
>  	FLAKEY_TABLE_DROP="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 0 180 1 drop_writes"
> +	FLAKEY_TABLE_ERROR="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 0 180 1 error_writes"
>  	$DMSETUP_PROG create flakey-test --table "$FLAKEY_TABLE" || \
>  		_fatal "failed to create flakey device"
>  	$DMSETUP_PROG mknodes > /dev/null 2>&1
> @@ -67,9 +92,9 @@ _cleanup_flakey()
>  # table, so it simulates power failure.
>  _load_flakey_table()
>  {
> -
>  	table="$FLAKEY_TABLE"
>  	[ $1 -eq $FLAKEY_DROP_WRITES ] && table="$FLAKEY_TABLE_DROP"
> +	[ $1 -eq $FLAKEY_ERROR_WRITES ] && table="$FLAKEY_TABLE_ERROR"
>  
>  	suspend_opt="--nolockfs"
>  	[ $# -gt 1 ] && [ $2 -eq 1 ] && suspend_opt=""
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
