Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889CF161306;
	Wed,  1 May 2024 18:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588883; cv=none; b=go/yZWHI8lugsSKcX/KHT+Pv4brikjeymUAgZrXj9EJs5HHSpW1kWLnxvrBRJ7GpB4mmyNcrvy2Z20Q2trJ8+EpwRjMvqaNavYDq2da00TJbTmSzVnKNACQf4U9dvqyMlJvyKPmrsPwGFIN0lazygf662hjehE4Oyno7Ris94L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588883; c=relaxed/simple;
	bh=Fv+Vz7rqSz2jWJbqO7e3wfg95/uznRlCrtWPbFYuOYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyaiLnna4vq6g5Yic+s3nu6hl/fI6ho+3fnfHDUy5InmXQGGThWGplyavIPcALmgMlMWXjAKHwuHTio+eh3PCIQfH+gGT0dvxYGCy5MUVULW8jE4Ogh6iXkWgDpjH1nbhpONMOwwNzgzFF0ce31j+F7WG80IY9bsO9m2mAeQcyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K5CHpe/b; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K5CHpe/b"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6ed691fb83eso6259084b3a.1;
        Wed, 01 May 2024 11:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588882; x=1715193682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nnbDevG3mSM/CWgGnFnqGsO0hsBI9MXW7MTGPOzxxI8=;
        b=K5CHpe/bLu7HaUIr5sk02r4nftCR8MW8c9VHKwLv8e8ztQFe126jHyHBcU0dFBGvGW
         KA5LgXdpms1sRQOUSCk1KALrlmelPDXnZOZ05vlxurN/hRJ1DueEM0F+PtpZvgHZfslB
         rKH2ziJ9wLrGGJDewkd7plEitj0gs2IQz/Y58W9MCW2mkfaQgSQy4NImErceI7KHktrO
         hSRoYKxLltz8lSRl176udOIlYyrNl16FCEOuMm331ZyqmUygCJtIwMNYSQuJXxOCHKDr
         oCWQSyzW7NWFgiuWL0q0+gEmCg7lbqH+GolqQ/AAJKiwykatfAgjx2ihPLcTGqR5ltc0
         81vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588882; x=1715193682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nnbDevG3mSM/CWgGnFnqGsO0hsBI9MXW7MTGPOzxxI8=;
        b=wPDd975FgkIlheO5oOItyrhaf0D5q6plVEjNOzr6BZ2R8xRUlYJnk7ghjf8ze6PqGS
         6MiJSIqRnqy/6dCiZON/MAOvNNuyDM7b0cYLXZNdcBlIEecRo3Ww7yBcP0NYUkM3B0y+
         +jJZsgiUVZX6CQsSMBCqwgV6WxvqBSlewyUmZ+x/+KSwt0mGEIVyF2IbtDJW+XRz5iTB
         2VrUUFUGe1jYuOxyopLeAIM1oSP88gTSxRWa1dIfCcEYEkZmbngceVTElz+rr+/MM4Ls
         4t97U45yGdp5ZE3gCFk+Z0pmukOXDcNg8TvoUGYuAwv2fgVJlEhp4xaFzHgBChWyubRy
         l3bQ==
X-Gm-Message-State: AOJu0YwWbgh13tx+EPopWnzhP9OOPQ6MyZk1fv7ZU2fKz/5/wiHn8PQx
	dDXCIUbV6+/duiStvf7FdlgZsphsGbtj3Nes5OxMUCuvpggtV9D6a/bnpoCy
X-Google-Smtp-Source: AGHT+IGFGY4nKmYUCSk27umLDjdh2fbpG2R0xm5uzloBsyiYFTM3e2UMsZvIWXiWl3C/p1/YVY3kmA==
X-Received: by 2002:a05:6a20:3945:b0:1ad:746:b15a with SMTP id r5-20020a056a20394500b001ad0746b15amr3530380pzg.47.1714588881752;
        Wed, 01 May 2024 11:41:21 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:21 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 06/24] xfs: xfs_bmap_punch_delalloc_range() should take a byte range
