Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39511607B2;
	Wed,  1 May 2024 18:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588891; cv=none; b=A3yU3WZTmC7M7gC4VC8KA4RpKMfjbsiT3JINCzTX4fDi82BKXkQfspLWHCyDO6pAWeNPYW6nIZyfbdX8P6HXO7DgU6J/RKmwHueokEn0Tnzo+1q6GqkcWQZ15llxSbqJJScFIhBgO3GT6sm6ly9gY1QUKNLySyjB14+35jK60x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588891; c=relaxed/simple;
	bh=wmUjWFfxqa3FQhDPEMkDTdz8LnYMIU8B1he5Oi1SaJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPoQgYAhuyGbJJ0hWFul80ZEs3GMnlo3XOVEtQA8MrEibmFj/uO9CVaDYQkp3nx2jX5oqom0t24xBEGDI4Z7vvyljrnwuABLaVZNcUwrsch0/weK6RI+mlg18ig5T2sxbRGXT184SfCsQXU+9eWKTHlIfB3jLPoOCQPrQ4k+eic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oqvu2Jd1; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oqvu2Jd1"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ee13f19e7eso6558391b3a.1;
        Wed, 01 May 2024 11:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588889; x=1715193689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AmJ41Pj8f3/OQaR1H6P0ilNrXYr8K74PNkbaUWhIlx0=;
        b=Oqvu2Jd108uaiXKcghV/lYx4LzZ27cbGg1/p7Hd262Tw9RVIOTmP7Of5sQ2xqKUc4a
         1jfCECrYL4JBXd43FDU1M/PuUcUYxknUYESMUDZOK1tWi5o8d4gz4j/DD5xI9d2xKCm7
         2yqxV8Q+lQ5+xaUy4vnXpu15jUVDkjhZrnSpfJdvu73JEaDB9OYSLGiWHqe+jGY+qI5H
         U1haNaJR6HzgXV9Ho1kxzuyZdpLJhgQV+2XMr7X8mDmb12WJlezCAAKz8dsaikZTxulU
         7FKJlmABDjyTSGCj9pfHYcrFjU5GQ7iTnnHhvK81ivUMFanSJducrcYEMY9Y0mlvTQML
         uA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588889; x=1715193689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AmJ41Pj8f3/OQaR1H6P0ilNrXYr8K74PNkbaUWhIlx0=;
        b=JCXZbPgN+/P9WDpe2vVFOH+mKaeVc9U/tPjX5molGyuAsPFdm2JbqmSgQx1gzD+TJE
         NgB1HJ5kc0tG7JVntGUxZD5JkAC/ZGPXKpels8pqQ8KUetIErUZXjvg1GcXs7R+Ek50O
         p4KMjggMP54Cf8P34RLORIxniztBN9iSxM+ZwKWGYymDi+7PZIcyhnqJpBkuIZNSuTH0
         L03To7Td9N3zjRhNHDJGvkwSgnfn6+nTRIFQHEZ/EDTA03PZQgSH6W3GC1lR+TFNV07R
         5be3XSDUiV7DZazmc0ysNg2aMlMtMIf5RduXckA71hIWzQB7dz0b+vdryRqPwr/RDP3e
         tf9A==
X-Gm-Message-State: AOJu0YyEz5w99M0gNr1dkAGYg46sojusRT9dsMCSAwAS+KljCQpXMhyl
	Z3C4kxeo0L1Jf1hd9EirV5zpQzS2Qw/FhmvvqXQ6lc/mXn7fpZsNJofrf/s6
X-Google-Smtp-Source: AGHT+IFJ1W6sk1081NmswOIJipeh9WDoXFH6akLKv61VqGbm8fXoRDHdoKVuKqOruSoSXn66qO8Cig==
X-Received: by 2002:a05:6a00:1a86:b0:6ed:d5f5:869 with SMTP id e6-20020a056a001a8600b006edd5f50869mr4038960pfv.3.1714588889131;
        Wed, 01 May 2024 11:41:29 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:28 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 13/24] xfs: fix incorrect i_nlink caused by inode racing
Date: Wed,  1 May 2024 11:41:01 -0700
Message-ID: <20240501184112.3799035-13-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 28b4b0596343d19d140da059eee0e5c2b5328731 ]

The following error occurred during the fsstress test:

XFS: Assertion failed: VFS_I(ip)->i_nlink >= 2, file: fs/xfs/xfs_inode.c, line: 2452

The problem was that inode race condition causes incorrect i_nlink to be
written to disk, and then it is read into memory. Consider the following
call graph, inodes that are marked as both XFS_IFLUSHING and
XFS_IRECLAIMABLE, i_nlink will be reset to 1 and then restored to original
value in xfs_reinit_inode(). Therefore, the i_nlink of directory on disk
may be set to 1.

  xfsaild
      xfs_inode_item_push
          xfs_iflush_cluster
              xfs_iflush
                  xfs_inode_to_disk

  xfs_iget
      xfs_iget_cache_hit
          xfs_iget_recycle
              xfs_reinit_inode
                  inode_init_always

xfs_reinit_inode() needs to hold the ILOCK_EXCL as it is changing internal
inode state and can race with other RCU protected inode lookups. On the
read side, xfs_iflush_cluster() grabs the ILOCK_SHARED while under rcu +
ip->i_flags_lock, and so xfs_iflush/xfs_inode_to_disk() are protected from
racing inode updates (during transactions) by that lock.

Fixes: ff7bebeb91f8 ("xfs: refactor the inode recycling code") # goes further back than this
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d884cba1d707..dd5a664c294f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -342,6 +342,9 @@ xfs_iget_recycle(
 
 	trace_xfs_iget_recycle(ip);
 
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
+		return -EAGAIN;
+
 	/*
 	 * We need to make it look like the inode is being reclaimed to prevent
 	 * the actual reclaim workers from stomping over us while we recycle
@@ -355,6 +358,7 @@ xfs_iget_recycle(
 
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	error = xfs_reinit_inode(mp, inode);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (error) {
 		/*
 		 * Re-initializing the inode failed, and we are in deep
@@ -523,6 +527,8 @@ xfs_iget_cache_hit(
 	if (ip->i_flags & XFS_IRECLAIMABLE) {
 		/* Drops i_flags_lock and RCU read lock. */
 		error = xfs_iget_recycle(pag, ip);
+		if (error == -EAGAIN)
+			goto out_skip;
 		if (error)
 			return error;
 	} else {
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

