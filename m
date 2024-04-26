Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E305438DE8
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168564; cv=none; b=sJPdpOvIo2EzNCg/ODacDrtE1UuPdL8GQMl7dLdS9awOjV3rPEVDSsQu09xvppPzkzW7wI9EDvgucSMpMVI7fcRH9Zv6dq6L0+KQ/rrSd48shSG/vq6yMKVIbylRH1ttCne0ayRQCiattTPovfoatFDbdr0dg4EWAn9QFna4cF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168564; c=relaxed/simple;
	bh=i8IsRUlgnLu13aDmR4B/+ZCHKCTqPEvoTxJGMA1rKWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+bM+SG8zNAAqQ7pcZlXbEzNKjydXLML4+hcF70TVqNj0BQuUl5N3DyT+HgoBsIc9JJ8rmHakD61NjJwbhTHiTgw2ARC89ESdRSGqtN+NQPZfr0WbIzA/gu8UsBPwHst7TOCj82SkE2lK7WNg6VztWYySjTqYYXnQvLk3fSsdhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X30syMXM; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X30syMXM"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e3ca4fe4cfso20198145ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168562; x=1714773362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FLKtpsrnk0K3LTK1AqAbvKTAf5YdKNbZ1P7dlKwCa0U=;
        b=X30syMXMa7vfDV849N27cYpGt3FG0aWl3/x7oaXIYtLRWGfVYOEBzZXdsBcgn4xnoY
         xUB9vyG3Y934PmMBAS3dd7q9HMN2h755W89Q7KTf8vzucaH/bE9jTmep01l7hi9S4UnU
         58dmA4sFwzUySgWQ+VTXsRl3C+8xyY0It8Mp5WbCuoEyZZI8SjUuEkaaW0pdJCTEpggK
         IthDMOD2Ctm6apmQ8jnlHSnGouAwgbDe5UXddDtXuWuO5mZltD+cVcYBD79YOrm+skHX
         IDRVasbD+by8El3T2MvD3qkj7l1VqxDmrhE3lM+LBxB793T7nfXoOfbdjW15M01X/3Rf
         +4Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168562; x=1714773362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FLKtpsrnk0K3LTK1AqAbvKTAf5YdKNbZ1P7dlKwCa0U=;
        b=qr8037qQDRAl8XJfa5IbJedpgyPnTm5UKi36Dd7si7PStojURgVlFujKf0rQ1Wdoba
         2LtAAcZ7bYVjknRjCaMW7BPqMlTShYb6ikDQ2azUPQkEGbofg+nlkQGATeYhNzp5t89y
         dXB4mIHYcdnnC5WbiZML3C27F1LNKu96Nv8oZofhc1/mBMbmec7e870wG+urnhvzRmMv
         X8N8zHx4TyPJQ9sWIu1P2XNr/TwVJ14qlh+lXQ0EhPAwZqFY87Dl1VBQtP0WE7985xu/
         pef8uUJAo8O9kdhboHBJD0b3QoXXpldTXPsf2RP37W2Csvy9X6cx7RGvL4lfPt4zyX+k
         6eTw==
X-Gm-Message-State: AOJu0YxLq03zVPEIBsfhgdau7K3Xl/GOfatLq8WsFxKUyP5zSwqqBNB9
	BtGuyUZQuo2PhuQ8whXO5pvcban3kiwmhEIRdAQe5ujxEVsVtYFm2C8hmbb0
X-Google-Smtp-Source: AGHT+IGpJpO2xK2ekJ+gFCSECEhOH7EMvNGXQWpMBu852oUK2g7r+6ldUWCxnINGHIFQdHAoTl4ezQ==
X-Received: by 2002:a17:903:18e:b0:1e6:766c:6a26 with SMTP id z14-20020a170903018e00b001e6766c6a26mr5168155plg.12.1714168561980;
        Fri, 26 Apr 2024 14:56:01 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:56:01 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 13/24] xfs: fix incorrect i_nlink caused by inode racing
Date: Fri, 26 Apr 2024 14:55:00 -0700
Message-ID: <20240426215512.2673806-14-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
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
2.44.0.769.g3c40516874-goog

