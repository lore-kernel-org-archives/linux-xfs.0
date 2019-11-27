Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D41C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 00:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 518722071A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 00:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sYbaQ/E3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfK0Aeb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 19:34:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36070 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfK0Aea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 19:34:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR0TC5u140046;
        Wed, 27 Nov 2019 00:34:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=dgtTkDSn/0knvUDOb+Ux5JOD77VZdLly2PeFpfIjy4k=;
 b=sYbaQ/E3MzicaMpH9nI6P6RbKBb/3a6qhqOeXkLM+Dn3VS/sIozxu9mUYp/zU0lKlaVg
 6hk5LIZWMMhep0WuJM11+1Rpq60f37ZdNKu52zRWBlx9PAm5s8Ry0jG1Z3hqMvdNEPoW
 1RKClhH92SjJCOs1eWdOOR77fIeGJdkZIMZTtRsdDTZnAeY+CG1f64fThALGkSwc3r3n
 qDN6SxbcLai/OCzxtO16yNg6EKqTgGkHZMVLLj/UMu6szRggh8xd7rJ0WP6eu++u+v7J
 GTBSiHDobP4t3mxC+jiRBGpt1qUbsyya7hI/QomoCFfEM/PBzAxjvy4mZUw0ecrCJruh hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wev6ua3bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 00:34:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR0T8Y3107009;
        Wed, 27 Nov 2019 00:34:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wh0rextuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 00:34:27 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAR0YRGR026071;
        Wed, 27 Nov 2019 00:34:27 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 16:34:27 -0800
Date:   Tue, 26 Nov 2019 16:34:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Transaction log reservation overrun when fallocating realtime
 file
Message-ID: <20191127003426.GP6219@magnolia>
References: <20191126202714.GA667580@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126202714.GA667580@vader>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 26, 2019 at 12:27:14PM -0800, Omar Sandoval wrote:
> Hello,
> 
> The following reproducer results in a transaction log overrun warning
> for me:
> 
>   mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
>   mount -o rtdev=/dev/vdc /dev/vdb /mnt
>   fallocate -l 4G /mnt/foo
> 
> I've attached the full dmesg output. My guess at the problem is that the
> tr_write reservation used by xfs_alloc_file_space is not taking the realtime
> bitmap and realtime summary inodes into account (inode numbers 129 and 130 on
> this filesystem, which I do see in some of the log items). However, I'm not
> familiar enough with the XFS transaction guts to confidently fix this. Can
> someone please help me out?

Hmm...

/*
 * In a write transaction we can allocate a maximum of 2
 * extents.  This gives:
 *    the inode getting the new extents: inode size
 *    the inode's bmap btree: max depth * block size
 *    the agfs of the ags from which the extents are allocated: 2 * sector
 *    the superblock free block counter: sector size
 *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
 * And the bmap_finish transaction can free bmap blocks in a join:
 *    the agfs of the ags containing the blocks: 2 * sector size
 *    the agfls of the ags containing the blocks: 2 * sector size
 *    the super block free block counter: sector size
 *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
 */
STATIC uint
xfs_calc_write_reservation(...);

So this means that the rt allocator can burn through at most ...
1 ext * 2 trees * (2 * maxdepth - 1) * blocksize
... worth of log reservation as part of setting bits in the rtbitmap and
fiddling with the rtsummary information.

Instead, 4GB of 4k rt extents == 1 million rtexts to mark in use, which
is 131072 bytes of rtbitmap to log, and *kaboom* there goes the 109K log
reservation.

So I think you're right, and the fix is probably? to cap ralen further
in xfs_bmap_rtalloc().  Does the following patch fix it?

--D

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs: cap realtime allocation length to something we can log

Omar Sandoval reported that a 4G fallocate on the realtime device causes
filesystem shutdowns due to a log reservation overflow that happens when
we log the rtbitmap updates.

The tr_write transaction reserves enough log reservation to handle a
full splits of both free space btrees, so cap the rt allocation at that
number of bits.

"The following reproducer results in a transaction log overrun warning
for me:

    mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
    mount -o rtdev=/dev/vdc /dev/vdb /mnt
    fallocate -l 4G /mnt/foo

Reported-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 49d7b530c8f7..15c4e2790de3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -69,6 +69,26 @@ xfs_zero_extent(
 }
 
 #ifdef CONFIG_XFS_RT
+/*
+ * tr_write allows for one full split in the bnobt and cntbt to record the
+ * allocation, and that's how many bits of rtbitmap we can log to the
+ * transaction.  We leave one full block's worth of log space to handle the
+ * rtsummary update, though that's probably overkill.
+ */
+static inline uint64_t
+xfs_bmap_rtalloc_max(
+	struct xfs_mount	*mp)
+{
+	uint64_t		max_rtbitmap;
+
+	max_rtbitmap = xfs_allocfree_log_count(mp, 1) - 1;
+	max_rtbitmap *= XFS_FSB_TO_B(mp, 1);
+	max_rtbitmap *= NBBY;
+	max_rtbitmap *= mp->m_sb.sb_rextsize;
+
+	return max_rtbitmap;
+}
+
 int
 xfs_bmap_rtalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
@@ -113,6 +133,9 @@ xfs_bmap_rtalloc(
 	if (ralen * mp->m_sb.sb_rextsize >= MAXEXTLEN)
 		ralen = MAXEXTLEN / mp->m_sb.sb_rextsize;
 
+	/* Don't allocate so much that we blow out the log reservation. */
+	ralen = min_t(uint64_t, ralen, xfs_bmap_rtalloc_max(mp));
+
 	/*
 	 * Lock out modifications to both the RT bitmap and summary inodes
 	 */
