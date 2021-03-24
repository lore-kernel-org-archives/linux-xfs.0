Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1632CC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 07:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADDEB619F8
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 07:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhCXHDx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 03:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhCXHDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 03:03:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BD2C061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 00:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=qSX6kggb1BnGoOLK2iEMXLDHlBH5AdTWXa4y4TXPedA=; b=HGjmQQAWO9cAnYLO2v1oIWXPi5
        PeE2jree81KhcFAZzKRdN5clqvxykmJKDWKbffYfl959vi+xH8eN+knHnJ5GPVHQYk408hFNhBC8u
        eTp87iRSVonixwbwvsgOvg1eCUmhIczgkZagO/ip2MBqW5SD8JnCcKjiM/Anb5hh9GJcouEKHV9MT
        BS7V58sQYJ36l/hvNE0W1aufsTrF7xEpWcVTsCDWo2xdnbt2yeGxUDtZGVBXE3uYbJ+803tLM40wL
        RkAagcaFUyVPX3+qb1vMMH6I7ybbA6ndU3ILVEdjjf0O3Y2I6+WCvppCgGPZpLjyQT1HV9yb/ksGb
        bp54wcWQ==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOxXx-003uit-98
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 07:03:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: pass struct xfs_eofblocks to the inode scan callback
Date:   Wed, 24 Mar 2021 08:03:07 +0100
Message-Id: <20210324070307.908462-4-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324070307.908462-1-hch@lst.de>
References: <20210324070307.908462-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Pass the actual structure instead of a void pointer here now
that none of the functions is used as a callback.

Signed-off-by: Christoph Hellwig <hch@lst.de>
 xfs_inode_free_cowblocks(
---
 fs/xfs/xfs_icache.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7fdf77df66269c..06286b5b613252 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -763,7 +763,7 @@ xfs_inode_walk_ag_grab(
 static int
 xfs_blockgc_scan_inode(
 	struct xfs_inode	*ip,
-	void			*args);
+	struct xfs_eofblocks	*eofb);
 
 /*
  * For a given per-AG structure @pag, grab, @execute, and rele all incore
@@ -1228,10 +1228,9 @@ xfs_reclaim_worker(
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
-	void			*args,
+	struct xfs_eofblocks	*eofb,
 	unsigned int		*lockflags)
 {
-	struct xfs_eofblocks	*eofb = args;
 	bool			wait;
 
 	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
@@ -1436,10 +1435,9 @@ xfs_prep_free_cowblocks(
 STATIC int
 xfs_inode_free_cowblocks(
 	struct xfs_inode	*ip,
-	void			*args,
+	struct xfs_eofblocks	*eofb,
 	unsigned int		*lockflags)
 {
-	struct xfs_eofblocks	*eofb = args;
 	bool			wait;
 	int			ret = 0;
 
@@ -1534,16 +1532,16 @@ xfs_blockgc_start(
 static int
 xfs_blockgc_scan_inode(
 	struct xfs_inode	*ip,
-	void			*args)
+	struct xfs_eofblocks	*eofb)
 {
 	unsigned int		lockflags = 0;
 	int			error;
 
-	error = xfs_inode_free_eofblocks(ip, args, &lockflags);
+	error = xfs_inode_free_eofblocks(ip, eofb, &lockflags);
 	if (error)
 		goto unlock;
 
-	error = xfs_inode_free_cowblocks(ip, args, &lockflags);
+	error = xfs_inode_free_cowblocks(ip, eofb, &lockflags);
 unlock:
 	if (lockflags)
 		xfs_iunlock(ip, lockflags);
-- 
2.30.1

