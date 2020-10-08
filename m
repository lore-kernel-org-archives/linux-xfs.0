Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E33EC47095
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 13:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B06302083B
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 13:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YABhE/dR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbgJHNqP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 09:46:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730396AbgJHNqP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 09:46:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602164773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+2dL6czcYPJdwFDJJO2gOPu3YwNkJwrAfEmGfXa0TE=;
        b=YABhE/dR0yfG/mFivwknGJ4vC8M3qfU9d7HbFtPiqbGbluTdkEhoqbXVchTHv/XuONPY2J
        6SjuzDxZKvrZGGkLqrjFKao4MHvJ+/DNQbkJ6WoeTc8VSnpgo6TET2kgAOIFunlSczsvY2
        IrT7h/9ltbctkggwhxMxL7VLYx48VL4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-uwxpWbPHPCyHY7R1JYexJA-1; Thu, 08 Oct 2020 09:46:12 -0400
X-MC-Unique: uwxpWbPHPCyHY7R1JYexJA-1
Received: by mail-wr1-f69.google.com with SMTP id v5so3929602wrr.0
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 06:46:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J+2dL6czcYPJdwFDJJO2gOPu3YwNkJwrAfEmGfXa0TE=;
        b=D6OOpVvl8tV5SEjchPxfRUgLRsnngLDXMphv6ZUtosf4+GaS/79vhvGRgQbvY9xLZS
         f4l3K2rxKRk6e1HQ25fhPmmn72+bNZmFYD9WGIsxhofzpRs8hUtRxwiz/1ZH5r+RlnBu
         u+tiv8dvGUjdY4lq8DhQH8JLGK+lGhKTyMkpRPzb8IL8lqSlMqKfWrMghvTdygbyrHrC
         6I+UKtP/rTx7sj7vjFOUf3h3al31/O6fNEeIQBGyZ9rj07YrNySvlqydxS6ePAFphB7A
         rjKJhDwymLhwdfNBbTKsFWHmiVQ9gHiXCsnfrl0+98mPjf4aJY5AycddHSOXzGzIXzXY
         0O8w==
X-Gm-Message-State: AOAM5315y2gZHpLHunHHV+rHwhtt21e//oi1hlpp89ZoT3qJkmITn4rX
        zdsnQ8Yej48EUmHnIj0UkhAKuOQKz8ycu0/QkGW4J7DmyB5nBHFzfS2pP5MHWKqQTv/uOmAo+zn
        8WznWrsAnpbuddr9p4tOp
X-Received: by 2002:a1c:f20f:: with SMTP id s15mr9006575wmc.69.1602164770446;
        Thu, 08 Oct 2020 06:46:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwO/J3F2RaFQzAouvqI3e6PBUXLNzsUkh8uDER2BgJPm2s2VV5amQ3gMCGgnQf7fA81bLbPeg==
X-Received: by 2002:a1c:f20f:: with SMTP id s15mr9006557wmc.69.1602164770278;
        Thu, 08 Oct 2020 06:46:10 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id s19sm7069465wmc.41.2020.10.08.06.46.09
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 06:46:09 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 3/4] xfs: xfs_isilocked() can only check a single lock type
Date:   Thu,  8 Oct 2020 15:46:04 +0200
Message-Id: <20201008134605.863269-4-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201008134605.863269-1-preichl@redhat.com>
References: <20201008134605.863269-1-preichl@redhat.com>
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
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ced3b996cd8a..ff5cc8a5d476 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5787,7 +5787,8 @@ xfs_bmap_collapse_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
@@ -5904,7 +5905,8 @@ xfs_bmap_insert_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
-- 
2.26.2

