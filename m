Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E622D78B;
	Fri,  5 Jan 2024 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a8kD0CD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A27AC433C7;
	Fri,  5 Jan 2024 13:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704462717;
	bh=coIJIWRfL6D35HRIXTPC4+qbFPcTFOtcNaXUo0rLYGQ=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=a8kD0CD4hyfKeBlKkKkbFXm7OX23NCJjc26otoUAqi+JAMI8L2BWNGw9YsNDFRFAA
	 vGjRIR1sXAAhVmq0IVFVhhkg//PNhrJyTnRh72Pbn1ZljicADKfiqoOIGw+mQWubPx
	 Wvs3m8PlYGxsXPTl95H8XywtjtYeLCaXc09vQN7BrEbub4WLRTLG/WzocuzhmCrrNE
	 hE0OqgI2gCwAqCLpWgKbS29r6MIr9+d8KfNcYPema8MXp8iB2JzVvHQsL0IOJexbqh
	 h7+tu3a4nJvSO93NSV16FajnNcFdfjJlSQCP6E8xawPtke75b2+H/0Tmg6DWRP+VA/
	 qN3aKMBGBJz0A==
References: <20240102084357.1199843-1-chandanbabu@kernel.org>
 <20240102084357.1199843-5-chandanbabu@kernel.org>
 <20240103055728.GP361584@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 4/5] xfs: Add support for testing metadump v2
