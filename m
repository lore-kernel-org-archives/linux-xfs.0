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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D60CC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DDC0619CD
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhC3O0U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:26:20 -0400
Received: from sonic311-23.consmr.mail.gq1.yahoo.com ([98.137.65.204]:46708
        "EHLO sonic311-23.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231918AbhC3OZz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 10:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617114355; bh=g5Yh0t0Afn9bSkRtW+yjgi1tpm/Hm7TbP7PeiMhsdm8=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=GeQZMhaL8EuSovwlNBnEl4SRtIy1UzXJ2Q91G9Cb3xelHcCOQ2/j1HHiVQ5EgodClvQm/yTYJhy7jIzMQ+jRy0exUY0ONPosHg3PyfZBqL+ReLq7XnYZAiM2N1GY3g0smNSFnH8ebUkXTA8f3IpK8EQEytZsjzNwtOU8JGKqZFP+Q1Ohb7UOzigNZ6DLR6cAkaePx/mkBwugcoMkzs9nMKmOLH4HWH7Pm5L0DhxV02nE0ciY0xTVH4VfKSWqj6JLdmI2NfvwPBBQbztZijlTtdAgj0shWP6B0UHeEex1HEYOId/kZKwbu25xWU/dNMbWk0hnQXnuf7nfXyBTSn3AvA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617114355; bh=aFDRp30xRtKwHe/nZkkSpjM1YJcKB9AxgIq9YKpgv8z=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Uwf+xbmN+6MDc56MMTqJr5iteJyZxHRLns/ieXPTgFq08y/c16sWpg1w3QbFraMNa6u9N7vVJ/KQczclwxhQ3tKhxILe70LN6Tmu6BlB5tOwSlsxAm+5ZTIhg912NrADRYvLnX1eW5M2zwwnF3JCCjnX7rQUIbToiaHVVdVKn7hwqgvkn5DY8MMZkKlmb8fdBtn3zh5I6lgkLpMeSP+noDOO52vg23/L93G1N3Use7jNeDPVwaQQpHK6Zk/Gzr+T26LAAviQnV6N1m8LuZwPySPClaCv/LBII04zL1CeyluET6XBVHvhpt8lOi6di9Mx3xpvdPiYydHFuwZYPP6PIQ==
X-YMail-OSG: X7hEIRYVM1mTaQET.MDNebYNTp1m974MY502dbhWFypx5RwSEjiLOQtnA4YXF6l
 uDQE0Yj6f3PX1puTJlhCBQ.ittzodb6lZIDmA6qhnzXChURCLKm9tRFOQF0kDVoAsOvOoY7wd6.m
 rlwH2ufw7adWcwD4ze3qwhGi9A5nxlzSXphqAXuzSeQQ0Rs0Ney1ZGWdpUnoMwDi2f6SIltbwLHC
 EmBdXc656AwHTxhK_Ay599ukdjimodzSDXwOIhwGop5A9sii.FlUPDiW8OixWRrCdMLbfS_OPUrE
 uVfDS_p.0GOt.lVW_2x7CbPWjxA51oYBslJ66FWIZcmqV93.T3wSeXBRRCXzaKQ4vzHFG89urwt2
 9eB6XBbhsx94Dupr06G0La59aHt6LaIobUONosFhaloyyfOLjbWp8vtefnk.2klRLj_l_aS9qazg
 nwOvFf35U7go4w8.yr3NBdim19D4VAUJ_GFUJvIYdpIUeyroRbLuWoTvYdv_NCq6s2q1l6PdhpRM
 JxEPyQP7rLQr2_q3QcgLOzNvZxmV7HLNKXnj.L1RStLb8v852GpspCzIYqqMps2UWosHwX3TV3Wu
 V1SXR6_FRydDzMFa6ek40Npi5PAH3FHlrn3cpp3PdzGCFjhrssjgB8nUag9z3mBGG6qOVznN59eR
 vRYAku6ULP9N5IvuYX01C9lXeLldlQAkFd1v.ZEsHKooIZmmf4la7_WGqxXROcOuOav394J4_VVv
 ZfWTebVuEmy5A1V5LaDcUUlwJrCOGYxcKgXzVe8fcqqfTU6nFICv5388GSYc.BGoIulSVKVUtU3p
 W91XR9uDgJ1ZR6jODHzJCCm2QTEF5Q63B2EoveYErC6JFDtKL5Gu9bCv0_m7mOVKeBWkohNaUoCJ
 2AOHVyRTD5rR0oAqDn50FdFKTWZWr8NhUGnXyzvV74D7x7rAWr5jjXvMphib3jhF8G9M3ZAWcYbx
 MN.aGX4D2MHkSM6kqS6lTN8FXCR2nZMOJWVhmXcupslhE_XX8Kb4LZcyHhOqR3496wlT6Cfiop9T
 kgtZLyORFDYSEeDT9BsSkYOR22tYflq.SIMNnAyqYawGJht3J2PFxP2rC4wBwS2maxluWSSlMGtW
 CVoPwwpLv8b9K.q.FopkiX2OpRhzhQODbX9HLI3HQcbQJgl_wjjlapBbFV1nbli.JouSI0kcPnmx
 _V5HkJ1PMQQunyIA31PV10wwVcC83H8uDB5LfDOfXJHj2AZI4U8z_0Gfqv4_6G5Lpijmlv8Khi1l
 Q8H3JhJusYHNodVWVLrxCOs53e5QUhtHrE6jNfvSJzWqC8NDRf6cvjWl.SsMrbg2pestUE9K3g2W
 y0hnTf0J5rQvSVnuG2A62Tqz3lV1qIqqHdW3cASinTQZ_oYTaTa2mxAhNAe7wj3NGFAynlx6Yog6
 7FfKb4E1LZH9Hq4G54vbacr95rfu.dzPvvIf40Na8lhmvSX2.m1RRpgG9TY8DPoPljw2yuWdrSVn
 yJiU38ruI9HormtbImKYE3RPwa54kFDfWvKqNw5tKSkNhkgxENFBQzh8Jb7xMHzwBEMnmNL_CISB
 wIGI2FHsIrA8Ot.ZVTgKzGPwdDW.3z6pi1h6_ReUXCfFQnppxcgC_GqZ_iDqnr272w9C3gb6Su5O
 j1ZdV9sQHyUKhY6sAZZS3JkDdYXTVkeGfks_ojutgAndJyEjkb_WQqPbmnmt9RCBNUUiNQqY2ZbH
 aAv02InWxaZwiyMIRy_6Q6Uo3i56tFQaKGFRZs..sR79EmQqCUguYKN5vcXlfLCAGmSbDqb_fjdK
 I1C8lAzjvGtbWeF18B8Gtgg.YhMxgV3NB2DfrqHVyN3ar3MTEpb.vV3STeniwUwwGLZdGn_58qZI
 K0YGnKpmNv90iYu9ipJY7QFTPLZwEhnKaqciq22vOZNPvqvms_4r9i6dFdOlZZ3ETzbs2Se9MfqJ
 V46icTa889UAn38.r2H9jFr1j3Gc9yMFq.MBDtrRTarnIrZjqmnBaz8oDRl584aXYBxu3b4TjIJi
 bWMLW7Y8Nxa75ZSmFViG1VTHgZ5vd9Oz7Vc7hSdOEHdHxeQBJJNEZBWU_mMC3LrqbNlQLCH.p8r_
 eBJwfzM4bDVyb1vxpUWDwa5YQ1NWXKpVCX8w8QJK34UpEEYAfpJLK.SH2ezc4fJX0TOc.GaCkqHI
 OJmjRuHqcyox.nGuVPZ.sfjtL1IHVXN7XRPBjYHh2dNp_QX3_fbo5dKdc3s7vHh0h2yX1gMH46tb
 tM0oS71UFp4S0hSXZKJ46WVcgcC5VtuPod5uAdQjA1Y6haylIcbCtHBa4n1UuQmQSQ4A6Jnj2OeB
 zUmk2ufny5bqjzffMrvKCD6x1nC9I_dHrtYcT7u9qWhEcR403ZJdTVh9KLj.Ra0En5.CPznw2Eur
 Cu0__DtCfsl9UbQyVjnz_sBRulJnG7r8Y7acIxJu1BY8Vm_n48UadnGr5bfLmSBJY3NguGFD2gtz
 q47Imp.mMe3RpcROBQudnRu4ad7m.b4jgEScQGVLGSMP5Kj5VcpbYTrV9TdaeQqKBKF1Ibr0Mf3f
 qd1Xot7nmvG4QuPI33Mj9nBNE.M_eVc.L2gRCUaKbkiKB43iRF.sc9FSv9SrUa_pFD08X42lYyrg
 QAP8FABMmnANOoxghZEeoigFVCORWmIbrgtT9VJUXSw--
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.gq1.yahoo.com with HTTP; Tue, 30 Mar 2021 14:25:55 +0000
Received: by kubenode575.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d17ac850f756223f45b54c36ad526fbe;
          Tue, 30 Mar 2021 14:25:50 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 3/8] repair: Protect bad inode list with mutex
