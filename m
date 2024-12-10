Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E730F78F44
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 12:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733835413; cv=none; b=g3KAWySVOep1FvkI7o9WwaqKrruYnLc2kMGDVwjma/Db3olpo37yE+U3g3z1FIl7kzRzexY6PLEbOMdy3KBrxoeohU0j5GYOK+9bx1KsrY2wiGQizmWQkOTwSXiaXugRHdHto9epy4yp+Pw/xub4BIUdILik4nI0nxbh8TKL6Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733835413; c=relaxed/simple;
	bh=Emtxl6aYjWLsalIPAzUkHycijaWaFPGRdiNXafiYnGI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FbNXMxzH+y0j1SGbYb8lhGHNazU5gtg+rCbl4+TRj8MheFg+u0IdKTxV6o4uzwUQQ60kqN+PGVx+80hU9PQUnXa66YSzOxq8rQ2ZVhj8jkVJZHDeNTvKAa1UzNYVPZqDg+d3ErblXGX2dU/s+bRYMyb/GCS/wnL6/lv1oTv/AHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XnRay6jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XnRay6jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097C4C4CED6;
	Tue, 10 Dec 2024 12:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733835412;
	bh=Emtxl6aYjWLsalIPAzUkHycijaWaFPGRdiNXafiYnGI=;
	h=From:To:Cc:Subject:Date:From;
	b=XnRay6jwvb3qdtI3UxOAA2Zrrm1CIwBXK1ikx4oNg6V2mGkd2UTv8WQf+X1bbtiI6
	 mbTM1yqnTRpt9sbFHw4buZU2vAwK7hv7KJHS2rrDt9QNeqP5uRQtHin0Vn69wmCsBU
	 jxmrkNe3qdYmxBHSS5E1zomehbg+hFSzdzo2RWqL4RRfmmAYcwzRnk0aiJ5XssCQu+
	 ih7+BepO9obPex0Dz31Zj65I8gbVMviYX3+zekwiudeTk1zjjp2aIvCag1xjC5RyOU
	 sYkbNO0PmEdUTLUvPvSUANgOKb8VHJDgGxe0CaFz7qUglEkeYR4s0bg8vgmYC2tETB
	 cCcy7TytrzTuw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@lst.de,
	djwong@kernel.org,
	dchinner@fromorbit.com
Subject: [PATCH] xfs: fix integer overflow in xlog_grant_head_check
Date: Tue, 10 Dec 2024 12:54:39 +0100
Message-ID: <20241210124628.578843-1-cem@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cmaiolino@redhat.com>

I tripped over an integer overflow when using a big journal size.

Essentially I can reliably reproduce it using:

mkfs.xfs -f -lsize=393216b -f -b size=4096 -m crc=1,reflink=1,rmapbt=1, \
-i sparse=1 /dev/vdb2 > /dev/null
mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt
xfs_io -x -c 'shutdown -f' /mnt
umount /mnt
mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt

The last mount command get stuck on the following path:

[<0>] xlog_grant_head_wait+0x5d/0x2a0 [xfs]
[<0>] xlog_grant_head_check+0x112/0x180 [xfs]
[<0>] xfs_log_reserve+0xe3/0x260 [xfs]
[<0>] xfs_trans_reserve+0x179/0x250 [xfs]
[<0>] xfs_trans_alloc+0x101/0x260 [xfs]
[<0>] xfs_sync_sb+0x3f/0x80 [xfs]
[<0>] xfs_qm_mount_quotas+0xe3/0x2f0 [xfs]
[<0>] xfs_mountfs+0x7ad/0xc20 [xfs]
[<0>] xfs_fs_fill_super+0x762/0xa50 [xfs]
[<0>] get_tree_bdev_flags+0x131/0x1d0
[<0>] vfs_get_tree+0x26/0xd0
[<0>] vfs_cmd_create+0x59/0xe0
[<0>] __do_sys_fsconfig+0x4e3/0x6b0
[<0>] do_syscall_64+0x82/0x160
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

By investigating it a bit, I noticed that xlog_grant_head_check (called
from xfs_log_reserve), defines free_bytes as an integer, which in turn
is used to store the value from xlog_grant_space_left().
xlog_grant_space_left() however, does return a uint64_t, and, giving a
big enough journal size, it can overflow the free_bytes in
xlog_grant_head_check(), resulting int the conditional:

else if (free_bytes < *need_bytes) {

in xlog_grant_head_check() to evaluate to true and cause xfsaild to try
to flush the log indefinitely, which seems to be causing xfs to get
stuck in xlog_grant_head_wait() indefinitely.

I'm adding a fixes tag as a suggestion from hch, giving that after the
aforementioned patch, all xlog_grant_space_left() callers should store
the return value on a 64bit type.

Fixes: c1220522ef40 ("xfs: grant heads track byte counts, not LSNs")
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

I'd like to add a caveat here, because I don't properly understand the
journal code/mechanism yet. It does seem to me that it is feasible to
have the reserve grant head to go to a big number and indeed cause the
overflow, but I'm not completely sure that what I'm fixing is a real bug
or if just the symptom of something else (or maybe a bug that triggeded
another overflow bug :)


 fs/xfs/xfs_log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 05daad8a8d34..a799821393b5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -222,7 +222,7 @@ STATIC bool
 xlog_grant_head_wake(
 	struct xlog		*log,
 	struct xlog_grant_head	*head,
-	int			*free_bytes)
+	uint64_t		*free_bytes)
 {
 	struct xlog_ticket	*tic;
 	int			need_bytes;
@@ -302,7 +302,7 @@ xlog_grant_head_check(
 	struct xlog_ticket	*tic,
 	int			*need_bytes)
 {
-	int			free_bytes;
+	uint64_t		free_bytes;
 	int			error = 0;
 
 	ASSERT(!xlog_in_recovery(log));
@@ -1088,7 +1088,7 @@ xfs_log_space_wake(
 	struct xfs_mount	*mp)
 {
 	struct xlog		*log = mp->m_log;
-	int			free_bytes;
+	uint64_t		free_bytes;
 
 	if (xlog_is_shutdown(log))
 		return;
-- 
2.47.1

