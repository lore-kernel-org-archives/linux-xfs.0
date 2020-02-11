Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC19C352A3
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 22:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBC6F20708
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 22:10:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JbhLRPJW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgBKWK0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 17:10:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39658 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727054AbgBKWK0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 17:10:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581459025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z+lCgrRtAhH3fiFQK/QvncAiSimhafm7U8lRQyzKh2Y=;
        b=JbhLRPJWN2gEz7YCMqSQgo2axwKwa3eoCOXH43AZmis43NbPszV0GDYhd740BTjtTmefy+
        vLU8xIS8D0m/yXonQVgdpsHw/+X14EDtLa7iOmbWpmNmrnVQCF4suBIA87R7dTLsF7/dHB
        VjCMM3AYatPdd3qMuU++WqQUokkV0gI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-SoKGZHv7Mm2wYLhTmr1-yw-1; Tue, 11 Feb 2020 17:10:23 -0500
X-MC-Unique: SoKGZHv7Mm2wYLhTmr1-yw-1
Received: by mail-wm1-f71.google.com with SMTP id f66so91843wmf.9
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2020 14:10:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z+lCgrRtAhH3fiFQK/QvncAiSimhafm7U8lRQyzKh2Y=;
        b=ekwOEnY0U84OQeQVRMpNM/F/aJkywbK7XqqYmA9g4fXErqaeIIFSRa3BxYCV3yDUss
         XTLWfT5nY0qmeBpCLDMwkK7GcB1zw4qcfUI/gvNKCrzQjTmlVAbqD+OWcgZ+G9pCyB5V
         WGlUdRxFQdYQgW4pzcunq7YJ2HvK0HPG3F4fmUpZznXieVyQKzvq/flP2cBn4aoTcgTM
         yJFl8IbhP/qr64Zq3N8SeOfqp/MWdChnP3mIUB0q2qWfc2bzyYe/u8dOgSbRCOdt1ru4
         Qw1hbhdeFNO6+KXOrKcYyXivoSS7GkizXUElAhYat9jstcYcL8hPGIwJh/mYVDl1okUg
         v1Vg==
X-Gm-Message-State: APjAAAXX9lErIyLYNMCCBni92vJXRVWFYfgIQq7iRr16lYVujt/Atttr
        JVL4MatFr65wHldupwE0e6Llo17SZIeKFzH5Qwnuk54zSt12Bi9x9/m37RixkfeIfMJz8PpSrIR
        n16YjQ9M8OUqM5Z0pA10P
X-Received: by 2002:a1c:451:: with SMTP id 78mr7691207wme.125.1581459021713;
        Tue, 11 Feb 2020 14:10:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqwYbizT5rL7L5u2gZlyaltMJhnmrDvma5ecOo0LeC7XPDd/hzLOX4oIulNgSev7rABpVhZnzw==
X-Received: by 2002:a1c:451:: with SMTP id 78mr7691195wme.125.1581459021444;
        Tue, 11 Feb 2020 14:10:21 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id p12sm4896786wrx.10.2020.02.11.14.10.20
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 14:10:20 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 3/4] xfs: Fix bug when checking diff. locks
Date:   Tue, 11 Feb 2020 23:10:17 +0100
Message-Id: <20200211221018.709125-3-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211221018.709125-1-preichl@redhat.com>
References: <20200211221018.709125-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In its current form, xfs_isilocked() is only able to test one lock type at a
time - ilock, iolock, or mmap lock, but combinations are not properly handled.
The intent here is to check that both XFS_IOLOCK_EXCL and XFS_ILOCK_EXCL are
held, so test them each separately.

The commit ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents") ORed the flags
together which was an error, so this patch reverts that part of the change and
check the locks independently.

Fixes: ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents")

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
Changelog from V3:
Commit message extened.


 fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bc2be29193aa..c9dc94f114ed 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5829,7 +5829,8 @@ xfs_bmap_collapse_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
@@ -5946,7 +5947,8 @@ xfs_bmap_insert_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
-- 
2.24.1

