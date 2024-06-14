Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD962836A
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 02:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718331799; cv=none; b=U2hSRyTnfIuyLPoLieKBj0b4DcL50kTo8Yf4/ukq24MzD2SwEPonc+s6Fsuu3FeZv9hLMRlxsYhIC59JlOVng3Zyr8+si76a4/kKz0HER7PZQBqgsk//fgxuMu/WItKkJ76E5iY+BI9VURDri0o/OLfgWVwgA1YkhWUQarZowxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718331799; c=relaxed/simple;
	bh=W+0uRBuRb6AVEdDU27rhpcxVpQVsqCPY86G7GDDepag=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q3JbtORCUMTLtUchnICNuOTV/cqePaWNj9mNNu+99mLiw9m4nm0iQ/RHcqLV85SVQRpjro4jHrqneVUVRzIglx0EXeJuj0dMROtkInD4fHDch9ETVd62T36SRVCFdb3tDAUAIsEsjwNwKBELnfSZjH03ytkc2yBAWCnd16w9jJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ICvSdb5C; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ICvSdb5C"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-6c53a315c6eso1268380a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 19:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718331797; x=1718936597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nb3u5lena1PmsLa5qh4KtcocCo0zwHfXXscTPy9jHs0=;
        b=ICvSdb5CcL0EDjC+u7eg4tzY6nInr7WdvMj9MumdHVfo2bOvekHG+L9pCC7BakoLIf
         Zagkl/ulx1BLCc62UGklOC7tbj+21bwam9g9bzyhqNNjZD8yx7Ye2y2O4ahEJwZk0g9K
         fQG8eY124oRlAMeHYgJbI4WBG92DPLFZOnXofPCx1awW/NDgtIDrBZVtf9xkw9UvQVm5
         MbggQEq8Iq6QgCQAZ9FdaUyBcE9KtCT19bMcWlTTRfmYRoKCQldSqGh5BGUrVo1Ajjut
         1VSapOfYkDjrYXvqSaqAZUL/SMiq2vDY/mYC8P1qPOLRuJUL8X61a9jABOGwfLln/68c
         Dryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718331797; x=1718936597;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nb3u5lena1PmsLa5qh4KtcocCo0zwHfXXscTPy9jHs0=;
        b=SXjQZz8gZY2QABlTIUXIeD5EhVFvC1sl6Xn/1bsJaX5ks0ENCw8yfRaIukse5DNU9w
         pyJr4DOsu6AbRMS7CjydMfIBrOzksFgi3d/2E8MyrbdidgCC3iLQAnSPx4nJwAk73Zqk
         kM8P/gelvEghLwIS2vaPJ+iBQ2s9Y+3UbPk90Yb4oZ9V6qneKoZXe6WFOUzVGNpeJHsn
         3fWanLSi+zwGI344Iy8P4FaZFVedrWTo+Ys6xyuBjKP0eKymrMaziAWnV5S/ktLOYHvF
         WOgff0J7UCqJdjPlMROfVEuab1ebGDN8N5YDWIYsqPkOMaLGDz1ysGnMeYXaW10yNOuM
         PnbA==
X-Gm-Message-State: AOJu0YzRiWtb2sP4c6Ps2X5HI2seFCGjtj6zbxaqVgGIFk9diTyEGXw6
	jq+goK+4sV6iL4WS6KIhcio0nHnrO+f5YCQh8iHPGO4pRuJ6gLd/o0YjctP2M1A=
X-Google-Smtp-Source: AGHT+IG3m5O2sd6pqUgv0H+Fvx0/fZ4YdS8l0HBm3Z4f8TLSGic+H/7h4J+50wEIUjPugi9hsXHs5w==
X-Received: by 2002:a17:90a:a797:b0:2ae:7f27:82cd with SMTP id 98e67ed59e1d1-2c4db132d0amr1494678a91.7.1718331796857;
        Thu, 13 Jun 2024 19:23:16 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a7603163sm4862512a91.25.2024.06.13.19.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 19:23:16 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org
