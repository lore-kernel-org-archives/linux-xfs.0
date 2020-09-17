Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310F0C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFA1F21D7F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:39:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IfV4PQwP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgIQLjB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 07:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgIQLi5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 07:38:57 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E002EC06178A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:38:56 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 34so1188162pgo.13
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1xjEftt6BoWBnurJ2cfbr79NM6CiAL0+326aCaRrEN4=;
        b=IfV4PQwPzMgvq+npmRqE8AfYxxcSGb9NL15aw7InSwiTPDfvT25cKcnuKyxGSf1igG
         cwdK/dm9I/y9lBka8V5aIfEkdKljIeKOj/mNRXzsz2HI3KyqrwXhEgjjY73uzkTD3gjq
         2/bkVc24aV6Y2REu+/8CIG1kwBKuM4yuwz3qOwinx1L2DanluukNEXjal6sJvWwcU2Kd
         aTrjqJAmSHONHE7C9pm4e+WCFkXYsw/+cZe01yPvuTn5+smn6oA1B2zfGlf406h7SYjo
         6bpZx7oG2jM2t47nRSXG1Nclcc+5A2UoCuX1sb6K83ZRBrDK1GOxrLQPAHElSmHEBquW
         ABNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1xjEftt6BoWBnurJ2cfbr79NM6CiAL0+326aCaRrEN4=;
        b=F/463Be1MPIu0Ls5IIRVOWUMCm9JqGwtO604JZItcRcL/QF/Vdqz5OPMH+YBcLdM65
         0CbSbK+dn3DDWZ2O0PIlhrIaNJPM5h3z7/8OusMhnNJGl3NfHS5o9OprY/tPTnrMZUpU
         BtwzxvHdVvTj1K3+nQRe0kfaEajCndeucfS3MIZjtzjT6KCEeyjiSgNp9FMEd4fArkhZ
         xT8fTtKgMdR5TJ0K+ThV0lOEyW5S9rOmMHuHK4S12iYXXVF/yNBBNH95T+ptXzAZlisQ
         XgDiI+Cf+PbUX39EQcseRpqhGiEse2YhJAs8ZXZdzInwPpsPnU0ak9Yld4V2l3zHfoYx
         Gkog==
X-Gm-Message-State: AOAM531BQQ1ruJ+X+ChC3GSEkS2e3zzCkOEyP14anMxmlrGN3Nbabxxr
        z169rXkC50Q94i2TDBxFArkSEgZ1qw==
X-Google-Smtp-Source: ABdhPJxhl/KOdSK95vm8VPqgr2MUBHgzTVdh2Pp4nedmDrXPrxdCdFowc2yhyur9oZa7DtxD5oFR2g==
X-Received: by 2002:a63:5656:: with SMTP id g22mr21314643pgm.44.1600342736183;
        Thu, 17 Sep 2020 04:38:56 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 64sm18761147pgi.90.2020.09.17.04.38.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 04:38:55 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 2/7] xfs: use the existing type definition for di_projid
Date:   Thu, 17 Sep 2020 19:38:43 +0800
Message-Id: <1600342728-21149-3-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We have already defined the project ID type prid_t, so maybe should
use it here.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 536666143fe7..ef5eaf33d146 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -17,7 +17,7 @@ struct xfs_dinode;
  */
 struct xfs_icdinode {
 	uint16_t	di_flushiter;	/* incremented on flush */
-	uint32_t	di_projid;	/* owner's project id */
+	prid_t		di_projid;	/* owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-- 
2.20.0

