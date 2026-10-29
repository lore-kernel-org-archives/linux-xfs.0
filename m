Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793240582;
	b=RJTIlNrvhgCBpBhTHKbOZ6XJcll+CKS7EmOy4AU5gABzJGJPGy3pjn6VlIqAicw0guyc
	 ajjYSaV+/eJOxZUMHBlr8EPCml/jOehWRkYBFyx5En+cumG7/k7VCd/fVfzMvU8tuYL7h
	 5A31IEWECTjy9ljjecwBcxcHTZNFFZDWhMZU4x6L4vZszWPzag9fx6hDrVwoHqdiWWmUm
	 u4AMetrNzZdCXErUsOJ213OGnNapKbc437B9gx5pRFMdICGgJQD+a5gGVjdZiol0NBpK8
	 1USLCTiW5XMyel6h1x+o6HCqiYxG5uPTYyMa7P5zsRTGNaF9wrq2UAPNxPZdknx1c+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240582;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=CB3KmtfAX1J8Xsyo0jCvf395wsYSppG6ixqV19DGLMg=;
	b=K2THoVNEKvQj36Axk6bKSIzoNpuFHPg+idOz6A40XrQ3LlWvkMq1zRfVjhcMmhOjkJjb
	 C9GDX4elX72Ji8IVHz+gyWSmyaO3AHVFQGUVERMspTTPtkTOi8YiHUXakDAXu5Nj7/3C8
	 PhuIElYGtdRb/2BRFBZ6RoYjIbeXbEnC6nSgG2ICX2bdyl33N0MwpjvPzrnL2QseAJyCh
	 CrU8mUyZ9vxvrAfU1Trzg0E7ue2Uv9a5fhKn5bsRQrxse5eRMSx4BVr0HkBLVfs+oKMsx
	 fnFurVQuSxExOndaafHQeaklWSa2I73Jx8G2bgIAtn+mW5TEHk8kJ/Wkptc14/8f11Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h+CLy3XD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C451260A2600;
	Thu, 29 Oct 2026 02:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h+CLy3XD
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793240581;
	b=cH4JavDVRdzwhX99nwQN3usQZ/ero3juDdJw48bdAA1tA8uXyJirGtKWASBNJwS2QElI
	 +bignKvWbjcmPvahn4vsfQCYqRTbwRKKM/o8L/E9sEg5UECsb7czYdN/sJ9JGUYIEHLfL
	 C9G2rFKcKFUnHaOH0M8vGXpcFosuX2LiwwrfbvmYbLCcKhLDvzLekHDVnrwOdXNuKWIek
	 hVl03qOENvwNAaJzWuZiv7AxDEOH0+FSgFe1FfrAYysOTdhN6x/0488498qbMXvhjqJP2
	 KUF5GLOppD8ueJLkMZ/Xcs4dYvfSKnaHO8GAe8mtlma604IyoY3LwjMG3DaKE7AXXIQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793240581;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=CB3KmtfAX1J8Xsyo0jCvf395wsYSppG6ixqV19DGLMg=;
	b=b7DHPR3XJP3oedpIMcZJb5DSiIel+wwSh/XmTUepO1fQik3ugSUiYAEoKLygMJmwmUL+
	 wayawliZ6IGw+73lMHrXQeSU7zxfm5e24VfNuzJXRu02s5XU1wu8uvIhEBxWMmXvz8VQk
	 Mh8BoPNRnjVrQFe9q1aRpQDVNiQn9hAW8JK4n880tqc9C5137DMj/3ZzkH5sLnAnT/54/
	 N9cdeoUj+Z2AI6y3VVohSHUb7WLrwERhMj9ogmEXXNylA5iujp1FWi519wuayFM5NK/gN
	 53QOrXulszQvPqUHSHzXZg9wO362H/yKDYqv24eAm5etmmAybiJhHOjSyR747uaei2Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5769A1F031E4;
	Thu, 29 Oct 2026 02:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793240581;
	bh=CB3KmtfAX1J8Xsyo0jCvf395wsYSppG6ixqV19DGLMg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=h+CLy3XDZRIY/GU/rlJC8fg5o6AsiEAXmXbNHWhiPnsv86X41jDubs9SkHFRkuYoC
	 EaW7Y2Z4RTS/VJQDFId4CGYMvYjWqSBpHAtzQefH4xCfQtodi0xdOBIItAGbEYp/E6
	 ff8KSQuL2XaBRDM5vrxqjC+4zdPwS0fplqUBy0B0Qo3SZ7KOT1cUR5Hfq9zI6BVwYw
	 hKe9TjqxkPdkgGF0ZZTuZ56oqPBdzXd9pbKRp20Q7GqEujZOoyb0FBjS5u6HPF5TFQ
	 LdbeMlngZFu+LETWvC5QerEYU8uJFCp5vwqQrrJmGmhkWFTXGRxRNoBNvjtDhdg1W8
	 E9TgN90Yf34NA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D06B34568E;
	Thu, 29 Oct 2026 02:22:58 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 29 Oct 2026 11:23:00 +0900
