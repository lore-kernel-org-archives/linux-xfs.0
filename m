Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705E3C32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjARWsW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjARWsI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:48:08 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D1464680
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:06 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id q9so107422pgq.5
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4q+6Xp9n+VfYC+pf1Rd0pktWwQnGPXSqSq2RV/ab2hw=;
        b=km8Yzgv74qlP2yJQ6875jC22hg2aCxTX4bdPUio3pKDXT4VeH4iMPzp18F8KOF+m/9
         +Tn8bvjLLfi7b/9TF3DWzq8RwkK0KISZorOHQse6cYjDaxvBXmIV2SMb7Z8pyRE/VNUy
         h05p4bwBP37gVXmERFldn0PDhy9Oc1sm2Nr5ofG4l5uRj3SSUSNjDmNj3B/xSEfRsDJp
         bkKIIRih5Mz/FiymORulgz1HtLhLhn/q8USSXQn2vIHaZUnOz6etTmwKyUrgYZZxdC4C
         diYQpsCd+mHCorTcs9WBFLEF/4wJ30BNj/1RKSrywOz7RwEI6ZP8GqJN1qYeZ1FbXTZa
         QBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4q+6Xp9n+VfYC+pf1Rd0pktWwQnGPXSqSq2RV/ab2hw=;
        b=7v7mC8XbMiv5hSrYYiM9saOI7RGK+YMwBtl9nZUHhZqx2PVEkD1qo/w8cwIKfXes87
         o86r2AZ6mVzcGSaNKvpKnB1ZyFq20ff1qWCw9OsKWLMM04rT2UtHrosrfjI6Oiwb4gzE
         CzjQ0LnJZp3bCEkkHYn3U6gYdXOjVLRn3yGhQgaX5W2eflb+FmrJ6mKvse3s9VX2eAoB
         H+rvAGmjsb6MXEBfgVnsGiPzGTANABcbUuOpU++DMcLFRPguw5/NVX5a0Sr/YNBUcQwd
         wS8x04L7PboCy9OGYrYcpD6F85AS5HAMUjik4s4BXbaeY7T2Byesa5mC0wRozMmdxyEF
         AzGA==
X-Gm-Message-State: AFqh2krQSycNsNjKqd3E8ShyP8jUhePdXqvc2n2XUQbq6KmmNCNKcRSJ
        dGWthvUNp/al3AtskZRkbQQ4Z0znvshcE9Ow
X-Google-Smtp-Source: AMrXdXuk1S82eM9pzaV+wM3n+TOmPrxK6oqnFie3+WPhH2JGuEO7sOX5aM/4JTHh0OrbXX78EMjX6A==
X-Received: by 2002:a05:6a00:340a:b0:58d:aae8:1c2 with SMTP id cn10-20020a056a00340a00b0058daae801c2mr10000603pfb.8.1674082086059;
        Wed, 18 Jan 2023 14:48:06 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id z188-20020a6265c5000000b0055f209690c0sm21824530pfb.50.2023.01.18.14.48.05
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:48:05 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iY8-Mj
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FF5-2H
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 32/42] xfs: use xfs_bmap_longest_free_extent() in filestreams
Date:   Thu, 19 Jan 2023 09:44:55 +1100
Message-Id: <20230118224505.1964941-33-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The code in xfs_bmap_longest_free_extent() is open coded in
xfs_filestream_pick_ag(). Export xfs_bmap_longest_free_extent and
call it from the filestreams code instead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c |  2 +-
 fs/xfs/libxfs/xfs_bmap.h |  2 ++
 fs/xfs/xfs_filestream.c  | 22 ++++++++--------------
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 58790951be3e..c6a617dada27 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3135,7 +3135,7 @@ xfs_bmap_adjacent(
 #undef ISVALID
 }
 
-static int
+int
 xfs_bmap_longest_free_extent(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 0ffc0d998850..7bd619eb2f7d 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -168,6 +168,8 @@ static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
 #define xfs_valid_startblock(ip, startblock) \
 	((startblock) != 0 || XFS_IS_REALTIME_INODE(ip))
 
+int	xfs_bmap_longest_free_extent(struct xfs_perag *pag,
+		struct xfs_trans *tp, xfs_extlen_t *blen);
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 7e8b25ab6c46..2eb702034d05 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -124,17 +124,14 @@ xfs_filestream_pick_ag(
 		trace_xfs_filestream_scan(mp, ip->i_ino, ag);
 
 		pag = xfs_perag_get(mp, ag);
-
-		if (!xfs_perag_initialised_agf(pag)) {
-			err = xfs_alloc_read_agf(pag, NULL, trylock, NULL);
-			if (err) {
-				if (err != -EAGAIN) {
-					xfs_perag_put(pag);
-					return err;
-				}
-				/* Couldn't lock the AGF, skip this AG. */
-				goto next_ag;
-			}
+		longest = 0;
+		err = xfs_bmap_longest_free_extent(pag, NULL, &longest);
+		if (err) {
+			xfs_perag_put(pag);
+			if (err != -EAGAIN)
+				return err;
+			/* Couldn't lock the AGF, skip this AG. */
+			goto next_ag;
 		}
 
 		/* Keep track of the AG with the most free blocks. */
@@ -154,9 +151,6 @@ xfs_filestream_pick_ag(
 			goto next_ag;
 		}
 
-		longest = xfs_alloc_longest_free_extent(pag,
-				xfs_alloc_min_freelist(mp, pag),
-				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 		if (((minlen && longest >= minlen) ||
 		     (!minlen && pag->pagf_freeblks >= minfree)) &&
 		    (!xfs_perag_prefers_metadata(pag) ||
-- 
2.39.0

