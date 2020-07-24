Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE244C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 06:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98CEC20714
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 06:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mw8uXqKl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgGXGNy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 02:13:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58848 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726178AbgGXGNy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 02:13:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595571232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=BO9n6hVZpzBnYCRr3ajb6n9ABkf1XIdzDLUFQFkkBXg=;
        b=Mw8uXqKlDUncI9OeWGZMffQq+DgoooXG845FVPkdNyjwboxJx5Rdy3WgcMVhQ+twYzI0hM
        FBah3SetED078JiWRL/iQncNIimbCHf4GwpJqZZ6rdzC2eRRRDizoBo8TidXwYCKFyi36i
        VUEsFkxq36cMR1K8A75ZSqpGq9+AF0g=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-fBNXa7xtPn6PKdQ7QccUVQ-1; Fri, 24 Jul 2020 02:13:50 -0400
X-MC-Unique: fBNXa7xtPn6PKdQ7QccUVQ-1
Received: by mail-pl1-f200.google.com with SMTP id o10so4887221plk.12
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2020 23:13:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BO9n6hVZpzBnYCRr3ajb6n9ABkf1XIdzDLUFQFkkBXg=;
        b=ahG6KqWOgPnREa4CjUIk3PcW1pqV+uVZa5GxRJPqyqJxizcFRKGa2vM6mHwjErwj7z
         5pEGx9u56by/BYJBcJATbYxLX5uFlpr1y42s84JYXhDkWXFFYtXgEIaV69PakfoUxi0o
         +GZFVcFldjqHOfLFf3nFZ+q75AGtLOqdE0RUerekTXRHZ1CiusmHIt51Czua49GK9RBN
         7ZGpRQKW+MVrO1VZSVHWVaQiWoerxr/eQeHScY/mwZ0tjPdwhFXgJc9ova6/AhMg2rNE
         a5oLjtLwTG+EKNX30v2qrWKFpk/BJM+TXthoiiCcUzmG51Rv6RRpAksN8L4JMqlJWyTz
         bkMg==
X-Gm-Message-State: AOAM532u2m3WHKpZAlTk1oKy0cZnz0QVzIBp4k2nsM40TWyHhVEn0vM/
        XxL/6F3JglaBnzwdFrlYMkttrMwGrp/LIq67jH79XWcrmLj/QoMcxVvkvuFGKJ6lNVU0QwFJMcl
        91N3vLjubNx6oIALaGRJq
X-Received: by 2002:a17:90b:142:: with SMTP id em2mr3698916pjb.236.1595571228764;
        Thu, 23 Jul 2020 23:13:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwi0lfJxN3LUPXyniNKbGZ5zXjR4At1YzAr1dGX1T7B5reH5/EJCMd0ieU4V59nKoevcW9czQ==
X-Received: by 2002:a17:90b:142:: with SMTP id em2mr3698899pjb.236.1595571228533;
        Thu, 23 Jul 2020 23:13:48 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n15sm4899232pjf.12.2020.07.23.23.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 23:13:47 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v2 1/3] xfs: arrange all unlinked inodes into one list
Date:   Fri, 24 Jul 2020 14:12:57 +0800
Message-Id: <20200724061259.5519-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200724061259.5519-1-hsiangkao@redhat.com>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200724061259.5519-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is no need to keep old multiple short unlink inode buckets
since we have an in-memory double linked list for all unlinked
inodes.

Apart from the perspective of the necessity, the main advantage
is the log and AGI update can be reduced since each AG has the
only one head now, which is implemented in the following patches.

Therefore, this patch applies the new way in xfs_iunlink() and
keep the old approach in xfs_iunlink_remove_inode() path as
well so inode eviction can still work properly in recovery.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_inode.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ab288424764c..4994398373df 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -33,6 +33,7 @@
 #include "xfs_symlink.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_iunlink_item.h"
@@ -2001,14 +2002,13 @@ xfs_iunlink_insert_inode(
 	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 
 	/*
 	 * Get the index into the agi hash table for the list this inode will
 	 * go on.  Make sure the pointer isn't garbage and that this inode
 	 * isn't already on the list.
 	 */
-	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	next_agino = be32_to_cpu(agi->agi_unlinked[0]);
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
 		xfs_buf_mark_corrupt(agibp);
@@ -2036,7 +2036,7 @@ xfs_iunlink_insert_inode(
 	}
 
 	/* Point the head of the list to point to this inode. */
-	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
+	return xfs_iunlink_update_bucket(tp, agno, agibp, 0, agino);
 }
 
 /*
@@ -2055,10 +2055,17 @@ xfs_iunlink_remove_inode(
 	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino = ip->i_next_unlinked;
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
 	if (ip->i_prev_unlinked == NULLAGINO) {
+		struct xlog	*log = mp->m_log;
+		short		bucket_index = 0;
+
+		/* During recovery, the old multiple bucket can be applied */
+		if ((!log || log->l_flags & XLOG_RECOVERY_NEEDED) &&
+		    be32_to_cpu(agi->agi_unlinked[0]) != agino)
+			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+
 		/* remove from head of list */
 		if (be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino) {
 			xfs_buf_mark_corrupt(agibp);
-- 
2.18.1

