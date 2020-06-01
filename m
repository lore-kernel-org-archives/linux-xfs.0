Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA724C433DF
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 14:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB8242074B
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 14:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i5yIXxPZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgFAOCH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 10:02:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51923 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726017AbgFAOCH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 10:02:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591020125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HrDiueD5iHRRaPnqPFl10H4VUPjjKmtK4KopbOsG0aM=;
        b=i5yIXxPZjiA9HZkne3JuH+C7JxAHEoihR2uP78W044UN2hRTNLyRUCvM+sjaTyJDoWiBk/
        sUa7z9PvibpJFiCFxp0XU5EQOOUe9Lo00+mBQwx6nwXkxqslJOu15hMdkz13wgVT596ir/
        H+ey5oT0PCuBcdciNDzFE1lE1Jv6+ag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-TkPKTIgoPDi80gw0QShlVw-1; Mon, 01 Jun 2020 10:02:02 -0400
X-MC-Unique: TkPKTIgoPDi80gw0QShlVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E326800053
        for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2020 14:02:01 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03BFB78EE7
        for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2020 14:02:00 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: Fix xfs_mount sunit and swidth types
Date:   Mon,  1 Jun 2020 16:01:52 +0200
Message-Id: <20200601140153.200864-2-cmaiolino@redhat.com>
In-Reply-To: <20200601140153.200864-1-cmaiolino@redhat.com>
References: <20200601140153.200864-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The sunit (mp->m_dalign) and swidth (mp->m_swidth) are currently encoded
as int in the xfs_mount structure, while it's treated as unsigned
everywhere where it is used (saving some places also changed by this
patch).

Change their type to uint32_t and fix some code using them as int.

This has been spotted by code inspection.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c   |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c |  2 +-
 fs/xfs/libxfs/xfs_ialloc.h |  2 +-
 fs/xfs/xfs_mount.c         |  4 ++--
 fs/xfs/xfs_mount.h         |  4 ++--
 fs/xfs/xfs_super.c         | 10 +++++-----
 fs/xfs/xfs_trace.h         |  7 ++++---
 7 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 667cdd0dfdf4..8b46f15cc414 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3477,7 +3477,7 @@ xfs_bmap_btalloc(
 	int		isaligned;
 	int		tryagain;
 	int		error;
-	int		stripe_align;
+	uint32_t	stripe_align;
 
 	ASSERT(ap->length);
 	orig_offset = ap->offset;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7fcf62b324b0..75cb2dd78a7a 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2913,7 +2913,7 @@ xfs_ialloc_setup_geometry(
 xfs_ino_t
 xfs_ialloc_calc_rootino(
 	struct xfs_mount	*mp,
-	int			sunit)
+	uint32_t		sunit)
 {
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	xfs_agblock_t		first_bno;
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 72b3468b97b1..a992bcae5358 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -152,6 +152,6 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
-xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
+xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, uint32_t sunit);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d5dcf9869860..1b1861376854 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -368,7 +368,7 @@ xfs_readsb(
 static inline int
 xfs_check_new_dalign(
 	struct xfs_mount	*mp,
-	int			new_dalign,
+	uint32_t		new_dalign,
 	bool			*update_sb)
 {
 	struct xfs_sb		*sbp = &mp->m_sb;
@@ -432,7 +432,7 @@ xfs_validate_new_dalign(
 			mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
 		} else {
 			xfs_warn(mp,
-		"alignment check failed: sunit(%d) less than bsize(%d)",
+		"alignment check failed: sunit(%u) less than bsize(%d)",
 				 mp->m_dalign, mp->m_sb.sb_blocksize);
 			return -EINVAL;
 		}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3725d25ad97e..6552473ab117 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -119,8 +119,8 @@ typedef struct xfs_mount {
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
-	int			m_dalign;	/* stripe unit */
-	int			m_swidth;	/* stripe width */
+	uint32_t		m_dalign;	/* stripe unit */
+	uint32_t		m_swidth;	/* stripe width */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
 	uint			m_allocsize_log;/* min write size log bytes */
 	uint			m_allocsize_blocks; /* min write size blocks */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fa58cb07c8fd..580072b19e8a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -193,11 +193,11 @@ xfs_fs_show_options(
 		seq_show_option(m, "rtdev", mp->m_rtname);
 
 	if (mp->m_dalign > 0)
-		seq_printf(m, ",sunit=%d",
-				(int)XFS_FSB_TO_BB(mp, mp->m_dalign));
+		seq_printf(m, ",sunit=%u",
+				XFS_FSB_TO_BB(mp, mp->m_dalign));
 	if (mp->m_swidth > 0)
-		seq_printf(m, ",swidth=%d",
-				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
+		seq_printf(m, ",swidth=%u",
+				XFS_FSB_TO_BB(mp, mp->m_swidth));
 
 	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
 		seq_puts(m, ",usrquota");
@@ -1338,7 +1338,7 @@ xfs_fc_validate_params(
 
 	if (mp->m_dalign && (mp->m_swidth % mp->m_dalign != 0)) {
 		xfs_warn(mp,
-	"stripe width (%d) must be a multiple of the stripe unit (%d)",
+	"stripe width (%u) must be a multiple of the stripe unit (%u)",
 			mp->m_swidth, mp->m_dalign);
 		return -EINVAL;
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 460136628a79..ad0c10e01a73 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3585,11 +3585,12 @@ DEFINE_KMEM_EVENT(kmem_realloc);
 DEFINE_KMEM_EVENT(kmem_zone_alloc);
 
 TRACE_EVENT(xfs_check_new_dalign,
-	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
+	TP_PROTO(struct xfs_mount *mp, uint32_t new_dalign,
+		 xfs_ino_t calc_rootino),
 	TP_ARGS(mp, new_dalign, calc_rootino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(int, new_dalign)
+		__field(uint32_t, new_dalign)
 		__field(xfs_ino_t, sb_rootino)
 		__field(xfs_ino_t, calc_rootino)
 	),
@@ -3599,7 +3600,7 @@ TRACE_EVENT(xfs_check_new_dalign,
 		__entry->sb_rootino = mp->m_sb.sb_rootino;
 		__entry->calc_rootino = calc_rootino;
 	),
-	TP_printk("dev %d:%d new_dalign %d sb_rootino %llu calc_rootino %llu",
+	TP_printk("dev %d:%d new_dalign %u sb_rootino %llu calc_rootino %llu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->new_dalign, __entry->sb_rootino,
 		  __entry->calc_rootino)
-- 
2.26.2

