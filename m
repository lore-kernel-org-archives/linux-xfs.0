Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0ACE95A8E
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 10:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345781AbjJIKag (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 06:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345829AbjJIKag (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 06:30:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18E0DE
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 03:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=VlDtWMGWjhXBYYtncVUcDKuc5aw5LH5hAxwEottF96o=; b=28e+JhP+yw0RcBYEPMpZMZHdLb
        ZqU6kTA6P3ZEoV6xUOdT6QK1gvicy2HbC7XCjBeOWBSRBbUrAD8zBFRH8ozIEl0VKHEZgHszPoKyS
        rxo0weqdSFtZ8Cze0QAxf0bqpulO9UCpS4LY80kQrxiJZiBL6OIYymH01yo6+dtuBDcKbTkPFR4+E
        UXMRMU/Unm84znEYbycXMqfx85rjVevjkxKxbnvKiMmBNpeE5hdPhurTbhd2Dp0fU0CX4Qy7TJgum
        nm7FQr2O40hH+8jgU7ci678+UlUsgq+jU3HWOAhhN1hMyjzMnV55L6PU9xSqqCYMOXAK//D0Pmpwm
        rpUezBGw==;
Received: from [2001:4bb8:182:6657:e5a9:584c:4324:b228] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qpnWy-00ADZE-1I
        for linux-xfs@vger.kernel.org;
        Mon, 09 Oct 2023 10:30:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space
Date:   Mon,  9 Oct 2023 12:30:20 +0200
Message-Id: <20231009103020.230639-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231009103020.230639-1-hch@lst.de>
References: <20231009103020.230639-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If xfs_bmapi_write finds a delalloc extent at the requested range, it
tries to convert the entire delalloc extent to a real allocation.
But if the allocator then can't find an AG with enough space to at least
cover the start block of the requested range, xfs_bmapi_write will return
0 but leave *nimaps set to 0.
In that case we simply need to keep looping with the same startoffset_fsb.

Note that this could affect any caller of xfs_bmapi_write that covers
an existing delayed allocation.  As far as I can tell we do not have
any other such caller, though - the regular writeback path uses
xfs_bmapi_convert_delalloc to convert delayed allocations to real ones,
and direct I/O invalidates the page cache first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d85580b101ad8a..556f57f757f33e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -814,12 +814,10 @@ xfs_alloc_file_space(
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
-	xfs_filblks_t		allocated_fsb;
 	xfs_filblks_t		allocatesize_fsb;
 	xfs_extlen_t		extsz, temp;
 	xfs_fileoff_t		startoffset_fsb;
 	xfs_fileoff_t		endoffset_fsb;
-	int			nimaps;
 	int			rt;
 	xfs_trans_t		*tp;
 	xfs_bmbt_irec_t		imaps[1], *imapp;
@@ -842,7 +840,6 @@ xfs_alloc_file_space(
 
 	count = len;
 	imapp = &imaps[0];
-	nimaps = 1;
 	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
 	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
 	allocatesize_fsb = endoffset_fsb - startoffset_fsb;
@@ -853,6 +850,7 @@ xfs_alloc_file_space(
 	while (allocatesize_fsb && !error) {
 		xfs_fileoff_t	s, e;
 		unsigned int	dblocks, rblocks, resblks;
+		int		nimaps = 1;
 
 		/*
 		 * Determine space reservations for data/realtime.
@@ -918,15 +916,20 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		allocated_fsb = imapp->br_blockcount;
-
-		if (nimaps == 0) {
-			error = -ENOSPC;
-			break;
+		/*
+		 * If xfs_bmapi_write finds a delalloc extent at the requested
+		 * range, it tries to convert the entire delalloc extent to a
+		 * real allocation.
+		 * But if the allocator then can't find an AG with enough space
+		 * to at least cover the start block of the requested range,
+		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
+		 * In that case we simply need to keep looping with the same
+		 * startoffset_fsb.
+		 */
+		if (nimaps) {
+			startoffset_fsb += imapp->br_blockcount;
+			allocatesize_fsb -= imapp->br_blockcount;
 		}
-
-		startoffset_fsb += allocated_fsb;
-		allocatesize_fsb -= allocated_fsb;
 	}
 
 	return error;
-- 
2.39.2

