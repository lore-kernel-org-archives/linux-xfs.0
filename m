Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB7EC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBPUqP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBPUqO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:46:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB194ECEF
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:46:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEEE960C1D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571A4C433EF;
        Thu, 16 Feb 2023 20:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580372;
        bh=UzSVyNQ2Jfs+fsvgU3Rx0t0MDBQLSEUWpMct2r2uOHs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=CTXeu306HTc3ZLbBgt6Vm4BzWxwDUY1txAXlB4vLwL85R95MNJGqbxuITa4RR5ZJG
         s4mcXxYd1YkJkouk7kodHwOwuWOG8lLzj35AqnK3OHAa7d0LRdvxNSjeY+ENkMPliR
         msLLVOlZ0p6UAZv5BuevpxdH2ZjB3mliFL7YqU3YY1anMlxuBHdWrqag9Mt27wxfmb
         QqrwKRKKvpzWvNuUydQfItYAbN/rI7D7HiCsZizhUgt3wG7DO5yQXisfExv6Be/o6d
         AqxA1v6QrdVpgBzIQu9ggXY0DAxlDbcd8rAyvWXfOiEZ0Lm6SDzcg/dO3uh1OmcpBR
         VCf0LqQE7U4FQ==
Date:   Thu, 16 Feb 2023 12:46:11 -0800
Subject: [PATCH 17/23] xfs: connect in-memory btrees to xfiles
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874078.3474338.15663340574527028545.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add to our stubbed-out in-memory btrees the ability to connect them with
an actual in-memory backing file (aka xfiles) and the necessary pieces
to track free space in the xfile and flush dirty xfbtree buffers on
demand, which we'll need for online repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    1 +
 fs/xfs/scrub/xfile.c |   11 +++++++++++
 fs/xfs/scrub/xfile.h |    2 ++
 3 files changed, 14 insertions(+)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 979ee2789668..4a6f0f1b0881 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -755,6 +755,7 @@ DEFINE_EVENT(xfile_class, name, \
 DEFINE_XFILE_EVENT(xfile_pread);
 DEFINE_XFILE_EVENT(xfile_pwrite);
 DEFINE_XFILE_EVENT(xfile_seek_data);
+DEFINE_XFILE_EVENT(xfile_discard);
 
 TRACE_EVENT(xfarray_create,
 	TP_PROTO(struct xfarray *xfa, unsigned long long required_capacity),
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 43455aa78243..f9888b6dd728 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -285,6 +285,17 @@ xfile_pwrite(
 	return error;
 }
 
+/* Discard pages backing a range of the xfile. */
+void
+xfile_discard(
+	struct xfile		*xf,
+	loff_t			pos,
+	u64			count)
+{
+	trace_xfile_discard(xf, pos, count);
+	shmem_truncate_range(file_inode(xf->file), pos, pos + count - 1);
+}
+
 /* Find the next written area in the xfile data for a given offset. */
 loff_t
 xfile_seek_data(
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index b37dba1961d8..973c8fc37707 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -46,6 +46,8 @@ xfile_obj_store(struct xfile *xf, const void *buf, size_t count, loff_t pos)
 	return 0;
 }
 
+void xfile_discard(struct xfile *xf, loff_t pos, u64 count);
+int xfile_prealloc(struct xfile *xf, loff_t pos, u64 count);
 loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
 
 struct xfile_stat {

