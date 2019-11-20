Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04176C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 02:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C48FE2240D
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 02:38:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WcsdNVp8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKTCi0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 21:38:26 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727243AbfKTCi0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Nov 2019 21:38:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAK2YAXu175312;
        Wed, 20 Nov 2019 02:38:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ruIkWR26Z0ugxN53t65JqezAQd9EtBlisN6EsGx6krc=;
 b=WcsdNVp8461iFPPuYBnMTwVh8G+odr57JBeuwXbYvuCGf71A1EHYrxl4dEBDGgTVWZky
 5y/pe/WHEk1v1PaMFhn1huExNhQ78iGHJ6ahWNBT+gt5eFvEYvMCvA2Dhdrfc1Db5kQd
 ssOI5ctuErVzwNyx/oe5Sirw+Xk016Y6U8RFblOBvHcv0iH1opVj1RaxBDiJiIN6cpKh
 rXccxe+t1hfjvZqhVaMSt0EV+8CfrcnkUfb1dw//rUnGIv4/kO6oCqV+PoRh3GtE5YAN
 oqXHqvN5gD30DC1ZJ+aghyYP9jFSMELTZOyGdX7xbgZ5aLHjVeUQXTpvbCdR7TgDNQoD YA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wa9rqjnxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 02:38:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAK2X1Ic108187;
        Wed, 20 Nov 2019 02:38:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wc0ahenyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 02:38:23 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAK2cMr7005055;
        Wed, 20 Nov 2019 02:38:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 18:38:21 -0800
Date:   Tue, 19 Nov 2019 18:38:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191120023821.GH6219@magnolia>
References: <20191029223752.28562-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029223752.28562-1-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hmm, do you think this is a reasonable backport of this patch for
pre-5.5?

--D

---------------------

From: Dave Chinner <dchinner@redhat.com>
Subject: [PATCH] xfs: properly serialise fallocate against AIO+DIO

AIO+DIO can extend the file size on IO completion, and it holds
no inode locks while the IO is in flight. Therefore, a race
condition exists in file size updates if we do something like this:

aio-thread			fallocate-thread

lock inode
submit IO beyond inode->i_size
unlock inode
.....
				lock inode
				break layouts
				if (off + len > inode->i_size)
					new_size = off + len
				.....
				inode_dio_wait()
				<blocks>
.....
completes
inode->i_size updated
inode_dio_done()
....
				<wakes>
				<does stuff no long beyond EOF>
				if (new_size)
					xfs_vn_setattr(inode, new_size)


Yup, that attempt to extend the file size in the fallocate code
turns into a truncate - it removes the whatever the aio write
allocated and put to disk, and reduced the inode size back down to
where the fallocate operation ends.

Fundamentally, xfs_file_fallocate()  not compatible with racing
AIO+DIO completions, so we need to move the inode_dio_wait() call
up to where the lock the inode and break the layouts.

Secondly, storing the inode size and then using it unchecked without
holding the ILOCK is not safe; we can only do such a thing if we've
locked out and drained all IO and other modification operations,
which we don't do initially in xfs_file_fallocate.

It should be noted that some of the fallocate operations are
compound operations - they are made up of multiple manipulations
that may zero data, and so we may need to flush and invalidate the
file multiple times during an operation. However, we only need to
lock out IO and other space manipulation operations once, as that
lockout is maintained until the entire fallocate operation has been
completed.

Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: include the chunks necessary for the old space ioctls]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    8 +-------
 fs/xfs/xfs_file.c      |   23 +++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c     |   25 +++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2dd49fb6794e..615ff1e7c7be 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -929,6 +929,7 @@ xfs_unmap_extent(
 	goto out_unlock;
 }
 
+/* Caller must first wait for the completion of any pending DIOs if required. */
 int
 xfs_flush_unmap_range(
 	struct xfs_inode	*ip,
@@ -940,9 +941,6 @@ xfs_flush_unmap_range(
 	xfs_off_t		rounding, start, end;
 	int			error;
 
-	/* wait for the completion of any pending DIOs */
-	inode_dio_wait(inode);
-
 	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_SIZE);
 	start = round_down(offset, rounding);
 	end = round_up(offset + len, rounding) - 1;
@@ -974,10 +972,6 @@ xfs_free_file_space(
 	if (len <= 0)	/* if nothing being freed */
 		return 0;
 
-	error = xfs_flush_unmap_range(ip, offset, len);
-	if (error)
-		return error;
-
 	startoffset_fsb = XFS_B_TO_FSB(mp, offset);
 	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1ffb179f35d2..d94e9823cd9f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -818,6 +818,29 @@ xfs_file_fallocate(
 	if (error)
 		goto out_unlock;
 
+	/*
+	 * Must wait for all AIO to complete before we continue as AIO can
+	 * change the file size on completion without holding any locks we
+	 * currently hold. We must do this first because AIO can update both
+	 * the on disk and in memory inode sizes, and the operations that follow
+	 * require the in-memory size to be fully up-to-date.
+	 */
+	inode_dio_wait(inode);
+
+	/*
+	 * Now that AIO and DIO has drained we can flush and (if necessary)
+	 * invalidate the cached range over the first operation we are about to
+	 * run. We include zero and collapse here because they both start with a
+	 * hole punch over the target range. Insert and collapse both invalidate
+	 * the broader range affected by the shift in xfs_prepare_shift().
+	 */
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
+		    FALLOC_FL_COLLAPSE_RANGE)) {
+		error = xfs_flush_unmap_range(ip, offset, len);
+		if (error)
+			goto out_unlock;
+	}
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d58f0d6a699e..3fb501c5efcc 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -665,6 +665,31 @@ xfs_ioc_space(
 		goto out_unlock;
 	}
 
+	/*
+	 * Must wait for all AIO to complete before we continue as AIO can
+	 * change the file size on completion without holding any locks we
+	 * currently hold. We must do this first because AIO can update both
+	 * the on disk and in memory inode sizes, and the operations that follow
+	 * require the in-memory size to be fully up-to-date.
+	 */
+	inode_dio_wait(inode);
+
+	/*
+	 * Now that AIO and DIO has drained we can flush and (if necessary)
+	 * invalidate the cached range over the first operation we are about to
+	 * run. We include zero range here because it starts with a hole punch
+	 * over the target range.
+	 */
+	switch (cmd) {
+	case XFS_IOC_ZERO_RANGE:
+	case XFS_IOC_UNRESVSP:
+	case XFS_IOC_UNRESVSP64:
+		error = xfs_flush_unmap_range(ip, bf->l_start, bf->l_len);
+		if (error)
+			goto out_unlock;
+		break;
+	}
+
 	switch (cmd) {
 	case XFS_IOC_ZERO_RANGE:
 		flags |= XFS_PREALLOC_SET;
