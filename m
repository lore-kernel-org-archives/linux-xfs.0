Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAABFC49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89B31214AF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732374AbfIPMQl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:16:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732409AbfIPMQk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 08:16:40 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5957D10CC1FB
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:40 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 189ED5C22C
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:40 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 10/11] xfs: factor out tree fixup logic into helper
Date:   Mon, 16 Sep 2019 08:16:34 -0400
Message-Id: <20190916121635.43148-11-bfoster@redhat.com>
In-Reply-To: <20190916121635.43148-1-bfoster@redhat.com>
References: <20190916121635.43148-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Mon, 16 Sep 2019 12:16:40 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Lift the btree fixup path into a helper function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 42 +++++++++++++++++++++++++++++----------
 fs/xfs/xfs_trace.h        |  1 +
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6f7e4666250c..381a08257aaf 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -883,6 +883,36 @@ xfs_alloc_cur_check(
 	return 0;
 }
 
+/*
+ * Complete an allocation of a candidate extent. Remove the extent from both
+ * trees and update the args structure.
+ */
+STATIC int
+xfs_alloc_cur_finish(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_cur	*acur)
+{
+	int			error;
+
+	ASSERT(acur->cnt && acur->bnolt);
+	ASSERT(acur->bno >= acur->rec_bno);
+	ASSERT(acur->bno + acur->len <= acur->rec_bno + acur->rec_len);
+	ASSERT(acur->rec_bno + acur->rec_len <=
+	       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
+
+	error = xfs_alloc_fixup_trees(acur->cnt, acur->bnolt, acur->rec_bno,
+				      acur->rec_len, acur->bno, acur->len, 0);
+	if (error)
+		return error;
+
+	args->agbno = acur->bno;
+	args->len = acur->len;
+	args->wasfromfl = 0;
+
+	trace_xfs_alloc_cur(args);
+	return 0;
+}
+
 /*
  * Deal with the case where only small freespaces remain. Either return the
  * contents of the last freespace record, or allocate space from the freelist if
@@ -1352,7 +1382,6 @@ xfs_alloc_ag_vextent_near(
 	} else if (error) {
 		goto out;
 	}
-	args->wasfromfl = 0;
 
 	/*
 	 * First algorithm.
@@ -1433,15 +1462,8 @@ xfs_alloc_ag_vextent_near(
 	}
 
 alloc:
-	args->agbno = acur.bno;
-	args->len = acur.len;
-	ASSERT(acur.bno >= acur.rec_bno);
-	ASSERT(acur.bno + acur.len <= acur.rec_bno + acur.rec_len);
-	ASSERT(acur.rec_bno + acur.rec_len <=
-	       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
-
-	error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt, acur.rec_bno,
-				      acur.rec_len, acur.bno, acur.len, 0);
+	/* fix up btrees on a successful allocation */
+	error = xfs_alloc_cur_finish(args, &acur);
 
 out:
 	xfs_alloc_cur_close(&acur, error);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2e57dc3d4230..b8b93068efe7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1642,6 +1642,7 @@ DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
+DEFINE_ALLOC_EVENT(xfs_alloc_cur);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur_right);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur_left);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
-- 
2.20.1

