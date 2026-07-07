Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265793A1A55
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 19:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783450947; cv=none; b=VGMURdf8ZfDvIfZ8jt9zRzDeo0VT9+XFDyiS0o5tU6+wl3JluXDaO3zBhCo0/Ub/lrQB0+kC56f5Wp5LRJHgJc5cZVdIni6fmL4iouGhvFcMsPYg7TgZsm2YGj7JD6EHqZqVyVr7Phjthfp4A/2OS1sszHOV3J+7wUuASC7kkco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783450947; c=relaxed/simple;
	bh=QYUa20pIZh2wxiF+T5Z9fR8QFbYCIIP9R0h4qS+mLH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bazF7IJ3D5ypPbp82jJTxOavoN8qin7dhZ1aMzZBLfoPR3GFqPcVJ6XWGMhYkag/1EU8p+E/WmRhEUYFd58i+EvcBCd7Ta0eI95Q5xk52yz4GfMrY6GyZ49TVJBXnnVDPZinjLTnzh1mN/LlzeqtYUS6qkyORgxh6o17KXoDCBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fQDRSxRh; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fQDRSxRh"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-380cda7f00cso3985265a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 12:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783450944; x=1784055744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fcqVoGIOsqHneznya0CjxdKSZ/9QYnIEWsldQdbwafY=;
        b=fQDRSxRhhfDQnouWeQJB+pOAunF2MMAq1smVgQ0SfCJcK6XKgimna0ccpnzeAu69f6
         NjlxmNqpvPM7aB3mpPMx2lQm7D2w4JsbzCQMDXgZ7otZUIt8/8BI5cN6ng6fpm22DTc5
         766TTwco4QdtCBDUxoKMgIzX17+v4SfqQSgnNs69ky8UP9tY2M8T8yR1LYoAoKh6rI3I
         jzNFeLGQG2Fk53aBX5kYTA3y/oDCBJ0EArAzANIImE2DZPI72e/egOzBUeUducmlXASf
         /3doIdqOSj3Iz6jpYH1ocD2wTd4R5+3nGW0dCA1T8A0xKOclgaVVxCdFX82yD5JCDchV
         SHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783450944; x=1784055744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fcqVoGIOsqHneznya0CjxdKSZ/9QYnIEWsldQdbwafY=;
        b=QyYYzhvhjD7DVn74eJOxJgFn9cBfdveCZXeDM/oJdlTFDp7ZlRsI+oUmVDyuayOUNF
         gmhDg9GeNlVFAUk7RvqIQPL9UCnp8RkPCBqA1vp3G5tkR7H3i64nCzH6nYOAWjC87bwB
         h8tR90jmYJBC3uHW8GoIupejdSc+Mh/Esv6QlQ+djvVLvPdyzywkWu3z8KAd2EUYE91O
         UI8ntpH2pnZvY/HoYRsReBjEWA55E/ddG3TplfyrTBLonI7ehps/cHGjSWxSzvhZf9po
         Aey4ZrB5qc2QC1rsCfbDWXSshHJOieKBfF8GZ/3yEAygZwNjx1yDNJK8uJFUFpQ+la37
         pe7A==
X-Gm-Message-State: AOJu0YynqcE3pD/ku5VjGTk50Mon25ZKORUNSBdbFYg8GbdSIwFIqfXw
	sluUqvoypT9rYOoVBCriE0VD1xoOen4Y8iqVic+nJlw+VpOce92MI4CmOw9kbtvqa6o=
X-Gm-Gg: AfdE7ckmWK2CUNGpgA7iPMF2fym/1DBGhMmTeBKb66VubNOWU+yVRGTGHNMrkl9WA3W
	rSbPnTGhVnJYp0WITz+K8Icv2FFVs7tX11mShIA4pYJl/B5D+QPosoDRPbO993/SfjG1pp/HwtJ
	niPDAyYerBz3miRHPAmxFDdBbSh8KWLTRkE7shPNFT3LBzK5QriZMtif69b7lQnNzpPqp00XKu7
	+UNz+Uyon8WNFrfNlpgkEDVB24rSL78NANONDjZAMgKYMJCbUQOET4auH4e7R9o36jCfXuzEi4O
	IayWMCQiYHBV5QtxkO8ArULHYCub6Z09LWe3/1GzonTY85/WU23E81urprqzHDeCL9rbY7mykjE
	t7EG0Xk3r3lO0c/ZQN/edD48txJ5mSPyJlU9VV3d5C5mb7HVrGE5DME2wisLkzJ+Y+MF+IqGJsP
	L2cA1MhwNnJz2B7Ws=
