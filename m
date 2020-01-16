Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E21EC33CB1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 06:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44A8320661
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 06:16:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Oxwm38TS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgAPGQJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 01:16:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49850 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729221AbgAPGQJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 01:16:09 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G6Ddif045078;
        Thu, 16 Jan 2020 06:16:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=m4QWMoh14oXI74hf5mHUM2zvTGz8GEhDwIkIdCqe1T8=;
 b=Oxwm38TS6r4tD8CerSDXKETSLO8OoeMxVvzFQxgtPgF7kk42jrJ2+89OgezGH/9qUiSZ
 cfriGZMO7iDKSlM1UTCD6c5fGjjzMDAbMlLxFJJf1nOJRfGnQN5WmdLkv/t12Tnirhvr
 k8HC45+FDbAQ/40DIgmt1XaNUxk5XT8Bo2HSl8JUsqu3n8mdFoyFyFhhIfzOGQzAmHGq
 Yc7eHZmePwMeBY4qi1W1VV0qPGkNxa//f8u8TDLkve7Q0IHqW7T6DQxKslPtd411+HyB
 Hm4iUzQTrfPAL/zA5BUBmze5gVKO/W7Zmn279MXaeTbEyoxFcQo1uhiIIWF2dzLfE5+m Lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74sgep0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 06:16:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G6EdYS123967;
        Thu, 16 Jan 2020 06:16:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xj1athcjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 06:16:00 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00G6FxQV015623;
        Thu, 16 Jan 2020 06:15:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 22:15:59 -0800
Subject: [PATCH 2/2] xfs: relax unwritten writeback overhead under some
 circumstances
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 22:15:58 -0800
Message-ID: <157915535801.2406747.10502356876965505327.stgit@magnolia>
In-Reply-To: <157915534429.2406747.2688273938645013888.stgit@magnolia>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=910
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=969 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160052
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In the previous patch, we solved a stale disk contents exposure problem
by forcing the delalloc write path to create unwritten extents, write
the data, and convert the extents to written after writeback completes.

This is a pretty huge hammer to use, so we'll relax the delalloc write
strategy to go straight to written extents (as we once did) if someone
tells us to write the entire file to disk.  This reopens the exposure
window slightly, but we'll only be affected if writeback completes out
of order and the system crashes during writeback.

Because once again we can map written extents past EOF, we also
enlarge the writepages window downward if the window is beyond the
on-disk size and there are written extents after the EOF block.  This
ensures that speculative post-EOF preallocations are not left uncovered.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    8 ++++---
 fs/xfs/libxfs/xfs_bmap.h |    3 ++-
 fs/xfs/xfs_aops.c        |   52 +++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 58 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 220ea1dc67ab..65b2bd12720e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4545,7 +4545,8 @@ xfs_bmapi_convert_delalloc(
 	int			whichfork,
 	xfs_off_t		offset,
 	struct iomap		*iomap,
-	unsigned int		*seq)
+	unsigned int		*seq,
+	bool			full_writeback)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -4610,11 +4611,12 @@ xfs_bmapi_convert_delalloc(
 	 *
 	 * New data fork extents must be mapped in as unwritten and converted
 	 * to real extents after the write succeeds to avoid exposing stale
-	 * disk contents if we crash.
+	 * disk contents if we crash.  We relax this requirement if we've been
+	 * told to flush all data to disk.
 	 */
 	if (whichfork == XFS_COW_FORK)
 		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
-	else
+	else if (!full_writeback)
 		bma.flags = XFS_BMAPI_PREALLOC;
 
 	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 14d25e0b7d9c..9d0b0ed83c9f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -228,7 +228,8 @@ int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
 		int eof);
 int	xfs_bmapi_convert_delalloc(struct xfs_inode *ip, int whichfork,
-		xfs_off_t offset, struct iomap *iomap, unsigned int *seq);
+		xfs_off_t offset, struct iomap *iomap, unsigned int *seq,
+		bool full_writeback);
 int	xfs_bmap_add_extent_unwritten_real(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_iext_cursor *icur, struct xfs_btree_cur **curp,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3a688eb5c5ae..45174dfa0b7d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -18,10 +18,13 @@
 #include "xfs_bmap_util.h"
 #include "xfs_reflink.h"
 
+#define XFS_WRITEPAGE_FULL_RANGE	(1 << 0)
+
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
 	unsigned int		data_seq;
 	unsigned int		cow_seq;
+	unsigned int		flags;
 };
 
 static inline struct xfs_writepage_ctx *
@@ -327,7 +330,8 @@ xfs_convert_blocks(
 	 */
 	do {
 		error = xfs_bmapi_convert_delalloc(ip, whichfork, offset,
-				&wpc->iomap, seq);
+				&wpc->iomap, seq,
+				XFS_WPC(wpc)->flags & XFS_WRITEPAGE_FULL_RANGE);
 		if (error)
 			return error;
 	} while (wpc->iomap.offset + wpc->iomap.length <= offset);
@@ -567,6 +571,48 @@ xfs_vm_writepage(
 	return iomap_writepage(page, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
 
+/*
+ * If we've been told to write a range of the file that is beyond the on-disk
+ * file size and there's a written extent beyond the EOF block, we conclude
+ * that we previously wrote a speculative post-EOF preallocation to disk (as
+ * written extents) and later extended the incore file size.
+ *
+ * To prevent exposure of the contents of those speculative preallocations
+ * after a crash, extend the writeback range all the way down to the old file
+ * size to make sure that those pages get flushed.
+ */
+static void
+xfs_vm_adjust_posteof_writepages(
+	struct xfs_inode		*ip,
+	struct writeback_control	*wbc)
+{
+	struct xfs_iext_cursor		icur;
+	struct xfs_bmbt_irec		irec;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (ip->i_d.di_size >= wbc->range_start)
+		goto out;
+
+	/* We're done if we can't find a real extent past EOF. */
+	if (!xfs_iext_lookup_extent(ip, XFS_IFORK_PTR(ip, XFS_DATA_FORK),
+			XFS_B_TO_FSB(ip->i_mount, ip->i_d.di_size), &icur,
+			&irec))
+		goto out;
+	if (irec.br_startblock == HOLESTARTBLOCK)
+		goto out;
+
+	wbc->range_start = ip->i_d.di_size;
+
+	/* Adjust the number of pages to write, if needed. */
+	if (wbc->nr_to_write == LONG_MAX)
+		goto out;
+
+	wbc->nr_to_write += (wbc->range_start >> PAGE_SHIFT) -
+			    (ip->i_d.di_size >> PAGE_SHIFT);
+out:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+}
+
 STATIC int
 xfs_vm_writepages(
 	struct address_space	*mapping,
@@ -574,6 +620,10 @@ xfs_vm_writepages(
 {
 	struct xfs_writepage_ctx wpc = { };
 
+	xfs_vm_adjust_posteof_writepages(XFS_I(mapping->host), wbc);
+	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
+		wpc.flags |= XFS_WRITEPAGE_FULL_RANGE;
+
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }

