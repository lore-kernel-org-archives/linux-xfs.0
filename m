Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298B5C2C6;
	Tue, 26 Nov 2024 01:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584487; cv=none; b=TKHxhcKhHf/CbTanYd85PAHjDGjD1i2nNk0PVoBemCklPYqge8wPKhjDAEh+Z3p9VayBFUGFSyoHpFj9ZxuS5O2Eyv6Eid4N0Ixx8U2GO58E6h4Bs8drwjNv4N0D8VDSvrVfr6Q/ze+AFqHK0SIELbwYblM/zTfiRyn3yDfpuhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584487; c=relaxed/simple;
	bh=c7PzyRcLjLqL1PLXx/V6AmTTP88j/FVN/S8Y2Gt4J5o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qv7+xOGHuVNUoI5l5SJ47oYQeKRHYtbCgKME5mOkUbCYrD+giE3SmH4fuqjBaGNSJ6sEyv/4rPAs2vrYagtOjAVtFOKSS4YqIkf7I+soPtNJrXztXbQmlLgeaOkXqD882mrurWZYYNnhMowYsBkWV0zu4nUEeu4cdixaDZlVPTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PhqfGRvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PhqfGRvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F55C4CECE;
	Tue, 26 Nov 2024 01:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584486;
	bh=c7PzyRcLjLqL1PLXx/V6AmTTP88j/FVN/S8Y2Gt4J5o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PhqfGRvSsyGkCjFFWZds13BSu7x4FwneBmC1d6eFk4q07Yf2I6D+hqrz29kfzYAjE
	 UVW4CF3ImykzOZHg5mTXTtbEaiqa11Tsu0NaW+61Kxi2zwDfmnNF21/WZcS5paLnFl
	 A7IzcM5UtqoOqw+yv7KQjnzhi3gnqS3CT4F2vJDjFdNgaWS7dYQGQg9Q7nM+LcNQAq
	 9aNHJdHnJ8hM8M5F1NY+G8Evpkcz7Yz8u/7wJO9zXd7e1FfBHY5/3BmrqZHjRQhHyx
	 VpOrRf9dvfmETnqSRlBMjBPVClJm4ytrPGKkcayS0ExqJ13nFnFcdkqeXUYwD+OlZh
	 Y/nmcyHXvIIow==
Date: Mon, 25 Nov 2024 17:28:06 -0800
Subject: [PATCH 13/21] xfs: unlock inodes when erroring out of
 xfs_trans_alloc_dir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258398025.4032920.17639399507003367709.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Debugging a filesystem patch with generic/475 caused the system to hang
after observing the following sequences in dmesg:

 XFS (dm-0): metadata I/O error in "xfs_imap_to_bp+0x61/0xe0 [xfs]" at daddr 0x491520 len 32 error 5
 XFS (dm-0): metadata I/O error in "xfs_btree_read_buf_block+0xba/0x160 [xfs]" at daddr 0x3445608 len 8 error 5
 XFS (dm-0): metadata I/O error in "xfs_imap_to_bp+0x61/0xe0 [xfs]" at daddr 0x138e1c0 len 32 error 5
 XFS (dm-0): log I/O error -5
 XFS (dm-0): Metadata I/O Error (0x1) detected at xfs_trans_read_buf_map+0x1ea/0x4b0 [xfs] (fs/xfs/xfs_trans_buf.c:311).  Shutting down filesystem.
 XFS (dm-0): Please unmount the filesystem and rectify the problem(s)
 XFS (dm-0): Internal error dqp->q_ino.reserved < dqp->q_ino.count at line 869 of file fs/xfs/xfs_trans_dquot.c.  Caller xfs_trans_dqresv+0x236/0x440 [xfs]
 XFS (dm-0): Corruption detected. Unmount and run xfs_repair
 XFS (dm-0): Unmounting Filesystem be6bcbcc-9921-4deb-8d16-7cc94e335fa7

The system is stuck in unmount trying to lock a couple of inodes so that
they can be purged.  The dquot corruption notice above is a clue to what
happened -- a link() call tried to set up a transaction to link a child
into a directory.  Quota reservation for the transaction failed after IO
errors shut down the filesystem, but then we forgot to unlock the inodes
on our way out.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: bd5562111d5839 ("xfs: Hold inode locks in xfs_trans_alloc_dir")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 30fbed27cf05cc..05b18e30368e4b 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1435,5 +1435,8 @@ xfs_trans_alloc_dir(
 
 out_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (dp != ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }

