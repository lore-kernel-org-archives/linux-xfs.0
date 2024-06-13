Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8903612CDB1
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 03:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718247948; cv=none; b=BTSmGA4hJ9z2i6jI6igOPDDJG8tnakp5Wcca8saC1IL2Lcz9qVcixDa7WgisliNyISKIPVArwM+QFiV1i1VzghF9o/c+6fbq3ml03FDAZHPvl+tC4+wH+spk7siwfP/3NDbQjjnkJ1vycFwLV+jKgf4y/KiG8Az8b6cqb7nFtUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718247948; c=relaxed/simple;
	bh=sh0+FsSCfhEzNKHLY96EitL1MDAyukCSyBJzom2zmFg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oN13GroIU4+lbS6y5l85HJV3a4hwFo2L7ynZEcT7echpE0TbZPDg1syoIackQWIRx1NHIvasn3VPinYdpyrni2qN9iqSm+rBf1G2h447mIwHGiPYeH4GhpxOfkteUKvR6g197Ma11QIDhZBJEDD+uNmx6C1teAHbScuzwDLjA9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLr7Z0BH; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLr7Z0BH"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-375932c953aso2512005ab.0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 20:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718247945; x=1718852745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lH9bJtteDn4yQ1wJCG4AuCFr/QlkR3V86staQBxMpsU=;
        b=FLr7Z0BHgcD1RJ9XgHbaBZ3udzOosaDjRMStKUsr5NBd5aho6U+SfhO0ifaaMjfhzx
         7OzWtHglARp0v0ujttIqKtjYCQlwkrYb5aUMI9Mwyg5jU6pa0Rj9mQu8OVFpdu/e9uSD
         3cB+PcxMAjX6F43jLjMHbWpAxHELb4KY/p5w19POeLolahpPFXER3sCgIPvJ3vtC++fh
         4NBVPW731BUJTlvH0TGHq9yXZh4WgeX3o6XkfttRzBOHpt6BRY0eeFpUe/nP3+P/cIEe
         lOSZnan9BiACaoCmtv2EaeQ2HZa8WGl93Vlm+AVcydN7dtVH1kn6z4XPqhKVVQ3dOhsP
         4N9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718247945; x=1718852745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lH9bJtteDn4yQ1wJCG4AuCFr/QlkR3V86staQBxMpsU=;
        b=M7V8jkbwEs6on1ofkfcSvbI7leNXuD8GZ6gG8iuksblGeZXyIV/qGjA0Hsbm+MkIy3
         ZpofCa/vI8ajrp6PUoGN8PHrpWXqWmrbZvA1v+SNqt+RmvmUd2PNyQVfJVYV6AAXqdLG
         tXQ8SzUi9oAyEM3nScHa3Nsy29I4VkwN301FTZ+kjcV7rRamOi7+0EJaYSLZBsdSsDGk
         80VPGiT1pH2tQYy161plEW6BZztYISAMQ1MTfCBSEhFU2zDf3vwpEWcmEMINXV5lKFk3
         P63mmZ8i+VFtfacrjNwLLzJnLuXcQSFD9wIHikuQYjwCgObMG6K61zOvMbLLzqW7xXJK
         fakg==
X-Gm-Message-State: AOJu0YzxHTFvkYnOKFwduz2zd+1B5GBv9vUtfyd2hm5iTDYgOj9xErJz
	GjCOJkbiEYW9q/tGIb3Z+KrolsBKxvD7L+ixTGv6DQgf1qkuOP0XTC12puunyiw=
X-Google-Smtp-Source: AGHT+IHAtkRNW6IF2jYj217TTjNumYHXxR1ZDpKKucMqi7sSiUpduBRHhvrK7IUq4tLG1AL1AgbNHA==
X-Received: by 2002:a05:6e02:13a9:b0:375:cac4:54e0 with SMTP id e9e14a558f8ab-375cd1525b2mr41968225ab.2.1718247945326;
        Wed, 12 Jun 2024 20:05:45 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6ff19a06b58sm145538a12.49.2024.06.12.20.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 20:05:45 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com,
	djwong@kernel.org
Subject: [PATCH v4] xfs: don't walk off the end of a directory data block
Date: Thu, 13 Jun 2024 11:05:09 +0800
Message-Id: <20240613030509.124873-1-llfamsec@gmail.com>
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
---
 fs/xfs/libxfs/xfs_dir2_data.c | 30 +++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2_priv.h |  7 +++++++
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index dbcf58979a59..feb4499f70e2 100644
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
@@ -186,9 +194,12 @@ __xfs_dir3_data_check(
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			xfs_failaddr_t	fa;
 
+			reclen = xfs_dir2_data_unusedsize(be16_to_cpu(dup->length));
 			if (lastfree != 0)
 				return __this_address;
-			if (offset + be16_to_cpu(dup->length) > end)
+			if (be16_to_cpu(dup->length) != reclen)
+				return __this_address;
+			if (offset + reclen > end)
 				return __this_address;
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
 			    offset)
@@ -206,10 +217,18 @@ __xfs_dir3_data_check(
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
@@ -218,9 +237,10 @@ __xfs_dir3_data_check(
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
@@ -244,7 +264,7 @@ __xfs_dir3_data_check(
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

