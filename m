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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE81C4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AB7F20870
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:04:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="fzFwbCfK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgJGOEk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:04:40 -0400
Received: from sonic317-20.consmr.mail.gq1.yahoo.com ([98.137.66.146]:35645
        "EHLO sonic317-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728469AbgJGOEk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 10:04:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1602079479; bh=5G6nRjWZxJn/ojQtP3Vd/OVp5DbAvJx7F1GHoPcjCnI=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=fzFwbCfKNbOpNw5Zh7nmGRH/IdQlJnZKgUIohF+Aa+4Xg2WLkdHXSgDKqAiXlz5Id+gAx9UxwBSfoayqiicCi+gLBHQYP1GAOgV0DR8tDRVCsG7gGFG+ltrNTJMzZ1UvCJLs43N4014ckkgyjeJb2nIs5yLPnT6i+Kba62dW7ytxtcYONKzDoLtqKqZkmfnnmdv1kSyrwMrWNGh+fuW1fzMC1R//auYc4RVRHNXhU4V7H7efB8jwhIBclZDRudF9UGczdMUiqTKPy0JXmVikqESXhieb11zSDkcIxnw8N7WQrf/V2nmyCnJEJ10ZQ6MpgsJxt5stHzjsbqatuopoqA==
X-YMail-OSG: IgcZXpkVM1kf5bcX_.MM372NdrFD9DYPCkGT8RJBJpeU6gSCPbOTvSREAqBAdqF
 Me8CjYGWMaExU5CN1psiGEVCjQ7OgqfP1MW5XvP7pv3TU7mT9_TFA5T1AhUj_G9mwgmy.YxaIljQ
 ynAvRCYLwfHJM859Qq5BbA7wIFzitTdKWN4G43ztQ.n2yA1F8np2U0UwnC6DCbG5YDvjpEi30EBi
 X3PGSAuaK1TeOaAV4nMl8gAASrlo1ZvySiZW2Pf1kuwcGB83Q.qN8HPvflJGXLIUu5i2EZ.GoACC
 3V.fB714D8cbpo2T27BgXgfB6Mw2.cRGvTLacXv869ikg1N3Lov.WMNk4Q0RL3Px5WyYBFsAHQ4D
 QC45zciLoXVIADgB5H_cFViunGliHC1pdAoq2wDm7OGBjFHhu6BEGshU.6GmbBp20aE.7Ozp8R6O
 J_E7tYBRiJ3kxA7YUcMd1tzsco33lymTjnDUx6vC3q8sMCfBKSFpr2bKOTKU7_3mIUBWtiQ8QSHW
 ERwJIO5CS0MqPb5fZesyE7FSV1gSmqm0TMZ0H4uWLfD_2hSvl2ruHiTGfEjBBiLrswTmWPLtaHzg
 w87_Uu3e8kEdshNlxn4xkuNE0VOUvYKNssPq5vIXtaDcD2.MeKYPCT9HjuIw67meNpdctkAJL64s
 uwR4_aOpH2c1ClIqQE_efEVwUt_l4kn.o77LTZrQkjuxfTZmy0UcY_r_0BNFxYXP7vWMGaFXjKZ1
 J_kBtEJ2IQOQs.kfit7TAoVBbF4lGU8EwHz7pajM6ernPfN36Uoto97mZsFGhh1PvzHO.EiDLvr3
 2KZph3PYZXYnaliZXpElxMr2SBcBwqyl_EH3lEUizLC3ha2_2E0uDElVU4c._rs2hELhG9npdXOH
 i5FOzQ8SIDnnyW9rvq3c.SgxXmcYgYquZcygFFiGpRRoncIojzFZDxR42Or5ntPlZMhrQousmx8U
 KAiIAzYXRE_DVf_G3OxElg8OKtMh9LQDiaDgwBoOtUR6l5KfKqv8P_HfRvt20ngo6ksO3mokpyrD
 bBB9VIfWx0uCdA9NuG3vjulcfuT84Jd05_xUByElhz6uLvCUjpTHbH8M84idP09vtRZNN2n_mvGn
 JSsbKj0RpR1uuToLZt1PhLPqN34Fu66uLB3yhFuyArEa9o2.7QgIBwI.zinG_LPhpJqwJiSjQfz3
 ulWojG.W.ZpaGcY2qEPb3yiP2L1PRdY1eNgT1VPCFkI2E9uJQTQgi26IozGXDdjDqNKbVRwGQdb_
 _dBCJMSRObxv4dIlmPpWsLD.D1LCbbjV0ZAoH1iVbcom_1fSRfw2VEHEeNFJeAOZvIUfMZVPiNfJ
 gvpS.PEheh20UrXzk31HqYaZbBJE5lV2TQeoohdS3reIS40NcBjQND4SmyWMVgOtoRqZ82_x.XQu
 EnUJbPekwMDnjFp1ybHc8ICC0ksROYVOG3HCRlldY1XpVT.MKy0d288ox2HOCS1gVuhQZNL0cXey
 ppMIL5LmYasWdjynsyBEyFisyifw_Zda4xBG83nhtW7R40jicxjKfWZ6qotwVxQyJXrn7x73Ol_i
 05r8-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.gq1.yahoo.com with HTTP; Wed, 7 Oct 2020 14:04:39 +0000
Received: by smtp404.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID a1aacd19ca90341b10418ab97793d328;
          Wed, 07 Oct 2020 14:04:37 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v4 1/3] xfsprogs: allow i18n to xfs printk
Date:   Wed,  7 Oct 2020 22:04:00 +0800
Message-Id: <20201007140402.14295-2-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20201007140402.14295-1-hsiangkao@aol.com>
References: <20201007140402.14295-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

In preparation to a common stripe validation helper,
allow i18n to xfs_{notice,warn,err,alert} so that
xfsprogs can share code with kernel.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 libxfs/libxfs_priv.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 5688284deb4e..545a66dec9b8 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -121,10 +121,10 @@ extern char    *progname;
 extern void cmn_err(int, char *, ...);
 enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 
-#define xfs_notice(mp,fmt,args...)		cmn_err(CE_NOTE,fmt, ## args)
-#define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
-#define xfs_err(mp,fmt,args...)			cmn_err(CE_ALERT,fmt, ## args)
-#define xfs_alert(mp,fmt,args...)		cmn_err(CE_ALERT,fmt, ## args)
+#define xfs_notice(mp,fmt,args...)	cmn_err(CE_NOTE, _(fmt), ## args)
+#define xfs_warn(mp,fmt,args...)	cmn_err(CE_WARN, _(fmt), ## args)
+#define xfs_err(mp,fmt,args...)		cmn_err(CE_ALERT, _(fmt), ## args)
+#define xfs_alert(mp,fmt,args...)	cmn_err(CE_ALERT, _(fmt), ## args)
 
 #define xfs_buf_ioerror_alert(bp,f)	((void) 0);
 
-- 
2.24.0

