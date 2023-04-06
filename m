Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE75C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbjDFToM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237498AbjDFToA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:44:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A5B93D8;
        Thu,  6 Apr 2023 12:43:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C73B60DED;
        Thu,  6 Apr 2023 19:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD48BC433EF;
        Thu,  6 Apr 2023 19:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810227;
        bh=YZuAiuQtSGRay462zIFX/RE+9F3tb6MnfWNw9MQhfWU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=d3E9oYr7xwAnN44LmRlAHGyb2X8/Llh7qcCSVhcty8+AdCeWgpXtCLezwv6gA6aqp
         JcsH59zY53ZhJ2E4WrTo/tGps4GcKzkFhfswreLe6DisZnGk75ssj6GZSJhcHkZjRb
         XWhNSVQvGP0Mctb/x4SFi2hmsztFP7g1ZX3SxUoY9oP9FeU58XSzg++n4Nm0+3lAYm
         qLB271jAl1Qk73rtmcoCNob6Rj6lxf6jI/S9QSTt+JAcWwlyvK/PP5I+IP342Qzi1M
         yY8lJdAKxXS2jabag7WIflMOZo3705M1c3OmryeNTwOSTKsGzzy3q1PnC4X5AelUqA
         ml8E+FZHeqpiA==
Date:   Thu, 06 Apr 2023 12:43:47 -0700
Subject: [PATCH 08/11] common: add helpers for parent pointer tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <168080829112.618488.6039839555651751713.stgit@frogsfrogsfrogs>
In-Reply-To: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
References: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add helper functions in common/parent to parse and verify parent
pointers. Also add functions to check that mkfs, kernel, and xfs_io
support parent pointers.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: add license and copyright, dont _fail tests immediately, make
 sure the pptr-generated paths match the dir-generated paths]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/parent |  209 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc     |    3 +
 common/xfs    |   12 +++
 3 files changed, 224 insertions(+)
 create mode 100644 common/parent


