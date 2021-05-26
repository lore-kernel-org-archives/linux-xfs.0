Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7B7C4707F
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF8C961090
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbhEZBss (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 21:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhEZBsq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 21:48:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C77AF61090;
        Wed, 26 May 2021 01:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621993635;
        bh=YxZ3UdgOFhFjOUS6g/N/oKYCImh181sx6R6/zbGWfT0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hba7fq7Urc379Pgfh0ZjX19g79bKfJbsjSoqeTUrwljlwiunGlNgDqETd07IArxI4
         LG227yrEOkKTVctisYyZ9bQ4gV/HsiTyR4bPbkeyQMG5SjsNuzxLm58bB6AqUuNyZB
         89ThPjoiATIUMUlbk24JNWND+XYN0nhxM8lKXSmonYoxgZ4iawTYlfpmI25omsLNwK
         0Cx6BW8X7IxOXzadalY4ZsNaGRAbMPKnAMlgweUV8kX+X4+v2l99fn4icm4xNjKrPx
         ktyFq42RlrQsVbhdm/hiH4Nh9Z1BCJ9dhzfTc3xM7WGFcZJ2PkuNuOXn2iopY2lU1k
         qmclxY7IP9hlA==
Subject: [PATCH 06/10] fstests: automatically generate group files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 May 2021 18:47:15 -0700
Message-ID: <162199363553.3744214.2202153763471757013.stgit@locust>
In-Reply-To: <162199360248.3744214.17042613373014687643.stgit@locust>
References: <162199360248.3744214.17042613373014687643.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've moved the group membership details into the test case
files themselves, automatically generate the group files during build.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/test_names      |    6 ++++++
 include/buildrules     |    6 ++++++
 tests/Makefile         |    4 ++++
 tests/btrfs/Makefile   |    3 +++
 tests/ceph/Makefile    |    3 +++
 tests/cifs/Makefile    |    3 +++
 tests/ext4/Makefile    |    3 +++
 tests/f2fs/Makefile    |    3 +++
 tests/generic/Makefile |    3 +++
 tests/nfs/Makefile     |    3 +++
 tests/ocfs2/Makefile   |    3 +++
 tests/overlay/Makefile |    3 +++
 tests/perf/Makefile    |    3 +++
 tests/shared/Makefile  |    3 +++
 tests/udf/Makefile     |    3 +++
 tests/xfs/Makefile     |    3 +++
 tools/mkgroupfile      |   37 +++++++++++++++++++++++++++++++++++++
 17 files changed, 92 insertions(+)
 create mode 100755 tools/mkgroupfile


diff --git a/common/test_names b/common/test_names
index 3b0b889a..841f617e 100644
--- a/common/test_names
+++ b/common/test_names
@@ -16,6 +16,12 @@ VALID_TEST_NAME="$VALID_TEST_ID-\?[[:alnum:]-]*"
 _set_seq_and_groups()
 {
 	seq=`basename $0`
+
+	if [ -n "$GENERATE_GROUPS" ]; then
+		echo "$seq $@"
+		exit 0
+	fi
+
 	seqres=$RESULT_DIR/$seq
 	echo "QA output created by $seq"
 
diff --git a/include/buildrules b/include/buildrules
index bf187662..6a3165fc 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -132,3 +132,9 @@ FILTER = $(basename $(EXTFILTER4) $(BASIC_OUTFILES))
 # finally, select the test files by filtering against against the
 # stripped output files and sort them to remove duplicates.
 TESTS = $(sort $(filter $(ALLFILES), $(FILTER)))
+
+.PHONY: group
+
+group:
+	@echo " [GROUP] $$PWD/$@"
+	$(Q)$(TOPDIR)/tools/mkgroupfile $@
diff --git a/tests/Makefile b/tests/Makefile
index 8ce8f209..5c8f0b10 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -7,6 +7,10 @@ include $(TOPDIR)/include/builddefs
 
 TESTS_SUBDIRS = $(sort $(dir $(wildcard $(CURDIR)/[[:lower:]]*/)))
 
+SUBDIRS = $(wildcard [[:lower:]]*)
+
+default: $(SUBDIRS)
+
 include $(BUILDRULES)
 
 install: $(addsuffix -install,$(TESTS_SUBDIRS))
diff --git a/tests/btrfs/Makefile b/tests/btrfs/Makefile
index 2d936421..8b74c9f1 100644
--- a/tests/btrfs/Makefile
+++ b/tests/btrfs/Makefile
@@ -7,6 +7,9 @@ include $(TOPDIR)/include/builddefs
 
 BTRFS_DIR = btrfs
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(BTRFS_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/ceph/Makefile b/tests/ceph/Makefile
index 55e35d77..775e9e8c 100644
--- a/tests/ceph/Makefile
+++ b/tests/ceph/Makefile
@@ -5,6 +5,9 @@ include $(TOPDIR)/include/builddefs
 
 CEPH_DIR = ceph
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(CEPH_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/cifs/Makefile b/tests/cifs/Makefile
index 0c5cf3be..491d4502 100644
--- a/tests/cifs/Makefile
+++ b/tests/cifs/Makefile
@@ -7,6 +7,9 @@ include $(TOPDIR)/include/builddefs
 
 CIFS_DIR = cifs
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(CIFS_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/ext4/Makefile b/tests/ext4/Makefile
index beb1541f..7e9a6a34 100644
--- a/tests/ext4/Makefile
+++ b/tests/ext4/Makefile
@@ -7,6 +7,9 @@ include $(TOPDIR)/include/builddefs
 
 EXT4_DIR = ext4
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(EXT4_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/f2fs/Makefile b/tests/f2fs/Makefile
index d13bca3f..53f95065 100644
--- a/tests/f2fs/Makefile
+++ b/tests/f2fs/Makefile
@@ -8,6 +8,9 @@ include $(TOPDIR)/include/builddefs
 
 F2FS_DIR = f2fs
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(F2FS_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/generic/Makefile b/tests/generic/Makefile
index 3878d05c..3eaada13 100644
--- a/tests/generic/Makefile
+++ b/tests/generic/Makefile
@@ -7,6 +7,9 @@ include $(TOPDIR)/include/builddefs
 
 GENERIC_DIR = generic
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(GENERIC_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/nfs/Makefile b/tests/nfs/Makefile
index 754f2b25..80a2906c 100644
--- a/tests/nfs/Makefile
+++ b/tests/nfs/Makefile
@@ -7,6 +7,9 @@ include $(TOPDIR)/include/builddefs
 
 NFS_DIR = nfs
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(NFS_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/ocfs2/Makefile b/tests/ocfs2/Makefile
index e1337908..6a550362 100644
--- a/tests/ocfs2/Makefile
+++ b/tests/ocfs2/Makefile
@@ -7,6 +7,9 @@ include $(TOPDIR)/include/builddefs
 
 OCFS2_DIR = ocfs2
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(OCFS2_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/overlay/Makefile b/tests/overlay/Makefile
index b07f8925..1c593a10 100644
--- a/tests/overlay/Makefile
+++ b/tests/overlay/Makefile
@@ -7,6 +7,9 @@ include $(TOPDIR)/include/builddefs
 
 TEST_DIR = overlay
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(TEST_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/perf/Makefile b/tests/perf/Makefile
index 620f1dbf..766de244 100644
--- a/tests/perf/Makefile
+++ b/tests/perf/Makefile
@@ -7,6 +7,9 @@ include $(TOPDIR)/include/builddefs
 
 PERF_DIR = perf
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(PERF_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/shared/Makefile b/tests/shared/Makefile
index 8a832782..6b0d5a39 100644
--- a/tests/shared/Makefile
+++ b/tests/shared/Makefile
@@ -7,6 +7,9 @@ include $(TOPDIR)/include/builddefs
 
 SHARED_DIR = shared
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(SHARED_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/udf/Makefile b/tests/udf/Makefile
index c9c9f1bd..84231c57 100644
--- a/tests/udf/Makefile
+++ b/tests/udf/Makefile
@@ -7,6 +7,9 @@ include $(TOPDIR)/include/builddefs
 
 UDF_DIR = udf
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(UDF_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/xfs/Makefile b/tests/xfs/Makefile
index d64800ea..55eccb5f 100644
--- a/tests/xfs/Makefile
+++ b/tests/xfs/Makefile
@@ -7,6 +7,9 @@ include $(TOPDIR)/include/builddefs
 
 XFS_DIR = xfs
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(XFS_DIR)
+DIRT = group
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tools/mkgroupfile b/tools/mkgroupfile
new file mode 100755
index 00000000..0b541146
--- /dev/null
+++ b/tools/mkgroupfile
@@ -0,0 +1,37 @@
+#!/bin/bash
+
+# Generate a group file from the _set_test_seqnum call in each test.
+
+if [ "$1" = "--help" ]; then
+	echo "Usage: (cd tests/XXX/ ; ../../tools/mkgroupfile [output])"
+	exit 1
+fi
+
+test_dir="$PWD"
+groupfile="$1"
+
+generate_groupfile() {
+	cat << ENDL
+# QA groups control file, automatically generated.
+# See _set_seq_and_groups in each test for details.
+
+ENDL
+	cd ../../
+	export GENERATE_GROUPS=yes
+	grep -R -l "^_set_seq_and_groups" "$test_dir/" 2>/dev/null | while read testfile; do
+		test -x "$testfile" && "$testfile"
+	done | sort -g
+	cd "$test_dir"
+}
+
+if [ -z "$groupfile" ] || [ "$groupfile" = "-" ]; then
+	# Dump the group file to stdout and exit
+	generate_groupfile
+	exit 0
+fi
+
+# Otherwise, write the group file to disk somewhere.
+ngroupfile="${groupfile}.new"
+rm -f "$ngroupfile"
+generate_groupfile >> "$ngroupfile"
+mv "$ngroupfile" "$groupfile"

