Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36044 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbfCHAe0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Mar 2019 19:34:26 -0500
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] xfs: Zero initialize highstale and lowstale in xfs_dir2_leafn_add
Date: Thu,  7 Mar 2019 17:34:13 -0700
Message-Id: <20190308003413.25068-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, Nathan Chancellor <natechancellor@gmail.com>

When building with -Wsometimes-uninitialized, Clang warns:

fs/xfs/libxfs/xfs_dir2_node.c:481:6: warning: variable 'lowstale' is
used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]
fs/xfs/libxfs/xfs_dir2_node.c:481:6: warning: variable 'highstale' is
used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]

While it isn't technically wrong, it isn't a problem in practice because
highstale and lowstale are only initialized in xfs_dir2_leafn_add when
compact is not zero then they are passed to xfs_dir3_leaf_find_entry,
where they are initialized before use when compact is zero. Regardless,
it's better not to be passing around uninitialized stack memory so zero
initialize these variables, which silences this warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/393
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 3b03703c5c3d..de46f26c5292 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -444,6 +444,8 @@ xfs_dir2_leafn_add(
 
 	dp = args->dp;
 	leaf = bp->b_addr;
+	highstale = 0;
+	lowstale = 0;
 	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
-- 
2.21.0
