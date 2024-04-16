Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CBF6AB9
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231748; cv=none; b=Bjd4TGTht2ZAWauuIrta7awGsKxQIhkJ7cglMuyypyXB6bkafsq04A43fCLAp4Aztd2Np3OzDYEXH1f5AKh23Xsmk1LPb18BDoFVEXdowtvqVl4hQkGnAy+t78dMAqgmONn3xg2xTob8Up+zbpyerIldhEFRIcht10ZPvb5n3ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231748; c=relaxed/simple;
	bh=JUy/LuvUD1YzrQCVTbIGHFA/kd3Wzrx2eXKRidV+2Rk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o2z2ONDufkUrde2ZyKnawYQ02vxn4P/ICH/Ez4LjDRUhhf2eQynq0iS4G9oBdu3tRKaVeE+d2AxePfXsyZD8KPJmHXLCAS9KNX0mbwyLdWb0Cq8FAOfOWhuZyzR4hLyDgKMGlp52fiqZEI3xqxzX+Dfjy1l483jRG2aC+mbWnk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJ04VrKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJ04VrKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA7FC113CC;
	Tue, 16 Apr 2024 01:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231748;
	bh=JUy/LuvUD1YzrQCVTbIGHFA/kd3Wzrx2eXKRidV+2Rk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NJ04VrKqrqQ+evFI3G2UEj2296fcADqS9hxwB5sbNRfqVvZ4bWg8za1i342x9w7Wv
	 NYn7Cbm3QCFjydwLJF4dTDw2iNtSp53L0yog6ojscWa/c4ME94ajrJ3tU0RKF7k8FQ
	 hX8pDOjzV9xQFbU/M0oEX94OuxhMQvQVonuZMPHrAy0t6fsIGIOrALQobVj01K6NDu
	 WYAxz3eHpMN7sip43VAKENtwg1EaSDwSG2R2NJT1SJegeXI4qGzH+xdXLTebOGMiF0
	 U35jqDeX78LtcjcWWCFvnn7bMWHpCA0Keisi4bJy4Ro/UKGBuPpmVhJkowp30wo4L5
	 QOi6gn4f0WCjg==
Date: Mon, 15 Apr 2024 18:42:27 -0700
Subject: [PATCH 4/4] xfs: only iget the file once when doing vectored
 scrub-by-handle
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Message-ID: <171323030309.253873.8649027644659300452.stgit@frogsfrogsfrogs>
In-Reply-To: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If a program wants us to perform a scrub on a file handle and the fd
passed to ioctl() is not the file referenced in the handle, iget the
file once and pass it into the scrub code.  This amortizes the untrusted
iget lookup over /all/ the scrubbers mentioned in the scrubv call.

When running fstests in "rebuild all metadata after each test" mode, I
observed a 10% reduction in runtime on account of avoiding repeated
inobt lookups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 78b00ab85c9c9..87a5a728031fb 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -792,6 +792,31 @@ xfs_scrubv_check_barrier(
 	return 0;
 }
 
+/*
+ * If the caller provided us with a nonzero inode number that isn't the ioctl
+ * file, try to grab a reference to it to eliminate all further untrusted inode
+ * lookups.  If we can't get the inode, let each scrub function try again.
+ */
+STATIC struct xfs_inode *
+xchk_scrubv_open_by_handle(
+	struct xfs_mount		*mp,
+	const struct xfs_scrub_vec_head	*head)
+{
+	struct xfs_inode		*ip;
+	int				error;
+
+	error = xfs_iget(mp, NULL, head->svh_ino, XFS_IGET_UNTRUSTED, 0, &ip);
+	if (error)
+		return NULL;
+
+	if (VFS_I(ip)->i_generation != head->svh_gen) {
+		xfs_irele(ip);
+		return NULL;
+	}
+
+	return ip;
+}
+
 /* Vectored scrub implementation to reduce ioctl calls. */
 int
 xfs_ioc_scrubv_metadata(
@@ -804,6 +829,7 @@ xfs_ioc_scrubv_metadata(
 	struct xfs_scrub_vec		__user *uvectors;
 	struct xfs_inode		*ip_in = XFS_I(file_inode(file));
 	struct xfs_mount		*mp = ip_in->i_mount;
+	struct xfs_inode		*handle_ip = NULL;
 	struct xfs_scrub_vec		*v;
 	size_t				vec_bytes;
 	unsigned int			i;
@@ -848,6 +874,17 @@ xfs_ioc_scrubv_metadata(
 		trace_xchk_scrubv_item(mp, &head, i, v);
 	}
 
+	/*
+	 * If the caller wants us to do a scrub-by-handle and the file used to
+	 * call the ioctl is not the same file, load the incore inode and pin
+	 * it across all the scrubv actions to avoid repeated UNTRUSTED
+	 * lookups.  The reference is not passed to deeper layers of scrub
+	 * because each scrubber gets to decide its own strategy for getting an
+	 * inode.
+	 */
+	if (head.svh_ino && head.svh_ino != ip_in->i_ino)
+		handle_ip = xchk_scrubv_open_by_handle(mp, &head);
+
 	/* Run all the scrubbers. */
 	for (i = 0, v = vectors; i < head.svh_nr; i++, v++) {
 		struct xfs_scrub_metadata	sm = {
@@ -895,6 +932,15 @@ xfs_ioc_scrubv_metadata(
 	}
 
 out_free:
+	/*
+	 * If we're holding the only reference to an inode opened via handle,
+	 * mark it dontcache so that we don't pollute the cache.
+	 */
+	if (handle_ip) {
+		if (atomic_read(&VFS_I(handle_ip)->i_count) == 1)
+			d_mark_dontcache(VFS_I(handle_ip));
+		xfs_irele(handle_ip);
+	}
 	kfree(vectors);
 	return error;
 }

