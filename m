Return-Path: <SRS0=5CkV=34=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735C8C35242
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 21:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 359202253D
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 21:10:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AaI7ZtTS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgBHVKm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Feb 2020 16:10:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31415 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727484AbgBHVKm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Feb 2020 16:10:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581196240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=BvpkezvFJYIHh4Fd8iBnBBUf7GuI/QGhu+1C1efVENQ=;
        b=AaI7ZtTS1suLQ/UnxauQz9/EZH/infl59OEu1l7Kh1rEjU9CBnO8XTdmHC/zSkWiv5gsix
        VwIu+liPctel2QOz+cf1yuIm9I0om8hWrjuThQ6gkOZyIpz7+Eki6Pxlk54Aj7irjGNjxd
        syLPCeAVcXkrZ7CE/9ni895wm/cF7Qo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-9_lfCmveMEGvIbWQHoE5nQ-1; Sat, 08 Feb 2020 16:10:38 -0500
X-MC-Unique: 9_lfCmveMEGvIbWQHoE5nQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B12331800D42
        for <linux-xfs@vger.kernel.org>; Sat,  8 Feb 2020 21:10:37 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82DE486458
        for <linux-xfs@vger.kernel.org>; Sat,  8 Feb 2020 21:10:37 +0000 (UTC)
Subject: [PATCH 1/4] xfs: fix up some whitespace in quota code
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <31c57459-2b3e-984d-cb20-e85566caafd0@redhat.com>
Date:   Sat, 8 Feb 2020 15:10:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is a fair bit of whitespace damage in the quota code, so
fix up enough of it that subsequent patches are restricted to
functional change to aid review.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_dquot.c    | 16 ++++++++--------
 fs/xfs/xfs_qm.h       | 44 +++++++++++++++++++++----------------------
 fs/xfs/xfs_quotaops.c |  8 ++++----
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index d223e1ae90a6..02f433d1f13a 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -205,16 +205,16 @@ xfs_qm_adjust_dqtimers(
  */
 STATIC void
 xfs_qm_init_dquot_blk(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dqid_t	id,
-	uint		type,
-	xfs_buf_t	*bp)
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	struct xfs_buf		*bp)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	xfs_dqblk_t	*d;
-	xfs_dqid_t	curid;
-	int		i;
+	xfs_dqblk_t		*d;
+	xfs_dqid_t		curid;
+	int			i;
 
 	ASSERT(tp);
 	ASSERT(xfs_buf_islocked(bp));
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 4e57edca8bce..3a850401b102 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -42,12 +42,12 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
 #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
 
 struct xfs_def_quota {
-	xfs_qcnt_t       bhardlimit;     /* default data blk hard limit */
-	xfs_qcnt_t       bsoftlimit;	 /* default data blk soft limit */
-	xfs_qcnt_t       ihardlimit;	 /* default inode count hard limit */
-	xfs_qcnt_t       isoftlimit;	 /* default inode count soft limit */
-	xfs_qcnt_t	 rtbhardlimit;   /* default realtime blk hard limit */
-	xfs_qcnt_t	 rtbsoftlimit;   /* default realtime blk soft limit */
+	xfs_qcnt_t	bhardlimit;	/* default data blk hard limit */
+	xfs_qcnt_t	bsoftlimit;	/* default data blk soft limit */
+	xfs_qcnt_t	ihardlimit;	/* default inode count hard limit */
+	xfs_qcnt_t	isoftlimit;	/* default inode count soft limit */
+	xfs_qcnt_t	rtbhardlimit;	/* default realtime blk hard limit */
+	xfs_qcnt_t	rtbsoftlimit;	/* default realtime blk soft limit */
 };
 
 /*
@@ -55,28 +55,28 @@ struct xfs_def_quota {
  * The mount structure keeps a pointer to this.
  */
 struct xfs_quotainfo {
-	struct radix_tree_root qi_uquota_tree;
-	struct radix_tree_root qi_gquota_tree;
-	struct radix_tree_root qi_pquota_tree;
-	struct mutex qi_tree_lock;
+	struct radix_tree_root	qi_uquota_tree;
+	struct radix_tree_root	qi_gquota_tree;
+	struct radix_tree_root	qi_pquota_tree;
+	struct mutex		qi_tree_lock;
 	struct xfs_inode	*qi_uquotaip;	/* user quota inode */
 	struct xfs_inode	*qi_gquotaip;	/* group quota inode */
 	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
-	struct list_lru	 qi_lru;
-	int		 qi_dquots;
-	time64_t	 qi_btimelimit;	 /* limit for blks timer */
-	time64_t	 qi_itimelimit;	 /* limit for inodes timer */
-	time64_t	 qi_rtbtimelimit;/* limit for rt blks timer */
-	xfs_qwarncnt_t	 qi_bwarnlimit;	 /* limit for blks warnings */
-	xfs_qwarncnt_t	 qi_iwarnlimit;	 /* limit for inodes warnings */
-	xfs_qwarncnt_t	 qi_rtbwarnlimit;/* limit for rt blks warnings */
-	struct mutex	 qi_quotaofflock;/* to serialize quotaoff */
-	xfs_filblks_t	 qi_dqchunklen;	 /* # BBs in a chunk of dqs */
-	uint		 qi_dqperchunk;	 /* # ondisk dqs in above chunk */
+	struct list_lru		qi_lru;
+	int			qi_dquots;
+	time64_t		qi_btimelimit;	/* limit for blks timer */
+	time64_t		qi_itimelimit;	/* limit for inodes timer */
+	time64_t		qi_rtbtimelimit;/* limit for rt blks timer */
+	xfs_qwarncnt_t		qi_bwarnlimit;	/* limit for blks warnings */
+	xfs_qwarncnt_t		qi_iwarnlimit;	/* limit for inodes warnings */
+	xfs_qwarncnt_t		qi_rtbwarnlimit;/* limit for rt blks warnings */
+	struct mutex		qi_quotaofflock;/* to serialize quotaoff */
+	xfs_filblks_t		qi_dqchunklen;	/* # BBs in a chunk of dqs */
+	uint			qi_dqperchunk;	/* # ondisk dq in above chunk */
 	struct xfs_def_quota	qi_usr_default;
 	struct xfs_def_quota	qi_grp_default;
 	struct xfs_def_quota	qi_prj_default;
-	struct shrinker	qi_shrinker;
+	struct shrinker		qi_shrinker;
 };
 
 static inline struct radix_tree_root *
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 38669e827206..cb16a91dd1d4 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -23,8 +23,8 @@ xfs_qm_fill_state(
 	struct xfs_inode	*ip,
 	xfs_ino_t		ino)
 {
-	struct xfs_quotainfo *q = mp->m_quotainfo;
-	bool tempqip = false;
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
+	bool			tempqip = false;
 
 	tstate->ino = ino;
 	if (!ip && ino == NULLFSINO)
@@ -109,8 +109,8 @@ xfs_fs_set_info(
 	int			type,
 	struct qc_info		*info)
 {
-	struct xfs_mount *mp = XFS_M(sb);
-	struct qc_dqblk newlim;
+	struct xfs_mount	*mp = XFS_M(sb);
+	struct qc_dqblk		newlim;
 
 	if (sb_rdonly(sb))
 		return -EROFS;
-- 
2.17.0


