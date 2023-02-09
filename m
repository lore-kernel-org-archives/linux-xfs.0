Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BD3C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjBIWSs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjBIWSi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:38 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE1B6A706
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:36 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id o8so2160931pls.11
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wpbyA0zM28tyIls+6mCI4lskKdE7calhX4RFUr2EdfI=;
        b=Vx/SSeRKtyQyohfyROf5Zq8y02kiah/FMmABX1TFCStld9CTa8HGdqgfZwbI/UC4ks
         4swf82rhxwiMTOfcaoZ6p8Gce926kWJdOshfXHowfJQcjWKxti0LtPJ0a/V/vfuF3sgS
         Dd2edF616eEZE++RLxiC8xeK++AaYFVacI+imH13xuJo+Ey/gW9L1G685OWg9Kd4dNye
         tGFPLZpFyIyVSo0L0jh8lTbdfxUuIyEUTiEtFAh27e5droZHZiRCEGHET9tVFKSYiK0l
         xI7+DfwH52XZnaGZlAJGu9w5Vx0IwjZ0FsQSZWtAW0qu3yn4Nvti9B4kBqNOqWC5fc9C
         bs3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wpbyA0zM28tyIls+6mCI4lskKdE7calhX4RFUr2EdfI=;
        b=2IxuYPK0su8XffldOPITmQRSTKZbb9KU18p6j62WADzOK7WPLNa7+IhsWKEGfSNZp4
         V0/wkP+lab1xOpHwgzcK48bJypPUe1mkl/QJG+ADFGrCKkt6WkDOYCFcxwTdqm3rbgfn
         JBUVZi+L/dmhtMKrd/LbJvvr+mrDW6Hl9h7duyKtCzlqcxvp2vJOomV4SIoQ2qVJbtBn
         fFB7YLYPyxYlpW3eq/1QRyrwyE/LzFaIC+6U/2Y8nppGHTWheJ4RcaOhAtUoS/E4R0io
         cP7oRVMHcCFg6OQ9QUhPmONuFBqTrt07M2W/4T+eNyxxOcMf71MD0wTB7YQE87dW16D3
         Md3w==
X-Gm-Message-State: AO0yUKWoZFwQWL8NWK7ilWgXveyhA5wM9fsszRCC3uwamvRgyESNx8ZD
        atw1BWfPeArHNoh7zSwxaVmIdNbu6+dB/KSz
X-Google-Smtp-Source: AK7set89GsBWnkeokCbLUwHDxnZ6IjC8Pdo9BSneQvTvomIg18wd02cE/Fl1/kvGBQHF3zQZsqjZdQ==
X-Received: by 2002:a05:6a21:33a0:b0:bd:17a4:c339 with SMTP id yy32-20020a056a2133a000b000bd17a4c339mr16762729pzb.13.1675981116131;
        Thu, 09 Feb 2023 14:18:36 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id x9-20020a63b349000000b004f1e87530cesm1726794pgt.91.2023.02.09.14.18.31
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:32 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOWV-Uf
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcP3-31
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 39/42] xfs: use for_each_perag_wrap in xfs_filestream_pick_ag
Date:   Fri, 10 Feb 2023 09:18:22 +1100
Message-Id: <20230209221825.3722244-40-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

