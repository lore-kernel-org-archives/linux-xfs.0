Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37314 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfF1HEM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 03:04:12 -0400
Date: Fri, 28 Jun 2019 15:04:05 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfs: project quota ineritance flag test
Message-ID: <20190628070405.GC7943@desktop>
References: <20190619101047.3149-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619101047.3149-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Jun 19, 2019 at 06:10:47PM +0800, Zorro Lang wrote:
> This case is used to cover xfsprogs bug "b136f48b xfs_quota: fix
> false error reporting of project inheritance flag is not set" at
> first. Then test more behavior when project ineritance flag is
> set or removed.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Test looks fine to me. Just some minor issues inline, and I've fixed
them up on commit.

> ---
>  tests/xfs/507     | 117 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/507.out |  23 +++++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 141 insertions(+)
>  create mode 100755 tests/xfs/507
>  create mode 100644 tests/xfs/507.out
> 
> diff --git a/tests/xfs/507 b/tests/xfs/507
> new file mode 100755
> index 00000000..509da03e
> --- /dev/null
> +++ b/tests/xfs/507
> @@ -0,0 +1,117 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 507
> +#
> +# Test project quota inheritance flag, uncover xfsprogs:
> +#    b136f48b xfs_quota: fix false error reporting of project inheritance flag is not set

Test project..., uncover xfsprogs bug fixed by commit b136f48b19a5
("xfs_quota: fix false error reporting of project inheritance flag is
not set").

> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +_require_xfs_quota
> +
> +cat >$tmp.projects <<EOF
> +10:$SCRATCH_MNT/dir
> +EOF
> +
> +cat >$tmp.projid <<EOF
> +root:0
> +test:10
> +EOF
> +
> +QUOTA_CMD="$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid"
> +
> +filter_xfs_pquota()
> +{
> +        perl -ne "
> +s,$tmp.projects,[PROJECTS_FILE],;
> +s,$SCRATCH_MNT,[SCR_MNT],;
> +s,$SCRATCH_DEV,[SCR_DEV],;
> +        print;"
> +}
> +
> +do_quota_nospc()
> +{
> +	local file=$1
> +	local exp=$2
> +
> +	echo "Write $file, expect $exp:" | _filter_scratch
> +
> +	# replace the "pwrite64" which old xfs_io prints
> +	$XFS_IO_PROG -t -f -c "pwrite 0 5m" $file 2>&1 >/dev/null | \
> +		sed -e 's/pwrite64/pwrite/g'

_filter_xfs_io_error does this job.

> +	rm -f $file
> +}
> +
> +_scratch_mkfs_xfs >>$seqres.full 2>&1
> +_qmount_option "prjquota"
> +_qmount
> +_require_prjquota $SCRATCH_DEV
> +
> +mkdir $SCRATCH_MNT/dir
> +$QUOTA_CMD -x -c 'project -s test' $SCRATCH_MNT >>$seqres.full 2>&1
> +$QUOTA_CMD -x -c 'limit -p bsoft=1m bhard=2m test' $SCRATCH_MNT
> +
> +# test the Project inheritance bit is a directory only flag, and it's set on
> +# directory by default

I added comments here to state that we don't expect "project inheritance
flag is not set" from xfs_quota.

Thanks,
Eryu

> +echo "== The parent directory has Project inheritance bit by default =="
> +touch $SCRATCH_MNT/dir/foo
> +mkdir $SCRATCH_MNT/dir/dir_inherit
> +touch $SCRATCH_MNT/dir/dir_inherit/foo
> +$QUOTA_CMD -x -c 'project -c test' $SCRATCH_MNT | filter_xfs_pquota
> +echo ""
> +
> +# test the quota and the project inheritance quota work well
> +do_quota_nospc $SCRATCH_MNT/dir/foo ENOSPC
> +do_quota_nospc $SCRATCH_MNT/dir/dir_inherit/foo ENOSPC
> +echo ""
> +
> +# test the project quota won't be inherited, if removing the Project
> +# inheritance bit
> +echo "== After removing parent directory has Project inheritance bit =="
> +$XFS_IO_PROG -x -c "chattr -P" $SCRATCH_MNT/dir
> +touch $SCRATCH_MNT/dir/foo
> +mkdir $SCRATCH_MNT/dir/dir_uninherit
> +touch $SCRATCH_MNT/dir/dir_uninherit/foo
> +$QUOTA_CMD -x -c 'project -c test' $SCRATCH_MNT | filter_xfs_pquota
> +echo ""
> +
> +# after remove the Project inheritance bit of the original parent directory,
> +# then verify:
> +# 1) there's not any limit on the original parent directory and files under it
> +# 2) the quota limit of sub-directory which has inherited still works
> +# 3) there's not limit on the new sub-dirctory (not inherit from parent)
> +do_quota_nospc $SCRATCH_MNT/dir/foo Success
> +do_quota_nospc $SCRATCH_MNT/dir/dir_inherit/foo ENOSPC
> +do_quota_nospc $SCRATCH_MNT/dir/dir_uninherit/foo Success
> +
> +_scratch_unmount
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/507.out b/tests/xfs/507.out
> new file mode 100644
> index 00000000..c8c09d3f
> --- /dev/null
> +++ b/tests/xfs/507.out
> @@ -0,0 +1,23 @@
> +QA output created by 507
> +== The parent directory has Project inheritance bit by default ==
> +Checking project test (path [SCR_MNT]/dir)...
> +Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
> +
> +Write SCRATCH_MNT/dir/foo, expect ENOSPC:
> +pwrite: No space left on device
> +Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> +pwrite: No space left on device
> +
> +== After removing parent directory has Project inheritance bit ==
> +Checking project test (path [SCR_MNT]/dir)...
> +[SCR_MNT]/dir - project inheritance flag is not set
> +[SCR_MNT]/dir/foo - project identifier is not set (inode=0, tree=10)
> +[SCR_MNT]/dir/dir_uninherit - project identifier is not set (inode=0, tree=10)
> +[SCR_MNT]/dir/dir_uninherit - project inheritance flag is not set
> +[SCR_MNT]/dir/dir_uninherit/foo - project identifier is not set (inode=0, tree=10)
> +Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
> +
> +Write SCRATCH_MNT/dir/foo, expect Success:
> +Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> +pwrite: No space left on device
> +Write SCRATCH_MNT/dir/dir_uninherit/foo, expect Success:
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ffe4ae12..46200752 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -504,3 +504,4 @@
>  504 auto quick mkfs label
>  505 auto quick spaceman
>  506 auto quick health
> +507 auto quick quota
> -- 
> 2.17.2
> 
