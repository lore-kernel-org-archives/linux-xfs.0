Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A60BDF58;
	Tue, 30 Apr 2024 03:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714447353; cv=none; b=dNUGKNEUDD4uqz8JWz+h9ZlAP6yiV7zOmhaWUFqk97P+k3bBWm//LnsTJ4IjdALDOp4/75CMh1HRjAbrgi5Cseh09VgjXa2pJyoqmd48rRSkC0mUPeGi0ke4IIU9x5yduqpYr6rFRUZSib1TwgxPwIw0a6f+wkjUHxk0w8gAQFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714447353; c=relaxed/simple;
	bh=nrVlaQU2IrwSGBzZTi6Pc/FQDWhRCu9nrgdykjbTDlU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NeTcVCzWKTYT5Q7/J3OewTMj7UXrxlyiAKzfglxDJC8esWl+H5n8Fif23N0zTDevJuQ5Rbb1W6L42dpI7qQzD7qDMT8i+kvNWACcVQF2XmCsB/LwOfuOLbMmP5MGyOoiPJV35AqINnx+r0kgKxiyhhdf4AwQND4v3cFdBafQXqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YM/DV0R2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YM/DV0R2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1111CC116B1;
	Tue, 30 Apr 2024 03:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714447353;
	bh=nrVlaQU2IrwSGBzZTi6Pc/FQDWhRCu9nrgdykjbTDlU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YM/DV0R21/SDoCG0KpNtluQycXHZ3nFXdrEcBaYdhS/awMdI5gKvmVRp5s85Twgmc
	 hVHAcWrcmgDMgVUlx/ti0NZZZRJuc+bgoSfKeowLUITKzZnUsCT4aGncodBZ1uP4vq
	 op/GQLmQoihwUA1/j5jSNeiCp/Dt0R3pxX3sM/MCUpYe/EhzdlKQ5ix6UNNthVqAnk
	 o0U3rMH/x4nr3EgneIp3TU+38+bKu9Zc9L3C2d7VMVb8qT4Y5loW1Ix0+BgsNBeEcc
	 8l5WGpjT+bRE8rYAzoxD1Y2o7XdV2vWJuuq2jmQ8Eua4Ah5eTpfVcASJFU8mqrot2n
	 S1V6ADOrhX2fQ==
Date: Mon, 29 Apr 2024 20:22:32 -0700
Subject: [PATCH 12/18] fsverity: report validation errors back to the
 filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@redhat.com, ebiggers@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, alexl@redhat.com, walters@verbum.org,
 fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org
Message-ID: <171444679792.955480.12734412776214738149.stgit@frogsfrogsfrogs>
In-Reply-To: <171444679542.955480.18087310571597618350.stgit@frogsfrogsfrogs>
References: <171444679542.955480.18087310571597618350.stgit@frogsfrogsfrogs>
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

Provide a new function call so that validation errors can be reported
back to the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/verity/verify.c              |    3 +++
 include/linux/fsverity.h        |   14 ++++++++++++++
 include/trace/events/fsverity.h |   19 +++++++++++++++++++
 3 files changed, 36 insertions(+)


diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 0782a69d89f26..2c1de3cdf24c8 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -250,6 +250,9 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		     data_pos, level - 1,
 		     params->hash_alg->name, hsize, want_hash,
 		     params->hash_alg->name, hsize, real_hash);
+	trace_fsverity_file_corrupt(inode, data_pos, params->block_size);
+	if (vops->file_corrupt)
+		vops->file_corrupt(inode, data_pos, params->block_size);
 error:
 	for (; level > 0; level--)
 		fsverity_drop_merkle_tree_block(inode, &hblocks[level - 1].block);
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index dc8f85380b9c7..6849c4e8268f8 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -228,6 +228,20 @@ struct fsverity_operations {
 	 * be implemented.
 	 */
 	void (*drop_merkle_tree_block)(struct fsverity_blockbuf *block);
+
+	/**
+	 * Notify the filesystem that file data is corrupt.
+	 *
+	 * @inode: the inode being validated
+	 * @pos: the file position of the invalid data
+	 * @len: the length of the invalid data
+	 *
+	 * This function is called when fs-verity detects that a portion of a
+	 * file's data is inconsistent with the Merkle tree, or a Merkle tree
+	 * block needed to validate the data is inconsistent with the level
+	 * above it.
+	 */
+	void (*file_corrupt)(struct inode *inode, loff_t pos, size_t len);
 };
 
 #ifdef CONFIG_FS_VERITY
diff --git a/include/trace/events/fsverity.h b/include/trace/events/fsverity.h
index dab220884b897..375fdddac6a99 100644
--- a/include/trace/events/fsverity.h
+++ b/include/trace/events/fsverity.h
@@ -137,6 +137,25 @@ TRACE_EVENT(fsverity_verify_merkle_block,
 		__entry->hidx)
 );
 
+TRACE_EVENT(fsverity_file_corrupt,
+	TP_PROTO(const struct inode *inode, loff_t pos, size_t len),
+	TP_ARGS(inode, pos, len),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(loff_t, pos)
+		__field(size_t, len)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->pos = pos;
+		__entry->len = len;
+	),
+	TP_printk("ino %lu pos %llu len %zu",
+		(unsigned long) __entry->ino,
+		__entry->pos,
+		__entry->len)
+);
+
 #endif /* _TRACE_FSVERITY_H */
 
 /* This part must be outside protection */

