Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8531C433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 02:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9094361A38
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 02:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhCZCrP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 22:47:15 -0400
Received: from sonic302-20.consmr.mail.gq1.yahoo.com ([98.137.68.146]:42476
        "EHLO sonic302-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230327AbhCZCqo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 22:46:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1616726802; bh=wCYtc51WQUz6IreAkTU/5gVKiCZx5s8xZg2gtVvTsQA=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=aLGnquObzfRawCYyQIUkEJLUxoyplKtY8aBCnWBC8JopgW4jJt8Y74On7kW0gcpSh4bMmYDBrFZGdbgFpfVjdg3JB3VkEt9sdFEDcO8gX0W+jNhCe9dUz1rVbjkB79SWlxXiSxJHE563jBb8J4lv/S50RjaXoCUrDmHaZRIpTCmm7J0zxAiaJdICRMvPFpYGbikWu/yatjCLcPVmMo89oNP2NaN2b9eThlB0FhjcIhYiIZ4RapPNZS2um3ICobuageIgTIm7tAnCc3gac/taqTZA3RmTSkFbdvQY1YdMtlA9F4GHuuwZM/RXcYTDxGEcqWgdsueR1ttCus3hqfYEMw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1616726802; bh=tFEFsl7MWMl5AkzZlh/T7C7rFMBTX9ODjpL9Nm+eva5=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=jpAQ/P8qTETSxywyHTEP5GNj7xaAEs4KuHrikrpO5it8LD4gbdvva/D9oJi2ZbPdfpzjn+XOntKUZnh1LbIIt1XAvuhKNrACCOcC6tPWg2YsGfgeluNxC2vO5zQYj6sPZv89CFAsg3QD5i5ofTyftgriakXtpfJsGk6q7G5yfgtGmSKBqW4pLJYAsw7T/Wx5dvydHvspJBvpfCjTyAksIM/TDamJ7/Le2UAC+kyFkScFLMaQ/Pf47s5bYb+kHyaL+3RFeh4o1Zokba2NhZSUgttk81F8UH4ZDShI9BjyVKj++OEowWAmr502oP1bJ4XHJPcXKOe5dHLDIKR94a5G0w==
X-YMail-OSG: 3_IHcw8VM1ktZ5VwPvyTjhd5eJS8r792vOQYjU3E2vNUFzjl3_M2GVHNtOeunmT
 lP03JDHxiuRmMeleFAJj.j37MpbA7I3EIIwvh867HLP5HssARG0bM8YmH464qV.FT76MVNza9OtW
 xlcr2z_bvRN051WtlGoms4RXdEdSUHPaSEEIKTWdWhlc2SsywCPprrgGDne9X8RLIxVPxBO86Cx5
 JKPNxAOdB.LKVYqsTOzKO6sX.hcw8WqeuBOXJb9LzQ67bFfXEalReci9z2OgilV4wGRcQQemQu71
 fnfaxCHY5jNF4jZl5rO9b2LvZA.lY_KLzZwraScjPiZeX7HAQnF1AZXgbKi_Js2dhgwYXt1m1cmF
 cyu7qUiGNQ5Onl3P84qLjQhr5zDf91anJ_zkTKt_doXQUOZcoMmCbg8rtYgYUL4S.t.YmOv1KfaO
 xUu8fdhP9vK7uJkwVHRLmMMWfJBKU0jbmVqL3OVwSq3ND5gik1I2Aw7GA5FX84_ughbKcAaUOZ5X
 hHOy2v9cnylUwnqp8krQ7qABsJny92q8qX3JWdKXNmZOPymT5Lr0J4XEmE3EheTMEzrlyhjXs4R8
 bd4igC371PBa659...NtXepIjEytXhmUUUvb4laggWpB36QAcAIVfdezEYlWwMf7AEL2gMIq4bdU
 ERAEnS5rYUHVJks_kUMkPzus0Z6NxGY5wq..GwzTdu.oBxzD5AxRuPPi4.wYiNOTjWz4Mp1ozdNJ
 _ePDVx5nvfT0JQlPU4lNffz8HiSXv9pv191q62wfTd0C7IMJ0tf8zcbDC.l66nBX3nSCkz0qT.19
 gJYiIk5ctcVWLoZTEUM9xIrYaxRna9rsWrqGSR19Y.lo9zriqEAp6ru5Oz56RgHUmPlu.ylm6bzw
 Ayl1lCSqvPKcTvFAJpvK8bvJJH.vAnGSWMRlA8vmHIX69S1JMWLrL1LCmxL1GGWJ1GO54h.G_B9i
 PtaV3lVT3i6t5kay0Hrg5t82sKdvjp9kYsC9c3CRXonn5fjA4EXVnMEoqsRgZtRTv0ZJoFc.cNtH
 V2bsQUub5JhX7OUxnXVcy.SsG_aqod5REVBCdHVEfWzJ5mo0buUkvsPfC9F1kQD62oUdKkO7l0VA
 zT9lQWQiT921_IxzcazWzV3RDLqgoQ_UICgHNEi99Ei_wux9Ap5hvYcq.GsTlX6c3Vhaemvx9NYN
 AO1jQWnxv9wwm6lE6MilVraZCq2SZrSY9TZP5cGAyjOt7F8sF.l1ykZKV.60Pi259Tm0HVPlPNRE
 1F9Fe8RcFh08xrDdnK8EKZG8w9QI.tTXcxNwS0LBiFCwOMRqTkclBSH8NuHNQokHUgnpv.JEz5fr
 0UcMADNDbXmDsGu_C4FF3XezQMC0a1Kq_Xwvu8IVsgVU0JWXbXJGVOvsP0dzbvvMu20NARyLxZBn
 RvjA.ZHrrPqWpo4VDGz_wjZ3ps_fuAsAtGg3W5KmX3b2iyr5TyyuCqAxDVY38xNEOT1xlhldcYyx
 dfuybOOwefKTIclVHz1jRnJSIBZzlZ6ie5_bR4hsUHu1f4Q3JWwdlwq5B.KM214ZKO_hPgjSB376
 HgLnBZSDIwS4kYhRnbiRzlE8pUSlQ8zqYv4jfqIwDZ667wfwsifEFwBZb.PQgNqm5_KyZYvMmvSC
 DI4DkY6vUfVfE67dTcYFIzpROa8hTQ.2uQ5JyljJnU_hApOn45xy1UX1TPT4YKzDZVTLJdoFD9AS
 EC5QqZTl4fi3AbTlBFzdziycYEY8DR56sRKm7CzRSEn0eQsl4LXGsKgPZuDL.ouZlqVQpzj6Luff
 T701zxWmjnyAVQXCY8T6hogGcPeItQ9q8PG5O_9SNFKF7QuwOPy3088ITha8tMSx76H2U67yXnDx
 k4Jp0s0ZqdbHO8zwpybzCcEzcQMtyC3yC.JA4z8XOZyZCvfXjer.ARtRaQoJ9Ytjv_U1k.h_tx_q
 ijvJJrAG0IGEMy1Qnip9gk6DPggYfrQereNFp5.gohIsKgQ7l3PWGegA6Je3WEoY2QdUIVeD_B95
 TRBOdk_XuuBBlcaD5.1FjmfGXhWQS7Mk8bA312UShlEgDfyoRqwOi9O5lf8jGi9JuxX1Y8y.9ZsS
 mMSTsLbtXj_..fOs3ek1U69Q3cxDN3jfWTJWBvKSbOgV4_T_4puTLvn7wt7Pt6UH0DbayL5.4eOR
 j_.KITVXK5I6.1kC4Ig9rkCiKghdMaqYruezjPcq6pOb8moGcziKjSSAFqaNA.C5hawBGX9Rykie
 Og55bmI3XOHlKzwTB9NQ2CAdT5FqJ9.ebAG6IPBEQtr7kxDze0_2kdsRQCIoYIN8tSU5QeoTmcTW
 ml3VZce.9gCJoWWUd242x8AmUVyATzY7zcErrYzg7s0tC605AaDI_pA52SKDRCADXUDuhFwn8S2F
 ibHzj8cSrFJs8y5yJubP8FC_s9B3u3m6wyMXn66yDhsbMvfRzD.2lbJBfgi9o.u3VVWe0yMliMWs
 OEQ8sMWS8jZD11h6eEwI94FK5f2gbc0RgNMPyaf__d0uWEY3vy.81Md6MkOMC_Bq4gOYAwe1waAL
 8rfLPQo71nIQp7IyFk.yI3UbbC0.TpN90VauJcyVgoVOpJXSt2nihQMQRFINiLEZ2hSUd2LGp2jE
 9rlsrpohW2p9gTYKjiKZnkID_R4dxE1_hdwYWpp0nP1PGUpSzphES9WJnu_aWknbY2gLYnT6DFlf
 p83_4GnOqn20TS5s-
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.gq1.yahoo.com with HTTP; Fri, 26 Mar 2021 02:46:42 +0000
Received: by kubenode572.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d84c985104b68650df5404b8da4793da;
          Fri, 26 Mar 2021 02:46:38 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2] xfs_growfs: support shrinking unused space
Date:   Fri, 26 Mar 2021 10:46:31 +0800
Message-Id: <20210326024631.12921-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20210326024631.12921-1-hsiangkao.ref@aol.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

This allows shrinking operation can pass into kernel. Currently,
only shrinking unused space in the tail AG functionality works.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
v1: https://lore.kernel.org/r/20201028114010.545331-1-hsiangkao@redhat.com
change since v1:
 - update manpage description (Darrick);

 growfs/xfs_growfs.c   | 9 ++++-----
 man/man8/xfs_growfs.8 | 8 +++++---
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index a68b515de40d..d45ba703cc6f 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -246,12 +246,11 @@ main(int argc, char **argv)
 			error = 1;
 		}
 
-		if (!error && dsize < geo.datablocks) {
-			fprintf(stderr, _("data size %lld too small,"
-				" old size is %lld\n"),
+		if (!error && dsize < geo.datablocks)
+			fprintf(stderr,
+_("[EXPERIMENTAL] try to shrink unused space %lld, old size is %lld\n"),
 				(long long)dsize, (long long)geo.datablocks);
-			error = 1;
-		} else if (!error &&
+		if (!error &&
 			   dsize == geo.datablocks && maxpct == geo.imaxpct) {
 			if (dflag)
 				fprintf(stderr, _(
diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
index 60a88189dd88..a01269270580 100644
--- a/man/man8/xfs_growfs.8
+++ b/man/man8/xfs_growfs.8
@@ -60,14 +60,16 @@ becomes available for additional file storage.
 .SH OPTIONS
 .TP
 .BI "\-d | \-D " size
-Specifies that the data section of the filesystem should be grown. If the
+Specifies that the data section of the filesystem should be resized. If the
 .B \-D
 .I size
-option is given, the data section is grown to that
+option is given, the data section is changed to that
 .IR size ,
 otherwise the data section is grown to the largest size possible with the
 .B \-d
-option. The size is expressed in filesystem blocks.
+option. The size is expressed in filesystem blocks. A filesystem with only
+1 AG cannot be shrunk further, and a filesystem cannot be shrunk to the point
+where it would only have 1 AG.
 .TP
 .B \-e
 Allows the real-time extent size to be specified. In
-- 
2.20.1

