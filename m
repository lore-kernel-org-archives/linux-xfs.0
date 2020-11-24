Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71680C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 15:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 178CB206FA
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 15:52:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UDtj4C8v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389883AbgKXPw1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 10:52:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389465AbgKXPw0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 10:52:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606233145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=8CjJhIyjuxuqdYkEDL3EVAWJbiBs4q6YVRMXB+7Jlqw=;
        b=UDtj4C8v/DvGwXlK5iUHc0YNPuFxzAmbHyn0q044vVMyE9XT77Yhv31llk2ECC8PKktdyc
        fhPvTLXRXx/qX6jaTfvSEPEutdFTNLXDmAnr1bIJVYJf7KJSJJhPWosH+/4FwlQ8tXra23
        ODZjxy4Jbd8hJuLbMLcRing9OAVRih8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-kIfDaDfyPpS9qI3CIuQ5nw-1; Tue, 24 Nov 2020 10:52:23 -0500
X-MC-Unique: kIfDaDfyPpS9qI3CIuQ5nw-1
Received: by mail-pl1-f199.google.com with SMTP id w9so13488239plp.1
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 07:52:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8CjJhIyjuxuqdYkEDL3EVAWJbiBs4q6YVRMXB+7Jlqw=;
        b=UlOhcX/Gqxh8ZrVaAGbY5qMqubwJ0lR6u/yHsLsfIZP7lglr5rN4GeQSCcW+pw5vrw
         MOAHN52HE7/aX0nWaACw7jJRX7tCRc97ST69FATwla+tYEwjRDpeI/QCkUKMqH7smPCu
         nnIBwkiwEymbfobdtDQU2ovcObbBRk7XztxZYD77wF5RshOadgDscIhTuO9/osaSAUWg
         GO4/b6oTRyj4zRVLLPZix5DstGU10WmrTRwr+G5Cs9VRUR/vzhkEl3JAKvVGCVimMMCn
         nO5iqSHpBJQAIQ0C1NWHmbkliEUFD984OFJ8+xfaEZY6ny6uhdc9vsmGfHjGd1U6v2PH
         OCPg==
X-Gm-Message-State: AOAM531Ofva5pJ5AnDHRdYG9nrCruC8mBhkt+nLODDumt0DiivGQWexa
        mLx/O9kNVfyaZzsP3jMVsdwjDNrEv9Q904cYZ1Kk0Cm3dsRPXorWWZCcozHlG8EqTmdnjn1fbjH
        bh6gbLUGnNcRjnTDKW8JCXs/1OU1ZxAywFBeXI18yDqAzFws2AaUyB1gruKw8P/HiErAhi5T0tw
        ==
X-Received: by 2002:a17:90a:bc83:: with SMTP id x3mr5622112pjr.90.1606233142153;
        Tue, 24 Nov 2020 07:52:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJym9odPozOYr5dF4hSiWearS4nICgev/VvPhu2lYCEdrF8Aq6iPuDjR/Bpr6mkF3mRjL9eJEA==
X-Received: by 2002:a17:90a:bc83:: with SMTP id x3mr5622092pjr.90.1606233141889;
        Tue, 24 Nov 2020 07:52:21 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mn21sm3723909pjb.28.2020.11.24.07.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 07:52:21 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 3/3] xfs: clean up xfs_dialloc() by introducing __xfs_dialloc()
Date:   Tue, 24 Nov 2020 23:51:30 +0800
Message-Id: <20201124155130.40848-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201124155130.40848-1-hsiangkao@redhat.com>
References: <20201124155130.40848-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the main loop out into a separated function, so we can save
many extra xfs_perag_put()s and gotoes to make the logic cleaner.

Also it can make the modification of perag protection by some lock
for shrinking in the future somewhat easier.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
It tries to kill multiple goto exits... which makes the logic hard
to read and modify.

not quite sure the name of __xfs_dialloc(), cannot think of some
better name since xfs_dialloc_ag is used...

 fs/xfs/libxfs/xfs_ialloc.c | 166 ++++++++++++++++++++-----------------
 1 file changed, 88 insertions(+), 78 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 5c8b0210aad3..937455c50570 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1681,6 +1681,83 @@ xfs_dialloc_ag(
 	return error;
 }
 
