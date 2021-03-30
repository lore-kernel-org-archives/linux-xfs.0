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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFDCC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D948F619BD
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhC3Obq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:31:46 -0400
Received: from sonic317-20.consmr.mail.gq1.yahoo.com ([98.137.66.146]:39677
        "EHLO sonic317-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232007AbhC3Oba (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 10:31:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617114689; bh=9D2qw1lU79Cy2El0txzMdRItqLsk6Sg9RDnGCQnPqmY=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=Snictr78S1cJFWTLmruc4HsDj7tRaxKfODURYPiuuspEXGnLB+CDCFVdQsFS+bHh052yRNzKfxIqTdY0DM95OxyhWXPvhKqlan3sjifN/gsG0BIl/YcrwR7btetMIS4KnjHJGL0u5DSFOcq+QWdHGb0EE3KcWC6vHfAtqCHk7jrlphh0/xcTVGe6b9oDtXpU5amAUZcIbMiTjNlMCynj7OjKdu0YHqKmT0KDUUQJD+978NkzFIp7rmoBSoob5Bek95Ve7Tr9qvwsTAHMnYUiW0pKB30x7cJ5pv0hITOd/sxdHmLDO0IgQeN0jgUFIrPq2nTYxlNcJ3uXjB35lvXJPg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617114689; bh=lTGRo+wboJm4UXCFBbQbDVs+mEhF6mTwZLTJWCS6ATK=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=WBMOaXGsOye3fNs1y8YW5qPOQrfNu/OmF5tPkINxKXV0FObo4v7t6gl+pthP49A0nl/bq//q2ZHvXbrj7iNCOKguXX4EwC6xdP4e5cJ66Nh2uvhdv0aZ4ARplAdz0zY3bYwV9yPwCyVxQ10HT79H+5u5OplCd46ktab5fQOKO7teAeNrHbUnFxMnGHr1BTaFx1oBiO6mt8ERpsuMTrrMSSBa8lzvl4/fHZE9tz12igIFBtK9tkF0ptCfZzjTc4tNJnAA5nNLviPM7Pup7cCdixNuLUIadmVimI1loFbzkKZoR92rsMPMJ4SiG2Ya3iMC4EPyz61jy+bVBvgQyhrqhA==
X-YMail-OSG: PGRzGugVM1nfThQ3d5.PFdoMOEKl3Dkb.zfD7V82IgCyNOUEQOPaT9zo9xQTqHI
 eOhN.v.WM_wdwySiYcwZr2YfMZjd9OTSHLmUfbMkEJG.Kb6oaJrQRdMbKiH57eNHYjaekIAoQSYf
 WCz3NrZvS1pOZMeFK5garJr_oQEFrLBeb0dwSNdyxvu4buK.M794VEONVpUiFLozKQhkIzvguFvU
 9jDKyxcmGK40vkv4P4cUJQzl4o5F5ISGMr1dEIRtsnkggmmczpL3JeshjF3WYuDZWhnCV_.oNfEF
 5vqAvQZJUeqXkk.FRK0pEkpN4qdezlw6TJ6weksQQ_5Yc0PWC3DS4z_kulL1rbBRzSoYRk8zdfTZ
 f860qsftAuUsOUy.45II82DrqISAu7plppnJ8XkD3vcpR7xljGtiM9Yv1q_.EdgQi3lLP6FHkgRS
 j_Uwqvf6AfwHlsKiU9e0P5f_PpWFQYoEpMHF1YpkP2f48Q6rGzkaCCvMCycAQ3NfzQ2U8_FbKfmA
 rhf_feorIMwXCxM87oNBmxs.9KOz9GquDUZb0CrvA8IQ51e1wLubhNVnIFF1E6C6dOSGSJRWumMq
 K6UZhXKRz6n10YjI67vN5mEgL9YGch2T_5Zs.FgiX70SCGr0YzGKXw1lBPeLqijawgwcj5uAjrZD
 rXFg6v1p9RpNT6uO8a8zHYScki91vofwuUqIBtnGpQIbFiZoDZx0EwPsd2UjzcpaiDJu3pnht0zX
 Hmv.qAsHKJDnmnc6kN5C2MBE4MqvxLF6PBONwoG1t7KSdXSWww4Ye6Cr8FlxeK_dqfB5.x7lWk8z
 nMwY6d0GdzMyuz4Jc_orCCKIeqo0DYJfCXibbFHNjJgjelD_Mc4OLVHR1lbevOTaGTA8._T4WR74
 g2AEcmBSwQIyDp.PA7aFxfXlpLI04v9sspke83yrNlrUOIqMxhGhLj.9EAjWcNDfziugwkeQMCL0
 o3KgzW2W8T36yLorXweGPZYZ8DEdTgByaZEjtvocgjY17WERRH2NAKsyUa6XpSYkASg7aWN7PYpf
 S9hC65iTxrYzjPETc3D9A5rK7_6jJqCmtx51gNZpuLsKMDPiDPoOa5I.WA0cxjUMqyQt8..WJvtq
 ZQUBSOwMOZlPmks7uET0saF4_pV4OwWZahyBMxeoSA24GNqUnXAGPqcrbsQ6FUUFJtj4CCaw5l_y
 s9qkxFcjeIjcCUzWKVyznxTJT91TXPfmpDjhGXdd5b7TA3JE.Ki7BKajOp69RnZMpXgkwELR7ZAW
 e_mKB9Jse4R1Xlez8xa3afQ_qfGn3b3dR1u35sslG4BN.aNoGo5IGOdyCDCMi3vw7OUXUn_Bpr5F
 fPHrh.bNOOVagF1PyAUNbA2t96PFafOisn3.kmLwGiKlNNjKEVhEwJ6ujgK2A9kni5SMbFSfjjYK
 OhrF99geujj0uczzJdNT_yWQ6zObGhEmUZESqf.ZueX7xgHYg3hJi9_7m821S8TCHVvngj36FVyr
 6nnAt8sfHkEcwqvn1lueKqQG96U.bgpBqkz5v2Jo9cMtsyuvHbaoMjbirOjsHW2u8oSMKzh1teM1
 lUMGvcWCz8ixyj2z.kBjF3zqjxT3Tvrr3zKBYdErqsn9VkFhC_gOe1BhNAh.5p.jMWRNxgZ6TDFe
 2C8OfDULJlk4XTQ6LJmnjDShm1p48WLeflqb2qFv5SQLh13H49S3_hsoWjEo0JLQ9UGo9MYiftUL
 PGg5QZZsH28jRASRpMRPRfgo2a.AsrckWUhLl65dzFdXQADBN.emX9sG1mje4J2z3pS5ze.UJ1d_
 mOJQbcH1ofPu3LF3vPGSjR4twpadPkyDDmwrxAWbQ46e81QYjd3X_uBR.xGSc3OJjuXIpDD3S5Gl
 n1W42QwqsfcT03BngCHC.2aYSuMKFfVhZHr.q.mLSgua8NpdFoOjUf2O3BAJxJafjyntS98NV4bi
 IxuN3OmRGUPGQfyiviNJkGVm6Vc4LtG8DLDJKgQ1LgpTtCT80Mxg_nhdh6dPKEJ3yLXyjnEjpUJ4
 MgtUhJcjVXdrlNzrjrF_PtDjJq8hudezlsrQCIRPgZRzwjB09Sd3RMJ2HShZ7SqHuzpGDf02TZR6
 Ppmyq3Ifxci.Og5S1D5ZRo5GaXY6DRYqf3m3Ekvw_m3SHOPOdz4mRGzKbevIQX8qdrLCaCPYKrVd
 cE9GiEO00cmv_lI1h50BNxxfOD0dow_GC7k7kwSy9QTAKcUiiPawb2Mn9zFaeajiVnImqXkFoJt5
 7fsqk4YOpCL7x0o4fICnnWcU97hZzIfTe6b1wcvTgnhSrF7T.St_YFHz6tGu7YmRKNo_DHXpdLjU
 ULGDJvInDoSzCEJnuv8K5MGKQtXIsfobrwi4QQsl0vnsoGAnvsmVnPjGK7F4KxH7u7IzS6BpOw4v
 df11OyJ1ixNLe2xd3LRQEumiwHNyvzICIgyhDM0sOJXU8oRIthxzGhVbOIPzuIizOdUdLktiyMnO
 aKDMKRj4OO5goGz1crqSsDbaoahReM0QHNGmWT9yKo6cHFJTIvXUnSfQjG0_GkIhTslFPWvihxs7
 8jAYTQ159fzpLOC2JEdAzpsQg1Xz4Gt6ZVdYW75W1giLf1jUn0kaFqljELZ49gN1dpjNCPzAhsCj
 0cJuzUXQ4jsfbjqC4OpxC49D71y5U.oBpLvL.c2HWuBmfvlSAuKmF0cKo90t5lZEJz8SzHn8NEYV
 jvSwtsVYe9qsZtmQTpNhyyE1nbGUBil11zQ--
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.gq1.yahoo.com with HTTP; Tue, 30 Mar 2021 14:31:29 +0000
Received: by kubenode514.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID e49be4bf1df824b016b2ed877f5a9aaa;
          Tue, 30 Mar 2021 14:31:26 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 RESEND 3/8] repair: Protect bad inode list with mutex
Date:   Tue, 30 Mar 2021 22:31:18 +0800
Message-Id: <20210330143118.21032-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210330142531.19809-4-hsiangkao@aol.com>
References: <20210330142531.19809-4-hsiangkao@aol.com>
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
RESEND:
 - fix broken v3 due to rebasing

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
 	if (!itab) {
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

