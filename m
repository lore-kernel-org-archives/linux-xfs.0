Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D182CC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbiLaDZq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbiLaDZf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:25:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AF712A80
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:25:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0142B61C7A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7AFC433EF;
        Sat, 31 Dec 2022 03:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457133;
        bh=RedcZtUlhM9LzsQTYpybCqt2h/vSHAx1cngBcOQQlF0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Nhlfkw58wV5YTejfcAFXRtg/XoRG5J86HaidwJpGhj+77aXWKzvs2wLJZUDXxs0qe
         aJa5bSTC4uuKKfHe0K1R4Q2K6aXioplmJh+m4mdL9iN6feNDenv3yxIJfQQefuKA9H
         0dQzBnTJgjhlS7xglL/FCkq+yEQxMIhgTr3S8iXD/lzTw8pV2tCdD2v4DUXTFTDLYm
         CRaM3muqvHvH3tKFaI6dPQzgMdxZwZ42raYCGDNpippcYaKjUkT/4rMWObQSF28SBp
         jtc8Re2WC+5FM3Iv+HGDP0YuYgytAyJVJTawrzqIX/FJNONkaa0mid5ELPvem5zKVV
         5bjapW8d/QgZg==
Subject: [PATCH 03/11] libfrog: support vectored scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243884072.739244.9544942319521737422.stgit@magnolia>
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

Enhance libfrog to support performing vectored metadata scrub.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/fsgeom.h |    6 +++
 libfrog/scrub.c  |  124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/scrub.h  |    1 
 3 files changed, 131 insertions(+)


diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index 6c6d6bb815a..0265a7c1684 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -58,6 +58,12 @@ struct xfs_fd {
 /* Only use FIEXCHANGE_RANGE for file data exchanges. */
 #define XFROG_FLAG_FORCE_FIEXCHANGE	(1 << 3)
 
+/* Only use the older one-at-a-time scrub ioctl. */
+#define XFROG_FLAG_SCRUB_FORCE_SINGLE	(1 << 4)
+
+/* Only use the vectored scrub ioctl. */
+#define XFROG_FLAG_SCRUB_FORCE_VECTOR	(1 << 5)
+
 /* Static initializers */
 #define XFS_FD_INIT(_fd)	{ .fd = (_fd), }
 #define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)
diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index c3cf5312f80..02b659ea2bd 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -186,3 +186,127 @@ xfrog_scrub_metadata(
 
 	return 0;
 }
+
+/* Decide if there have been any scrub failures up to this point. */
+static inline int
+xfrog_scrubv_previous_failures(
+	struct xfs_scrub_vec_head	*vhead,
+	struct xfs_scrub_vec		*barrier_vec)
+{
+	struct xfs_scrub_vec		*v;
+	__u32				failmask;
+
+	failmask = barrier_vec->sv_flags & XFS_SCRUB_FLAGS_OUT;
+	for (v = vhead->svh_vecs; v < barrier_vec; v++) {
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER)
+			continue;
+
+		/*
+		 * Runtime errors count as a previous failure, except the ones
+		 * used to ask userspace to retry.
+		 */
+		if (v->sv_ret && v->sv_ret != -EBUSY && v->sv_ret != -ENOENT &&
+		    v->sv_ret != -EUSERS)
+			return -ECANCELED;
+
+		/*
+		 * If any of the out-flags on the scrub vector match the mask
+		 * that was set on the barrier vector, that's a previous fail.
+		 */
+		if (v->sv_flags & failmask)
+			return -ECANCELED;
+	}
+
+	return 0;
+}
+
+static int
+xfrog_scrubv_fallback(
+	struct xfs_fd			*xfd,
+	struct xfs_scrub_vec_head	*vhead)
+{
+	struct xfs_scrub_vec		*v;
+	unsigned int			i;
+
+	if (vhead->svh_flags & ~XFS_SCRUB_VEC_FLAGS_ALL)
+		return -EINVAL;
+	for (i = 0, v = vhead->svh_vecs; i < vhead->svh_nr; i++, v++) {
+		if (v->sv_reserved)
+			return -EINVAL;
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER &&
+		    (v->sv_flags & ~XFS_SCRUB_FLAGS_OUT))
+			return -EINVAL;
+	}
+
+	/* Run all the scrubbers. */
+	for (i = 0, v = vhead->svh_vecs; i < vhead->svh_nr; i++, v++) {
+		struct xfs_scrub_metadata	sm = {
+			.sm_type	= v->sv_type,
+			.sm_flags	= v->sv_flags,
+			.sm_ino		= vhead->svh_ino,
+			.sm_gen		= vhead->svh_gen,
+			.sm_agno	= vhead->svh_agno,
+		};
+		struct timespec	tv;
+
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER) {
+			v->sv_ret = xfrog_scrubv_previous_failures(vhead, v);
+			if (v->sv_ret)
+				break;
+			continue;
+		}
+
+		v->sv_ret = xfrog_scrub_metadata(xfd, &sm);
+		v->sv_flags = sm.sm_flags;
+
+		if (vhead->svh_rest_us) {
+			tv.tv_sec = 0;
+			tv.tv_nsec = vhead->svh_rest_us * 1000;
+			nanosleep(&tv, NULL);
+		}
+	}
+
+	return 0;
+}
+
+/* Invoke the vectored scrub ioctl. */
+static int
+xfrog_scrubv_call(
+	struct xfs_fd			*xfd,
+	struct xfs_scrub_vec_head	*vhead)
+{
+	int				ret;
+
+	ret = ioctl(xfd->fd, XFS_IOC_SCRUBV_METADATA, vhead);
+	if (ret)
+		return -errno;
+
+	return 0;
+}
+
+/* Invoke the vectored scrub ioctl.  Returns zero or negative error code. */
+int
+xfrog_scrubv_metadata(
+	struct xfs_fd			*xfd,
+	struct xfs_scrub_vec_head	*vhead)
+{
+	int				error = 0;
+
+	if (xfd->flags & XFROG_FLAG_SCRUB_FORCE_SINGLE)
+		goto try_single;
+
+	error = xfrog_scrubv_call(xfd, vhead);
+	if (error == 0 || (xfd->flags & XFROG_FLAG_SCRUB_FORCE_VECTOR))
+		return error;
+
+	/* If the vectored scrub ioctl wasn't found, force single mode. */
+	switch (error) {
+	case -EOPNOTSUPP:
+	case -ENOTTY:
+		xfd->flags |= XFROG_FLAG_SCRUB_FORCE_SINGLE;
+		break;
+	}
+
+try_single:
+	return xfrog_scrubv_fallback(xfd, vhead);
+}
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index 7155e6a9b0e..2f5ca2b1317 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -28,5 +28,6 @@ struct xfrog_scrub_descr {
 extern const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR];
 
 int xfrog_scrub_metadata(struct xfs_fd *xfd, struct xfs_scrub_metadata *meta);
+int xfrog_scrubv_metadata(struct xfs_fd *xfd, struct xfs_scrub_vec_head *vhead);
 
 #endif	/* __LIBFROG_SCRUB_H__ */

