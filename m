Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1AFC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 10:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 442792068E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 10:06:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHbdrLRN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgHYKGr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 06:06:47 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31369 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726000AbgHYKGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 06:06:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598350005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=cN3ogaTWLiUQM5qi6rq+x6SyLW5kXQnWEzTmvZKQ9EA=;
        b=NHbdrLRNAr+4s+VVCWwl97TvhgvCd18PDVRFGLaOjGpsyhcoQBvsgT/uE44NwTJDyWX5Cv
        0cXhbXkq/V55gfxgkuyKULr1dxwSoN5KRPDczfzgvVTfbXcifSripSEprZ6VG+znHhm+/p
        gUHwgFHbfydJsdXg0pIXQbnZE68e284=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-y5Y9AGjcMA2B-MUv06nwqQ-1; Tue, 25 Aug 2020 06:06:43 -0400
X-MC-Unique: y5Y9AGjcMA2B-MUv06nwqQ-1
Received: by mail-pg1-f197.google.com with SMTP id k32so7482238pgm.15
        for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2020 03:06:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cN3ogaTWLiUQM5qi6rq+x6SyLW5kXQnWEzTmvZKQ9EA=;
        b=lGK0XIsXygK/TficXK3FyL9v0ppJuOxCzGp/DHV2Fb5GgR51L7u34fyewCwJ6oaxUH
         ii46fcdGXP4ViDbUhUm9u2QYYK6uJWOvC4jYrSoHF6AEupWRZ82dYocnJF22CnIbT21R
         JSRLSh9qLa7c4dBjFD0kel1tReqffe6C6583pzMm3pTKfQrQWf/SHDvdcB6/w7Hhs8Qs
         gIbyo4R4mfotHsIzNs+b0ad7eZ+JQerymnVgYssNWauQdE8l/Hy9y5SVIDjBinSA0X5g
         XTpouH7O7jweleqDJ6TcL9vPXOxUmSCwNDQDCVIihOizKql5kkNrUbhmMaolTKmGlmUe
         yf4Q==
X-Gm-Message-State: AOAM531+NQkXoopQXz4H3blkDqSPH+JJfpDp2uA+oM825imyPuZLwMIs
        9nVsPeDsfJV2MgWgfV/dvRxLa9x8dw1VAFgCgQuaca1y5r5VLmn/kHHpmBmH7iIWKj+mjIX3l4q
        n3b7CB306Tp44vCTneX8B
X-Received: by 2002:a62:a203:: with SMTP id m3mr7020985pff.86.1598350002262;
        Tue, 25 Aug 2020 03:06:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcK2DQr+fqEP4sv0NVhQRkKqXhzEppbWXjWEuzWrGvIkEZTHz5Snx/8E7Fq7kPd7AUh9uFvQ==
X-Received: by 2002:a62:a203:: with SMTP id m3mr7020971pff.86.1598350001960;
        Tue, 25 Aug 2020 03:06:41 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s125sm14499821pfb.125.2020.08.25.03.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 03:06:41 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH] xfs: use log_incompat feature instead of speculate matching
Date:   Tue, 25 Aug 2020 18:06:01 +0800
Message-Id: <20200825100601.2529-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200824154120.GA23868@xiangao.remote.csb>
References: <20200824154120.GA23868@xiangao.remote.csb>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a log_incompat (v5) or sb_features2 (v4) feature
of a single long iunlinked list just to be safe. Hence,
older kernels will refuse to replay log for v5 images
or mount entirely for v4 images.

If the current mount is in RO state, it will defer
to the next RW (re)mount to add such flag instead.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
Different combinations have been tested (v4/v5 and before/after patch).

Based on the top of
`[PATCH 13/13] xfs: reorder iunlink remove operation in xfs_ifree`
https://lore.kernel.org/r/20200812092556.2567285-14-david@fromorbit.com

Either folding or rearranging this patch would be okay.

Maybe xfsprogs could be also patched as well to change the default
feature setting, but let me send out this first...

(It's possible that I'm still missing something...
 Kindly point out any time.)

 fs/xfs/libxfs/xfs_format.h | 29 +++++++++++++++++++++++++++--
 fs/xfs/xfs_inode.c         |  2 +-
 fs/xfs/xfs_mount.c         |  6 ++++++
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 31b7ece985bb..a859fe601f6e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -79,12 +79,14 @@ struct xfs_ifork;
 #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
 #define XFS_SB_VERSION2_CRCBIT		0x00000100	/* metadata CRCs */
 #define XFS_SB_VERSION2_FTYPE		0x00000200	/* inode type in dir */
+#define XFS_SB_VERSION2_NEW_IUNLINK	0x00000400	/* (v4) new iunlink */
 
 #define	XFS_SB_VERSION2_OKBITS		\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
 	 XFS_SB_VERSION2_ATTR2BIT	| \
 	 XFS_SB_VERSION2_PROJID32BIT	| \
-	 XFS_SB_VERSION2_FTYPE)
+	 XFS_SB_VERSION2_FTYPE		| \
+	 XFS_SB_VERSION2_NEW_IUNLINK)
 
 /* Maximum size of the xfs filesystem label, no terminating NULL */
 #define XFSLABEL_MAX			12
@@ -479,7 +481,9 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_LOG_NEW_IUNLINK	(1 << 0)
+#define XFS_SB_FEAT_INCOMPAT_LOG_ALL	\
+		(XFS_SB_FEAT_INCOMPAT_LOG_NEW_IUNLINK)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(
@@ -563,6 +567,27 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
 }
 
+static inline bool xfs_sb_has_new_iunlink(struct xfs_sb *sbp)
+{
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
+		return sbp->sb_features_log_incompat &
+			XFS_SB_FEAT_INCOMPAT_LOG_NEW_IUNLINK;
+
+	return xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_NEW_IUNLINK);
+}
+
+static inline void xfs_sb_add_new_iunlink(struct xfs_sb *sbp)
+{
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
+		sbp->sb_features_log_incompat |=
+			XFS_SB_FEAT_INCOMPAT_LOG_NEW_IUNLINK;
+		return;
+	}
+	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+	sbp->sb_features2 |= XFS_SB_VERSION2_NEW_IUNLINK;
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7ee778bcde06..1656ed7dcadf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1952,7 +1952,7 @@ xfs_iunlink_update_bucket(
 	if (!log || log->l_flags & XLOG_RECOVERY_NEEDED) {
 		ASSERT(cur_agino != NULLAGINO);
 
-		if (be32_to_cpu(agi->agi_unlinked[0]) != cur_agino)
+		if (!xfs_sb_has_new_iunlink(&mp->m_sb))
 			bucket_index = cur_agino % XFS_AGI_UNLINKED_BUCKETS;
 	}
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f28c969af272..a3b2e3c3d32f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -836,6 +836,12 @@ xfs_mountfs(
 		goto out_fail_wait;
 	}
 
+	if (!xfs_sb_has_new_iunlink(sbp)) {
+		xfs_warn(mp, "will switch to long iunlinked list on r/w");
+		xfs_sb_add_new_iunlink(sbp);
+		mp->m_update_sb = true;
+	}
+
 	/* Make sure the summary counts are ok. */
 	error = xfs_check_summary_counts(mp);
 	if (error)
-- 
2.18.1

