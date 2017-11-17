Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30154 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932152AbdKQUOr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 15:14:47 -0500
Subject: [PATCH 11/12] libhandle: add missing destructor
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 12:14:43 -0800
Message-ID: <151094968373.29763.2142855883193834111.stgit@magnolia>
In-Reply-To: <151094960522.29763.11622891165765932168.stgit@magnolia>
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make it so that we can tear down the file descriptor hash table.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/handle.h   |    2 ++
 libhandle/handle.c |   13 +++++++++++++
 2 files changed, 15 insertions(+)


diff --git a/include/handle.h b/include/handle.h
index ee69a11..49f1441 100644
--- a/include/handle.h
+++ b/include/handle.h
@@ -50,6 +50,8 @@ extern int  parentpaths_by_handle(void *__hanp, size_t __hlen,
 extern int  fssetdm_by_handle (void *__hanp, size_t __hlen,
 			       struct fsdmidata *__fsdmi);
 
+void fshandle_destroy(void);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 00127b3..e6971dd 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -62,6 +62,19 @@ struct fdhash {
 
 static struct fdhash *fdhash_head = NULL;
 
+void
+fshandle_destroy(void)
+{
+	struct fdhash	*nexth;
+	struct fdhash	*h = fdhash_head;
+
+	while (h) {
+		nexth = h->fnxt;
+		free(h);
+		h = nexth;
+	}
+}
+
 int
 path_to_fshandle(
 	char		*path,		/* input,  path to convert */

