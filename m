Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751916AbdHDByi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Aug 2017 21:54:38 -0400
Date: Fri, 4 Aug 2017 09:54:35 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/5] common/populate: enable xfs quota accounting
Message-ID: <20170804015435.GB1991@eguan.usersys.redhat.com>
References: <150067465981.30639.14801416171688538711.stgit@magnolia>
 <150067469221.30639.16711306489951233808.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150067469221.30639.16711306489951233808.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Jul 21, 2017 at 03:04:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're creating a populated xfs image, turn on quotas so that we can
> fuzz those fields too.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/populate |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 49 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index 498151f..b77c508 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -21,6 +21,7 @@
>  #  Contact information: Silicon Graphics, Inc., 1500 Crittenden Lane,
>  #  Mountain View, CA 94043, USA, or: http://www.sgi.com
>  #-----------------------------------------------------------------------
> +. ./common/quota
>  
>  _require_populate_commands() {
>  	_require_xfs_io_command "falloc"
> @@ -94,6 +95,47 @@ __populate_fill_fs() {
>  	done
>  }
>  
> +# For XFS, force on all the quota options if quota is enabled
> +# and the user didn't feed us noquota.
> +_populate_xfs_qmount_option()
> +{
> +	# User explicitly told us not to quota
> +	if echo "${MOUNT_OPTIONS}" | grep -q 'noquota'; then
> +		return
> +	fi
> +
> +	# Don't bother if we can't turn on quotas
> +	if [ ! -f /proc/fs/xfs/xqmstat ]; then
> +		# No quota support
> +		return
> +	elif [ "${USE_EXTERNAL}" = "yes" ] && [ ! -z "${SCRATCH_RTDEV}" ]; then
> +		# Quotas not supported on rt filesystems
> +		return
> +	elif [ -z "${XFS_QUOTA_PROG}" ]; then
> +		# xfs quota tools not installed
> +		return
> +	fi
> +
> +	# Turn on all the quotas
> +	if xfs_info "${TEST_DIR}" | grep -q 'crc=1'; then
> +		# v5 filesystems can have group & project quotas
> +		quota="usrquota,grpquota,prjquota"
> +	else
> +		# v4 filesystems cannot mix group & project quotas
> +		quota="usrquota,grpquota"
> +	fi
> +
> +	# Inject our quota mount options
> +	if echo "${MOUNT_OPTIONS}" | grep -q "${quota}"; then
> +		return
> +	elif echo "${MOUNT_OPTIONS}" | egrep -q '(quota|noenforce)'; then
> +		_qmount_option "${quota}"
> +	else
> +		export MOUNT_OPTIONS="$MOUNT_OPTIONS -o ${quota}"
> +		echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
> +	fi

It looks like an unconditional '_qmount_option "${quota}"' would be
sufficient here. Did I miss anything?

> +}
> +
>  # Populate an XFS on the scratch device with (we hope) all known
>  # types of metadata block
>  _scratch_xfs_populate() {
> @@ -106,6 +148,7 @@ _scratch_xfs_populate() {
>  		esac
>  	done
>  
> +	_populate_xfs_qmount_option
>  	_scratch_mount

Then use _qmount? But it's in populate function for xfs, _scratch_mount
and _qmount doesn't have much difference, so either way seems fine.

Thanks,
Eryu

>  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  	dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> @@ -720,7 +763,12 @@ _scratch_populate_cached() {
>  		test -n "${SCRATCH_LOGDEV}" && rm -f "${POPULATE_METADUMP}"
>  		;;
>  	"xfs")
> -		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL} RTDEV ${SCRATCH_RTDEV}";;
> +		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL} RTDEV ${SCRATCH_RTDEV}"
> +		_populate_xfs_qmount_option
> +		if echo "${MOUNT_OPTIONS}" | grep -q 'usrquota'; then
> +			extra_descr="${extra_descr} QUOTAS"
> +		fi
> +		;;
>  	*)
>  		extra_descr="";;
>  	esac
> 
