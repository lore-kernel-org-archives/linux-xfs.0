Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EA6C41604
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 19:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2EDE206CB
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 19:15:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fCTcnu0L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgJFTPw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 15:15:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42988 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726918AbgJFTPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 15:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602011750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+2dL6czcYPJdwFDJJO2gOPu3YwNkJwrAfEmGfXa0TE=;
        b=fCTcnu0LIsm4LT9zcdrJ0Irgj2YQOPqlUU3wNZp6dfWIy0IedHuAYxQDeLuv2rTvEGxU99
        3XqQzytvq8zlcoyK8HWK22vNn8tZAvYH4XDOY+DOeKf0sZPapq76CQgLPjsrBJ6p509FIG
        N1kzTOgFZWntB18lnhl5+ahaukVteqE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-4WVIDdE-M8uIMOuvbYxgdQ-1; Tue, 06 Oct 2020 15:15:48 -0400
X-MC-Unique: 4WVIDdE-M8uIMOuvbYxgdQ-1
Received: by mail-wm1-f70.google.com with SMTP id a25so1479561wmb.2
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2020 12:15:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J+2dL6czcYPJdwFDJJO2gOPu3YwNkJwrAfEmGfXa0TE=;
        b=L8NfFJcLI3gjWkhjyhJlGvBnLmntav6mzacv/CTf5uxw2imLvTNd7tWWqe5GWMWLJN
         mNWbk2qfuHpDU8r+hxxjUm+z6KZ4nLfxJfU96n6EjZbDQFHdlA5r7zTXClavaYUg9F9V
         eMRPbtN7w8PdnPdN8DiUQ6gUUFDZXN/zk6nWr6xfumGbVrpoV7GsrZN2yYomHpPm2wQB
         yJB0XIk5b+9oy+gS8UIcoOv6ZWDQBvgejeZagorlHYww5Bnc8Y8KK/4hQZ3TUY1l6VrI
         tVnHXcakemCu9joQeSx7IXgeUdrmN9bJrs+hNJaGr3PjGKv7W/JFGZk+tOJlRoc3xU+F
         hasw==
X-Gm-Message-State: AOAM532/zqoXhcbWS4N/Cqqa19iFSvOzVbWxDzu0+v6DJiGmYtPQ8Qxy
        jheWhgfjJWIrzoSyXcXB3EDK/qAgyUt42amSIm0Nzez+iqZccNY4ZvuT/Du1jB17DO2QG7pF3/t
        MCPS/r67KJKKl3EETr25z
X-Received: by 2002:a7b:cb8c:: with SMTP id m12mr6709445wmi.12.1602011746637;
        Tue, 06 Oct 2020 12:15:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKXU9NrcARYm6lGPORmUIGFXUJhFGt+4QuOay9EJUN9YsZ88H1szedsJJm9BEzU8/p4gIK0w==
X-Received: by 2002:a7b:cb8c:: with SMTP id m12mr6709435wmi.12.1602011746456;
        Tue, 06 Oct 2020 12:15:46 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id v17sm5317074wrc.23.2020.10.06.12.15.45
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 12:15:45 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 3/4] xfs: xfs_isilocked() can only check a single lock type
Date:   Tue,  6 Oct 2020 21:15:40 +0200
Message-Id: <20201006191541.115364-4-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006191541.115364-1-preichl@redhat.com>
References: <20201006191541.115364-1-preichl@redhat.com>
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

