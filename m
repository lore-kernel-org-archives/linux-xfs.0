Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0380C36B17
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168557; cv=none; b=MCZtMTTJXr6BZ0bLlTmWubnQw2tuhfxAHTk0FrIBwi/6ii/oUH6y2RyHt0VdBxR8WEaG7GfHyTRiUkJbSqWFOFFTtfSKrkspk+cMlN55u4uU+XN87vXdLO0hnNxvm2eYtixgPMT1rulaWlMV/z7WOqK5vJYKoJxqylW6g/Z1HEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168557; c=relaxed/simple;
	bh=u8JO4w3l37IF4urxqp5LT3dnN+M5KBdbmobx25GKsjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2jHs1cKGqe1eewR8h56z3xjhELgt9cuTlC2acH3A84bHPNqjdyYEwJWhBrF1RyeqbBsiaX9fjFLK3Nwz+l8a8kSxUJwtswqk8psguwCMCwpXPqOwRf34csOXiuAqSl+07/lJUW6OtA22aiJs1mnuxazEtqNyqBzanWq2W5coS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XMVHtvYR; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XMVHtvYR"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1eb0e08bfd2so7686965ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168555; x=1714773355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvCc5WYGZ4cnKLb9iJ7KaL3Fdjd6Lh5J040eZYLmRN4=;
        b=XMVHtvYRFtGQ3yrrnIlPRk/thLRasq6KcHfwsGOjHQLG1foqrBnyc1Xd5Vi4hnaAej
         1j8o82nXmEzFqcY2Dl+H+lb3rDTsWIiR7WGQcCAYN8qWN1iO8lWcpQnuOUQTJ39iH5Yd
         OL1ikRuGredC+IDAiMF7IQiLapKdv47XZRtCWvSCQgHg322T4Hc2jPgrw+tNS9R913db
         XJu/dQJwpyXvLS+dTfRLnnfdxYlNKBaiosmK7Pg4iU0C/5B1I+DWmYlqvjROybIh6ZjJ
         wCQht3kybOeMgdpEd3Ra455XT9GEZ0aJRxti6Sp3YMb340psvyz7ENNKAScwVb2mG75y
         BOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168555; x=1714773355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bvCc5WYGZ4cnKLb9iJ7KaL3Fdjd6Lh5J040eZYLmRN4=;
        b=MbbXLW736k9+cpjtRow+ZhMZaFDabsdfX+NYdcEQ7pbkGSxziuJVHyHqn5m5Y9QeoA
         q7ZpOm5hFnEVvinBhQOZWDdzFit3h5+mYcXDt+22atB5k4LKUu3yyqtXh8qYJ26Ubeha
         mUZizLD5kjIAynuVbqsjdeR0IZvdodvySskBbHaRS22udFbOFcffSKd8mcOFp1g/gjn5
         eGzm6MmPD85WQ11hCNX8dEECI/hr7D9Zw2KpKS31YgLmA0OtQJ/eXUyg1S4wIMGWqN+O
         XqqAO4dXsft7DeEoPo+47GW9Z7xDvIg9bw2d2ivOMpQBNFPmxthQQGkWFf6SsUPWQt0y
         KApA==
X-Gm-Message-State: AOJu0YzCvsMOFDwRqGk66JMceiEFf9axha8gx/zcI/e/9WH3x3YclxOE
	fF7hq80uaXNo5x/yd4Sp1dvv8SiR7/PrO4SVptMlo7q6keLeLvZXOyopCo9x
X-Google-Smtp-Source: AGHT+IGbZvB2Tpi/amPAy1Wu9sb9UWlyZujB1LrH8sa1gnX1sbJMnAmUBVxSp3lLFuCmPrrA3WDqsA==
X-Received: by 2002:a17:902:ba89:b0:1e5:3554:d9db with SMTP id k9-20020a170902ba8900b001e53554d9dbmr3294673pls.64.1714168555028;
        Fri, 26 Apr 2024 14:55:55 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:55:54 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 06/24] xfs: xfs_bmap_punch_delalloc_range() should take a byte range
Date: Fri, 26 Apr 2024 14:54:53 -0700
Message-ID: <20240426215512.2673806-7-leah.rumancik@gmail.com>
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
2.44.0.769.g3c40516874-goog

