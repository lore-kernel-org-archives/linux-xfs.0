Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B45C00A89
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 19:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7233D22268
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 19:41:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AhwZD2iD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgKBTlr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 14:41:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgKBTlq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 14:41:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604346105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2XRIs7DXzBubAxQtzgYxk8wipb85gWL2/e2ZaaSZQqE=;
        b=AhwZD2iD2yAkG4Id2vB/of/yUjDdoTIGHXQQScf//ssWq4kUzsrK+NXoXXN4FMHk15vutY
        OL/q1w8muY9pD6kmTSM+sM3hYAfdIUX80xW8gz8cp1dhzgKoscsTq1T1fmdnebgyndkIiH
        l9RKr1YXMneOeFKz6KFZKX0LLPRvV+4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-HBfdr_NPO3y_GTGVBegwXA-1; Mon, 02 Nov 2020 14:41:43 -0500
X-MC-Unique: HBfdr_NPO3y_GTGVBegwXA-1
Received: by mail-wr1-f70.google.com with SMTP id 31so6808472wrg.12
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 11:41:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2XRIs7DXzBubAxQtzgYxk8wipb85gWL2/e2ZaaSZQqE=;
        b=TfAVI5hHvGRP1lc2ONc5MmI6qmagB790eGWBEjNXFMNQsdXkIOrNoMe5QJF5GpuDOH
         siBaG/1F0yYreAjqdLLEBb1eGrS/1m/yD9qXSCWH9gl0hhXIXYy8iSc137SHEyvI43QB
         Abt/iEXiEbDtBcj1izFoCNvLggE4txrUp+ftKMZx6OzXO6NmPgfeKVLq+LJmsysAPCiA
         L/aHLOInkdWB85n3Lgyujp3yW5LuBuw+WoIpAsyf0+N9U31W+XF4YQIokzrpc0JCRUAH
         WMnyGngWWhULdZnk+NnIRn0KUTSwj/EXzndVpli5AhAzmDHmab4oCOkXITq34M3GI8sa
         Bx6Q==
X-Gm-Message-State: AOAM533zN1f7IQECf6W0xakXi2eCgr5oqlq2w7srlv6UHcFPvuHrRSTZ
        YHogY5UAU16oQkZyRowUWmkdbwR9UAW1HbDcI0dTTFcr0DBN9tKL/U7S1cIUJXo+KLxdMGbLCXW
        zBKXDIsXU/OoOrbH9zv8V
X-Received: by 2002:adf:80cb:: with SMTP id 69mr21763149wrl.325.1604346102265;
        Mon, 02 Nov 2020 11:41:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygnY0zj/k8+fHqqNbEv+P6/lrbP8ufM2RwZmTR05Ow9j4nTfo/95s4aER396RCO1puXUzhoQ==
X-Received: by 2002:adf:80cb:: with SMTP id 69mr21763144wrl.325.1604346102117;
        Mon, 02 Nov 2020 11:41:42 -0800 (PST)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id 6sm11742465wrc.88.2020.11.02.11.41.40
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 11:41:40 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 3/4] xfs: xfs_isilocked() can only check a single lock type
Date:   Mon,  2 Nov 2020 20:41:34 +0100
Message-Id: <20201102194135.174806-4-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102194135.174806-1-preichl@redhat.com>
References: <20201102194135.174806-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In its current form, xfs_isilocked() is only able to test one lock type
at a time - ilock, iolock, or mmap lock, but combinations are not
properly handled. The intent here is to check that both XFS_IOLOCK_EXCL
and XFS_ILOCK_EXCL are held, so test them each separately.

The commit ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents") ORed the
flags together which was an error, so this patch reverts that part of
the change and check the locks independently.

Fixes: ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents")

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 666aa47e4f4f..558e113e267f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5792,7 +5792,8 @@ xfs_bmap_collapse_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
@@ -5909,7 +5910,8 @@ xfs_bmap_insert_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
-- 
2.26.2

