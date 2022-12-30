Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFED5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbiLaBd2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLaBd2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:33:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F69DEB7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:33:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D6861CC5
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79968C433D2;
        Sat, 31 Dec 2022 01:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450406;
        bh=LGuoXi8+16wLZ7dAopQhftCLR72gRlv4KrRI89IbSLM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JOZTl4BH3dmkWcAGVr3ZdPc91RaKeKhD+sFR3Vb7UWZEPt4FrJR0hzqigCHzth05P
         eN8rBI33acHsexljLgDy8sy0JNdUTH9OMq0lfNsMSnxedVvyd1gLEKOz99c/PJY51b
         trITFRjon7tmEscTA8iMt+6gYCIlk6/TgVIbOaWSA8irR6WqmlffateB3uoGJaPeqo
         vpi9A8BMhHI97Yk9zB3RDRtIh2I/K6yl2ZvSSDul4LFUMelTLY2rpAsxstPFD0KYhT
         OqMtp2UaxeFCtw/cIVzHxhL6YEHEQKDIYJlJfDefdbaifG8ARZpBejvf3VVyENksLs
         A/6iLfFt+E0LQ==
Subject: [PATCH 1/3] xfs: hoist data device FITRIM AG iteration to a separate
 function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:58 -0800
Message-ID: <167243867879.713699.17161072809346415533.stgit@magnolia>
In-Reply-To: <167243867862.713699.17132272459502557791.stgit@magnolia>
References: <167243867862.713699.17132272459502557791.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Hoist the AG iteration loop logic out of xfs_ioc_trim and into a
separate function.  No functional changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |   50 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 44658cc7d3f2..7459c5205a6b 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -140,6 +140,35 @@ xfs_trim_extents(
 	return error;
 }
 
+static int
+xfs_trim_ddev_extents(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		start,
+	xfs_daddr_t		end,
+	xfs_daddr_t		minlen,
+	uint64_t		*blocks_trimmed)
+{
+	xfs_agnumber_t		start_agno, end_agno, agno;
+	int			error, last_error = 0;
+
+	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
+		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
+
+	start_agno = xfs_daddr_to_agno(mp, start);
+	end_agno = xfs_daddr_to_agno(mp, end);
+
+	for (agno = start_agno; agno <= end_agno; agno++) {
+		error = xfs_trim_extents(mp, agno, start, end, minlen,
+				blocks_trimmed);
+		if (error == -ERESTARTSYS)
+			return error;
+		if (error)
+			last_error = error;
+	}
+
+	return last_error;
+}
+
 /*
  * trim a range of the filesystem.
  *
@@ -158,7 +187,6 @@ xfs_ioc_trim(
 	unsigned int		granularity = bdev_discard_granularity(bdev);
 	struct fstrim_range	range;
 	xfs_daddr_t		start, end, minlen;
-	xfs_agnumber_t		start_agno, end_agno, agno;
 	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
 
@@ -194,21 +222,11 @@ xfs_ioc_trim(
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
 
-	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
-		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)- 1;
-
-	start_agno = xfs_daddr_to_agno(mp, start);
-	end_agno = xfs_daddr_to_agno(mp, end);
-
-	for (agno = start_agno; agno <= end_agno; agno++) {
-		error = xfs_trim_extents(mp, agno, start, end, minlen,
-					  &blocks_trimmed);
-		if (error) {
-			last_error = error;
-			if (error == -ERESTARTSYS)
-				break;
-		}
-	}
+	error = xfs_trim_ddev_extents(mp, start, end, minlen, &blocks_trimmed);
+	if (error == -ERESTARTSYS)
+		return error;
+	if (error)
+		last_error = error;
 
 	if (last_error)
 		return last_error;

