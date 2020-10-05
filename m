Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D6BC4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9270820B80
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:21:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aJqbLJs5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgJESVp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:21:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJESVp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 14:21:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IA3aQ190416;
        Mon, 5 Oct 2020 18:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5Xue2BUkDOE/VnhIBVfgYJc+X5+mDUyJB33SgABdLAE=;
 b=aJqbLJs5e9dXlSxdnODwP9VQ4t54r85eGiLr9y0XH3g0kix26HDIJcFkzHElcqrnVbdC
 1pjIHBIpw80MYofs8zBhRVgR0eMRtBGpCAwQTVariAKgcqJpYVZjRsfKM6ysLay7jsPj
 s0OkZf4qIC8m3hiWtOIH1M6ymHC+V4ghA2q1pOeH8S4xI/wzO2qbSk40itN4qzBtf30W
 aTiGlaf+XN1FsSYmD4/zWMraPKquQKi0FYOe+bsH3zpF/O14lGF1aBIFDoJdxnLu1TRr
 t/4P8xvxcFsDVAdXjrnYmeWqgvCVkJBvQuMTTM/LnfC3YVJ8YKgRsHnW/k0NLHsMgZOa cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33ym34c4m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 18:21:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IBRli073691;
        Mon, 5 Oct 2020 18:21:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33y2vkugy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 18:21:39 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 095ILcQN031258;
        Mon, 5 Oct 2020 18:21:38 GMT
