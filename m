Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7E6C4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEE4420870
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:04:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="r7kirQgo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgJGOEd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:04:33 -0400
Received: from sonic314-19.consmr.mail.gq1.yahoo.com ([98.137.69.82]:45502
        "EHLO sonic314-19.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728469AbgJGOEd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 10:04:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1602079472; bh=YC+YGNkmeisDO/rbi8l/QKr12w7rztAcjoDRkTHmJNw=; h=From:To:Cc:Subject:Date:References:From:Subject; b=r7kirQgofR70/adinG4cDgsERPN6Z0WiyC2p5BdPGWAg7Cl/L7p5YR/HeUTntg9OIDC+1iBDODoUSP7DLZ2SDNNROrpwR2jYsUiEmiDJUXisB36QVIgrREmHf3sAaqIEmnyi29TW96Qx9F1kCtzuPKIhiq5+05YqsdczuYaDj5d5HzoT/z3lZhh38JFlH0QyGu818ZlD421hhkqwhPD9dZGXKENAxCl9JgCYhbqTSfceDE2lLSWvnGXvlY1rgZULhlRgWvhSNQIbgT5coLnP4L+gmj7M9SR1XkeZ7yyi/XkxHYrlkQF/G5p9JptugrM+4LmyT86lOmTb/JV+1tS0kw==
X-YMail-OSG: SMfpOu8VM1kBeQ5EBrrF2wQKh8b7hvpxB2jH5ra1K0b36kKjQCMdIw0rtvaRuUv
 cnv.LESLNbBgNfr.qzdqTydOTHy5LkxdE8ndk8IelR3DbWL9LW36uai.rJ3vHJyBodfm0odDc20G
 hsMzGWuZOKJy.COmYNtamssHoSQF3kj9.Rxr_fPv1tg5i6d_sP3hoAR8JefqW_21wduFlvJRtjUG
 Dj5bpGgoZ30yNlh6dbdItXhxjsuuokyBK4jG65uO.rnnGOKmD0qheU9a8IQTiXMnI.hJI55EdSAh
 VeAo4XwBZ5O6CMBzyl37EbZHiTGeZ_rOcDAYIV7UB1OzOlEuJ8Xm5C__16ghFr9jZYNVnFn.XSb1
 f1_dnvvWgc6RZRmB9qnf.TSqGcaxqXNBkNzMTekuXgP6EUGp6dp2SgL_eAiBh8M9EoZCIi5_WKC1
 afzHJ8.npvIS.FiLjQP8Ry_cujaYBEEBYC0cew1n_WFFBfU7oFD6MQUnkxPT9cX5x74Cl3pfBbvc
 ywfeucteuvEVpvHFc0UoD_WTK7CJvm4_fRWSM2FdVQNmyCk_D33l0byZBsx__8KwmGrN5tAwhhPf
 AFkUDBCLJLVXL3DMLmV2aMsmSVFKGGqRdQ9qRFk6U8NHNQrlxIDLLoNn81v7lgym5mvNnw9gOqDB
 RfEdrBP.IlGbH4GwUFJ8n3O7w6pJRCmHgRWFFEnYCleIyyyo1dOGIkZ9C1RempFnq.QGH3nx84Xf
 2WGjNYW1sPQjP2hpHeyXckbhDUKZCPVQ1HUN4us2Vqtzj3uvQ_S4iQWHXEDZHM7MOccZsbUw.4JZ
 8zdAVTgH7M3iH7QCPYxtpSeVXzRtfVMJhdTu_S5.2Cim0UTh1I9P9YYaMEs_r42c8jBVv6a5XEDY
 Npz1_uxud4IwX9gLySIoKB6NK_cAU_L0RRBt24KJ1nWxtwYyC2eZ5sJxg.t6lAqUIOAxSo8Y_w.u
 GuLYXjWnknMW10v8ICcNQXqB.vqEp90EzSP_o5y.Hqa1jjZl.fYoAQKdCUzVCT_J9xEBcl_cqBtd
 hUc6846f0uWWKmH6bBbU_4MFwFwV8FKLyGTaTEODSmQq_S5Mv.kSkCQEU5rTCapHCTbqOhDqW2E4
 S23V0vAmx9Gx_KTi2FU_t16PZalYkwt4kCnXDUWkmh9J_8KRTnqiYpTbBCFnGEvzRsh2ojaRXqx_
 5dvdmn6R1_9VdE.mRLufX.SFtlT2WmRkqv.7zSrBSscPKIkX3dysIPCDNYXY409iu3FsotNbLKw5
 bPv6fTyBBf73UisxsSpg.kkurtSUuJObpKYhv6NeBadP_rlIshMoS1VSBCxelgs_g4Z6E8_aQmA5
 HiRnWtR_lkZxVwIwqNvr89w7sDY8NaCGconR8rGJVSMS3EBa8uhQJHygg88vfkP7Ig9xgDI._05E
 4VTFHqURYq.3.TZY.AmReBy3wqeqTNtqU7P7d.0q4cUe1nZHds2SIIaSeaYTpX5Mppw9LRCvhE8A
 56hEerabkyTk4LK96bcC5Ocp.WHeArKRDMnoNBDddvuqQLuozqCFj2NCDY1lmBJluhmukVSYVryK
 VcaPou4eAiM5uuJ3jsTK5D7KbPFOIkUHANdhj_nCxY58rFiAcXppGOcTuc1Bv6GtR_ofnnCAeyd3
 ymGo-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.gq1.yahoo.com with HTTP; Wed, 7 Oct 2020 14:04:32 +0000
Received: by smtp404.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID a1aacd19ca90341b10418ab97793d328;
          Wed, 07 Oct 2020 14:04:27 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 0/3] xfsprogs: consolidate stripe validation
Date:   Wed,  7 Oct 2020 22:03:59 +0800
Message-Id: <20201007140402.14295-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20201007140402.14295-1-hsiangkao.ref@aol.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

Hi,

v3: https://lore.kernel.org/r/20200806130301.27937-1-hsiangkao@redhat.com

This is another approach suggested by Eric in the reply of v3
(if I understand correctly), which also attempts to use
i18n-enabled xfsprogs xfs_notice() to error out sanity check
failure suggested by Dave on IRC.

In addition, I manually ported [PATCH 2/3] to the kernel side
as well then fault injection with xfs_db and it seems work
as expected.

Thanks,
Gao Xiang

changes since v3:
 - mainly follow Eric suggestion mentioned in the reply of v3,
   e.g directly prints the error using xfs_notice/warn() and
   return bool;

 - with an exception that it doesn't need the unit of sunit/swidth
   are in bytes if sectorsize is not specified, since the sanity
   check logic condition only needs these are in the same unit,
   so it saves calculation for these FSB / sector-based
   representation.

Gao Xiang (3):
  xfsprogs: allow i18n to xfs printk
  xfs: introduce xfs_validate_stripe_factors()
  xfsprogs: make use of xfs_validate_stripe_factors()

 libxfs/libxfs_priv.h |  8 +++----
 libxfs/xfs_sb.c      | 54 +++++++++++++++++++++++++++++++++++---------
 libxfs/xfs_sb.h      |  3 +++
 mkfs/xfs_mkfs.c      | 23 ++++++-------------
 4 files changed, 57 insertions(+), 31 deletions(-)

-- 
2.24.0

