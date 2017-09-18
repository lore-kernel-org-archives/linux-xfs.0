Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932401AbdIRJQD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 05:16:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 43/78] xfs: check _alloc_read_agf buffer pointer before using
Date: Mon, 18 Sep 2017 11:11:52 +0200
Message-Id: <20170918091132.850826096@linuxfoundation.org>
In-Reply-To: <20170918091126.077483037@linuxfoundation.org>
References: <20170918091126.077483037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 10479e2dea83d4c421ad05dfc55d918aa8dfc0cd upstream.

In some circumstances, _alloc_read_agf can return an error code of zero
but also a null AGF buffer pointer.  Check for this and jump out.

Fixes-coverity-id: 1415250
Fixes-coverity-id: 1415320
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_refcount.c |    4 ++++
 fs/xfs/xfs_reflink.c         |    2 ++
 2 files changed, 6 insertions(+)

--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1640,6 +1640,10 @@ xfs_refcount_recover_cow_leftovers(
 	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 	if (error)
 		goto out_trans;
+	if (!agbp) {
+		error = -ENOMEM;
+		goto out_trans;
+	}
 	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
 
 	/* Find all the leftover CoW staging extents. */
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -169,6 +169,8 @@ xfs_reflink_find_shared(
 	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
 	if (error)
 		return error;
+	if (!agbp)
+		return -ENOMEM;
 
 	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
 


