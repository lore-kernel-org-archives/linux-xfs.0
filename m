Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90F0C4332B
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 21:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE08C20658
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 21:03:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c4OjrPda"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgCTVDk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 17:03:40 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:46626 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727192AbgCTVDk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 17:03:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584738218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dW3EbRkshj9JpOctSp2z4KTvGyhVHIf5NPCI25idIlI=;
        b=c4OjrPdarxyH2JXrpxY76vYQS/tRvf6ZR1YD0faSCfRTlSQPPQqCaZpiByyWfw+aCy2YOJ
        3/2n38D2aPjhDUom3dMou5GnZENkBLAJQRw8lkFqU7YGOO8L/09c6qPUF7xURW0EyFqVCx
        lEO0xz9Ux2Kmdax4vNZDatSKg+ZjOUo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-N33R0scEMJmQo0Zyk4Fd3w-1; Fri, 20 Mar 2020 17:03:37 -0400
X-MC-Unique: N33R0scEMJmQo0Zyk4Fd3w-1
Received: by mail-wr1-f71.google.com with SMTP id u18so3193805wrn.11
        for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2020 14:03:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dW3EbRkshj9JpOctSp2z4KTvGyhVHIf5NPCI25idIlI=;
        b=XyCv2P9XNiupDzHxgqAe02z5BDiiUDpJw4Mh5+bcI825Uxq3EAaHPB/fNKT97arj/f
         v2VYXkix+RFF51RZPWC2miEs7cRsHvnW1NRfaTTbsVCGvT88n+G1+5Tc4B+B7j8cU069
         z1DOCytOs/Ffn9qbcezAKIVHtG7fBzZ/7gQOWk6OTv5Qz/3RwaU06gxLtc4yII8Ttu/1
         hBKvz8jJtlZDvI0d2bmPmrOR6wTkE90fjnummkEFLdd3VBM/P2zKRFI62Va20BxOer8X
         yXl8Nxv3bK75JMjdRZffvp6kfKspD/CMoUJuOLV2yfkajIqeIKJSpnz4KOv/zD+74fmP
         4CQQ==
X-Gm-Message-State: ANhLgQ39LuBg2UCvDLjDh4/G2n1mpEDvnZ9SUYeSjSs5BqhgAKw9dImJ
        WhXjIwXc9LSfot5HfWVJWZ6ybSjLJ2HdOx9D13/ccP3CL/bWiAxMhHZhaNvz+318YIj3AW9XC0T
        T19kYf3XW3YpEU1FJc438
X-Received: by 2002:adf:f688:: with SMTP id v8mr13363017wrp.344.1584738215572;
        Fri, 20 Mar 2020 14:03:35 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsd4UVj8sgv3MbuWmHHfyPwK3arKNVp39EQfG9Dj7aqv7LA5/qk3wEUYN1lhUp1FYaJpzBO/Q==
X-Received: by 2002:adf:f688:: with SMTP id v8mr13363001wrp.344.1584738215372;
        Fri, 20 Mar 2020 14:03:35 -0700 (PDT)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id w7sm10479668wrr.60.2020.03.20.14.03.34
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 14:03:34 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Date:   Fri, 20 Mar 2020 22:03:15 +0100
Message-Id: <20200320210317.1071747-3-preichl@redhat.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200320210317.1071747-1-preichl@redhat.com>
References: <20200320210317.1071747-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make whitespace follow the same pattern in all xfs_isilocked() calls.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 fs/xfs/xfs_file.c        | 3 ++-
 fs/xfs/xfs_inode.c       | 6 +++---
 fs/xfs/xfs_qm.c          | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9a6d7a84689a..bc2be29193aa 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3906,7 +3906,7 @@ xfs_bmapi_read(
 	ASSERT(*nmap >= 1);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK|XFS_BMAPI_ENTIRE|
 			   XFS_BMAPI_COWFORK)));
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b8a4a3f29b36..6b65572bdb21 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -770,7 +770,8 @@ xfs_break_layouts(
 	bool			retry;
 	int			error;
 
-	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(XFS_I(inode),
+			XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
 
 	do {
 		retry = false;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index db356f815adc..dec66059b045 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2836,7 +2836,7 @@ static void
 xfs_iunpin(
 	struct xfs_inode	*ip)
 {
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
 
@@ -3700,7 +3700,7 @@ xfs_iflush(
 
 	XFS_STATS_INC(mp, xs_iflush_count);
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
@@ -3832,7 +3832,7 @@ xfs_iflush_int(
 	struct xfs_dinode	*dip;
 	struct xfs_mount	*mp = ip->i_mount;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 0b0909657bad..d2896925b5ca 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1802,7 +1802,7 @@ xfs_qm_vop_chown_reserve(
 	int			error;
 
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	delblks = ip->i_delayed_blks;
-- 
2.25.1

