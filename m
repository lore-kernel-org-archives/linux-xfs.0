Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34806 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935732AbeFRT0v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jun 2018 15:26:51 -0400
Date: Mon, 18 Jun 2018 12:26:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfstests: Test root inode parent pointer repairing
Message-ID: <20180618192635.GH8128@magnolia>
References: <20180618174433.3069-1-mbenatto@redhat.com>
 <20180618174433.3069-2-mbenatto@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180618174433.3069-2-mbenatto@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marco Benatto <mbenatto@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@redhat.com

On Mon, Jun 18, 2018 at 02:44:33PM -0300, Marco Benatto wrote:
> Recently we found out xfs_repair were not repairing
> root inode parent pointer when root inode is on short-form
> and parent points to an invalid inode number (refer to:
> "xfs_repair: Fix root inode's parent when it's bogus for sf
> directory" on xfs-devel list).
> 
> This test checks if xfs_repair successfully repair the
> filesystem in the scenario mentioned before.
> 
> Signed-off-by: Marco Benatto <mbenatto@redhat.com>

Looks ok, I think...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  tests/xfs/450     | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/450.out |  1 +
>  tests/xfs/group   |  1 +
>  3 files changed, 55 insertions(+)
>  create mode 100755 tests/xfs/450
>  create mode 100644 tests/xfs/450.out
> 
> diff --git a/tests/xfs/450 b/tests/xfs/450
> new file mode 100755
> index 0000000..dc7f244
> --- /dev/null
> +++ b/tests/xfs/450
> @@ -0,0 +1,53 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
> +#
> +# FS QA Test 450
> +#
> +# Make sure xfs_repair can repair root inode parent's pointer
> +# when it contains a bogus ino when it's using shot form directory
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +
> +status=1	# failure is the default!
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +
> +
> +_scratch_mkfs >> /dev/null 2>&1
> +
> +rootino=$(_scratch_xfs_get_metadata_field 'rootino' 'sb 0')
> +
> +prefix=$(_scratch_get_sfdir_prefix ${rootino} || \
> +		_fail "Cannot determine sfdir prefix")
> +
> +
> +# Corrupt root inode parent pointer
> +_scratch_xfs_set_metadata_field "${prefix}.hdr.parent.i4" 0 "inode ${rootino}"\
> +								>> $seqres.full
> +
> +_scratch_xfs_repair >> $seqres.full 2>&1
> +
> +_scratch_xfs_repair -n >> $seqres.full 2>&1
> +
> +if [ $? -eq 1 ]
> +then
> +	_fail "xfs_repair failed to repair filesystem"
> +fi
> +
> +echo "OK"
> +status=0
> +exit
> diff --git a/tests/xfs/450.out b/tests/xfs/450.out
> new file mode 100644
> index 0000000..d86bac9
> --- /dev/null
> +++ b/tests/xfs/450.out
> @@ -0,0 +1 @@
> +OK
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 932ab90..3a1db0b 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -447,3 +447,4 @@
>  447 auto mount
>  448 auto quick fuzzers
>  449 auto quick
> +450 auto quick
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
