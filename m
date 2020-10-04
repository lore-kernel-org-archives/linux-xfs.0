Return-Path: <SRS0=mrUW=DL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B3AC4363C
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Oct 2020 19:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D017C2068E
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Oct 2020 19:14:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UxfTb/vC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgJDTOy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Oct 2020 15:14:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58558 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgJDTOw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Oct 2020 15:14:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 094JEOpu194886;
        Sun, 4 Oct 2020 19:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JgP+N2mIAevDDGoc1RgFkX8+0iqKZEuUROz/SsL8GBw=;
 b=UxfTb/vCl1W59eKHjMp23JcpHxAhtOtl2MeWzmIqDFk7pmdh3bIo+vZxwl8prL35kPlH
 eP40zaBI3wKKwspQal+8kTMn3SuGaN/lpDwa5Qpqvak9yb4RfhFOWl8nLQi+H8kWdjr9
 f+uW7k9im49UV9kmKDQRlw/HoarI3B+N9zqv55FoQflxVS/P806V1NNCdw16iTU9hA1e
 aSvoe/TL3KF1/pHsOdg9t0A71Al7FiG75qoScY2PAM3ljNmjB31N3uwIAOXKrMllk39/
 QJmXRmyihW5DYNyh52MwMoJ1DBBjXnyxeWqKenAhV+KRD1TfCKlV4JqM52JMWrQOrj0h Vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33ym3480hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 04 Oct 2020 19:14:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 094JA2gR193061;
        Sun, 4 Oct 2020 19:14:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33y37u9c5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 04 Oct 2020 19:14:23 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 094JEFlT008680;
        Sun, 4 Oct 2020 19:14:15 GMT
Received: from localhost (/10.159.155.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 04 Oct 2020 12:14:14 -0700
Date:   Sun, 4 Oct 2020 12:14:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v1.2 2/2] xfs: fix deadlock and streamline xfs_getfsmap
 performance
Message-ID: <20201004191414.GD49547@magnolia>
References: <160161415855.1967459.13623226657245838117.stgit@magnolia>
 <160161417069.1967459.11222290374186255598.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160161417069.1967459.11222290374186255598.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9764 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=7 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010040146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9764 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=7 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010040147
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

While we're at it, constrain the kernel memory buffer size so that
userspace can't whack the kernel with huge memory allocations.

Fixes: 4c934c7dd60c ("xfs: report realtime space information via the rtbitmap")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: constrain the internal buffer size and loop xfs_getfsmap calls
until we fill the userspace buffer or run out of result rows
---
 fs/xfs/xfs_fsmap.c |   45 +++++++++-------
 fs/xfs/xfs_fsmap.h |    6 --
 fs/xfs/xfs_ioctl.c |  147 +++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 126 insertions(+), 72 deletions(-)

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
index bca7659fb5c6..a08fc7eb3e93 100644
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
@@ -1760,38 +1738,113 @@ xfs_ioc_getfsmap(
 		       sizeof(head.fmh_keys[1].fmr_reserved)))
 		return -EINVAL;
 
+	/*
+	 * Use an internal memory buffer so that we don't have to copy fsmap
+	 * data to userspace while holding locks.  Start by trying to allocate
+	 * up to 16 pages for the buffer, but fall back to a single page if we
+	 * have to.
+	 */
+	count = min_t(unsigned int, head.fmh_count,
+			(16 * PAGE_SIZE) / sizeof(struct fsmap));
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
