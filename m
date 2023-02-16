Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47610C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjBPVPa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBPVP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:15:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A393B864;
        Thu, 16 Feb 2023 13:15:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D3F1CE2D79;
        Thu, 16 Feb 2023 21:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835C6C433D2;
        Thu, 16 Feb 2023 21:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582124;
        bh=9WA2T9MlmqzVirMIvwjnlNM5oEQJRMZvYxnvGXeFvUo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=G70JYI7DszdJ7KsHwwPi2Dj2t3+/vLA8Ue5sjYvrx43t0GH8cFq8IU9nUCpMVlFxT
         gcnseXAH/ElvqMYtqm65enKathdFgzGJ/2KiftLsBANRieWGu9+0QJE9fag+kwgid5
         /FQVg/zqeLDYPQh9cHQyE1Y5e9fhWoXtx0xJXt26DdsgXXUUk4SUn7RItsWaTPf7gy
         /6CfhNVQ6K7k9RrHVx39cvfLF9ApjPPgMROdjagDiT3JOw5SP3ozt0wG5ElHaTqf0q
         Ari0GIyHRoCd9CG2RQy3NqSs5E5Iagw/jl/qqA5AmX0X8S0iWtRwYY7Ot8xwZOYmbm
         9JM5utSnv7TZg==
Date:   Thu, 16 Feb 2023 13:15:24 -0800
Subject: [PATCH 07/14] common: add helpers for parent pointer tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884579.3481377.17737344610252798639.stgit@magnolia>
In-Reply-To: <167657884480.3481377.14824439551809919632.stgit@magnolia>
References: <167657884480.3481377.14824439551809919632.stgit@magnolia>
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
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/parent |  198 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc     |    3 +
 common/xfs    |   12 +++
 3 files changed, 213 insertions(+)
 create mode 100644 common/parent


diff --git a/common/parent b/common/parent
new file mode 100644
index 0000000000..a0ba7d927a
--- /dev/null
+++ b/common/parent
@@ -0,0 +1,198 @@
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
+		_fail "$SCRATCH_MNT/$parent_path not found"
+	else
+		echo "*** $parent_path OK"
+	fi
+
+	# Verify child exists
+	if [ ! -f $SCRATCH_MNT/$child_path ]; then
+		_fail "$SCRATCH_MNT/$child_path not found"
+	else
+		echo "*** $child_path OK"
+	fi
+
+	# Verify the parent pointer name exists as a child of the parent
+	if [ ! -f $SCRATCH_MNT/$parent_ppath ]; then
+		_fail "$SCRATCH_MNT/$parent_ppath not found"
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
+		 _fail "No parent pointers found for $child_path"
+	fi
+
+	# Parse parent pointer output.
+	# This sets PPINO PPGEN PPNAME PPNAME_LEN
+	_parse_parent_pointer $parents $pino $parent_pointer_name
+
+	# If we didnt find one, bail out
+	if [ $? -ne 0 ]; then
+		_fail "No parent pointer record found for $parent_path"\
+			"in $child_path"
+	fi
+
+	# Verify the inode generated by the parent pointer name is
+	# the same as the child inode
+	pppino="$(stat -c '%i' $SCRATCH_MNT/$parent_ppath)"
+	if [ $cino -ne $pppino ]
+	then
+		_fail "Bad parent pointer name value for $child_path."\
+			"$SCRATCH_MNT/$parent_ppath belongs to inode $PPPINO,"\
+			"but should be $cino"
+	fi
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
+		_fail "$SCRATCH_MNT/$child_path not found"
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
+	_fail "Parent pointer entry found where none should:"\
+			"inode:$PPINO, gen:$PPGEN,"
+			"name:$PPNAME, namelen:$PPNAME_LEN"
+}
diff --git a/common/rc b/common/rc
index 00800c43b4..d3edbb78c4 100644
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
index 0ea9d3826e..32406c0fe5 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2091,3 +2091,15 @@ _scratch_find_rt_metadir_entry() {
 		grep "${sfkey}.inumber" | awk '{print $1}'
 	return 0
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

