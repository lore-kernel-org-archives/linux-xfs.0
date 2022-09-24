Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001CFC07E9D
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Sep 2022 00:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiIXAty (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 20:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiIXAtw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 20:49:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F8325C5A;
        Fri, 23 Sep 2022 17:49:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEB7AB815B4;
        Sat, 24 Sep 2022 00:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B0BC433C1;
        Sat, 24 Sep 2022 00:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663980586;
        bh=w3ncYbAZVqVmZUaZ2xMVsQOw6b3krBG1QnRzmI5mIYo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uNqVMMJ83laaT00mv0LsrlCiCPGSTjPi1zLg2s344BEcuUyzxGE41v+3h7uHrjB+S
         KkWmTvmDq026qoNBqv72RED2dOwJE1lFHBHNdEhXoKWMsjkdSXhTrp6871R40qhIbs
         Jq5HQ0PmurFyZ9RxkyxJVmKY+dmt0xL9dSwwfNyVIb6lLlbmrzYv8hwl4HsBDSMu6b
         +WD9kqJGQYvN68anJwOTh6ByIvrBpse51NK6cufEVV9pWq70UmZ3qhtjCHRon9Hkn5
         U1S45s4fppL8krM4FYUSlmEEc5UbfNzyBZCu2W//uG8SrgSd0Lzv5Bvgub7sSN9g2L
         6TFwV0yVi3ZUA==
Date:   Fri, 23 Sep 2022 17:49:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1 1/1] xfstests: Add parent pointer test
Message-ID: <Yy5UKf1SxzszOCYw@magnolia>
References: <20220614220129.20847-1-catherine.hoang@oracle.com>
 <20220614220129.20847-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614220129.20847-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 14, 2022 at 03:01:29PM -0700, Catherine Hoang wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds a test for basic parent pointer operations,
