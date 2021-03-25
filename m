Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D767C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 16:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EF23619D3
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 16:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhCYQgb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 12:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229865AbhCYQg0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 12:36:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C15961A25;
        Thu, 25 Mar 2021 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616690185;
        bh=LRJ/coR4LOQq4Wz8BOHOENl2WGEBly/iDD8lS+E45BU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YC/11cjNP/9PQa17QAU9WMac84ppJxVhrBMh4esF+SmsM1bzvSOKwtWLm01lz7A+x
         1A36tvoxDVO93a/NnN52/rG2QiikwsVYjD9CKGpbYcSUgmYkYta85z6vVsbkmKkf0E
         m9eUtXSDovQGcfOjAmB/3xm5hfgE/9zz0fOOleU9Dvu9BS9HYvxmTg8DOpZOoC8BsO
         lIvDrCj03kU7lgSLSxym3o7bq+cJ6D3tkxCkE0VL1yJGiAXoSsFtQyKs5lyfVPimQ6
         FsFYFa5GiGDj9O7u7ZI86XvZyylXnoRw0xyYo47j51wYE5Hpf9jjdX0oh+HBtAJ+IB
         VMealCUp2vY+g==
Date:   Thu, 25 Mar 2021 09:36:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        chandanrlinux@gmail.com
Subject: [PATCH v1.1 2/2] xfs: test the xfs_db ls command
Message-ID: <20210325163625.GI4090233@magnolia>
References: <161647321880.3430916.13415014495565709258.stgit@magnolia>
 <161647322983.3430916.9402200604814364098.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161647322983.3430916.9402200604814364098.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that the xfs_db ls command works the way the author thinks it
does.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.1: fix word usage
---
 tests/xfs/918     |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/918.out |   27 +++++++++++++
 tests/xfs/group   |    1 
 3 files changed, 135 insertions(+)
 create mode 100755 tests/xfs/918
 create mode 100644 tests/xfs/918.out

