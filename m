Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B25C4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFE1721531
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="T3fFyD3w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgJGOEw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:04:52 -0400
Received: from sonic304-24.consmr.mail.gq1.yahoo.com ([98.137.68.205]:39426
        "EHLO sonic304-24.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728469AbgJGOEw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 10:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1602079491; bh=PF3NlLL686qoRHiEQmKC0PRCUmBeoYYPFEdU023sH6w=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=T3fFyD3wXzVA+nqjxN+8TD0AE6O6gaysfapRze6uIaU4aTJNfIysbqGHC+MWb7FYyqDPRxUXX9JZp4Y/bYxsVBGv1jEA5m0dzOmyGiq5vhn6qdABN6LPltt9N16KjfHDwXmCAe/milkL7/ALZeZ/9tVARgQu5TuxNg/yz0LZ5D2jay+byYJchlRdKDPYQd3STFIT0nrsf9kbkF8XjlCNXgSa3UHvO9QkJSPJyeSOnGlh1dk/omspofgTVn20L8lBNaSkqgViZ9PMn5hMQGQuYreCYk0Os8NDA5YEHfD73BaBg8d9N1B0CfYpkznxJgeNPCmASFyKMhTCU+tivgTEfA==
X-YMail-OSG: 6AVkQGIVM1nWcsC7wlwewqxm5BH6VaHe4gIfdudwWoMuK31205BLVRBGNZYbyrK
 Es66ctryDZEThiqaS0zbr2m.FjApn2MOWzEfP4c_OxorB3sMx.u9ctdEDmLS4NVlFt_1bW_qfo6d
 ynBfTHQ_0t1LYndq8IwLmGW5mB_5qCt5nKTrOEWcl_LkadjEuQiXAvV4Qon7qDi8322YsuJMwFOc
 Tp7IGpimGWrbR_AZynhAl3aOidMnprcsiJT97R2EsZ0I3V5SfolUvNbXsGgB.kiJxJRiBvY_X0vi
 T.BrHR3LfERM12GugqsSVKE61JFw5Oawd4nSu7XpK_UaOi.LJrvamBRyc5Jm3bKDr07EsSHDjGtz
 gTLfc9c3YhGZassUdrrjsHTwlpCZrNh6PZCFzoHz.d8a93AgVx8bcZCNcIc_iueoPE8hOwx0f2JF
 YlbmP7CM7rq0kNLgY3B_S6h7RkLR9Lz3moIp2c18hZBdkAnThsqRWLTvjWGjXCbm38mrl02MyimA
 Oee55ocI09i7wIjupCRvRzBOZmuE_BkH28Jyjri.4yDbd9sxtvb.ElUmeUy04tSzMJmLvbz9Q.1R
 7qCv9vImnU3J2hIz_VhqWsaFXS4oX7pftf3HdiBQqPO99ofMQB6R63ijXMvzUD0t4pjgN8o7zcls
 M8KVbDqSq_zEDH1TdE1PJ6liJiU2foYBaSuQNaGLnpF2sigmmR_X5xo4zySc6zYx2aL6_5r4tcVB
 fF9ryD4lPXDtmchk7hZlVWmpxCE7.YQutILpsXuYw49OsSDwlQ8aL8wWsonI96Pmbs_s3tMfTvRM
 lzGrP33fRMYJWqKFAnMYt95hd611xUh2vkAFWbtY_6uHLB0xU8dkDmUmJDUYpkA9xG9yJFVEMZJq
 kcaJo1THb9.JGTTqCb4TK16JN2Yz2gPwL8UcSODKH64LGbzkIBswwfF6VsBGqiLjBP3iAq2X6a1.
 nnl9kJqfinP3TzRZA3MTkDfkNyR1_LLxLQjxVVPOpVNKJ5uABfw4sPOPTK83YhZ6NIRx4Km4w5JE
 3QiaK5UkACcTzJ_AqcnhCv9h8vdVX4WosCJlwRatncGW5VTpk6f5DG.tXGyF8UzDAOuQlT5UcHCY
 Val1S.WXCe3IdrGBd0trDWeogXsxcDlcH7QdUQhCXsVYMVExcKCq.MFU1tDKQN5OsHvJUI6gj8y8
 .SKqsm.jRcrPr4cAXiyWP8R9kkwkbs43tXvP6D3pBWi2jgTiWDiNirfc7YdeKub2wFkec5b..v2Q
 t.d5LJ0sHPSinL3wz20mpIQuuLLOsR4kK3b9peiIABYbyO1NJLlv108.v5AGFPwF5SDfFkdsvFB2
 7kg6v.Rk4yIJ.tSAOhbJtVmEOcAJj5BV4eizIHFrpAt_05Rbz96anqdKdnZuXfnHJArCHniWABvV
 i3xgFiU30nxgYZ5Z02WZyqh3iM7PrcKvQvB7qXzNl.Xaz4vPmeWmhWcy.YJOfSJLg7X5VM8ok39V
 weZA00cPSvVU7.y1gNstGfjDKxQGWemKdCzZgQb.UrMNZeX3Oclm87I429xKU3lEO6FOtCm.fCul
 oFGh0lEQ-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.gq1.yahoo.com with HTTP; Wed, 7 Oct 2020 14:04:51 +0000
Received: by smtp404.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID a1aacd19ca90341b10418ab97793d328;
          Wed, 07 Oct 2020 14:04:46 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 2/3] xfs: introduce xfs_validate_stripe_factors()
