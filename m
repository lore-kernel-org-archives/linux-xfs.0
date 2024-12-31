Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2949613FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688410; cv=none; b=vDnThFQin2vvx2hli+guA1zFzW9Pun+Q9iFkCfUfH+yZRBSd4tAPRcFvkDl0zGjO3iFhdVzWZ3ADYMkYgZVTpCy4ZF+phTW6oBqBsFpVwcWB7LkikXGFJBCJ9boIWrwrEkS8RU+Nzlpw/eOL7BdcsqxgzFzIHfOUEJkdaXyNmp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688410; c=relaxed/simple;
	bh=I6r4whCp2cVDkTqRdsyiCBt0h8QCjktMKGrZQ/Y5qGY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gMtoW6Qs5XVVzvMEUhKOWK35XeoeLuXUDSjAklH4KfJP/q0itO49kyc2yfMJpY/xyzGhH/f4rtLQ0RS8twfS77Wk4RDESESQREutgUC3aj3PZd8SnooEKacBiTkzs/j5XRO0/RvisRi/8Ti4kp0aC4fdX4EmQ2lfOvTKGx8vdEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2DR0qGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2DR0qGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE745C4CED2;
	Tue, 31 Dec 2024 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688410;
	bh=I6r4whCp2cVDkTqRdsyiCBt0h8QCjktMKGrZQ/Y5qGY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D2DR0qGDdthHU8PwiwAKjCG0lqiZ5VSEhWOF1Hcrl35J0Xp59UWAMhgE7HU1ZfJVD
	 evgRq8ooLq5399rWv4yu4Ohs5mm8yf/uoGpKYEbeEkUe02BSJ9XH325CS+U5Ikg6cG
	 UsKz7yTi1KhwhphIyrCC1dC0XXO/vXkl9PzgCH2wlmfeKf+S+Nbt6ADrgX9nEnEIjG
	 3Apc8WbEmVFwwcFxKso2KnkYD1NO416Zf+JlWABjL5TlErNE4LRD/MLtJFajMMEA+G
	 Y7A/KbnNu4J/i2T5aLBsPcmdufSDicadrdFP4OJYh8WTr4bP3RkYW0do65aue+yiIw
	 DlIN1X1HAm0Og==
Date: Tue, 31 Dec 2024 15:40:09 -0800
Subject: [PATCH 05/16] iomap,
 filemap: report buffered read and write io errors to the filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754829.2704911.5583911059846056720.stgit@frogsfrogsfrogs>
In-Reply-To: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
References: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Provide a callback so that iomap can report read and write IO errors to
the caller filesystem.  For now this is only wired up for iomap as a
testbed for XFS.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 Documentation/filesystems/vfs.rst |    7 +++++++
 fs/iomap/buffered-io.c            |   26 +++++++++++++++++++++++++-
 include/linux/fs.h                |    4 ++++
 3 files changed, 36 insertions(+), 1 deletion(-)


diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 0b18af3f954eb7..2f0ef4e1a8d340 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -827,6 +827,8 @@ cache in your filesystem.  The following members are defined:
 		int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
 		int (*swap_deactivate)(struct file *);
 		int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
+		void (*ioerror)(struct address_space *mapping, int direction,
+				loff_t pos, u64 len, int error);
 	};
 
 ``writepage``
@@ -1056,6 +1058,11 @@ cache in your filesystem.  The following members are defined:
 ``swap_rw``
 	Called to read or write swap pages when SWP_FS_OPS is set.
 
+``ioerror``
+        Called to deal with IO errors during readahead or writeback.
+        This may be called from interrupt context, and without any
+        locks necessarily being held.
+
 The File Object
 ===============
 
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 86e30b56e8d41b..39782376895306 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -284,6 +284,14 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 	*lenp = plen;
 }
 
+static inline void iomap_mapping_ioerror(struct address_space *mapping,
+		int direction, loff_t pos, u64 len, int error)
+{
+	if (mapping && mapping->a_ops->ioerror)
+		mapping->a_ops->ioerror(mapping, direction, pos, len,
+				error);
+}
+
 static void iomap_finish_folio_read(struct folio *folio, size_t off,
 		size_t len, int error)
 {
@@ -302,6 +310,10 @@ static void iomap_finish_folio_read(struct folio *folio, size_t off,
 		spin_unlock_irqrestore(&ifs->state_lock, flags);
 	}
 
+	if (error)
+		iomap_mapping_ioerror(folio->mapping, READ,
+				folio_pos(folio) + off, len, error);
+
 	if (finished)
 		folio_end_read(folio, uptodate);
 }
@@ -670,11 +682,16 @@ static int iomap_read_folio_sync(loff_t block_start, struct folio *folio,
 {
 	struct bio_vec bvec;
 	struct bio bio;
+	int ret;
 
 	bio_init(&bio, iomap->bdev, &bvec, 1, REQ_OP_READ);
 	bio.bi_iter.bi_sector = iomap_sector(iomap, block_start);
 	bio_add_folio_nofail(&bio, folio, plen, poff);
-	return submit_bio_wait(&bio);
+	ret = submit_bio_wait(&bio);
+	if (ret)
+		iomap_mapping_ioerror(folio->mapping, READ,
+				folio_pos(folio) + poff, plen, ret);
+	return ret;
 }
 
 static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
@@ -1573,6 +1590,11 @@ u32 iomap_finish_ioend_buffered(struct iomap_ioend *ioend)
 
 	/* walk all folios in bio, ending page IO on them */
 	bio_for_each_folio_all(fi, bio) {
+		if (ioend->io_error)
+			iomap_mapping_ioerror(inode->i_mapping, WRITE,
+					folio_pos(fi.folio) + fi.offset,
+					fi.length, ioend->io_error);
+
 		iomap_finish_folio_write(inode, fi.folio, fi.length);
 		folio_count++;
 	}
@@ -1881,6 +1903,8 @@ static int iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 
 	if (count)
 		wpc->nr_folios++;
+	if (error && !count)
+		iomap_mapping_ioerror(inode->i_mapping, WRITE, pos, 0, error);
 
 	/*
 	 * We can have dirty bits set past end of file in page_mkwrite path
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b638fb1bcbc96f..9375753577025d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -438,6 +438,10 @@ struct address_space_operations {
 				sector_t *span);
 	void (*swap_deactivate)(struct file *file);
 	int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
+
+	/* Callback for dealing with IO errors during readahead or writeback */
+	void (*ioerror)(struct address_space *mapping, int direction,
+			loff_t pos, u64 len, int error);
 };
 
 extern const struct address_space_operations empty_aops;

