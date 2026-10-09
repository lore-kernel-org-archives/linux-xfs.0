Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C33635C6B8
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589883; cv=none; b=g2SNkWnGNlI4F5S0hVJtbQvTcsFqX1yjzHL+JLrsGVdSrWHijhkPoNp7HdVOvqZL6GMCnZDKdjvcVgXL5gpZnH4+/jDbEVZnf2J8LYtMnk3pQAAWxbmRBd/2OMdvLnrFIXuCeHao1fdJ5XAkWV4rn/hbFBCLDOVAUiN+wcZ2fNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589883; c=relaxed/simple;
	bh=wJMUC9ueQ7PF4MN+jdKddrtpBAp82k75a109NsvkrAU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G/VpxWPbRr4q9mWryOVFlTtKTcjsxviMkXAvYBH+CWw/o2Yw5XdDZcXiBkhqg80PA+cRMOV1YaedfUb++LpYepFN0kH8KAyBdGJxDUApPblS4oAJnNNsB04Mi2M0oiR1bZnY4xFIAnASDO7ejr+KkgwnLYmF/zwWNznFAh/RtDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MPGzq3og; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MPGzq3og"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1236F1F000FF;
	Fri,  9 Oct 2026 23:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589882;
	bh=vw25foLtkPldgMniB+TYojZjU/ON9dl5ZB+swDrF5Vw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=MPGzq3ogRKKkDauMAEIwoLjKh6PxxqhYQwhEHlTflvH4tqjZLaktEZ/sm3onkeemO
	 GyT0OpO+UJv02cPB3AQKJD7MoqfrxDD6gcSf54y02QS9SjFk9eNTQTkDhezsrv+YdW
	 PMmWe0dNTZf3BEtX3hw5xLIDufSC+EagaIxdS1yaRB1tcqkbQ00EbEUav4UGysxJCx
	 +saOX11WVrSZ9LCK012eQke6sc3FX/Z1HTNr5JowAWc6t68qP6sxVY+hmo0IDx68EV
	 GtHyX02ykJukWASNhGKFnZmb59zWay8+CzaOGiGKgU2qBjXzGyjgXc55ILum+tVcLj
	 StY2dAEGoc/8A==
Date: Fri, 09 Oct 2026 16:51:21 -0700
Subject: [PATCH 22/26] xfs: fix under-reservation of blocks when repairing sf
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, dgc@kernel.org, floss@jetm.me,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179158947771.3719791.14262224484340384897.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 4d3c07591534517c633945c8d8e6526f10e3fabc

Whilst running QA on XFS for-next as of 7.3-rc2 with MKFS_OPTIONS="-n
size=8192", I observed the following (trimmed) dmesg splat:

XFS: Assertion failed: args->total >= dp->i_nblocks - nblks, file: fs/xfs/libxfs/xfs_da_btree.c, line: 2387
WARNING: fs/xfs/xfs_message.c:104 at assfail+0x46/0x4a [xfs], CPU#0: xfs_scrub/1426511
CPU: 0 UID: 0 PID: 1426511 Comm: xfs_scrub Tainted: G        W           7.3.0-rc2-djwx #rc2 PREEMPT(lazy)  6e418570b606a39783b0e7e7b30dc407b965f9e8
Tainted: [W]=WARN
RIP: 0010:assfail+0x46/0x4a [xfs]
RSP: 0018:ffffc900010d7890 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000ffffffd1
RDX: 0000000000000000 RSI: 0000000000000021 RDI: ffffffffa059fd38
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000a R11: 000000007fffffff R12: ffffc900010d7940
R13: ffff888368d8f980 R14: ffffc900010d7a48 R15: ffffc900010d78d0
FS:  00007f445c5ce680(0000) GS:ffff8884a97ea000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f443803b9a8 CR3: 0000000107a4b000 CR4: 00000000003506f0
Call Trace:
<TASK>
xfs_da_grow_inode_int+0x2e0/0x300 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
xfs_dir2_grow_inode+0x6e/0x150 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
xfs_dir2_sf_to_block+0x149/0x870 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
xrep_dir_swap_prep+0xe2/0x110 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
xrep_dir_swap+0xfb/0x2f0 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
xrep_dir_rebuild_tree+0x99/0x100 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
xrep_directory+0x83/0x1c0 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
xrep_attempt+0x4f/0x1e0 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
xfs_scrub_metadata+0x393/0x5b0 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
xfs_ioc_scrubv_metadata+0x306/0x570 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
xfs_file_ioctl+0xa4f/0x1150 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
__x64_sys_ioctl+0x76/0xc0
do_syscall_64+0x7a/0x3b0
entry_SYSCALL_64_after_hwframe+0x4b/0x53

This is a consequence of commit 0fe77e57588b98, which added the
following assertion to xfs_da_grow_inode_int:

ASSERT(args->total >= dp->i_nblocks - nblks);

Tracing this back to xrep_dir_swap_prep, I noticed that the xfs_da_args
object that's passed to xfs_dir2_sf_to_block sets args->total to 1.
This is incorrect because mkfs set the directory block size to 8k and
the filesystem block size to 4k.  In other words, args->total should be
2 here, not 1.

Dave Chinner tripped over the same problem with the same branch through
a different channel -- his test setup set the fs block size to 1k, in
which case the directory block size is still set to 4k.  Here,
args->total should be 4.

Changing the assignment of args->total to sc->mp->m_dir_geo->fsbcount
makes the assertion go away, but that isn't a complete fix.  In
xrep_tempexch_estimate, we also incorrectly assume that a shortform
conversion requires 1 fsblock when it should be m_dir_geo->fsbcount.
Without that, we can under-reserve space in the transaction and cause a
filesystem shutdown.

Note that the xfs_dabuf_nfsb helper will compute the correct value for
directories and xattr, so we use that instead of open-coding the logic.
Also fix xrep_xattr_swap_prep to assign args->total via xfs_dabuf_nfsb
to avoid one logic bomb if we ever support multi-fsblock attrs.

Cc: floss@jetm.me
Reported-by: dgc@kernel.org
Fixes: 629fdaf5f5b1b7 ("xfs: use atomic extent swapping to fix user file fork data")
Tripped-by: 0fe77e57588b98 ("xfs: assert the reservation covers each da fork growth")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_da_btree.h |    2 ++
 libxfs/xfs_da_btree.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index afcf2d3c7a21c0..a718b1ceb0aab7 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -244,4 +244,6 @@ xfs_failaddr_t xfs_da3_node_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern struct kmem_cache	*xfs_da_state_cache;
 
+int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork);
+
 #endif	/* __XFS_DA_BTREE_H__ */
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index bd13879f29ca1e..7f59c10a7c597e 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -128,7 +128,7 @@ xfs_da_state_reset(
 	state->mp = state->args->dp->i_mount;
 }
 
-static inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
+inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
 {
 	if (whichfork == XFS_DATA_FORK)
 		return mp->m_dir_geo->fsbcount;

