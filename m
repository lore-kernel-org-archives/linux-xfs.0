Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7724C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C2C0610D1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbhINCoH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236074AbhINCoG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:44:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE1FC610D1;
        Tue, 14 Sep 2021 02:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587369;
        bh=jvEv/ApBeSfPV8v+dBSoZFKqZfI6tjPxTfz+6cVuZnI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HLHi5PKS7I841Cmp8JO781bazY2gYk58ZYjnAbj7qDJxVFJH4fwibdaU1i5FKiqyt
         Mv3lhR3eAd1b+G/AUQpWdKlSmPGrHLF8Ussl6LJ70HoVbP6auAzRC755dZ7kk/iixE
         3o7vOOOhnbMAprE8bxNYWwK0iSU2+Z8sHjm+pyHwP0ediD8KPKVcywNcwvfzSwNnFE
         prrx6BlvJ1uLe3ZPLMdi4dsDAPwIS/okXcz6FCcVGxW/GqI4619kW+gda6WeBHeesv
         U8g5piyppuTanEdrP2oxSyw5+QbkYx+0mGhJyL8RcX44Eyf7bmSlOO/cbo+8R60OyN
         0LjwNDQEnR3lQ==
Subject: [PATCH 31/43] libxlog: replace xfs_sb_version checks with feature
 flag checks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:42:49 -0700
Message-ID: <163158736945.1604118.14641958910467350750.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the xfs_sb_version_hasfoo() to checks against mp->m_features.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxlog/util.c            |    6 +++---
 libxlog/xfs_log_recover.c |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/libxlog/util.c b/libxlog/util.c
index a85d70c9..ad60036f 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -31,7 +31,7 @@ xlog_is_dirty(
 	x->logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 	x->logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
 	x->lbsize = BBSIZE;
-	if (xfs_sb_version_hassector(&mp->m_sb))
+	if (xfs_has_sector(mp))
 		x->lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
 
 	log->l_dev = mp->m_logdev_targp;
@@ -39,13 +39,13 @@ xlog_is_dirty(
 	log->l_logBBstart = x->logBBstart;
 	log->l_sectBBsize = BTOBB(x->lbsize);
 	log->l_mp = mp;
-	if (xfs_sb_version_hassector(&mp->m_sb)) {
+	if (xfs_has_sector(mp)) {
 		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
 		ASSERT(log->l_sectbb_log <= mp->m_sectbb_log);
 		/* for larger sector sizes, must have v2 or external log */
 		ASSERT(log->l_sectbb_log == 0 ||
 			log->l_logBBstart == 0 ||
-			xfs_sb_version_haslogv2(&mp->m_sb));
+			xfs_has_logv2(mp));
 		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
 	}
 	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 40d18b88..592e4502 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -364,7 +364,7 @@ xlog_find_verify_log_record(
 	 * reset last_blk.  Only when last_blk points in the middle of a log
 	 * record do we update last_blk.
 	 */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		uint	h_size = be32_to_cpu(head->h_size);
 
 		xhdrs = h_size / XLOG_HEADER_CYCLE_SIZE;
@@ -783,7 +783,7 @@ xlog_find_tail(
 	 * unmount record if there is one, so we pass the lsn of the
 	 * unmount record rather than the block after it.
 	 */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		int	h_size = be32_to_cpu(rhead->h_size);
 		int	h_version = be32_to_cpu(rhead->h_version);
 
@@ -1313,7 +1313,7 @@ xlog_unpack_data_crc(
 
 	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
 	if (crc != rhead->h_crc) {
-		if (rhead->h_crc || xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
+		if (rhead->h_crc || xfs_has_crc(log->l_mp)) {
 			xfs_alert(log->l_mp,
 		"log record CRC mismatch: found 0x%x, expected 0x%x.",
 					le32_to_cpu(rhead->h_crc),
@@ -1326,7 +1326,7 @@ xlog_unpack_data_crc(
 		 * recover past this point. Abort recovery if we are enforcing
 		 * CRC protection by punting an error back up the stack.
 		 */
-		if (xfs_sb_version_hascrc(&log->l_mp->m_sb))
+		if (xfs_has_crc(log->l_mp))
 			return EFSCORRUPTED;
 	}
 
@@ -1352,7 +1352,7 @@ xlog_unpack_data(
 		dp += BBSIZE;
 	}
 
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
 		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
@@ -1431,7 +1431,7 @@ xlog_do_recovery_pass(
 	 * Read the header of the tail block and get the iclog buffer size from
 	 * h_size.  Use this to tell how many sectors make up the log header.
 	 */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		/*
 		 * When using variable length iclogs, read first sector of
 		 * iclog header and extract the header size from it.  Get a

