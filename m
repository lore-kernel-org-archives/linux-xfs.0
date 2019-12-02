Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5CEC432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 069B520848
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:36:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g9GAtWBS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfLBRgK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 12:36:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58646 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfLBRgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 12:36:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HZKgq043049;
        Mon, 2 Dec 2019 17:36:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=dazfTsJPDeJvRGlHLs8Bm0suCuRYkMFVHfLHtxPz33g=;
 b=g9GAtWBSbmK2wkRmACg+RssHgFEaKokfi/wjJvRQaNQ40H9eon36Pe5X8iaj+jgeO1Hm
 62CDlS8Q/tWFRnVWAr7Ex0k1GvTS7Yv4yjnxXolEqmmsuL3cUhhi/+Uq5CcNXOMGcPPj
 56QXTeCFyV7P48UGu39F5Q9SKcpXKLJ1S+gJYdTnxOd40WaZQSkhTQA47vhfOUeTZqUy
 khbZHKWChOOPJqeAD7CNGtgxPyFDb4kNqlOwcVQbyFXQFK9CwJ5B9Ifeb1vCadrIU6Of
 nxikgd1A6Q8kMB8eZ76k222KsgFNYZp3ic8+kQuXXx8hcELlDE3XgvS85BBQV9R2mdB6 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wkgcq1m5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:36:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HXwPS076570;
        Mon, 2 Dec 2019 17:36:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wm1w2ysqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:36:07 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB2Ha6CQ010586;
        Mon, 2 Dec 2019 17:36:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 09:36:06 -0800
Subject: [PATCH 1/4] xfs: don't commit sunit/swidth updates to disk if that
 would cause repair failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Mon, 02 Dec 2019 09:36:05 -0800
Message-ID: <157530816498.126767.16270669712075474727.stgit@magnolia>
In-Reply-To: <157530815855.126767.7523979488668040754.stgit@magnolia>
References: <157530815855.126767.7523979488668040754.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912020148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912020149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
and swidth values could cause xfs_repair to fail loudly.  The problem
here is that repair calculates the where mkfs should have allocated the
root inode, based on the superblock geometry.  The allocation decisions
depend on sunit, which means that we really can't go updating sunit if
it would lead to a subsequent repair failure on an otherwise correct
filesystem.

Port the computation code from xfs_repair and teach mount to avoid the
ondisk update if it would cause problems for repair.  We allow the mount
to proceed (and new allocations will reflect this new geometry) because
we've never screened this kind of thing before.

[1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d

Reported-by: Alex Lyakas <alex@zadara.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_ialloc.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ialloc.h |    2 +
 2 files changed, 90 insertions(+)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index f039b287..fe6553d3 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2848,3 +2848,91 @@ xfs_ialloc_setup_geometry(
 	else
 		igeo->ialloc_align = 0;
 }
+
+/*
+ * Compute the first and last inodes numbers of the inode chunk that was
+ * preallocated for the root directory.
+ */
+void
+xfs_ialloc_find_prealloc(
+	struct xfs_mount	*mp,
+	xfs_agino_t		*first_agino,
+	xfs_agino_t		*last_agino)
+{
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_agblock_t		first_bno;
+
+	/*
+	 * Pre-calculate the geometry of ag 0. We know what it looks like
+	 * because we know what mkfs does: 2 allocation btree roots (by block
+	 * and by size), the inode allocation btree root, the free inode
+	 * allocation btree root (if enabled) and some number of blocks to
+	 * prefill the agfl.
+	 *
+	 * Because the current shape of the btrees may differ from the current
+	 * shape, we open code the mkfs freelist block count here. mkfs creates
+	 * single level trees, so the calculation is pertty straight forward for
+	 * the trees that use the AGFL.
+	 */
+
+	/* free space by block btree root comes after the ag headers */
+	first_bno = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
+
+	/* free space by length btree root */
+	first_bno += 1;
+
+	/* inode btree root */
+	first_bno += 1;
+
+	/* agfl */
+	first_bno += (2 * min(2U, mp->m_ag_maxlevels)) + 1;
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		first_bno++;
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		first_bno += min(2U, mp->m_rmap_maxlevels); /* agfl blocks */
+		first_bno++;
+	}
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		first_bno++;
+
+	/*
+	 * If the log is allocated in the first allocation group we need to
+	 * add the number of blocks used by the log to the above calculation.
+	 *
+	 * This can happens with filesystems that only have a single
+	 * allocation group, or very odd geometries created by old mkfs
+	 * versions on very small filesystems.
+	 */
+	if (mp->m_sb.sb_logstart &&
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0) {
+
+		/*
+		 * XXX(hch): verify that sb_logstart makes sense?
+		 */
+		 first_bno += mp->m_sb.sb_logblocks;
+	}
+
+	/*
+	 * ditto the location of the first inode chunks in the fs ('/')
+	 */
+	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0) {
+		*first_agino = XFS_AGB_TO_AGINO(mp,
+				roundup(first_bno, mp->m_sb.sb_unit));
+	} else if (xfs_sb_version_hasalign(&mp->m_sb) &&
+		   mp->m_sb.sb_inoalignmt > 1)  {
+		*first_agino = XFS_AGB_TO_AGINO(mp,
+				roundup(first_bno, mp->m_sb.sb_inoalignmt));
+	} else  {
+		*first_agino = XFS_AGB_TO_AGINO(mp, first_bno);
+	}
+
+	ASSERT(igeo->ialloc_blks > 0);
+
+	if (igeo->ialloc_blks > 1)
+		*last_agino = *first_agino + XFS_INODES_PER_CHUNK;
+	else
+		*last_agino = XFS_AGB_TO_AGINO(mp, first_bno + 1);
+}
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 323592d5..9d9fe7b4 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -152,5 +152,7 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
+void xfs_ialloc_find_prealloc(struct xfs_mount *mp, xfs_agino_t *first_agino,
+		xfs_agino_t *last_agino);
 
 #endif	/* __XFS_IALLOC_H__ */

