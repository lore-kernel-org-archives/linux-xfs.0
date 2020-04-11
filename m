Return-Path: <SRS0=7tHi=53=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AE3C2BBC7
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ED902084D
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJYuHsid"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgDKJNM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Apr 2020 05:13:12 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43319 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgDKJNM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Apr 2020 05:13:12 -0400
Received: by mail-pg1-f193.google.com with SMTP id x26so853464pgc.10
        for <linux-xfs@vger.kernel.org>; Sat, 11 Apr 2020 02:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jy1Zvve1cTB1l+zBWthvsgenMzAtaJtUDZEmAXv7mDU=;
        b=KJYuHsidw9ALyYRPgPvVt3sCzaRRWJ2Ep8TFyyl1ADb9MoB/pDL3DRTu5Vi99dh4hQ
         IBz5Zn1gWLx0ruWP8OBtwCDc1bnju6l/8fl+afrlhDJ3WgWBQa6SnJZMfgRZ+oBA+r4I
         Diz2pyap4iG2JBvpB5saf0dn36qWq5D9AT+5aB+sSr3unXNYPw0davJOEhgtMX9FQj19
         pNLf3RAZxZX8VQG3H3oxubS810qI5CwUFvlKxbCNiOYhwDma2e+lLgnHJaqfcL06U0ds
         gAkI5vMSYhd6jRnHLz4pb/PK5eJ1snu65HSPN1+3u2muw32MDMXIUcmKX5MHvZeVsTVS
         2RlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jy1Zvve1cTB1l+zBWthvsgenMzAtaJtUDZEmAXv7mDU=;
        b=hwQLiJZKk62fQ2PxhZy1p6H60F98zXHrUkybkRGhOeiMixiU25MaKKTVEoPhacn0R6
         iHxE++mqbqLknFvcky4/S1eiL4KEKoz9grE9TDEZwCEaHPEtFYq5sBvJn0v9F1apoP17
         IZtGPhUTMfL+RY9sZZodnp6XFJDguE4RpKb7HhqSAJxFLX/9VHggHOkYjLwoAsdLg9Ly
         6JxY6ReNV2gkYU3sQCj5VZDkVxiSsKvVombgqSUnicAE4LeyZs1u5l5W1zeL6ssb5HKO
         xg1cenLFT2oDvCFIQcoFzloVnncGi46x/fGIBgDzwxakGu94I/HiqKnd1iXd1SjsfsB8
         aJ4Q==
X-Gm-Message-State: AGi0PuY89ejk6LpZ2jkGKQAKR55ZK2Y0gnTtaiweBLDgLqE3ibOdtqED
        fLXhkNZTMx4O7nHugD04ADWpm8I=
X-Google-Smtp-Source: APiQypII7MiSoF5GRnsfuW07emf/93YSvIleIWHFShc2iJxDjHnhqvj7+SCza79ukglGpn5o8nsIYg==
X-Received: by 2002:aa7:8b44:: with SMTP id i4mr9381647pfd.179.1586596390252;
        Sat, 11 Apr 2020 02:13:10 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id n7sm3280364pgm.28.2020.04.11.02.13.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 02:13:09 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 4/6] xfs: remove unnecessary variable udqp from xfs_ioctl_setattr
Date:   Sat, 11 Apr 2020 17:12:56 +0800
Message-Id: <1586596378-10754-5-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
References: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The initial value of variable udqp is NULL, and we only set the
flag XFS_QMOPT_PQUOTA in xfs_qm_vop_dqalloc() function, so only
the pdqp value is initialized and the udqp value is still NULL.
Since the udqp value is NULL in the rest part of xfs_ioctl_setattr()
function, it is meaningless and do nothing. So remove it from
xfs_ioctl_setattr().

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index cdfb3cd9a25b..8ff91ab221aa 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1513,7 +1513,6 @@ xfs_ioctl_setattr(
 	struct fsxattr		old_fa;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
-	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
 	int			code;
@@ -1536,7 +1535,7 @@ xfs_ioctl_setattr(
 	if (XFS_IS_QUOTA_ON(mp)) {
 		code = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
 				VFS_I(ip)->i_gid, fa->fsx_projid,
-				XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
+				XFS_QMOPT_PQUOTA, NULL, NULL, &pdqp);
 		if (code)
 			return code;
 	}
@@ -1560,7 +1559,7 @@ xfs_ioctl_setattr(
 
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
 	    ip->i_d.di_projid != fa->fsx_projid) {
-		code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL, pdqp,
+		code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
 				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
 		if (code)	/* out of quota */
 			goto error_trans_cancel;
@@ -1626,7 +1625,6 @@ xfs_ioctl_setattr(
 	 * Release any dquot(s) the inode had kept before chown.
 	 */
 	xfs_qm_dqrele(olddquot);
-	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(pdqp);
 
 	return code;
@@ -1634,7 +1632,6 @@ xfs_ioctl_setattr(
 error_trans_cancel:
 	xfs_trans_cancel(tp);
 error_free_dquots:
-	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(pdqp);
 	return code;
 }
-- 
2.20.0

