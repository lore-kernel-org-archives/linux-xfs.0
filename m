Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98D318021;
	Wed,  3 Jan 2024 05:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rl7VWgB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEE2C433C7;
	Wed,  3 Jan 2024 05:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704261449;
	bh=SyOCAk1S7VMGrasITMKSHKuWSsUGiKbBDslHB9YGiw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rl7VWgB+lci06fhxzBFkiE2TyYVFFjjCUOpVXLCZt7dfFpCPluRNFut3RmueBtewz
	 PrUGkyEy1AlWc66IiVnpHG7tdlxmFB9DY5BGQj872IS2v+U6Y882gUAdMDqnmDcX2L
	 RTJi6QQ8TvBA7jwyU0i+tkI2o5G96vjgpx0unjyNYS+D5LSoqOSP+3If7iuX1jJXuK
	 ymsPBGaQ/zNzduv4N1iGqsO8906mr3r1N0Nlw1dKQBcnu+6X8SCuCINZPvXNZhz8nZ
	 KNlvaxdRxr40ZNgIfITDd5ljO7w2VOWo3OpK2qWrtDPX4HJiAItXVFD9D416ZEVwuN
	 9o3I25yctey0A==
Date: Tue, 2 Jan 2024 21:57:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 4/5] xfs: Add support for testing metadump v2
Message-ID: <20240103055728.GP361584@frogsfrogsfrogs>
References: <20240102084357.1199843-1-chandanbabu@kernel.org>
 <20240102084357.1199843-5-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240102084357.1199843-5-chandanbabu@kernel.org>

