Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18167C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED106604AC
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbhHQXmw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhHQXmv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:42:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D718D604AC;
        Tue, 17 Aug 2021 23:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243737;
        bh=F85+Pak1vAlDNuhwrseQzVbIzi6EUCORAIYsDvdeX48=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=emiwpUFr9GvBTKn2BNUIjSskrosnZPglCBp5U/UnAfEspC7SehcnNARruEg4lec5p
         s47ypkZigvyr7xRIc0kbBT/Fle+RMim9QFBiFWtr8lffdmkK8dn+9FNjCZUl2KfmPh
         CkmPBs48Gq5DedWyZh1a0npfkhIAUu/cZJ4UR+XMMEKDEuYD9e9p5ok6v/U0uy2woZ
         MU+P+kV9DgY0MYWV3at/Otu19wSp/pyI3rfXD0SHakYD951YsCY+XXtU95kiuCyIFO
         AaqrI5WdP4n1Bz0AS/IOZdmnhXg/aTl70v7ICOr9c7NYjrS+cAYd1AYn2a03sUKXRP
         jY+uCE2fRn1GQ==
Subject: [PATCH 01/15] xfs: fix incorrect unit conversion in scrub tracepoint
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:42:17 -0700
Message-ID: <162924373760.761813.14269643495581366455.stgit@magnolia>
In-Reply-To: <162924373176.761813.10896002154570305865.stgit@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XFS_DADDR_TO_FSB converts a raw disk address (in units of 512b blocks)
to a raw disk address (in units of fs blocks).  Unfortunately, the
xchk_block_error_class tracepoints incorrectly uses this to decode
xfs_daddr_t into segmented AG number and AG block addresses.  Use the
correct translation code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index e46f5cef90da..29f1d0ac7ec5 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -193,29 +193,21 @@ DECLARE_EVENT_CLASS(xchk_block_error_class,
 		__field(dev_t, dev)
 		__field(unsigned int, type)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, bno)
+		__field(xfs_agblock_t, agbno)
 		__field(void *, ret_ip)
 	),
 	TP_fast_assign(
-		xfs_fsblock_t	fsbno;
-		xfs_agnumber_t	agno;
-		xfs_agblock_t	bno;
-
-		fsbno = XFS_DADDR_TO_FSB(sc->mp, daddr);
-		agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
-		bno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
-
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->type = sc->sm->sm_type;
-		__entry->agno = agno;
-		__entry->bno = bno;
+		__entry->agno = xfs_daddr_to_agno(sc->mp, daddr);
+		__entry->agbno = xfs_daddr_to_agbno(sc->mp, daddr);
 		__entry->ret_ip = ret_ip;
 	),
 	TP_printk("dev %d:%d type %s agno %u agbno %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->agno,
-		  __entry->bno,
+		  __entry->agbno,
 		  __entry->ret_ip)
 )
 

