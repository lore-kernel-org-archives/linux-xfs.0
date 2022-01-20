Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79953C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357759AbiATAUX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240436AbiATAUW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:20:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6E5C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4558B81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77088C004E1;
        Thu, 20 Jan 2022 00:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638019;
        bh=jvEv/ApBeSfPV8v+dBSoZFKqZfI6tjPxTfz+6cVuZnI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Yj/+BiyMaMEVF9NAnXY3ThSHdXYxWr3PAy/3TZqtTgpAz6cdCrIfVV/vzQJYdSxFn
         KssdhC2ulOowyqT/172ZqpZeR+/ZdB2cnzow9ta3Sq3ll4kNc55bir1Of0kEdnNpqc
         T9Y0ofcIJAZh/Z50TkjTHvN9JSwRLnu/YL6kxU5aGfhYJtspum771p6p8+tghmkkcp
         vp6fjTAF/Iq8o0d/wRaI84ZSfEJic+PD0tME7mfwsNb9m8GiCV2UDI55Pk+D4K07sn
         sOZeB/2R6esUN7WAjTM7SWOw9KGVRySaaWKXMtTH4hCwYI7ZdmvZw5CBDvvJyXvzfJ
         wjZmFg7PDlt7A==
Subject: [PATCH 32/45] libxlog: replace xfs_sb_version checks with feature
 flag checks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:20:19 -0800
Message-ID: <164263801917.860211.2280941273411845824.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
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

