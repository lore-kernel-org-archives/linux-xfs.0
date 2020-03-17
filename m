Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEB1C3F2CE
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 09:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D867B205ED
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 09:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ke962Boq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgCQJ7g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 05:59:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45831 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgCQJ7g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 05:59:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id m15so11434263pgv.12
        for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2020 02:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=053GDBN3hGRd7hjqdMewYMzVMg44EzkrP1AVCvFLOoM=;
        b=Ke962BoqViUJQ9xym2PwziO4UFLy5W2U85GfqrWAdTRHnm2OdBYwJNr5ALRCPJKRxF
         GlhC9EHLgviAm0XTfKj4c3Dt/yR43BZyz7wEX4sHo9qnEmqWUJV1bjIQwdzxmOSNCO+V
         hi98c7r3XdquafVRXJ9JoA6ZSjp0tTc4XsxfGVTyD6+si59B1kSLYdRWDVYBcKgkreUb
         gdO8FXlNsta9EaM8zLawi0MYoShtFAh3N+GnMrixzJgYc1VuGzDgSsuU6GE4m1ux2fIx
         tCbnrNPEK1Smmsvm2XP1s6J5aJJtGTfxTwJXlRDtFJOxFTVAoyp1s5HZ7INWTSxR60b8
         VueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=053GDBN3hGRd7hjqdMewYMzVMg44EzkrP1AVCvFLOoM=;
        b=OQj8MytLgNpxjhQ6LJLVaNuT7h3yR77w1kFmaD0yiMoxQrijwfTIQKlozME5aw44Y2
         JSadEKEWt0dwa44czkRiH1vpvvKkaAjU5EPF0A3CmhIKEMfssW2sWWFxMGsXAQArOpvC
         QP7c7GuqgKMUZZO5de/aRpR0nj6y2MhcLmQIYelzF8x3uyPgmA6dUyphnfeYCpq2ADCP
         C50arOmP2Th0Ozq/BdYceBxPNp+sANZTpUtslDiMroY9c1sazPVqiwVUqHHwA5yLm9QM
         5ifuwNwZacGEoqIIBmMB2ayyfmvJxD8ebu8u8DPwp4GEnx6WRqlsA5ERaKK8WqutgJ1B
         mTMA==
X-Gm-Message-State: ANhLgQ3//1eySFH61UJOs3pjwMGmA2W1Ho3hXXOCK9MC3LkQqt5iStR7
        VUd/V+SDW/FwVRYhJgNylKfUM7Espg==
X-Google-Smtp-Source: ADFU+vt18OX+qbtE8Qr4eim3EBFZFlkppyqlU0Ir6PS6hOnPVJ/iHG2PNR3ZbYGEr0uqsW1SIT7REA==
X-Received: by 2002:a63:c20e:: with SMTP id b14mr4055772pgd.394.1584439175232;
        Tue, 17 Mar 2020 02:59:35 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id a185sm1143085pfa.27.2020.03.17.02.59.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 02:59:34 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: use more suitable method to get the quota limit value
Date:   Tue, 17 Mar 2020 17:59:30 +0800
Message-Id: <1584439170-20993-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

It is more suitable to use min_not_zero() to get the quota limit
value, means to choose the minimum value not the softlimit firstly.
And the meaning is more clear even though the hardlimit value must
be larger than softlimit value.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_qm_bhv.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index fc2fa41..f1711f5 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -23,9 +23,8 @@
 {
 	uint64_t		limit;
 
-	limit = dqp->q_core.d_blk_softlimit ?
-		be64_to_cpu(dqp->q_core.d_blk_softlimit) :
-		be64_to_cpu(dqp->q_core.d_blk_hardlimit);
+	limit = min_not_zero(be64_to_cpu(dqp->q_core.d_blk_softlimit),
+				be64_to_cpu(dqp->q_core.d_blk_hardlimit));
 	if (limit && statp->f_blocks > limit) {
 		statp->f_blocks = limit;
 		statp->f_bfree = statp->f_bavail =
@@ -33,9 +32,8 @@
 			 (statp->f_blocks - dqp->q_res_bcount) : 0;
 	}
 
-	limit = dqp->q_core.d_ino_softlimit ?
-		be64_to_cpu(dqp->q_core.d_ino_softlimit) :
-		be64_to_cpu(dqp->q_core.d_ino_hardlimit);
+	limit = min_not_zero(be64_to_cpu(dqp->q_core.d_ino_softlimit),
+				be64_to_cpu(dqp->q_core.d_ino_hardlimit));
 	if (limit && statp->f_files > limit) {
 		statp->f_files = limit;
 		statp->f_ffree =
-- 
1.8.3.1

