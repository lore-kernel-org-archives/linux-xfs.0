Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA733281503;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791423571; cv=none; b=s2oOclijHorSvGmxVbBrkU/5EuXDdrfEKzHpTBbS3iD8amO/CncTyFmgqfiJeaZ1+EhH0x4SOcW1Px8RaqjVusdVtUXmaCQ2IVOrHc7qU5kZqFEe2lws8KsreA2KZ70RCbDvYTzEMnbtB34rvstogOkIql3IljscMxl7WWord5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791423571; c=relaxed/simple;
	bh=jY9oZ8Z9S4otJIqmVjdCr8YUgrPXD/jsfoPnxmuuZc8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KbJew4Jqqb3t9tQX8wJzpFVFcYCLet+zcCqRIkDmZDTX2kg3KViJJr9AWaLD80YuZMjkSyV+Lgtr0OwI7JaQY1U6Ap8WZDkgDD4obDGG6NS+D5z2B1ZN44D//Mog0M9jUMb5B5q4r31C/UYFk7E95+jzUhxkhbEJI3RdYgI6MGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NsEZxWJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsEZxWJg"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4843AC2BCFB;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791423571;
	bh=jY9oZ8Z9S4otJIqmVjdCr8YUgrPXD/jsfoPnxmuuZc8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NsEZxWJgzTBzVq7UZj4E6zIsFcplLjtEdND0OR+un6zoYLELu2ai+yw+oh1rWGcOr
	 NnnigSdLl0e2iM3dyFLuc19NRzHEckmMuI+L9dXXOTQ8wuEUfgbloEbFOqSG9/OLAg
	 yblbil+I9uYNGrYZNeMaXzDCQgXdtzyiUF0KfXdmK22j8q+V8Qfz3w75LKljXDrKzX
	 wMxyt7pnXUQ11wooOWtxZZyJIEOqfAHZs2sNuCZwHKjIVlklDK0owL04gUH3rg7qMy
	 vkT+6ouPVuIvgaqolFN/D9NPwNR07bKFXrNV3lw4iKnRfgFpGsLv10pBpk6TC13Jxl
	 FuoezVgwSkRaw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1C2CA6004;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 08 Oct 2026 10:39:32 +0900
Subject: [PATCH 3/8] xfs: clamp the pNFS layout range to the maximum file
 size
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-xfs-nfsd-map-blocks-v1-3-560026cdccb6@samsung.com>
References: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
In-Reply-To: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
To: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, 
 Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Christian Brauner <brauner@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791423569; l=3068;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=z/BxmcsRnxQN10z0yMKgWHuxZ++6a94ROtN8flqGz9A=;
 b=bFDOXblLmZ9OptOC5Ru+mWQZfDv95mZ5+SPFE2/8bktgafS7vWWrwbhd2h46AFf0r+a8rHJxk
 V6m2VoNaJ6BBAX4wv+353lf300TPyY3FW374GWviADN6bcB4f2gG+xQ
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_map_blocks() checks the range of a layout with

	if (offset > limit)
		goto out_unlock;
	if (offset > limit - length)
		length = limit - offset;

limit - length is computed in u64, so a length larger than the limit
wraps and the length is not clamped. nfsd passes the LAYOUTGET range
through, and RFC 8881 lets a client ask for NFS4_UINT64_MAX bytes, for
the rest of the file. offset + length then wraps to offset - 1, end_fsb
rounds back to offset_fsb, and xfs_bmapi_read() maps nothing. For a read
layout, xfs_bmbt_to_iomap() then gets an uninitialized imap: with a
zeroed stack it logs "Access to block zero", marks the data fork sick
and fails with -EFSCORRUPTED, and otherwise the mapping is whatever was
on the stack and can reach the client. For a write layout,
xfs_iomap_write_direct() is called with a count of zero, which trips an
ASSERT with XFS_DEBUG. An offset of 2^63 or more, which nfsd accepts
too, becomes negative in the loff_t argument and passes the first check.

Reject a negative offset and an offset at the limit, and compare the
length with what is left up to the limit, which cannot wrap once the
offset is below it.

With pynfs as the client, a READ LAYOUTGET for NFS4_UINT64_MAX bytes at
offset 0 got NFS4ERR_IO, as did an RW one, which also made nfsd warn
about the non-standard errno -63, and a READ LAYOUTGET at offset 2^63
got NFS4ERR_IO as well. With this patch and the previous one, the one at
2^63 gets NFS4ERR_INVAL, the RW one gets NFS4ERR_NOSPC before anything
is allocated, as the range up to the maximum file size cannot be
reserved, and the server logs nothing. The READ one gets NFS4ERR_INVAL
as well: nfsd, which maps a layout one extent at a time since
commit cc6c40e09d7b ("NFSD/blocklayout: Support multiple extents per
LAYOUTGET"), asks again from the maximum file size on. An RW one on a
file whose first 64 KiB are allocated, with a loga_maxcount that has
room for one extent, is granted 0+65536.

This depends on the previous patch. Without it, an RW LAYOUTGET to the
end of the file, whose length is now clamped instead of wrapping, asks
xfs_iomap_write_direct() for every block up to the maximum file size,
which wraps the block reservation and shuts the filesystem down where it
got NFS4ERR_IO before.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/xfs/xfs_pnfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index ab38561700..88d9c3c043 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -167,9 +167,9 @@ xfs_fs_map_blocks(
 	if (!write)
 		limit = max(limit, round_up(i_size_read(inode),
 				     inode->i_sb->s_blocksize));
-	if (offset > limit)
+	if (offset < 0 || offset >= limit)
 		goto out_unlock;
-	if (offset > limit - length)
+	if (length > limit - offset)
 		length = limit - offset;
 
 	error = filemap_write_and_wait(inode->i_mapping);

-- 
2.43.0


