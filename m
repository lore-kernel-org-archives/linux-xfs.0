Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9ADE1B7EA
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 23:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="TNKmxfk5"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6d9bba6d773so8013350b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 15:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705359683; x=1705964483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3LJife0DkUSCWANql4//DrwcmVy3A9Mu4G9yC26ZmxY=;
        b=TNKmxfk50vdv+oU+x85QhK5mWR6UHnOqvuF7rjBLLYQCLGHhSp6KqX7aDnUP2viWbn
         uRBXsfKGTVIlkLpYG3xAjhs8BEU2uPf3RMJR9B0T6ssWFwc2GnVACRBT6Dv7n6/nS+dZ
         bmyxGwCxxeF4H6Pc/kloXt9UHdEV5a51NxEnKilRTCzTJLbciEGZ0mRgikqKSXXxZKvg
         wsZnwGCIxpsyiVZhFuOwlJel/So0D2W/mnv8X3dG5pu7Mi7j/lMfGVEUrV1G1/pYkK9E
         KLxQr1JrZF4Qaq0j3m/69X4mtwq93oDfFicG/I0pzP7l13uZmkxuSJzUS6pbHD0BxZYB
         qPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705359683; x=1705964483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3LJife0DkUSCWANql4//DrwcmVy3A9Mu4G9yC26ZmxY=;
        b=Fi8oOgBIpHgujJlEMXBgMHd+T8QxP2T+6WpoZk9sQvY3d0KjX2q172/W+g5+pzRqsP
         61ZzY35QpM7nKbBxNO1p32zoVFn54v15pRIK1fQOdnzpTeV+W/dMoJsAuIzJGjcBaJRE
         5ZwzYlBZgpfHc4/xYWLXccGe0luOUpzggBWInN+4R/rn2YW5CnK6cIRY7TWkeLNG8HxL
         qrSXSKxEc0GfbQRxGcxLUOnhIkkAHIvyKLjTav1Ol71yA7QKVVM57Ra9tuZ+jHOYOZkr
         LGXFL1+Y0adwV5/Ohev6g32yeFqwTYaw2NyOZJMXtKlLRAzLf7eElXObvFlZQRPagK9s
         DxfQ==
X-Gm-Message-State: AOJu0Yw6qRWQb36Pau5EohHNs7prFuXEtSlQcRsPDl8mzIdY4HUJIHb2
	hcGgRaSi/LjWSaXtl9dCnL+fQdBZiHdSfDJMxILXxlLQuoI=
X-Google-Smtp-Source: AGHT+IHuvnJ8hiLAOei7LMgoGrEcANGg1wnR1tJpH4QRdpptY/qungv5tMun/Ja8vcEiUVKBDoAqbg==
X-Received: by 2002:a62:8142:0:b0:6d9:8d46:814b with SMTP id t63-20020a628142000000b006d98d46814bmr7449168pfd.20.1705359682966;
        Mon, 15 Jan 2024 15:01:22 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id b12-20020aa78ecc000000b006db105027basm8081256pfr.50.2024.01.15.15.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 15:01:19 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rPVxE-00AtKW-18;
	Tue, 16 Jan 2024 10:01:15 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rPVxD-0000000H8gB-3MLa;
	Tue, 16 Jan 2024 10:01:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 11/12] xfs: clean up remaining GFP_NOFS users
Date: Tue, 16 Jan 2024 09:59:49 +1100
Message-ID: <20240115230113.4080105-12-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240115230113.4080105-1-david@fromorbit.com>
References: <20240115230113.4080105-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

These few remaining GFP_NOFS callers do not need to use GFP_NOFS at
all. They are only called from a non-transactional context or cannot
be accessed from memory reclaim due to other constraints. Hence they
can just use GFP_KERNEL.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree_staging.c | 4 ++--
 fs/xfs/xfs_attr_list.c            | 2 +-
 fs/xfs/xfs_buf.c                  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 961f6b898f4b..f0c69f9bb169 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -139,7 +139,7 @@ xfs_btree_stage_afakeroot(
 	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
 	ASSERT(cur->bc_tp == NULL);
 
-	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
+	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;
@@ -220,7 +220,7 @@ xfs_btree_stage_ifakeroot(
 	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
 	ASSERT(cur->bc_tp == NULL);
 
-	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
+	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 0318d768520a..47453510c0ab 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -109,7 +109,7 @@ xfs_attr_shortform_list(
 	 * It didn't all fit, so we have to sort everything on hashval.
 	 */
 	sbsize = sf->count * sizeof(*sbuf);
-	sbp = sbuf = kmalloc(sbsize, GFP_NOFS | __GFP_NOFAIL);
+	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
 
 	/*
 	 * Scan the attribute list for the rest of the entries, storing
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index de99368000b4..08f2fbc04db5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2008,7 +2008,7 @@ xfs_alloc_buftarg(
 #if defined(CONFIG_FS_DAX) && defined(CONFIG_MEMORY_FAILURE)
 	ops = &xfs_dax_holder_operations;
 #endif
-	btp = kzalloc(sizeof(*btp), GFP_NOFS | __GFP_NOFAIL);
+	btp = kzalloc(sizeof(*btp), GFP_KERNEL | __GFP_NOFAIL);
 
 	btp->bt_mount = mp;
 	btp->bt_bdev_handle = bdev_handle;
-- 
2.43.0