Date:   Tue, 30 Mar 2021 22:25:26 +0800
Message-Id: <20210330142531.19809-4-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210330142531.19809-1-hsiangkao@aol.com>
References: <20210330142531.19809-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To enable phase 6 parallelisation, we need to protect the bad inode
list from concurrent modification and/or access. Wrap it with a
mutex and clean up the nasty typedefs.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 repair/dir2.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index b6a8a5c40ae4..c1d262fb1207 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -26,6 +26,7 @@ struct dir2_bad {
 };
 
 static struct dir2_bad	dir2_bad;
+pthread_mutex_t		dir2_bad_lock = PTHREAD_MUTEX_INITIALIZER;
 
 static void
 dir2_add_badlist(
@@ -33,6 +34,7 @@ dir2_add_badlist(
 {
 	xfs_ino_t	*itab;
 
+	pthread_mutex_lock(&dir2_bad_lock);
 	itab = realloc(dir2_bad.itab, (dir2_bad.nr + 1) * sizeof(xfs_ino_t));
 	if (!ino) {
 		do_error(
@@ -42,18 +44,25 @@ _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
 	}
 	itab[dir2_bad.nr++] = ino;
 	dir2_bad.itab = itab;
+	pthread_mutex_unlock(&dir2_bad_lock);
 }
 
 bool
 dir2_is_badino(
 	xfs_ino_t	ino)
 {
-	unsigned int i;
+	unsigned int	i;
+	bool		ret = false;
 
-	for (i = 0; i < dir2_bad.nr; ++i)
-		if (dir2_bad.itab[i] == ino)
-			return true;
-	return false;
+	pthread_mutex_lock(&dir2_bad_lock);
+	for (i = 0; i < dir2_bad.nr; ++i) {
+		if (dir2_bad.itab[i] == ino) {
+			ret = true;
+			break;
+		}
+	}
+	pthread_mutex_unlock(&dir2_bad_lock);
+	return ret;
 }
 
 /*
-- 
2.20.1

