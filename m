Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF72A1422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991062; cv=none; b=bc08wjd157TOb9B4aznBeL82T1xT9AZR3OOKfI/vYrTptP42SsTYpM/gNfGBgl1RQd9wo0KmJYUISEOluuh7vr6SgsnWTNIc1/VZG2xPMEsvtxb0ms9f17+6hgy8aOuPTmIXB/radTuDbkbVfLQUE2/17voZJ02Wff+Tb6taXKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991062; c=relaxed/simple;
	bh=t7BV/BvzMP2navKnjz89aOqx6t2KqTA6RP4yrzYSisk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V+sv/lkAzEJyMa8ktDbO4igheJBndF0QALKSPWq2gHchMK1+AA1uxKlGDxnpqimrOqrR5WnTVf1VAoPPRiUI2RKDbkkOQutVVcV32UdGAXTh+hnKQ+f4huPoWfNJSCKdTMxt1cJHviGPCp02aa1UtSrxJvb+nmtpOOwQq8osbEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E3/pMFdf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E3/pMFdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8561BC4CED3;
	Mon, 23 Dec 2024 21:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991062;
	bh=t7BV/BvzMP2navKnjz89aOqx6t2KqTA6RP4yrzYSisk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E3/pMFdfi8wuH3KlfwqdcY4l9xuuf95uQrcX6reOCeCtyhKpAvCTs0WVJDr6kTJTC
	 mgcO7flv8aVXW/eu6UvxRonaYxIjqjjmv8zgUvyNtOF+qyKY2AkWWJ11qjU/BE/XYW
	 5d2OJlXsTVCIfL3WFphjIva/26U7wwvPzksLlvgL6fnBB+Eb33+UOOuL+weBquXnBl
	 Jjf78zvzBPSjx3tAbtehMLzmdBrK3+XNnuuimMryZQoTGCkzarHZ0BTUcnt2dRd1P9
	 a6h44Ao6Sitw6ha+US6JApLjXdOFftKoS3p1GMj7pQmzw5D5v+4VzjzMip4686FIXd
	 KsJUZX0+1wrOA==
Date: Mon, 23 Dec 2024 13:57:42 -0800
Subject: [PATCH 2/4] mkfs: support copying in large or sparse files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941959.2295644.1190041955142131540.stgit@frogsfrogsfrogs>
In-Reply-To: <173498941923.2295644.12590815257028938964.stgit@frogsfrogsfrogs>
References: <173498941923.2295644.12590815257028938964.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Restructure the protofile code to handle sparse files and files that are
larger than the program's address space.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h |    2 +
 libxfs/util.c    |   67 +++++++++++++++++++++
 mkfs/proto.c     |  175 ++++++++++++++++++++++++++++++++----------------------
 3 files changed, 174 insertions(+), 70 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 878fefbbde7524..985646e6ad89d1 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -178,6 +178,8 @@ extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
 
 int	libxfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len, uint32_t bmapi_flags);
+int	libxfs_file_write(struct xfs_inode *ip, void *buf, off_t pos,
+		size_t len);
 
 /* XXX: this is messy and needs fixing */
 #ifndef __LIBXFS_INTERNAL_XFS_H__
diff --git a/libxfs/util.c b/libxfs/util.c
index e5892fc86c3e92..8c2ecff5855775 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -527,3 +527,70 @@ get_random_u32(void)
 	return ret;
 }
 #endif
