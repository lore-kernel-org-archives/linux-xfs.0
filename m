Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67732C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 22:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D88222D75
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 22:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbhAEWDt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 17:03:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730122AbhAEWDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 17:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609884142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=g3L3LLJGU1g6CnBt8Zi9YtJ0mpwkeYoMvv2FC5rl5jk=;
        b=VnnsmXOuS9pVLQiitAJ1ep2hMsubkp4Ui7vvFshNdQmCOKwTPQNf5BFX9WM3VaD4uPEZou
        Iary/zGY3hsZyxAwyQ6qiC3oGrQgySR2G167xLVc/1VZC2VH5cn0BGJgI0nlA86ZfFRXBH
        zK48NX9h4ALyFiiGDzZWncYI57LoZWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-qNLlmzDbNLqfvGAuzBOo2g-1; Tue, 05 Jan 2021 17:02:20 -0500
X-MC-Unique: qNLlmzDbNLqfvGAuzBOo2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71919801817
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jan 2021 22:02:19 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3ECBA5D9D2
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jan 2021 22:02:19 +0000 (UTC)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: cosmetic changes to libxfs_inode_alloc
Message-ID: <a06e071c-be56-2e7d-cceb-82030f55e1f3@redhat.com>
Date:   Tue, 5 Jan 2021 16:02:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This pre-patch helps make the next libxfs-sync for 5.11 a bit
more clear.

In reality, the libxfs_inode_alloc function matches the kernel's
xfs_dir_ialloc so rename it for clarity before the rest of the
sync, and change several variable names for the same reason.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 742aebc8..01a62daa 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -156,7 +156,7 @@ typedef struct cred {
 	gid_t	cr_gid;
 } cred_t;
 
-extern int	libxfs_inode_alloc (struct xfs_trans **, struct xfs_inode *,
+extern int	libxfs_dir_ialloc (struct xfs_trans **, struct xfs_inode *,
 				mode_t, nlink_t, xfs_dev_t, struct cred *,
 				struct fsxattr *, struct xfs_inode **);
 extern void	libxfs_trans_inode_alloc_buf (struct xfs_trans *,
diff --git a/libxfs/util.c b/libxfs/util.c
index 252cf91e..62eadaea 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -531,9 +531,9 @@ error0:	/* Cancel bmap, cancel trans */
  * other in repair - now there is just the one.
  */
 int
-libxfs_inode_alloc(
-	xfs_trans_t	**tp,
-	xfs_inode_t	*pip,
+libxfs_dir_ialloc(
+	xfs_trans_t	**tpp,
+	xfs_inode_t	*dp,
 	mode_t		mode,
 	nlink_t		nlink,
 	xfs_dev_t	rdev,
@@ -541,16 +541,18 @@ libxfs_inode_alloc(
 	struct fsxattr	*fsx,
 	xfs_inode_t	**ipp)
 {
-	xfs_buf_t	*ialloc_context;
+	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
-	int		error;
+	xfs_buf_t	*ialloc_context = NULL;
+	int		code;
+
+	tp = *tpp;
 
-	ialloc_context = (xfs_buf_t *)0;
-	error = libxfs_ialloc(*tp, pip, mode, nlink, rdev, cr, fsx,
+	code = libxfs_ialloc(tp, dp, mode, nlink, rdev, cr, fsx,
 			   &ialloc_context, &ip);
-	if (error) {
+	if (code) {
 		*ipp = NULL;
-		return error;
+		return code;
 	}
 	if (!ialloc_context && !ip) {
 		*ipp = NULL;
@@ -559,25 +561,25 @@ libxfs_inode_alloc(
 
 	if (ialloc_context) {
 
-		xfs_trans_bhold(*tp, ialloc_context);
+		xfs_trans_bhold(tp, ialloc_context);
 
-		error = xfs_trans_roll(tp);
-		if (error) {
+		code = xfs_trans_roll(tpp);
+		if (code) {
 			fprintf(stderr, _("%s: cannot duplicate transaction: %s\n"),
-				progname, strerror(error));
+				progname, strerror(code));
 			exit(1);
 		}
-		xfs_trans_bjoin(*tp, ialloc_context);
-		error = libxfs_ialloc(*tp, pip, mode, nlink, rdev, cr,
+		xfs_trans_bjoin(tp, ialloc_context);
+		code = libxfs_ialloc(tp, dp, mode, nlink, rdev, cr,
 				   fsx, &ialloc_context, &ip);
 		if (!ip)
-			error = -ENOSPC;
-		if (error)
-			return error;
+			code = -ENOSPC;
+		if (code)
+			return code;
 	}
 
 	*ipp = ip;
-	return error;
+	return code;
 }
 
 void
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 0fa6ffb0..8439efc4 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -453,7 +453,7 @@ parseproto(
 	case IF_REGULAR:
 		buf = newregfile(pp, &len);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					   &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -477,7 +477,7 @@ parseproto(
 		}
 		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
 
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					  &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode pre-allocation failed"), error);
@@ -498,7 +498,7 @@ parseproto(
 		tp = getres(mp, 0);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFBLK, 1,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFBLK, 1,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error) {
 			fail(_("Inode allocation failed"), error);
@@ -513,7 +513,7 @@ parseproto(
 		tp = getres(mp, 0);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFCHR, 1,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFCHR, 1,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -525,7 +525,7 @@ parseproto(
 
 	case IF_FIFO:
 		tp = getres(mp, 0);
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFIFO, 1, 0,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFIFO, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -537,7 +537,7 @@ parseproto(
 		buf = getstr(pp);
 		len = (int)strlen(buf);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFLNK, 1, 0,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFLNK, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -548,7 +548,7 @@ parseproto(
 		break;
 	case IF_DIRECTORY:
 		tp = getres(mp, 0);
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFDIR, 1, 0,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -640,7 +640,7 @@ rtinit(
 
 	memset(&creds, 0, sizeof(creds));
 	memset(&fsxattrs, 0, sizeof(fsxattrs));
-	error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
+	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
 					&creds, &fsxattrs, &rbmip);
 	if (error) {
 		fail(_("Realtime bitmap inode allocation failed"), error);
@@ -657,7 +657,7 @@ rtinit(
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
 	mp->m_rbmip = rbmip;
-	error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
+	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
 					&creds, &fsxattrs, &rsumip);
 	if (error) {
 		fail(_("Realtime summary inode allocation failed"), error);
diff --git a/repair/phase6.c b/repair/phase6.c
index 682356f0..f69afac9 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -919,7 +919,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(_("%d - couldn't iget root inode to make %s\n"),
 			i, ORPHANAGE);*/
 
-	error = -libxfs_inode_alloc(&tp, pip, mode|S_IFDIR,
+	error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR,
 					1, 0, &zerocr, &zerofsx, &ip);
 	if (error) {
 		do_error(_("%s inode allocation failed %d\n"),

