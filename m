Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE8DC47095
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 21:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 137C9212CC
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 21:39:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvp9/VP3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgJEVjB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 17:39:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726685AbgJEVjB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 17:39:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601933940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JOggIbMhWLASLR12VW4Ix4Ht18K8U1KrcchbvqrMHVw=;
        b=dvp9/VP3V4nDekLFzi2COLish8YRZr0nrPRHfmqiQ1jFOajo194jYhByiP4TDq2XzuoQTm
        NxPw5jMev0u5YqDtaSQpLKvHFJVWuvBPKCiO1c07Brmp4t7rcCDnkcziAhJOqSCarNvzSn
        X1UspGHcfFJlyLggtnqhsInJ+Hn5pW8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-vm6IQvXTM9yF9iSwgHfqNw-1; Mon, 05 Oct 2020 17:38:58 -0400
X-MC-Unique: vm6IQvXTM9yF9iSwgHfqNw-1
Received: by mail-wr1-f71.google.com with SMTP id r16so4480480wrm.18
        for <linux-xfs@vger.kernel.org>; Mon, 05 Oct 2020 14:38:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JOggIbMhWLASLR12VW4Ix4Ht18K8U1KrcchbvqrMHVw=;
        b=p5DQT71+y9/HznhmWB3zWz9ofB09V3S5LzOrfRzKyL0eMHKImMMZ6njAiUB+y8b51i
         e7MwEa35SRI1uipbzPbrAZ2AEx1MZFnNqCgDSPkfUzbZ1L5VaLQyKIVJBhfX5iruCNIX
         yM4dIWM95mI8Visdo9oJXNG+0xNpaSE9EEXQ2ncSKmqcF5F1Xrtg3YCv/7V1Ccl44OJ6
         CZPAp3P8GrpgRseXghGWXINdHtLEsRMJvSifz4rLcroZp48h7AZRC173TV6oNn2RjtyU
         ykx2dOuanhl/H1b2jRSnSrR31ykzvFg85+d69SqRZjpGxhudl+NW7N2zMM/zW2ikOoA4
         do2Q==
X-Gm-Message-State: AOAM533bLCvRyO8/BSRAKyGMKf6HiaOMRy037tt35sYpP/zFWhqYbjMl
        ydVA+MdCyY9nbliS9+jvJ906+N4ad8qFvoeYUIbp+qs7NTyeGnSA1MlkQ4WxXhb21vkGBYvrgm+
        9au0FcC9J87+GH2CKryNm
X-Received: by 2002:adf:ce01:: with SMTP id p1mr1273711wrn.33.1601933937032;
        Mon, 05 Oct 2020 14:38:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOP4mKnEF+umbSySiU0tLbNMtH7nfF/kOA/V79T85HEcuHQ2lEHpS9HoybfnHFhlWzoTVdzg==
X-Received: by 2002:adf:ce01:: with SMTP id p1mr1273701wrn.33.1601933936878;
        Mon, 05 Oct 2020 14:38:56 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id r5sm1576499wrp.15.2020.10.05.14.38.56
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 14:38:56 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 3/4] xfs: xfs_isilocked() can only check a single lock type
Date:   Mon,  5 Oct 2020 23:38:51 +0200
Message-Id: <20201005213852.233004-4-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005213852.233004-1-preichl@redhat.com>
References: <20201005213852.233004-1-preichl@redhat.com>
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

