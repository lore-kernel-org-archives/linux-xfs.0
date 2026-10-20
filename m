Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465728;
	b=UuTtyDjml0ZH7nUR0Q0ZpXBrdQDNwvZn1Zl4Gjvozes/tUL6O2NAK4MDV3UjLsI3iZzY
	 7ShzXuKmY8n7YyYmeu1CpQg5ZQN1kRrtxQUpVN+xZ62rBZ2Wrx9/6n1JVspx7fu9L3lbE
	 eWaZAmiSMn1F+uQgXTGUmD8IdBTguxbhr/9MnW5x7mnk1QQ+JOLRlgn65HLNBMUvEKfrU
	 ytbUXsXCyDdP6vZ/tGzpaWS1FJ2G9iq/4pZ/0PRqCDMNJ4RxFqsaQtaXmYuWxs51/QgFZ
	 bLq9hzi/vRNQGkRxpBg+t77ebKF38u9oz58zwFgPmf6YvBosz4jndXIurQ9cYarbjIA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465728;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=z4fsJMhMCRNvkmS03W2b42RQped56DTAtvUpJEnLScs=;
	b=i3VX2c2qpA1AAtO3QLGqE44kt6jlx7Gfzd0VJcHbe42IsRv8f76PrAbNUyk+8UPlvEF6
	 ZeicD3RDK9nK+lpyFZqLe2iuFO8rn0E1D3vzUx5TrQQsmQ2GuivPSchrNx87JGRgrw62y
	 Hsh/ULeBP4eK8vP9qyVlWXjjPXkuZ+FD9sfQKp0eZPbjNccASlXKLPYkoD6ZgLxpz6g99
	 MbOhG1JOwlTtvcCMPlqA2GpRMNaIDqR56wWmXC8wQIaDJJOFFP+bTE6BJpxtlghcocWhu
	 ORy63tRrq3DQeplfrS0Zbc6kuxOXUy+uAzjApbbIQ7f7XEYnoGmEZPmI1OqrVtIk0/w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PCeAJAHP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A84606A331;
	Tue, 20 Oct 2026 03:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PCeAJAHP
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465727;
	b=Y3n3HU1k/9I5qZHYoFNZ+vO4PRGHl4UhbLmv2FbGtWSPdesJ/sh/m8KGFRMmSyxw2FVy
	 O14LdEAhw5Blark5D+3eKiPFNW3wEQc8zn8OEbtQQqXeEygqqWe+Jv/OB4/7qwDL1Z494
	 qCIhQvRbKpzOJT4dseVUsV4O2/HGSNUWvtc5C1YQLdZj7NlKxcY1PVK0ekM2CY8RgjWHX
	 V/J42TMxSOijhi9okga/X60M3A8hPWl0zze8VPOjyTUvVyyN4A7L37hnondav7sga5rgO
	 yI8fgSqEGZ6U5J8NgnaDke0Y8tNJHC1jgZBSNHhxW4P5gp9HLPK3jA+/fNo/NZTX12g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465727;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=z4fsJMhMCRNvkmS03W2b42RQped56DTAtvUpJEnLScs=;
	b=mBrjdI1WUEAPbpLO7Yu5/uZ3AWZfAloCDpWRZyRO/8WzLW/oA1zq8F+9i6ifz2HAaBsp
	 7KvS1ZrJ87yNhm5yjaXYO5KlBLvR0d5q/p5hFIJJKa79nbT7rGVxrOtfFJo2O2rRU/kvz
	 VNBJKAIHnLCfO2Zy+9Fl3H71SqEsVvb8SHoWDIZefaGzD9pgDa1DNXbF2V1msr30B9C6e
	 zzAMWZr6lOJJ+zfadxvVCSv4IFLNCavdBLVcArvZ32v4Y3ofNysg3/Xm9VDIYBAM8LzYr
	 3JGINC2adr8Gx5guxo+l3aXu4upv6FpuE1BUEicaXIwy6FfukRU3xgnXOxn7XZ0S4/Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7CA691F000C4;
	Tue, 20 Oct 2026 03:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465727;
	bh=z4fsJMhMCRNvkmS03W2b42RQped56DTAtvUpJEnLScs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=PCeAJAHPM3cce6WeYN10CbHJKymPS6L4DncpqukDl2B1M3rIHgymEH/bEvQaypCsn
	 8HIIoNMXOlON/6exuZ4blKXfbmbiX1MZ1rVBSPkPXQk+RTWaLbpgXBq2KY0/AnSUlG
	 atixw6vV8YJ0zgjGdNUpDTEZlLzkBqqVHzm0TYN2lUqANKH/O8KUFq/LjNgaMC1ObB
	 KtMjFSoU/5esBDRwze/VNlctqPl9hzqtUiEYk12IX4QTs8HauPAk6gKvR5BCH0cffN
	 GwKggrNcIfCiKe+teBJSni8ahzgzun27MexoAqnp6rzWH20qJBUl+0f/lB/LjLkrEU
	 Fwk2xmb9yguJg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E5E1B40738;
	Tue, 20 Oct 2026 03:08:44 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 20 Oct 2026 12:08:46 +0900
