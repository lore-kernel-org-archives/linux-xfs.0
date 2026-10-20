Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465729;
	b=xD6QEo5m895SflAueGuURLIdBd0Mx0IWjwI7Dh1cAOztSuj9ikxGm0CzWeF5YHIXq5qY
	 bqVSnrlIexHKrVhLYZii1i0gXqi5tP4LCL/0yvE8DuOlEsr6MbPI7NOxdvb+XLwCZaoP/
	 f+fT3poXCvK6TDaIPShf3LmkjM0STKLZiTalQlQlgZ65UXt5W4CqGNVeWZUdJ1vwXME7K
	 m0sCY0A9cFJxfWl5se1bkctDIZwzsIMoI9YGFfsmES5wOy3qAp3rrzhvdU3W3yMxLOD+d
	 anYlPxrqNpSG6DHol1IIK59VqZ2InVtNgYW2ktCn0nd4hkpFLct/mfkV9Ik3S7S/3HA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465729;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=kCh3XfT7m9HhPYV+seKPsDleqJt+sSzyOzsYJs7eCSs=;
	b=ICexXY815rN4bgelpINtAB9JHsZNvzLybQIvUcb1l6kvi/Jb4IKBXSaxnuFhlT5CwvBg
	 u1pzoIvqyjGqddHzfakR+5AjZFl2C5fQMEg4ryIjDNqdcHDEK3MfKyzSAkvTUbBorfR+0
	 ZRhupedjZoUt6Ht1IrET4rcszOFYdJ4z5iwfWpEBvf7ROWoQ9cFlwiNNJcW7Ea/WAnvYw
	 1PVdJ1YuPK66E3pIHTFvLUJwkASdIdzuqDYgw8vjkGivW2HhwTz3nBXIJiJqAnGuYR0mj
	 i1DAJTf2qtJ25+I3syDyttkSDasJObNW523i6Rkay/TLFHFvmDPEjGKWVnVgmfMNjzQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O7NAkHli;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A1960A261A;
	Tue, 20 Oct 2026 03:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O7NAkHli
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465729;
	b=SDZF5KgXgzAfVtI/kB/Vu7ezfZtRQ9VbQB7qyuW7i1FOit9mLPAoidrBFBDkMIpxsEr/
	 3tCOcen6Wmf7ssg3vCQeZo0szZOv+8gwuNwPA4uET/Nz2LQVIuOnGD1h0C6UNkkyRrQKs
	 PjxsJJp/EVhFQkt3v9yRDhTyIBr4Qa7c+NS082h5HdCgvJrNB5qHTBX9Xdee+cnUhgpQk
	 dKixr9t/iEvtFhtlRQAm8AieiyhHwUUcopYBZi721BvMt/7hYXWOanwvWSm2HcV7uscCF
	 oU0bDGc1dwJ1ytwgACdS0U39yWGBnqioaGo9amI9a/DiCIUExTFmNPvrRQ0ckPJVqBQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465729;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=kCh3XfT7m9HhPYV+seKPsDleqJt+sSzyOzsYJs7eCSs=;
	b=X9sOYQ+Z+ALotaeoNQKGmIi74Zurp2pjY2NhDresLMMD+X+qbu+Fa8moLde7revy70k5
	 khlGv+AEc1HsRk13QfTEK2bV92cN/ptwTwVTiDdpXp8Bsrmao3NOgi+BggPbF/CzTRk0O
	 H05mnoc2hCtoA14mvKbq/syI1M7+t3X32SmtLbGTohyrqGpCRnp/xVx6JWG7Sk+tSMEm8
	 IhddqzAZo2tO/EV17fGSrelCTBf/sxS0/oMEOQssBT0PVHKutIOnqcNSzn669oZ7pbjPz
	 bRupSqRn5OTMnixIFuTw2IEI7IWLVS4ssYdiNgIlx4nwMWdVPOzfSNQUzXES27cHyNw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9A6391F000CD;
	Tue, 20 Oct 2026 03:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465729;
	bh=kCh3XfT7m9HhPYV+seKPsDleqJt+sSzyOzsYJs7eCSs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=O7NAkHlid8wa6y/G+W/LgLU9G8L6CduDi25IxiXRIG7XaruoI+Ae/2RwhtxUDjQoS
	 OD0Qt+ylwSWwvf3EkrbKS6vF+WRYKx/7RnaAKN435cgRhtHrrZ145FIQZ2WnjTcRC2
	 ZZTcg0w1c5U1xQ84HtQgetvcNEtFddFdBUwSSWwzp1sNZQ28JfqrVR43MFRY0wdnWh
	 HY0IqRb75pjloTDLmUt7GtHQZA7rRUKXFInGPPNRO+zjiodWEs7x0I1R9xdqX6KlSE
	 v4VG5tv9gJBoKpgh23j754EVNSD1puOVliIGjzVlHcb/UsralNcoZKa+EHyZIKQ4BF
	 iCHiJ341M/sjg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 16FF843070;
	Tue, 20 Oct 2026 03:08:45 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 20 Oct 2026 12:08:52 +0900
