Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D31C00A89
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 02:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ABF422265
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 02:34:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dKHeDLb+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgKCCeH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 21:34:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbgKCCeH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 21:34:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604370845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=VR9Xpzs08VUXpHhn7xrbRvNeU00LlZuXhKUWZ2QMT60=;
        b=dKHeDLb+bJpDJaNza4nPdGePRCTLaiz3SGRcbygTeHUQbj6L7/J+XUMZVDOfJJ0bVSobJg
        BhOW4iPHreqFHUKL0AsZIlqcImIlLV6ycZKTQZiSBkwtLiIiTx9JWcPajzZk9MBCgUX8qP
        KNABLci16dqwQGZ1QDFz42INfIMVGoo=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-TSpCiGPCNIy3dGXn8PeGzg-1; Mon, 02 Nov 2020 21:34:04 -0500
X-MC-Unique: TSpCiGPCNIy3dGXn8PeGzg-1
Received: by mail-pg1-f199.google.com with SMTP id f2so10548094pgf.5
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 18:34:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VR9Xpzs08VUXpHhn7xrbRvNeU00LlZuXhKUWZ2QMT60=;
        b=lmWnT3Ih4dQkDX74KwdI5cpQC7lkTHrLADtjRvwvbHH9nmkPIzN1TlxF/ABWUtH7wA
         6hQdAg0vuSMYz+vK7ATwXMHN0I+o/oWcJrUE5YNjJoWYmb7Bre7lqkoCxgI7LbaiIU9x
         ouxIT++/yayJioy5SVxp+PH06BYYXqhE7cwedaW6m/QnnvtXo/k5hqZfpblQp4pBmiQB
         p3fysS0nUnSGQ6qJmWXhYcLPYaoZOc/f9MJ+7mkbzYy/jUZz7HANlIdJE+yfN6ajSeTw
         RbKLVdwXAMVeDmeA/u+/Lfkj1b3hufOS4yRRtyDM/sPNDFVAZyp/fEpXyXsPC11u084I
         2etQ==
X-Gm-Message-State: AOAM531BliJGwBTSpCRgMl4U3QKWhn7egpc8xhjftiVRtStO4BIaxIv3
        uw7mBdUMoVRcLQOQBIndjmO7mSDjNnOt0caHefP401xm3hrUdauekanSGEnG1MpmJzAVr9Et/bM
        OoRLi841Svdh28t3BgE0x
X-Received: by 2002:aa7:96f9:0:b029:18a:aaea:20f6 with SMTP id i25-20020aa796f90000b029018aaaea20f6mr13951451pfq.41.1604370842955;
        Mon, 02 Nov 2020 18:34:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxOcOq1OzI08AuLce5e4toE7KaZcxTQHg3OJjQ/BMFiW7lG+fnVMShubfnRVeKEKHNqu+fwyQ==
X-Received: by 2002:aa7:96f9:0:b029:18a:aaea:20f6 with SMTP id i25-20020aa796f90000b029018aaaea20f6mr13951432pfq.41.1604370842526;
        Mon, 02 Nov 2020 18:34:02 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u11sm14251253pfk.164.2020.11.02.18.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 18:34:02 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH v2 1/2] xfsdump: Revert "xfsdump: handle bind mount targets"
Date:   Tue,  3 Nov 2020 10:33:14 +0800
Message-Id: <20201103023315.786103-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Bind mount mntpnts will be forbided in the next commits
instead since it's not the real rootdir.

This cannot be reverted cleanly due to several cleanup
patches, but the logic is reverted equivalently.

This reverts commit 25195ebf107dc81b1b7cea1476764950e1d6cc9d.

Fixes: 25195ebf107d ("xfsdump: handle bind mount targets")
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 dump/content.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/dump/content.c b/dump/content.c
index 30232d4..c11d9b4 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -1382,17 +1382,10 @@ baseuuidbypass:
 	}
 
 	/* figure out the ino for the root directory of the fs
-	 * and get its struct xfs_bstat for inomap_build().  This could
-	 * be a bind mount; don't ask for the mount point inode,
-	 * find the actual lowest inode number in the filesystem.
+	 * and get its xfs_bstat_t for inomap_build()
 	 */
 	{
 		stat64_t rootstat;
-		xfs_ino_t lastino = 0;
-		int ocount = 0;
-		struct xfs_fsop_bulkreq bulkreq;
-
-		/* Get the inode of the mount point */
 		rval = fstat64(sc_fsfd, &rootstat);
 		if (rval) {
 			mlog(MLOG_NORMAL, _(
@@ -1404,21 +1397,11 @@ baseuuidbypass:
 			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
 		assert(sc_rootxfsstatp);
 
-		/* Get the first valid (i.e. root) inode in this fs */
-		bulkreq.lastip = (__u64 *)&lastino;
-		bulkreq.icount = 1;
-		bulkreq.ubuffer = sc_rootxfsstatp;
-		bulkreq.ocount = &ocount;
-		if (ioctl(sc_fsfd, XFS_IOC_FSBULKSTAT, &bulkreq) < 0) {
+		if (bigstat_one(sc_fsfd, rootstat.st_ino, sc_rootxfsstatp) < 0) {
 			mlog(MLOG_ERROR,
 			      _("failed to get bulkstat information for root inode\n"));
 			return BOOL_FALSE;
 		}
-
-		if (sc_rootxfsstatp->bs_ino != rootstat.st_ino)
-			mlog (MLOG_NORMAL | MLOG_NOTE,
-			       _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
-			         sc_rootxfsstatp->bs_ino, rootstat.st_ino);
 	}
 
 	/* alloc a file system handle, to be used with the jdm_open()
-- 
2.18.1

