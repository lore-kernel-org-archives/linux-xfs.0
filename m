Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35489C05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjBIW0n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjBIW0m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:42 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DD95A9C9
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:40 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id mi9so3418940pjb.4
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wA1KCdf9LliXC5fnyuaN30leiwS2w1Xde/CEDLCm8sk=;
        b=Pjck6Qv+WKlPNQuijyta+J836Nz3GeZD7kNe8zNDLhLqcqRJ8HuPLeLXJTqB7Chjv+
         gPNySgjARbn/WunGCR3h1RwUdLUSsKlF4e6jszHWP9ZMVJquTgKUfccOAuJhTJO1fed2
         OQGXbjA6PWN61maiZF3Yn2GiaTc/yZkmKfeFRgPrmqzovhsDhvyfxk7zs+ol9raNs42S
         qTZ/ASYKSPl8wk8imaeAeWVThy2uVqIY3xGkeZ8J7YgizSipNafNjcI4AtcoCgWi1wC2
         S3DcBC5kVTwiJ2c+Tu3MdiAY5yGrA/COfXTSNHGRzLxLotx3F2ga1iKdm7AP6AB06+no
         CSlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wA1KCdf9LliXC5fnyuaN30leiwS2w1Xde/CEDLCm8sk=;
        b=2fHdzuBahQnRGA9P0AQC4Of2k3ZYnPc4ttmtXgpCAlROtcJ9tSoxsOOSsZdUuB2EVz
         lgkGK7H162sEB8fDKhP3gu/jYcCddPIPQ+hka66/yj9uhiO2WCOJGEVDqOWMP0jvxTNN
         /wQU1P3uv4bOAHtqwvNDn6/mlgcH/DeQleXFWj60NPOMJiBY3Vizjt3epX2hso3UDfT2
         31NbiA93+TM1mO1kaE2OqXuvLdsckFgja+Y2s26H/A156hY7gsNRdNmHRS9wq4jqDseS
         WyCHOln3rYvj4eLw4MQa10rWPUoHBiMRv7rlEynvTnQexRm9EbkuhSSwZ4FLptsHXqAW
         CjdQ==
X-Gm-Message-State: AO0yUKX1nrvYMIJuOOxaN5bz8zx6VE4dvjaBcLfacfsGPIiYw+YHp3lv
        UVeigOpTiTIAc0PEkcTwGOXj8y6WbwfWht2c
X-Google-Smtp-Source: AK7set+SA0XlaSGrKPGv6gwsPXGUZwIJE7Lnm9sW/+kWrbmQ2B9gAcySFcsMEpGAcW4Fb15c22rxpA==
X-Received: by 2002:a05:6a21:3801:b0:bc:c456:9621 with SMTP id yi1-20020a056a21380100b000bcc4569621mr9822512pzb.8.1675981600256;
        Thu, 09 Feb 2023 14:26:40 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id v1-20020a17090a6b0100b002311ae14a01sm3403794pjj.11.2023.02.09.14.26.39
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:26:39 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOWA-O2
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcOU-2N
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 32/42] xfs: use xfs_bmap_longest_free_extent() in filestreams
Date:   Fri, 10 Feb 2023 09:18:15 +1100
Message-Id: <20230209221825.3722244-33-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |  2 +-
 fs/xfs/libxfs/xfs_bmap.h |  2 ++
 fs/xfs/xfs_filestream.c  | 22 ++++++++--------------
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 89398172d8be..16628fdbcd55 100644
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
index 524912f276f8..b52cfdcb9320 100644
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

