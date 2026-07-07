Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6223FB075
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783432753; cv=none; b=Zcyt8tk0Uni651m183w9B2E4nByqaWX6k4f/W7ogt9EgGgUbDIL52nFmSSJOV/ktoEjtPkgkj3k6pB1bqGSgolej012ejSgWRC1sBgQP0wql8TpirPa4U96cP32eTsimoKPKiw9xDG24UOprv1Eae1Wv1DtA0utaw+PfZgljbQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783432753; c=relaxed/simple;
	bh=2hE/QLQ6NQwnEh/ct0Xx3GBBCa/XdCxtAbTVrpNN3+g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qthH4kc80zcR0FAvwn8Noui8NVRHKWjogxP+NPLJlQtmgZi1Amwffxc+S+aX3m+j9M159JxG0hv7zWPZT9bn0+/AQasI/HpXxF1Ep+j1/ByjEc6Sy1JARlp4lSYJN0dtAn3QE9Joz549J72dJOL5YUqRGtKU5YnOYda6u+a4FGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qc4upGR2; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qc4upGR2"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-36b9d265355so3370061a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 06:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783432751; x=1784037551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JbfkOlj9qer2JLXvYFJ3G2PBpp6ZD35Tjdyv1Gk76Bg=;
        b=qc4upGR2B6oeeK2J+bOHfS0vsZbFYRd0lLn9e5V6JmeTPH4JZWc5h7joiQzTZ87nsG
         sh8LwO+0MlZTHSwqwaK3FLp4FF/9YpYjuiPSJ3hGgowuaqQHRlfE7U5FZfdnvF/SzE03
         hEjN5rfg8l/G4lnYNSwfVF2Ti5cu4W3JL1bm/hb2YcNrwudToxp9lRLsZBB0HlFBOeGS
         3GefBS1KtOW5GJf0JDmjh3HUfLmMetyGp8KX2fwUK19DUa8crAFW+lnR8tdI+2CjZrBK
         06pC9t7ksNqDvgokWN3g7QAd/Bk9Om7G9DEHZmfiMy4DS/Ee6TPiOYMl04+eonbRLDgC
         1dng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783432751; x=1784037551;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JbfkOlj9qer2JLXvYFJ3G2PBpp6ZD35Tjdyv1Gk76Bg=;
        b=r7ShxipvgUvzjJm7cM0gR6gYNnsNKszBb+RLVImRpRNDzOGMufV/xzPYVza4+SrRWx
         5oEIlLrl7i9/Z3p4Kab8HO23jTWEOx4fbo7FbaYGSeP4eqdHEfskC7zfJqwbPvsOLCD9
         X/b5ikxnfD3cQ4M0iZRp88rfCVqzqP8/s4fanrviYZWUOSDbDeqRr+bUGtLEtnm0OiWQ
         bwhh6mlPVwo4paXJTV3UUTSNxFeMmk9vjmiKLykElne89ub5vbYXd0lb+BluCP1H5Ly0
         4GQEPktvk9Cy/rEgY+NJt19fgJrNmN5PIbYTH0Ta/63vIyCoG1uDYw9vx5aClxVDhqnp
         jD3g==
X-Gm-Message-State: AOJu0YxIor/uErHdpHlhBWYSfvwSH5QeIcVCMEbMgrwQpRqyzIHh3iYY
	kRssNAWoPNMTbK/anxLEXiPb8ei0U5MQj9XZWVokcCBXsCbkreuR1/ckADsvYMKUcAQ=
X-Gm-Gg: AfdE7cmY+CF04yTjZe5OVgJXy/lvmx/XJigaJVKfupSr5IORt1wS5hqQMLq5a8+dYCn
	AtHkjWBl5E4HtaPbzEZ/KT1tjv1dzbL6Ra3jDc20FcA4Z/0lGXt4P1O007a37w9MB8keD4eGt60
	aZUYIF4GbIXlWe1y7umCoojMcr0k0uAfAKjXXQf5t4Z4iYK27IyHvGimFp/p58LZeCJcBoQH80w
	Ex978MVYZ+rZANUtT4LBE9h723yewHCSjeWsNUrpNNCnQeHbcHj7dbaLhIf5CVrmJcwqzKCpa0n
	HK4DXyshKRnzSY+rIkhUbXhqo+EzOpAB6ZAqQC8PyyAWQ9Y+4xVGlaotsxYjTO1CW1FG1gK8Abi
	Ck3F88ybqliYINelhIPd8yz7Uxvyh7z+gWGVjp3cuQrQwdWt+ZTlra9hOcfgWDA3iobksIgMHNH
	YoXshx
X-Received: by 2002:a17:90a:f94f:b0:37f:ec5e:12d9 with SMTP id 98e67ed59e1d1-38756ed4dd2mr5060311a91.16.1783432751182;
        Tue, 07 Jul 2026 06:59:11 -0700 (PDT)
Received: from beelink.. ([186.22.57.86])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174a5b26csm8537100eec.15.2026.07.07.06.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 06:59:10 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanrlinux@gmail.com>,
	linux-kernel@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: [PATCH] xfs: bound inode fork length against the fork size during log recovery
Date: Tue,  7 Jul 2026 10:58:43 -0300
Message-ID: <20260707135843.3213352-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
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

Reject the log item with -EFSCORRUPTED when the region length exceeds the
destination fork size.

Fixes: 658fa68b6f34 ("xfs: refactor log recovery inode item dispatch for pass2 commit functions")
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
 fs/xfs/xfs_inode_item_recover.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 169a8fe3bf0a..388d3a8dbd31 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -510,6 +510,10 @@ xlog_recover_inode_commit_pass2(
 	switch (fields & XFS_ILOG_DFORK) {
 	case XFS_ILOG_DDATA:
 	case XFS_ILOG_DEXT:
+		if (len > XFS_DFORK_DSIZE(dip, mp)) {
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
 		memcpy(XFS_DFORK_DPTR(dip), src, len);
 		break;
 
@@ -545,8 +549,11 @@ xlog_recover_inode_commit_pass2(
 		switch (in_f->ilf_fields & XFS_ILOG_AFORK) {
 		case XFS_ILOG_ADATA:
 		case XFS_ILOG_AEXT:
+			if (len > XFS_DFORK_ASIZE(dip, mp)) {
+				error = -EFSCORRUPTED;
+				goto out_release;
+			}
 			dest = XFS_DFORK_APTR(dip);
-			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
 			memcpy(dest, src, len);
 			break;
 
-- 
2.43.0

