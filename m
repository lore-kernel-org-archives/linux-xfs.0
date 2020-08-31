Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF571C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1F66206CD
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I2qeDlO/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgHaNA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgHaNAn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 09:00:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD9BC061755
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:00:42 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id h12so550418pgm.7
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qga1hzz07K5e+K9/OTPTyOgQSFSofcbP8y11BSWRp8s=;
        b=I2qeDlO/vwuSWpmzByHswzhl5CjZk2FxyKwk8hdhqdL27Vfj8E7te4LqiPminhdJ0r
         4mRZ90mUQgiSwsTfOwaTiTFn1ZoQ8qLphVqdSy8QQTsydjoLm0SwtYPRlX0gcFCbAwpn
         SwhSWwaE39817YNFGC9YSb3RlRnpWYEzXGL7oF35SFxJXBm5SvwTWPEzXRsyqX9LFpeP
         ZohsoMVTpFSjvSUrfGuKYazU2VsvWt+zYrHPCnGNelFGeP/Wvmw2Bo02yTIy2AoLwkUn
         Q6Xqe7BRaeKql6ppHqbB34ZWH6HoSU9N2l3nX9rZK9FytFqwH3pFrAmcxw16MhgnXZUy
         qRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qga1hzz07K5e+K9/OTPTyOgQSFSofcbP8y11BSWRp8s=;
        b=QWijI771sN7vZejnbcalq/IlpUgW+pCcRBqHzjTkJtFsYFzLUXDfcImQJouF3hqv1e
         zfy+dwRDO9PucHmFEdWBeQksPAG0tzNJ9EGa3Cw9Sd0GR/00pESlBxdqHw2cP57zQlKJ
         +Z/rBuue51IfHLIRfrjZQjkKtqDlfTLhQHAwffECH2Q4gSHrBwidZSSWkeden7jX/pSK
         /lWoBwtpSfqrJ1CLzuJB4n7KG4/+ecF3fy/denaU2JiPV+z9lPV7O6skxa1cNwOT6RCJ
         qLWwlyB620XyTH39oYLPBa7VF9Xn8dxSnXk5z5RG+Yt8XgAGdRcRhVjElRAUHx37hub+
         a2IQ==
X-Gm-Message-State: AOAM532O1DFm4wKSbFfttUxKRYUyiX9Nvx9YDhRAuyBcEtW/bafBbexG
        bKJPaPy8hXpTarC4qjrtJCsAOnwnodE=
X-Google-Smtp-Source: ABdhPJz0BtcFu59FL5fwnPlWAySLlr/x1ZcMta/ViolOxUi0lQ64pUKUxIPrg0qh6o0kDSAbNB59bg==
X-Received: by 2002:a63:fc4b:: with SMTP id r11mr1110771pgk.342.1598878841517;
        Mon, 31 Aug 2020 06:00:41 -0700 (PDT)
Received: from localhost.localdomain ([122.167.36.194])
        by smtp.gmail.com with ESMTPSA id p190sm8296130pfp.9.2020.08.31.06.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 06:00:40 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH 2/3] xfs: Introduce xfs_dfork_nextents() helper
Date:   Mon, 31 Aug 2020 18:30:09 +0530
Message-Id: <20200831130010.454-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831130010.454-1-chandanrlinux@gmail.com>
References: <20200831130010.454-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper
function xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents()
returns the same value as XFS_DFORK_NEXTENTS(). A future commit which
extends inode's extent counter fields will add more logic to this
helper.

This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
with calls to xfs_dfork_nextents().

No functional changes have been made.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_format.h     |  4 ----
 fs/xfs/libxfs/xfs_inode_buf.c  | 29 ++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_inode_buf.h  |  2 ++
 fs/xfs/libxfs/xfs_inode_fork.c | 10 +++++++---
 fs/xfs/scrub/inode.c           | 12 +++++++-----
 5 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 31b7ece985bb..5f41e177dbda 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -992,10 +992,6 @@ enum xfs_dinode_fmt {
 	((w) == XFS_DATA_FORK ? \
 		(dip)->di_format : \
 		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 5dcd71bfab2e..cce2aa99aad8 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -368,9 +368,11 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	uint32_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
+	di_nextents = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
+
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
@@ -401,6 +403,19 @@ xfs_dinode_verify_fork(
 	return NULL;
 }
 
+xfs_extnum_t
+xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip, int whichfork)
+{
+	xfs_extnum_t nextents;
+
+	if (whichfork == XFS_DATA_FORK)
+		nextents = be32_to_cpu(dip->di_nextents);
+	else
+		nextents = be16_to_cpu(dip->di_anextents);
+
+	return nextents;
+}
+
 static xfs_failaddr_t
 xfs_dinode_verify_forkoff(
 	struct xfs_dinode	*dip,
@@ -437,6 +452,8 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_extnum_t            nextents;
+	int64_t			nblocks;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -467,10 +484,12 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK);
+	nextents += xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
 	/* Fork checks carried over from xfs_iformat_fork */
-	if (mode &&
-	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+	if (mode && nextents > nblocks)
 		return __this_address;
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
@@ -527,7 +546,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
 			return __this_address;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 6b08b9d060c2..a97caf675aaf 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -59,5 +59,7 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
 xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
+xfs_extnum_t xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip,
+				int whichfork);
 
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 3a084aea8f85..2ce80bb5c70a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -10,6 +10,7 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
+#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
@@ -104,9 +105,10 @@ xfs_iformat_extents(
 	int			whichfork)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	int			nex = xfs_dfork_nextents(sbp, dip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
@@ -226,6 +228,7 @@ xfs_iformat_data_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
 	struct inode		*inode = VFS_I(ip);
 	int			error;
 
@@ -234,7 +237,7 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
+	ip->i_df.if_nextents = xfs_dfork_nextents(sbp, dip, XFS_DATA_FORK);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -286,6 +289,7 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
 	int			error = 0;
 
 	/*
@@ -296,7 +300,7 @@ xfs_iformat_attr_fork(
 	ip->i_afp->if_format = dip->di_aformat;
 	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
 		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
-	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
+	ip->i_afp->if_nextents = xfs_dfork_nextents(sbp, dip, XFS_ATTR_FORK);
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 6d483ab29e63..e428ad0eef03 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -354,7 +354,7 @@ xchk_dinode(
 	xchk_inode_extsize(sc, dip, ino, mode, flags);
 
 	/* di_nextents */
-	nextents = be32_to_cpu(dip->di_nextents);
+	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK);
 	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
@@ -371,10 +371,12 @@ xchk_dinode(
 		break;
 	}
 
+	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
+
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
-	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
+	if (nextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
 		xchk_ino_set_corrupt(sc, ino);
@@ -386,7 +388,6 @@ xchk_dinode(
 		xchk_ino_set_corrupt(sc, ino);
 
 	/* di_anextents */
-	nextents = be16_to_cpu(dip->di_anextents);
 	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
@@ -464,6 +465,7 @@ xchk_inode_xref_bmap(
 	struct xfs_scrub	*sc,
 	struct xfs_dinode	*dip)
 {
+	xfs_mount_t		*mp = sc->mp;
 	xfs_extnum_t		nextents;
 	xfs_filblks_t		count;
 	xfs_filblks_t		acount;
@@ -477,14 +479,14 @@ xchk_inode_xref_bmap(
 			&nextents, &count);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents < be32_to_cpu(dip->di_nextents))
+	if (nextents < xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
 			&nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents != be16_to_cpu(dip->di_anextents))
+	if (nextents != xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	/* Check nblocks against the inode. */
-- 
2.28.0

