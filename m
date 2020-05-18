Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE8BC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A1E320758
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mtM4lKsB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgERREq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 13:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERREp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 13:04:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56CCC061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 10:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=z8tiePGIXsKV+TRlkgIO2fmfPmXAnAfTMfqrnyoR/Cc=; b=mtM4lKsBgIx1dBUUf1SxnRVfm8
        /zYoc5iSVWLXwBaA8XUVCzG0Mb6XaluI5nj9US70scC+lbxp8BAhI53kkhtNAxEDwcYgX260uYBRu
        /eiK5J6LCm5+ygcPrAZoRDb9WWjafyNxiLL1M5M+vG1ASW5IUU1EkBNsc1Z/ZLRgl6fVjl++pbUmE
        vtrl9NOlWhZF7hxC0r+RYlBeqAhN5JkA3JLxm7gLuB+uEPoshl39EwGKyoODBQHMlygX+gvOq2OPj
        zro7akmamPfHQszuDdxx2MDSa2gsCmqBY7I1pyOdpgOgFc2h/1TKg+lK8mO6CNzyXuqaTtHs/1V7X
        Rj6VLGmg==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jajC1-0001vx-CI
        for linux-xfs@vger.kernel.org; Mon, 18 May 2020 17:04:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs: mark xfs_inode_ag_iterator_tag static
Date:   Mon, 18 May 2020 19:04:33 +0200
Message-Id: <20200518170437.1218883-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518170437.1218883-1-hch@lst.de>
References: <20200518170437.1218883-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

No users outside of xfs_icache.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 2 +-
 fs/xfs/xfs_icache.h | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1f9b86768f054..6c6f8015ab6ef 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -979,7 +979,7 @@ xfs_inode_ag_iterator_flags(
 	return last_error;
 }
 
-int
+static int
 xfs_inode_ag_iterator_tag(
 	struct xfs_mount	*mp,
 	int			(*execute)(struct xfs_inode *ip, int flags,
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 39712737c0d5c..11fd6d877e112 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -74,9 +74,6 @@ void xfs_queue_cowblocks(struct xfs_mount *);
 int xfs_inode_ag_iterator_flags(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, int flags, void *args),
 	int flags, void *args, int iter_flags);
-int xfs_inode_ag_iterator_tag(struct xfs_mount *mp,
-	int (*execute)(struct xfs_inode *ip, int flags, void *args),
-	int flags, void *args, int tag);
 
 static inline int
 xfs_fs_eofblocks_from_user(
-- 
2.26.2

