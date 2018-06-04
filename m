Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbeFDXuG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Jun 2018 19:50:06 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 744523002489
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jun 2018 23:50:06 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4449660E37
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jun 2018 23:50:06 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: use xfs_trans_getsb in xfs_sync_sb_buf
Message-ID: <bd3ee55c-30a4-4e45-10fc-3458c7b93a1d@redhat.com>
Date: Mon, 4 Jun 2018 18:50:05 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Use xfs_trans_getsb rather than reaching right in for
mp->m_sb_bp; I think this is more correct, and it facilitates
building this libxfs code in userspace as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This passes the online label test ... tbh I'm not quite
sure if I'm unwinding/unlocking/putting the bp properly
here, though, so ... eyes & advice appreciated?

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 0bc0a40764e1..5f25aac04aa9 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -897,14 +897,16 @@ xfs_sync_sb_buf(
 	struct xfs_mount	*mp)
 {
 	struct xfs_trans	*tp;
+	struct xfs_buf		*bp;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
 	if (error)
 		return error;
 
+	bp = xfs_trans_getsb(tp, mp, 0);
 	xfs_log_sb(tp);
-	xfs_trans_bhold(tp, mp->m_sb_bp);
+	xfs_trans_bhold(tp, bp);
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
@@ -912,9 +914,9 @@ xfs_sync_sb_buf(
 	/*
 	 * write out the sb buffer to get the changes to disk
 	 */
-	error = xfs_bwrite(mp->m_sb_bp);
+	error = xfs_bwrite(bp);
 out:
-	xfs_buf_relse(mp->m_sb_bp);
+	xfs_buf_relse(bp);
 	return error;
 }
 