> including link, unlink, rename, overwrite, hardlinks and
> error inject.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/parent       |  196 +++++++++
>  common/rc           |    3 +
>  doc/group-names.txt |    1 +
>  tests/xfs/547       |  126 ++++++
>  tests/xfs/547.out   |   59 +++
>  tests/xfs/548       |   97 +++++
>  tests/xfs/548.out   | 1002 +++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/549       |  110 +++++
>  tests/xfs/549.out   |   14 +
>  9 files changed, 1608 insertions(+)
>  create mode 100644 common/parent
>  create mode 100755 tests/xfs/547
>  create mode 100644 tests/xfs/547.out
>  create mode 100755 tests/xfs/548
>  create mode 100644 tests/xfs/548.out
>  create mode 100755 tests/xfs/549
>  create mode 100644 tests/xfs/549.out
> 
> diff --git a/common/parent b/common/parent
> new file mode 100644
> index 00000000..0af12553
> --- /dev/null
> +++ b/common/parent
> @@ -0,0 +1,196 @@
> +#
> +# Parent pointer common functions
> +#
> +
> +#
> +# parse_parent_pointer parents parent_inode parent_pointer_name
> +#
> +# Given a list of parent pointers, find the record that matches
> +# the given inode and filename
> +#
> +# inputs:
> +# parents	: A list of parent pointers in the format of:
> +#		  inode/generation/name_length/name
> +# parent_inode	: The parent inode to search for
> +# parent_name	: The parent name to search for
> +#
> +# outputs:
> +# PPINO         : Parent pointer inode
> +# PPGEN         : Parent pointer generation
> +# PPNAME        : Parent pointer name
> +# PPNAME_LEN    : Parent pointer name length
> +#
> +_parse_parent_pointer()
> +{
> +	local parents=$1
> +	local pino=$2
> +	local parent_pointer_name=$3
> +
> +	local found=0
> +
> +	# Find the entry that has the same inode as the parent
> +	# and parse out the entry info
> +	while IFS=\/ read PPINO PPGEN PPNAME_LEN PPNAME; do
> +		if [ "$PPINO" != "$pino" ]; then
> +			continue
> +		fi
> +
> +		if [ "$PPNAME" != "$parent_pointer_name" ]; then
> +			continue
> +		fi
> +
> +		found=1
> +		break
> +	done <<< $(echo "$parents")
> +
> +	# Check to see if we found anything
> +	# We do not fail the test because we also use this
> +	# routine to verify when parent pointers should
> +	# be removed or updated  (ie a rename or a move
> +	# operation changes your parent pointer)
> +	if [ $found -eq "0" ]; then
> +		return 1
> +	fi
> +
> +	# Verify the parent pointer name length is correct
> +	if [ "$PPNAME_LEN" -ne "${#parent_pointer_name}" ]
> +	then
> +		_fail "Bad parent pointer reclen"

Do you really want to _fail the whole test immediately?  Or simply let
the golden output comparison mark the test failed because there's
unexpected output from "echo 'bad parent pointer reclen'" ?

> +	fi
> +
> +	#return sucess
> +	return 0
> +}
> +
> +#
> +# _verify_parent parent_path parent_pointer_name child_path
> +#
> +# Verify that the given child path lists the given parent as a parent pointer
> +# and that the parent pointer name matches the given name
> +#
> +# Examples:
> +#
> +# #simple example
> +# mkdir testfolder1
> +# touch testfolder1/file1
> +# verify_parent testfolder1 file1 testfolder1/file1
> +#
> +# # In this above example, we want to verify that "testfolder1"
> +# # appears as a parent pointer of "testfolder1/file1".  Additionally
> +# # we verify that the name record of the parent pointer is "file1"
> +#
> +#
> +# #hardlink example
> +# mkdir testfolder1
> +# mkdir testfolder2
> +# touch testfolder1/file1
> +# ln testfolder1/file1 testfolder2/file1_ln
> +# verify_parent testfolder2 file1_ln testfolder1/file1
> +#
> +# # In this above example, we want to verify that "testfolder2"
> +# # appears as a parent pointer of "testfolder1/file1".  Additionally
> +# # we verify that the name record of the parent pointer is "file1_ln"
> +#
> +_verify_parent()
> +{
> +
> +	local parent_path=$1
> +	local parent_pointer_name=$2
> +	local child_path=$3
> +
> +	local parent_ppath="$parent_path/$parent_pointer_name"
> +
> +	# Verify parent exists
> +	if [ ! -d $SCRATCH_MNT/$parent_path ]; then
> +		_fail "$SCRATCH_MNT/$parent_path not found"
> +	else
> +		echo "*** $parent_path OK"
> +	fi
> +
> +	# Verify child exists
> +	if [ ! -f $SCRATCH_MNT/$child_path ]; then
> +		_fail "$SCRATCH_MNT/$child_path not found"
> +	else
> +		echo "*** $child_path OK"
> +	fi
> +
> +	# Verify the parent pointer name exists as a child of the parent
> +	if [ ! -f $SCRATCH_MNT/$parent_ppath ]; then
> +		_fail "$SCRATCH_MNT/$parent_ppath not found"
> +	else
> +		echo "*** $parent_ppath OK"
> +	fi
> +
> +	# Get the inodes of both parent and child
> +	pino="$(stat -c '%i' $SCRATCH_MNT/$parent_path)"
> +	cino="$(stat -c '%i' $SCRATCH_MNT/$child_path)"
> +
> +	# Get all the parent pointers of the child
> +	parents=($($XFS_IO_PROG -x -c "parent -f -i $pino -n $parent_pointer_name" $SCRATCH_MNT/$child_path))
> +	if [[ $? != 0 ]]; then
> +		 _fail "No parent pointers found for $child_path"
> +	fi
> +
> +	# Parse parent pointer output.
> +	# This sets PPINO PPGEN PPNAME PPNAME_LEN
> +	_parse_parent_pointer $parents $pino $parent_pointer_name
> +
> +	# If we didnt find one, bail out
> +	if [ $? -ne 0 ]; then
> +		_fail "No parent pointer record found for $parent_path in $child_path"
> +	fi
> +
> +	# Verify the inode generated by the parent pointer name is
> +	# the same as the child inode
> +	pppino="$(stat -c '%i' $SCRATCH_MNT/$parent_ppath)"
> +	if [ $cino -ne $pppino ]
> +	then
> +		_fail "Bad parent pointer name value for $child_path."\
> +				"$SCRATCH_MNT/$parent_ppath belongs to inode $PPPINO, but should be $cino"
> +	fi
> +
> +	echo "*** Verified parent pointer:"\
> +			"name:$PPNAME, namelen:$PPNAME_LEN"
> +	echo "*** Parent pointer OK for child $child_path"
> +}
> +
> +#
> +# _verify_parent parent_pointer_name pino child_path
> +#
> +# Verify that the given child path contains no parent pointer entry
> +# for the given inode and file name
> +#
> +_verify_no_parent()
> +{
> +
> +	local parent_pname=$1
> +	local pino=$2
> +	local child_path=$3
> +
> +	# Verify child exists
> +	if [ ! -f $SCRATCH_MNT/$child_path ]; then
> +		_fail "$SCRATCH_MNT/$child_path not found"
> +	else
> +		echo "*** $child_path OK"
> +	fi
> +
> +	# Get all the parent pointers of the child
> +	local parents=($($XFS_IO_PROG -x -c "parent -f -i $pino -n $parent_pname" $SCRATCH_MNT/$child_path))
> +	if [[ $? != 0 ]]; then
> +		return 0
> +	fi
> +
> +	# Parse parent pointer output.
> +	# This sets PPINO PPGEN PPNAME PPNAME_LEN
> +	_parse_parent_pointer $parents $pino $parent_pname
> +
> +	# If we didnt find one, return sucess
> +	if [ $? -ne 0 ]; then
> +		return 0
> +	fi
> +
> +	_fail "Parent pointer entry found where none should:"\
> +			"inode:$PPINO, gen:$PPGEN,"
> +			"name:$PPNAME, namelen:$PPNAME_LEN"
> +}
> +
> diff --git a/common/rc b/common/rc
> index 4201a059..68752cdc 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2701,6 +2701,9 @@ _require_xfs_io_command()
>  		echo $testio | grep -q "invalid option" && \
>  			_notrun "xfs_io $command support is missing"
>  		;;
> +	"parent")
> +		testio=`$XFS_IO_PROG -x -c "parent" $TEST_DIR 2>&1`
> +		;;
>  	"pwrite")
>  		# -N (RWF_NOWAIT) only works with direct vectored I/O writes
>  		local pwrite_opts=" "
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index e8e3477e..98bbe3b7 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -77,6 +77,7 @@ nfs4_acl		NFSv4 access control lists
>  nonsamefs		overlayfs layers on different filesystems
>  online_repair		online repair functionality tests
>  other			dumping ground, do not add more tests to this group
> +parent			Parent pointer tests
>  pattern			specific IO pattern tests
>  perms			access control and permission checking
>  pipe			pipe functionality
> diff --git a/tests/xfs/547 b/tests/xfs/547
> new file mode 100755
> index 00000000..5c7d1d45
> --- /dev/null
> +++ b/tests/xfs/547
> @@ -0,0 +1,126 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test 547
> +#
> +# simple parent pointer test
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick parent
> +
> +cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	echo 0 > /sys/fs/xfs/debug/larp
> +}
> +
> +full()
> +{
> +    echo ""            >>$seqres.full
> +    echo "*** $* ***"  >>$seqres.full
> +    echo ""            >>$seqres.full
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/filter
> +. ./common/reflink
> +. ./common/inject
> +. ./common/parent
> +
> +# Modify as appropriate
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_sysfs debug/larp
> +_require_xfs_io_error_injection "larp"
> +
> +echo 1 > /sys/fs/xfs/debug/larp

Doesn't the parent pointer code turn on LARP mode automatically?
Why does the test need to do that explicitly?

> +
> +# real QA test starts here
> +
> +# Create a directory tree using a protofile and
> +# make sure all inodes created have parent pointers
> +
> +protofile=$tmp.proto
> +
> +cat >$protofile <<EOF
> +DUMMY1
> +0 0
> +: root directory
> +d--777 3 1
> +: a directory
> +testfolder1 d--755 3 1
> +file1 ---755 3 1 /dev/null
> +$
> +: back in the root
> +testfolder2 d--755 3 1
> +file2 ---755 3 1 /dev/null
> +: done
> +$
> +EOF
> +
> +if [ $? -ne 0 ]
> +then
> +    _fail "failed to create test protofile"
> +fi
> +
> +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
> +	|| _fail "mkfs failed"
> +_check_scratch_fs
> +
> +_scratch_mount >>$seqres.full 2>&1 \
> +	|| _fail "mount failed"
> +
> +testfolder1="testfolder1"
> +testfolder2="testfolder2"
> +file1="file1"
> +file2="file2"
> +file3="file3"
> +file4="file4"
> +file5="file5"
> +file1_ln="file1_link"
> +
> +echo ""
> +# Create parent pointer test
> +_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1"
> +
> +echo ""
> +# Move parent pointer test
> +mv $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder2/$file1
> +_verify_parent "$testfolder2" "$file1" "$testfolder2/$file1"
> +
> +echo ""
> +# Hard link parent pointer test
> +ln $SCRATCH_MNT/$testfolder2/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln
> +_verify_parent "$testfolder1" "$file1_ln"  "$testfolder1/$file1_ln"
> +_verify_parent "$testfolder1" "$file1_ln"  "$testfolder2/$file1"
> +_verify_parent "$testfolder2" "$file1"     "$testfolder1/$file1_ln"
> +_verify_parent "$testfolder2" "$file1"     "$testfolder2/$file1"
> +
> +echo ""
> +# Remove hard link parent pointer test
> +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file1)"
> +rm $SCRATCH_MNT/$testfolder2/$file1
> +_verify_parent    "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
> +_verify_no_parent "$file1" "$ino" "$testfolder1/$file1_ln"
> +
> +echo ""
> +# Rename parent pointer test
> +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln)"
> +mv $SCRATCH_MNT/$testfolder1/$file1_ln $SCRATCH_MNT/$testfolder1/$file2
> +_verify_parent    "$testfolder1" "$file2"    "$testfolder1/$file2"
> +_verify_no_parent "$file1_ln" "$ino" "$testfolder1/$file2"
> +
> +echo ""
> +# Over write parent pointer test
> +touch $SCRATCH_MNT/$testfolder2/$file3
> +_verify_parent    "$testfolder2" "$file3"    "$testfolder2/$file3"
> +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file3)"
> +mv -f $SCRATCH_MNT/$testfolder2/$file3 $SCRATCH_MNT/$testfolder1/$file2
> +_verify_parent    "$testfolder1" "$file2"    "$testfolder1/$file2"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/547.out b/tests/xfs/547.out
> new file mode 100644
> index 00000000..e0ce9e65
> --- /dev/null
> +++ b/tests/xfs/547.out
> @@ -0,0 +1,59 @@
> +QA output created by 547
> +
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1
> +
> +*** testfolder2 OK
> +*** testfolder2/file1 OK
> +*** testfolder2/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder2/file1
> +
> +*** testfolder1 OK
> +*** testfolder1/file1_link OK
> +*** testfolder1/file1_link OK
> +*** Verified parent pointer: name:file1_link, namelen:10
> +*** Parent pointer OK for child testfolder1/file1_link
> +*** testfolder1 OK
> +*** testfolder2/file1 OK
> +*** testfolder1/file1_link OK
> +*** Verified parent pointer: name:file1_link, namelen:10
> +*** Parent pointer OK for child testfolder2/file1
> +*** testfolder2 OK
> +*** testfolder1/file1_link OK
> +*** testfolder2/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link
> +*** testfolder2 OK
> +*** testfolder2/file1 OK
> +*** testfolder2/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder2/file1
> +
> +*** testfolder1 OK
> +*** testfolder1/file1_link OK
> +*** testfolder1/file1_link OK
> +*** Verified parent pointer: name:file1_link, namelen:10
> +*** Parent pointer OK for child testfolder1/file1_link
> +*** testfolder1/file1_link OK
> +
> +*** testfolder1 OK
> +*** testfolder1/file2 OK
> +*** testfolder1/file2 OK
> +*** Verified parent pointer: name:file2, namelen:5
> +*** Parent pointer OK for child testfolder1/file2
> +*** testfolder1/file2 OK
> +
> +*** testfolder2 OK
> +*** testfolder2/file3 OK
> +*** testfolder2/file3 OK
> +*** Verified parent pointer: name:file3, namelen:5
> +*** Parent pointer OK for child testfolder2/file3
> +*** testfolder1 OK
> +*** testfolder1/file2 OK
> +*** testfolder1/file2 OK
> +*** Verified parent pointer: name:file2, namelen:5
> +*** Parent pointer OK for child testfolder1/file2
> diff --git a/tests/xfs/548 b/tests/xfs/548
> new file mode 100755
> index 00000000..229d871a
> --- /dev/null
> +++ b/tests/xfs/548
> @@ -0,0 +1,97 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test 548
> +#
> +# multi link parent pointer test
> +#
> +. ./common/preamble
> +_begin_fstest auto quick parent
> +
> +cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	echo 0 > /sys/fs/xfs/debug/larp
> +}
> +
> +full()
> +{
> +    echo ""            >>$seqres.full
> +    echo "*** $* ***"  >>$seqres.full
> +    echo ""            >>$seqres.full
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/filter
> +. ./common/reflink
> +. ./common/inject
> +. ./common/parent
> +
> +# Modify as appropriate
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_io_error_injection "larp"
> +_require_xfs_sysfs debug/larp
> +
> +echo 1 > /sys/fs/xfs/debug/larp
> +
> +# real QA test starts here
> +
> +# Create a directory tree using a protofile and
> +# make sure all inodes created have parent pointers
> +
> +protofile=$tmp.proto
> +
> +cat >$protofile <<EOF
> +DUMMY1
> +0 0
> +: root directory
> +d--777 3 1
> +: a directory
> +testfolder1 d--755 3 1
> +file1 ---755 3 1 /dev/null
> +: done
> +$
> +EOF
> +
> +if [ $? -ne 0 ]
> +then
> +    _fail "failed to create test protofile"
> +fi
> +
> +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqresres.full 2>&1 \
> +	|| _fail "mkfs failed"
> +_check_scratch_fs
> +
> +_scratch_mount >>$seqres.full 2>&1 \
> +	|| _fail "mount failed"
> +
> +testfolder1="testfolder1"
> +testfolder2="testfolder2"
> +file1="file1"
> +file2="file2"
> +file3="file3"
> +file4="file4"
> +file5="file5"
> +file1_ln="file1_link"
> +
> +echo ""
> +# Multi link parent pointer test
> +NLINKS=100
> +for (( j=0; j<$NLINKS; j++ )); do
> +	ln $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln.$j
> +	_verify_parent    "$testfolder1" "$file1_ln.$j"    "$testfolder1/$file1"
> +	_verify_parent    "$testfolder1" "$file1"          "$testfolder1/$file1_ln.$j"
> +done
> +# Multi unlink parent pointer test
> +for (( j=$NLINKS-1; j<=0; j-- )); do
> +	ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln.$j)"
> +	rm $SCRATCH_MNT/$testfolder1/$file1_ln.$j
> +	_verify_no_parent "$file1_ln.$j" "$ino" "$testfolder1/$file1"
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/548.out b/tests/xfs/548.out
> new file mode 100644
> index 00000000..afdc083b
> --- /dev/null
> +++ b/tests/xfs/548.out
> @@ -0,0 +1,1002 @@
> +QA output created by 548
> +
> +*** testfolder1 OK

