Return-Path: <SRS0=Ip4f=4C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63637C3B1BE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 18:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 315E722314
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 18:59:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zk4en6xE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387860AbgBNS7u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 13:59:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38679 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387743AbgBNS7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Feb 2020 13:59:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581706789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=guJnUNqhtBfd5Mk56aEg8uRvde4cx3MYR8GAqLgVb2k=;
        b=Zk4en6xExD9yZgGvamtjfnNty6ldFjTqWYcgvYi/lRYP9FgTExaYZrq55AuqlwHMIvKUpQ
        q10GE8aFo9PgxIiFYFmgR8acvV3AZcXUsdZVYHZGFXyNkpbb6XspZ74IYfzp1aHVDtypAO
        oqtv9vB0oLIzDQfcfO6/uH9tTOaJTew=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-6lw8NtzjMhasmO1_RbSO2A-1; Fri, 14 Feb 2020 13:59:47 -0500
X-MC-Unique: 6lw8NtzjMhasmO1_RbSO2A-1
Received: by mail-wr1-f69.google.com with SMTP id t3so4490943wrm.23
        for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2020 10:59:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=guJnUNqhtBfd5Mk56aEg8uRvde4cx3MYR8GAqLgVb2k=;
        b=M60OUoZl3qONTphvZLY9DxJqH3OW9ggPfIPj70NgYOSJwVAbSX+HfwHRHDF/aXWA/z
         rSnnLe7L81eILSW2Epr8DZmruBGXWno2I5Cystyr1Z7nV4cdsXdYALRBrL9vCIMFozp2
         xIGpFtQwdtdQCKoTYbFSWYYy+ZTp6tZ1uqCdhowMBFa/io4bHjOfRbJihDTHskN5m9BE
         SQy1cNmv8ojfdQ3RDcNCzycyyZzyTRgJRCc1VVw5n/Bu9Zy1L1wSqoEKTFDMxo+DcCl6
         BnYWzE3J6O5OMCMY50avVmQ3gVkl1pJZTk7rp5OlFmXqmwg/pxRQiJnmthzAsY9sRIFO
         NwvQ==
X-Gm-Message-State: APjAAAU0UU24/CZlbg2oqSadvlx9/bQLcMqxtHgn2MaFSe5qXguqY8tj
        ZSx1t9M8x272fbSYiEkQ8TqrwnaBanMtsWpg9HXfckuEGl+7932yVFzP7/Ls/W1mQPN4Lt252Rf
        tLBLHEtDd6X9d/52LTXPN
X-Received: by 2002:a5d:6151:: with SMTP id y17mr5311241wrt.110.1581706786152;
        Fri, 14 Feb 2020 10:59:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqyxwRdTdFeFYAvP+ndNjEpdgQDrQcVjyZ5e9mtj1fwO60x4SECl53m7L3woe9iBAgJ/95ZPkA==
X-Received: by 2002:a5d:6151:: with SMTP id y17mr5311233wrt.110.1581706785975;
        Fri, 14 Feb 2020 10:59:45 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id c9sm8287475wmc.47.2020.02.14.10.59.45
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 10:59:45 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 3/4] xfs: xfs_isilocked() can only check a single lock type
Date:   Fri, 14 Feb 2020 19:59:41 +0100
Message-Id: <20200214185942.1147742-3-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200214185942.1147742-1-preichl@redhat.com>
References: <20200214185942.1147742-1-preichl@redhat.com>
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
Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
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

