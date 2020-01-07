Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948B0C33C9E
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 16:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B5FE214D8
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 16:52:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nReyFPFO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgAGQw7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 11:52:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51446 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728215AbgAGQw6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 11:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uX1cNfoUjlP7M1M+NyKWUF0XVUS6WmFcz58xFnZiu+o=; b=nReyFPFO+7l9lq7HCOa9MYg8F
        33QXE6lEJbd/nG/7YgY3uf/cLcFTDuXIhY1b9Zypsk+5s4zmtM4qW0590htEUmvu7jswaJt+6U3Vm
        xWbCVvmdHztZrbp2BBeYzr/Ix5+tslCbpE9PbSs3M/C9tinRwsmKSYuAgQS3GtpCCe2rX95ua+3dH
        iao8W30ZcF6JJHnAfOTNK9VsR9k5wbIYhWPW9vwW/UqGRli8Qm18BM3STBcscKyad8sDzfKfJJmPw
        tKLGEjpGRzt+9Fymf/+hh0OhKtyqt2984PBmZeXX8UM6PPDrb1X/1VqhSIB5f03lOma7nWKDASp3q
        JnfLZlPIQ==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ios6E-00028K-2c; Tue, 07 Jan 2020 16:52:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: add a new test for removing ACLs through the attr interface
Date:   Tue,  7 Jan 2020 17:52:55 +0100
Message-Id: <20200107165255.261877-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Test that removing the SGI_ACL_FILE attr also removes the cached ACL
used for access control checking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/666     | 58 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/666.out |  7 ++++++
 tests/xfs/group   |  1 +
 3 files changed, 66 insertions(+)
 create mode 100755 tests/xfs/666
 create mode 100644 tests/xfs/666.out

diff --git a/tests/xfs/666 b/tests/xfs/666
new file mode 100755
index 00000000..00d3cbc1
--- /dev/null
+++ b/tests/xfs/666
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Christoph Hellwig
+#
+# FS QA Test 666
+#
+# Ensure that removing the access ACL through the XFS-specific attr name removes
+# the cached ACL as well
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $FILE
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_test
+_require_runas
+_require_acls
+_require_user
+
+FILE=$TEST_DIR/foo
+
+echo "This is a test" > ${FILE}
+chmod g-r $FILE
+chmod o-r $FILE
+chmod u-r $FILE
+
+echo "No ACL: "
+_user_do "cat $FILE"
+
+echo "With ACL: "
+setfacl -m u:$qa_user:r $FILE
+_user_do "cat $FILE"
+
+echo "ACL Removed through attr:"
+setfattr -x trusted.SGI_ACL_FILE ${FILE}
+_user_do "cat $FILE"
+
+status=0
+exit
diff --git a/tests/xfs/666.out b/tests/xfs/666.out
new file mode 100644
index 00000000..bd45c3ef
--- /dev/null
+++ b/tests/xfs/666.out
@@ -0,0 +1,7 @@
+QA output created by 666
+No ACL: 
+Permission denied
+With ACL: 
+This is a test
+ACL Removed through attr:
+Permission denied
diff --git a/tests/xfs/group b/tests/xfs/group
index c7253cf1..6af5171e 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -509,3 +509,4 @@
 509 auto ioctl
 510 auto ioctl quick
 511 auto quick quota
+666 auto quick acl attr
-- 
2.24.1

