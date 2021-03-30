Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02890C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAFF0619BD
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhC3OZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:25:48 -0400
Received: from sonic308-54.consmr.mail.gq1.yahoo.com ([98.137.68.30]:37800
        "EHLO sonic308-54.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232020AbhC3OZr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 10:25:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617114346; bh=tUzFRPQCk/k3kOrqIax53zdggLUM9qodvvAwCj+kYE4=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=J/FSRtpWoNQmHfNF8RCQ7IU27cNNvS+WULTjHNDRXPfU9NFQ9/RcrmMiwWUmzKB2OrXE1S20/N7JXzUf75q+no8m+yfAK+P8Od08IsNl7Qb5kvXsGcXpjtIRpKfKwEN91HChIpJaT/SDcbjoOEmhUyjY1M7iUiXfgTCpOY/wYGQTzC3hSlmnfu/CQr4AJxgogbSlyiZkxNlpt1qjnYvdvTKlm3PPlo9Q4ukogr+dkJzmHkgc9cLcxwav9lshpZEvTK2s5SfWaxkERJjw+7UxgBlXlStjwOCpFSr91MHGaEXedP7Ux0hh7soLM55lmOJff75wzcV/kFgnerof1xe53Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617114346; bh=71jth4gSUW+J7lZzpk1eHXF4rhzP3vX9RgjWKOkxHkW=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=IY+Lf9mfIL6R0voicCXR3D7GfVvK4XJGEeU59coxYPv/6kLMFjIPiX3ulBC/IHqZ311197nd7H4Q0uUNQCC7tj6Oreac48RiHFj0F3qDvzPTDtIVp3QQ/nYDkTvDGTNNIwH3jSk9znARSJiuR+EwFShHsuEIaudmevmPMI/Z/Lyw1TCBOEPVq3mccwwd1p9LrCLOjmBvZWjTqWZyXhdwqQWzTBdVh++J7ZLSZnhTBL9AtPYHVJuEDb4ROR8XArK3H/9D3fRdCjJ3haRjGUiNP9Msj3mUX5DBqZk6aiRsa7PB49sYdHPSgw9XUqtX8R8Kc4Hxf9j2kbVl8jglqFTERQ==
X-YMail-OSG: TxfUab0VM1lORk.aUO3q1LywUMiSn02eLr.QQZC1BJzkfajLtdWXSaJBQZjnRFt
 xAmeN5ZeNrV37vacMMhfc0jlZlxPb_52qToHCSI1OX1Sd4Hqe.gSqgngkyzpRLcXgHIb48AsSLXn
 7WVL6v0h7Qhn950UKA1JAn9VUA4BgXutPKjLTPjsax51hkNnllwML1mZKPD.KqhEyNzPD0wLPb9G
 QRtEWSsDywxJhI9ORAL6WU4gN5BvgKpOjR5tD4aiq1B.5iPLdoRV_0QyhLisUXNoHLjHEh2KZozW
 Y2_fuZAj.w_v_Yi8CBxZhRYeTolyE7RNqEnjYkL5OgXEx4IZxjN.idXkKqUy58XNDqoJ9gRmTg6N
 k6R0cMtPztYXjzxjomS26EWIChvRFE1TgVYDGLN9WEeb8OdmHD2qpda7qwQBtRfIXYkBmLM9ApR4
 v68kV0GrhnrEtNt67P2w9Me0PY09Wdh05tbqEvNu_JiXQlyQv6ydxRroqmy9FI4.LlHu9Wwcur.A
 cCfI8pz0Vb2WgpKKxXXiXUYn74LdsKkQq1JBi3EQCuAuNhqT4xee17JxvhbJ2UHEmzD7r.SuBW0t
 IulVyR4oT7KKRC_os8AQqnaCS1h1uHahWfHKfKNfcuAA0CIydLqRvve2EkiXtxPG_Gtnfm8tV3hZ
 aPaxnazKYSojNP2c6iMaBbMVwjAdSahVlPwUB9EBzgvkQAM7QcHu71O4SAJ438mnNWdufjnJoETy
 fvagFoMytW_6mXiRd0K9bfZKWfsxUU7.LmJ33kcI5ZNy8_kDIa2aBOuybHRX_rsjRIToj5zK8CfY
 W9LVy2vnfbdsh8KIv2CrGm61nm3e_MhOi6rKE1banGH8OI5gW1WO4Yaf.bdn8BMogve8dvEcqC.p
 lGBqT3PStOkJaoQbduZl6hqgNSr75L1tzL5LKts2UPhl2rmYCMsXZo.WtNpbLRJGbqjR.X9kYmr7
 7O.KY6zyWF1Kx4VPoI2JQJ_9gf9PYoQZKxb2W488pc2No4TAZkJ.bLJALJsv7U0W9vjxyLQ0DxGp
 JoRiQ0b5D6JUEJySnwj.fEUe0l0D2gZ9LlzoB6QpdFHFcfwr1PUW36oqvNlMC0q55vmFYgc01HCU
 3wrd9mEBmcqhK_WK.SWQRNtqZGwZRtfWjanbZ4nCWJfjhHspePrNqoSRgMlcjfG3xEexaCgeWXgu
 6e6eADPQ87fdDPeIVIsUxBZ4d_yScKxqW5vjJwvN19QNLfp3DexHQ3I4m4Yy7vzLnsXdK1sIis4E
 e8WvOKafoJVNJIPLLzoBqf6z9wBhhReYxB8vTCch7wKSajQ0_tedw5NfWHlzgMr8k8inMiLbS3FV
 kCALK4Z5sfpfcTmbVq8hfWQR65rOKfwdecMT74NU4SfJvMHEqjeTH8q4o6Nl2yOHqI4rgTL3PE94
 tKIm.yGAGGUUUNRzxJKwXREI.63HCDopc3byuUAuF1jCSFHFICUsoVtwL5Kn5ObnDJeJ.Bs.W_RE
 BYvDBWkM87t8nJbUDU4Y4SFdY0DjH5gTY9KFnYgaao3.C773BGOEj_z3werDGH5XVs4w5kmtWLCP
 LXDXkK89WMLhEHWcjPyqBTJX95f.jiHXR5hwysAVDAgrJUiOxGnowt_5cUBnSG42qf.xLhUgVIgH
 hY5zVZ_M2qcoRnfuP4ZzcsID3gZPIURodC1QqefynTJE56gMokPeVjLQZQPCNK2CkTFZnkqkq3ks
 LhKL86aMTjE5qQ13XggRnIur2u47UQDZFSbhDm.mSKLaxKAd5xUxl5EdiXx4rlR9gk8g6pPhRbDu
 zS.RNYkHPqYRE_pohc1iB2lhtAGA8nFJ8ChNa7wZAkXIdTIKdjoEWYCz6sXLjSwfbLc9xpFjr3XV
 zrfMnHiehA53fSFkr5bAFehALgHYFxFPUEc.UOFC3z5k0cR.tdNAGVRb23Fq1mLOUjZQoPhZQnEj
 a_CMmJG3bMvDDC5VKAUdDP6bYyFizO6qVV9Ldm4PblyserrdTtHN7kJvG9IGLHui7jcVsxAw5NCZ
 JtOGNLvILshAnGddJFQehMMxfBFRlPj1zRo2gp_i3p3zRsodtBSyrm9LeajM2emflae__ONUkGZ1
 h5FVaAc_j0A6Ifcukjt2kFp.tZPClETfO5mjJoAw4coxXARTODprvs1hQo2Sc7bAwrz_sIQqn94O
 IcDv5BflVgcLmEClG9IgwK7sWJuyU5xYVvBEDnFHDxkKaASZ8bn.QIY2oR3GJw11E_wJ1q2mmWA3
 c5xt0RBkLOewqryhQtZjPJdeNwh.zt4oMllr2BEgtYRPuk3Ubtvkob8254K2CrSHW3YfqCoLHYcg
 HpdA_BjOXIArJvVzF3UaQCksIVdqC78njjv1uCk24SREONMme9XSBIwX7n61lKDzt8IsBQLnvnFI
 eCQMQ2XDZps0tj2Cajj1tyDvVMLUPIskCHx.EXj_sOSyRCXAyMYkumkwMSV2tjlYdiCnNVjltd9n
 JiIWvmntpoBkxeW8C9TSgZWKD0ff1bVMgx6V0ppMsXQIMZXI_8Q53e.oQ2stN1V.CsvPA0qBzeMk
 XQ.xuONUZNk2c62tEndFoAA--
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.gq1.yahoo.com with HTTP; Tue, 30 Mar 2021 14:25:46 +0000
Received: by kubenode575.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d17ac850f756223f45b54c36ad526fbe;
          Tue, 30 Mar 2021 14:25:43 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 1/8] repair: turn bad inode list into array