Subject: [PATCH v5] xfs: don't walk off the end of a directory data block
Date: Fri, 14 Jun 2024 10:22:53 +0800
Message-Id: <20240614022253.130814-1-llfamsec@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
to make sure don't stray beyond valid memory region. Before patching, the
loop simply checks that the start offset of the dup and dep is within the
range. So in a crafted image, if last entry is xfs_dir2_data_unused, we
can change dup->length to dup->length-1 and leave 1 byte of space. In the
next traversal, this space will be considered as dup or dep. We may
encounter an out of bound read when accessing the fixed members.

In the patch, we make sure that the remaining bytes large enough to hold
an unused entry before accessing xfs_dir2_data_unused and
xfs_dir2_data_unused is XFS_DIR2_DATA_ALIGN byte aligned. We also make
sure that the remaining bytes large enough to hold a dirent with a
single-byte name before accessing xfs_dir2_data_entry.

Signed-off-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 31 ++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2_priv.h |  7 +++++++
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index dbcf58979a59..e1d5da6d8d4a 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -177,6 +177,14 @@ __xfs_dir3_data_check(
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		unsigned int	reclen;
+
+		/*
+		 * Are the remaining bytes large enough to hold an
+		 * unused entry?
+		 */
+		if (offset > end - xfs_dir2_data_unusedsize(1))
+			return __this_address;
 
 		/*
 		 * If it's unused, look for the space in the bestfree table.
@@ -186,9 +194,13 @@ __xfs_dir3_data_check(
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			xfs_failaddr_t	fa;
 
+			reclen = xfs_dir2_data_unusedsize(
+					be16_to_cpu(dup->length));
 			if (lastfree != 0)
 				return __this_address;
-			if (offset + be16_to_cpu(dup->length) > end)
+			if (be16_to_cpu(dup->length) != reclen)
+				return __this_address;
+			if (offset + reclen > end)
 				return __this_address;
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
 			    offset)
@@ -206,10 +218,18 @@ __xfs_dir3_data_check(
 				    be16_to_cpu(bf[2].length))
 					return __this_address;
 			}
-			offset += be16_to_cpu(dup->length);
+			offset += reclen;
 			lastfree = 1;
 			continue;
 		}
+
+		/*
+		 * This is not an unused entry. Are the remaining bytes
+		 * large enough for a dirent with a single-byte name?
+		 */
+		if (offset > end - xfs_dir2_data_entsize(mp, 1))
+			return __this_address;
+
 		/*
 		 * It's a real entry.  Validate the fields.
 		 * If this is a block directory then make sure it's
@@ -218,9 +238,10 @@ __xfs_dir3_data_check(
 		 */
 		if (dep->namelen == 0)
 			return __this_address;
-		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
+		reclen = xfs_dir2_data_entsize(mp, dep->namelen);
+		if (offset + reclen > end)
 			return __this_address;
-		if (offset + xfs_dir2_data_entsize(mp, dep->namelen) > end)
+		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
 			return __this_address;
 		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) != offset)
 			return __this_address;
@@ -244,7 +265,7 @@ __xfs_dir3_data_check(
 			if (i >= be32_to_cpu(btp->count))
 				return __this_address;
 		}
-		offset += xfs_dir2_data_entsize(mp, dep->namelen);
+		offset += reclen;
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 1db2e60ba827..263f77bc4cf8 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -188,6 +188,13 @@ void xfs_dir2_sf_put_ftype(struct xfs_mount *mp,
 extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
 		       struct dir_context *ctx, size_t bufsize);
 
+static inline unsigned int
+xfs_dir2_data_unusedsize(
+	unsigned int	len)
+{
+	return round_up(len, XFS_DIR2_DATA_ALIGN);
+}
+
 static inline unsigned int
 xfs_dir2_data_entsize(
 	struct xfs_mount	*mp,
-- 
2.34.1

