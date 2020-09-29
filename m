Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B3FC4741F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 14:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E086021D43
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 14:12:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LyEQ1c5E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgI2OMe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 10:12:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728140AbgI2OMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 10:12:34 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601388752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fUR3E/nL29/sUn3/5Q7yO/bBpcJBDK4+C+Ih652mObs=;
        b=LyEQ1c5EPbi/Fb8DcJIU66uvN1WA9lOEk5421RXhrbR07cEDqkcvDgITA09Cg3Oom/2r9I
        iyImw7MPpTJfJXtt3CCNnakASayal4XsOTq5haOJXwRmbs1GeXeqMoLFGNc82UbtavY7iP
        qfBvwQxHCWqdllqxuLVyl5Wsdmq+W3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-WsjB6NpQOvmaHFGz52pcrA-1; Tue, 29 Sep 2020 10:12:30 -0400
X-MC-Unique: WsjB6NpQOvmaHFGz52pcrA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E75221DDFF
        for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2020 14:12:29 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-202.rdu2.redhat.com [10.10.113.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA80419C4F
        for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2020 14:12:29 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 2/3] xfs: temporary transaction subsystem freeze hack
Date:   Tue, 29 Sep 2020 10:12:27 -0400
Message-Id: <20200929141228.108688-3-bfoster@redhat.com>
In-Reply-To: <20200929141228.108688-1-bfoster@redhat.com>
References: <20200929141228.108688-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Implement a quick hack to abuse the superblock freeze mechanism to
freeze the XFS transaction subsystem.

XXX: to be replaced

Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans.c | 16 ++++++++++++++++
 fs/xfs/xfs_trans.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index ca18a040336a..5cb9cb44e963 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1024,3 +1024,19 @@ xfs_trans_roll(
 	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 	return xfs_trans_reserve(*tpp, &tres, 0, 0);
 }
+
+void
+xfs_trans_freeze(
+	struct xfs_mount	*mp)
+{
+	struct super_block	*sb = mp->m_super;
+	percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_WRITE-1);
+}
+
+void
+xfs_trans_unfreeze(
+	struct xfs_mount	*mp)
+{
+	struct super_block	*sb = mp->m_super;
+	percpu_up_write(sb->s_writers.rw_sem + SB_FREEZE_WRITE-1);
+}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f46534b75236..ec1d5a5c2610 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -233,6 +233,8 @@ int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
 void		xfs_trans_cancel(xfs_trans_t *);
+void		xfs_trans_freeze(struct xfs_mount *);
+void		xfs_trans_unfreeze(struct xfs_mount *);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
 
-- 
2.25.4

