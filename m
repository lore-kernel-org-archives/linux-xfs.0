Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54755C3524D
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B9EF21582
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IXJzKh/e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgBCR7G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 12:59:06 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36614 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728474AbgBCR7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 12:59:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580752745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CM4C13QnWi5L1OqqBneEKswNuLP9I1IEei57QnAzrDc=;
        b=IXJzKh/eTS0AKMxEBYA2DWFXSEtvW66YsjCLpDRNcmJJlmnVKHQXiEozlu8eKAjU4FhRxE
        dpnRN4R4q0SYFkWatLtidz/2d/R6YNMigTpfNb8Wvk8owl4UGktTnR4jZxjpddOmWYERNG
        7YPo+eYFJvcplDDOhU6Bs1ilL3M2zCo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-OJb8cD21Plug90hT3NIyug-1; Mon, 03 Feb 2020 12:59:04 -0500
X-MC-Unique: OJb8cD21Plug90hT3NIyug-1
Received: by mail-wr1-f70.google.com with SMTP id 50so7819597wrc.2
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2020 09:59:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CM4C13QnWi5L1OqqBneEKswNuLP9I1IEei57QnAzrDc=;
        b=CWtW2obC0KPQLBbBpHMbncxBMjGJTO8+EemBgbO2SrLYPYb2iUjCdJKPdE72s/RaNE
         JxE0rw8C2v2ssOO0iLNYLvjX8Sm1KsIzN0AFZ9PgnFzFHM/GmYIEpFcFyhy7NofdzLPF
         RFw45w5Nk283Cu+UPIRxDva/FFkEqevdtLDZRT/uT0mKXQdznLvHMgOTm7RJV0svr7Q1
         sdPnMz8yUAFvNH6pbYl8ApfBQlpqncBPoWkq2dABp6q++gwYqPu9ZleLoBz5ZUGib72D
         B5AlSaV9+DYkA+qmKq5kLJquVxH00XhVJnFW+YGae6CxWAi7VcfIvpJ5O3tshH6wpymq
         sfww==
X-Gm-Message-State: APjAAAUDKXHuyuHZLOLhbzbuim0JPdZJkOXPx9XgYznYYv0Y3zaJkSXj
        S+c9iVXm1gzKuxr+F2ph9NXVaStS1a9iEr3bhxXjXXpRV/bM51fG9SyiOENRLrLTAbJ3AFdI+ra
        LQx0crFKO7ds6HsXyKVP3
X-Received: by 2002:a5d:678f:: with SMTP id v15mr11593312wru.27.1580752742901;
        Mon, 03 Feb 2020 09:59:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqw1R6H/IQN85qamfpegBxe27QpTXPXJEvxk3gr+tgNOshX901sLJ5jGCfJjvs5l3PmCvHNqLA==
X-Received: by 2002:a5d:678f:: with SMTP id v15mr11593299wru.27.1580752742751;
        Mon, 03 Feb 2020 09:59:02 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a132sm212274wme.3.2020.02.03.09.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 09:59:02 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v2 4/7] xfs: Update checking for iolock
Date:   Mon,  3 Feb 2020 18:58:47 +0100
Message-Id: <20200203175850.171689-5-preichl@redhat.com>
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
 fs/xfs/libxfs/xfs_bmap.c | 4 ++--
 fs/xfs/xfs_bmap_util.c   | 4 ++--
 fs/xfs/xfs_file.c        | 3 ++-
 fs/xfs/xfs_inode.c       | 2 +-
 fs/xfs/xfs_iops.c        | 2 +-
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 86a9fe2a7629..c3638552b3c0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5699,7 +5699,7 @@ xfs_bmse_merge(
 
 	blockcount = left->br_blockcount + got->br_blockcount;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(xfs_bmse_can_merge(left, got, shift));
 
@@ -5904,7 +5904,7 @@ xfs_bmap_can_insert_extents(
 	int			is_empty;
 	int			error = 0;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL));
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e62fb5216341..ae0bccb2288f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1065,7 +1065,7 @@ xfs_collapse_file_space(
 	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 	bool			done = false;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 
 	trace_xfs_collapse_file_space(ip);
@@ -1133,7 +1133,7 @@ xfs_insert_file_space(
 	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
 	bool			done = false;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 
 	trace_xfs_insert_file_space(ip);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b8a4a3f29b36..9b3958ca73d9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -770,7 +770,8 @@ xfs_break_layouts(
 	bool			retry;
 	int			error;
 
-	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
+	ASSERT(xfs_is_iolocked(XFS_I(inode),
+		XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
 
 	do {
 		retry = false;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d7cb2886ca81..328a3b4ffbd2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1576,7 +1576,7 @@ xfs_itruncate_extents_flags(
 
 	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
-	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	       xfs_is_iolocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(new_size <= XFS_ISIZE(ip));
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(ip->i_itemp != NULL);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index eba2ec2a59f1..aad255521514 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -865,7 +865,7 @@ xfs_setattr_size(
 	uint			lock_flags = 0;
 	bool			did_zeroing = false;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 	ASSERT(S_ISREG(inode->i_mode));
 	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-- 
2.24.1