+/*
+ * Return 0 for successfully allocating some inodes in this AG;
+ *        1 for skipping to allocating in the next AG;
+ *      < 0 for error code.
+ */
+static int
+__xfs_dialloc(
+	struct xfs_trans	*tp,
+	xfs_ino_t		parent,
+	struct xfs_perag	*pag,
+	struct xfs_buf		**IO_agbp,
+	xfs_ino_t		*inop,
+	bool			okalloc)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_agnumber_t		agno = pag->pag_agno;
+	struct xfs_buf		*agbp;
+	int			error;
+
+	if (!pag->pagi_inodeok) {
+		xfs_ialloc_next_ag(mp);
+		return 1;
+	}
+
+	if (!pag->pagi_init) {
+		error = xfs_ialloc_pagi_init(mp, tp, agno);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Do a first racy fast path check if this AG is usable.
+	 */
+	if (!pag->pagi_freecount && !okalloc)
+		return 1;
+
+	/*
+	 * Then read in the AGI buffer and recheck with the AGI buffer
+	 * lock held.
+	 */
+	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	if (error)
+		return error;
+
+	if (pag->pagi_freecount) {
+		*IO_agbp = NULL;
+		return xfs_dialloc_ag(tp, agbp, parent, inop);
+	}
+
+	if (okalloc) {
+		error = xfs_ialloc_ag_alloc(tp, agbp);
+		if (error < 0) {
+			xfs_trans_brelse(tp, agbp);
+			if (error != -ENOSPC)
+				return error;
+
+			*inop = NULLFSINO;
+			return 0;
+		}
+
+		if (!error) {
+			/*
+			 * We successfully allocated some inodes, return
+			 * the current context to the caller so that it
+			 * can commit the current transaction and call
+			 * us again where we left off.
+			 */
+			ASSERT(pag->pagi_freecount > 0);
+			*IO_agbp = agbp;
+			*inop = NULLFSINO;
+			return 0;
+		}
+	}
+	xfs_trans_brelse(tp, agbp);
+	return 1;
+}
+
 /*
  * Allocate an inode on disk.
  *
@@ -1711,7 +1788,6 @@ xfs_dialloc(
 	xfs_ino_t		*inop)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno;
 	int			error;
 	bool			noroom = false;
@@ -1726,8 +1802,9 @@ xfs_dialloc(
 		 * continue where we left off before.  In this case, we
 		 * know that the allocation group has free inodes.
 		 */
-		agbp = *IO_agbp;
-		goto out_alloc;
+		error = xfs_dialloc_ag(tp, *IO_agbp, parent, inop);
+		*IO_agbp = NULL;
+		return error;
 	}
 
 	/*
@@ -1761,87 +1838,20 @@ xfs_dialloc(
 	 * allocation groups upward, wrapping at the end.
 	 */
 	agno = start_agno;
-	for (;;) {
+	do {
 		pag = xfs_perag_get(mp, agno);
-		if (!pag->pagi_inodeok) {
-			xfs_ialloc_next_ag(mp);
-			goto nextag;
-		}
-
-		if (!pag->pagi_init) {
-			error = xfs_ialloc_pagi_init(mp, tp, agno);
-			if (error)
-				goto out_error;
-		}
-
-		/*
-		 * Do a first racy fast path check if this AG is usable.
-		 */
-		if (!pag->pagi_freecount && !okalloc)
-			goto nextag;
-
-		/*
-		 * Then read in the AGI buffer and recheck with the AGI buffer
-		 * lock held.
-		 */
-		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
-		if (error)
-			goto out_error;
-
-		if (pag->pagi_freecount) {
-			xfs_perag_put(pag);
-			goto out_alloc;
-		}
-
-		if (!okalloc)
-			goto nextag_relse_buffer;
-
-
-		error = xfs_ialloc_ag_alloc(tp, agbp);
-		if (error < 0) {
-			xfs_trans_brelse(tp, agbp);
-
-			if (error != -ENOSPC)
-				goto out_error;
-
-			xfs_perag_put(pag);
-			*inop = NULLFSINO;
-			return 0;
-		}
-
-		if (!error) {
-			/*
-			 * We successfully allocated some inodes, return
-			 * the current context to the caller so that it
-			 * can commit the current transaction and call
-			 * us again where we left off.
-			 */
-			ASSERT(pag->pagi_freecount > 0);
-			xfs_perag_put(pag);
+		error = __xfs_dialloc(tp, parent, pag, IO_agbp, inop, okalloc);
+		xfs_perag_put(pag);
 
-			*IO_agbp = agbp;
-			*inop = NULLFSINO;
-			return 0;
-		}
+		if (error <= 0)
+			return error;
 
-nextag_relse_buffer:
-		xfs_trans_brelse(tp, agbp);
-nextag:
-		xfs_perag_put(pag);
 		if (++agno == mp->m_sb.sb_agcount)
 			agno = 0;
-		if (agno == start_agno) {
-			*inop = NULLFSINO;
-			return noroom ? -ENOSPC : 0;
-		}
-	}
+	} while (agno != start_agno);
 
-out_alloc:
-	*IO_agbp = NULL;
-	return xfs_dialloc_ag(tp, agbp, parent, inop);
-out_error:
-	xfs_perag_put(pag);
-	return error;
+	*inop = NULLFSINO;
+	return noroom ? -ENOSPC : 0;
 }
 
 /*
-- 
2.18.4

