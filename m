Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbeK0JfK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:35:10 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E010D1390C
        for <linux-xfs@vger.kernel.org>; Mon, 26 Nov 2018 22:39:31 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mkfs.xfs: null-terminate symlinks created via protofile
Message-ID: <a7246562-e851-dfc4-ea3f-3b4dd64aca5b@redhat.com>
Date: Mon, 26 Nov 2018 16:39:30 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Zorro Lang <zlang@redhat.com>

Now that we have a symlink verifier which checks that in-memory
symlink names are null-terminated, be sure we do that when we
create them via the mkfs protofile.

We only want to null-terminate inline data if it's a symlink;
we only ever /call/ newfile() with "dolocal" for symlinks, so
rename that function argument for clarity.

Zorro found this by running xfs/019 on an s390x machine, it
failed with:

 Metadata corruption detected at 0x101214a, inode 0x89 data fork

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reported-by: Zorro Lang <zlang@redhat.com>
---

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 1cd5436..d76c80d 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -15,7 +15,7 @@ static char *getstr(char **pp);
 static void fail(char *msg, int i);
 static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
-static int newfile(xfs_trans_t *tp, xfs_inode_t *ip, int dolocal, int logit,
+static int newfile(xfs_trans_t *tp, xfs_inode_t *ip, int symlink, int logit,
 			char *buf, int len);
 static char *newregfile(char **pp, int *len);
 static void rtinit(xfs_mount_t *mp);
@@ -220,7 +220,7 @@ static int
 newfile(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*ip,
-	int		dolocal,
+	int		symlink,
 	int		logit,
 	char		*buf,
 	int		len)
@@ -236,7 +236,9 @@ newfile(
 
 	flags = 0;
 	mp = ip->i_mount;
-	if (dolocal && len <= XFS_IFORK_DSIZE(ip)) {
+	if (symlink && len <= XFS_IFORK_DSIZE(ip)) {
+		/* Copy the name's trailing NULL as well */
+		len += 1;
 		libxfs_idata_realloc(ip, len, XFS_DATA_FORK);
 		if (buf)
 			memmove(ip->i_df.if_u1.if_data, buf, len);