Date:   Tue, 30 Mar 2021 22:25:24 +0800
Message-Id: <20210330142531.19809-2-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210330142531.19809-1-hsiangkao@aol.com>
References: <20210330142531.19809-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

Just use array and reallocate one-by-one here (not sure if bulk
allocation is more effective or not.)

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 repair/dir2.c | 34 +++++++++++++++++-----------------
 repair/dir2.h |  2 +-
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index eabdb4f2d497..b6a8a5c40ae4 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -20,40 +20,40 @@
  * Known bad inode list.  These are seen when the leaf and node
  * block linkages are incorrect.
  */
-typedef struct dir2_bad {
-	xfs_ino_t	ino;
-	struct dir2_bad	*next;
-} dir2_bad_t;
+struct dir2_bad {
+	unsigned int	nr;
+	xfs_ino_t	*itab;
+};
 
-static dir2_bad_t *dir2_bad_list;
+static struct dir2_bad	dir2_bad;
 
 static void
 dir2_add_badlist(
 	xfs_ino_t	ino)
 {
-	dir2_bad_t	*l;
+	xfs_ino_t	*itab;
 
-	if ((l = malloc(sizeof(dir2_bad_t))) == NULL) {
+	itab = realloc(dir2_bad.itab, (dir2_bad.nr + 1) * sizeof(xfs_ino_t));
+	if (!itab) {
 		do_error(
 _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
-			sizeof(dir2_bad_t), ino);
+			sizeof(xfs_ino_t), ino);
 		exit(1);
 	}
-	l->next = dir2_bad_list;
-	dir2_bad_list = l;
-	l->ino = ino;
+	itab[dir2_bad.nr++] = ino;
+	dir2_bad.itab = itab;
 }
 
-int
+bool
 dir2_is_badino(
 	xfs_ino_t	ino)
 {
-	dir2_bad_t	*l;
+	unsigned int i;
 
-	for (l = dir2_bad_list; l; l = l->next)
-		if (l->ino == ino)
-			return 1;
-	return 0;
+	for (i = 0; i < dir2_bad.nr; ++i)
+		if (dir2_bad.itab[i] == ino)
+			return true;
+	return false;
 }
 
 /*
diff --git a/repair/dir2.h b/repair/dir2.h
index 5795aac5eaab..af4cfb1da329 100644
--- a/repair/dir2.h
+++ b/repair/dir2.h
@@ -27,7 +27,7 @@ process_sf_dir2_fixi8(
 	struct xfs_dir2_sf_hdr	*sfp,
 	xfs_dir2_sf_entry_t	**next_sfep);
 
-int
+bool
 dir2_is_badino(
 	xfs_ino_t	ino);
 
-- 
2.20.1