diff --git a/tests/xfs/918 b/tests/xfs/918
new file mode 100755
index 00000000..68b6bdd1
--- /dev/null
+++ b/tests/xfs/918
@@ -0,0 +1,107 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 918
+#
+# Make sure the xfs_db ls command works the way the author thinks it does.
+# This means that we can list the current directory, list an arbitrary path,
+# and we can't list things that aren't directories.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_db_command "path"
+_require_xfs_db_command "ls"
+_require_scratch
+
+echo "Format filesystem and populate"
+_scratch_mkfs > $seqres.full
+_scratch_mount >> $seqres.full
+
+$XFS_INFO_PROG $SCRATCH_MNT | grep -q ftype=1 || \
+	_notrun "filesystem does not support ftype"
+
+filter_ls() {
+	awk '
+BEGIN { cookie = 0; }
+{
+	if (cookie == 0)
+		cookie = $1;
+	printf("+%d %s %s %s %s %s\n", $1 - cookie, $2, $3, $4, $5, $6);
+	cookie = $1;
+}' | \
+	sed	-e "s/ $root_ino directory / root directory /g" \
+		-e "s/ $a_ino directory / a_ino directory /g" \
+		-e "s/ $b_ino directory / b_ino directory /g" \
+		-e "s/ $c_ino regular / c_ino regular /g" \
+		-e "s/ $d_ino symlink / d_ino symlink /g" \
+		-e "s/ $e_ino blkdev / e_ino blkdev /g" \
+		-e "s/ $f_ino chardev / f_ino chardev /g" \
+		-e "s/ $g_ino fifo / g_ino fifo /g" \
+		-e "s/ $big0_ino regular / big0_ino regular /g" \
+		-e "s/ $big1_ino regular / big1_ino regular /g" \
+		-e "s/ $h_ino regular / g_ino regular /g"
+}
+
+mkdir $SCRATCH_MNT/a
+mkdir $SCRATCH_MNT/a/b
+$XFS_IO_PROG -f -c 'pwrite 0 61' $SCRATCH_MNT/a/c >> $seqres.full
+ln -s -f b $SCRATCH_MNT/a/d
+mknod $SCRATCH_MNT/a/e b 0 0
+mknod $SCRATCH_MNT/a/f c 0 0
+mknod $SCRATCH_MNT/a/g p
+touch $SCRATCH_MNT/a/averylongnameforadirectorysothatwecanpushthecookieforward
+touch $SCRATCH_MNT/a/andmakethefirstcolumnlookmoreinterestingtopeoplelolwtfbbq
+touch $SCRATCH_MNT/a/h
+
+root_ino=$(stat -c '%i' $SCRATCH_MNT)
+a_ino=$(stat -c '%i' $SCRATCH_MNT/a)
+b_ino=$(stat -c '%i' $SCRATCH_MNT/a/b)
+c_ino=$(stat -c '%i' $SCRATCH_MNT/a/c)
+d_ino=$(stat -c '%i' $SCRATCH_MNT/a/d)
+e_ino=$(stat -c '%i' $SCRATCH_MNT/a/e)
+f_ino=$(stat -c '%i' $SCRATCH_MNT/a/f)
+g_ino=$(stat -c '%i' $SCRATCH_MNT/a/g)
+big0_ino=$(stat -c '%i' $SCRATCH_MNT/a/avery*)
+big1_ino=$(stat -c '%i' $SCRATCH_MNT/a/andma*)
+h_ino=$(stat -c '%i' $SCRATCH_MNT/a/h)
+
+_scratch_unmount
+
+echo "Manually navigate to root dir then list"
+_scratch_xfs_db -c 'sb 0' -c 'addr rootino' -c ls | filter_ls
+
+echo "Use path to navigate to root dir then list"
+_scratch_xfs_db -c 'path /' -c ls | filter_ls
+
+echo "Use path to navigate to /a then list"
+_scratch_xfs_db -c 'path /a' -c ls | filter_ls
+
+echo "Use path to navigate to /a/b then list"
+_scratch_xfs_db -c 'path /a/b' -c ls | filter_ls
+
+echo "Use path to navigate to /a/c (non-dir) then list"
+_scratch_xfs_db -c 'path /a/c' -c ls
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/918.out b/tests/xfs/918.out
new file mode 100644
index 00000000..62d43c8a
--- /dev/null
+++ b/tests/xfs/918.out
@@ -0,0 +1,27 @@
+QA output created by 918
+Format filesystem and populate
+Manually navigate to root dir then list
++0 root directory 0x0000002e 1 .
++2 root directory 0x0000172e 2 ..
++2 a_ino directory 0x00000061 1 a
+Use path to navigate to root dir then list
++0 root directory 0x0000002e 1 .
++2 root directory 0x0000172e 2 ..
++2 a_ino directory 0x00000061 1 a
+Use path to navigate to /a then list
++0 a_ino directory 0x0000002e 1 .
++2 root directory 0x0000172e 2 ..
++2 b_ino directory 0x00000062 1 b
++2 c_ino regular 0x00000063 1 c
++2 d_ino symlink 0x00000064 1 d
++2 e_ino blkdev 0x00000065 1 e
++2 f_ino chardev 0x00000066 1 f
++2 g_ino fifo 0x00000067 1 g
++2 big0_ino regular 0xc7457cba 57 averylongnameforadirectorysothatwecanpushthecookieforward
++9 big1_ino regular 0xeefd9237 57 andmakethefirstcolumnlookmoreinterestingtopeoplelolwtfbbq
++9 g_ino regular 0x00000068 1 h
+Use path to navigate to /a/b then list
++0 b_ino directory 0x0000002e 1 .
++2 a_ino directory 0x0000172e 2 ..
+Use path to navigate to /a/c (non-dir) then list
+Not a directory
diff --git a/tests/xfs/group b/tests/xfs/group
index daa56787..45628739 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -518,3 +518,4 @@
 759 auto quick rw realtime
 760 auto quick rw realtime collapse insert unshare zero prealloc
 917 auto quick db
+918 auto quick db
