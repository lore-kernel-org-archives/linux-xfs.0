Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E70C3B187
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 22:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD7342082F
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 22:10:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CHi8An3Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgBKWKZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 17:10:25 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30421 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgBKWKZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 17:10:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581459023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d7919lYQYI4lwq2Mpm2pPCii3+x0+t8tskinkCVUsr8=;
        b=CHi8An3QXvdFPwOkGnAO9q43HlXEkbckmtod5tyi018WisO2E5/s8j22R38fGxTnrWwsr2
        XupDt8hpKnNLW845BwNBc2jUWqmWMNdsKMflObCNiVUpOiYIfdLwGoPDiFCcm5JFHHb+lm
        Sqg6Ev8RYsn6nzSQHXzvVI3A9aYxS1w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-kTbCxGkdObmOgMTHqfuCQQ-1; Tue, 11 Feb 2020 17:10:22 -0500
X-MC-Unique: kTbCxGkdObmOgMTHqfuCQQ-1
Received: by mail-wm1-f71.google.com with SMTP id d4so96596wmd.7
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2020 14:10:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d7919lYQYI4lwq2Mpm2pPCii3+x0+t8tskinkCVUsr8=;
        b=XNfIdwE1pfc4e13lr2R0J+01pqmgCEsfoHd815cLDrDM96BzLqtEh/tNXoHS8R0hCf
         magCX2Ssqv6xwMTMCLpkNcNaRW/HZpSkufsqsPK4Z4il6QA9vmfIVBTlOj+lCkbKEorv
         jzkDcJfnwbYMR2xVngesfTQ7YZHHN7qifMO7pgUtXmAeyQwStgkkH0bK9kuAkc2U65w1
         xTYZ+MPzfGdM4DaK8pxhRKcCaObeoo+AIyW6Uy8dfsyro6UVk6o2a+2e5jddOMeVGrfK
         S4Btgq6M+SLONOBgnFfyH17PDuwp/AHHBqVn0fve/GlRt+dZWFEQqt79XCIufXIVNapb
         nsKg==
X-Gm-Message-State: APjAAAUtdOGObFS5twXYQ54zVlmBMIflUG58X5oeXlDqapqRCptwp9d7
        xmdp9tYfDZuG0S0sAhs0ZCTx/9AzPHw7cidRVE7Ea4Mha2H9hYoo1PzEeaiKMS77eYEZ1JqbL8r
        +jZUoYMQYnm+Qn/5JOz73
X-Received: by 2002:a1c:e488:: with SMTP id b130mr7713549wmh.108.1581459020830;
        Tue, 11 Feb 2020 14:10:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqwHnX3rD5/WAvIbPYmTX9OVp2Q4ApXUHG8cwExBpK4Wr/evNJZYRel0+9HDorqLbblZZvPYHw==
X-Received: by 2002:a1c:e488:: with SMTP id b130mr7713533wmh.108.1581459020650;
        Tue, 11 Feb 2020 14:10:20 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id p12sm4896786wrx.10.2020.02.11.14.10.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 14:10:20 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 2/4] xfs: Fix WS in xfs_isilocked() calls
Date:   Tue, 11 Feb 2020 23:10:16 +0100
Message-Id: <20200211221018.709125-2-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211221018.709125-1-preichl@redhat.com>
References: <20200211221018.709125-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index cfefa7543b37..be1f06fe1016 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2831,7 +2831,7 @@ static void
 xfs_iunpin(
 	struct xfs_inode	*ip)
 {
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
 
@@ -3695,7 +3695,7 @@ xfs_iflush(
 
 	XFS_STATS_INC(mp, xs_iflush_count);
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
@@ -3827,7 +3827,7 @@ xfs_iflush_int(
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

