Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9753CCA12;
	Tue, 29 Sep 2026 02:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790647512; cv=none; b=IyLMGM6+T5cxZPuWhjl7+u6usiUxOBfsjjl97wWf19IFdcoUXLeJoNHeJolQ0lbDJnKOAMflXg5mo8RqWJDVGKeTUURTBSg7u/snbHDMXFnK3RAk6npNuz43nL7BUDtEEnSN7Nqi52uzOOIEK6yeO/IjzR7ZQPqqUrAxF6K8H74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790647512; c=relaxed/simple;
	bh=mMPIBfn+GSTTte81m7xXNvX/BzHi9+3yfWXjeFfThAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QL6tolDcEuD+frA5OWHqq8l2Nr2T3VSBgs8DVA9QXLXYU1XiuXYMSSEQ8JJJkpPgQUwBBlkSN53y46E2Lg1Xnrk180QXK8zFNwX5bYl4HFE7thxosrhh3XyTgdo8hOSUorb9i6X2yyGQI5ACFiDVsbsr2nginFjZ5bSfPHZhRpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlmBRtAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlmBRtAA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4CC9A1F000FF;
	Tue, 29 Sep 2026 02:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790647510;
	bh=zpFZmA4P1moWc+f/lSCKc7Cg9rWhLYbqtIK+HDmobgs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HlmBRtAA52Yn/MZ4UYs+/H76UfoXMm7vJnEhIfFTMwvXTLyTKpiw3yP3uJ6Hf8tK7
	 gjPqXrO4dAxfc48Yjd0SeH3b8/cz2mjPedo5lh100n9+1SK2SjuEx6H4bT1KIF8cu9
	 aO5uMA/cAypxSAx02nkY2HePH5QFhkeepFX8Kub/F1Gr5+fKZFCo8Bkj3wLgKhog43
	 hHSBulVq72BYn95MAObQ85H6S5+EVjrYudWe9KpDUqZUoC3fE3f2EesNDS4WPfW+l+
	 EgxOW2CpDo/kjhxETX5ZS6wuspw/xQtkgAVDGJWBRi9sjFvhEsbE66ssYq0MoN/rKE
	 c+xehItX6Q9qw==
Date: Mon, 28 Sep 2026 19:05:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] xfs/2307: test checksum handling using corrupted
 checksums
Message-ID: <20260929020509.GP2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-13-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:53PM +0200, Christoph Hellwig wrote:
> Inject errors into the rtcsum files and check that the kernel handles
> them gracefully and that repair fixes them, rebuilding the checksums if
> needed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/2307     | 106 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/2307.out |  93 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 199 insertions(+)
>  create mode 100755 tests/xfs/2307
>  create mode 100644 tests/xfs/2307.out
> 
> diff --git a/tests/xfs/2307 b/tests/xfs/2307
> new file mode 100755
> index 000000000000..47d5be36623d
> --- /dev/null
> +++ b/tests/xfs/2307
> @@ -0,0 +1,106 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2026 Christoph Hellwig.
> +#
> +# FS QA Test No. 2307
> +#
> +# Inject errors into the rtcsum files and check that the kernel handles
> +# them gracefully and that repair fixes them, rebuilding the checksums if
> +# needed.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick repair zone datacsum
> +
> +. ./common/filter
> +. ./common/repair
> +
> +_require_scratch_nocheck
> +
> +
> +prepare_fs()
> +{
> +	_scratch_mkfs >> $seqres.full 2>&1
> +	_scratch_mount
> +	_require_xfs_data_csum $TEST_DIR
> +	cat /bin/sh > $SCRATCH_MNT/sh
> +	_scratch_unmount
> +}
> +
> +exercise_repair()
> +{
> +	echo "Checking corrupted file system"
> +	_scratch_xfs_repair -P -n >> $seqres.full 2>&1
> +
> +	echo "Repairing corrupted file system"
> +	_scratch_xfs_repair -P >> $seqres.full 2>&1
> +}
> +
> +check_corrupted()
> +{
> +	echo "Checking corrupted file system"
> +	_scratch_xfs_repair -P -n >> $seqres.full 2>&1
> +	if [ $? -eq 0 ]; then
> +		_fail "xfs_repair -n succeeded"
> +	fi
> +
> +	_scratch_mount
> +
> +	echo "Reading from corrupted file system"
> +	cmp /bin/sh $SCRATCH_MNT/sh
> +	_scratch_unmount
> +}
> +
> +check_fixed()
> +{
> +	echo "Checking repaired file system"
> +	_scratch_xfs_repair -P -n 2>&1 | _filter_repair
> +
> +	_scratch_mount
> +
> +	echo "Scrubbing repaired file system"
> +	$XFS_SCRUB_PROG -x -a 0 $SCRATCH_MNT >> $seqres.full
> +	if [ $? -ne 0 ]; then
> +		_fail "xfs_scrub failed"
> +	fi
> +
> +	echo "Reading from repaired file system"
> +	cmp /bin/sh $SCRATCH_MNT/sh
> +	_scratch_unmount
> +}
> +
> +echo
> +echo
> +echo "Corrupting rtcsum inode size"
> +echo
> +prepare_fs
> +_scratch_xfs_set_metadata_field core.size 18 "path -m /rtgroups/0.csum"
> +check_corrupted
> +exercise_repair
> +check_fixed
> +
> +echo
> +echo
> +echo "Corrupting rtcsum inode mode"
> +echo
> +prepare_fs
> +_scratch_xfs_set_metadata_field core.mode 0 "path -m /rtgroups/0.csum"
> +if _try_scratch_mount >>$seqres.full 2>&1; then
> +	_fail "mount succeeded with corrupted nextents"
> +fi
> +exercise_repair
> +check_fixed
> +
> +echo
> +echo
> +echo "Corrupting rtcsum inode nextents"
> +echo
> +prepare_fs
> +_scratch_xfs_set_metadata_field core.nextents 2 "path -m /rtgroups/0.csum"
> +if _try_scratch_mount >>$seqres.full 2>&1; then
> +	_fail "mount succeeded with corrupted nextents"
> +fi
> +exercise_repair
> +check_fixed

