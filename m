Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E6D8F5C;
	Mon,  1 Apr 2024 16:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990167; cv=none; b=PN04zNVvBEVxTORizjk5WUZuYe+XyaSe0A+z8l4edx3j3lV7zibFNPOl6SfLr8BZaE95suUxzqqQYnD++8rLYnCETtIsHc7Bggr7eqB8Te8UIzN9C86NYKVupTCqrNQAvD1+K1zfiAD6AuHjSah0xD+M538fdVcTYH2sfK/Wb0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990167; c=relaxed/simple;
	bh=oHL5zqz/cUjwzCnrKeY4BGDtGiJXonOo1seeczz7kFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHS8nohxN0jh+uD5TBcBYimUcP1foHrLIjVtiV51kYdRWCnxbX09xhPtM4SCqW+budEz2ch5ZHufCPLtFI9SkdBoy3Ne/UtVta2e+q3vmqu6spGr9vn+sA3qqXakLzvJv473kPXp9UkTrDXJCN3EbZQLli/8UHkFaKMzGOWSbtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOO4fp4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOO4fp4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D062C433F1;
	Mon,  1 Apr 2024 16:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990166;
	bh=oHL5zqz/cUjwzCnrKeY4BGDtGiJXonOo1seeczz7kFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOO4fp4kP/9xzk/En8sIrQ6saIzN8pHBo7HNq3Ez5NYhKSIkRJ7+pmhNFm5eGtsQx
	 3d9aa2p4nJ6ymYI5XC40ezjnjeAvzd1ZYWDBJQY7vKV2/y6GJywIQHj3zCXeIY53iw
	 OZ9Klv4xyQVvgM/AB08Mec5MkgDpnELAcqIG9mLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 266/396] xfs: fix an off-by-one error in xreap_agextent_binval
Date: Mon,  1 Apr 2024 17:45:15 +0200
Message-ID: <20240401152555.835362842@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit c0e37f07d2bd3c1ee3fb5a650da7d8673557ed16 upstream.

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
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -247,7 +247,7 @@ xreap_agextent_binval(
 		max_fsbs = min_t(xfs_agblock_t, agbno_next - bno,
 				xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX));
 
-		for (fsbcount = 1; fsbcount < max_fsbs; fsbcount++) {
+		for (fsbcount = 1; fsbcount <= max_fsbs; fsbcount++) {
 			struct xfs_buf	*bp = NULL;
 			xfs_daddr_t	daddr;
 			int		error;


