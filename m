Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01877212FBC
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528411; cv=none; b=MktfyxFnPaXdOYdoJdqRdNiTt2sIQ++CDuC+xWZSR0Dbmf29SSIB7J9SrhxzPDcJZYFL3iiNXCxOL+0NuG6fFE37KpSSexlXhdvp11ltIenDjOTTDKj3HIhmmAmbxzoL4B1hhNmy3FrierJbgcpBqalfDHP1cqlQ9C1piE1sqM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528411; c=relaxed/simple;
	bh=gj7qpNWm8NxrkEGVdzdTQTZ3XWqiMDdL7/2QKqUWsL8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MI/wTXYOYBvvHZ1J765EZ3RTACO6asB5JzNCjS1rLZL+0+M8B2YVhdEfCpa4depFgccwI/bFE9z/PMADGIHrFzGn8/6hTagrTZaS7Lrs3lm+bmOTHnr8QN8WgqvZbDko0043r3mGgjKw307sow2BBKDsI2yIMIdimwH1n24FCgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VqARcpFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VqARcpFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAE4C4CED1;
	Fri,  6 Dec 2024 23:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528410;
	bh=gj7qpNWm8NxrkEGVdzdTQTZ3XWqiMDdL7/2QKqUWsL8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VqARcpFuB2Hg7a6nOKJBVIvYact4lSZhr1RTLaFJ0zc4LeP6ITfd7SMZaM/iMDCWc
	 GjMS27v/DO2PUckfOTZ89TsHGw7nJO8RovEIUwzcZArCeaoe9/bigMKBG8yoscadh1
	 icTysURpzdYJ6IpsSQtXQzfgv+B2oAQ8ck8dH8hgdFPOq8TRvGe+dwxILYkAtWEPj6
	 XhpsVWqCzw+ApljYkkLAh0c3kCiWeuOt8CkSMTxrCUZ4ufYPTJiBUuxP4C5MI6SSVd
	 EPgkGL9ZNtnntjIDBuNoBpwuGJhP0mJbzIDxvqWD2bQlIlf8vYafmzJmh4Nfgyfe0i
	 hGSdQfoWF3QZg==
Date: Fri, 06 Dec 2024 15:40:10 -0800
Subject: [PATCH 02/41] libxfs: load metadata directory root at mount time
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748269.122992.3943016621222740988.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Load the metadata directory root inode into memory at mount time and
release it at unmount time.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_mount.h |    1 +
 libxfs/init.c       |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index c7fada9e2a6d70..6daf3f01ffa9cf 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -91,6 +91,7 @@ typedef struct xfs_mount {
 	uint8_t			*m_rsum_cache;
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
+	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
 	struct xfs_buftarg	*m_ddev_targp;
 	struct xfs_buftarg	*m_logdev_targp;
 	struct xfs_buftarg	*m_rtdev_targp;
diff --git a/libxfs/init.c b/libxfs/init.c
index beb58706629d23..bf488c5d8533b1 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -619,6 +619,27 @@ libxfs_compute_all_maxlevels(
 
 }
 
+/* Mount the metadata files under the metadata directory tree. */
+STATIC void
+libxfs_mount_setup_metadir(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	/* Ignore filesystems that are under construction. */
+	if (mp->m_sb.sb_inprogress)
+		return;
+
+	error = -libxfs_metafile_iget(mp, mp->m_sb.sb_metadirino,
+			XFS_METAFILE_DIR, &mp->m_metadirip);
+	if (error) {
+		fprintf(stderr,
+ _("%s: Failed to load metadir root directory, error %d\n"),
+					progname, error);
+		return;
+	}
+}
+
 /*
  * precalculate the low space thresholds for dynamic speculative preallocation.
  */
@@ -800,6 +821,9 @@ libxfs_mount(
 	}
 	xfs_set_perag_data_loaded(mp);
 
+	if (xfs_has_metadir(mp))
+		libxfs_mount_setup_metadir(mp);
+
 	return mp;
 out_da:
 	xfs_da_unmount(mp);
@@ -918,6 +942,8 @@ libxfs_umount(
 	int			error;
 
 	libxfs_rtmount_destroy(mp);
+	if (mp->m_metadirip)
+		libxfs_irele(mp->m_metadirip);
 
 	/*
 	 * Purge the buffer cache to write all dirty buffers to disk and free

