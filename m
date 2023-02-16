Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF54C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjBPUrU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBPUrT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:47:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87F54ECF1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7338B60C1A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1075C433EF;
        Thu, 16 Feb 2023 20:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580436;
        bh=/6NPo8lGi/hnV1eVi2f97U7kf1s0I63qe2ah5LMcKmU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jjhyRKLYszEf91dplQnLL/+j+NmXP+tWXz++fnU+B7lcBPXgw0PYF7NgB7jljSwR6
         9zYGdl2v3As/fDJkZJVD8zFlfJIIHyJVC8MU7fn4jz46mtJCOUFKlIJM0IuucrJF05
         k7ccYJOlfQ3aMzOk3vO6jElR7HvWYad8gk1GQGgsOdeRMH3y5foR++wjhZvTblzTl3
         d/DG4m3VXG78106XvCs/AbV1o0ty/nOUeTZPqmdPtkzMLC1ywxwBaPxtXBKpN/48py
         v0hmIDnbX8dUdBI4+etT3BzB3qzdx+sn+sHIgSB3baukxn0eZNCrwMpC1D5Aju1z7o
         x6sxwxCJfFOCA==
Date:   Thu, 16 Feb 2023 12:47:14 -0800
Subject: [PATCH 21/23] xfs: repair extended attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874135.3474338.12445265558220558646.stgit@magnolia>
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

If the extended attributes look bad, try to sift through the rubble to
find whatever keys/values we can, stage a new attribute structure in a
temporary file and use the atomic extent swapping mechanism to commit
the results in bulk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfarray.c |   24 ++++++++++++++++++++++++
 fs/xfs/scrub/xfarray.h |    2 ++
 fs/xfs/scrub/xfblob.c  |   24 ++++++++++++++++++++++++
 fs/xfs/scrub/xfblob.h  |    2 ++
 4 files changed, 52 insertions(+)


diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 8fdd7dd40193..fccb3a3d9199 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -368,3 +368,27 @@ xfarray_load_next(
 	*idx = cur;
 	return 0;
 }
+
+/* How many bytes is this array consuming? */
+long long
+xfarray_bytes(
+	struct xfarray		*array)
+{
+	struct xfile_stat	statbuf;
+	int			error;
+
+	error = xfile_stat(array->xfile, &statbuf);
+	if (error)
+		return error;
+
+	return statbuf.bytes;
+}
+
+/* Empty the entire array. */
+void
+xfarray_truncate(
+	struct xfarray	*array)
+{
+	xfile_discard(array->xfile, 0, MAX_LFS_FILESIZE);
+	array->nr = 0;
+}
diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index 26e2b594f121..8a3af0cecc3e 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -45,6 +45,8 @@ int xfarray_unset(struct xfarray *array, xfarray_idx_t idx);
 int xfarray_store(struct xfarray *array, xfarray_idx_t idx, const void *ptr);
 int xfarray_store_anywhere(struct xfarray *array, const void *ptr);
 bool xfarray_element_is_null(struct xfarray *array, const void *ptr);
+void xfarray_truncate(struct xfarray *array);
+long long xfarray_bytes(struct xfarray *array);
 
 /* Append an element to the array. */
 static inline int xfarray_append(struct xfarray *array, const void *ptr)
diff --git a/fs/xfs/scrub/xfblob.c b/fs/xfs/scrub/xfblob.c
index 1f89d7d13c59..2f89617a2db8 100644
--- a/fs/xfs/scrub/xfblob.c
+++ b/fs/xfs/scrub/xfblob.c
@@ -150,3 +150,27 @@ xfblob_free(
 	xfile_discard(blob->xfile, cookie, sizeof(key) + key.xb_size);
 	return 0;
 }
+
+/* How many bytes is this blob storage object consuming? */
+long long
+xfblob_bytes(
+	struct xfblob		*blob)
+{
+	struct xfile_stat	statbuf;
+	int			error;
+
+	error = xfile_stat(blob->xfile, &statbuf);
+	if (error)
+		return error;
+
+	return statbuf.bytes;
+}
+
+/* Drop all the blobs. */
+void
+xfblob_truncate(
+	struct xfblob	*blob)
+{
+	xfile_discard(blob->xfile, 0, MAX_LFS_FILESIZE);
+	blob->last_offset = 0;
+}
diff --git a/fs/xfs/scrub/xfblob.h b/fs/xfs/scrub/xfblob.h
index d1282810bb1d..8a5738e1d568 100644
--- a/fs/xfs/scrub/xfblob.h
+++ b/fs/xfs/scrub/xfblob.h
@@ -21,5 +21,7 @@ int xfblob_load(struct xfblob *blob, xfblob_cookie cookie, void *ptr,
 int xfblob_store(struct xfblob *blob, xfblob_cookie *cookie, const void *ptr,
 		uint32_t size);
 int xfblob_free(struct xfblob *blob, xfblob_cookie cookie);
+long long xfblob_bytes(struct xfblob *blob);
+void xfblob_truncate(struct xfblob *blob);
 
 #endif /* __XFS_SCRUB_XFBLOB_H__ */

