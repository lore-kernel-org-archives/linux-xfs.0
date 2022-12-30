Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1FBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236383AbiLaDZ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbiLaDZV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:25:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F8612A80
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:25:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EA5CB81E73
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6377C433EF;
        Sat, 31 Dec 2022 03:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457117;
        bh=XbOYt1quCT5N6pjlEpWpbq50eoDCaFVreZdvSgEY/g0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y8IS2IG2pjtulM2YIISK6ATMMil0lqXRugu91N8HLb3sZ2xcifq0iCTvAxN1mPFku
         EKZzGx3KJWynKObQwda8C7YKhflSZaMmCiyZwGv7mz/URk+rMU88B6hQr+As+V+lfk
         pqrCXsZkd89NbdQDLjrwvESPqV6K/bnP1OmIHa0sSVcoeNx8Rx+W3xExvsOfG9k2ya
         t6uZLlmbEWinDimdmY3tPbeqQOFITiqojLg2LKESVfwEMSN14udWRo/tyMvkg2G9cS
         Fu+nbdoKTBy9u7glffvsexn0XUicgAwdfiN+81C3VKVF/m7MShT+DvmLf2v1P3biz1
         FfxIEEvJkoVvA==
Subject: [PATCH 02/11] xfs: introduce vectored scrub mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243884059.739244.8952934219433779096.stgit@magnolia>
In-Reply-To: <167243884029.739244.16777239536975047510.stgit@magnolia>
References: <167243884029.739244.16777239536975047510.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Introduce a variant on XFS_SCRUB_METADATA that allows for vectored mode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 453b0861225..067dd0b1315 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -751,6 +751,15 @@ struct xfs_scrub_metadata {
 /* Number of scrub subcommands. */
 #define XFS_SCRUB_TYPE_NR	32
 
+/*
+ * This special type code only applies to the vectored scrub implementation.
+ *
+ * If any of the previous scrub vectors recorded runtime errors or have
+ * sv_flags bits set that match the OFLAG bits in the barrier vector's
+ * sv_flags, set the barrier's sv_ret to -ECANCELED and return to userspace.
+ */
+#define XFS_SCRUB_TYPE_BARRIER	(-1U)
+
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
 
@@ -795,6 +804,33 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+struct xfs_scrub_vec {
+	__u32 sv_type;		/* XFS_SCRUB_TYPE_* */
+	__u32 sv_flags;		/* XFS_SCRUB_FLAGS_* */
+	__s32 sv_ret;		/* 0 or a negative error code */
+	__u32 sv_reserved;	/* must be zero */
+};
+
+/* Vectored metadata scrub control structure. */
+struct xfs_scrub_vec_head {
+	__u64 svh_ino;		/* inode number. */
+	__u32 svh_gen;		/* inode generation. */
+	__u32 svh_agno;		/* ag number. */
+	__u32 svh_flags;	/* XFS_SCRUB_VEC_FLAGS_* */
+	__u16 svh_rest_us;	/* wait this much time between vector items */
+	__u16 svh_nr;		/* number of svh_vecs */
+
+	struct xfs_scrub_vec svh_vecs[0];
+};
+
+#define XFS_SCRUB_VEC_FLAGS_ALL		(0)
+
+static inline size_t sizeof_xfs_scrub_vec(unsigned int nr)
+{
+	return sizeof(struct xfs_scrub_vec_head) +
+		nr * sizeof(struct xfs_scrub_vec);
+}
+
 /*
  * ioctl limits
  */
@@ -839,6 +875,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
+#define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 60, struct xfs_scrub_vec_head)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 62, struct xfs_rtgroup_geometry)
 

