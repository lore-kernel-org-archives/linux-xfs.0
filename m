Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782786;
	b=iZt1AOad4ViUn6dm98ixlBRc3jWiIJmA+3QLya8yTv9vfUqAkHKvRfDWz7GMD8Zm4jnf
	 IN4ti9LdZy1Zc4S9D99VPB3qCaw7nlxfkhVN1ujaUPTcOaZe4fPyGNX7eRlGgutgUo7tQ
	 6jwvf2NNbCJV9EUHw6mkQs8Ncj1NGUXcsccuvrJSdqRF5hh9tWPs9/MK/0F1V03D/k9Wf
	 adTmL/JSbJ8MT0v6v3G+tR6XXZ5/D/MnGCp9I+nFYuz54+bA1TbWa/NIBA23e+SIQakQF
	 3s1inDLFJ7nvHRTZCrBoxkiGHwcTuq2uvOOqVmMs5XeAh+2t0hy+DW3mRxGG9wngRkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782786;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=ad64sEH0yhq//hL1K2MZKUxirnf+ZA6YqqTPjA2sb8k=;
	b=psxAlNNS8fOQBiZpRZlrRnXc/A81SU+PV4Wrz/T3vuVuwMrBKOibkoxB6QmSGhGlcmpR
	 J/CbsPU0bc+AEfIWEmvwrWxwzEqoy8Xj4CIqhoZaadAu3lgzf5cwtN49Eo2plpDVSxKpZ
	 /sUnyAHTqGtgjsCpMSnxP48L2FJs2goPH5Mp1CRaSLL1OXTv2NDS9q/66c4eNxzkZUqEd
	 JbebWn6bfENbAvRZA45sxbaodhwrJZdZtlJQVfe4mhRmgHmlLgJhwiL+PbJ6bCZJLM2TJ
	 QVsKmvaFTnQp/IjPDAVqyz3xyRUaYxpWxs79f0Y2d55WIAEnnp6CuMRmE1JBAf9LEig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rvPiDMIT;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0EF606A329;
	Wed,  4 Nov 2026 08:59:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C0EF606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rvPiDMIT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ad64sEH0yhq//hL1K2MZKUxirnf+ZA6YqqTPjA2sb8k=; b=rvPiDMITsufhsG+pA+jRWEiGHO
	z0cYLZ5vVPi06Zd9HnyBhoPOKd5diexg7KS10s2JtEUcK42vI88S4pa0nmwQJcp4C8ZQo+CQFgrIU
	bPM9ZGcljjvTRHM+BoqnajB+mEgC/56V5o6woOi12kIi6ONgW4Kj0KXcGlnqeEq7b1A2FOTeCIGKg
	NuaOncVz2UdR/FKGFugYRFZcCo0++PoTxlQgk3v8ElXYnK/i8NqPo1owJXybxc6zZHPi/7ScMsHKn
	M9BYCc/VCHxAfM6zAtfEHcfiLHY2RCD9qw7EaBGPIPjD2LPXiQD0PpSPFuynwwDf+iEs0PQSNbRpC
	/CkPEnKw==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqO-00000004oL6-2zH2;
	Wed, 04 Nov 2026 08:59:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 04/25] xfs: use a separate lockdep class for all rmap inode locks
Date: Wed,  4 Nov 2026 09:57:08 +0100
Message-ID: <20261104085929.317544-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

We'll soon use the rmap inode iolock for additional zone reset
synchronization, so assign a differnet lock class to it.  And while
we're at it do the same for the invalidate lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index c6981f566860..91961fb85aff 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -282,6 +282,8 @@ xfs_rtgroup_get_geometry(
 
 #ifdef CONFIG_PROVE_LOCKING
 static struct lock_class_key xfs_rtginode_lock_class;
+static struct lock_class_key xfs_rtginode_iolock_class;
+static struct lock_class_key xfs_rtginode_invalidatelock_class;
 
 static int
 xfs_rtginode_ilock_cmp_fn(
@@ -328,6 +330,10 @@ xfs_rtginode_lockdep_setup(
 			type);
 	lock_set_cmp_fn(&ip->i_lock, xfs_rtginode_ilock_cmp_fn,
 			xfs_rtginode_ilock_print_fn);
+	lockdep_set_class_and_subclass(&VFS_I(ip)->i_rwsem,
+			&xfs_rtginode_iolock_class, type);
+	lockdep_set_class_and_subclass(&VFS_I(ip)->i_mapping->invalidate_lock,
+			&xfs_rtginode_invalidatelock_class, type);
 }
 #else
 #define xfs_rtginode_lockdep_setup(ip, rgno, type)	do { } while (0)
-- 
2.53.0

