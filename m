Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:38740 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbdI1QkP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2017 12:40:15 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] generic/447: not a quick test
Date: Thu, 28 Sep 2017 19:40:41 +0300
Message-Id: <1506616841-24121-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Eryu Guan <eguan@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

It hogged my cpu for a good 300s.
Test was inheritted from generic/176, which is not quick.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/group | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/group b/tests/generic/group
index f922b49..a9ad05d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -449,7 +449,7 @@
 444 auto quick acl
 445 auto quick rw
 446 auto quick rw dangerous
-447 auto quick clone
+447 auto clone
 448 auto quick rw
 449 auto quick acl enospc
 450 auto quick rw
-- 
2.7.4

