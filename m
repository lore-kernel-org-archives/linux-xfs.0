Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B131C48BE8
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 18:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B37D613E9
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 18:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhFRS4K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 14:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231689AbhFRS4J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Jun 2021 14:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF18A613E2;
        Fri, 18 Jun 2021 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624042439;
        bh=/s07VwNw72ghCw8RDkaH2rD3zQgSoHypDk34lH8Zyik=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W7ieP0mgONcSCFwc4TmuYpcaXPexfI0LUnsKsDdj6o7mozx+zKRjmAVafcNpghXWr
         hivmwnNWowvb+KXRBdocw5HWnvORQd0QGyXgi9658TROM1aNGJJTFWvwhKgIVHLM8L
         Nx1/onUv4tYSG6AgYZbin593McIDYH9Jl9L0YNPBhq3cpdnaMXkCKtdBd03Kqc43IH
         QY4qqggiAk9fb3yhqIBr6IgAwjtEJpgXtSC/dnrP2Pq/RgehBYLQdJ0v6KGflc5j5E
         DUJSB/molBB4bvLVir5sadofAATDaAO93ZhKVYi4N6RSBb4FY5WTJf73WDrMO1QbOw
         cf/jcf9hWT8RQ==
Subject: [PATCH 1/3] xfs: fix type mismatches in the inode reclaim functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org,
        chandanrlinux@gmail.com, bfoster@redhat.com
Date:   Fri, 18 Jun 2021 11:53:59 -0700
Message-ID: <162404243951.2377241.4625544936148599795.stgit@locust>
In-Reply-To: <162404243382.2377241.18273624393083430320.stgit@locust>
References: <162404243382.2377241.18273624393083430320.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It's currently unlikely that we will ever end up with more than 4
billion inodes waiting for reclamation, but the fs object code uses long
int for object counts and we're certainly capable of generating that
many.  Instead of truncating the internal counters, widen them and
report the object counts correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_icache.c |    8 ++++----
 fs/xfs/xfs_icache.h |    6 +++---
 fs/xfs/xfs_trace.h  |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6b44fc734cb5..6007683482c6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1084,11 +1084,11 @@ xfs_reclaim_inodes(
 long
 xfs_reclaim_inodes_nr(
 	struct xfs_mount	*mp,
-	int			nr_to_scan)
+	unsigned long		nr_to_scan)
 {
 	struct xfs_icwalk	icw = {
 		.icw_flags	= XFS_ICWALK_FLAG_SCAN_LIMIT,
-		.icw_scan_limit	= nr_to_scan,
+		.icw_scan_limit	= min_t(unsigned long, LONG_MAX, nr_to_scan),
 	};
 
 	if (xfs_want_reclaim_sick(mp))
@@ -1106,13 +1106,13 @@ xfs_reclaim_inodes_nr(
  * Return the number of reclaimable inodes in the filesystem for
  * the shrinker to determine how much to reclaim.
  */
-int
+long
 xfs_reclaim_inodes_count(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		ag = 0;
-	int			reclaimable = 0;
+	long			reclaimable = 0;
 
 	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
 		ag = pag->pag_agno + 1;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 00dc98a92835..c751cc32dc46 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -15,7 +15,7 @@ struct xfs_icwalk {
 	kgid_t		icw_gid;
 	prid_t		icw_prid;
 	__u64		icw_min_file_size;
-	int		icw_scan_limit;
+	long		icw_scan_limit;
 };
 
 /* Flags that reflect xfs_fs_eofblocks functionality. */
@@ -49,8 +49,8 @@ void xfs_inode_free(struct xfs_inode *ip);
 void xfs_reclaim_worker(struct work_struct *work);
 
 void xfs_reclaim_inodes(struct xfs_mount *mp);
-int xfs_reclaim_inodes_count(struct xfs_mount *mp);
-long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
+long xfs_reclaim_inodes_count(struct xfs_mount *mp);
+long xfs_reclaim_inodes_nr(struct xfs_mount *mp, unsigned long nr_to_scan);
 
 void xfs_inode_mark_reclaimable(struct xfs_inode *ip);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 428dc71f7f8b..85fa864f8e2f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3894,7 +3894,7 @@ DECLARE_EVENT_CLASS(xfs_icwalk_class,
 		__field(uint32_t, gid)
 		__field(prid_t, prid)
 		__field(__u64, min_file_size)
-		__field(int, scan_limit)
+		__field(long, scan_limit)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
@@ -3909,7 +3909,7 @@ DECLARE_EVENT_CLASS(xfs_icwalk_class,
 		__entry->scan_limit = icw ? icw->icw_scan_limit : 0;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu scan_limit %d caller %pS",
+	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu scan_limit %ld caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->flags,
 		  __entry->uid,

