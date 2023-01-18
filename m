Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8DCC32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjARWs1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjARWsT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:48:19 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5804663E33
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:19 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id v10-20020a17090abb8a00b00229c517a6eeso3998855pjr.5
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YG+zdlmm5lAWh9En7pnzqioreUYArbEXxAUwZRDcMWA=;
        b=G214PVaWPqGTgDrvtTJpXglwV4HbrCkUDr4obxZ8L8cuy2sxkhc5xwIGq6YSWZ8MyO
         yZScpz4FMxGsSp8e+hp0XCItk1UFaI8LfCdBhpyIE2GgOkaTLQE5aW6HW8G3J2Q1y3PW
         /CdLAo4MNsyc+JBqF9tOpAlk4eeYgHE4kgh4kJL8VGlGw5+XgqB3cyc1er/xyo7mxJiR
         ScktfBleKNnjUlnjI+FRtXy0Dd49wXePhzFGgNSP5cNRW/RodJRccAcIzQ+WimuJcklR
         PeyN+6BAXHiQ7rVJh9/Ms2ffbat+WQj5Tco7c/fjHn1JETtmBlCBHvIXZ1UImDk0Vv5D
         EJIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YG+zdlmm5lAWh9En7pnzqioreUYArbEXxAUwZRDcMWA=;
        b=HeIUuY/PYthdcc/QMNEaIZuKSZ4/5y5yEjbQPtEVbsA5tiq/QRvbydYDorE+I/PLbr
         5EqvrVMZjoe8DmA6+gb4G4erSmANd3L/FZ7XfFzGggB9Ws3HuSr/jHLvtEdevLJlR0JD
         Em5a5WF38GTHEMs/i7FoiG4qbvJ9rOxCsKV/mcLbPvMd6FUM+1Cy4mGYzaCCe848VPiu
         XGyUEPGgJruEoRzClMf2bawWg5ag0NB726wjCcUddG9xFUMPi4o2BUsJyfDiKHPxZYY6
         3iGTwSQQbuoBMmsIRnlQI1lFqKK780tzCk9GAtmaoKnwJ2tTTzHbMjB7yMQ3D9HUBemq
         CA0Q==
X-Gm-Message-State: AFqh2kpmpw8px1qTEdAbNbhUXwaqMvwKSy7/ABoU6PpWgGt4g+o9Ablp
        UAQ9uaj/opSixyzYaxBpzrP+m7p5T1C/4fVJ
