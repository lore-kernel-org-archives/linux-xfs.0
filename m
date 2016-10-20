Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932345AbcJTOLW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Oct 2016 10:11:22 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C3A7F80099
        for <linux-xfs@vger.kernel.org>; Thu, 20 Oct 2016 14:11:21 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9KEBL6q001881
        for <linux-xfs@vger.kernel.org>; Thu, 20 Oct 2016 10:11:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs_io: use fiemap -c param to query cow fork
Date: Thu, 20 Oct 2016 10:11:19 -0400
Message-Id: <1476972679-571-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1476972679-571-1-git-send-email-bfoster@redhat.com>
References: <1476972679-571-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 io/fiemap.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index f89da06..9114af1 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -206,6 +206,10 @@ calc_print_format(
 	}
 }
 
+#ifndef FIEMAP_FLAG_COW
+#define FIEMAP_FLAG_COW		0x00000010
+#endif
+
 int
 fiemap_f(
 	int		argc,
@@ -231,11 +235,14 @@ fiemap_f(
 	__u64		last_logical = 0;
 	struct stat	st;
 
-	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
+	while ((c = getopt(argc, argv, "acln:v")) != EOF) {
 		switch (c) {
 		case 'a':
 			fiemap_flags |= FIEMAP_FLAG_XATTR;
 			break;
+		case 'c':
+			fiemap_flags |= FIEMAP_FLAG_COW;
+			break;
 		case 'l':
 			lflag = 1;
 			break;
-- 
2.7.4

