Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FC8C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiEEQMl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381845AbiEEQML (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:12:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492EC5C649
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:08:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0617BB82C77
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE82C385AC;
        Thu,  5 May 2022 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766904;
        bh=iX7q+DeOnRDQzBezgSmgW+bH111jghQaYXk2hKR37Qk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d4wEgXA/W54E5ajGBX0AKEpeI5RgzgbDA+DP7gFv7BFiUvX/DKUOwkxEvrNdqGWoY
         2NKNIS7zaGFroTjlhQtKMTJ7Ib0ZI0ffyZD30MeuyArxh0RaRM0Y5aLf9OchL5Pzem
         gDpE4IV5t1dljPPPosq4r29BblGG86XV6E+l9/YSWQZqTO/CI53MO5fIMlUzFH01/5
         G1MVLY51mYpGtzzvYLT+V7tKzOcpqMN0a742F39vx8xGIJKBk6+g0Z0b5uhnrVL0g6
         oC73zXpW+EqugYPhRG7mzJl9NxSjmUpxHHP8tg/35+z/3opPXXyzdDkowj7g64xwuH
         AWXZHm0yHN2ow==
Subject: [PATCH 1/4] xfs_scrub: widen action list length variables
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:08:24 -0700
Message-ID: <165176690438.252326.914958822000727760.stgit@magnolia>
In-Reply-To: <165176689880.252326.13947902143386455815.stgit@magnolia>
References: <165176689880.252326.13947902143386455815.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

On a 32-bit system it's possible for there to be so many items in the
repair list that we overflow a size_t.  Widen this to unsigned long
long.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase4.c |    6 +++---
 scrub/repair.c |    2 +-
 scrub/repair.h |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index 559b2779..f97847d8 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -30,8 +30,8 @@ repair_ag(
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	bool				*aborted = priv;
 	struct action_list		*alist;
-	size_t				unfixed;
-	size_t				new_unfixed;
+	unsigned long long		unfixed;
+	unsigned long long		new_unfixed;
 	unsigned int			flags = 0;
 	int				ret;
 
@@ -168,7 +168,7 @@ phase4_estimate(
 	int			*rshift)
 {
 	xfs_agnumber_t		agno;
-	size_t			need_fixing = 0;
+	unsigned long long	need_fixing = 0;
 
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++)
 		need_fixing += action_list_length(&ctx->action_lists[agno]);
diff --git a/scrub/repair.c b/scrub/repair.c
index bb026101..67900ea4 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -189,7 +189,7 @@ action_list_init(
 }
 
 /* Number of repairs in this list. */
-size_t
+unsigned long long
 action_list_length(
 	struct action_list		*alist)
 {
diff --git a/scrub/repair.h b/scrub/repair.h
index 4261be49..102e5779 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -8,7 +8,7 @@
 
 struct action_list {
 	struct list_head	list;
-	size_t			nr;
+	unsigned long long	nr;
 	bool			sorted;
 };
 
@@ -22,7 +22,7 @@ static inline bool action_list_empty(const struct action_list *alist)
 	return list_empty(&alist->list);
 }
 
-size_t action_list_length(struct action_list *alist);
+unsigned long long action_list_length(struct action_list *alist);
 void action_list_add(struct action_list *dest, struct action_item *item);
 void action_list_splice(struct action_list *dest, struct action_list *src);
 

