Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD860C2BB1D
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95FF020674
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:00:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NCb+Vgpe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCQTAM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 15:00:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55590 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgCQTAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 15:00:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=l9XtZoDc6uQiMacsmLLJz/ZfrhyFD9uW98B4qyu92Lw=; b=NCb+Vgpei8JgbnnWmlFYmJ8yqU
        efqJPYgxrbmKvFrpU0cjX4VaHvH58FCekob4axmMBuiOIyP/fYxkTJuCVoQ1bhv4+Icel/t3U3mx6
        pJABxOCHEd281+Rqv4IJDUY4lunS7jpd2Ql4nw80ikyaCwBa4VH1zg01Ss+96eeKsd6jgcpsNLOPn
        INlX9CF+Fqrn7J0MSXSi5yjV5u/joL2+u669YuAovKlU2yC8Ax7/sjxmRSJlxIOjEyy0uwu60DoHT
        lA+IqF3+zbka/e5nSSVjrXrGndrDn6QFQs34+s3NXI0WxHu8Ljd/+roheiMvecbha2I2D7uW/pkMZ
        xm+zjbCQ==;
Received: from 089144202225.atnat0011.highway.a1.net ([89.144.202.225] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEHRi-0001o3-EV
        for linux-xfs@vger.kernel.org; Tue, 17 Mar 2020 19:00:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: remove the di_version icdinode field v3
Date:   Tue, 17 Mar 2020 19:57:51 +0100
Message-Id: <20200317185756.1063268-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series remove the not really needed ic_version field from
the icdinode structure.

Changes since v2:
 - fix a commit message typo
 - rename xfs_sb_version_has_large_dinode to xfs_sb_version_has_v3inode
 - move xfs_dinode_good_version next to xfs_sb_version_has_v3inode
 - pass the sb instead of xfs_mount to XFS_DINODE_SIZE

Changes since v1:
 - split into multiple patches
 - add a new xfs_sb_version_has_large_dinode helper instead of using
   xfs_sb_version_hascrc
 - add a comment about the relationship of file system and dinode
   versions
 - add a few more trivial cleanups