Want to try something wild and less obvious like ... shrinking one of
the extent maps so that there's a sparse hole in the rtcsum file?

--D

> +
> +status=0
> +exit
> diff --git a/tests/xfs/2307.out b/tests/xfs/2307.out
> new file mode 100644
> index 000000000000..2016c27ee280
> --- /dev/null
> +++ b/tests/xfs/2307.out
> @@ -0,0 +1,93 @@
> +QA output created by 2307
> +
> +
> +Corrupting rtcsum inode size
> +
> +Allowing write of corrupted data with good CRC
> +core.size = 18
> +Checking corrupted file system
> +Reading from corrupted file system
> +Checking corrupted file system
> +Repairing corrupted file system
> +Checking repaired file system
> +Phase 1 - find and verify superblock...
> +Phase 2 - using <TYPEOF> log
> +        - zero log...
> +        - scan filesystem freespace and inode maps...
> +        - found root inode chunk
> +Phase 3 - for each AG...
> +        - scan (but don't clear) agi unlinked lists...
> +        - process known inodes and perform inode discovery...
> +        - process newly discovered inodes...
> +Phase 4 - check for duplicate blocks...
> +        - setting up duplicate extent list...
> +        - check for inodes claiming duplicate blocks...
> +No modify flag set, skipping phase 5
> +Phase 6 - check inode connectivity...
> +        - traversing filesystem ...
> +        - traversal finished ...
> +        - moving disconnected inodes to lost+found ...
> +Phase 7 - verify link counts...
> +No modify flag set, skipping filesystem flush and exiting.
> +Scrubbing repaired file system
> +Reading from repaired file system
> +
> +
> +Corrupting rtcsum inode mode
> +
> +Allowing write of corrupted data with good CRC
> +core.mode = 0
> +Checking corrupted file system
> +Repairing corrupted file system
> +Checking repaired file system
> +Phase 1 - find and verify superblock...
> +Phase 2 - using <TYPEOF> log
> +        - zero log...
> +        - scan filesystem freespace and inode maps...
> +        - found root inode chunk
> +Phase 3 - for each AG...
> +        - scan (but don't clear) agi unlinked lists...
> +        - process known inodes and perform inode discovery...
> +        - process newly discovered inodes...
> +Phase 4 - check for duplicate blocks...
> +        - setting up duplicate extent list...
> +        - check for inodes claiming duplicate blocks...
> +No modify flag set, skipping phase 5
> +Phase 6 - check inode connectivity...
> +        - traversing filesystem ...
> +        - traversal finished ...
> +        - moving disconnected inodes to lost+found ...
> +Phase 7 - verify link counts...
> +No modify flag set, skipping filesystem flush and exiting.
> +Scrubbing repaired file system
> +Reading from repaired file system
> +
> +
> +Corrupting rtcsum inode nextents
> +
> +Allowing write of corrupted data with good CRC
> +core.nextents = 2
> +Checking corrupted file system
> +Repairing corrupted file system
> +Checking repaired file system
> +Phase 1 - find and verify superblock...
> +Phase 2 - using <TYPEOF> log
> +        - zero log...
> +        - scan filesystem freespace and inode maps...
> +        - found root inode chunk
> +Phase 3 - for each AG...
> +        - scan (but don't clear) agi unlinked lists...
> +        - process known inodes and perform inode discovery...
> +        - process newly discovered inodes...
> +Phase 4 - check for duplicate blocks...
> +        - setting up duplicate extent list...
> +        - check for inodes claiming duplicate blocks...
> +No modify flag set, skipping phase 5
> +Phase 6 - check inode connectivity...
> +        - traversing filesystem ...
> +        - traversal finished ...
> +        - moving disconnected inodes to lost+found ...
> +Phase 7 - verify link counts...
> +No modify flag set, skipping filesystem flush and exiting.
> +Scrubbing repaired file system
> +Reading from repaired file system
> -- 
> 2.53.0
> 
> 