+
+/*
+ * Write a buffer to a file on the data device.  There must not be sparse holes
+ * or unwritten extents.
+ */
+int
+libxfs_file_write(
+	struct xfs_inode	*ip,
+	void			*buf,
+	off_t			pos,
+	size_t			len)
+{
+	struct xfs_bmbt_irec	map;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buf		*bp;
+	xfs_fileoff_t		bno = XFS_B_TO_FSBT(mp, pos);
+	xfs_fileoff_t		end_bno = XFS_B_TO_FSB(mp, pos + len);
+	unsigned int		block_off = pos % mp->m_sb.sb_blocksize;
+	size_t			count;
+	size_t			bcount;
+	int			nmap;
+	int			error = 0;
+
+	/* Write up to 1MB at a time. */
+	while (bno < end_bno) {
+		xfs_filblks_t	maplen;
+
+		maplen = min(end_bno - bno, XFS_B_TO_FSBT(mp, 1048576));
+		nmap = 1;
+		error = libxfs_bmapi_read(ip, bno, maplen, &map, &nmap, 0);
+		if (error)
+			return error;
+		if (nmap != 1)
+			return -ENOSPC;
+
+		if (map.br_startblock == HOLESTARTBLOCK ||
+		    map.br_state == XFS_EXT_UNWRITTEN)
+			return -EINVAL;
+
+		error = libxfs_buf_get(mp->m_dev,
+				XFS_FSB_TO_DADDR(mp, map.br_startblock),
+				XFS_FSB_TO_BB(mp, map.br_blockcount),
+				&bp);
+		if (error)
+			break;
+		bp->b_ops = NULL;
+
+		if (block_off > 0)
+			memset((char *)bp->b_addr, 0, block_off);
+		count = min(len, XFS_FSB_TO_B(mp, map.br_blockcount));
+		memmove(bp->b_addr, buf + block_off, count);
+		bcount = BBTOB(bp->b_length);
+		if (count < bcount)
+			memset((char *)bp->b_addr + block_off + count, 0,
+					bcount - (block_off + count));
+
+		libxfs_buf_mark_dirty(bp);
+		libxfs_buf_relse(bp);
+
+		buf += count;
+		len -= count;
+		bno += map.br_blockcount;
+		block_off = 0;
+	}
+
+	return error;
+}
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 0764064e043e97..6946c22ff14d2a 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -16,7 +16,7 @@ static char *getstr(char **pp);
 static void fail(char *msg, int i);
 static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
-static char *newregfile(char **pp, int *len);
+static int newregfile(char **pp, char **fname);
 static void rtinit(xfs_mount_t *mp);
 static long filesize(int fd);
 static int slashes_are_spaces;
@@ -261,88 +261,120 @@ writesymlink(
 }
 
 static void
-writefile(
-	struct xfs_trans	*tp,
+writefile_range(
 	struct xfs_inode	*ip,
-	char			*buf,
-	int			len)
+	const char		*fname,
+	int			fd,
+	off_t			pos,
+	uint64_t		len)
 {
-	struct xfs_bmbt_irec	map;
-	struct xfs_mount	*mp;
-	struct xfs_buf		*bp;
-	xfs_daddr_t		d;
-	xfs_extlen_t		nb;
-	int			nmap;
+	static char		buf[131072];
 	int			error;
 
-	mp = ip->i_mount;
-	if (len > 0) {
-		int	bcount;
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		fprintf(stderr,
+ _("%s: creating realtime files from proto file not supported.\n"),
+				progname);
+		exit(1);
+	}
 
-		nb = XFS_B_TO_FSB(mp, len);
-		nmap = 1;
-		error = -libxfs_bmapi_write(tp, ip, 0, nb, 0, nb, &map, &nmap);
-		if (error == ENOSYS && XFS_IS_REALTIME_INODE(ip)) {
-			fprintf(stderr,
-	_("%s: creating realtime files from proto file not supported.\n"),
-					progname);
+	while (len > 0) {
+		ssize_t		read_len;
+
+		read_len = pread(fd, buf, min(len, sizeof(buf)), pos);
+		if (read_len < 0) {
+			fprintf(stderr, _("%s: read failed on %s: %s\n"),
+					progname, fname, strerror(errno));
 			exit(1);
 		}
-		if (error) {
+
+		error = -libxfs_alloc_file_space(ip, pos, read_len, 0);
+		if (error)
 			fail(_("error allocating space for a file"), error);
+
+		error = -libxfs_file_write(ip, buf, pos, read_len);
+		if (error)
+			fail(_("error writing file"), error);
+
+		pos += read_len;
+		len -= read_len;
+	}
+}
+
+static void
+writefile(
+	struct xfs_inode	*ip,
+	const char		*fname,
+	int			fd)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct stat		statbuf;
+	off_t			data_pos;
+	off_t			eof = 0;
+	int			error;
+
+	/* do not try to read from non-regular files */
+	error = fstat(fd, &statbuf);
+	if (error < 0)
+		fail(_("unable to stat file to copyin"), errno);
+
+	if (!S_ISREG(statbuf.st_mode))
+		return;
+
+	data_pos = lseek(fd, 0, SEEK_DATA);
+	while (data_pos >= 0) {
+		off_t		hole_pos;
+
+		hole_pos = lseek(fd, data_pos, SEEK_HOLE);
+		if (hole_pos < 0) {
+			/* save error, break */
+			data_pos = hole_pos;
+			break;
 		}
-		if (nmap != 1) {
-			fprintf(stderr,
-				_("%s: cannot allocate space for file\n"),
-				progname);
-			exit(1);
-		}
-		d = XFS_FSB_TO_DADDR(mp, map.br_startblock);
-		error = -libxfs_trans_get_buf(NULL, mp->m_dev, d,
-				nb << mp->m_blkbb_log, 0, &bp);
-		if (error) {
-			fprintf(stderr,
-				_("%s: cannot allocate buffer for file\n"),
-				progname);
-			exit(1);
+		if (hole_pos <= data_pos) {
+			/* shouldn't happen??? */
+			break;
 		}
-		memmove(bp->b_addr, buf, len);
-		bcount = BBTOB(bp->b_length);
-		if (len < bcount)
-			memset((char *)bp->b_addr + len, 0, bcount - len);
-		libxfs_buf_mark_dirty(bp);
-		libxfs_buf_relse(bp);
+
+		writefile_range(ip, fname, fd, data_pos, hole_pos - data_pos);
+		eof = hole_pos;
+
+		data_pos = lseek(fd, hole_pos, SEEK_DATA);
 	}
-	ip->i_disk_size = len;
+	if (data_pos < 0 && errno != ENXIO)
+		fail(_("error finding file data to import"), errno);
+
+	/* extend EOF only after writing all the file data */
+	error = -libxfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange, 0, 0,
+			false, &tp);
+	if (error)
+		fail(_("error creating isize transaction"), error);
+
+	libxfs_trans_ijoin(tp, ip, 0);
+	ip->i_disk_size = eof;
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("error committing isize transaction"), error);
 }
 
