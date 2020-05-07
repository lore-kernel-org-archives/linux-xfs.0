Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252E7C38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 037C12083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DZ83xB9I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgEGMTH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76810C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=BKNp1DXoFHOCGKBay1iJQ8aUjmI/8Sq/IpqxoBX6blo=; b=DZ83xB9Iu1Ztrt9ngXpSugvpjH
        I6iOlc9Wg2qg6+inGpzAuHthfCWGGqTEixIYfJ+WZ27Mw/HAd8SgE+jq/ZkpUXtwbN+bF06TSViKf
        JJRCnCMqDxXQ4bpsc5w1NrEWjefCsOrQoA9IXQW1glnmvgoYWhbpolk9E7oymI6IbwkHhZC68am9R
        XhBfg+RDN2yPYRH9T6UAWJ98at9yTLfxAQgIhneY0LFaAVLCYsO229UkdgTvCl6wiFASd00g5WeZa
        pVFneLn3ozcjw2dXz0pOoWAImwrKJ7jEyp/oc4wAvd6zGx0K0BEyMOyEUyKvDr2ZoFtB++rV6MS7G
        P+2PdwSA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUY-00054X-MY; Thu, 07 May 2020 12:19:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/58] xfs: fix an undefined behaviour in _da3_path_shift
Date:   Thu,  7 May 2020 14:17:58 +0200
Message-Id: <20200507121851.304002-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Qian Cai <cai@lca.pw>

Source kernel commit: 4982bff1ace1196843f55536fcd4cc119738fe39

In xfs_da3_path_shift() "blk" can be assigned to state->path.blk[-1] if
state->path.active is 1 (which is a valid state) when it tries to add an
entry to a single dir leaf block and then to shift forward to see if
there's a sibling block that would be a better place to put the new
entry. This causes a UBSAN warning given negative array indices are
undefined behavior in C. In practice the warning is entirely harmless
given that "blk" is never dereferenced in this case, but it is still
better to fix up the warning and slightly improve the code.

UBSAN: Undefined behaviour in fs/xfs/libxfs/xfs_da_btree.c:1989:14
index -1 is out of range for type 'xfs_da_state_blk_t [5]'
Call trace:
dump_backtrace+0x0/0x2c8
show_stack+0x20/0x2c
dump_stack+0xe8/0x150
__ubsan_handle_out_of_bounds+0xe4/0xfc
xfs_da3_path_shift+0x860/0x86c [xfs]
xfs_da3_node_lookup_int+0x7c8/0x934 [xfs]
xfs_dir2_node_addname+0x2c8/0xcd0 [xfs]
xfs_dir_createname+0x348/0x38c [xfs]
xfs_create+0x6b0/0x8b4 [xfs]
xfs_generic_create+0x12c/0x1f8 [xfs]
xfs_vn_mknod+0x3c/0x4c [xfs]
xfs_vn_create+0x34/0x44 [xfs]
do_last+0xd4c/0x10c8
path_openat+0xbc/0x2f4
do_filp_open+0x74/0xf4
do_sys_openat2+0x98/0x180
__arm64_sys_openat+0xf8/0x170
do_el0_svc+0x170/0x240
el0_sync_handler+0x150/0x250
el0_sync+0x164/0x180

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_da_btree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 3f40e99e..7f26d124 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -1983,7 +1983,8 @@ xfs_da3_path_shift(
 	ASSERT(path != NULL);
 	ASSERT((path->active > 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	level = (path->active-1) - 1;	/* skip bottom layer in path */
-	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
+	for (; level >= 0; level--) {
+		blk = &path->blk[level];
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
 					   blk->bp->b_addr);
 
-- 
2.26.2

