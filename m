Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF297C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 983342064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="chEmxQqP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgAABJB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52922 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xYg109458
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QfJwhhf4iNm3FTBow7upUy3SCx+PM8aXJKtmaBuZ+s4=;
 b=chEmxQqP0UJwTl+0x6XZWNQf6n6LWObt5MzXKPjTeRoJU0h9WGyLcvv0Lii2lcKJ3/ar
 qAP06kuCjvcV2B8fqiTC4zhjgx4q4nC0emh/AkBboz+PfMuVq4SNBxwvOW4EtAtAeIDx
 ocY13GjPtQ7t1HAsAVvPTf/sQXj9wOZKlFe9RKCPRdqLAHTVwaajNn5WxIFjN4ob+qPG
 Xn3J181Gerqk5s6E3fCHD350CmgYMwJmzGvliQjWuyfLiUTUO+W/KEzam+3jIyPWDLmR
 ZF20YDGnG4eTsw8WlvXeWf5RzMUZrPp7GYmwstTP0HRyDY7X14kVotz3lVIUOPVvrSdq 6Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk2c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uIV190239
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrfy2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:57 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 001185rL031041
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:05 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:08:04 -0800
Subject: [PATCH 1/6] xfs: refactor the predicate part of xfs_free_eofblocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:08:02 -0800
Message-ID: <157784088213.1361683.10381610571454563314.stgit@magnolia>
In-Reply-To: <157784087594.1361683.5987233633798863051.stgit@magnolia>
References: <157784087594.1361683.5987233633798863051.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the part of _free_eofblocks that decides if it's really going
to truncate post-EOF blocks into a separate helper function.  The
upcoming deferred inode inactivation patch requires us to be able to
decide this prior to actual inactivation.  No functionality changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |  105 +++++++++++++++++++++---------------------------
 fs/xfs/xfs_inode.c     |   36 ++++++++++++++++
 fs/xfs/xfs_inode.h     |    1 
 3 files changed, 82 insertions(+), 60 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index cd993802cfa2..6553d533d659 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -637,78 +637,63 @@ xfs_free_eofblocks(
 	struct xfs_inode	*ip)
 {
 	struct xfs_trans	*tp;
-	int			error;
-	xfs_fileoff_t		end_fsb;
-	xfs_fileoff_t		last_fsb;
-	xfs_filblks_t		map_len;
-	int			nimaps;
-	struct xfs_bmbt_irec	imap;
 	struct xfs_mount	*mp = ip->i_mount;
+	bool			has;
+	int			error;
 
 	/*
-	 * Figure out if there are any blocks beyond the end
-	 * of the file.  If not, then there is nothing to do.
+	 * If there are blocks after the end of file, truncate the file to its
+	 * current size to free them up.
 	 */
-	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
-	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-	if (last_fsb <= end_fsb)
-		return 0;
-	map_len = last_fsb - end_fsb;
-
-	nimaps = 1;
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	error = xfs_has_eofblocks(ip, &has);
+	if (error || !has)
+		return error;
 
 	/*
-	 * If there are blocks after the end of file, truncate the file to its
-	 * current size to free them up.
+	 * Attach the dquots to the inode up front.
 	 */
-	if (!error && (nimaps != 0) &&
-	    (imap.br_startblock != HOLESTARTBLOCK ||
-	     ip->i_delayed_blks)) {
-		/*
-		 * Attach the dquots to the inode up front.
-		 */
-		error = xfs_qm_dqattach(ip);
-		if (error)
-			return error;
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
 
-		/* wait on dio to ensure i_size has settled */
-		inode_dio_wait(VFS_I(ip));
+	/* wait on dio to ensure i_size has settled */
+	inode_dio_wait(VFS_I(ip));
 
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
-				&tp);
-		if (error) {
-			ASSERT(XFS_FORCED_SHUTDOWN(mp));
-			return error;
-		}
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error) {
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		return error;
+	}
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, 0);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
-		/*
-		 * Do not update the on-disk file size.  If we update the
-		 * on-disk file size and then the system crashes before the
-		 * contents of the file are flushed to disk then the files
-		 * may be full of holes (ie NULL files bug).
-		 */
-		error = xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
-					XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
-		if (error) {
-			/*
-			 * If we get an error at this point we simply don't
-			 * bother truncating the file.
-			 */
-			xfs_trans_cancel(tp);
-		} else {
-			error = xfs_trans_commit(tp);
-			if (!error)
-				xfs_inode_clear_eofblocks_tag(ip);
-		}
+	/*
+	 * Do not update the on-disk file size.  If we update the
+	 * on-disk file size and then the system crashes before the
+	 * contents of the file are flushed to disk then the files
+	 * may be full of holes (ie NULL files bug).
+	 */
+	error = xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
+				XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
+	if (error)
+		goto err_cancel;
 
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	}
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_unlock;
+
+	xfs_inode_clear_eofblocks_tag(ip);
+	goto out_unlock;
+
+err_cancel:
+	/*
+	 * If we get an error at this point we simply don't
+	 * bother truncating the file.
+	 */
+	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c41003fae9d5..1187ff7035d9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3962,3 +3962,39 @@ xfs_irele(
 	trace_xfs_irele(ip, _RET_IP_);
 	iput(VFS_I(ip));
 }
+
+/*
+ * Decide if this inode have post-EOF blocks.  The caller is responsible
+ * for knowing / caring about the PREALLOC/APPEND flags.
+ */
+int
+xfs_has_eofblocks(
+	struct xfs_inode	*ip,
+	bool			*has)
+{
+	struct xfs_bmbt_irec	imap;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		end_fsb;
+	xfs_fileoff_t		last_fsb;
+	xfs_filblks_t		map_len;
+	int			nimaps;
+	int			error;
+
+	*has = false;
+	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
+	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
+	if (last_fsb <= end_fsb)
+		return 0;
+	map_len = last_fsb - end_fsb;
+
+	nimaps = 1;
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (error || nimaps == 0)
+		return error;
+
+	*has = imap.br_startblock != HOLESTARTBLOCK || ip->i_delayed_blks;
+	return 0;
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 492e53992fa9..377e02cd3c0a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -497,6 +497,7 @@ extern struct kmem_zone	*xfs_inode_zone;
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
 bool xfs_inode_verify_forks(struct xfs_inode *ip);
+int xfs_has_eofblocks(struct xfs_inode *ip, bool *has);
 
 int xfs_iunlink_init(struct xfs_perag *pag);
 void xfs_iunlink_destroy(struct xfs_perag *pag);

