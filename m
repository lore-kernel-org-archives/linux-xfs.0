Received: from mout-y-209.mailbox.org (mout-y-209.mailbox.org [91.198.250.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185092DCBE3;
	Sun, 24 May 2026 06:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.198.250.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779604731; cv=none; b=n+0oSJugBkiP21N8jU2bJlz6faP2z+M0rYr+V3FbDhkINt3WWf5hiVN6BBOqZhZGOBo9iKzACkUzsc3bQhqNUfLk74dc1Fwh4ynbeAGBqTbC6+wFFJseJwzp1/qucHZWluEd0q3VygkKi0DlPxNiznfC9/iKdJYm8GQ1HaN0J+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779604731; c=relaxed/simple;
	bh=X3qqqYKWKVPETbgVP2MBjVk40V6OGMm3QTCsNf10ET8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oOua0PmgjvaL/iNg/kl9otNAvNV8j5sZofv5W6laItSkbR4QfmyxVbOrysIGPemcEY6QcpPhV/FmIGfPtmKtDvvkNLWl7kzK/5qXlFr5y9agzmz5bHdFjATSKq4kqsOnEg2ypc+8Mg1BRgnRXq6sboc6M5exgIgZfaKjuPXFW/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=Z9wGvBwZ; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=UX0VzkoC; arc=none smtp.client-ip=91.198.250.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="Z9wGvBwZ";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="UX0VzkoC"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-y-209.mailbox.org (Postfix) with ESMTPS id 4gNTqh2fMrzB19s;
	Sun, 24 May 2026 08:38:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1779604720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ueaMCONefLS/M3tkr8PKm897ROtAHuNqDqbIoo9sEOQ=;
	b=Z9wGvBwZvJuAc6QBUHsCvj6QOyKGMI+8/MK7BKggvr104gG7+8xztUFw5vDr4SvdaFBsvT
	y/L1vB5zeeACcyqrSvtAa9QwiIt7KbeZFOpQtgKw8uoCLcmUp3htfCX2+VDAR4zm6KKlSE
	qtwdb5+UFK5XxBEQ8PbIlPHfL0StB8l6Ic7Ck2GHQWVHnmSiL/fNR6UuHcyArZiht6ywE2
	lbw61OzJq/bvRYbcEKg6BSF0Kokb2GsCZHcTdFIrB+WYBYVf4yOGlJfNEAIblWt6ltD/PU
	EQeUeFrs68oTnRDsnxHsB4IcFrC2e0YGCI+SpQtGk11zEYIN3NYQ29XbukNSrQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=UX0VzkoC;
	spf=pass (outgoing_mbo_mout: domain of a0yami@mailbox.org designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=a0yami@mailbox.org
From: Qing Ming <a0yami@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1779604718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ueaMCONefLS/M3tkr8PKm897ROtAHuNqDqbIoo9sEOQ=;
	b=UX0VzkoCgarUknbTOIVDv02IsV7GhLQKPvgqwSWrJC6JLC4Ai669MazfKQVMz8/Rxfk1nC
	Mp2M9MZMTDbjSCJj0mv3bwWp6UPIRl1z0W6DxaHR9XFgWI/iPkERh9FxR+IWn4XJg9QIy/
	NvMByRRFRN8pbsA8I93q7nrq5GODSiB7juQDymJ1n1/XkYN2z2MYFQaoiyfbCpawomMrkW
	xiqeTG86EB02zdB0UOvqMNJ8pUCtvnJE9ewKyzjVS7X8SoRNvSMIyg5uAt5iy35nhybrGG
	bkhvQCJGUfXn31sxxLZrEux89+F5i+2uKCcQiAn0xJBxdovHYzy1qRVxLaWLEw==
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qing Ming <a0yami@mailbox.org>
Subject: [PATCH] xfs: remove file privileges after XFS_IOC_SWAPEXT
Date: Sun, 24 May 2026 14:38:20 +0800
Message-ID: <20260524063820.45459-1-a0yami@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: ayk8ki6z9nmt77z49pw8dofwi5nhhq5y
X-MBO-RS-ID: 3367bf80eb3d33f2d5a
X-Rspamd-Queue-Id: 4gNTqh2fMrzB19s

XFS_IOC_SWAPEXT exchanges the data forks of two regular files. This
changes file contents and therefore needs the same privilege stripping
that ordinary write paths apply.

The legacy ioctl currently completes the exchange without removing
SUID/SGID bits or file capabilities. As a result, a privileged inode can
retain those attributes after its data fork has been replaced.

Pass the file objects into xfs_swap_extents() and call file_remove_privs()
for both files after the exchange commits, before dropping the outer
inode and mapping locks. This matches the XFS_IOC_EXCHANGE_RANGE finish
path.

Signed-off-by: Qing Ming <a0yami@mailbox.org>
---
 fs/xfs/xfs_bmap_util.c | 18 ++++++++++++++++--
 fs/xfs/xfs_bmap_util.h |  3 ++-
 fs/xfs/xfs_ioctl.c     |  2 +-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0ab00615f..ced81309b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1505,10 +1505,12 @@ xfs_swap_change_owner(
 
 int
 xfs_swap_extents(
-	struct xfs_inode	*ip,	/* target inode */
-	struct xfs_inode	*tip,	/* tmp inode */
+	struct file		*file,
+	struct file		*tmp_file,
 	struct xfs_swapext	*sxp)
 {
+	struct xfs_inode	*ip = XFS_I(file_inode(file));
+	struct xfs_inode	*tip = XFS_I(file_inode(tmp_file));
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	struct xfs_bstat	*sbp = &sxp->sx_stat;
@@ -1727,10 +1729,22 @@ xfs_swap_extents(
 		xfs_trans_set_sync(tp);
 
 	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_unlock_ilock;
 
 	trace_xfs_swap_extent_after(ip, 0);
 	trace_xfs_swap_extent_after(tip, 1);
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(tip, XFS_ILOCK_EXCL);
+
+	error = file_remove_privs(file);
+	if (error)
+		goto out_unlock;
+	if (file_inode(file) != file_inode(tmp_file))
+		error = file_remove_privs(tmp_file);
+	goto out_unlock;
+
 out_unlock_ilock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(tip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index c477b3361..a6043d1aa 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -8,6 +8,7 @@
 
 /* Kernel only BMAP related definitions and functions */
 
+struct file;
 struct xfs_bmbt_irec;
 struct xfs_extent_free_item;
 struct xfs_ifork;
@@ -68,7 +69,7 @@ int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip);
 int	xfs_free_eofblocks(struct xfs_inode *ip);
 
-int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
+int	xfs_swap_extents(struct file *file, struct file *tmp_file,
 			 struct xfs_swapext *sx);
 
 xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 46e234863..ea1047d6a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -990,7 +990,7 @@ xfs_ioc_swapext(
 	if (xfs_is_shutdown(ip->i_mount))
 		return -EIO;
 
-	return xfs_swap_extents(ip, tip, sxp);
+	return xfs_swap_extents(fd_file(f), fd_file(tmp), sxp);
 }
 
 static int
-- 
2.53.0

