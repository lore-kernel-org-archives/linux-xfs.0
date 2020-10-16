Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0598C43467
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 02:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DF7420897
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 02:10:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LGC1KzVf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393361AbgJPCKP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:10:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393353AbgJPCKP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 22:10:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602814213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MfskKedjbuMhMr9I37Yepp3TV5To7FBSMj5kfmhNapA=;
        b=LGC1KzVfFWBrWheTyV98epGU2Rdu+1Ovn3peO9YEw41XY312dQsIrjBl7hBrnGH8HXrSff
        ArATjnEC3A2a2Ygb9y500WDKyT/YNeNRxVYw/dR9XymyzNTWXefale9N5gfmz0kfhSh7JE
        1Yhej14LnJTaxz0AS+XZ3XdIt8tzGTg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-Nt1vXe5-MQm0W3gN8fOI_Q-1; Thu, 15 Oct 2020 22:10:11 -0400
X-MC-Unique: Nt1vXe5-MQm0W3gN8fOI_Q-1
Received: by mail-wr1-f70.google.com with SMTP id q15so612838wrw.8
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 19:10:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MfskKedjbuMhMr9I37Yepp3TV5To7FBSMj5kfmhNapA=;
        b=EFSJPK7wIGyslrwpH2zzQqJJpI1OLawQkgxxj1UQH4H3VRrCCOR8in4sIVoooJxGu8
         3TyjXf1NcXaKEzyVtPKdjG+pjJbPmYBhdu23Faf8J3AiHyxId2MnETFhAqNEbvbQi3tm
         JSUmaiqNBq03Ee1yCwkIWaTPFUVkMoisFp3JXhB0b30dxFX8LmcwoIAMCXpyOKBrlAaO
         iRiSG6yGnYlUmJ1d7HoKRps9C2a4R409+bShaUqm8IiQG9CfwQt9ylKJTKFYEvz5Of9u
         gdrrd6Dt6q2ltvQVX9paquM4niIdKELJA+THfyxDV4hbOuffr0SPsbE7d4MmeElfTKUK
         IP/w==
X-Gm-Message-State: AOAM532fwd+y21GkgPAZenjiCobTK4QQsc84ijQGGghe1q6fSEupQHqb
        4Hg+kLXcnDiXTm9SPVjDoI+rmRLfM0vqWpOZdSG4VqTL5uWc/JLg0nidVbLlxqYRxoZwglrvLTe
        i0PGN1sw6ttIU44t5iko5
X-Received: by 2002:adf:94e6:: with SMTP id 93mr1057922wrr.190.1602814210144;
        Thu, 15 Oct 2020 19:10:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAbmCxUOPWMjJRYyloMdSWqCKAN13MDzhkTdoAS0MzNWWhLTWPOn/kxbbV8O88NYpR5EobaA==
X-Received: by 2002:adf:94e6:: with SMTP id 93mr1057911wrr.190.1602814209999;
        Thu, 15 Oct 2020 19:10:09 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id v3sm1420685wre.17.2020.10.15.19.10.09
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 19:10:09 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 3/4] xfs: xfs_isilocked() can only check a single lock type
Date:   Fri, 16 Oct 2020 04:10:04 +0200
Message-Id: <20201016021005.548850-4-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016021005.548850-1-preichl@redhat.com>
References: <20201016021005.548850-1-preichl@redhat.com>
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