X-Received: by 2002:a17:90a:c2cb:b0:380:21b7:e727 with SMTP id 98e67ed59e1d1-3875547c4cbmr7015406a91.14.1783450944395;
        Tue, 07 Jul 2026 12:02:24 -0700 (PDT)
Received: from beelink.. ([186.22.57.86])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174839f89sm11375916eec.10.2026.07.07.12.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:02:24 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanrlinux@gmail.com>,
	linux-kernel@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: bound inode fork length against the fork size during log recovery
Date: Tue,  7 Jul 2026 16:02:14 -0300
Message-ID: <20260707190214.3813321-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707135843.3213352-1-qwe.aldo@gmail.com>
References: <20260707135843.3213352-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xlog_recover_inode_commit_pass2() copies an inode log item's data/attr
fork region into the inode buffer using the on-log region length without
bounding it against the fork capacity, e.g.:

	len = item->ri_buf[2].iov_len;
	memcpy(XFS_DFORK_DPTR(dip), src, len);

The only guard is an ASSERT, which is a no-op on production kernels
(CONFIG_XFS_DEBUG off), and xfs_dinode_verify() runs only after the copy.
A crafted image with a dirty log can therefore drive a heap out-of-bounds
write at mount time. The XFS_ILOG_DBROOT sibling already passes
XFS_DFORK_DSIZE as a bound; the DDATA/DEXT and ADATA/AEXT memcpy paths
did not.

Bound each logged fork region against the destination fork size before
copying it, and reject the log item with -EFSCORRUPTED when it does not
fit. Because the recovered inode is only verified after the fork data has
been copied in, the checks are done up front, before any memcpy into the
on-disk inode.

Fixes: 658fa68b6f34 ("xfs: refactor log recovery inode item dispatch for pass2 commit functions")
Cc: <stable@vger.kernel.org> # v5.8
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
v2: cc stable # v5.8 (per Darrick).  Move both fork-length checks to the
    top of the fork-copy block, before any memcpy into the on-disk
    inode, and drop the now-redundant ASSERT.

 fs/xfs/xfs_inode_item_recover.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 169a8fe3bf0a..6c7dd7dd7032 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -507,6 +507,25 @@ xlog_recover_inode_commit_pass2(
 	ASSERT(!(fields & XFS_ILOG_DFORK) ||
 	       (len == xlog_calc_iovec_len(in_f->ilf_dsize)));
 
+	/*
+	 * The recovered inode is verified only after the fork data has been
+	 * copied into it, so bound each logged fork region against the size of
+	 * its fork now, before the memcpy below can overrun the on-disk inode.
+	 * The DBROOT/ABROOT cases already bound their copies against the fork
+	 * size.
+	 */
+	if ((fields & (XFS_ILOG_DDATA | XFS_ILOG_DEXT)) &&
+	    item->ri_buf[2].iov_len > XFS_DFORK_DSIZE(dip, mp)) {
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+	if ((fields & (XFS_ILOG_ADATA | XFS_ILOG_AEXT)) &&
+	    item->ri_buf[(fields & XFS_ILOG_DFORK) ? 3 : 2].iov_len >
+	    XFS_DFORK_ASIZE(dip, mp)) {
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
 	switch (fields & XFS_ILOG_DFORK) {
 	case XFS_ILOG_DDATA:
 	case XFS_ILOG_DEXT:
@@ -546,7 +565,6 @@ xlog_recover_inode_commit_pass2(
 		case XFS_ILOG_ADATA:
 		case XFS_ILOG_AEXT:
 			dest = XFS_DFORK_APTR(dip);
-			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
 			memcpy(dest, src, len);
 			break;
 
-- 
2.53.0