-static char *
+static int
 newregfile(
 	char		**pp,
-	int		*len)
+	char		**fname)
 {
-	char		*buf;
 	int		fd;
-	char		*fname;
-	long		size;
+	off_t		size;
 
-	fname = getstr(pp);
-	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
+	*fname = getstr(pp);
+	if ((fd = open(*fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
-			progname, fname, strerror(errno));
+			progname, *fname, strerror(errno));
 		exit(1);
 	}
-	if ((*len = (int)size)) {
-		buf = malloc(size);
-		if (read(fd, buf, size) < size) {
-			fprintf(stderr, _("%s: read failed on %s: %s\n"),
-				progname, fname, strerror(errno));
-			exit(1);
-		}
-	} else
-		buf = NULL;
-	close(fd);
-	return buf;
+
+	return fd;
 }
 
 static void
@@ -552,7 +584,8 @@ parseproto(
 	int		fmt;
 	int		i;
 	xfs_inode_t	*ip;
-	int		len;
+	int		fd = -1;
+	off_t		len;
 	long long	llen;
 	int		majdev;
 	int		mindev;
@@ -563,6 +596,7 @@ parseproto(
 	int		isroot = 0;
 	struct cred	creds;
 	char		*value;
+	char		*fname = NULL;
 	struct xfs_name	xname;
 	struct xfs_parent_args *ppargs = NULL;
 
@@ -636,16 +670,13 @@ parseproto(
 	flags = XFS_ILOG_CORE;
 	switch (fmt) {
 	case IF_REGULAR:
-		buf = newregfile(pp, &len);
-		tp = getres(mp, XFS_B_TO_FSB(mp, len));
+		fd = newregfile(pp, &fname);
+		tp = getres(mp, 0);
 		ppargs = newpptr(mp);
 		error = creatproto(&tp, pip, mode | S_IFREG, 0, &creds, fsxp,
 				&ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
-		writefile(tp, ip, buf, len);
-		if (buf)
-			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_REG_FILE;
 		newdirent(mp, tp, pip, &xname, ip, ppargs);
@@ -800,6 +831,10 @@ parseproto(
 	}
 
 	libxfs_parent_finish(mp, ppargs);
+	if (fmt == IF_REGULAR) {
+		writefile(ip, fname, fd);
+		close(fd);
+	}
 	libxfs_irele(ip);
 }
 
@@ -950,7 +985,7 @@ rtinit(
 	rtfreesp_init(mp);
 }
 
-static long
+static off_t
 filesize(
 	int		fd)
 {
@@ -958,5 +993,5 @@ filesize(
 
 	if (fstat(fd, &stb) < 0)
 		return -1;
-	return (long)stb.st_size;
+	return stb.st_size;
 }

