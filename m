Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3D5C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 01:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhLPBJb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Dec 2021 20:09:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48120 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhLPBJ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 20:09:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C654B8226B
        for <linux-xfs@vger.kernel.org>; Thu, 16 Dec 2021 01:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1461C36AE1;
        Thu, 16 Dec 2021 01:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639616966;
        bh=LCsWpvfM7oVyUXPZrKubG7mceV7f1hUET1sWtlIb0Ew=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ACtmmIcB1PWK0RVKjv70Jz4gj46+ge9WZxB28q9bSBzjOKHAnCkerGazImL1yC3gU
         Dy94vJhvAKozbnzptMxICIKrct3E7WNLvKMvJ3c1ApbnxsnPsak3yRgpOFzpQfmBIo
         33KPEIYz16Gz68swOPyYJUUd8kldfd+4c7NLnZFC4YWw/DcQd6+3qqtytXDIPDzTaJ
         mVva7IDICTAGFCm0PS8k2h2CS2dBO+ujg0hj1C+q2m41JcQSGOzHw1iwlkfN0BXN7T
         fwA+SpIfuuK8H7jcGtqIzMSg7ANTRDick6eVGK14Zdl+FhraoUY3KOhcrk/I5rOT46
         L8rv8izc2c2Vw==
Subject: [PATCH 2/7] xfs: shut down filesystem if we xfs_trans_cancel with
 deferred work items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Dec 2021 17:09:26 -0800
Message-ID: <163961696648.3129691.5075630610079213754.stgit@magnolia>
In-Reply-To: <163961695502.3129691.3496134437073533141.stgit@magnolia>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While debugging some very strange rmap corruption reports in connection
with the online directory repair code.  I root-caused the error to the
following incorrect sequence:

<start repair transaction>
<expand directory, causing a deferred rmap to be queued>
<roll transaction>
<cancel transaction>

Obviously, we should have committed the transaction instead of
cancelling it.  Thinking more broadly, however, xfs_trans_cancel should
have warned us that we were throwing away work item that we already
committed to performing.  This is not correct, and we need to shut down
the filesystem.

Change xfs_trans_cancel to complain in the loudest manner if we're
cancelling any transaction with deferred work items attached.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 234a9d9c2f43..59e2f9031b9f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -942,8 +942,17 @@ xfs_trans_cancel(
 
 	trace_xfs_trans_cancel(tp, _RET_IP_);
 
-	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
+	/*
+	 * It's never valid to cancel a transaction with deferred ops attached,
+	 * because the transaction is effectively dirty.  Complain about this
+	 * loudly before freeing the in-memory defer items.
+	 */
+	if (!list_empty(&tp->t_dfops)) {
+		ASSERT(xfs_is_shutdown(mp) || list_empty(&tp->t_dfops));
+		ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+		dirty = true;
 		xfs_defer_cancel(tp);
+	}
 
 	/*
 	 * See if the caller is relying on us to shut down the

