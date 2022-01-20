Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 928C1C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345251AbiATAX6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240611AbiATAX5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:23:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B465DC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:23:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 544F561514
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1AFC004E1;
        Thu, 20 Jan 2022 00:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638236;
        bh=kKSCEh9Brtps/lreAEL6ivx8QhPzfkPU/WSCnbhG6ao=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r3hEP4innc9Ynm02jWM0IA4GbqrNKllWv5kpMxN+AB7Q/WdY6SbNKo0mAnQ5uJqLo
         etAx4GspEWpxZiTDI2hBjDZMYaKPialbfIufrIJqGEd+QTgq4R6D81gYtHkgyAWNdE
         +Ly4zN704mOveNvACGDYFGPdgilii23Rh5VFe3sM5MA4k+vRsE2G5bxBJdJxfAQHVo
         8ayvGykA0x9hvJ63cVUDPw7lm59gyoQPxi9g2X7mCMHsJhOkiezPI1COlueuqCsFdK
         fpRhETEkvzKW+gZ8ytdKdZ1i/4QKNMOsIK3YW5sMzT76UYw1UOC5eUKVu1EoOUYKWh
         sgi3B1vEWaffw==
Subject: [PATCH 08/48] xfs: remove the xfs_dqblk_t typedef
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:23:56 -0800
Message-ID: <164263823637.865554.14010692926217489679.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 11a83f4c393040dc3a6a368c6399785dbfae7602

Remove the few leftover instances of the xfs_dinode_t typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c               |    2 +-
 db/dquot.c               |    8 ++++----
 db/field.c               |    2 +-
 libxfs/xfs_dquot_buf.c   |    4 ++--
 libxfs/xfs_format.h      |    4 ++--
 logprint/log_print_all.c |    2 +-
 repair/dinode.c          |    2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/db/check.c b/db/check.c
