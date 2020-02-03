Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D337C3F68F
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6802021582
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M3LPLwhU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgBCR7Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 12:59:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37357 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728278AbgBCR7Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 12:59:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580752755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vW1g6s+HBcI0J8HGyOEdASKggJmBfc4o86wIy8hvv6s=;
        b=M3LPLwhUwFmJj5ZxUucKZvfBtvNZme+zEPd5UJUXXHPPyPJnDhOz6aDGHmpmmEJANYBsbB
        5eGUBsI/OBE3qhzhfqHQuLsyq3Zd+JPm0D8i50mLDyt6Xq/8Ti2T+lnbxgWdBmw6tb1Pzk
        wpxpCWWSsb6VparNafD2d7HBuX7uYpA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-X-e_HdVnOAW801JzIX1olw-1; Mon, 03 Feb 2020 12:59:13 -0500
X-MC-Unique: X-e_HdVnOAW801JzIX1olw-1
Received: by mail-wm1-f70.google.com with SMTP id m4so71656wmi.5
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2020 09:59:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vW1g6s+HBcI0J8HGyOEdASKggJmBfc4o86wIy8hvv6s=;
        b=ZXsQJxOy80GkPtzN3F+Ibg6lhD8ScaSMvXiW05DvtI5f7PJhOc0Y9xK1oiXHdZ7Dgc
         yaEWikco/OKx3qIZRTK88hxasJbNYMRdGppeBApBm1ZqpE5wKj0uYsLAsaNTbs+lNIVj
         NooJlHfaaB28BrIgQfG1RrB7dhP+vAbVRJbsv9oaX9WPV8bOwRukCwQD1+akCZk8xyhI
         V/ky0MUeUC6v1OE5C3AGFuRBgYizj8PoYhDuoWMlxEsqGV4qVv1BBQcvpQBh76kx3dA6
         1H301ywXYN4O7EdVVY18wL87Tp/d/GDiwfYDd4zurt17S9uLgB/HMfAkV7XIqPrg3Bm+
         4lxA==
X-Gm-Message-State: APjAAAWv3m8eIIYgewN2lMdFG2sz7lVr8xRq+yaMeC87cA/smiaevncD
        EJHtAWxWGDEMdwJhv9B9u61kUy20ALWk0cjpx89Y6yJvc8J4il16PVG53EovsNiTZvCnOBNm7fc
        U/lryr83fLsuWxYbCNQ5O
X-Received: by 2002:adf:cd03:: with SMTP id w3mr17446972wrm.191.1580752752037;
        Mon, 03 Feb 2020 09:59:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqwsRwpqT+D64C9O7XOhKblckDEGo1ljqhutKTbpj38iQPTgW7FvqpjKRRgBfR6bF3+6q3dsCg==
X-Received: by 2002:adf:cd03:: with SMTP id w3mr17446964wrm.191.1580752751931;
        Mon, 03 Feb 2020 09:59:11 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a132sm212274wme.3.2020.02.03.09.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 09:59:11 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v2 6/7] xfs: update excl. lock check for IOLOCK and ILOCK
Date:   Mon,  3 Feb 2020 18:58:49 +0100
Message-Id: <20200203175850.171689-7-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203175850.171689-1-preichl@redhat.com>
References: <20200203175850.171689-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c3638552b3c0..2d371f87e890 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5829,7 +5829,8 @@ xfs_bmap_collapse_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL) ||
+		xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
@@ -5946,7 +5947,8 @@ xfs_bmap_insert_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL) ||
+		xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
-- 
2.24.1

