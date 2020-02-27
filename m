Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCC1C35E1D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A361B2469C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:36:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WiNOJhmq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgB0Ugq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:36:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39790 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729409AbgB0Ugp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 15:36:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582835804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6yQTu420JW+laaVKh8Pijf952p5iuFmH4hmdQZVSDyg=;
        b=WiNOJhmqptAXOiaVnJgx5Wcf7FMyZG0Vm2Qyg99P06d6ATHotkZckKWTKFetcrdmG7Liiw
        Y+olbZ2/kbqaAzw4O5GNnmNS1iM8L0EfUqxzbgIm5Ew5FB9tI163yb3r9Pe2U4NzjStY8x
        Coq9xPizpqVptsDMqvn882QdvV14PaE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-Qmtk1CfPOqaoPNQy75FVpg-1; Thu, 27 Feb 2020 15:36:42 -0500
X-MC-Unique: Qmtk1CfPOqaoPNQy75FVpg-1
Received: by mail-wr1-f72.google.com with SMTP id m13so339738wrw.3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 12:36:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6yQTu420JW+laaVKh8Pijf952p5iuFmH4hmdQZVSDyg=;
        b=thwwjhL68w1zfEVS73fa/NqnhtNPo/lOJ0mHRmipWPoKX1LoO2WHZ0jGzS2YhiKGSq
         g4XVWH6P6/R4UneHPH/znwq9C2GM0ChVFRReO6rAwIVUxzNnSqErRKJDANSVYOvxvyLz
         ZvArIyooP/pDB0CLSaCCsPE68Yay/37A9SLuDJBvOjLR5d9qshrtzIC4a6/dSBrPnIxt
         jv2/7OdCYHUvw9ab1beSpBus5TkptYA9dfVlC9amPisOBsYQyy7lNE+qsZsungJZzcmx
         3oVpIvY3NT41LNKu6ySEoC/de4+96Cm3IL7tg3dHZcM43O/9HRwISQwjFTXruXi36Wib
         NMkg==
X-Gm-Message-State: APjAAAWJ1u4V9U/QXWunUANkoQ+zJe/NBNK0p4F2traBp/ZSXvEenTvT
        xiTEly1ff1a9RNHUmkr93aKA8tns3T0ajgC5LSDzv/R1tRWIA+5LntvB+k8xaWJZIIcWMCQg0SI
        WXsVzQtyU+iQXIfN0tbfV
X-Received: by 2002:a1c:25c5:: with SMTP id l188mr560105wml.105.1582835801151;
        Thu, 27 Feb 2020 12:36:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqynvO3gdMuJ9B9PrM5QJsEU+xveZByZW1kE7a4KaBuFiFd0gn3hxOVqKbhB/kwvZDIittQakg==
X-Received: by 2002:a1c:25c5:: with SMTP id l188mr560092wml.105.1582835800894;
        Thu, 27 Feb 2020 12:36:40 -0800 (PST)
Received: from localhost.localdomain (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id e11sm9217157wrm.80.2020.02.27.12.36.40
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 12:36:40 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 3/4] xfs: xfs_isilocked() can only check a single lock type
Date:   Thu, 27 Feb 2020 21:36:35 +0100
Message-Id: <20200227203636.317790-4-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227203636.317790-1-preichl@redhat.com>
References: <20200227203636.317790-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
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

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
Changes from V5: None

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