X-Google-Smtp-Source: AMrXdXsB4fNzCZy5WBWckfkU50Mh78VVeGFtU+Yx95vSysGcC3GTEGs8b0A2ktTjzasH7FCkKSp07Q==
X-Received: by 2002:a17:90a:1305:b0:229:369f:fc89 with SMTP id h5-20020a17090a130500b00229369ffc89mr8549492pja.35.1674082098864;
        Wed, 18 Jan 2023 14:48:18 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id dw13-20020a17090b094d00b00226f49eca92sm1856952pjb.28.2023.01.18.14.48.18
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:48:18 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iYT-TC
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FFe-2v
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 39/42] xfs: use for_each_perag_wrap in xfs_filestream_pick_ag
Date:   Thu, 19 Jan 2023 09:45:02 +1100
Message-Id: <20230118224505.1964941-40-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_filestream_pick_ag() is now ready to rework to use
for_each_perag_wrap() for iterating the perags during the AG
selection scan.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 101 ++++++++++++++++------------------------
 1 file changed, 41 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index c92429272ff7..71fa44485a2f 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -83,9 +83,9 @@ xfs_filestream_pick_ag(
 	struct xfs_perag	*max_pag = NULL;
 	xfs_extlen_t		minlen = *longest;
 	xfs_extlen_t		free = 0, minfree, maxfree = 0;
-	xfs_agnumber_t		startag = *agp;
-	xfs_agnumber_t		ag = startag;
-	int			err, trylock, nscan;
+	xfs_agnumber_t		start_agno = *agp;
+	xfs_agnumber_t		agno;
+	int			err, trylock;
 
 	ASSERT(S_ISDIR(VFS_I(ip)->i_mode));
 
@@ -97,13 +97,9 @@ xfs_filestream_pick_ag(
 	/* For the first pass, don't sleep trying to init the per-AG. */
 	trylock = XFS_ALLOC_FLAG_TRYLOCK;
 
-	for (nscan = 0; 1; nscan++) {
-		trace_xfs_filestream_scan(mp, ip->i_ino, ag);
-
-		err = 0;
-		pag = xfs_perag_grab(mp, ag);
-		if (!pag)
-			goto next_ag;
+restart:
+	for_each_perag_wrap(mp, start_agno, agno, pag) {
+		trace_xfs_filestream_scan(mp, ip->i_ino, agno);
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
@@ -111,6 +107,7 @@ xfs_filestream_pick_ag(
 			if (err != -EAGAIN)
 				break;
 			/* Couldn't lock the AGF, skip this AG. */
+			err = 0;
 			goto next_ag;
 		}
 
@@ -129,77 +126,61 @@ xfs_filestream_pick_ag(
 		 * loop, and it guards against two filestreams being established
 		 * in the same AG as each other.
 		 */
-		if (atomic_inc_return(&pag->pagf_fstrms) > 1) {
-			atomic_dec(&pag->pagf_fstrms);
-			xfs_perag_rele(pag);
-			goto next_ag;
-		}
-
-		if (((minlen && *longest >= minlen) ||
-		     (!minlen && pag->pagf_freeblks >= minfree)) &&
-		    (!xfs_perag_prefers_metadata(pag) ||
-		     !(flags & XFS_PICK_USERDATA) ||
-		     (flags & XFS_PICK_LOWSPACE))) {
-
-			/* Break out, retaining the reference on the AG. */
-			free = pag->pagf_freeblks;
-			break;
+		if (atomic_inc_return(&pag->pagf_fstrms) <= 1) {
+			if (((minlen && *longest >= minlen) ||
+			     (!minlen && pag->pagf_freeblks >= minfree)) &&
+			    (!xfs_perag_prefers_metadata(pag) ||
+			     !(flags & XFS_PICK_USERDATA) ||
+			     (flags & XFS_PICK_LOWSPACE))) {
+				/* Break out, retaining the reference on the AG. */
+				free = pag->pagf_freeblks;
+				break;
+			}
 		}
 
 		/* Drop the reference on this AG, it's not usable. */
 		atomic_dec(&pag->pagf_fstrms);
-next_ag:
-		/* Move to the next AG, wrapping to AG 0 if necessary. */
-		if (++ag >= mp->m_sb.sb_agcount)
-			ag = 0;
+	}
 
-		/* If a full pass of the AGs hasn't been done yet, continue. */
-		if (ag != startag)
-			continue;
+	if (err) {
+		xfs_perag_rele(pag);
+		if (max_pag)
+			xfs_perag_rele(max_pag);
+		return err;
+	}
 
+	if (!pag) {
 		/* Allow sleeping in xfs_alloc_read_agf() on the 2nd pass. */
-		if (trylock != 0) {
+		if (trylock) {
 			trylock = 0;
-			continue;
+			goto restart;
 		}
 
 		/* Finally, if lowspace wasn't set, set it for the 3rd pass. */
 		if (!(flags & XFS_PICK_LOWSPACE)) {
 			flags |= XFS_PICK_LOWSPACE;
-			continue;
+			goto restart;
 		}
 
 		/*
-		 * Take the AG with the most free space, regardless of whether
-		 * it's already in use by another filestream.
+		 * No unassociated AGs are available, so select the AG with the
+		 * most free space, regardless of whether it's already in use by
+		 * another filestream. It none suit, return NULLAGNUMBER.
 		 */
-		if (max_pag) {
-			pag = max_pag;
-			atomic_inc(&pag->pagf_fstrms);
-			free = maxfree;
-			break;
+		if (!max_pag) {
+			*agp = NULLAGNUMBER;
+			trace_xfs_filestream_pick(ip, *agp, free, 0);
+			return 0;
 		}
-
-		/* take AG 0 if none matched */
-		trace_xfs_filestream_pick(ip, *agp, free, nscan);
-		*agp = 0;
-		return 0;
-	}
-
-	trace_xfs_filestream_pick(ip, pag ? pag->pag_agno : NULLAGNUMBER,
-			free, nscan);
-
-	if (max_pag)
+		pag = max_pag;
+		free = maxfree;
+		atomic_inc(&pag->pagf_fstrms);
+	} else if (max_pag) {
 		xfs_perag_rele(max_pag);
-
-	if (err)
-		return err;
-
-	if (!pag) {
-		*agp = NULLAGNUMBER;
-		return 0;
 	}
 
+	trace_xfs_filestream_pick(ip, pag->pag_agno, free, 0);
+
 	err = -ENOMEM;
 	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
 	if (!item)
-- 
2.39.0

