Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD2DB7CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 01:12:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26C13AC003
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 23:12:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 39lb0fOEaQI6DzA3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Aug 2016 23:12:54 -0700 (PDT)
Date: Mon, 22 Aug 2016 14:12:52 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/2] xfs/006: move code about resetting error handling to
	common/rc
Message-ID: <20160822061252.GJ27776@eguan.usersys.redhat.com>
References: <1471629392-13661-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471629392-13661-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Sat, Aug 20, 2016 at 01:56:31AM +0800, Zorro Lang wrote:
> Nearly 1/3 code is used to reset the xfs error handling attributes,
> This part can be picked up, and used for other cases. So move them
> to a new function reset_xfs_sysfs_error_handling() in common/rc.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

These two patches look good to me, both xfs/006 and the new EIO test
passed on 4.8-rc2 and RHEL7 kernel, test hung as expected if I set
max_retries or retry_timeout_seconds to 0. Just some nitpicks below:

> ---
>  common/rc         | 37 +++++++++++++++++++++++++++++++++++++
>  tests/xfs/006     | 27 +++++++--------------------
>  tests/xfs/006.out |  1 +
>  3 files changed, 45 insertions(+), 20 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 3fb0600..b038d8e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3888,6 +3888,43 @@ _get_fs_sysfs_attr()
>  	cat /sys/fs/${FSTYP}/${dname}/${attr}
>  }
>  
> +
> +# Reset all xfs error handling attributes, set them to original
> +# status.
> +#
> +# Only one argument, and it's necessary:
                                 ^^^^^^^^^ mandatory?

> +#  - dev: device name, e.g. $SCRATCH_DEV
> +#
> +# Note: this function only works for XFS
> +reset_xfs_sysfs_error_handling()

Usually we name common helpers with a "_" as prefix.

I can fix them at commit time, if there's no new review comments from
others.

Thanks,
Eryu

> +{
> +	local dev=$1
> +
> +	if [ ! -b "$dev" -o "$FSTYP" != "xfs" ];then
> +		_fail "Usage: reset_xfs_sysfs_error_handling <device>"
> +	fi
> +
> +	_set_fs_sysfs_attr $dev error/fail_at_unmount 1
> +	echo -n "error/fail_at_unmount="
> +	_get_fs_sysfs_attr $dev error/fail_at_unmount
> +
> +	# Make sure all will be configured to retry forever by default, except
> +	# for ENODEV, which is an unrecoverable error, so it will be configured
> +	# to not retry on error by default.
> +	for e in default EIO ENOSPC; do
> +		_set_fs_sysfs_attr $dev \
> +				   error/metadata/${e}/max_retries -1
> +		echo -n "error/metadata/${e}/max_retries="
> +		_get_fs_sysfs_attr $dev error/metadata/${e}/max_retries
> +
> +		_set_fs_sysfs_attr $dev \
> +				   error/metadata/${e}/retry_timeout_seconds 0
> +		echo -n "error/metadata/${e}/retry_timeout_seconds="
> +		_get_fs_sysfs_attr $dev \
> +				   error/metadata/${e}/retry_timeout_seconds
> +	done
> +}
> +
>  # Skip if we are running an older binary without the stricter input checks.
>  # Make multiple checks to be sure that there is no regression on the one
>  # selected feature check, which would skew the result.
> diff --git a/tests/xfs/006 b/tests/xfs/006
> index 8910026..58f9348 100755
> --- a/tests/xfs/006
> +++ b/tests/xfs/006
> @@ -57,31 +57,18 @@ _scratch_mkfs > $seqres.full 2>&1
>  _dmerror_init
>  _dmerror_mount
>  
> -# Enable fail_at_unmount, so XFS stops retrying on errors at unmount
> -# time. _fail the test if we fail to set it to 1, because the test
> -# probably will hang in such case and block subsequent tests.
> -_set_fs_sysfs_attr $DMERROR_DEV error/fail_at_unmount 1
> +# Make sure all error handling attributes are original status
> +reset_xfs_sysfs_error_handling $DMERROR_DEV
> +
> +# Make sure fail_at_unmount is enabled, so XFS stops retrying on
> +# errors at unmount time. _fail the test if we fail to set it to 1,
> +# because the test probably will hang in such case and block
> +# subsequent tests.
>  attr=`_get_fs_sysfs_attr $DMERROR_DEV error/fail_at_unmount`
>  if [ "$attr" != "1" ]; then
>  	_fail "Failed to set error/fail_at_unmount: $attr"
>  fi
>  
> -# Make sure all will be configured to retry forever by default, except
> -# for ENODEV, which is an unrecoverable error, so it will be configured
> -# to not retry on error by default.
> -for e in default EIO ENOSPC; do
> -	_set_fs_sysfs_attr $DMERROR_DEV \
> -			   error/metadata/${e}/max_retries -1
> -	echo -n "error/metadata/${e}/max_retries="
> -	_get_fs_sysfs_attr $DMERROR_DEV error/metadata/${e}/max_retries
> -
> -	_set_fs_sysfs_attr $DMERROR_DEV \
> -			   error/metadata/${e}/retry_timeout_seconds 0
> -	echo -n "error/metadata/${e}/retry_timeout_seconds="
> -	_get_fs_sysfs_attr $DMERROR_DEV \
> -			   error/metadata/${e}/retry_timeout_seconds
> -done
> -
>  # start a metadata-intensive workload, but no data allocation operation.
>  # Because uncompleted new space allocation I/Os may cause XFS to shutdown
>  # after loading error table.
> diff --git a/tests/xfs/006.out b/tests/xfs/006.out
> index 393f411..3260b3a 100644
> --- a/tests/xfs/006.out
> +++ b/tests/xfs/006.out
> @@ -1,4 +1,5 @@
>  QA output created by 006
> +error/fail_at_unmount=1
>  error/metadata/default/max_retries=-1
>  error/metadata/default/retry_timeout_seconds=0
>  error/metadata/EIO/max_retries=-1
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
