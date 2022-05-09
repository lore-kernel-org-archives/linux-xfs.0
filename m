Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8878BC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 18:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240219AbiEISj0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 May 2022 14:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240255AbiEISjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 May 2022 14:39:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A733248E2D;
        Mon,  9 May 2022 11:35:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0F6261628;
        Mon,  9 May 2022 18:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F5EC385B2;
        Mon,  9 May 2022 18:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652121327;
        bh=0pWndvc3+Hynb0vkklHt/VVvt3X2GswvlEf7JmTxcxw=;
        h=From:To:Cc:Subject:Date:From;
        b=sMQGM1YwFrK1VTOU6FcXSrZbhtvTn4HAZbCZa0vNNxhMF5S0LpBPzf7fVkMiatX1b
         tetto+u9OU2cfg7DXyHzCm/qg5x4o9zLm/SHnr/8X9zo2/CBpvHhpeW5T5uWYN/bR+
         q4psE+0z7VmDoTBL+HXaExy+8Sajhem1i9sE5YGP1S85g0APXjClpi5iN5M/xoIR04
         qUhZbEaZHM5mW5AjWnJsPxTj5bHNGMjmO05j//425dXosbIljZkF1hqVwjbboGpls0
         q1aAC7LjigSzx/J68YWGl39W5mxzH4KjeQDCy8t3cjLkTczeAE+9RkaZ3ur1nvcG+H
         LSvOjevQXwtaA==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] generic: soft quota limits testing within grace time
Date:   Tue, 10 May 2022 02:35:23 +0800
Message-Id: <20220509183523.1809778-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After soft limits are exceeded, within the grace time, fs quota
should allow more space allocation before exceeding hard limits,
even if allocating many small files.

This case can cover bc37e4fb5cac (xfs: revert "xfs: actually bump
warning counts when we send warnings"). And will help to expose
later behavior changes on this side.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Thanks review points from Darrick, V2 move _create_project_quota and
_restore_project_quota to common/quota and help them to be common.

Thanks,
Zorro

 common/quota          | 48 +++++++++++++++++++++++
 tests/generic/999     | 88 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  2 +
 3 files changed, 138 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/common/quota b/common/quota
index 7fa1a61a..67698f74 100644
--- a/common/quota
+++ b/common/quota
@@ -351,5 +351,53 @@ _qsetup()
 	echo "Using type=$type id=$id" >> $seqres.full
 }
 
+# Help to create project quota on directory, works for xfs and other fs.
+# Usage: _create_project_quota <dirname> <projid> [name]
+# Although the [name] is optional, better to specify it if need a fixed name.
+_create_project_quota()
+{
+	local prjdir=$1
+	local id=$2
+	local name=$3
+
+	if [ -z "$name" ];then
+		name=`echo $projdir | tr \/ \_`
+	fi
+
+	rm -rf $prjdir
+	mkdir $prjdir
+	chmod ugo+rwx $prjdir
+
+	if [ -f /etc/projects -a ! -f $tmp.projects.bk ];then
+		cat /etc/projects > $tmp.projects.bk
+		echo >/etc/projects
+	fi
+	if [ -f /etc/projid -a ! -f $tmp.projid.bk ];then
+		cat /etc/projid > $tmp.projid.bk
+		echo >/etc/projid
+	fi
+
+	cat >>/etc/projects <<EOF
+$id:$prjdir
+EOF
+	cat >>/etc/projid <<EOF
+$name:$id
+EOF
+	$XFS_IO_PROG -r -c "chproj $id" -c "chattr +P" $prjdir
+}
+
+# If you've called _create_project_quota, then use this function in _cleanup
+_restore_project_quota()
+{
+	if [ -f $tmp.projects.bk ];then
+		cat $tmp.projects.bk > /etc/projects && \
+			rm -f $tmp.projects.bk
+	fi
+	if [ -f $tmp.projid.bk ];then
+		cat $tmp.projid.bk > /etc/projid && \
+			rm -f $tmp.projid.bk
+	fi
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..103a74f9
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,88 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test No. 999
+#
+# Make sure filesystem quota works well, after soft limits are exceeded. The
+# fs quota should allow more space allocation before exceeding hard limits
+# and with in grace time.
+#
+# But different with other similar testing, this case trys to write many small
+# files, to cover bc37e4fb5cac (xfs: revert "xfs: actually bump warning counts
+# when we send warnings"). If there's a behavior change in one day, this case
+# might help to detect that too.
+#
+. ./common/preamble
+_begin_fstest auto quota
+
+# Override the default cleanup function.
+_cleanup()
+{
+	_restore_project_quota
+	cd /
+	rm -r -f $tmp.*
+}
+
+# Import common functions.
+. ./common/quota
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch
+_require_quota
+_require_user
+_require_group
+
+# Make sure the kernel supports project quota
+_scratch_mkfs >$seqres.full 2>&1
+_scratch_enable_pquota
+_qmount_option "prjquota"
+_qmount
+_require_prjquota $SCRATCH_DEV
+
+exercise()
+{
+	local type=$1
+	local file=$SCRATCH_MNT/testfile
+
+	echo "= Test type=$type quota =" >>$seqres.full
+	_scratch_unmount
+	_scratch_mkfs >>$seqres.full 2>&1
+	if [ "$1" = "P" ];then
+		_scratch_enable_pquota
+	fi
+	_qmount
+	if [ "$1" = "P" ];then
+		_create_project_quota $SCRATCH_MNT/t 100 $qa_user
+		file=$SCRATCH_MNT/t/testfile
+	fi
+
+	setquota -${type} $qa_user 1M 500M 0 0 $SCRATCH_MNT
+	setquota -${type} -t 86400 86400 $SCRATCH_MNT
+	repquota -v -${type} $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
+	# Exceed the soft quota limit a bit at first
+	su $qa_user -c "$XFS_IO_PROG -f -t -c 'pwrite 0 2m' -c fsync ${file}.0" >>$seqres.full 2>&1
+	# Write more data more times under soft quota limit exhausted condition,
+	# but not reach hard limit. To make sure the it won't trigger EDQUOT.
+	for ((i=1; i<=100; i++));do
+		su "$qa_user" -c "$XFS_IO_PROG -f -c 'pwrite 0 1m' -c fsync ${file}.$i" >>$seqres.full 2>&1
+		if [ $? -ne 0 ];then
+			echo "Unexpected error (type=$type)!"
+			break
+		fi
+	done
+	repquota -v -${type} $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
+}
+
+_qmount_option "usrquota"
+exercise u
+_qmount_option "grpquota"
+exercise g
+_qmount_option "prjquota"
+exercise P
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..3b276ca8
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
-- 
2.31.1