Date: Wed,  1 May 2024 11:40:54 -0700
Message-ID: <20240501184112.3799035-6-leah.rumancik@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 7348b322332d8602a4133f0b861334ea021b134a ]

All the callers of xfs_bmap_punch_delalloc_range() jump through
hoops to convert a byte range to filesystem blocks before calling
xfs_bmap_punch_delalloc_range(). Instead, pass the byte range to
xfs_bmap_punch_delalloc_range() and have it do the conversion to
filesystem blocks internally.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c      | 16 ++++++----------
 fs/xfs/xfs_bmap_util.c | 10 ++++++----
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_iomap.c     |  8 ++------
 4 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5d1a995b15f8..6aadc5815068 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -114,9 +114,8 @@ xfs_end_ioend(
 	if (unlikely(error)) {
 		if (ioend->io_flags & IOMAP_F_SHARED) {
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
-			xfs_bmap_punch_delalloc_range(ip,
-						      XFS_B_TO_FSBT(mp, offset),
-						      XFS_B_TO_FSB(mp, size));
+			xfs_bmap_punch_delalloc_range(ip, offset,
+					offset + size);
 		}
 		goto done;
 	}
@@ -455,12 +454,8 @@ xfs_discard_folio(
 	struct folio		*folio,
 	loff_t			pos)
 {
-	struct inode		*inode = folio->mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_I(folio->mapping->host);
 	struct xfs_mount	*mp = ip->i_mount;
-	size_t			offset = offset_in_folio(folio, pos);
-	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, pos);
-	xfs_fileoff_t		pageoff_fsb = XFS_B_TO_FSBT(mp, offset);
 	int			error;
 
 	if (xfs_is_shutdown(mp))
@@ -470,8 +465,9 @@ xfs_discard_folio(
 		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
 			folio, ip->i_ino, pos);
 
-	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-			i_blocks_per_folio(inode, folio) - pageoff_fsb);
+	error = xfs_bmap_punch_delalloc_range(ip, pos,
+			round_up(pos, folio_size(folio)));
+
 	if (error && !xfs_is_shutdown(mp))
 		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
 }
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 04d0c2bff67c..867645b74d88 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -590,11 +590,13 @@ xfs_getbmap(
 int
 xfs_bmap_punch_delalloc_range(
 	struct xfs_inode	*ip,
-	xfs_fileoff_t		start_fsb,
-	xfs_fileoff_t		length)
+	xfs_off_t		start_byte,
+	xfs_off_t		end_byte)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = &ip->i_df;
-	xfs_fileoff_t		end_fsb = start_fsb + length;
+	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, start_byte);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
 	struct xfs_bmbt_irec	got, del;
 	struct xfs_iext_cursor	icur;
 	int			error = 0;
@@ -607,7 +609,7 @@ xfs_bmap_punch_delalloc_range(
 
 	while (got.br_startoff + got.br_blockcount > start_fsb) {
 		del = got;
-		xfs_trim_extent(&del, start_fsb, length);
+		xfs_trim_extent(&del, start_fsb, end_fsb - start_fsb);
 
 		/*
 		 * A delete can push the cursor forward. Step back to the
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 24b37d211f1d..6888078f5c31 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -31,7 +31,7 @@ xfs_bmap_rtalloc(struct xfs_bmalloca *ap)
 #endif /* CONFIG_XFS_RT */
 
 int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
-		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
+		xfs_off_t start_byte, xfs_off_t end_byte);
 
 struct kgetbmap {
 	__s64		bmv_offset;	/* file offset of segment in blocks */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ea96e8a34868..09676ff6940e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1126,12 +1126,8 @@ xfs_buffered_write_delalloc_punch(
 	loff_t			offset,
 	loff_t			length)
 {
-	struct xfs_mount	*mp = XFS_M(inode->i_sb);
-	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, offset);
-	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + length);
-
-	return xfs_bmap_punch_delalloc_range(XFS_I(inode), start_fsb,
-				end_fsb - start_fsb);
+	return xfs_bmap_punch_delalloc_range(XFS_I(inode), offset,
+			offset + length);
 }
 
 static int
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