Subject: [PATCH v4 3/9] xfs: refuse a pNFS LAYOUTCOMMIT of a range without
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
Message-Id: <20261020-xfs-pnfs-batch-v4-3-9230fa2ca4a4@samsung.com>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
In-Reply-To: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465723; l=6738;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=TS0BpT+iyPj0zrwPOS+USB60F2J2/oQCnoflsIQ4Vk0=;
 b=Hkx/e4cS0sGKldcK/QBgKt9Sx0ZoLuaSLsF//OSB1vRdwFsSaqUJEI2ivhOLoFUMYFgzabO6E
 VIpltQ0OuHgAZw9xd8b7Yjad3vSMp1c2OsETY54QBDT+pQxboHrI8ja
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_commit_blocks() passes every range that a pNFS client commits to
xfs_iomap_write_unwritten(), whatever is mapped there, and the range can
be a hole. nfsd does not check the extents of a block or SCSI layout
LAYOUTCOMMIT against the layouts it handed out, and for a reclaim during
the grace period it has no layouts to check against, so a client can
commit a range that it never had a layout for.

For a hole, xfs_bmapi_write() with XFS_BMAPI_CONVERT allocates new
blocks as written extents, while the transaction only reserved blocks
for bmbt splits. A hole larger than that reservation shuts XFS down:

  XFS (nvme0n1): Corruption of in-memory data (0x8) detected at
    xfs_trans_mod_sb+0x817/0x960 (fs/xfs/xfs_trans.c:351).
    Shutting down filesystem.

A smaller hole gets blocks that nobody wrote mapped into the file as
data, so readers see whatever those blocks held, and the LAYOUTCOMMIT
succeeds.

With pynfs as the client and an RW layout for the first 64 KiB of a
2 MiB sparse file, a LAYOUTCOMMIT of 64 KiB at offset 1 MiB, which no
layout covered, got NFS4ERR_IO and shut XFS down. A LAYOUTCOMMIT of
4 KiB at 1 MiB got NFS4_OK, and the file got a written block there. The
client wrote nothing to the device in either case.

A client may only write to blocks that a layout handed out, and
xfs_fs_map_blocks() allocates blocks for any hole in a write layout, so
a committed range without blocks holds nothing that can be committed.
Pass XFS_BMAPI_CONVERT_ONLY from xfs_fs_commit_blocks() through
xfs_iomap_write_unwritten(), and fail with -EIO when xfs_bmapi_write()
finds a hole or a delalloc extent. Each xfs_bmapi_write() call finds the
extent and converts it in one transaction under the ILOCK, so nothing
can change it between the check and the conversion. -EIO is what
xfs_pnfs_validate_isize() returns when the new size falls into a hole.

xfs_iomap_write_unwritten() commits the transaction instead of
cancelling it when it fails this way, as xfs_alloc_file_space() does
after -ENOSR. xfs_iext_count_extend() logs the inode when it moves the
inode to large extent counters, which happens when the data fork of an
inode without large extent counts nears 2^31 extents on a filesystem
that supports them, and cancelling a dirty transaction shuts the
filesystem down.

Ranges before the hole have been converted by the time the commit
fails, as they would have been had the client committed them in a
LAYOUTCOMMIT of their own. Later ranges are left alone, and the
timestamps and the size are not updated.

With this, both LAYOUTCOMMITs get NFS4ERR_IO, XFS keeps running and no
block is allocated.

Link: https://lore.kernel.org/r/20261014130834.GB15773@lst.de
Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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


