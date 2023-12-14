Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1CA6ABB3
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2MkPGy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460F7C433C8;
	Thu, 14 Dec 2023 21:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702589926;
	bh=uO06c7Pyd4MYEy0kKIM3A37kN7ybUrfFWGHP9wB+sbQ=;
	h=Date:From:To:Cc:Subject:From;
	b=a2MkPGy12+nXuwo/nXX7sJwOBt59C9pfPkCzlrrFfQ+WWWuImVKjsJehW+AyMYZM1
	 SvoFKtNcZaRu/4i1YwQkdDY9wOF/jPNKpgGF9k7UVmmVCPkLmzXTqylVw9eetGm2sb
	 lYU2omNY2ly9Np5wghfO1tnMymgOQhd3thY0Y969tA8g5kNySiSXCxfIi4IzmT/Llh
	 4Ugv5lqdb/P2kdiESetUY5zNIRdnSlGraIaC+e8KL6b0c4LLTzTsAJC4V7+P2Diloe
	 gzEKAWSg0ciFvyVauusPx4372DpEmclNMcWmkFk1G3UTvEIkAm6ZchD15weGUNw+YE
	 IOXxCMAbgFOsg==
Date: Thu, 14 Dec 2023 13:38:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix an off-by-one error in xreap_agextent_binval
Message-ID: <20231214213845.GK361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Overall, this function tries to find and invalidate all buffers for a
given extent of space on the data device.  The inner for loop in this
function tries to find all xfs_bufs for a given daddr.  The lengths of
all possible cached buffers range from 1 fsblock to the largest needed
to contain a 64k xattr value (~17fsb).  The scan is capped to avoid
looking at anything buffer going past the given extent.

Unfortunately, the loop continuation test is wrong -- max_fsbs is the
largest size we want to scan, not one past that.  Put another way, this
loop is actually 1-indexed, not 0-indexed.  Therefore, the continuation
test should use <=, not <.

As a result, online repairs of btree blocks fails to stale any buffers
for btrees that are being torn down, which causes later assertions in
the buffer cache when another thread creates a different-sized buffer.
This happens in xfs/709 when allocating an inode cluster buffer:

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 3346128 at fs/xfs/xfs_message.c:104 assfail+0x3a/0x40 [xfs]
 CPU: 0 PID: 3346128 Comm: fsstress Not tainted 6.7.0-rc4-djwx #rc4
 RIP: 0010:assfail+0x3a/0x40 [xfs]
 Call Trace:
  <TASK>
  _xfs_buf_obj_cmp+0x4a/0x50
  xfs_buf_get_map+0x191/0xba0
  xfs_trans_get_buf_map+0x136/0x280
  xfs_ialloc_inode_init+0x186/0x340
  xfs_ialloc_ag_alloc+0x254/0x720
  xfs_dialloc+0x21f/0x870
  xfs_create_tmpfile+0x1a9/0x2f0
  xfs_rename+0x369/0xfd0
  xfs_vn_rename+0xfa/0x170
  vfs_rename+0x5fb/0xc30
  do_renameat2+0x52d/0x6e0
  __x64_sys_renameat2+0x4b/0x60
  do_syscall_64+0x3b/0xe0
  entry_SYSCALL_64_after_hwframe+0x46/0x4e

A later refactoring patch in the online repair series fixed this by
accident, which is why I didn't notice this until I started testing only
the patches that are likely to end up in 6.8.

Fixes: 1c7ce115e521 ("xfs: reap large AG metadata extents when possible")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 9b6c919db522..f99eca799809 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -251,7 +251,7 @@ xreap_agextent_binval(
 		max_fsbs = min_t(xfs_agblock_t, agbno_next - bno,
 				xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX));
 
-		for (fsbcount = 1; fsbcount < max_fsbs; fsbcount++) {
+		for (fsbcount = 1; fsbcount <= max_fsbs; fsbcount++) {
 			struct xfs_buf	*bp = NULL;
 			xfs_daddr_t	daddr;
 			int		error;