Received: from localhost (/10.159.154.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 11:21:37 -0700
Subject: [PATCH 2/2] xfs: fix deadlock and streamline xfs_getfsmap performance
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, chandanrlinux@gmail.com
Date:   Mon, 05 Oct 2020 11:21:36 -0700
Message-ID: <160192209677.2569942.16673759463630442919.stgit@magnolia>
In-Reply-To: <160192208358.2569942.13189278742183856412.stgit@magnolia>
References: <160192208358.2569942.13189278742183856412.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=4 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=4 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor xfs_getfsmap to improve its performance: instead of indirectly
calling a function that copies one record to userspace at a time, create
a shadow buffer in the kernel and copy the whole array once at the end.
On the author's computer, this reduces the runtime on his /home by ~20%.

This also eliminates a deadlock when running GETFSMAP against the
realtime device.  The current code locks the rtbitmap to create
fsmappings and copies them into userspace, having not released the
rtbitmap lock.  If the userspace buffer is an mmap of a sparse file that
itself resides on the realtime device, the write page fault will recurse
into the fs for allocation, which will deadlock on the rtbitmap lock.

Fixes: 4c934c7dd60c ("xfs: report realtime space information via the rtbitmap")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c |   45 +++++++++-------
 fs/xfs/xfs_fsmap.h |    6 --
 fs/xfs/xfs_ioctl.c |  146 +++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 125 insertions(+), 72 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index aa36e7daf82c..9ce5e7d5bf8f 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -26,7 +26,7 @@
 #include "xfs_rtalloc.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
-void
+static void
 xfs_fsmap_from_internal(
 	struct fsmap		*dest,
 	struct xfs_fsmap	*src)
@@ -155,8 +155,7 @@ xfs_fsmap_owner_from_rmap(
 /* getfsmap query state */
 struct xfs_getfsmap_info {
 	struct xfs_fsmap_head	*head;
-	xfs_fsmap_format_t	formatter;	/* formatting fn */
-	void			*format_arg;	/* format buffer */
+	struct fsmap		*fsmap_recs;	/* mapping records */
 	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	u64			missing_owner;	/* owner of holes */
@@ -224,6 +223,20 @@ xfs_getfsmap_is_shared(
 	return 0;
 }
 
+static inline void
+xfs_getfsmap_format(
+	struct xfs_mount		*mp,
+	struct xfs_fsmap		*xfm,
+	struct xfs_getfsmap_info	*info)
+{
+	struct fsmap			*rec;
+
+	trace_xfs_getfsmap_mapping(mp, xfm);
+
+	rec = &info->fsmap_recs[info->head->fmh_entries++];
+	xfs_fsmap_from_internal(rec, xfm);
+}
+
 /*
  * Format a reverse mapping for getfsmap, having translated rm_startblock
  * into the appropriate daddr units.
@@ -288,10 +301,7 @@ xfs_getfsmap_helper(
 		fmr.fmr_offset = 0;
 		fmr.fmr_length = rec_daddr - info->next_daddr;
 		fmr.fmr_flags = FMR_OF_SPECIAL_OWNER;
-		error = info->formatter(&fmr, info->format_arg);
-		if (error)
-			return error;
-		info->head->fmh_entries++;
+		xfs_getfsmap_format(mp, &fmr, info);
 	}
 
 	if (info->last)
@@ -323,11 +333,8 @@ xfs_getfsmap_helper(
 		if (shared)
 			fmr.fmr_flags |= FMR_OF_SHARED;
 	}
-	error = info->formatter(&fmr, info->format_arg);
-	if (error)
-		return error;
-	info->head->fmh_entries++;
 
+	xfs_getfsmap_format(mp, &fmr, info);
 out:
 	rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
 	if (info->next_daddr < rec_daddr)
@@ -795,11 +802,11 @@ xfs_getfsmap_check_keys(
 #endif /* CONFIG_XFS_RT */
 
 /*
- * Get filesystem's extents as described in head, and format for
- * output.  Calls formatter to fill the user's buffer until all
- * extents are mapped, until the passed-in head->fmh_count slots have
- * been filled, or until the formatter short-circuits the loop, if it
- * is tracking filled-in extents on its own.
+ * Get filesystem's extents as described in head, and format for output. Fills
+ * in the supplied records array until there are no more reverse mappings to
+ * return or head.fmh_entries == head.fmh_count.  In the second case, this
+ * function returns -ECANCELED to indicate that more records would have been
+ * returned.
  *
  * Key to Confusion
  * ----------------
@@ -819,8 +826,7 @@ int
 xfs_getfsmap(
 	struct xfs_mount		*mp,
 	struct xfs_fsmap_head		*head,
-	xfs_fsmap_format_t		formatter,
-	void				*arg)
+	struct fsmap			*fsmap_recs)
 {
 	struct xfs_trans		*tp = NULL;
 	struct xfs_fsmap		dkeys[2];	/* per-dev keys */
@@ -895,8 +901,7 @@ xfs_getfsmap(
 
 	info.next_daddr = head->fmh_keys[0].fmr_physical +
 			  head->fmh_keys[0].fmr_length;
-	info.formatter = formatter;
-	info.format_arg = arg;
+	info.fsmap_recs = fsmap_recs;
 	info.head = head;
 
 	/*
diff --git a/fs/xfs/xfs_fsmap.h b/fs/xfs/xfs_fsmap.h
index c6c57739b862..a0775788e7b1 100644
--- a/fs/xfs/xfs_fsmap.h
+++ b/fs/xfs/xfs_fsmap.h
@@ -27,13 +27,9 @@ struct xfs_fsmap_head {
 	struct xfs_fsmap fmh_keys[2];	/* low and high keys */
 };
 
-void xfs_fsmap_from_internal(struct fsmap *dest, struct xfs_fsmap *src);
 void xfs_fsmap_to_internal(struct xfs_fsmap *dest, struct fsmap *src);
 
-/* fsmap to userspace formatter - copy to user & advance pointer */
-typedef int (*xfs_fsmap_format_t)(struct xfs_fsmap *, void *);
-
 int xfs_getfsmap(struct xfs_mount *mp, struct xfs_fsmap_head *head,
-		xfs_fsmap_format_t formatter, void *arg);
+		struct fsmap *out_recs);
 
 #endif /* __XFS_FSMAP_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bca7659fb5c6..3fbd98f61ea5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1716,39 +1716,17 @@ xfs_ioc_getbmap(
 	return error;
 }
 
-struct getfsmap_info {
-	struct xfs_mount	*mp;
-	struct fsmap_head __user *data;
-	unsigned int		idx;
-	__u32			last_flags;
-};
-
-STATIC int
-xfs_getfsmap_format(struct xfs_fsmap *xfm, void *priv)
-{
-	struct getfsmap_info	*info = priv;
-	struct fsmap		fm;
-
-	trace_xfs_getfsmap_mapping(info->mp, xfm);
-
-	info->last_flags = xfm->fmr_flags;
-	xfs_fsmap_from_internal(&fm, xfm);
-	if (copy_to_user(&info->data->fmh_recs[info->idx++], &fm,
-			sizeof(struct fsmap)))
-		return -EFAULT;
-
-	return 0;
-}
-
 STATIC int
 xfs_ioc_getfsmap(
 	struct xfs_inode	*ip,
 	struct fsmap_head	__user *arg)
 {
-	struct getfsmap_info	info = { NULL };
 	struct xfs_fsmap_head	xhead = {0};
 	struct fsmap_head	head;
-	bool			aborted = false;
+	struct fsmap		*recs;
+	unsigned int		count;
+	__u32			last_flags = 0;
+	bool			done = false;
 	int			error;
 
 	if (copy_from_user(&head, arg, sizeof(struct fsmap_head)))
@@ -1760,38 +1738,112 @@ xfs_ioc_getfsmap(
 		       sizeof(head.fmh_keys[1].fmr_reserved)))
 		return -EINVAL;
 
+	/*
+	 * Use an internal memory buffer so that we don't have to copy fsmap
+	 * data to userspace while holding locks.  Start by trying to allocate
+	 * up to 128k for the buffer, but fall back to a single page if needed.
+	 */
+	count = min_t(unsigned int, head.fmh_count,
+			131072 / sizeof(struct fsmap));
+	recs = kvzalloc(count * sizeof(struct fsmap), GFP_KERNEL);
+	if (!recs) {
+		count = min_t(unsigned int, head.fmh_count,
+				PAGE_SIZE / sizeof(struct fsmap));
+		recs = kvzalloc(count * sizeof(struct fsmap), GFP_KERNEL);
+		if (!recs)
+			return -ENOMEM;
+	}
+
 	xhead.fmh_iflags = head.fmh_iflags;
-	xhead.fmh_count = head.fmh_count;
 	xfs_fsmap_to_internal(&xhead.fmh_keys[0], &head.fmh_keys[0]);
 	xfs_fsmap_to_internal(&xhead.fmh_keys[1], &head.fmh_keys[1]);
 
 	trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
 	trace_xfs_getfsmap_high_key(ip->i_mount, &xhead.fmh_keys[1]);
 
-	info.mp = ip->i_mount;
-	info.data = arg;
-	error = xfs_getfsmap(ip->i_mount, &xhead, xfs_getfsmap_format, &info);
-	if (error == -ECANCELED) {
-		error = 0;
-		aborted = true;
-	} else if (error)
-		return error;
-
-	/* If we didn't abort, set the "last" flag in the last fmx */
-	if (!aborted && info.idx) {
-		info.last_flags |= FMR_OF_LAST;
-		if (copy_to_user(&info.data->fmh_recs[info.idx - 1].fmr_flags,
-				&info.last_flags, sizeof(info.last_flags)))
-			return -EFAULT;
+	head.fmh_entries = 0;
+	do {
+		struct fsmap __user	*user_recs;
+		struct fsmap		*last_rec;
+
+		user_recs = &arg->fmh_recs[head.fmh_entries];
+		xhead.fmh_entries = 0;
+		xhead.fmh_count = min_t(unsigned int, count,
+					head.fmh_count - head.fmh_entries);
+
+		/* Run query, record how many entries we got. */
+		error = xfs_getfsmap(ip->i_mount, &xhead, recs);
+		switch (error) {
+		case 0:
+			/*
+			 * There are no more records in the result set.  Copy
+			 * whatever we got to userspace and break out.
+			 */
+			done = true;
+			break;
+		case -ECANCELED:
+			/*
+			 * The internal memory buffer is full.  Copy whatever
+			 * records we got to userspace and go again if we have
+			 * not yet filled the userspace buffer.
+			 */
+			error = 0;
+			break;
+		default:
+			goto out_free;
+		}
+		head.fmh_entries += xhead.fmh_entries;
+		head.fmh_oflags = xhead.fmh_oflags;
+
+		/*
+		 * If the caller wanted a record count or there aren't any
+		 * new records to return, we're done.
+		 */
+		if (head.fmh_count == 0 || xhead.fmh_entries == 0)
+			break;
+
+		/* Copy all the records we got out to userspace. */
+		if (copy_to_user(user_recs, recs,
+				 xhead.fmh_entries * sizeof(struct fsmap))) {
+			error = -EFAULT;
+			goto out_free;
+		}
+
+		/* Remember the last record flags we copied to userspace. */
+		last_rec = &recs[xhead.fmh_entries - 1];
+		last_flags = last_rec->fmr_flags;
+
+		/* Set up the low key for the next iteration. */
+		xfs_fsmap_to_internal(&xhead.fmh_keys[0], last_rec);
+		trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
+	} while (!done && head.fmh_entries < head.fmh_count);
+
+	/*
+	 * If there are no more records in the query result set and we're not
+	 * in counting mode, mark the last record returned with the LAST flag.
+	 */
+	if (done && head.fmh_count > 0 && head.fmh_entries > 0) {
+		struct fsmap __user	*user_rec;
+
+		last_flags |= FMR_OF_LAST;
+		user_rec = &arg->fmh_recs[head.fmh_entries - 1];
+
+		if (copy_to_user(&user_rec->fmr_flags, &last_flags,
+					sizeof(last_flags))) {
+			error = -EFAULT;
+			goto out_free;
+		}
 	}
 
 	/* copy back header */
-	head.fmh_entries = xhead.fmh_entries;
-	head.fmh_oflags = xhead.fmh_oflags;
-	if (copy_to_user(arg, &head, sizeof(struct fsmap_head)))
-		return -EFAULT;
+	if (copy_to_user(arg, &head, sizeof(struct fsmap_head))) {
+		error = -EFAULT;
+		goto out_free;
+	}
 
-	return 0;
+out_free:
+	kmem_free(recs);
+	return error;
 }
 
 STATIC int

