Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1B5328270
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 16:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762965319; cv=none; b=s6VTTYt5poHWhDE8J3UntqkAvlsYxTp0mTOQYAw1U1+ovuWNQQiYsLCMbstoHjn92MUFLI5Er9wd5RSxIx8OlIqTTAlydHaJT6NGHpCsnzykv81ebnfD4vlBp9vkAnJH/C269asGRop3N5+ExVXDGseyFo0l5QrwR/O+qpOsbZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762965319; c=relaxed/simple;
	bh=AtzpFXBDxD2TfNxdZ8k1vuYaqTQ4cJOPC6E+XW+12wM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sfIGfKu8YC88n845ewl9ZGwYgUukEuBzkNvcKOllqRxH28S8ekEwBAvtPTLgPMHDVMw3oAWOz2avZTzSNd/Wmat6LNPZUzuXohjstN2+EW+/zWh6GIBMKku7Cngjymkrj0Kg6dP7JlJSm6e14ZhqQjoRZiHX1LEZ1exJWY88mus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D9Gc4LWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D9Gc4LWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF29C4CEF5;
	Wed, 12 Nov 2025 16:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762965319;
	bh=AtzpFXBDxD2TfNxdZ8k1vuYaqTQ4cJOPC6E+XW+12wM=;
	h=Date:From:To:Cc:Subject:From;
	b=D9Gc4LWYuZSbDckGz7/CfuPbmrAGpYjSzQ2v3cKCa5eXNGUFZD5F8m2hlyaX3grch
	 KGPDTVlCVD5ZhYzkot2jJPSeK3NHH4Q8gNilbQGtLyyFyq7omE4JCFLOge+fBEfFIl
	 rtBSMmqarUaxBEcKwGXUOwKdzQsylehfTjhvu3XHd9Np+Tj0aNKeF+HnaoTfVzEt8K
	 VrrsqxLm/qZjbe591itHCi4NvU45TLCZKoPe4VPLPSI5UEw4SXOFProtTQhiY5BWYE
	 trpymLRx6uGjli/OStgquiMJLwkttJrR6MK7WolqdeRVArOF0gts4mC3x7FUA4DmdL
	 w4u5cFZnn4c3Q==
Date: Wed, 12 Nov 2025 08:35:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix out of bounds memory read error in symlink repair
Message-ID: <20251112163518.GY196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

xfs/286 produced this report on my test fleet:

 ==================================================================
 BUG: KFENCE: out-of-bounds read in memcpy_orig+0x54/0x110

 Out-of-bounds read at 0xffff88843fe9e038 (184B right of kfence-#184):
  memcpy_orig+0x54/0x110
  xrep_symlink_salvage_inline+0xb3/0xf0 [xfs]
  xrep_symlink_salvage+0x100/0x110 [xfs]
  xrep_symlink+0x2e/0x80 [xfs]
  xrep_attempt+0x61/0x1f0 [xfs]
  xfs_scrub_metadata+0x34f/0x5c0 [xfs]
  xfs_ioc_scrubv_metadata+0x387/0x560 [xfs]
  xfs_file_ioctl+0xe23/0x10e0 [xfs]
  __x64_sys_ioctl+0x76/0xc0
  do_syscall_64+0x4e/0x1e0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

 kfence-#184: 0xffff88843fe9df80-0xffff88843fe9dfea, size=107, cache=kmalloc-128

 allocated by task 3470 on cpu 1 at 263329.131592s (192823.508886s ago):
  xfs_init_local_fork+0x79/0xe0 [xfs]
  xfs_iformat_local+0xa4/0x170 [xfs]
  xfs_iformat_data_fork+0x148/0x180 [xfs]
  xfs_inode_from_disk+0x2cd/0x480 [xfs]
  xfs_iget+0x450/0xd60 [xfs]
  xfs_bulkstat_one_int+0x6b/0x510 [xfs]
  xfs_bulkstat_iwalk+0x1e/0x30 [xfs]
  xfs_iwalk_ag_recs+0xdf/0x150 [xfs]
  xfs_iwalk_run_callbacks+0xb9/0x190 [xfs]
  xfs_iwalk_ag+0x1dc/0x2f0 [xfs]
  xfs_iwalk_args.constprop.0+0x6a/0x120 [xfs]
  xfs_iwalk+0xa4/0xd0 [xfs]
  xfs_bulkstat+0xfa/0x170 [xfs]
  xfs_ioc_fsbulkstat.isra.0+0x13a/0x230 [xfs]
  xfs_file_ioctl+0xbf2/0x10e0 [xfs]
  __x64_sys_ioctl+0x76/0xc0
  do_syscall_64+0x4e/0x1e0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

 CPU: 1 UID: 0 PID: 1300113 Comm: xfs_scrub Not tainted 6.18.0-rc4-djwx #rc4 PREEMPT(lazy)  3d744dd94e92690f00a04398d2bd8631dcef1954
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-4.module+el8.8.0+21164+ed375313 04/01/2014
 ==================================================================

On further analysis, I realized that the second parameter to min() is
not correct.  xfs_ifork::if_bytes is the size of the xfs_ifork::if_data
buffer.  if_bytes can be smaller than the data fork size because:

(a) the forkoff code tries to keep the data area as large as possible
(b) for symbolic links, if_bytes is the ondisk file size + 1
(c) forkoff is always a multiple of 8.

Case in point: for a single-byte symlink target, forkoff will be
8 but the buffer will only be 2 bytes long.

In other words, the logic here is wrong and we walk off the end of the
incore buffer.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 2651923d8d8db0 ("xfs: online repair of symbolic links")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/symlink_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index 5902398185a898..df629892462fe1 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -184,7 +184,7 @@ xrep_symlink_salvage_inline(
 	    sc->ip->i_disk_size == 1 && old_target[0] == '?')
 		return 0;
 
-	nr = min(XFS_SYMLINK_MAXLEN, xfs_inode_data_fork_size(ip));
+	nr = min(XFS_SYMLINK_MAXLEN, ifp->if_bytes);
 	memcpy(target_buf, ifp->if_data, nr);
 	return nr;
 }