On Tue, Jan 02, 2024 at 02:13:51PM +0530, Chandan Babu R wrote:
> This commit adds the ability to test metadump v2 to existing metadump tests.
> 
> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
> ---
>  tests/xfs/129     |  63 ++++++++++++---
>  tests/xfs/129.out |   4 +-
>  tests/xfs/234     |  63 ++++++++++++---
>  tests/xfs/234.out |   4 +-
>  tests/xfs/253     | 195 ++++++++++++++++++++++++++--------------------
>  tests/xfs/291     |  25 +++++-
>  tests/xfs/432     |  29 +++++--
>  tests/xfs/432.out |   3 +-
>  tests/xfs/503     |  94 +++++++++++++---------
>  tests/xfs/503.out |  12 +--
>  10 files changed, 326 insertions(+), 166 deletions(-)
> 
> diff --git a/tests/xfs/129 b/tests/xfs/129
> index 6f2ef564..7226d57d 100755
> --- a/tests/xfs/129
> +++ b/tests/xfs/129
> @@ -16,7 +16,11 @@ _cleanup()
>  {
>      cd /
>      _scratch_unmount > /dev/null 2>&1
> -    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/image
> +    [[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
> +	    _destroy_loop_device $logdev
> +    [[ -n $datadev ]] && _destroy_loop_device $datadev
> +    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/data-image \
> +       $TEST_DIR/log-image
>  }
>  
>  # Import common functions.
> @@ -47,18 +51,57 @@ seq 1 2 $((nr_blks - 1)) | while read nr; do
>  			$testdir/file2 $((nr * blksz)) $blksz >> $seqres.full
>  done
>  
> -echo "Create metadump file"
>  _scratch_unmount
> -_scratch_xfs_metadump $metadump_file
>  
> -# Now restore the obfuscated one back and take a look around
> -echo "Restore metadump"
> -SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> -SCRATCH_DEV=$TEST_DIR/image _scratch_mount
> -SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
> +max_md_version=1
> +_scratch_metadump_v2_supported && max_md_version=2
>  
> -echo "Check restored fs"
> -_check_generic_filesystem $metadump_file
> +echo "Create metadump file, restore it and check restored fs"
> +for md_version in $(seq 1 $max_md_version); do
> +	# Determine the version to be passed to metadump/mdrestore
> +	version=""
> +	if [[ $max_md_version == 2 ]]; then
> +		version="-v $md_version"
> +	fi
> +
> +	_scratch_xfs_metadump $metadump_file $version
> +
> +	# Now restore the obfuscated one back and take a look around
> +
> +	# Metadump v2 files can contain contents dumped from an external log
> +	# device. Use a temporary file to hold the log device contents restored
> +	# from such a metadump file.
> +	slogdev=$TEST_DIR/log-image
> +	if [[ -z $version || $version == "-v 1" || -z $SCRATCH_LOGDEV ]]; then
> +		slogdev=""
> +	fi
> +
> + 	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \

   ^ space before tab

> +		   _scratch_xfs_mdrestore $metadump_file
> +
> +	datadev=$(_create_loop_device $TEST_DIR/data-image)
> +
> +	logdev=${SCRATCH_LOGDEV}
> +	if [[ -s $TEST_DIR/log-image ]]; then
> +		logdev=$(_create_loop_device $TEST_DIR/log-image)
> +	fi
> +
> +	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
> +	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
> +
> +	[[ -z $logdev ]] && logdev=none
> +	_check_xfs_filesystem $datadev $logdev none
> +
> +	if [[ -s $TEST_DIR/log-image ]]; then
> +		_destroy_loop_device $logdev
> +		logdev=""
> +		rm -f $TEST_DIR/log-image
> +	fi
> +
> +	_destroy_loop_device $datadev
> +	datadev=""
> +	rm -f $TEST_DIR/data-image
> +done

Given the major differences between v1 and v2, would the two metadump
tests be easier to understand if this loop were unrolled?

I like that it mdrestores to a separate device to preserve the original
$SCRATCH_DEV metadata between metadump v1 and v2 testing.

>  # success, all done
>  status=0
> diff --git a/tests/xfs/129.out b/tests/xfs/129.out
> index da6f43fd..0f24c431 100644
> --- a/tests/xfs/129.out
> +++ b/tests/xfs/129.out
> @@ -1,6 +1,4 @@
>  QA output created by 129
>  Create the original file blocks
>  Reflink every other block
> -Create metadump file
> -Restore metadump
> -Check restored fs
> +Create metadump file, restore it and check restored fs
> diff --git a/tests/xfs/234 b/tests/xfs/234
> index 57d447c0..2f6b1f65 100755
> --- a/tests/xfs/234
> +++ b/tests/xfs/234
> @@ -16,7 +16,11 @@ _cleanup()
>  {
>      cd /
>      _scratch_unmount > /dev/null 2>&1
> -    rm -rf $tmp.* $metadump_file $TEST_DIR/image
> +    [[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
> +	    _destroy_loop_device $logdev
> +    [[ -n $datadev ]] && _destroy_loop_device $datadev
> +    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/image \
> +       $TEST_DIR/log-image
>  }
>  
>  # Import common functions.
> @@ -47,18 +51,57 @@ seq 1 2 $((nr_blks - 1)) | while read nr; do
>  	$XFS_IO_PROG -c "fpunch $((nr * blksz)) $blksz" $testdir/file1 >> $seqres.full
>  done
>  
> -echo "Create metadump file"
>  _scratch_unmount
> -_scratch_xfs_metadump $metadump_file
>  
> -# Now restore the obfuscated one back and take a look around
> -echo "Restore metadump"
> -SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> -SCRATCH_DEV=$TEST_DIR/image _scratch_mount
> -SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
> +max_md_version=1
> +_scratch_metadump_v2_supported && max_md_version=2
>  
> -echo "Check restored fs"
> -_check_generic_filesystem $metadump_file
> +echo "Create metadump file, restore it and check restored fs"
> +for md_version in $(seq 1 $max_md_version); do
> +	# Determine the version to be passed to metadump/mdrestore
> +	version=""
> +	if [[ $max_md_version == 2 ]]; then
> +		version="-v $md_version"
> +	fi
> +
> +	_scratch_xfs_metadump $metadump_file $version
> +
> +	# Now restore the obfuscated one back and take a look around
> +
> +	# Metadump v2 files can contain contents dumped from an external log
> +	# device. Use a temporary file to hold the log device contents restored
> +	# from such a metadump file.
> +	slogdev=$TEST_DIR/log-image
> +	if [[ -z $version || $version == "-v 1" || -z $SCRATCH_LOGDEV ]]; then
> +		slogdev=""
> +	fi
> +
> +	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
> +		   _scratch_xfs_mdrestore $metadump_file
> +
> +	datadev=$(_create_loop_device $TEST_DIR/data-image)
> +
> +	logdev=${SCRATCH_LOGDEV}
> +	if [[ -s $TEST_DIR/log-image ]]; then
> +		logdev=$(_create_loop_device $TEST_DIR/log-image)
> +	fi
> +
> +	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
> +	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
> +
> +	[[ -z $logdev ]] && logdev=none
> +	_check_xfs_filesystem $datadev $logdev none
> +
> +	if [[ -s $TEST_DIR/log-image ]]; then
> +		_destroy_loop_device $logdev
> +		logdev=""
> +		rm -f $TEST_DIR/log-image
> +	fi
> +
> +	_destroy_loop_device $datadev
> +	datadev=""
> +	rm -f $TEST_DIR/data-image
> +done
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/234.out b/tests/xfs/234.out
> index 463d4660..fc2ddd77 100644
> --- a/tests/xfs/234.out
> +++ b/tests/xfs/234.out
> @@ -1,6 +1,4 @@
>  QA output created by 234
>  Create the original file blocks
>  Punch every other block
> -Create metadump file
> -Restore metadump
> -Check restored fs
> +Create metadump file, restore it and check restored fs
> diff --git a/tests/xfs/253 b/tests/xfs/253
> index ce902477..b69a1faf 100755
> --- a/tests/xfs/253
> +++ b/tests/xfs/253
> @@ -52,114 +52,139 @@ function create_file() {
>  echo "Disciplyne of silence is goed."
>  
>  _scratch_mkfs >/dev/null 2>&1
> -_scratch_mount
>  
> -# Initialize and mount the scratch filesystem, then create a bunch
> -# of files that exercise the original problem.
> -#
> -# The problem arose when a file name produced a hash that contained
> -# either 0x00 (string terminator) or 0x27 ('/' character) in a
> -# spot used to determine a character in an obfuscated name.  This
> -# occurred in one of 5 spots at the end of the name, at position
> -# (last-4), (last-3), (last-2), (last-1), or (last).

I wonder, could you create the scratch fs and only then move into
testing v1 and v2 metadump?  Rather than doing the create_file stuff
twice?  Or do we actually end up with a different fs between the two
iterations?

The other two tests here look good enough for now...

--D

> +max_md_version=1
> +_scratch_metadump_v2_supported && max_md_version=2
>  
> -rm -f "${METADUMP_FILE}"
> +for md_version in $(seq 1 $max_md_version); do
> +	version=""
> +	if [[ $max_md_version == 2 ]]; then
> +		version="-v $md_version"
> +	fi
>  
> -mkdir -p "${OUTPUT_DIR}"
> +	cd $here
>  
> -cd "${OUTPUT_DIR}"
> -# Start out with some basic test files
> -create_file 'abcde'		# hash 0x1c58f263 ("normal" name)
> +	# Initialize and mount the scratch filesystem, then create a bunch of
> +	# files that exercise the original problem.
> +	#
> +	# The problem arose when a file name produced a hash that contained
> +	# either 0x00 (string terminator) or 0x27 ('/' character) in a spot used
> +	# to determine a character in an obfuscated name.  This occurred in one
> +	# of 5 spots at the end of the name, at position (last-4), (last-3),
> +	# (last-2), (last-1), or (last).
>  
> -create_file 'f'			# hash 0x00000066 (1-byte name)
> -create_file 'gh'		# hash 0x000033e8 (2-byte name)
> -create_file 'ijk'		# hash 0x001a756b (3-byte name)
> -create_file 'lmno'		# hash 0x0d9b776f (4-byte name)
> -create_file 'pqrstu'		# hash 0x1e5cf9f2 (6-byte name)
> -create_file 'abcdefghijklmnopqrstuvwxyz' # a most remarkable word (0x55004ae3)
> +	_scratch_unmount >> $seqres.full 2>&1
>  
> -# Create a short directory name; it won't be obfuscated.  Populate
> -# it with some longer named-files.  The first part of the obfuscated
> -# filenames should use printable characters.
> -mkdir foo
> -create_file 'foo/longer_file_name_1'	# hash 0xe83634ec
> -create_file 'foo/longer_file_name_2'	# hash 0xe83634ef
> -create_file 'foo/longer_file_name_3'	# hash 0xe83634ee
> +	_scratch_mkfs >> $seqres.full 2>&1
>  
> -# Now create a longer directory name
> -mkdir longer_directory_name
> -create_file 'longer_directory_name/f1'	# directory hash 0x9c7accdd
> -create_file 'longer_directory_name/f2'	# filenames are short, no hash
> -create_file 'longer_directory_name/f3'
> +	_scratch_mount
>  
> -# The problematic name originally reported by Arkadiusz Miśkiewicz
> +	rm -f "${METADUMP_FILE}"
>  
> -create_file 'R\323\257NE'	# hash 0x3a4be740, forces  (last-3) = 0x2f
> +	mkdir -p "${OUTPUT_DIR}"
>  
> -# Other names that force a 0x00 byte
> -create_file 'Pbcde'		# hash 0x0c58f260, forces  (last-4) = 0x00
> -create_file 'a\001\203de'	# hash 0x1000f263, forces  (last-3) = 0x00
> -create_file 'ab\001\344e'	# hash 0x1c403263, forces  (last-2) = 0x00
> -create_file 'abc\200e'		# hash 0x1c588063, forces  (last-1) = 0x00
> -create_file 'abcd\006'		# hash 0x1c58f200, forces    (last) = 0x00
> +	cd "${OUTPUT_DIR}"
> +	# Start out with some basic test files
> +	create_file 'abcde'		# hash 0x1c58f263 ("normal" name)
>  
> -# Names that force a 0x2f byte; note no name will ever force (last-4) = 0x2f
> -create_file 'a.\343de'		# hash 0x15f8f263 forces   (last-3) = 0x00
> -create_file 'ac\257de'		# hash 0x1c4bf263, forces  (last-2) = 0x2f
> -create_file 'abe\257e'		# hash 0x1c5917e3, forces  (last-1) = 0x2f
> -create_file 'abcd)'		# hash 0x1c58f22f, forces    (last) = 0x2f
> +	create_file 'f'			# hash 0x00000066 (1-byte name)
> +	create_file 'gh'		# hash 0x000033e8 (2-byte name)
> +	create_file 'ijk'		# hash 0x001a756b (3-byte name)
> +	create_file 'lmno'		# hash 0x0d9b776f (4-byte name)
> +	create_file 'pqrstu'		# hash 0x1e5cf9f2 (6-byte name)
> +	create_file 'abcdefghijklmnopqrstuvwxyz' # a most remarkable word (0x55004ae3)
>  
> -# The following names are possible results of obfuscating the name
> -# "abcde".  Previously, xfs_metadump could get hung up trying to
> -# obfuscate names when too many of the same length had the same hash
> -# value.
> -create_file '!bcda'		# essentially a dup of 'abcde'
> -create_file 'Abcdg'		# essentially a dup of 'abcde'
> -create_file 'qbcdd'		# essentially a dup of 'abcde'
> -create_file '1bcd`'		# essentially a dup of 'abcde'
> -create_file 'Qbcdf'		# essentially a dup of 'abcde'
> -create_file '\001bcdc'		# essentially a dup of 'abcde'
> -create_file 'Qbce\346'		# essentially a dup of 'abcde'
> -create_file 'abb\344e'		# essentially a dup of 'abcde'
> +	# Create a short directory name; it won't be obfuscated.  Populate it
> +	# with some longer named-files.  The first part of the obfuscated
> +	# filenames should use printable characters.
> +	mkdir foo
> +	create_file 'foo/longer_file_name_1'	# hash 0xe83634ec
> +	create_file 'foo/longer_file_name_2'	# hash 0xe83634ef
> +	create_file 'foo/longer_file_name_3'	# hash 0xe83634ee
>  
> -# The orphanage directory (lost+found) should not be obfuscated.
> -# Files thereunder can be, but not if their name is the same as
> -# their inode number.  Test this.
> +	# Now create a longer directory name
> +	mkdir longer_directory_name
> +	create_file 'longer_directory_name/f1'	# directory hash 0x9c7accdd
> +	create_file 'longer_directory_name/f2'	# filenames are short, no hash
> +	create_file 'longer_directory_name/f3'
>  
> -cd "${SCRATCH_MNT}"
> -mkdir -p "${ORPHANAGE}"
> +	# The problematic name originally reported by Arkadiusz Miśkiewicz
>  
> -TEMP_ORPHAN="${ORPHANAGE}/__orphan__"
> -NON_ORPHAN="${ORPHANAGE}/__should_be_obfuscated__"
> +	create_file 'R\323\257NE'	# hash 0x3a4be740, forces  (last-3) = 0x2f
>  
> -# Create an orphan, whose name is the same as its inode number
> -touch "${TEMP_ORPHAN}"
> -INUM=$(ls -i "${TEMP_ORPHAN}" | awk '{ print $1; }')
> -ORPHAN="${SCRATCH_MNT}/lost+found/${INUM}"
> -mv "${TEMP_ORPHAN}" "${ORPHAN}"
> +	# Other names that force a 0x00 byte
> +	create_file 'Pbcde'		# hash 0x0c58f260, forces  (last-4) = 0x00
> +	create_file 'a\001\203de'	# hash 0x1000f263, forces  (last-3) = 0x00
> +	create_file 'ab\001\344e'	# hash 0x1c403263, forces  (last-2) = 0x00
> +	create_file 'abc\200e'		# hash 0x1c588063, forces  (last-1) = 0x00
> +	create_file 'abcd\006'		# hash 0x1c58f200, forces    (last) = 0x00
>  
> -# Create non-orphan, which *should* be obfuscated
> -touch "${NON_ORPHAN}"
> +	# Names that force a 0x2f byte; note no name will ever force (last-4) = 0x2f
> +	create_file 'a.\343de'		# hash 0x15f8f263 forces   (last-3) = 0x00
> +	create_file 'ac\257de'		# hash 0x1c4bf263, forces  (last-2) = 0x2f
> +	create_file 'abe\257e'		# hash 0x1c5917e3, forces  (last-1) = 0x2f
> +	create_file 'abcd)'		# hash 0x1c58f22f, forces    (last) = 0x2f
>  
> -# Get a listing of all the files before obfuscation
> -ls -R >> $seqres.full
> -ls -R | od -c >> $seqres.full
> +	# The following names are possible results of obfuscating the name
> +	# "abcde".  Previously, xfs_metadump could get hung up trying to
> +	# obfuscate names when too many of the same length had the same hash
> +	# value.
> +	create_file '!bcda'		# essentially a dup of 'abcde'
> +	create_file 'Abcdg'		# essentially a dup of 'abcde'
> +	create_file 'qbcdd'		# essentially a dup of 'abcde'
> +	create_file '1bcd`'		# essentially a dup of 'abcde'
> +	create_file 'Qbcdf'		# essentially a dup of 'abcde'
> +	create_file '\001bcdc'		# essentially a dup of 'abcde'
> +	create_file 'Qbce\346'		# essentially a dup of 'abcde'
> +	create_file 'abb\344e'		# essentially a dup of 'abcde'
>  
> -# Now unmount the filesystem and create a metadump file
> -cd $here
> +	# The orphanage directory (lost+found) should not be obfuscated.
> +	# Files thereunder can be, but not if their name is the same as
> +	# their inode number.  Test this.
>  
> -_scratch_unmount
> -_scratch_xfs_metadump $METADUMP_FILE
> +	cd "${SCRATCH_MNT}"
> +	mkdir -p "${ORPHANAGE}"
>  
> -# Now restore the obfuscated one back and take a look around
> -_scratch_xfs_mdrestore "$METADUMP_FILE"
> +	TEMP_ORPHAN="${ORPHANAGE}/__orphan__"
> +	NON_ORPHAN="${ORPHANAGE}/__should_be_obfuscated__"
>  
> -_scratch_mount
> +	# Create an orphan, whose name is the same as its inode number
> +	touch "${TEMP_ORPHAN}"
> +	INUM=$(ls -i "${TEMP_ORPHAN}" | awk '{ print $1; }')
> +	ORPHAN="${SCRATCH_MNT}/lost+found/${INUM}"
> +	mv "${TEMP_ORPHAN}" "${ORPHAN}"
>  
> -# Get a listing of all the files after obfuscation
> -cd ${SCRATCH_MNT}
> -ls -R >> $seqres.full
> -ls -R | od -c >> $seqres.full
> +	# Create non-orphan, which *should* be obfuscated
> +	touch "${NON_ORPHAN}"
> +
> +	# Get a listing of all the files before obfuscation
> +	ls -R >> $seqres.full
> +	ls -R | od -c >> $seqres.full
> +
> +	# Now unmount the filesystem and create a metadump file
> +	cd $here
> +
> +	_scratch_unmount
> +	
> +	_scratch_xfs_metadump $METADUMP_FILE $version
> +
> +	# Now restore the obfuscated one back and take a look around
> +
> +	slogdev=$SCRATCH_LOGDEV
> +	if [[ -z $version || $version == "-v 1" ]]; then
> +		slogdev=""
> +	fi
> +
> +	SCRATCH_LOGDEV=${slogdev} _scratch_xfs_mdrestore "$METADUMP_FILE"
> +
> +	_scratch_mount
> +
> +	cd "${SCRATCH_MNT}"
> +
> +	# Get a listing of all the files after obfuscation
> +	ls -R >> $seqres.full
> +	ls -R | od -c >> $seqres.full
> +done
>  
>  # Finally, re-make the filesystem since to ensure we don't
>  # leave a directory with duplicate entries lying around.
> diff --git a/tests/xfs/291 b/tests/xfs/291
> index 54448497..33193eb7 100755
> --- a/tests/xfs/291
> +++ b/tests/xfs/291
> @@ -92,10 +92,27 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
>  
>  # Yes they can!  Now...
>  # Can xfs_metadump cope with this monster?
> -_scratch_xfs_metadump $tmp.metadump -a -o || _fail "xfs_metadump failed"
> -SCRATCH_DEV=$tmp.img _scratch_xfs_mdrestore $tmp.metadump || _fail "xfs_mdrestore failed"
> -SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \
> -	_fail "xfs_repair of metadump failed"
> +max_md_version=1
> +_scratch_metadump_v2_supported && max_md_version=2
> +
> +for md_version in $(seq 1 $max_md_version); do
> +	version=""
> +	if [[ $max_md_version == 2 ]]; then
> +		version="-v $md_version"
> +	fi
> +
> +	_scratch_xfs_metadump $tmp.metadump -a -o $version || \
> +		_fail "xfs_metadump failed"
> +
> +	slogdev=$SCRATCH_LOGDEV
> +	if [[ -z $version || $version == "-v 1" ]]; then
> +		slogdev=""
> +	fi
> +	SCRATCH_DEV=$tmp.img SCRATCH_LOGDEV=$slogdev _scratch_xfs_mdrestore \
> +		   $tmp.metadump || _fail "xfs_mdrestore failed"
> +	SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \
> +		_fail "xfs_repair of metadump failed"
> +done
>  
>  # Yes it can; success, all done
>  status=0
> diff --git a/tests/xfs/432 b/tests/xfs/432
> index dae68fb2..a215d3ce 100755
> --- a/tests/xfs/432
> +++ b/tests/xfs/432
> @@ -50,6 +50,7 @@ echo "Format and mount"
>  # block.  8187 hashes/dablk / 248 dirents/dirblock = ~33 dirblocks per
>  # dablock.  33 dirblocks * 64k mean that we can expand a directory by
>  # 2112k before we have to allocate another da btree block.
> +
>  _scratch_mkfs -b size=1k -n size=64k > "$seqres.full" 2>&1
>  _scratch_mount >> "$seqres.full" 2>&1
>  
> @@ -85,13 +86,29 @@ extlen="$(check_for_long_extent $dir_inum)"
>  echo "qualifying extent: $extlen blocks" >> $seqres.full
>  test -n "$extlen" || _notrun "could not create dir extent > 1000 blocks"
>  
> -echo "Try to metadump"
> -_scratch_xfs_metadump $metadump_file -a -o -w
> -SCRATCH_DEV=$metadump_img _scratch_xfs_mdrestore $metadump_file
> +echo "Try to metadump, restore and check restored metadump image"
> +max_md_version=1
> +_scratch_metadump_v2_supported && max_md_version=2
>  
> -echo "Check restored metadump image"
> -SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
> -	echo "xfs_repair on restored fs returned $?"
> +for md_version in $(seq 1 $max_md_version); do
> +	version=""
> +	if [[ $max_md_version == 2 ]]; then
> +		version="-v $md_version"
> +	fi
> +
> +	_scratch_xfs_metadump $metadump_file -a -o -w $version
> +
> +	slogdev=$SCRATCH_LOGDEV
> +	if [[ -z $version || $version == "-v 1" ]]; then
> +		slogdev=""
> +	fi
> +
> +	SCRATCH_DEV=$metadump_img SCRATCH_LOGDEV=$slogdev \
> +		   _scratch_xfs_mdrestore $metadump_file
> +
> +	SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
> +		echo "xfs_repair on restored fs returned $?"
> +done
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/432.out b/tests/xfs/432.out
> index 1f135d16..37bac902 100644
> --- a/tests/xfs/432.out
> +++ b/tests/xfs/432.out
> @@ -2,5 +2,4 @@ QA output created by 432
>  Format and mount
>  Create huge dir
>  Check for > 1000 block extent?
> -Try to metadump
> -Check restored metadump image
> +Try to metadump, restore and check restored metadump image
> diff --git a/tests/xfs/503 b/tests/xfs/503
> index 8805632d..a1479eb6 100755
> --- a/tests/xfs/503
> +++ b/tests/xfs/503
> @@ -29,6 +29,7 @@ testdir=$TEST_DIR/test-$seq
>  _supported_fs xfs
>  
>  _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
> +_require_loop
>  _require_xfs_copy
>  _require_scratch_nocheck
>  _require_populate_commands
> @@ -40,22 +41,69 @@ _scratch_populate_cached nofill > $seqres.full 2>&1
>  
>  mkdir -p $testdir
>  metadump_file=$testdir/scratch.md
> -metadump_file_a=${metadump_file}.a
> -metadump_file_g=${metadump_file}.g
> -metadump_file_ag=${metadump_file}.ag
>  copy_file=$testdir/copy.img
>  
> -echo metadump
> -_scratch_xfs_metadump $metadump_file -a -o >> $seqres.full
> +check_restored_metadump_image()
> +{
> +	local image=$1
>  
> -echo metadump a
> -_scratch_xfs_metadump $metadump_file_a -a >> $seqres.full
> +	loop_dev=$(_create_loop_device $image)
> +	SCRATCH_DEV=$loop_dev _scratch_mount
> +	SCRATCH_DEV=$loop_dev _check_scratch_fs
> +	SCRATCH_DEV=$loop_dev _scratch_unmount
> +	_destroy_loop_device $loop_dev
> +}
>  
> -echo metadump g
> -_scratch_xfs_metadump $metadump_file_g -g >> $seqres.full
> +max_md_version=1
> +_scratch_metadump_v2_supported && max_md_version=2
>  
> -echo metadump ag
> -_scratch_xfs_metadump $metadump_file_ag -a -g >> $seqres.full
> +echo "metadump and mdrestore"
> +for md_version in $(seq 1 $max_md_version); do
> +	version=""
> +	if [[ $max_md_version == 2 ]]; then
> +		version="-v $md_version"
> +	fi
> +
> +	_scratch_xfs_metadump $metadump_file -a -o $version >> $seqres.full
> +	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> +	check_restored_metadump_image $TEST_DIR/image
> +done
> +
> +echo "metadump a and mdrestore"
> +for md_version in $(seq 1 $max_md_version); do
> +	version=""
> +	if [[ $max_md_version == 2 ]]; then
> +		version="-v $md_version"
> +	fi
> +
> +	_scratch_xfs_metadump $metadump_file -a $version >> $seqres.full
> +	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> +	check_restored_metadump_image $TEST_DIR/image
> +done
> +
> +echo "metadump g and mdrestore"
> +for md_version in $(seq 1 $max_md_version); do
> +	version=""
> +	if [[ $max_md_version == 2 ]]; then
> +		version="-v $md_version"
> +	fi
> +
> +	_scratch_xfs_metadump $metadump_file -g $version >> $seqres.full
> +	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> +	check_restored_metadump_image $TEST_DIR/image
> +done
> +
> +echo "metadump ag and mdrestore"
> +for md_version in $(seq 1 $max_md_version); do
> +	version=""
> +	if [[ $max_md_version == 2 ]]; then
> +		version="-v $md_version"
> +	fi
> +
> +	_scratch_xfs_metadump $metadump_file -a -g $version >> $seqres.full
> +	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> +	check_restored_metadump_image $TEST_DIR/image
> +done
>  
>  echo copy
>  $XFS_COPY_PROG $SCRATCH_DEV $copy_file >> $seqres.full
> @@ -67,30 +115,6 @@ _scratch_mount
>  _check_scratch_fs
>  _scratch_unmount
>  
> -echo mdrestore
> -_scratch_xfs_mdrestore $metadump_file
> -_scratch_mount
> -_check_scratch_fs
> -_scratch_unmount
> -
> -echo mdrestore a
> -_scratch_xfs_mdrestore $metadump_file_a
> -_scratch_mount
> -_check_scratch_fs
> -_scratch_unmount
> -
> -echo mdrestore g
> -_scratch_xfs_mdrestore $metadump_file_g
> -_scratch_mount
> -_check_scratch_fs
> -_scratch_unmount
> -
> -echo mdrestore ag
> -_scratch_xfs_mdrestore $metadump_file_ag
> -_scratch_mount
> -_check_scratch_fs
> -_scratch_unmount
> -
>  # success, all done
>  status=0
>  exit
> diff --git a/tests/xfs/503.out b/tests/xfs/503.out
> index 8ef31dbe..496f2516 100644
> --- a/tests/xfs/503.out
> +++ b/tests/xfs/503.out
> @@ -1,12 +1,8 @@
>  QA output created by 503
>  Format and populate
> -metadump
> -metadump a
> -metadump g
> -metadump ag
> +metadump and mdrestore
> +metadump a and mdrestore
> +metadump g and mdrestore
> +metadump ag and mdrestore
>  copy
>  recopy
> -mdrestore
> -mdrestore a
> -mdrestore g
> -mdrestore ag
> -- 
> 2.43.0
> 
> 