Subject: [PATCH v4 9/9] xfs: make pNFS LAYOUTCOMMIT stable the way
 fdatasync does
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
Message-Id: <20261020-xfs-pnfs-batch-v4-9-9230fa2ca4a4@samsung.com>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
In-Reply-To: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465723; l=5378;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=ctf4MTuEXVtDU8yk/Y9V6pNK51IH6jYFKZ1i+uMZrGY=;
 b=MheMggnG0UOWXpGkor48CtzPg5gy2OmSbhoskElzbWcAJ2Q79DLfEsa5JzFJ3QEN2IN8NMpbD
 7SIYRKtkcNuAAG8IRktNooPfUa+wTUQB1KQz9fOGmEHHN6aIx/9FuCS
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_commit_blocks() commits the timestamp update of every
LAYOUTCOMMIT as a synchronous transaction, so every LAYOUTCOMMIT forces
the log. When the client only overwrote blocks that were already written
on disk and the size does not change, the only metadata that this log
force makes stable for the file is the new timestamps. fdatasync after
the same overwrite does not force the log: a timestamp-only change does
not set ili_datasync_seq, and without it xfs_file_fsync() only flushes
the cache of the device that holds the file data. The comment above
xfs_fs_commit_blocks() says that it relies on always committing a
transaction, and that it would otherwise have to flush the cache the way
fsync does for a datasync.

Do it the way fdatasync does: log the timestamps as XFS_ILOG_TIMESTAMP
when the size does not change, commit the transaction without
XFS_TRANS_SYNC, force the log up to ili_datasync_seq, and flush the
cache of the device that holds the file data unless that log force wrote
an iclog. The unwritten extent conversions and a new size set
ili_datasync_seq, so a LAYOUTCOMMIT that converts extents or changes the
size still forces the log. So does a conversion that was done earlier,
for example by a direct write on the server: ili_datasync_seq stays set
until that conversion is on disk, so the log force covers it.

With the block layout on an NVMe/TCP namespace in QEMU, backed by a
partition of an NVMe SSD with a volatile write cache, one client process
overwriting a 16 MiB file in 64 KiB writes, each followed by fsync, took
473 ms instead of 800 ms (median of 5 runs). On average a LAYOUTCOMMIT
spent 1.1 ms in xfs_fs_commit_blocks() instead of 2.4 ms, and none wrote
an iclog. With 4 KiB writes to a 4 MiB file it took 1841 ms instead of
3101 ms. A LAYOUTCOMMIT now issues an empty cache flush instead of a log
write with REQ_PREFLUSH and REQ_FUA. The guest that ran nvmet reached
the SSD through virtio-blk, which has no FUA, so there the FUA cost a
second cache flush. The gain should be smaller with native FUA and on a
device without a volatile write cache. It is also smaller with several
writers: 4 threads overwriting 16 MiB files in 64 KiB writes took
1011 ms instead of 1083 ms. LAYOUTCOMMITs of new files force the log as
before.

As with fdatasync, the timestamps of a LAYOUTCOMMIT that converts
nothing and keeps the size, and the change attribute that nfsd derives
from the ctime, reach the disk with a later log write instead of before
the reply, at the latest the one that the log worker issues every 30 s
by default. After a crash in that window, the change attribute can go
back to the value it had before the LAYOUTCOMMIT, while the data the
client wrote is on disk. The Linux client sends LAYOUTCOMMIT from both
fsync() and fdatasync() (pnfs_generic_sync() ignores datasync), so
fsync() on a block layout client now gets the timestamp guarantee of
fdatasync(). RFC 8881 section 12.5.4 says that LAYOUTCOMMIT may require
committing the block list to stable storage, which this keeps, and
section 12.5.4.1 only asks that the updated attributes be visible when
it completes.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_pnfs.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 1e47d0aa6a..2d238a0e5a 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -304,10 +304,12 @@ xfs_pnfs_validate_isize(
  * converting any unwritten extents, flushing the disk cache and updating the
  * time stamps.
  *
- * Note that we rely on the caller to always send us a timestamp update so that
- * we always commit a transaction here.  If that stops being true we will have
- * to manually flush the cache here similar to what the fsync code path does
- * for datasyncs on files that have no dirty metadata.
+ * Like fdatasync, a commit that only updates the timestamps does not force the
+ * log: they are logged as XFS_ILOG_TIMESTAMP and reach the disk with a later
+ * log write. The log is forced up to the last change that a datasync needs,
+ * such as the unwritten extent conversions or a new size, and the cache of the
+ * device holding the file data is flushed if that log force did not write an
+ * iclog itself.
  */
 static int
 xfs_fs_commit_blocks(
@@ -321,6 +323,7 @@ xfs_fs_commit_blocks(
 	struct xfs_trans	*tp;
 	struct timespec64	now;
 	bool			update_isize = false;
+	int			log_flushed = 0;
 	int			error, i;
 	loff_t			size;
 
@@ -377,7 +380,8 @@ xfs_fs_commit_blocks(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	xfs_trans_log_inode(tp, ip,
+			update_isize ? XFS_ILOG_CORE : XFS_ILOG_TIMESTAMP);
 
 	now = inode_set_ctime_current(inode);
 	inode_set_atime_to_ts(inode, now);
@@ -388,8 +392,13 @@ xfs_fs_commit_blocks(
 		ip->i_disk_size = new_size;
 	}
 
-	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_drop_iolock;
+
+	error = xfs_log_force_inode(ip, true, &log_flushed);
+	if (!error && !log_flushed)
+		error = blkdev_issue_flush(xfs_inode_buftarg(ip)->bt_bdev);
 
 out_drop_iolock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);

-- 
2.43.0


