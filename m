Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D084C47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 18:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3084B206DB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 18:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NkHxaJwO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730974AbgEKSuZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 14:50:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33120 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729685AbgEKSuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 14:50:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589223024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=T1mWqMnO1lvy7SjhFSEdJuYHbRMkaCR2KMp0QCIe64w=;
        b=NkHxaJwODPIAcIE+nZ4mLFJbZBsDDamlQG7+8r6LQDwWx+c27rxQYTQoGV3MC2uQn4nB1O
        cCFXT4cNC41Y30ZMYa5IqxFjlvVEPdOz9T73Egj06ypPJJKO8q3UVOmSF0UPsRPQ9WbXis
        qeQhV/lzevgPnzQtGaNeUvFNk13O8Fg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-UvQoTCyUMLi9hlTU79kBag-1; Mon, 11 May 2020 14:50:17 -0400
X-MC-Unique: UvQoTCyUMLi9hlTU79kBag-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7D241009600
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 18:50:16 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83AEA5C1B5
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 18:50:16 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC] xfs: warn instead of fail verifier on empty attr3 leaf block
Date:   Mon, 11 May 2020 14:50:16 -0400
Message-Id: <20200511185016.33684-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

What do folks think of something like this? We have a user report of a
corresponding read verifier failure while processing unlinked inodes.
This presumably means the attr fork was put in this state because the
format conversion and xattr set are not atomic. For example, the
filesystem crashed after the format conversion transaction hit the log
but before the xattr set transaction. The subsequent recovery succeeds
according to the logic below, but if the attr didn't hit the log the
leaf block remains empty and sets a landmine for the next read attempt.
This either prevents further xattr operations on the inode or prevents
the inode from being removed from the unlinked list due to xattr
inactivation failure.

I've not confirmed that this is how the user got into this state, but
I've confirmed that it's possible. We have a couple band aids now (this
and the writeback variant) that intend to deal with this problem and
still haven't quite got it right, so personally I'm inclined to accept
the reality that an empty attr leaf block is an expected state based on
our current xattr implementation and just remove the check from the
verifier (at least until we have atomic sets). I turned it into a
warning/comment for the purpose of discussion. Thoughts?

Brian

 fs/xfs/libxfs/xfs_attr_leaf.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 863444e2dda7..71cee43669e1 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -309,12 +309,18 @@ xfs_attr3_leaf_verify(
 		return fa;
 
 	/*
-	 * In recovery there is a transient state where count == 0 is valid
-	 * because we may have transitioned an empty shortform attr to a leaf
-	 * if the attr didn't fit in shortform.
+	 * There is a valid count == 0 state if we transitioned an empty
+	 * shortform attr to leaf format because an attr didn't fit in
+	 * shortform. This is intended to transient during recovery, but in
+	 * reality is not because the attr comes in a separate transaction from
+	 * format conversion and may not have hit the log. Warn if we encounter
+	 * this outside of recovery just to inform the user something might be
+	 * off.
 	 */
 	if (!xfs_log_in_recovery(mp) && ichdr.count == 0)
-		return __this_address;
+		xfs_warn(mp,
+	"Empty attr leaf block (bno 0x%llx). attr fork in unexpected format\n",
+			 bp->b_bn);
 
 	/*
 	 * firstused is the block offset of the first name info structure.
-- 
2.21.1

