Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897D3138496;
	Mon, 20 May 2024 18:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716228141; cv=none; b=P1lnvL5uJpwCRFl3tmNw8AjInQ32+zAWJ64mByq9rhXz0Y+WJvIKpdsBIBoYbpvraxJI7qMVg9zusMgF2feN4AeP6xDmuOoZdPgKAb9AB+aKE0rcnaqRD29ziFgny+50RAlqijYhxLAk6oj8oqBq0cfuhLygp0sRMBFN3bri3cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716228141; c=relaxed/simple;
	bh=n0+tOObzkjmLN26mxF7gNx3sR4DXADUfj5C6hBdu+9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PSxIVaej0Qx7TRliGEeowr1XpdlRQM7ZuZ88DYcZarEvnnAqq83YOFwuzY4tgm+h44Z+owVZECHTs6wBQ4Ighv2DZWsBT4qNmg17aNcsRTVV3mcTO6gD9rRYWkDs28qGhhKHTJ6Nw8SUOTofTlL8BDvjLekc1QVrLcrb6U/SCOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s5cWm5K1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s5cWm5K1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEFBC2BD10;
	Mon, 20 May 2024 18:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716228141;
	bh=n0+tOObzkjmLN26mxF7gNx3sR4DXADUfj5C6hBdu+9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s5cWm5K1LOxEtieZU/qrq1CXl/FKJYQ44LzNn5OP7ilgiDbWKCmGFPyvoG2yPQ+cq
	 bu/TiR/sMdps21XT/KXnBdlcf0CXeeYRR4HFk1btQgrLQ8J31CoNrwDDhYJ/rxpouq
	 HuPeufRllWnTVnq3i9pUQRR+I/NhcGKVf9AGmYgjjU9NIbVn5qpVcTjHYxgTiCtj9m
	 2HXWRf82RNWXy/VYVsxBNp51g+mbW+AfMciLi36z0lH3ypAbuYqqUZHfb0uKN/cRrD
	 3ScghTr5Ti9J2yeJZHuTy6CXJc6Bxf5/NKBC3uzry7Ywv3vA51gXb204EWTZzQyhlI
	 ZEN5zYk0Epayg==
Date: Mon, 20 May 2024 11:02:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test quota's project ID on special files
Message-ID: <20240520180220.GH25518@frogsfrogsfrogs>
References: <20240520170004.669254-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520170004.669254-2-aalbersh@redhat.com>

On Mon, May 20, 2024 at 07:00:05PM +0200, Andrey Albershteyn wrote:
> With addition of FS_IOC_FSSETXATTRAT xfs_quota now can set project
> ID on filesystem inodes behind special files. Previously, quota
> reporting didn't count inodes of special files created before
> project initialization. Only new inodes had project ID set.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
> 
> Notes:
>     This is part of the patchset which introduces
>     FS_IOC_FS[GET|SET]XATTRAT:
>     https://lore.kernel.org/linux-xfs/20240520164624.665269-2-aalbersh@redhat.com/T/#t
>     https://lore.kernel.org/linux-xfs/20240520165200.667150-2-aalbersh@redhat.com/T/#u
> 
>  tests/xfs/608     | 73 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/608.out | 10 +++++++
>  2 files changed, 83 insertions(+)
>  create mode 100755 tests/xfs/608
>  create mode 100644 tests/xfs/608.out
> 
> diff --git a/tests/xfs/608 b/tests/xfs/608
> new file mode 100755
> index 000000000000..3573c764c5f4
> --- /dev/null
> +++ b/tests/xfs/608
> @@ -0,0 +1,73 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Red Hat.  All Rights Reserved.
> +#
> +# FS QA Test 608
> +#
> +# Test that XFS can set quota project ID on special files
> +#
> +. ./common/preamble
> +_begin_fstest auto quota
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	rm -f $tmp.proects $tmp.projid

Not sure why this is "proects" (is that a misspelling of 'projects'?)
but the rm above should take care of these, and then you don't need to
redefine _cleanup.

> +}
> +
> +
> +# Import common functions.
> +. ./common/quota
> +. ./common/filter
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_quota
> +_require_user
> +
> +_scratch_mkfs >/dev/null 2>&1

Perhaps dump the output to $seqres.full?

The rest looks ok to me; thank you for including a test with the new
functionality!

--D

> +_qmount_option "pquota"
> +_scratch_mount
> +_require_test_program "af_unix"
> +_require_symlinks
> +_require_mknod
> +
> +function create_af_unix () {
> +	$here/src/af_unix $* || echo af_unix failed
> +}
> +
> +function filter_quota() {
> +	_filter_quota | sed "s~$tmp.proects~PROJECTS_FILE~"
> +}
> +
> +projectdir=$SCRATCH_MNT/prj
> +id=42
> +
> +mkdir $projectdir
> +mkfifo $projectdir/fifo
> +mknod $projectdir/chardev c 1 1
> +mknod $projectdir/blockdev b 1 1
> +create_af_unix $projectdir/socket
> +touch $projectdir/foo
> +ln -s $projectdir/foo $projectdir/symlink
> +touch $projectdir/bar
> +ln -s $projectdir/bar $projectdir/broken-symlink
> +rm -f $projectdir/bar
> +
> +$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
> +	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
> +$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
> +	-c "limit -p isoft=20 ihard=20 $id " $SCRATCH_DEV | filter_quota
> +$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
> +	-c "project -cp $projectdir $id" $SCRATCH_DEV | filter_quota
> +$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
> +	-c "report -inN -p" $SCRATCH_DEV
> +$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
> +	-c "project -Cp $projectdir $id" $SCRATCH_DEV | filter_quota
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/608.out b/tests/xfs/608.out
> new file mode 100644
> index 000000000000..c3d56c3c7682
> --- /dev/null
> +++ b/tests/xfs/608.out
> @@ -0,0 +1,10 @@
> +QA output created by 608
> +Setting up project 42 (path SCRATCH_MNT/prj)...
> +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> +Checking project 42 (path SCRATCH_MNT/prj)...
> +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> +#0                   3          0          0     00 [--------]
> +#42                  8         20         20     00 [--------]
> +
> +Clearing project 42 (path SCRATCH_MNT/prj)...
> +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> -- 
> 2.42.0
> 
> 