Date:   Wed,  7 Oct 2020 22:04:01 +0800
Message-Id: <20201007140402.14295-3-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20201007140402.14295-1-hsiangkao@aol.com>
References: <20201007140402.14295-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

Introduce a common helper to consolidate
stripe validation process. Also make kernel
code xfs_validate_sb_common() use it first.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 libxfs/xfs_sb.c | 54 +++++++++++++++++++++++++++++++++++++++----------
 libxfs/xfs_sb.h |  3 +++
 2 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index d37d60b39a52..bd65828c844e 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -357,21 +357,13 @@ xfs_validate_sb_common(
 		}
 	}
 
-	if (sbp->sb_unit) {
-		if (!xfs_sb_version_hasdalign(sbp) ||
-		    sbp->sb_unit > sbp->sb_width ||
-		    (sbp->sb_width % sbp->sb_unit) != 0) {
-			xfs_notice(mp, "SB stripe unit sanity check failed");
-			return -EFSCORRUPTED;
-		}
-	} else if (xfs_sb_version_hasdalign(sbp)) {
+	if (!sbp->sb_unit ^ !xfs_sb_version_hasdalign(sbp)) {
 		xfs_notice(mp, "SB stripe alignment sanity check failed");
 		return -EFSCORRUPTED;
-	} else if (sbp->sb_width) {
-		xfs_notice(mp, "SB stripe width sanity check failed");
-		return -EFSCORRUPTED;
 	}
 
+	if (!xfs_validate_stripe_factors(mp, sbp->sb_unit, sbp->sb_width, 0))
+		return -EFSCORRUPTED;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
@@ -1208,3 +1200,43 @@ xfs_sb_get_secondary(
 	*bpp = bp;
 	return 0;
 }
+
+/*
+ * If sectorsize is specified, sunit / swidth must be in bytes;
+ * or both can be in any kind of units (e.g. 512B sector or blocksize).
+ */
+bool
+xfs_validate_stripe_factors(
+	struct xfs_mount	*mp,
+	int			sunit,
+	int			swidth,
+	int			sectorsize)
+{
+	if (sectorsize && sunit % sectorsize) {
+		xfs_notice(mp,
+"stripe unit (%d) must be a multiple of the sector size (%d)",
+			   sunit, sectorsize);
+		return false;
+	}
+
+	if ((sunit && !swidth) || (!sunit && swidth)) {
+		xfs_notice(mp,
+"stripe unit (%d) and width (%d) are partially valid", sunit, swidth);
+		return false;
+	}
+
+	if (sunit > swidth) {
+		xfs_notice(mp,
+"stripe unit (%d) is too large of the stripe width (%d)", sunit, swidth);
+		return false;
+	}
+
+	if (sunit && (swidth % sunit)) {
+		xfs_notice(mp,
+"stripe width (%d) must be a multiple of the stripe unit (%d)",
+			   swidth, sunit);
+		return false;
+	}
+	return true;
+}
+
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index 92465a9a5162..015b2605f587 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -42,4 +42,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
 				struct xfs_buf **bpp);
 
+extern bool	xfs_validate_stripe_factors(struct xfs_mount *mp,
+				int sunit, int swidth, int sectorsize);
+
 #endif	/* __XFS_SB_H__ */
-- 
2.24.0

