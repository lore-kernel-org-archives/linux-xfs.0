Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE547C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 764B8206CD
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:01:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jkdfx+GN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgHaNAz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgHaNAl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 09:00:41 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30681C061575
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:00:39 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k13so2972889plk.13
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SuImZV6KQxIArM80WpY9EThnbpHmDQ0UWY+LTYjv8tc=;
        b=jkdfx+GNzRc51Si7lXDJ0p1olZN9L9iKW/ff37G8ICFPeahNFKSXeK+9kHkIDDXaWl
         wLQ5fbcZzXwVqBVWvgi+9tU0/6vmFpPO27HPrnB+3SOXeC17rdNj3KrZDtJW0my2g3HB
         WWrd6LyVuhm590cjs7lcdFFfufQplQJtQYZdmUzeXMzccYEQCUwKBySeacUl7yQ0kVGH
         oqlILoAeJaiAmvV3v1HSNK1eMvdSC9brC+prGMDTL9fj8NfGxv7SPhSUv5WSRX7KGGAc
         5icnr3421R2CEfGFnA+6TuvyReJBx7o9+xNfFK7O8OyH2DZhFy0aK10JLJLvB9R7/kF7
         O/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SuImZV6KQxIArM80WpY9EThnbpHmDQ0UWY+LTYjv8tc=;
        b=tz05ahEzC1u/LNVaEIZMFn/qUujKpUminPYN7NlPuKzkp3ocbm61QLCPIXCh0d9EvD
         /aKNSOAFFFZcCaw5LwhXSaiAn/rapJF7VMTOdJ+AEeQIyEt0B53rbq8HCqwPJrPcvpEt
         BIg/k4++aLu0m7iWVX8zTdJs773hbndNwWxMsAhDWo0RnhYKaRNE8TDQrJTd0zyq7G0+
         mUnb9etnyUTtNFcb1D87uUH3t1HH0yBLHHlA9slHEXMKfWcv88TBXVApWjwHDqYMCgzB
         Ad93iN+lWTxEkqu5DFbkZN28b4p08Ly6zwKtpE8wIVN0DkUtVTMtqm9rcpErLEbG+ycq
         K0xw==
X-Gm-Message-State: AOAM532/DCz+LTzAUb819MJFN0wF0nsNBAXe37oC9OnmqVcYBEBB79uB
        Meln9pYRPiAez1NbpDcoaMgtRDHS3Tc=
X-Google-Smtp-Source: ABdhPJw3qGn8ecnXXUzkkspe/OHIdrBp+1RNo2cCPqSupDmAHthcVf5ACPiS2A+VOmM4mQsI3KPAzw==
X-Received: by 2002:a17:90b:4d10:: with SMTP id mw16mr1302532pjb.100.1598878838454;
        Mon, 31 Aug 2020 06:00:38 -0700 (PDT)
Received: from localhost.localdomain ([122.167.36.194])
        by smtp.gmail.com with ESMTPSA id p190sm8296130pfp.9.2020.08.31.06.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 06:00:37 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH 1/3] xfs: Introduce xfs_iext_max() helper
Date:   Mon, 31 Aug 2020 18:30:08 +0530
Message-Id: <20200831130010.454-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831130010.454-1-chandanrlinux@gmail.com>
References: <20200831130010.454-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iext_max() returns the maximum number of extents possible for either
data fork or attribute fork. This helper will be extended further in a
future commit when maximum extent counts associated with data/attribute
forks are increased.

No functional changes have been made.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |  9 ++++-----
 fs/xfs/libxfs/xfs_inode_buf.c  |  8 +++-----
 fs/xfs/libxfs/xfs_inode_fork.h | 10 ++++++++++
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index dcc8eeecd571..16b983b8977d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -74,13 +74,12 @@ xfs_bmap_compute_maxlevels(
 	 * for both ATTR1 and ATTR2 we have to assume the worst case scenario
 	 * of a minimum size available.
 	 */
-	if (whichfork == XFS_DATA_FORK) {
-		maxleafents = MAXEXTNUM;
+	maxleafents = xfs_iext_max(&mp->m_sb, whichfork);
+	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
-	} else {
-		maxleafents = MAXAEXTNUM;
+	else
 		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	}
+
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 8d5dd08eab75..5dcd71bfab2e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -369,6 +369,7 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -390,12 +391,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (whichfork == XFS_ATTR_FORK) {
-			if (di_nextents > MAXAEXTNUM)
-				return __this_address;
-		} else if (di_nextents > MAXEXTNUM) {
+		max_extents = xfs_iext_max(&mp->m_sb, whichfork);
+		if (di_nextents > max_extents)
 			return __this_address;
-		}
 		break;
 	default:
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 4219b01f1034..75e07078967e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -153,6 +153,16 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
+static inline xfs_extnum_t xfs_iext_max(struct xfs_sb *sbp, int whichfork)
+{
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
+	if (whichfork == XFS_DATA_FORK)
+		return MAXEXTNUM;
+	else
+		return MAXAEXTNUM;
+}
+
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
 
 int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
-- 
2.28.0