<snip>

> +*** testfolder1 OK
> +*** testfolder1/file1_link.99 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.99
> diff --git a/tests/xfs/549 b/tests/xfs/549
> new file mode 100755
> index 00000000..e8e74b8a
> --- /dev/null
> +++ b/tests/xfs/549
> @@ -0,0 +1,110 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test 549
> +#
> +# parent pointer inject test
> +#
> +. ./common/preamble
> +_begin_fstest auto quick parent
> +
> +cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	echo 0 > /sys/fs/xfs/debug/larp
> +}
> +
> +full()
> +{
> +    echo ""            >>$seqres.full
> +    echo "*** $* ***"  >>$seqres.full
> +    echo ""            >>$seqres.full
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/filter
> +. ./common/reflink
> +. ./common/inject
> +. ./common/parent
> +
> +# Modify as appropriate
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_sysfs debug/larp
> +_require_xfs_io_error_injection "larp"
> +
> +echo 1 > /sys/fs/xfs/debug/larp
> +
> +# real QA test starts here
> +
> +# Create a directory tree using a protofile and
> +# make sure all inodes created have parent pointers

Looks like we're testing the error injection knobs too?

--D

> +
> +protofile=$tmp.proto
> +
> +cat >$protofile <<EOF
> +DUMMY1
> +0 0
> +: root directory
> +d--777 3 1
> +: a directory
> +testfolder1 d--755 3 1
> +file1 ---755 3 1 /dev/null
> +$
> +: back in the root
> +testfolder2 d--755 3 1
> +file2 ---755 3 1 /dev/null
> +: done
> +$
> +EOF
> +
> +if [ $? -ne 0 ]
> +then
> +    _fail "failed to create test protofile"
> +fi
> +
> +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
> +	|| _fail "mkfs failed"
> +_check_scratch_fs
> +
> +_scratch_mount >>$seqres.full 2>&1 \
> +	|| _fail "mount failed"
> +
> +testfolder1="testfolder1"
> +testfolder2="testfolder2"
> +file1="file1"
> +file2="file2"
> +file3="file3"
> +file4="file4"
> +file5="file5"
> +file1_ln="file1_link"
> +
> +echo ""
> +
> +# Create files
> +touch $SCRATCH_MNT/$testfolder1/$file4
> +_verify_parent    "$testfolder1" "$file4" "$testfolder1/$file4"
> +
> +# Inject error
> +_scratch_inject_error "larp"
> +
> +# Move files
> +mv $SCRATCH_MNT/$testfolder1/$file4 $SCRATCH_MNT/$testfolder2/$file5 2>&1 | _filter_scratch
> +
> +# FS should be shut down, touch will fail
> +touch $SCRATCH_MNT/$testfolder2/$file5 2>&1 | _filter_scratch
> +
> +# Remount to replay log
> +_scratch_remount_dump_log >> $seqres.full
> +
> +# FS should be online, touch should succeed
> +touch $SCRATCH_MNT/$testfolder2/$file5
> +
> +# Check files again
> +_verify_parent    "$testfolder2" "$file5" "$testfolder2/$file5"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/549.out b/tests/xfs/549.out
> new file mode 100644
> index 00000000..1af49c73
> --- /dev/null
> +++ b/tests/xfs/549.out
> @@ -0,0 +1,14 @@
> +QA output created by 549
> +
> +*** testfolder1 OK
> +*** testfolder1/file4 OK
> +*** testfolder1/file4 OK
> +*** Verified parent pointer: name:file4, namelen:5
> +*** Parent pointer OK for child testfolder1/file4
> +mv: cannot stat 'SCRATCH_MNT/testfolder1/file4': Input/output error
> +touch: cannot touch 'SCRATCH_MNT/testfolder2/file5': Input/output error
> +*** testfolder2 OK
> +*** testfolder2/file5 OK
> +*** testfolder2/file5 OK
> +*** Verified parent pointer: name:file5, namelen:5
> +*** Parent pointer OK for child testfolder2/file5
> -- 
> 2.25.1
> 
