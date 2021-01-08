Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD60CC433E9
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 19:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9235A239A1
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 19:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbhAHTLq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 14:11:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727893AbhAHTLp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 14:11:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610133019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LhTefEwTNxBYmgLm87KXueiU4fG2wrHB2vH8Ada3GFI=;
        b=i9HtrG6e1QwbViLbIJrrRyYBLCLJOahMkIahY0CVsNwlBxMSvQ4lQdlIJItKmoRFngOiAp
        88giQNV0dsJgdO2Z7hShv2wJ40RVjXxssIN5gWtqsxg7gNmjn9O8jdjg7W9NLgOLmjD5pP
        gMvQ4SuWncdIPlZz3w8yurVoQzvPAtY=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-MtmWD0AXPL-k0hhd5D_e3g-1; Fri, 08 Jan 2021 14:10:18 -0500
X-MC-Unique: MtmWD0AXPL-k0hhd5D_e3g-1
Received: by mail-pj1-f71.google.com with SMTP id gv14so7667773pjb.1
        for <linux-xfs@vger.kernel.org>; Fri, 08 Jan 2021 11:10:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LhTefEwTNxBYmgLm87KXueiU4fG2wrHB2vH8Ada3GFI=;
        b=iIvYz46IjMm0zvGB19iIncyVjsvZBorPN6PnMDkWtxg7kWA2GcVYbXwTwVLtp/JphB
         8x8kl8GShNRcFiNcFx1ZhVxI6IK3wPX4//vjMQNRepJ7i4xkizxwkgnTtpos4w3wD3B6
         eY7UZStYFieNasjnrSPo7Hassg9HRMaYa+XTGvTmNs7XBotByhiOUG78B3yoOw7W//I5
         3TrbA0fRop0QcSFBq0YAaj1WQlogI2U5JIFy/RY02W2ohVR7W/9u1o5FB4CNHLyEYRTI
         dI7CmZttiSBo25MP4XDhA5nJQ4tGOF9Bz9n74WdYedmN4ObiaFucouxmUKUEgGOscZYg
         m0oA==
X-Gm-Message-State: AOAM5320UoTXnsDY0bB8Z/fh/TulG90vaxU384zBcwzhKCh4gBeCiWz8
        3G7qv0FmpyVOelEzK+YL2i75MNGNg8dSblWhW5WRLbE15RSMZVFIWckdVb0ysZSyJIGfBBXRvQ0
        /FM3L0Y6+paVX1EXyISSIq2dOBsAbcUn0xDVeNx2RYSsWwniXko7XkOnOIkm0nr1SPWi0EgDckQ
        ==
X-Received: by 2002:a63:4c4f:: with SMTP id m15mr8399493pgl.54.1610133015834;
        Fri, 08 Jan 2021 11:10:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwa5tU3TUHLuvUhUqKbHRygD9Y474cp21o5S0pbfjwtFkXniyBmc1fDYJ+JLEpqlqG+Xsc1aw==
X-Received: by 2002:a63:4c4f:: with SMTP id m15mr8399453pgl.54.1610133015427;
        Fri, 08 Jan 2021 11:10:15 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h15sm9761824pfo.71.2021.01.08.11.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 11:10:14 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 1/4] xfs: rename `new' to `delta' in xfs_growfs_data_private()
Date:   Sat,  9 Jan 2021 03:09:16 +0800
Message-Id: <20210108190919.623672-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210108190919.623672-1-hsiangkao@redhat.com>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It actually means the delta block count of growfs. Rename it in order
to make it clear.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 5870db855e8b..d254588f6e21 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -33,7 +33,7 @@ xfs_growfs_data_private(
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_mod;
-	xfs_rfsblock_t		new;
+	xfs_rfsblock_t		delta;
 	xfs_agnumber_t		oagcount;
 	xfs_trans_t		*tp;
 	struct aghdr_init_data	id = {};
@@ -50,16 +50,16 @@ xfs_growfs_data_private(
 		return error;
 	xfs_buf_relse(bp);
 
-	new = nb;	/* use new as a temporary here */
-	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
-	nagcount = new + (nb_mod != 0);
+	delta = nb;	/* use delta as a temporary here */
+	nb_mod = do_div(delta, mp->m_sb.sb_agblocks);
+	nagcount = delta + (nb_mod != 0);
 	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
 		nagcount--;
 		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
 		if (nb < mp->m_sb.sb_dblocks)
 			return -EINVAL;
 	}
-	new = nb - mp->m_sb.sb_dblocks;
+	delta = nb - mp->m_sb.sb_dblocks;
 	oagcount = mp->m_sb.sb_agcount;
 
 	/* allocate the new per-ag structures */
@@ -89,7 +89,7 @@ xfs_growfs_data_private(
 	INIT_LIST_HEAD(&id.buffer_list);
 	for (id.agno = nagcount - 1;
 	     id.agno >= oagcount;
-	     id.agno--, new -= id.agsize) {
+	     id.agno--, delta -= id.agsize) {
 
 		if (id.agno == nagcount - 1)
 			id.agsize = nb -
@@ -110,8 +110,8 @@ xfs_growfs_data_private(
 	xfs_trans_agblocks_delta(tp, id.nfree);
 
 	/* If there are new blocks in the old last AG, extend it. */
-	if (new) {
-		error = xfs_ag_extend_space(mp, tp, &id, new);
+	if (delta) {
+		error = xfs_ag_extend_space(mp, tp, &id, delta);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -143,7 +143,7 @@ xfs_growfs_data_private(
 	 * If we expanded the last AG, free the per-AG reservation
 	 * so we can reinitialize it with the new size.
 	 */
-	if (new) {
+	if (delta) {
 		struct xfs_perag	*pag;
 
 		pag = xfs_perag_get(mp, id.agno);
-- 
2.27.0

