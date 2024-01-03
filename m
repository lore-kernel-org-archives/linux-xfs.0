Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3484A17981;
	Wed,  3 Jan 2024 05:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxH4psAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0602C433C7;
	Wed,  3 Jan 2024 05:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704260641;
	bh=XjzIo2mgzGBWu3o7veNfWwc0GJ1XZ2W1mdRsGkvvuNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mxH4psAjHdqJo5edBUdRZX6BvCQl/vkHx0I4eLkOt2FVkvFPMdhwTPJMyDQKEC35p
	 U5mUL+atPZUeKEsry5msWAQykdEqHW2uqL+kDsR6PCgbJBFqxus9+d2W3oiCHcNSrB
	 kwckpngrAyukFAZgNO7Dz1lv799L6FcwMe/Eoxs97A5WZGncsQ7CZSgIiCpU9G5xcT
	 PWoT4xLXCTWB9fwFmrMignx29G0DzMw/8R+HWEkEYb2pwz6RKi0ZOvo5KgEsH8GF0G
	 uOdr7hvk4s6iLiWB/IYzYs04/Bvp4YJatMkx+PU2TBomUTVgzys9UsmAZ+OuTAUwk4
	 1kosuAi5PpB2A==
Date: Tue, 2 Jan 2024 21:44:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 5/5] xfs: Check correctness of metadump/mdrestore's
 ability to work with dirty log
Message-ID: <20240103054400.GO361584@frogsfrogsfrogs>
References: <20240102084357.1199843-1-chandanbabu@kernel.org>
 <20240102084357.1199843-6-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240102084357.1199843-6-chandanbabu@kernel.org>

On Tue, Jan 02, 2024 at 02:13:52PM +0530, Chandan Babu R wrote:
> Add a new test to verify if metadump/mdrestore are able to dump and restore
> the contents of a dirty log.
> 
> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
> ---
>  tests/xfs/801     | 115 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/801.out |  14 ++++++
>  2 files changed, 129 insertions(+)
>  create mode 100755 tests/xfs/801
>  create mode 100644 tests/xfs/801.out
> 
> diff --git a/tests/xfs/801 b/tests/xfs/801
> new file mode 100755
> index 00000000..3ed559df
> --- /dev/null
> +++ b/tests/xfs/801
> @@ -0,0 +1,115 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 801
> +#
> +# Test metadump/mdrestore's ability to dump a dirty log and restore it
> +# correctly.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick metadump log logprint punch
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	_scratch_unmount > /dev/null 2>&1
> +}
> +
> +# Import common functions.
> +. ./common/dmflakey
> +. ./common/inject
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_test
> +_require_xfs_debug
> +_require_xfs_io_error_injection log_item_pin
> +_require_dm_target flakey
> +_require_xfs_io_command "pwrite"
> +_require_test_program "punch-alternating"
> +
> +metadump_file=${TEST_DIR}/${seq}.md
> +testfile=${SCRATCH_MNT}/testfile
> +
> +echo "Format filesystem on scratch device"
> +_scratch_mkfs >> $seqres.full 2>&1
> +
> +max_md_version=1
> +_scratch_metadump_v2_supported && max_md_version=2
> +
> +external_log=0
> +if [[ $USE_EXTERNAL = yes && -n "$SCRATCH_LOGDEV" ]]; then
> +	external_log=1
> +fi
> +
> +if [[ $max_md_version == 1 && $external_log == 1 ]]; then
> +	_notrun "metadump v1 does not support external log device"
> +fi
> +
> +echo "Initialize and mount filesystem on flakey device"
> +_init_flakey
> +_load_flakey_table $FLAKEY_ALLOW_WRITES
> +_mount_flakey
> +
> +echo "Create test file"
> +$XFS_IO_PROG -s -f -c "pwrite 0 5M" $testfile >> $seqres.full
> +
> +echo "Punch alternative blocks of test file"
> +$here/src/punch-alternating $testfile
> +
> +echo "Mount cycle the filesystem on flakey device"
> +_unmount_flakey
> +_mount_flakey
> +
> +device=$(readlink -f $FLAKEY_DEV)
> +device=$(_short_dev $device)
> +
> +echo "Pin log items in the AIL"
> +echo 1 > /sys/fs/xfs/${device}/errortag/log_item_pin

_scratch_inject_error log_item_pin 1

> +
> +echo "Create two checkpoint transactions on ondisk log"
> +for ct in $(seq 1 2); do
> +	offset=$(xfs_io -c 'fiemap' $testfile | tac |  grep -v hole | \

$XFS_IO_PROG

> +			 head -n 1 | awk -F '[\\[.]' '{ print $2 * 512; }')
> +	$XFS_IO_PROG -c "truncate $offset" -c fsync $testfile
> +done
> +
> +echo "Drop writes to filesystem from here onwards"
> +_load_flakey_table $FLAKEY_DROP_WRITES
> +
> +echo "Unpin log items in AIL"
> +echo 0 > /sys/fs/xfs/${device}/errortag/log_item_pin

_scratch_inject_error log_item_pin 0

> +
> +echo "Unmount filesystem on flakey device"
> +_unmount_flakey
> +
> +echo "Clean up flakey device"
> +_cleanup_flakey
> +
> +echo -n "Filesystem has a "
> +_print_logstate
> +
> +echo "Create metadump file, restore it and check restored fs"
> +for md_version in $(seq 1 $max_md_version); do
> +	[[ $md_version == 1 && $external_log == 1 ]] && continue
> +
> +	version=""
> +	if [[ $max_md_version == 2 ]]; then
> +		version="-v $md_version"
> +	fi
> +
> +	_scratch_xfs_metadump $metadump_file -a -o $version
> +	_scratch_xfs_mdrestore $metadump_file

Don't you want to mdrestore to a file or something so that the next
iteration of the loop will still be dumping from the exact same fs?

--D

> +
> +	_scratch_mount
> +	_check_scratch_fs
> +	_scratch_unmount
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/801.out b/tests/xfs/801.out
> new file mode 100644
> index 00000000..a2f2abca
> --- /dev/null
> +++ b/tests/xfs/801.out
> @@ -0,0 +1,14 @@
> +QA output created by 801
> +Format filesystem on scratch device
> +Initialize and mount filesystem on flakey device
> +Create test file
> +Punch alternative blocks of test file
> +Mount cycle the filesystem on flakey device
> +Pin log items in the AIL
> +Create two checkpoint transactions on ondisk log
> +Drop writes to filesystem from here onwards
> +Unpin log items in AIL
> +Unmount filesystem on flakey device
> +Clean up flakey device
> +Filesystem has a dirty log
> +Create metadump file, restore it and check restored fs
> -- 
> 2.43.0
> 
> 
