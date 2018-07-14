Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:43082 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbeGNKhn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Jul 2018 06:37:43 -0400
Date: Sat, 14 Jul 2018 18:14:47 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 2/7] misc: force the exact quota options coded into the
 test
Message-ID: <20180714101447.GC2830@desktop>
References: <153067984748.28393.1595618163831671652.stgit@magnolia>
 <153067986006.28393.12507727179398690195.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153067986006.28393.12507727179398690195.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jul 03, 2018 at 09:51:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Several tests require setting exactly the quota mount options that are
> encoded in the test.  Unfortunately, quota mount options set by the user
> in MOUNT_OPTIONS can turn on other quota types, which causes the golden
> outputs to be off for various reasons (quota report output, behavior
> changes, etc.)
> 
> So use _qmount_option to delete all the quota mount options in these
> tests so that the test itself can run with exactly the config for which
> it was written.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/230 |    3 +++
>  tests/xfs/075     |    4 ++++
>  tests/xfs/116     |    3 +++
>  tests/xfs/132     |    5 +++++
>  tests/xfs/220     |    3 +++
>  5 files changed, 18 insertions(+)
> 
> 
> diff --git a/tests/generic/230 b/tests/generic/230
> index bc8c1ad0..a7ab67f7 100755
> --- a/tests/generic/230
> +++ b/tests/generic/230
> @@ -99,6 +99,9 @@ rm -f $seqres.full
>  
>  grace=2
>  
> +# Test only the quota type specified in each _scratch_mount clause below.
> +_qmount_option 'defaults'
> +

IMHO, instead of converting all user defined quota related options to
'defaults' then mount with _scratch_mount, it's better to convert them
to what we want and mount with _qmount, i.e.

_qmount_option "usrquota,grpquota"
_qmount

This is the standard process for quota tests.

>  _scratch_mkfs >> $seqres.full 2>&1
>  _scratch_mount "-o usrquota,grpquota"
>  quotacheck -u -g $SCRATCH_MNT 2>/dev/null

Also, with _qmount we could remove all these quotacheck and quotaon.

Thanks,
Eryu

> diff --git a/tests/xfs/075 b/tests/xfs/075
> index caf612bb..dee01462 100755
> --- a/tests/xfs/075
> +++ b/tests/xfs/075
> @@ -25,12 +25,16 @@ _cleanup()
>  # get standard environment, filters and checks
>  . ./common/rc
>  . ./common/filter
> +. ./common/quota
>  
>  # real QA test starts here
>  _supported_fs xfs
>  _supported_os Linux
>  _require_scratch
>  
> +# norecovery mounts do not succeed with quotas eanbled, so shut them off
> +_qmount_option "defaults"
> +
>  echo "Silence is golden"
>  _scratch_mkfs_sized $((512 * 1024 * 1024)) >$seqres.full
>  
> diff --git a/tests/xfs/116 b/tests/xfs/116
> index 6887d7e5..4422eb50 100755
> --- a/tests/xfs/116
> +++ b/tests/xfs/116
> @@ -36,6 +36,9 @@ _supported_os Linux
>  _require_scratch
>  _require_xfs_quota
>  
> +# Only mount with the quota options we specify below
> +_qmount_option "defaults"
> +
>  _scratch_mkfs >/dev/null 2>&1
>  _scratch_mount "-o uquota"
>  _scratch_unmount
> diff --git a/tests/xfs/132 b/tests/xfs/132
> index c5fe8b5a..a421f727 100755
> --- a/tests/xfs/132
> +++ b/tests/xfs/132
> @@ -24,6 +24,7 @@ _cleanup()
>  # get standard environment, filters and checks
>  . ./common/rc
>  . ./common/filter
> +. ./common/quota
>  
>  # remove previous $seqres.full before test
>  rm -f $seqres.full
> @@ -43,6 +44,10 @@ _disable_dmesg_check
>  _require_xfs_mkfs_crc
>  _scratch_mkfs -m crc=0 > $seqres.full 2>&1
>  
> +# The files that EIO in the golden output changes if we have quotas enabled
> +# so leave it off.
> +_qmount_option "defaults"
> +
>  # corrupt an inode in the root inode chunk
>  root_ino=$(_scratch_xfs_get_metadata_field 'rootino' 'sb 0')
>  corrupt_ino=$((root_ino + 15))
> diff --git a/tests/xfs/220 b/tests/xfs/220
> index 227d5452..61319c9d 100755
> --- a/tests/xfs/220
> +++ b/tests/xfs/220
> @@ -36,6 +36,9 @@ _supported_os Linux
>  _require_scratch
>  _require_quota
>  
> +# Only mount with the specific quota options mentioned below
> +_qmount_option "defaults"
> +
>  echo "Silence is golden."
>  
>  # create scratch filesystem
> 