diff --git a/common/parent b/common/parent
new file mode 100644
index 0000000000..f849e4b27c
--- /dev/null
+++ b/common/parent
@@ -0,0 +1,209 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2023, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# Parent pointer common functions
+#
+
+#
+# parse_parent_pointer parents parent_inode parent_pointer_name
+#
+# Given a list of parent pointers, find the record that matches
+# the given inode and filename
+#
+# inputs:
+# parents	: A list of parent pointers in the format of:
+#		  inode/generation/name_length/name
+# parent_inode	: The parent inode to search for
+# parent_name	: The parent name to search for
+#
+# outputs:
+# PPINO         : Parent pointer inode
+# PPGEN         : Parent pointer generation
+# PPNAME        : Parent pointer name
+# PPNAME_LEN    : Parent pointer name length
+#
+_parse_parent_pointer()
+{
+	local parents=$1
+	local pino=$2
+	local parent_pointer_name=$3
+
+	local found=0
+
+	# Find the entry that has the same inode as the parent
+	# and parse out the entry info
+	while IFS=\/ read PPINO PPGEN PPNAME_LEN PPNAME; do
+		if [ "$PPINO" != "$pino" ]; then
+			continue
+		fi
+
+		if [ "$PPNAME" != "$parent_pointer_name" ]; then
+			continue
+		fi
+
+		found=1
+		break
+	done <<< $(echo "$parents")
+
+	# Check to see if we found anything
+	# We do not fail the test because we also use this
+	# routine to verify when parent pointers should
+	# be removed or updated  (ie a rename or a move
+	# operation changes your parent pointer)
+	if [ $found -eq "0" ]; then
+		return 1
+	fi
+
+	# Verify the parent pointer name length is correct
+	if [ "$PPNAME_LEN" -ne "${#parent_pointer_name}" ]
+	then
+		echo "*** Bad parent pointer:"\
+			"name:$PPNAME, namelen:$PPNAME_LEN"
+	fi
+
+	#return sucess
+	return 0
+}
+
+#
+# _verify_parent parent_path parent_pointer_name child_path
+#
+# Verify that the given child path lists the given parent as a parent pointer
+# and that the parent pointer name matches the given name
+#
+# Examples:
+#
+# #simple example
+# mkdir testfolder1
+# touch testfolder1/file1
+# verify_parent testfolder1 file1 testfolder1/file1
+#
+# # In this above example, we want to verify that "testfolder1"
+# # appears as a parent pointer of "testfolder1/file1".  Additionally
+# # we verify that the name record of the parent pointer is "file1"
+#
+#
+# #hardlink example
+# mkdir testfolder1
+# mkdir testfolder2
+# touch testfolder1/file1
+# ln testfolder1/file1 testfolder2/file1_ln
+# verify_parent testfolder2 file1_ln testfolder1/file1
+#
+# # In this above example, we want to verify that "testfolder2"
+# # appears as a parent pointer of "testfolder1/file1".  Additionally
+# # we verify that the name record of the parent pointer is "file1_ln"
+#
+_verify_parent()
+{
+	local parent_path=$1
+	local parent_pointer_name=$2
+	local child_path=$3
+
+	local parent_ppath="$parent_path/$parent_pointer_name"
+
+	# Verify parent exists
+	if [ ! -d $SCRATCH_MNT/$parent_path ]; then
+		echo "$SCRATCH_MNT/$parent_path not found"
+	else
+		echo "*** $parent_path OK"
+	fi
+
+	# Verify child exists
+	if [ ! -f $SCRATCH_MNT/$child_path ]; then
+		echo "$SCRATCH_MNT/$child_path not found"
+	else
+		echo "*** $child_path OK"
+	fi
+
+	# Verify the parent pointer name exists as a child of the parent
+	if [ ! -f $SCRATCH_MNT/$parent_ppath ]; then
+		echo "$SCRATCH_MNT/$parent_ppath not found"
+	else
+		echo "*** $parent_ppath OK"
+	fi
+
+	# Get the inodes of both parent and child
+	pino="$(stat -c '%i' $SCRATCH_MNT/$parent_path)"
+	cino="$(stat -c '%i' $SCRATCH_MNT/$child_path)"
+
+	# Get all the parent pointers of the child
+	parents=($($XFS_IO_PROG -x -c \
+	 "parent -f -i $pino -n $parent_pointer_name" $SCRATCH_MNT/$child_path))
+	if [[ $? != 0 ]]; then
+		 echo "No parent pointers found for $child_path"
+	fi
+
+	# Parse parent pointer output.
+	# This sets PPINO PPGEN PPNAME PPNAME_LEN
+	_parse_parent_pointer $parents $pino $parent_pointer_name
+
+	# If we didnt find one, bail out
+	if [ $? -ne 0 ]; then
+		echo "No parent pointer record found for $parent_path"\
+			"in $child_path"
+	fi
+
+	# Verify the inode generated by the parent pointer name is
+	# the same as the child inode
+	pppino="$(stat -c '%i' $SCRATCH_MNT/$parent_ppath)"
+	if [ $cino -ne $pppino ]
+	then
+		echo "Bad parent pointer name value for $child_path."\
+			"$SCRATCH_MNT/$parent_ppath belongs to inode $PPPINO,"\
+			"but should be $cino"
+	fi
+
+	# Make sure path printing works by checking that the paths returned
+	# all point to the same inode.
+	local tgt="$SCRATCH_MNT/$child_path"
+	$XFS_IO_PROG -x -c 'parent -p' "$tgt" | while read pptr_path; do
+		test "$tgt" -ef "$pptr_path" || \
+			echo "$tgt parent pointer $pptr_path should be the same file"
+	done
+
+	echo "*** Verified parent pointer:"\
+			"name:$PPNAME, namelen:$PPNAME_LEN"
+	echo "*** Parent pointer OK for child $child_path"
+}
+
+#
+# _verify_parent parent_pointer_name pino child_path
+#
+# Verify that the given child path contains no parent pointer entry
+# for the given inode and file name
+#
+_verify_no_parent()
+{
+	local parent_pname=$1
+	local pino=$2
+	local child_path=$3
+
+	# Verify child exists
+	if [ ! -f $SCRATCH_MNT/$child_path ]; then
+		echo "$SCRATCH_MNT/$child_path not found"
+	else
+		echo "*** $child_path OK"
+	fi
+
+	# Get all the parent pointers of the child
+	local parents=($($XFS_IO_PROG -x -c \
+	 "parent -f -i $pino -n $parent_pname" $SCRATCH_MNT/$child_path))
+	if [[ $? != 0 ]]; then
+		return 0
+	fi
+
+	# Parse parent pointer output.
+	# This sets PPINO PPGEN PPNAME PPNAME_LEN
+	_parse_parent_pointer $parents $pino $parent_pname
+
+	# If we didnt find one, return sucess
+	if [ $? -ne 0 ]; then
+		return 0
+	fi
+
+	echo "Parent pointer entry found where none should:"\
+			"inode:$PPINO, gen:$PPGEN,"
+			"name:$PPNAME, namelen:$PPNAME_LEN"
+}
diff --git a/common/rc b/common/rc
index a7e7d1f25b..bf53d62aac 100644
--- a/common/rc
+++ b/common/rc
@@ -2565,6 +2565,9 @@ _require_xfs_io_command()
 		echo $testio | grep -q "invalid option" && \
 			_notrun "xfs_io $command support is missing"
 		;;
+	"parent")
+		testio=`$XFS_IO_PROG -x -c "parent" $TEST_DIR 2>&1`
+		;;
 	"pwrite")
 		# -N (RWF_NOWAIT) only works with direct vectored I/O writes
 		local pwrite_opts=" "
diff --git a/common/xfs b/common/xfs
index b211c7a6d8..81ac143374 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1791,3 +1791,15 @@ _xfs_discard_max_offset_kb()
 	$XFS_IO_PROG -c 'statfs' "$1" | \
 		awk '{g[$1] = $3} END {print (g["geom.bsize"] * g["geom.datablocks"] / 1024)}'
 }
+
+# this test requires the xfs parent pointers feature
+#
+_require_xfs_parent()
+{
+	_scratch_mkfs_xfs_supported -n parent > /dev/null 2>&1 \
+		|| _notrun "mkfs.xfs does not support parent pointers"
+	_scratch_mkfs_xfs -n parent > /dev/null 2>&1
+	_try_scratch_mount >/dev/null 2>&1 \
+		|| _notrun "kernel does not support parent pointers"
+	_scratch_unmount
+}

