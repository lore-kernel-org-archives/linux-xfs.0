Return-Path: <SRS0=Ip4f=4C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C590EC3B1BD
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 18:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9243E22314
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 18:59:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WE3p5pBM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387743AbgBNS7v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 13:59:51 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38786 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387767AbgBNS7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Feb 2020 13:59:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581706789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sBv4Jipw3BawSHTJNVeUQ7nSUhmAaRRQVV2vxLSW19I=;
        b=WE3p5pBMZMa0FACHXAYddKHeucYBuwN02oPiZwNd3pT075uvYrjYzYpD5hlZ29JPvzhE1p
        ysc9rz5AO2exTQb2rkRYPNBs+v8gAP6Sma0WoeF+EZzgirZAKwM+X0VwkMoop/eEiywII3
        FnMHlYFRLVlmQirdJYP+VQviLs2GD9A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-Rl4QYaQsOWq3A73Q3GJhbg-1; Fri, 14 Feb 2020 13:59:46 -0500
X-MC-Unique: Rl4QYaQsOWq3A73Q3GJhbg-1
Received: by mail-wr1-f72.google.com with SMTP id p8so4528924wrw.5
        for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2020 10:59:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sBv4Jipw3BawSHTJNVeUQ7nSUhmAaRRQVV2vxLSW19I=;
        b=iG6eSbtSVORhVPncgqzZ0/8N7Js5egnvNamzlT1zc5LXR3RfXouj3f0ImGK9CTdr4+
         N6N4jsIsnApl5LWrH3NeyURmbg29xapKJUDFjqaF1q/jwE4cN3K1ZN3UCYJY7fZejonz
         BO+fo78rp1czRqREr+CMbyQAkDrP6PXt8+8VlZwquWVeGy9tE0EsszXB+fymQrm75w0i
         SOLoixa3OywMgp+r2bBPsSyzK2dv6OSAJbpzwbNCBqanOe6zceUClW7TGLoSWWJqJTF9
         6M7OnhbgZf6JrovVM5vipEGjG9B63acG+l9vI1NXn0gVJAU0wrJqBH1GFKgIE/B0iAws
         sUqg==
X-Gm-Message-State: APjAAAUroYI38tK8kyK2OJjNnvHuENG836bL3ZXfu4Li1XhI5BzpsJId
        9E9tKOUaK3KMvNkJIauOD9gbLSh1cvj0ejgP4wKuzget2rldcNbLy+NB55IN/xFABKr57M2hEMZ
        GZFL+26nxWLezUeFicIDx
X-Received: by 2002:adf:a39a:: with SMTP id l26mr5320620wrb.211.1581706785412;
        Fri, 14 Feb 2020 10:59:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqxPNRCl0aolDarL96IylxIg00eEubmRqVc4oWGE3UTd35UQI0G9S2X9eoAKRFNxp2iH3tBldw==
X-Received: by 2002:adf:a39a:: with SMTP id l26mr5320607wrb.211.1581706785184;
        Fri, 14 Feb 2020 10:59:45 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id c9sm8287475wmc.47.2020.02.14.10.59.44
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 10:59:44 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Date:   Fri, 14 Feb 2020 19:59:40 +0100
Message-Id: <20200214185942.1147742-2-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200214185942.1147742-1-preichl@redhat.com>
References: <20200214185942.1147742-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make whitespace follow the same pattern in all xfs_isilocked() calls.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
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
index 3d28c4790231..14f46f099470 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2828,7 +2828,7 @@ static void
 xfs_iunpin(
 	struct xfs_inode	*ip)
 {
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
 
@@ -3692,7 +3692,7 @@ xfs_iflush(
 
 	XFS_STATS_INC(mp, xs_iflush_count);
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
@@ -3824,7 +3824,7 @@ xfs_iflush_int(
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
2.24.1

