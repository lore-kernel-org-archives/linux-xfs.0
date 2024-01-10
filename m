Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D840DF6C;
	Wed, 10 Jan 2024 06:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c5mkA2CX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8B6C433C7;
	Wed, 10 Jan 2024 06:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704867093;
	bh=HnY3GNHvuEPU7S2SP7+ZFdp14DYulgxqY37Py/jHuhM=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=c5mkA2CXMuQtbIzg7+xO1vHfnaHyfbRJYNmmjYuBQXo/1wDtbLN8iZRb83aKXJUPl
	 I9MqdV6MO2WBsXM2qD036YWS2czoj4dwDjtvdW5B3j4qHVc/gh+pG93BxGFKhxc/tq
	 /lprngZAF1MYWzOdlZ0pn3x4PVQWDrQIGZES5+jZTRcq8oUD1n/QmuLBhN+6WKZo1S
	 bbsE9M1YE3JHMe0CUHqUbxv0qD+3kCS3wfoQ/yAAGDj+gzsPlPtYdRHZkX8fbw5B4G
	 I01FfgL5GUc/eIL108uR9Fg7ZO1v+clgJiHTihElRoeLVcN4DHlFgCZ4+Ufv+J3Hgs
	 Nv9Z4x6JTB3Rg==
References: <20240109102054.1668192-1-chandanbabu@kernel.org>
 <20240109102054.1668192-6-chandanbabu@kernel.org>
 <20240109165745.GF722975@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH V2 5/5] xfs: Check correctness of metadump/mdrestore's
 ability to work with dirty log
Date: Wed, 10 Jan 2024 10:56:28 +0530
In-reply-to: <20240109165745.GF722975@frogsfrogsfrogs>
Message-ID: <87h6jliupa.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Jan 09, 2024 at 08:57:45 AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 09, 2024 at 03:50:47PM +0530, Chandan Babu R wrote:
>> Add a new test to verify if metadump/mdrestore are able to dump and restore
>> the contents of a dirty log.
>> 
>> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
>> ---
>>  tests/xfs/801     | 178 ++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/801.out |  14 ++++
>>  2 files changed, 192 insertions(+)
>>  create mode 100755 tests/xfs/801
>>  create mode 100644 tests/xfs/801.out
>> 
>> diff --git a/tests/xfs/801 b/tests/xfs/801
>> new file mode 100755
>> index 00000000..a7866ce7
>> --- /dev/null
>> +++ b/tests/xfs/801
>> @@ -0,0 +1,178 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2024 Oracle, Inc.  All Rights Reserved.
>> +#
>> +# FS QA Test 801
>> +#
>> +# Test metadump/mdrestore's ability to dump a dirty log and restore it
>> +# correctly.
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick metadump log logprint punch
>> +
>> +# Override the default cleanup function.
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -r -f $tmp.*
>> +	_scratch_unmount > /dev/null 2>&1
>> +	[[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
>> +		_destroy_loop_device $logdev
>> +	[[ -n $datadev ]] && _destroy_loop_device $datadev
>> +	rm -r -f $metadump_file $TEST_DIR/data-image \
>> +	   $TEST_DIR/log-image
>> +}
>> +
>> +# Import common functions.
>> +. ./common/dmflakey
>> +. ./common/inject
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +_require_scratch
>> +_require_test
>> +_require_loop
>> +_require_xfs_debug
>> +_require_xfs_io_error_injection log_item_pin
>> +_require_dm_target flakey
>> +_require_xfs_io_command "pwrite"
>> +_require_test_program "punch-alternating"
>> +
>> +metadump_file=${TEST_DIR}/${seq}.md
>> +testfile=${SCRATCH_MNT}/testfile
>> +
>> +echo "Format filesystem on scratch device"
>> +_scratch_mkfs >> $seqres.full 2>&1
>> +
>> +max_md_version=1
>> +_scratch_metadump_v2_supported && max_md_version=2
>> +
>> +external_log=0
>> +if [[ $USE_EXTERNAL = yes && -n "$SCRATCH_LOGDEV" ]]; then
>> +	external_log=1
>> +fi
>> +
>> +if [[ $max_md_version == 1 && $external_log == 1 ]]; then
>> +	_notrun "metadump v1 does not support external log device"
>> +fi
>> +
>> +verify_metadump_v1()
>> +{
>> +	local version=""
>> +	if [[ $max_md_version == 2 ]]; then
>> +		version="-v 1"
>> +	fi
>> +
>> +	_scratch_xfs_metadump $metadump_file -a -o $version
>> +
>> +	SCRATCH_DEV=$TEST_DIR/data-image _scratch_xfs_mdrestore $metadump_file
>> +
>> +	datadev=$(_create_loop_device $TEST_DIR/data-image)
>> +
>> +	SCRATCH_DEV=$datadev _scratch_mount
>> +	SCRATCH_DEV=$datadev _check_scratch_fs
>> +	SCRATCH_DEV=$datadev _scratch_unmount
>> +
>> +	_destroy_loop_device $datadev
>> +	datadev=""
>> +	rm -f $TEST_DIR/data-image
>> +}
>> +
>> +verify_metadump_v2()
>> +{
>> +	local version="-v 2"
>> +
>> +	_scratch_xfs_metadump $metadump_file -a -o $version
>> +
>> +	# Metadump v2 files can contain contents dumped from an external log
>> +	# device. Use a temporary file to hold the log device contents restored
>> +	# from such a metadump file.
>> +	slogdev=""
>> +	if [[ -n $SCRATCH_LOGDEV ]]; then
>> +		slogdev=$TEST_DIR/log-image
>
> Why not create the loopdevs here?
>

The backing files (i.e. $TEST_DIR/data-image and $TEST_DIR/log-image) have not
yet been created. They are created by the invocation of mdrestore command
below.

>> +	fi
>> +
>> +	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
>> +		   _scratch_xfs_mdrestore $metadump_file
>> +
>> +	datadev=$(_create_loop_device $TEST_DIR/data-image)
>> +
>> +	logdev=${SCRATCH_LOGDEV}
>> +	if [[ -s $TEST_DIR/log-image ]]; then
>> +		logdev=$(_create_loop_device $TEST_DIR/log-image)
>
> if [[ -s $slogdev ]]; then
> 	logdev=$(_create_loop_device $slogdev)
> fi
>
> When would we have logdev == SCRATCH_LOGDEV at this point in the program?

logdev == SCRATCH_LOGDEV only when using an internal log. I think a much
cleaner way of initializing logdev would be

	logdev=""

Combining this with the change suggested by you earlier, the code now looks
like the following,

	verify_metadump_v2()
	{
		local version="-v 2"
	
		_scratch_xfs_metadump $metadump_file -a -o $version
	
		# Metadump v2 files can contain contents dumped from an external log
		# device. Use a temporary file to hold the log device contents restored
		# from such a metadump file.
		slogdev=""
		if [[ -n $SCRATCH_LOGDEV ]]; then
			slogdev=$TEST_DIR/log-image
		fi
	
		SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
			   _scratch_xfs_mdrestore $metadump_file
	
		datadev=$(_create_loop_device $TEST_DIR/data-image)
	
		logdev=""
		if [[ -s $slogdev ]]; then
			logdev=$(_create_loop_device $slogdev)
		fi
	
		SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
		SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _check_scratch_fs
		SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
	
		if [[ -s $logdev ]]; then
			_destroy_loop_device $logdev
			logdev=""
			rm -f $slogdev
		fi
	
		_destroy_loop_device $datadev
		datadev=""
		rm -f $TEST_DIR/data-image
	}

-- 
Chandan
