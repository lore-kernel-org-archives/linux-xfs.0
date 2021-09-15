Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1BAC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC33960E05
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhIOXNW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:13:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232465AbhIOXNW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:13:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F12960E94;
        Wed, 15 Sep 2021 23:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747522;
        bh=tKFyvEgjyD+skrOGjKkfoanM3a4lVjhfbjNMXohjNKg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Po5vKxrTOnNKHWpc0oUS9SMUgjbJTD1nDdkTC6svpeKc7dpPTVqx2PjudEiIcqkek
         HkBF/MLAFAPVPA6KXWBWhUnIk7uDfQisq2oADJWxsgYcOQ+kG+Q6AnTp3eGx31n4tA
         PAU48CwIAn+UfTjs2syU0qTDAAq7GDNrCDaITnkDNL9wW+qNqhOYC0g6N1qVuBFYQ9
         NaZ9GGzO0Dci5XyBO6pTao5GNtRhT/FS1K+Iu8r3HRTSDwOjHclzlH+qm0CS3f3BUl
         7urNarrSx609iAh03QybQWgBL432eEfpG5y6qRw0NW/33VotAbFbkXLH5gTwvY1JdS
         al6OG0ziV72Pg==
Subject: [PATCH 60/61] xfs_db: convert the agresv command to use
 for_each_perag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:12:02 -0700
Message-ID: <163174752232.350433.14940185128838830345.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the AG iteration loop for this debugger command to use
for_each_perag, since it's the only place in userspace that obvious
wants it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/info.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)


diff --git a/db/info.c b/db/info.c
index 2ecaea64..fdee76ba 100644
--- a/db/info.c
+++ b/db/info.c
@@ -62,11 +62,11 @@ agresv_help(void)
 
 static void
 print_agresv_info(
-	xfs_agnumber_t	agno)
+	struct xfs_perag *pag)
 {
 	struct xfs_buf	*bp;
 	struct xfs_agf	*agf;
-	struct xfs_perag *pag = libxfs_perag_get(mp, agno);
+	xfs_agnumber_t	agno = pag->pag_agno;
 	xfs_extlen_t	ask = 0;
 	xfs_extlen_t	used = 0;
 	xfs_extlen_t	free = 0;
@@ -97,7 +97,6 @@ print_agresv_info(
 	if (ask - used > free)
 		printf(" <not enough space>");
 	printf("\n");
-	libxfs_perag_put(pag);
 }
 
 static int
@@ -105,6 +104,7 @@ agresv_f(
 	int			argc,
 	char			**argv)
 {
+	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 	int			i;
 
@@ -127,13 +127,15 @@ agresv_f(
 				continue;
 			}
 
-			print_agresv_info(a);
+			pag = libxfs_perag_get(mp, a);
+			print_agresv_info(pag);
+			libxfs_perag_put(pag);
 		}
 		return 0;
 	}
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
-		print_agresv_info(agno);
+	for_each_perag(mp, agno, pag)
+		print_agresv_info(pag);
 
 	return 0;
 }

