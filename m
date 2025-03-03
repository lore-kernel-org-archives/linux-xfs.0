Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7501E32BE
	for <linux-xfs@vger.kernel.org>; Mon,  3 Mar 2025 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741025259; cv=none; b=HWwAn0TT/p8YNm6cqZO6Yl0o/0IQEwOLVR0zd2wJTmtWeGw9b1GYmD2bfIZdnZK4oA01LwQwrqHopyga0XYNLbtvi4SHI30nGWsKzA0OfVUSrK6DZRUQRPXSz7tZYylsK4Efxn1rkwYEdV+IXzPzuHGEv4HKNs86eahKNqIo9BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741025259; c=relaxed/simple;
	bh=n7JJ3Oz8izX3n+ShxXIDOFOeTfANgSQXnEDmZZ56K7E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c6bjlwHhCtZVDd0T28lRmGNRJPNHLGwENXA+6+wBzmjkQRX7+X+En3l2q2klRbgsl6bAI7VNJ6E2PkI7F5pNkTE2rWU1rMTkcnBsqsrES1vWMXkrqUQHx1zrXloPzCa9/BwTe2v2Nhq+CewZryRClbgTdOvJ6b/YID+AtC6FNR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r5fKdfOD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r5fKdfOD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=mndNoCBhVIr8/QwfXGfMmzm33Fl2t22W7oynLRwGb4w=; b=r5fKdfOD/M/VJBDBf+AlQ8RQhu
	TpUFZsbB9hp8BwK3PHrzf7m3OCdqLI8b8hXN88zKEdIuwyRj0DGkIJZmb72/6f6ylZNl1baBBni26
	9ERqgtcruBruIzJPoGA99a/2+0GFn9inmVYU5WuyD3qF/se9jOOv8sWRueFkrL7xN5dWxVeoqQciN
	zb3ZLrb1IOn1AZ6IAZqelCz57JY/pUAAbU8dSD/Per3O5bLeJLu4+BgttvFATxqKaDLgLpIIzNSsE
	+APs4wJl6odIRw8jpFVC+82ndYlWkEur2ce2NbaBDAQ/rfLCDeA8JZiM6rw5Z8kHAbffpzZc+nMLg
	KDU1cESQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tpA7f-0000000DrqE-1x7A;
	Mon, 03 Mar 2025 18:03:47 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Use abs_diff instead of XFS_ABSDIFF
Date: Mon,  3 Mar 2025 18:02:32 +0000
Message-ID: <20250303180234.3305018-1-willy@infradead.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We have a central definition for this function since 2023, used by
a number of different parts of the kernel.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3d33e17f2e5c..7839efe050bf 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -33,8 +33,6 @@ struct kmem_cache	*xfs_extfree_item_cache;
 
 struct workqueue_struct *xfs_alloc_wq;
 
-#define XFS_ABSDIFF(a,b)	(((a) <= (b)) ? ((b) - (a)) : ((a) - (b)))
-
 #define	XFSA_FIXUP_BNO_OK	1
 #define	XFSA_FIXUP_CNT_OK	2
 
@@ -410,8 +408,8 @@ xfs_alloc_compute_diff(
 		if (newbno1 != NULLAGBLOCK && newbno2 != NULLAGBLOCK) {
 			if (newlen1 < newlen2 ||
 			    (newlen1 == newlen2 &&
-			     XFS_ABSDIFF(newbno1, wantbno) >
-			     XFS_ABSDIFF(newbno2, wantbno)))
+			     abs_diff(newbno1, wantbno) >
+			     abs_diff(newbno2, wantbno)))
 				newbno1 = newbno2;
 		} else if (newbno2 != NULLAGBLOCK)
 			newbno1 = newbno2;
@@ -427,7 +425,7 @@ xfs_alloc_compute_diff(
 	} else
 		newbno1 = freeend - wantlen;
 	*newbnop = newbno1;
-	return newbno1 == NULLAGBLOCK ? 0 : XFS_ABSDIFF(newbno1, wantbno);
+	return newbno1 == NULLAGBLOCK ? 0 : abs_diff(newbno1, wantbno);
 }
 
 /*
-- 
2.47.2

