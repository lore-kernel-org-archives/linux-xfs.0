Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605242A1A4
	for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 20:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742502335; cv=none; b=cTYQgTDriu4scGw7oxpr35ksYvaUgdLdn2pqQ+NPcj76B/00It4DNp6JX5WGAlfHzjpmvZtkwD0ReGW82fU+dAsYY27lvj7ClwjJHe6CXzsQR29gdqDb4HHvO9urtWD9p+I/ld5mu9KdvMesYD29/8ywiDf+XOCtUXID4HsQ2js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742502335; c=relaxed/simple;
	bh=BNL/4VTSb4o0AbHMxaOB4pXYTBRJRe1DLDVOa4oQ+Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jA89z/YbOzg073zd3eB35M8LIpgQRJfFCKOwVHbOXb0nEMzYrZA3HmEJ2sFKJzroId1J3iKdMxJSSQL/gUK6Jp07EPqTBcKWi9sOOXN30GptdONFgUB9tmJI3Q6JIZXKSAFVjCUbCJjeKcOCp/oQBnxRoj4VJB1/TqCRvEJl/j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jJXhMCTF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jJXhMCTF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742502332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=in8YSvwmPQoOVNNI6ogYoeHH0Sv19ObMg2l5lhwwJek=;
	b=jJXhMCTFXmcwKeAdMRpOBntkTHIw0TBoB8m7ZeLN9vfFH+kNBdNfAIgYROlqA4fN59/O+X
	NSNQBANJivSfDE3kuwDqqjkRuIBYsEXUJx1T5iTRAiprg/YarzMyWznTDaqilsSEq+RqkI
	NZIU5tO6QL1uXrisKO9xpK0lhAKyABc=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-4uKKvuXWNyeQhQOVEfzwKw-1; Thu, 20 Mar 2025 16:25:31 -0400
X-MC-Unique: 4uKKvuXWNyeQhQOVEfzwKw-1
X-Mimecast-MFC-AGG-ID: 4uKKvuXWNyeQhQOVEfzwKw_1742502330
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d443811f04so11335715ab.1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 13:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742502330; x=1743107130;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=in8YSvwmPQoOVNNI6ogYoeHH0Sv19ObMg2l5lhwwJek=;
        b=GIGQC3iJ9rUgCjkJtdgPkTG6I907AvydSFj+UrMmAE13Ti0+EQijCR7cbnMwOZYeaZ
         ArKcmSY0P0+uDHx/8hcYi2n8nCnetLg6h1D2Eo8t8gq7hwoRIY0+tBqmVuKMlTILBqch
         dwMDykBiXoqDCrHHguMQ6YyQV3oHg3/YAESX8W1effB4l506TTbuY315VH35C9CYG8+8
         7QXh6kkWu6IbFZf8wgbpeAT80Yq6yX6YrqlfgwvDZKcxB9ysDYuUA+2pcNNvAroG6bdQ
         ORK776qI+1R4GUIlNu0m8I1RMwjvNOea6TZ2MUtwqTu2HmlLthmXFrbbI/zWp/UkBZn+
         1sAA==
X-Gm-Message-State: AOJu0YymtL1kJsYESoznwJ5IknKtm7fjYGO9dcJpPU0yziTwAJtBdF1c
	9XbSQnA/h7bjwoPVhpOhdcbqL40155TUn7vt0fOj0HFWpBTz7Hug09V1yYuOr1MPOvqNuRcydtf
	fPgLL6D3Sz3LNVzw3w9Z/Eq8pg1bqghtUTlQRwQthoBj2VF3fy8UVoAQ2LrOc5I6k+Uo+liXNrM
	x2vKNkJIU6RxXxtwxwGJaaZrnsqTEvnjRWTn+ggBnqKA==
