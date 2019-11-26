Return-Path: <SRS0=SRpQ=ZS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB19C43215
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 20:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 319182080F
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 20:13:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="pKmF+Lr4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfKZUNk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 15:13:40 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37853 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZUNk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 15:13:40 -0500
Received: by mail-pj1-f66.google.com with SMTP id bb19so5248032pjb.4
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 12:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bBawISIpm3ywl1IoRyEagpAc0bn6fndkfvUfk2/PFpQ=;
        b=pKmF+Lr4er9Ma6Ku+o+xcDnzBPZRw2cU1WTZd1A+9tRqTbG8SlDfamMCCnzk93nJB0
         khee6Tk4BoY94bouqpB57dToprCA5iuAOumu+wVaLuQNV1R8JDzwIWQmGZf8lkjp1vmz
         ywHRxzb1drHW7cmijYP8cKEO+vTMHlE8u2J/xSSIuT/0M+mpziwIPrdlQ7I2EEdwroZF
         yAsx9007GUG6ZdbdH7bCerMg5ksnbkpaRe7vOz1LY1LFA3p0R4AHt2jEZEA1O+ET8V1R
         EQkmk6Ar4Byp8UpHDXdtCBsMPOZmcqgh45ZW8HScIGSkxf5bFcgipI1BaYbFFao5zpuC
         J51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bBawISIpm3ywl1IoRyEagpAc0bn6fndkfvUfk2/PFpQ=;
        b=PEgykybg+lcbH9yZvY1h389Y99ztrBOrxQ9Zh6gCjpofYqvaquQg7gnklj8Fe9R56w
         CbUh0YZsYRThBoH1gP/9wdlMP5tDBJUaJBQnwpq7ICzsB7NeC0HZuaMHZ4hrGinwxeJs
         4D7Kq6wc7cXxUEFQWlBZPEku2aoyoRpEMUc+d2LunFGGpGCyRmwdbL4oSF+l4f5AsbVa
         9bEXL+64vggCRFMPE6OrnBjDVzzUkJ1Wg8FK+3pOzK64VwiFVovqJwpmm6JbBJTBg67q
         5ifUEXzTBZxtJ+oLTvzqRR5kZjzFkOmKpRXmgHZwH2mshwdfsAtUYEI1wHLgxVvKMnln
         j5jw==
X-Gm-Message-State: APjAAAV4yrVvZfJv/ZJgw9qOqQMjswzENAb0d9iUo1nMEzZLr+uuDyJn
        gKBgFSnsS+YGYK91U0O7z6XNFznZoLLldg==
X-Google-Smtp-Source: APXvYqwNVLt0LmZY40/kNUbm7edlUYzZi9XXRjpmBntbQ/D95xeauW6ReH0JdXGIxjAA+6jLcVqJFA==
X-Received: by 2002:a17:90a:e651:: with SMTP id ep17mr1220800pjb.74.1574799219281;
        Tue, 26 Nov 2019 12:13:39 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:180::30de])
        by smtp.gmail.com with ESMTPSA id p123sm13802327pfg.30.2019.11.26.12.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 12:13:38 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH 1/2] xfs: fix realtime file data space leak
Date:   Tue, 26 Nov 2019 12:13:28 -0800
Message-Id: <fe86a7464d77f770736404a9fbfcdfbb04b59826.1574799066.git.osandov@fb.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1574799066.git.osandov@fb.com>
References: <cover.1574799066.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Realtime files in XFS allocate extents in rextsize units. However, the
written/unwritten state of those extents is still tracked in blocksize
units. Therefore, a realtime file can be split up into written and
unwritten extents that are not necessarily aligned to the realtime
extent size. __xfs_bunmapi() has some logic to handle these various
corner cases. Consider how it handles the following case:

1. The last extent is unwritten.
2. The last extent is smaller than the realtime extent size.
3. startblock of the last extent is not aligned to the realtime extent
   size, but startblock + blockcount is.

In this case, __xfs_bunmapi() calls xfs_bmap_add_extent_unwritten_real()
to set the second-to-last extent to unwritten. This should merge the
last and second-to-last extents, so __xfs_bunmapi() moves on to the
second-to-last extent.

However, if the size of the last and second-to-last extents combined is
greater than MAXEXTLEN, xfs_bmap_add_extent_unwritten_real() does not
merge the two extents. When that happens, __xfs_bunmapi() skips past the
last extent without unmapping it, thus leaking the space.

Fix it by only unwriting the minimum amount needed to align the last
extent to the realtime extent size, which is guaranteed to merge with
the last extent.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 02469d59c787..6f8791a1e460 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5376,16 +5376,17 @@ __xfs_bunmapi(
 		}
 		div_u64_rem(del.br_startblock, mp->m_sb.sb_rextsize, &mod);
 		if (mod) {
+			xfs_extlen_t off = mp->m_sb.sb_rextsize - mod;
+
 			/*
 			 * Realtime extent is lined up at the end but not
 			 * at the front.  We'll get rid of full extents if
 			 * we can.
 			 */
-			mod = mp->m_sb.sb_rextsize - mod;
-			if (del.br_blockcount > mod) {
-				del.br_blockcount -= mod;
-				del.br_startoff += mod;
-				del.br_startblock += mod;
+			if (del.br_blockcount > off) {
+				del.br_blockcount -= off;
+				del.br_startoff += off;
+				del.br_startblock += off;
 			} else if (del.br_startoff == start &&
 				   (del.br_state == XFS_EXT_UNWRITTEN ||
 				    tp->t_blk_res == 0)) {
@@ -5403,6 +5404,7 @@ __xfs_bunmapi(
 				continue;
 			} else if (del.br_state == XFS_EXT_UNWRITTEN) {
 				struct xfs_bmbt_irec	prev;
+				xfs_fileoff_t		unwrite_start;
 
 				/*
 				 * This one is already unwritten.
@@ -5416,12 +5418,13 @@ __xfs_bunmapi(
 				ASSERT(!isnullstartblock(prev.br_startblock));
 				ASSERT(del.br_startblock ==
 				       prev.br_startblock + prev.br_blockcount);
-				if (prev.br_startoff < start) {
-					mod = start - prev.br_startoff;
-					prev.br_blockcount -= mod;
-					prev.br_startblock += mod;
-					prev.br_startoff = start;
-				}
+				unwrite_start = max3(start,
+						     del.br_startoff - mod,
+						     prev.br_startoff);
+				mod = unwrite_start - prev.br_startoff;
+				prev.br_startoff = unwrite_start;
+				prev.br_startblock += mod;
+				prev.br_blockcount -= mod;
 				prev.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent_unwritten_real(tp,
 						ip, whichfork, &icur, &cur,
-- 
2.24.0

