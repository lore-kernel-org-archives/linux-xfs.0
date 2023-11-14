Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD33C074FD
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjKNByD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbjKNByD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:54:03 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7A0D45
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:59 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cc3388621cso45878865ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926839; x=1700531639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+6aUg0Rw7SV8YlFaf1FQyTuKLiXDrzhC3SD/xZ7hvKc=;
        b=bTp7+SOqKCLgl8fHMxxqhh96MnDUN/wYWenXpIM3wo8rrKXP2bb+lcSswNhhb4Fmau
         krtNHM0UiJANdGOcp3aM9fQuQpEwq90md3nL0uELWuBL39fNi0sA6fI3aoeL/IJjdFqR
         IVlWdEiL11km1veb6frJl9TxDkkEsr7VFpvGEfdt+yuQDWkqBPduymlg8s/tkYS3/yUA
         W776uXqXzzw9hHA+yuYrc4m64Bj7mnEvRwBamx1yAwLEAJsitM/a/aPJm2cfz+Y6LSgm
         DXskmR3Ph9wP6RZoGwkgWk2dVMctl5H1746yprcYKdKhLUnBnYqOulPRIXQOy51itjdi
         9gtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926839; x=1700531639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+6aUg0Rw7SV8YlFaf1FQyTuKLiXDrzhC3SD/xZ7hvKc=;
        b=BvHzjii4u7amYww6ClXDq+DiZYcHpg7uygJoiWsMwtdzvt27s7qThPUQYy99RDwqFI
         mu7881GyvKRAQQbQ91LSnPUi9/Wep2/zekKk+fJGa8IkbvAVD5hKYyAgeJWmy2XYkPp6
         NLhB1bFxItE3z59ky/K+ACd+6ECvkBXnqOUPTMvVd0Fmj7OppupAYi3Pt7UTp4RPJ0Pa
         rR5+eiezquGgCecgEVXtcmMm0IIIYNDRebad+HDYvqniw12NZLptgfX0ZCcypcMzEuIi
         0a/5G2/RW1RjDBLx92MCLzZKEFmijskmrnbBotVlq3ly3uYyIFCSTMOKolDRNE529h4t
         aE8w==
X-Gm-Message-State: AOJu0Yx+oLoaVvBgDyhNfrf94k5qX6DTOMzR/HR8/4m9iERp1SkraUIm
        SfxZblu4lAP+su1/cOpuBbbrIytPaX27TA==
X-Google-Smtp-Source: AGHT+IGf0CKBSvqAJ1aK1UWuPEeXuPT46PskVWmdocDvQX5gnLqo/bU0Nv7dJ2UtebRqSjbErAdYag==
X-Received: by 2002:a17:902:e892:b0:1cc:32df:8ebd with SMTP id w18-20020a170902e89200b001cc32df8ebdmr1488607plg.25.1699926839116;
        Mon, 13 Nov 2023 17:53:59 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:53:58 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        hexiaole <hexiaole@kylinos.cn>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 13/17] xfs: fix inode reservation space for removing transaction
Date:   Mon, 13 Nov 2023 17:53:34 -0800
Message-ID: <20231114015339.3922119-14-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: hexiaole <hexiaole@kylinos.cn>

[ Upstream commit 031d166f968efba6e4f091ff75d0bb5206bb3918 ]

In 'fs/xfs/libxfs/xfs_trans_resv.c', the comment for transaction of removing a
directory entry writes:

/* fs/xfs/libxfs/xfs_trans_resv.c begin */
/*
 * For removing a directory entry we can modify:
 *    the parent directory inode: inode size
 *    the removed inode: inode size
...
xfs_calc_remove_reservation(
        struct xfs_mount        *mp)
{
        return XFS_DQUOT_LOGRES(mp) +
                xfs_calc_iunlink_add_reservation(mp) +
                max((xfs_calc_inode_res(mp, 1) +
...
/* fs/xfs/libxfs/xfs_trans_resv.c end */

There has 2 inode size of space to be reserverd, but the actual code
for inode reservation space writes.

There only count for 1 inode size to be reserved in
'xfs_calc_inode_res(mp, 1)', rather than 2.

Signed-off-by: hexiaole <hexiaole@kylinos.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: remove redundant code citations]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5e300daa2559..2db9d9d12344 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -423,7 +423,7 @@ xfs_calc_remove_reservation(
 {
 	return XFS_DQUOT_LOGRES(mp) +
 		xfs_calc_iunlink_add_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 1) +
+		max((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-- 
2.43.0.rc0.421.g78406f8d94-goog

