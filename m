Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0579C52F6E
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708782811; cv=none; b=PHl0bx/TOkVws6FF7ZM20zQCrWVc+UEod0bssCRQ0lvLZB3EvP7QBnt6r+N5aLSowhReKqIyFZysFIO7gVimJiFQhjp+tLyMnGf6Z1eZneOU+bjvAiOcrsI3mSmsT3Ny5tKwt4Mn6JLO/ZTn7v64OERdSH25aKDBPB4JRaIA3lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708782811; c=relaxed/simple;
	bh=+C2QW/f0RI+8Ygnvj/1ns6kexgt5mz3fEZ9jYLuct24=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JZ+WPYC0nu4k3WfwdhP0VAuiZlIVup/au+dGy63T2sfxZ2HuSKUTGKtNgR44ujRH5mXc8NCc6uA+1FBDvM1j+qSP7F24GkPJ6ZBGhW8N0Zu4mcKh8ctkwhVNxEfPjfPweDWNRz3gEDBG4LD4dHmadYfJG0C6jgg78TIWifZTxHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QRESwJby; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QRESwJby"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708782808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LxCxkx8l5yBZAVu2gvV0cjhc3YekJfohK1yANvznAjs=;
	b=QRESwJbyP+miss2loec0KjAl5QsJNBFdOpteW4uXGVzcdIm12aY/XS66CQQ/zNLLZIOy/I
	aOlHjd+4h7t1XlrKB2jUtZhg6fwi+B77O/XIE5baysYaGb1DM5CPtsY2A2SPEp8tJpBcep
	uDKxFEm/ZrJURewL2JVNVNexGYzscmo=
From: chengming.zhou@linux.dev
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	vbabka@suse.cz,
	roman.gushchin@linux.dev,
	Xiongwei.Song@windriver.com,
	chengming.zhou@linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH] xfs: remove SLAB_MEM_SPREAD flag usage
Date: Sat, 24 Feb 2024 13:53:23 +0000
Message-Id: <20240224135323.830509-1-chengming.zhou@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Chengming Zhou <zhouchengming@bytedance.com>

The SLAB_MEM_SPREAD flag is already a no-op as of 6.8-rc1, remove
its usage so we can delete it from slab. No functional change.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 fs/xfs/xfs_super.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 56006b877a5d..171a1287b296 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2042,8 +2042,7 @@ xfs_init_caches(void)
 
 	xfs_buf_cache = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
 					 SLAB_HWCACHE_ALIGN |
-					 SLAB_RECLAIM_ACCOUNT |
-					 SLAB_MEM_SPREAD,
+					 SLAB_RECLAIM_ACCOUNT,
 					 NULL);
 	if (!xfs_buf_cache)
 		goto out;
@@ -2108,14 +2107,14 @@ xfs_init_caches(void)
 					   sizeof(struct xfs_inode), 0,
 					   (SLAB_HWCACHE_ALIGN |
 					    SLAB_RECLAIM_ACCOUNT |
-					    SLAB_MEM_SPREAD | SLAB_ACCOUNT),
+					    SLAB_ACCOUNT),
 					   xfs_fs_inode_init_once);
 	if (!xfs_inode_cache)
 		goto out_destroy_efi_cache;
 
 	xfs_ili_cache = kmem_cache_create("xfs_ili",
 					 sizeof(struct xfs_inode_log_item), 0,
-					 SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+					 SLAB_RECLAIM_ACCOUNT,
 					 NULL);
 	if (!xfs_ili_cache)
 		goto out_destroy_inode_cache;
-- 
2.40.1

