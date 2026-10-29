Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275859;
	b=oyG2faKuVrbRnZRBE4Mt1oAdMJO6H3gHVbD+XYTmV/y4uDTQLAU42TN7TOHvjEt9FuiI
	 nnUvWHz0yrtHnaFbmMvMHs7wgJZfdnxBhOQfMC7A4EMA+LXL88ElwJM1xrPLp/9ucvhmd
	 ZGe1WRH5hUUTxkz3BV1FV4DU6KctqcTby3+YRh5tLz6WZlnlxdXsFusRnSwi9CyougsBp
	 9MczKARzBVk7U0YNBOn9Ajb03ZXgaMOj/Hr25dV5RfX3v/l70aE6oyV3fL19+bZmmgTyG
	 N/+R0AfIOGRHmgzT/stEp4vqXZI/CcFJm56Uj6mXPmFj+QsB7NI8iHVk5NhN/kww4zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=s82WjKRF+U0A8m0v6U0PSlK3QdtjH2IRNEGwkawRUH8=;
	b=a+11IMPH/WIE4FDnFDsazEYvMbb/9CTsvEVzkWsM2d11cRD9hQV4mtXNtnhNLtK10dA6
	 JosVoijz6YPl3NgXlnYK8HXHrcFhxMGPqz7VkPLmV3CK8iL3rkvhnd8EzQ3ko7iZ70R15
	 JVSGietym9n7TIOy38hzPYFM+MXoLHxEsAzSkiMw1cTpGI56UOkOl/k5eWRPDgGza82Y+
	 gsIwJOJ5W2ydtT4squwPFLlIQGNYyJL5MjROsWdH2ozrjxtfIOZrcw4I2uyZ/3hY9Dsyw
	 dxRckwBjXFx5zxXSo4mRnP7K2K3p+7yDlKqjEjZTB6aWGtFZGXYX74BOW80wT8WGFJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TfofKY+z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DF5606A31D
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TfofKY+z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272271F01828;
	Thu, 29 Oct 2026 12:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275858;
	bh=s82WjKRF+U0A8m0v6U0PSlK3QdtjH2IRNEGwkawRUH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfofKY+z52DS1OLHtZRa+zbBf9jT10Vw+cVynZ8GPyG5SqrK1GTNYNKxOW9XcOwnx
	 MgpD59/R2a5d+8pGwbHri1s7kI7UJlJfUUoBIAjPfDe2gtsLFAFdR73pKuT+Iqjaa9
	 DCdryYkms44csb2/thktAAhc0nBCXHk0XWWJ4qr7v1ymxY7oQ9dJoJSbVLKfeO7m37
	 yE972SipQioUX/9H/tyIvYvsfAaQP59PpEdW3C5tk+Kfbw1nkWWABwMp+gfx4AV08R
	 aiiwt6zrZ4dzC+8eLZaXPVftgpn7LJNbLjnW/b+4P6zYNgVcITEb1Vn8Uefim7VwMW
	 nVTM2yBNBAXYA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 22/28] xfs: fix under-reservation of blocks when repairing sf directories
Date: Thu, 29 Oct 2026 13:06:19 +0100
Message-ID: <20261029120631.803074-23-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

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
 libxfs/xfs_da_btree.c | 2 +-
 libxfs/xfs_da_btree.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 8cbdd6574755..3d02a0d7ba44 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -130,7 +130,7 @@ xfs_da_state_reset(
 	state->mp = state->args->dp->i_mount;
 }
 
-static inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
+inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
 {
 	if (whichfork == XFS_DATA_FORK)
 		return mp->m_dir_geo->fsbcount;
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index afcf2d3c7a21..a718b1ceb0aa 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -244,4 +244,6 @@ xfs_failaddr_t xfs_da3_node_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern struct kmem_cache	*xfs_da_state_cache;
 
+int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork);
+
 #endif	/* __XFS_DA_BTREE_H__ */
-- 
2.54.0

