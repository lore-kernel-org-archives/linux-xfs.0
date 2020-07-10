Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6789C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 05:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2DA32077D
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 05:49:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r2zQIedF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgGJFtI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 01:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgGJFtG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 01:49:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFBAC08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 22:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=+5czvv3JQVDi5xz5HYo9VSqNoqeZ4RxcWdRAy2vgi60=; b=r2zQIedFUAOynQ2dfqL7kFV0fh
        mjllx+vfh4BdJQ0G6rSya7XRKWkCiaTKVeg1Ei2417EmaOt0nuMarerkguvHOfIyzpUmYxG/wt+At
        kePTyq+VvQnXrFd7utQe11NWQk1wzDY7vqVgos/08nFXXkN+xYKLjxuDB/NPgl+iyKuBUVOaJUAEm
        qmYMKQ9l4g885PoJvJ75J+qeAv/CG+eUJopotIcjGde3XauCYmBv3gMZFaTsq5LLUS1C46AEluElF
        dxKdN/cgNmCEQjeiL0qeXlY04lFh24+EyPA9FqIjxW2YSOmNrlJNsotfLCJkZTheM+kd0pR1mcjYJ
        viHlQf4g==;
Received: from 089144201169.atnat0010.highway.a1.net ([89.144.201.169] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtluC-0007k4-3L
        for linux-xfs@vger.kernel.org; Fri, 10 Jul 2020 05:49:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove SYNC_WAIT and SYNC_TRYLOCK
Date:   Fri, 10 Jul 2020 07:46:52 +0200
Message-Id: <20200710054652.353008-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These two definitions are unused now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index ae92ca53de423f..3a4c8b382cd0fe 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -17,9 +17,6 @@ struct xfs_eofblocks {
 	__u64		eof_min_file_size;
 };
 
-#define SYNC_WAIT		0x0001	/* wait for i/o to complete */
-#define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
-
 /*
  * tags for inode radix tree
  */
-- 
2.26.2