Date: Fri, 05 Jan 2024 12:34:19 +0530
In-reply-to: <20240103055728.GP361584@frogsfrogsfrogs>
Message-ID: <874jfr51mv.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Jan 02, 2024 at 09:57:28 PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 02, 2024 at 02:13:51PM +0530, Chandan Babu R wrote:
>> This commit adds the ability to test metadump v2 to existing metadump tests.
>> 
>> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
>> ---
>>  tests/xfs/129     |  63 ++++++++++++---
>>  tests/xfs/129.out |   4 +-
>>  tests/xfs/234     |  63 ++++++++++++---
>>  tests/xfs/234.out |   4 +-
>>  tests/xfs/253     | 195 ++++++++++++++++++++++++++--------------------
>>  tests/xfs/291     |  25 +++++-
>>  tests/xfs/432     |  29 +++++--
>>  tests/xfs/432.out |   3 +-
>>  tests/xfs/503     |  94 +++++++++++++---------
>>  tests/xfs/503.out |  12 +--
>>  10 files changed, 326 insertions(+), 166 deletions(-)
>> 
>> diff --git a/tests/xfs/129 b/tests/xfs/129
>> index 6f2ef564..7226d57d 100755
>> --- a/tests/xfs/129
>> +++ b/tests/xfs/129
>> @@ -16,7 +16,11 @@ _cleanup()
>>  {
>>      cd /
>>      _scratch_unmount > /dev/null 2>&1
>> -    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/image
>> +    [[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
>> +	    _destroy_loop_device $logdev
>> +    [[ -n $datadev ]] && _destroy_loop_device $datadev
>> +    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/data-image \
>> +       $TEST_DIR/log-image
>>  }
>>  
>>  # Import common functions.
>> @@ -47,18 +51,57 @@ seq 1 2 $((nr_blks - 1)) | while read nr; do
>>  			$testdir/file2 $((nr * blksz)) $blksz >> $seqres.full
>>  done
>>  
>> -echo "Create metadump file"
>>  _scratch_unmount
>> -_scratch_xfs_metadump $metadump_file
>>  
>> -# Now restore the obfuscated one back and take a look around
>> -echo "Restore metadump"
>> -SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
>> -SCRATCH_DEV=$TEST_DIR/image _scratch_mount
>> -SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
>> +max_md_version=1
>> +_scratch_metadump_v2_supported && max_md_version=2
>>  
>> -echo "Check restored fs"
>> -_check_generic_filesystem $metadump_file
>> +echo "Create metadump file, restore it and check restored fs"
>> +for md_version in $(seq 1 $max_md_version); do
>> +	# Determine the version to be passed to metadump/mdrestore
>> +	version=""
>> +	if [[ $max_md_version == 2 ]]; then
>> +		version="-v $md_version"
>> +	fi
>> +
>> +	_scratch_xfs_metadump $metadump_file $version
>> +
>> +	# Now restore the obfuscated one back and take a look around
>> +
>> +	# Metadump v2 files can contain contents dumped from an external log
>> +	# device. Use a temporary file to hold the log device contents restored
>> +	# from such a metadump file.
>> +	slogdev=$TEST_DIR/log-image
>> +	if [[ -z $version || $version == "-v 1" || -z $SCRATCH_LOGDEV ]]; then
>> +		slogdev=""
>> +	fi
>> +
>> + 	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
>
>    ^ space before tab
>

Sorry, I will fix it.

>> +		   _scratch_xfs_mdrestore $metadump_file
>> +
>> +	datadev=$(_create_loop_device $TEST_DIR/data-image)
>> +
>> +	logdev=${SCRATCH_LOGDEV}
>> +	if [[ -s $TEST_DIR/log-image ]]; then
>> +		logdev=$(_create_loop_device $TEST_DIR/log-image)
>> +	fi
>> +
>> +	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
>> +	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
>> +
>> +	[[ -z $logdev ]] && logdev=none
>> +	_check_xfs_filesystem $datadev $logdev none
>> +
>> +	if [[ -s $TEST_DIR/log-image ]]; then
>> +		_destroy_loop_device $logdev
>> +		logdev=""
>> +		rm -f $TEST_DIR/log-image
>> +	fi
>> +
>> +	_destroy_loop_device $datadev
>> +	datadev=""
>> +	rm -f $TEST_DIR/data-image
>> +done
>
> Given the major differences between v1 and v2, would the two metadump
> tests be easier to understand if this loop were unrolled?
>

Yes, you are right. Unrolling the loop will improve the readability of the
code. I will make the required changes.

> I like that it mdrestores to a separate device to preserve the original
> $SCRATCH_DEV metadata between metadump v1 and v2 testing.
>
>>  # success, all done
>>  status=0
>> diff --git a/tests/xfs/129.out b/tests/xfs/129.out
>> index da6f43fd..0f24c431 100644
>> --- a/tests/xfs/129.out
>> +++ b/tests/xfs/129.out
>> @@ -1,6 +1,4 @@
>>  QA output created by 129
>>  Create the original file blocks
>>  Reflink every other block
>> -Create metadump file
>> -Restore metadump
>> -Check restored fs
>> +Create metadump file, restore it and check restored fs
>> diff --git a/tests/xfs/234 b/tests/xfs/234
>> index 57d447c0..2f6b1f65 100755
>> --- a/tests/xfs/234
>> +++ b/tests/xfs/234
>> @@ -16,7 +16,11 @@ _cleanup()
>>  {
>>      cd /
>>      _scratch_unmount > /dev/null 2>&1
>> -    rm -rf $tmp.* $metadump_file $TEST_DIR/image
>> +    [[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
>> +	    _destroy_loop_device $logdev
>> +    [[ -n $datadev ]] && _destroy_loop_device $datadev
>> +    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/image \
>> +       $TEST_DIR/log-image
>>  }
>>  
>>  # Import common functions.
>> @@ -47,18 +51,57 @@ seq 1 2 $((nr_blks - 1)) | while read nr; do
>>  	$XFS_IO_PROG -c "fpunch $((nr * blksz)) $blksz" $testdir/file1 >> $seqres.full
>>  done
>>  
>> -echo "Create metadump file"
>>  _scratch_unmount
>> -_scratch_xfs_metadump $metadump_file
>>  
>> -# Now restore the obfuscated one back and take a look around
>> -echo "Restore metadump"
>> -SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
>> -SCRATCH_DEV=$TEST_DIR/image _scratch_mount
>> -SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
>> +max_md_version=1
>> +_scratch_metadump_v2_supported && max_md_version=2
>>  
>> -echo "Check restored fs"
>> -_check_generic_filesystem $metadump_file
>> +echo "Create metadump file, restore it and check restored fs"
>> +for md_version in $(seq 1 $max_md_version); do
>> +	# Determine the version to be passed to metadump/mdrestore
>> +	version=""
>> +	if [[ $max_md_version == 2 ]]; then
>> +		version="-v $md_version"
>> +	fi
>> +
>> +	_scratch_xfs_metadump $metadump_file $version
>> +
>> +	# Now restore the obfuscated one back and take a look around
>> +
>> +	# Metadump v2 files can contain contents dumped from an external log
>> +	# device. Use a temporary file to hold the log device contents restored
>> +	# from such a metadump file.
>> +	slogdev=$TEST_DIR/log-image
>> +	if [[ -z $version || $version == "-v 1" || -z $SCRATCH_LOGDEV ]]; then
>> +		slogdev=""
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
>> +	fi
>> +
>> +	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
>> +	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
>> +
>> +	[[ -z $logdev ]] && logdev=none
>> +	_check_xfs_filesystem $datadev $logdev none
>> +
>> +	if [[ -s $TEST_DIR/log-image ]]; then
>> +		_destroy_loop_device $logdev
>> +		logdev=""
>> +		rm -f $TEST_DIR/log-image
>> +	fi
>> +
>> +	_destroy_loop_device $datadev
>> +	datadev=""
>> +	rm -f $TEST_DIR/data-image
>> +done
>>  
>>  # success, all done
>>  status=0
>> diff --git a/tests/xfs/234.out b/tests/xfs/234.out
>> index 463d4660..fc2ddd77 100644
>> --- a/tests/xfs/234.out
>> +++ b/tests/xfs/234.out
>> @@ -1,6 +1,4 @@
>>  QA output created by 234
>>  Create the original file blocks
>>  Punch every other block
>> -Create metadump file
>> -Restore metadump
>> -Check restored fs
>> +Create metadump file, restore it and check restored fs
>> diff --git a/tests/xfs/253 b/tests/xfs/253
>> index ce902477..b69a1faf 100755
>> --- a/tests/xfs/253
>> +++ b/tests/xfs/253
>> @@ -52,114 +52,139 @@ function create_file() {
>>  echo "Disciplyne of silence is goed."
>>  
>>  _scratch_mkfs >/dev/null 2>&1
>> -_scratch_mount
>>  
>> -# Initialize and mount the scratch filesystem, then create a bunch
>> -# of files that exercise the original problem.
>> -#
>> -# The problem arose when a file name produced a hash that contained
>> -# either 0x00 (string terminator) or 0x27 ('/' character) in a
>> -# spot used to determine a character in an obfuscated name.  This
>> -# occurred in one of 5 spots at the end of the name, at position
>> -# (last-4), (last-3), (last-2), (last-1), or (last).
>
> I wonder, could you create the scratch fs and only then move into
> testing v1 and v2 metadump?  Rather than doing the create_file stuff
> twice?  Or do we actually end up with a different fs between the two
> iterations?
>

Yes, Creating the fs once should be sufficient. I will implement the changes
that have been suggested.

> The other two tests here look good enough for now...
>
> --D
>

-- 
Chandan