index 496a4da3..654631a5 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3461,7 +3461,7 @@ process_quota(
 {
 	xfs_fsblock_t	bno;
 	int		cb;
-	xfs_dqblk_t	*dqb;
+	struct xfs_dqblk	*dqb;
 	xfs_dqid_t	dqid;
 	uint8_t		exp_flags = 0;
 	uint		i;
diff --git a/db/dquot.c b/db/dquot.c
index e52000f2..76853a72 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -32,8 +32,8 @@ const field_t	dqblk_hfld[] = {
 	{ NULL }
 };
 
-#define	DDOFF(f)	bitize(offsetof(xfs_dqblk_t, dd_ ## f))
-#define	DDSZC(f)	szcount(xfs_dqblk_t, dd_ ## f)
+#define	DDOFF(f)	bitize(offsetof(struct xfs_dqblk, dd_ ## f))
+#define	DDSZC(f)	szcount(struct xfs_dqblk, dd_ ## f)
 const field_t	dqblk_flds[] = {
 	{ "diskdq", FLDT_DISK_DQUOT, OI(DDOFF(diskdq)), C1, 0, TYP_NONE },
 	{ "fill", FLDT_CHARS, OI(DDOFF(fill)), CI(DDSZC(fill)), FLD_SKIPALL,
@@ -138,7 +138,7 @@ dquot_f(
 		dbprintf(_("bad %s id for dquot %s\n"), s, argv[optind]);
 		return 0;
 	}
-	perblock = (int)(mp->m_sb.sb_blocksize / sizeof(xfs_dqblk_t));
+	perblock = (int)(mp->m_sb.sb_blocksize / sizeof(struct xfs_dqblk));
 	qbno = (xfs_fileoff_t)id / perblock;
 	qoff = (int)(id % perblock);
 	push_cur();
@@ -153,7 +153,7 @@ dquot_f(
 	set_cur(&typtab[TYP_DQBLK], XFS_FSB_TO_DADDR(mp, bm.startblock), blkbb,
 		DB_RING_IGN, NULL);
 	iocur_top->dquot_buf = 1;
-	off_cur(qoff * (int)sizeof(xfs_dqblk_t), sizeof(xfs_dqblk_t));
+	off_cur(qoff * (int)sizeof(struct xfs_dqblk), sizeof(struct xfs_dqblk));
 	ring_add();
 	return 0;
 }
diff --git a/db/field.c b/db/field.c
index 90d3609a..0a089b56 100644
--- a/db/field.c
+++ b/db/field.c
@@ -290,7 +290,7 @@ const ftattr_t	ftattrtab[] = {
 	  fa_dirblock, NULL },
 	{ FLDT_DISK_DQUOT, "disk_dquot", NULL, (char *)disk_dquot_flds,
 	  SI(bitsz(struct xfs_disk_dquot)), 0, NULL, disk_dquot_flds },
-	{ FLDT_DQBLK, "dqblk", NULL, (char *)dqblk_flds, SI(bitsz(xfs_dqblk_t)),
+	{ FLDT_DQBLK, "dqblk", NULL, (char *)dqblk_flds, SI(bitsz(struct xfs_dqblk)),
 	  0, NULL, dqblk_flds },
 	{ FLDT_DQID, "dqid", fp_num, "%d", SI(bitsz(xfs_dqid_t)), 0, NULL,
 	  NULL },
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index ecb4a002..db603cab 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -20,7 +20,7 @@ xfs_calc_dquots_per_chunk(
 	unsigned int		nbblks)	/* basic block units */
 {
 	ASSERT(nbblks > 0);
-	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
+	return BBTOB(nbblks) / sizeof(struct xfs_dqblk);
 }
 
 /*
@@ -125,7 +125,7 @@ xfs_dqblk_repair(
 	 * Typically, a repair is only requested by quotacheck.
 	 */
 	ASSERT(id != -1);
-	memset(dqb, 0, sizeof(xfs_dqblk_t));
+	memset(dqb, 0, sizeof(struct xfs_dqblk));
 
 	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 10f38541..d665c04e 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1215,7 +1215,7 @@ struct xfs_disk_dquot {
  * This is what goes on disk. This is separated from the xfs_disk_dquot because
  * carrying the unnecessary padding would be a waste of memory.
  */
-typedef struct xfs_dqblk {
+struct xfs_dqblk {
 	struct xfs_disk_dquot	dd_diskdq; /* portion living incore as well */
 	char			dd_fill[4];/* filling for posterity */
 
@@ -1225,7 +1225,7 @@ typedef struct xfs_dqblk {
 	__be32		  dd_crc;	/* checksum */
 	__be64		  dd_lsn;	/* last modification in log */
 	uuid_t		  dd_uuid;	/* location information */
-} xfs_dqblk_t;
+};
 
 #define XFS_DQUOT_CRC_OFF	offsetof(struct xfs_dqblk, dd_crc)
 
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index c9c453f6..182b9d53 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -172,7 +172,7 @@ xlog_recover_print_buffer(
 			printf(_("		UIDs 0x%lx-0x%lx\n"),
 			       (unsigned long)be32_to_cpu(ddq->d_id),
 			       (unsigned long)be32_to_cpu(ddq->d_id) +
-			       (BBTOB(f->blf_len) / sizeof(xfs_dqblk_t)) - 1);
+			       (BBTOB(f->blf_len) / sizeof(struct xfs_dqblk)) - 1);
 		} else {
 			printf(_("	BUF DATA\n"));
 			if (!print_buffer) continue;
diff --git a/repair/dinode.c b/repair/dinode.c
index a9ab3d99..909fea8e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1142,7 +1142,7 @@ process_quota_inode(
 	qbno = NULLFILEOFF;
 
 	while ((qbno = blkmap_next_off(blkmap, qbno, &t)) != NULLFILEOFF) {
-		xfs_dqblk_t	*dqb;
+		struct xfs_dqblk	*dqb;
 		int		writebuf = 0;
 
 		fsbno = blkmap_get(blkmap, qbno);

