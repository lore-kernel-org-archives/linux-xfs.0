Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803D8C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Dec 2022 03:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiLHDtw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Dec 2022 22:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLHDtv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2022 22:49:51 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243FA6392
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2022 19:49:51 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id jn7so314216plb.13
        for <linux-xfs@vger.kernel.org>; Wed, 07 Dec 2022 19:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=LWk7ZY1UpU5ufs5V3AO/FvGB5jOgkNLYrpso06SfS40=;
        b=6eux0HL1CagYC34zHav4h2tR4CHdu6Uq1p7x6wGIcsHgziIqdtJg2KXzc3wlFiVAuU
         ljmn02S08TXgc/iyf4cmrFtgEoSZKfiwTMmIfJ0LBGNMcgzCi5O1NH/jh/SvpCF/Ifal
         oH3FERDYFT7TwSxghCopXdUMSju8zwFLh7QgEfKG41OtnopdtqvDkZ+2Ie18ASiUAJ/I
         mKMNzUuDxifH7ZBHTB5qPpEq5e4zG0WbErTkHjBFRaa+U/hRzBrTJjmO1EUtuf83qqy9
         HPVs7c9qkYAnGi+DCW9Ux7WTlPnqyVt9QEbm0WY+0V28wu3MPKDml/TXTMOX4f8COLDq
         XhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWk7ZY1UpU5ufs5V3AO/FvGB5jOgkNLYrpso06SfS40=;
        b=ualaaBhh6BjHEwM/eqwDzZH2+gjRT2tahFjyPWOS4uWP0dF7afEyaabG8Rf9rKnLMa
         FQfTbeCxfw8Y8xHrMZlnmW8NFbN25fkDaMC8VA+zimgKBTgoPr6/qY8/sWX6nrglFnKd
         AH67RlbyBYorPo0NdwRUidVrIjc9fU7TXynRIIJ6UbirCU7DLs3Akwi5GOhmcWibSaBC
         ItcOZzhlaedWROdXmUKA8ZFsAw4/VLdHFTyQpG3pNoVjgCZmDIvbtYhoIbnyF+5Fz4kd
         3DAiXW5n98OZghs0MCtbUK+nziHoXO7Ls4U2OPVTMtTjU5Xi3rbr+5QKlWIEjg0U4G4f
         y+Sg==
X-Gm-Message-State: ANoB5plzYmDCEDdSedbb8e6yN8t7ed+SMws8M3mlVCBWuW731ZKc7QOs
        hMuK72Z1dXRuCtyibsI8YkXFv3VyxogVtKOB
X-Google-Smtp-Source: AA0mqf5uu8DIc3AT9kwbfkYAYKohv7dIdssAWL2dS/rqYrhOQfkvWdX44e+NVQ4tIuYuER0SMIh0KQ==
X-Received: by 2002:a17:90a:4814:b0:219:7742:9bcf with SMTP id a20-20020a17090a481400b0021977429bcfmr1608097pjh.40.1670471390633;
        Wed, 07 Dec 2022 19:49:50 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id k1-20020a17090a4c8100b0020aacde1964sm1859460pjh.32.2022.12.07.19.49.49
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 19:49:50 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1p37ut-005poq-1a
        for linux-xfs@vger.kernel.org; Thu, 08 Dec 2022 14:49:47 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1p37us-000Dli-2f
        for linux-xfs@vger.kernel.org;
        Thu, 08 Dec 2022 14:49:46 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: dquot shrinker doesn't check for XFS_DQFLAG_FREEING
Date:   Thu,  8 Dec 2022 14:49:46 +1100
Message-Id: <20221208034946.52917-1-david@fromorbit.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Resulting in a UAF if the shrinker races with some other dquot
freeing mechanism that sets XFS_DQFLAG_FREEING before the dquot is
removed from the LRU. This can occur if a dquot purge races with
drop_caches.

Reported-by: syzbot+912776840162c13db1a3@syzkaller.appspotmail.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 18bb4ec4d7c9..ff53d40a2dae 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -422,6 +422,14 @@ xfs_qm_dquot_isolate(
 	if (!xfs_dqlock_nowait(dqp))
 		goto out_miss_busy;
 
+	/*
+	 * If something else is freeing this dquot and hasn't yet removed it
+	 * from the LRU, leave it for the freeing task to complete the freeing
+	 * process rather than risk it being free from under us here.
+	 */
+	if (dqp->q_flags & XFS_DQFLAG_FREEING)
+		goto out_miss_unlock;
+
 	/*
 	 * This dquot has acquired a reference in the meantime remove it from
 	 * the freelist and try again.
@@ -441,10 +449,8 @@ xfs_qm_dquot_isolate(
 	 * skip it so there is time for the IO to complete before we try to
 	 * reclaim it again on the next LRU pass.
 	 */
-	if (!xfs_dqflock_nowait(dqp)) {
-		xfs_dqunlock(dqp);
-		goto out_miss_busy;
-	}
+	if (!xfs_dqflock_nowait(dqp))
+		goto out_miss_unlock;
 
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		struct xfs_buf	*bp = NULL;
@@ -478,6 +484,8 @@ xfs_qm_dquot_isolate(
 	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaims);
 	return LRU_REMOVED;
 
+out_miss_unlock:
+	xfs_dqunlock(dqp);
 out_miss_busy:
 	trace_xfs_dqreclaim_busy(dqp);
 	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
-- 
2.38.1