Subject: [PATCH v5 3/9] xfs: refuse a pNFS LAYOUTCOMMIT of a range without
 blocks
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261029-xfs-pnfs-batch-v5-3-ef8d2eafb7fa@samsung.com>
References: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
In-Reply-To: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>, 
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793240577; l=4550;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=q73bMSn/98VB2qO8zqoT8A6x6YaJckKSChsJxjXxqQ0=;
 b=UhVAfIE9WPR18xBe8YRDG0saY/M9Ai2xia06MoOMVT2k9H9eYkatW87o9f89pUJYfzpDPNugZ
 JTOBIRgXpViCIbJW/zkI69huVRh1xR7U268WjZhGczdMMdQJUljy7sq
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

A client can commit a hole in a LAYOUTCOMMIT, because nfsd does not
check the extents against its layouts. xfs_iomap_write_unwritten() then
allocates written blocks there. A large hole overruns the block
reservation and shuts XFS down. A small one exposes stale data.

Refuse such a range with -EIO, using XFS_BMAPI_CONVERT_ONLY.

Link: https://lore.kernel.org/r/20261014130834.GB15773@lst.de
Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
Tested with pynfs: committing a 64 KiB hole shut XFS down, and a 4 KiB
hole got NFS4_OK and a new block. Both now get NFS4ERR_IO, no block.
---
 fs/xfs/xfs_file.c  |  2 +-
 fs/xfs/xfs_ioend.c |  2 +-
 fs/xfs/xfs_iomap.c | 20 +++++++++++++++++---
 fs/xfs/xfs_iomap.h |  3 ++-
 fs/xfs/xfs_pnfs.c  |  9 ++++++++-
 5 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7d0c8a1975..720f4a9b40 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -666,7 +666,7 @@ xfs_dio_write_end_io(
 	 * they are converted.
 	 */
 	if (flags & IOMAP_DIO_UNWRITTEN) {
-		error = xfs_iomap_write_unwritten(ip, offset, size, true);
+		error = xfs_iomap_write_unwritten(ip, offset, size, true, 0);
 		goto out;
 	}
 
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 48becc3bf6..7f4a4a95af 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -237,7 +237,7 @@ xfs_end_ioend_write(
 	if (ioend->io_flags & IOMAP_IOEND_SHARED)
 		error = xfs_reflink_end_cow(ip, offset, size);
 	else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
-		error = xfs_iomap_write_unwritten(ip, offset, size, false);
+		error = xfs_iomap_write_unwritten(ip, offset, size, false, 0);
 
 	if (!error &&
 	    !(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 329c745e31..99d48081c5 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -614,7 +614,8 @@ xfs_iomap_write_unwritten(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	xfs_off_t	count,
-	bool		update_isize)
+	bool		update_isize,
+	uint32_t	bmapi_flags)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb;
@@ -676,8 +677,21 @@ xfs_iomap_write_unwritten(
 		 */
 		nimaps = 1;
 		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-					XFS_BMAPI_CONVERT, resblks, &imap,
-					&nimaps);
+					XFS_BMAPI_CONVERT | bmapi_flags,
+					resblks, &imap, &nimaps);
+		if (error == -ENOSR && (bmapi_flags & XFS_BMAPI_CONVERT_ONLY)) {
+			/*
+			 * Nothing was mapped: the rest of the range starts
+			 * with a hole or a delalloc extent. Nothing was
+			 * changed either, but xfs_iext_count_extend() may
+			 * have logged the inode, and cancelling a dirty
+			 * transaction shuts the filesystem down. Commit it,
+			 * as xfs_alloc_file_space() does on -ENOSR.
+			 */
+			error = xfs_trans_commit(tp);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			return error ? error : -EIO;
+		}
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index f2520a9b3a..8fc0c6fc8b 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -15,7 +15,8 @@ struct xfs_zone_alloc_ctx;
 int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t count_fsb, unsigned int flags,
 		struct xfs_bmbt_irec *imap, u64 *sequence);
-int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
+int xfs_iomap_write_unwritten(struct xfs_inode *ip, xfs_off_t offset,
+		xfs_off_t count, bool update_isize, uint32_t bmapi_flags);
 xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
 		xfs_fileoff_t end_fsb);
 
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index a9f0b472f3..7ff83274a5 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -344,7 +344,14 @@ xfs_fs_commit_blocks(
 					(end - 1) >> PAGE_SHIFT);
 		WARN_ON_ONCE(error);
 
-		error = xfs_iomap_write_unwritten(ip, start, length, false);
+		/*
+		 * A client may only write to blocks that a layout handed out,
+		 * and xfs_fs_map_blocks() allocates blocks for any hole in a
+		 * write layout, so refuse to allocate blocks for a hole or a
+		 * delalloc extent in the committed range.
+		 */
+		error = xfs_iomap_write_unwritten(ip, start, length, false,
+				XFS_BMAPI_CONVERT_ONLY);
 		if (error)
 			goto out_drop_iolock;
 	}

-- 
2.43.0


