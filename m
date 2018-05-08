Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52078 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752644AbeEHEnc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 00:43:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w484f9PP034742
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:31 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2hs24sey0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 04:43:31 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w484hV0r016008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:31 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w484hVWn029386
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:31 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 19/21] xfsprogs: Remove single byte array from struct parent
Date: Mon,  7 May 2018 21:41:17 -0700
Message-Id: <1525754479-12177-20-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Variable sized arrays implemented this way may cause
corruptions depending on how different compilers pack
the structure.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/parent.h | 1 -
 io/parent.c      | 9 ++++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/parent.h b/include/parent.h
index f338f96..85cef85 100644
--- a/include/parent.h
+++ b/include/parent.h
@@ -22,7 +22,6 @@ typedef struct parent {
 	__u64	p_ino;
 	__u32	p_gen;
 	__u16	p_reclen;
-	char	p_name[1];
 } parent_t;
 
 typedef struct parent_cursor {
diff --git a/io/parent.c b/io/parent.c
index 1968516..55b8b49 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -45,7 +45,8 @@ check_parent_entry(xfs_bstat_t *bstatp, parent_t *parent)
 	struct stat statbuf;
 	char *str;
 
-	sprintf(fullpath, _("%s%s"), mntpt, parent->p_name);
+	snprintf(fullpath, parent->p_reclen, _("%s%s"), mntpt,
+				((char*)parent)+sizeof(struct parent));
 
 	sts = lstat(fullpath, &statbuf);
 	if (sts != 0) {
@@ -284,9 +285,11 @@ print_parent_entry(parent_t *parent, int fullpath)
 	printf(_("p_gen    = %u\n"),	parent->p_gen);
 	printf(_("p_reclen = %u\n"),	parent->p_reclen);
 	if (fullpath)
-		printf(_("p_name   = \"%s%s\"\n"), mntpt, parent->p_name);
+		printf(_("p_name   = \"%s%s\"\n"), mntpt,
+					((char*)parent)+sizeof(struct parent));
 	else
-		printf(_("p_name   = \"%s\"\n"), parent->p_name);
+		printf(_("p_name   = \"%s\"\n"),
+					((char*)parent)+sizeof(struct parent));
 }
 
 static int
-- 
2.7.4

