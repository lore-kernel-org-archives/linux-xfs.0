Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10D9E7CDD
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 06:15:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C77568F8050
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JxmzOR5C7NyFWo9d (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:54 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 82143C0467EE
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:15:54 +0000 (UTC)
Received: from localhost.localdomain (vpn1-7-36.ams2.redhat.com [10.36.7.36])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u2OBFbLN009274
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 07:15:53 -0400
From: jtulak@redhat.com
Subject: [PATCH 17/19] xfsprogs: disable truncating of files
Date: Thu, 24 Mar 2016 12:15:34 +0100
Message-Id: <1458818136-56043-18-git-send-email-jtulak@redhat.com>
In-Reply-To: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Jan Tulak <jtulak@redhat.com>

Unify mkfs.xfs behaviour a bit and never truncate files. If the user
is trying to mkfs an existing file, we don't want to destroy anything
he did with the file before (sparse file, allocations...)

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 libxfs/init.c   |  2 +-
 mkfs/xfs_mkfs.c | 18 +++++++++++-------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 268136f..5f4b6c4 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -112,7 +112,7 @@ libxfs_device_open(char *path, int creat, int xflags, int setblksize)
 
 retry:
 	flags = (readonly ? O_RDONLY : O_RDWR) | \
-		(creat ? (O_CREAT|O_TRUNC) : 0) | \
+		(creat ? O_CREAT : 0) | \
 		(dio ? O_DIRECT : 0) | \
 		(excl ? O_EXCL : 0);
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9a6ae2c..2bb3b35 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1029,15 +1029,19 @@ check_device_type(
 	const char	*optname)
 {
 	struct stat64 statbuf;
+	int statres;
 
-	if (*isfile && (no_size || no_name)) {
+	statres = stat64(name, &statbuf);
+
+	if (*isfile && statres != 0 && (no_size || no_name)) {
 		fprintf(stderr,
-	_("if -%s file then -%s name and -%s size are required\n"),
-			optname, optname, optname);
+			_("if -%s file and the file does not exists, " \
+			"then -%s name and -%s size are required\n"),
+					optname, optname, optname);
 		usage();
 	}
 
-	if (stat64(name, &statbuf)) {
+	if (statres) {
 		if (errno == ENOENT && *isfile) {
 			if (create)
 				*create = 1;
@@ -1059,9 +1063,9 @@ check_device_type(
 	}
 
 	/*
-	 * We only want to completely truncate and recreate an existing file if
-	 * we were specifically told it was a file. Set the create flag only in
-	 * this case to trigger that behaviour.
+	 * We only want to create a file only if we were specifically told
+	 * we want a file. Set the create flag only in this case to trigger
+	 * that behaviour.
 	 */
 	if (S_ISREG(statbuf.st_mode)) {
 		if (!*isfile)
-- 
2.6.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