X-Gm-Gg: ASbGncvZYmCz3NiwSDWWvjJfrGpvZBeRDIrPyndOMXQ122V6VWB5/llr9aExL8Y39If
	G06IaSxLI1VyYAWOJ5qu2C6vHyiOoQ5LmlmE0KzqR4R5XJSnx7lIti6hnzteLe/nlW6pRSV/Jb4
	SIOQqmoBytrsKQv3jagtPs9fKIy6AV3Z+G86R5EXQFoKMCJwzuh6jSM5EN03+xOecpPbVRm/8iH
	bI3PpZZCYVjZlNTNUtp6b30fBBUajYXrZFWNOZILZVpN16gICl1jbIE6bLeqtpbnlAyOESACAC1
	izK4xDSl+a9dKlqB52ncLTN80nw3lWxu56dpzyF45jY2q2jSzbgY/39xEg==
X-Received: by 2002:a05:6e02:1a43:b0:3cf:c7d3:e4b with SMTP id e9e14a558f8ab-3d596186625mr11602315ab.21.1742502330240;
        Thu, 20 Mar 2025 13:25:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlM0uOAEppj7EZCi57L1H0XgmLxq+NrHuUWi9Eq4uaHJIXu+NeNRGH3rR9a3lUBV6r3Crl/A==
X-Received: by 2002:a05:6e02:1a43:b0:3cf:c7d3:e4b with SMTP id e9e14a558f8ab-3d596186625mr11602045ab.21.1742502329869;
        Thu, 20 Mar 2025 13:25:29 -0700 (PDT)
Received: from fedora.redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbdd0325sm88065173.46.2025.03.20.13.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 13:25:29 -0700 (PDT)
From: bodonnel@redhat.com
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH] xfs_repair: handling a block with bad crc, bad uuid, and bad magic number needs fixing
Date: Thu, 20 Mar 2025 15:25:18 -0500
Message-ID: <20250320202518.644182-1-bodonnel@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bill O'Donnell <bodonnel@redhat.com>

In certain cases, if a block is so messed up that crc, uuid and magic number are all
bad, we need to not only detect in phase3 but fix it properly in phase6. In the
current code, the mechanism doesn't work in that it only pays attention to one of the
parameters.

Note: in this case, the nlink inode link count drops to 1, but re-running xfs_repair
fixes it back to 2. This is a side effect that should probably be handled in
update_inode_nlinks() with separate patch. Regardless, running xfs_repair twice
fixes the issue. Also, this patch fixes the issue with v5, but not v4 xfs.

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
 repair/phase6.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 4064a84b2450..677505d45357 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2336,6 +2336,7 @@ longform_dir2_entry_check(
 	int			fixit = 0;
 	struct xfs_da_args	args;
 	int			error;
+	int			wantmagic;
 
 	*need_dot = 1;
 	freetab = malloc(FREETAB_SIZE(ip->i_disk_size / mp->m_dir_geo->blksize));
@@ -2364,7 +2365,6 @@ longform_dir2_entry_check(
 	     da_bno = (xfs_dablk_t)next_da_bno) {
 		const struct xfs_buf_ops *ops;
 		int			 error;
-		struct xfs_dir2_data_hdr *d;
 
 		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
 		if (bmap_next_offset(ip, &next_da_bno)) {
@@ -2404,9 +2404,11 @@ longform_dir2_entry_check(
 		}
 
 		/* check v5 metadata */
-		d = bp->b_addr;
-		if (be32_to_cpu(d->magic) == XFS_DIR3_BLOCK_MAGIC ||
-		    be32_to_cpu(d->magic) == XFS_DIR3_DATA_MAGIC) {
+		if (xfs_has_crc(mp))
+			wantmagic = XFS_DIR3_BLOCK_MAGIC;
+		else
+			wantmagic = XFS_DIR2_BLOCK_MAGIC;
+		if (wantmagic == XFS_DIR3_BLOCK_MAGIC) {
 			error = check_dir3_header(mp, bp, ino);
 			if (error) {
 				fixit++;
-- 
2.48.1

