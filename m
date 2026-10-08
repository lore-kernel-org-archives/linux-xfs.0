Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4166C3BBFBD
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 12:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791462708; cv=none; b=gjr9z7d5bdDzLR2gyJ6sW7KssoIPYFnxYvMlYUElEgK/iJN9PKp6KsCq3a+MlBcas3iszIRajHl6cNKpWq+UPvdLZ0OwqrlDlooRxhefsjrncLt2Nr6UO6eAfzM/oDXWTl9OoiudQY5PsT0glFxJOy7NhFa41A5zX3hgpI0fwiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791462708; c=relaxed/simple;
	bh=RSc82EyOPvu2yon2woZrQi/U94upL8h677IxWnPSu/8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gMocBYpmXMU/Ofs4jzAeJEwNjHqGrRfce2iM5D6hw4rLaL0oL8bvItvz05dJLYBT6d+Y/w3WvSA60SG77F0o3c7MDFfF8Xk+6AcgPKpWJuyCF94L+w3krZSJcGZBbfD4iw/QnbatvDAjd/xqv8stSHObFPj6eLSumiO1tAEZ4g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D25YZSnE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D25YZSnE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791462705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cjckrhUfON0qWN18ql+SWJjFZbuuzq9SuBDZ4TG7VtA=;
	b=D25YZSnExjskQgtZRLlzDS1IbwbDRAGp7rC34kQMeQ5PB5ekyQ+scOQvtE4HDm7V3otneS
	xl4aIt5U6oGj88Q2l8By0ksY29jkwg7kljAP9WtC+GLBNdFKKQ+VZ2y7xcC/+JgPZO5Uk+
	G+LMtyep0O2Q++5Fs40SSxmwirohqeo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-paOdejoeOmWlf4pKYEjjOw-1; Thu,
 08 Oct 2026 08:31:43 -0400
X-MC-Unique: paOdejoeOmWlf4pKYEjjOw-1
X-Mimecast-MFC-AGG-ID: paOdejoeOmWlf4pKYEjjOw_1791462702
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D80D195FE32
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 12:31:42 +0000 (UTC)
Received: from bfoster.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0CEF230000E6
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 12:31:41 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: restore pre flushing optimization xfsaild iteration behavior
Date: Thu,  8 Oct 2026 08:31:41 -0400
Message-ID: <20261008123141.358649-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Commit f3f7ae68a4ea ("xfs: skip flushing log items during push")
implements an optimization to avoid repeated indirect ->iop_push()
function calls for inodes that are already flushed via cluster
buffer flushes. It also changes how flushing inodes are accounted
and how xfsaild processes the AIL list.

We have a report of a soft lockup in this task that is potentially
enabled by these behavior changes. The schedule timeout for the
partial push case was reduced to 0 and the flushing inode item
filtering changes the semantics of the 90% stuck heuristic, which
potentially bypasses another form of task throttling. Both of these
combined increase the risk of excessive spinning.

To address this problem, rework the original optimization to skip
->iop_push() calls without altering iteration and accounting
behavior. Push the flushing check down into xfsaild_push_item(),
which allows flushing inodes to be accounted as they were prior to
the original commit. Remove the count based loop iteration break and
restore the previous tout value. These changes can be revisited in a
follow on patch that documents design/intent and includes any newly
discovered dependent functionality.

Reported-by: MingTao Huang <mintaohuang@tencent.com>
Assisted-by: LLM
Fixes: f3f7ae68a4ea ("xfs: skip flushing log items during push")
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is completely untested. I'm mainly posting as a point of reference
for the discussion here [1], and there is disagreement. I'll revisit in
the future if this becomes worth pushing further.

Brian

[1] https://lore.kernel.org/linux-xfs/tencent_F801A9436DFB447AAFEC63D3E615B8052405@qq.com/

 fs/xfs/xfs_trans_ail.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index f955479a08fd..652b09c7dce3 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -392,6 +392,8 @@ xfsaild_push_item(
 	 */
 	if (!lip->li_ops->iop_push)
 		return XFS_ITEM_PINNED;
+	if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
+		return XFS_ITEM_FLUSHING;
 	if (test_bit(XFS_LI_FAILED, &lip->li_flags))
 		return xfsaild_resubmit_item(lip, &ailp->ail_buf_list);
 	return lip->li_ops->iop_push(lip, &ailp->ail_buf_list);
@@ -581,9 +583,6 @@ xfsaild_push(
 	lsn = lip->li_lsn;
 	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
 
-		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
-			goto next_item;
-
 		xfsaild_process_logitem(ailp, lip, &stuck, &flushing);
 		count++;
 
@@ -603,12 +602,9 @@ xfsaild_push(
 		if (stuck > 100)
 			break;
 
-next_item:
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 		if (lip == NULL)
 			break;
-		if (lip->li_lsn != lsn && count > 1000)
-			break;
 		lsn = lip->li_lsn;
 	}
 
@@ -645,7 +641,7 @@ xfsaild_push(
 		/*
 		 * Assume we have more work to do in a short while.
 		 */
-		tout = 0;
+		tout = 10;
 	}
 
 	return tout;
-- 
2.55.0

