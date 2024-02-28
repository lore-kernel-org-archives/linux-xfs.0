Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F89C15B98B;
	Wed, 28 Feb 2024 15:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135971; cv=none; b=eZpkYV+5ChPToU2az3lj6zDYeaw2Rfb4/3AoJifFYfZTjN/ixsclJqb/2zcGne207kUm8owWh2ztAziS2P8gmPUeDzz0u4RA8lv2B2oBNALxP8H8A2o5jMmt3R+fFrdx7yxnLnqaOTTXgjxFpAB0mzbp6Qv/bJB7vIsTT4wk4Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135971; c=relaxed/simple;
	bh=kQ5+t1j1ZKEV2cfC/903k6n4OIu4xKbMKcdblukLsDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7b0z647NF6LrnDCkkRzdzpQOB2huscHMUnkeWU8JC6CHq6e3Cai4SyS3YAn8VGMp69WgtPhNBP4Z+3J8q2/KSGzXvpFWJqbRQN6JLCDwY6VMdMlbhFhgmoSZr/lOgFbRzrrvj+gqVfzOiONrY1TVG1H0ORzGM+tUdqhJNG66yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZOKs4bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZOKs4bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94200C433C7;
	Wed, 28 Feb 2024 15:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709135970;
	bh=kQ5+t1j1ZKEV2cfC/903k6n4OIu4xKbMKcdblukLsDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cZOKs4bjptxEDVSZaDrpfhRN44yj3i6zoODIaFDZ5KSbVTp5jgTUIMZ1LRjRTH0HT
	 Fb8RmOxyAqP74vbvlctVDzyrEtwp6JQtEzko8NAL1/LAPpuJL7P+BPVZoBHavws8Cz
	 9rpANqGg9roFOvLeMA3I2eYDRWQExiq5RVfyCzQpF7hGdqpbFs3hIXEKBr6pWhz8qU
	 p//ISZeebGTOOfF1IEKY4lte84klFinrSdKLBK+0JunnjhFTyPURG9RYmX25yuBRbQ
	 EvsE9T1JprpSmf3kMGfpndptjbrL0fIYI15NCr5M4vqlPxRiSYNtR2AG1tsQK2jyy4
	 y3PKDqoOlXHfQ==
Date: Wed, 28 Feb 2024 07:59:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: check logical-sector sized O_DIRECT
Message-ID: <20240228155929.GD1927156@frogsfrogsfrogs>
References: <20221107045618.2772009-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107045618.2772009-1-zlang@kernel.org>

On Mon, Nov 07, 2022 at 12:56:18PM +0800, Zorro Lang wrote:
> If the physical sector size is 4096, but the logical sector size
> is 512, the 512b dio write/read should be allowed.

Huh, did we all completely forget to review this patch?

> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
> 
> Hi,
> 
> This reproducer was written for xfs, I try to make it to be a generic
> test case for localfs. Current it test passed on xfs, extN and btrfs,
> the bug can be reproduced on old rhel-6.6 [1]. If it's not right for
> someone fs, please feel free to tell me.
> 
> Thanks,
> Zorro
> 
> [1]
> # ./check generic/888
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 xxx-xxxxx-xxxxxx 2.6.32-504.el6.x86_64
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
> MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/loop1 /mnt/scratch
> 
> generic/888      - output mismatch (see /root/xfstests-dev/results//generic/888.out.bad)
>     --- tests/generic/888.out   2022-11-06 23:42:44.683040977 -0500
>     +++ /root/xfstests-dev/results//generic/888.out.bad 2022-11-06 23:48:33.986481844 -0500
>     @@ -4,3 +4,4 @@
>      512
>      mkfs and mount
>      DIO read/write 512 bytes
>     +pwrite64: Invalid argument
>     ...
>     (Run 'diff -u tests/generic/888.out /root/xfstests-dev/results//generic/888.out.bad'  to see the entire diff)
> Ran: generic/888
> Failures: generic/888
> Failed 1 of 1 tests
> 
>  tests/generic/888     | 52 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/888.out |  6 +++++
>  2 files changed, 58 insertions(+)
>  create mode 100755 tests/generic/888
>  create mode 100644 tests/generic/888.out
> 
> diff --git a/tests/generic/888 b/tests/generic/888
> new file mode 100755
> index 00000000..b5075d1e
> --- /dev/null
> +++ b/tests/generic/888
> @@ -0,0 +1,52 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 888
> +#
> +# Make sure logical-sector sized O_DIRECT write is allowed
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	[ -d "$SCSI_DEBUG_MNT" ] && $UMOUNT_PROG $SCSI_DEBUG_MNT 2>/dev/null
> +	_put_scsi_debug_dev
> +}
> +
> +# Import common functions.
> +. ./common/scsi_debug
> +
> +# real QA test starts here
> +_supported_fs generic
> +_fixed_by_kernel_commit 7c71ee78031c "xfs: allow logical-sector sized O_DIRECT"
> +_require_scsi_debug
> +# If TEST_DEV is block device, make sure current fs is a localfs which can be
> +# written on scsi_debug device
> +_require_test
> +_require_block_device $TEST_DEV

_require_odirect?

> +
> +echo "Get a device with 4096 physical sector size and 512 logical sector size"
> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 256`
> +blockdev --getpbsz --getss $SCSI_DEBUG_DEV
> +
> +echo "mkfs and mount"
> +_mkfs_dev $SCSI_DEBUG_DEV || _fail "Can't make $FSTYP on scsi_debug device"
> +SCSI_DEBUG_MNT="$TEST_DIR/scsi_debug_$seq"
> +rm -rf $SCSI_DEBUG_MNT
> +mkdir $SCSI_DEBUG_MNT
> +run_check _mount $SCSI_DEBUG_DEV $SCSI_DEBUG_MNT

/me wonders, should we try to use $MKFS_OPTIONS and $MOUNT_OPTIONS
on the scsidebug device?  To catch cases where the config actually
matters for that kind of thing?

--D

> +
> +echo "DIO read/write 512 bytes"
> +# This dio write should succeed, even the physical sector size is 4096, but
> +# the logical sector size is 512
> +$XFS_IO_PROG -d -f -c "pwrite 0 512" $SCSI_DEBUG_MNT/testfile >> $seqres.full
> +$XFS_IO_PROG -d -c "pread 0 512" $SCSI_DEBUG_MNT/testfile >> $seqres.full
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/888.out b/tests/generic/888.out
> new file mode 100644
> index 00000000..0f142ce9
> --- /dev/null
> +++ b/tests/generic/888.out
> @@ -0,0 +1,6 @@
> +QA output created by 888
> +Get a device with 4096 physical sector size and 512 logical sector size
> +4096
> +512
> +mkfs and mount
> +DIO read/write 512 bytes
> -- 
> 2.31.1
> 
