Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794962940;
	b=twEf5APqd4j4GrZVP2SQo7E8MAnhDocSqaxqVYKyXzZBcr+23Ae9hAiwCyTe9EXeztya
	 pbX+wVmYYVvtMg4R2Lwml7cqVbKe5LTgJ0bATTizXDs4vrqy01Gki8F96ziJMvOtYdMsq
	 eTcaYt983imPVoXS7lR6mUlC6TbWwUxoPuj2fYCLhEKdccaDd0q6OZGE5W0eQzhpg3uWH
	 KLXcU1oO/SGhDKlvn97GfjfCv+RDFeeVjEYDKVQmixKyj1JnWeBcqQjQT0yun9wVyN5yJ
	 rTtPjHATENdIEisCyvYADz1tsDpeMwKxirl8lwYMnT5qd4QxOBDDo2OYgVN5Y1Oe7kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962940;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TZeoHkr/pxx3BmTn/Pfgy9HpgaQN/+V8W+yqYyq3Xbg=;
	b=raKjLpsb4h9kpIaAjfey7dx23eNURvbvnEciWpcqgsV2CxRhtLPJOl+yas+3fOxCAsq2
	 gDLNdsXnXhzErPDV8gAEzjESHrOrF4V/lqbNlzyn4F1y8eCHcI5fPdpH/oIL7iTJ5eImq
	 vIFgIxlp6WDnMaBDMh8t2OKr94Ww+OB5tWjoI2UWJHFKoTx2ANbXNpDFb0Nq7LLWte8ho
	 buZOdZY/gt+DFGShlGJYDceUPoHSWSFNjNrVxdi/omWSTN0uJODb97/Vd3EOQvGaTmucZ
	 D7peMgzy+OvOw8EQnPMQcjsQdCg8I8oIzWoTIdZKI52qUB61n+GltyAN0v290MZE/Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dubeyko.com;
	spf=pass smtp.mailfrom=dubeyko.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fbxVwi35;
	arc=none smtp.remote-ip=74.125.224.54
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A078606A885
	for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 00:49:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A078606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fbxVwi35
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-67dabd38cdfso358434d50.2
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 16:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20260707.gappssmtp.com; s=20260707; t=1794962939; x=1795567739; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TZeoHkr/pxx3BmTn/Pfgy9HpgaQN/+V8W+yqYyq3Xbg=;
        b=fbxVwi35SWKD4JkD9DHQJpbHpVC20TpvUheD4AlRcgsCmKKFcsEawPPiW7Z8dxUH5J
         /sVdDXmiIhV2zFJ8Ar+WoCE8L1YcKJBHI9IB2dozEB2rmbtF0fHcOPIjJJnShfcMtRgl
         Pt0gTtXFWVDdtNIVfF7KKvKQrCGwx8nh6PDJcWsHPQiv+SqMutL3G+0gv+n6vl+Ewqm2
         8h0lhidPzI7V4DmCYdM3vEyPLW9h734QBmiSyWa1dnRhv76nmRgHImRj+NTTTXolY8tB
         s6YxxV4iPQR3vchVck6bu6LOKLy195hp6dd/xPWz6u2uvrLr7heqePcSOR1DxPOQdDuW
         XQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794962939; x=1795567739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TZeoHkr/pxx3BmTn/Pfgy9HpgaQN/+V8W+yqYyq3Xbg=;
        b=1eExyHMoxjCToiYi802o2cHl5QZq6eSQJ82EPhoBdaoU1toCh52+R70lse0nuuU1h5
         OSLtyfP7ICS1Y25SfFVQFTCRXGyVPhtxNRXcS8FQ3esCUXfrpWqwzm3/XQsajVfkYg8S
         0hemWJT59FnJ1l+pDIG5QcI9MFwT2PIuKM9882kmIaPM8PRs2caHoD8vVHYk7xa3+d3q
         9cAGaZxOSxaCLKgoa8fjPfBtXPFc02FvLsjXSeOrXnU/xrh8ysrFvbvNxDInASeTOPhU
         v4LOanGs9pBTlSoV8zgVfOsoR550XZGiEAiiXADYLnZ0q4UMburSpGNSvmRuLUXIe+4+
         Pxhw==
X-Forwarded-Encrypted: i=1; AL+hErErcSDQl9nPXXaApdASWU2Mvx1dGeCJjHGlUazsiEYVfqLE9QGzECAQxmRjZQxYMpXOCZeIIwYUwsM=@vger.kernel.org
X-Gm-Message-State: APuU4Z/dZH/Yi8vRzbB33y0CaZWzksIZ0h8Et9p/Cr/D6Vqpd5McT3mt
	tDx9W7l55MLCtgHDHkzW+YLPujz5ggRWX9cFWxcrlEZgr47TZtqkKyENDkwpH5HL+tA=
X-Gm-Gg: AZFdTZdO+yM/ZGtiwU0ZXl09XazFxcnW4wmnfrf+/lQ5xx60bTPopiMrQd9GZqX8Phb
	a5ceGA1FdqUKWJYTKlzORrUj6di0DEtaxJr5IhrXWkA7683P0SYUbOqcbvcw7T0Oe7iDV5mT4vs
	zPeKsW0EPJNIcuGAkhk/oJILwFGh2Pxzq+B/C/2PuyaxrVBbxLoNBsLLjn5Te+yL7Hy0SvB9YLh
	fITIJUPqxW9MbsxkeAbTITWEfE2kKwcklZ6JgGc4Ifmlzv2JHTGM041CtHRPKP55QyrSW6OcNVa
	Bv6FtAB0vEqcZEp9sYjdWvBJO1TbdMDmFNLsV029QcgcbgH/ZcdEv8gV6DziWSMt+vYRvF0Zuah
	gf4rnkF/EPb8HMmdKETKjoB18XnsJvV5WNTO3Ik5DfT7+d/3qg+CAPH0SQ3C80ombJVrTKH7auN
	2vM+AXJP/Uv2z7Q9Zhw2rUolBh8Yc6+8U71G3wtqHOAXxGZxagUcthq+wo/Zv+ZhpDmpau4cd7x
	t1oEGrdSeR+BD1LfscmQVNL5TbBJia2o6pZneXuAmvB0kjLx3Vwq4Cl/K4YEq+IjYsHAwKevYf5
	5G7QaO6lKv9Hpxl+ovDy93a0FHHMCZdqJPv4nsnwULR9FfwhdPiwQCchfFfnmXvBtbER7iYDl/z
	+Xr1SISvBx/4mLKafziuPm6GfFJZnAFuH0vShKSU+qdlamjE/+HIZ3xBO/O/SjcTeiux25TNO
X-Received: by 2002:a05:690e:40c:b0:67d:c2d1:5f31 with SMTP id 956f58d0204a3-67dd3fe03d9mr410438d50.57.1794962939086;
        Tue, 17 Nov 2026 16:48:59 -0800 (PST)
Received: from system76-laptop.attlocal.net ([2600:1700:6476:1430:5fae:4d02:7055:94ad])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67dd56ead87sm729575d50.1.2026.11.17.16.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:48:58 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: glaubitz@physik.fu-berlin.de,
	frank.li@vivo.com,
	hch@lst.de
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	vdubeyko@coreweave.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v5 2/5] hfsplus: move file related operations to file.c
Date: Tue, 17 Nov 2026 16:48:41 -0800
Message-ID: <20261118004844.3849979-3-slava@dubeyko.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118004844.3849979-1-slava@dubeyko.com>
References: <20261118004844.3849979-1-slava@dubeyko.com>
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

This patch introduces fs/hfsplus/file.c and moves
file related operations from fs/hfsplus/inode.c
into the new file.

cc: Christoph Hellwig <hch@lst.de>
cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Yangtao Li <frank.li@vivo.com>
cc: linux-fsdevel@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
---
 fs/hfsplus/Makefile     |   5 +-
 fs/hfsplus/file.c       | 127 ++++++++++++++++++++++++++++++++++++++++
 fs/hfsplus/hfsplus_fs.h |   7 ++-
 fs/hfsplus/inode.c      | 119 -------------------------------------
 4 files changed, 135 insertions(+), 123 deletions(-)
 create mode 100644 fs/hfsplus/file.c

diff --git a/fs/hfsplus/Makefile b/fs/hfsplus/Makefile
index f2a9ae697e81..82738ce7ca4d 100644
--- a/fs/hfsplus/Makefile
+++ b/fs/hfsplus/Makefile
@@ -5,8 +5,9 @@
 
 obj-$(CONFIG_HFSPLUS_FS) += hfsplus.o
 
-hfsplus-objs := super.o options.o inode.o ioctl.o extents.o catalog.o dir.o btree.o \
-		bnode.o brec.o bfind.o tables.o unicode.o wrapper.o bitmap.o part_tbl.o \
+hfsplus-objs := super.o options.o inode.o file.o ioctl.o extents.o catalog.o dir.o \
+		btree.o bnode.o brec.o bfind.o tables.o unicode.o wrapper.o bitmap.o \
+		part_tbl.o \
 		attributes.o xattr.o xattr_user.o xattr_security.o xattr_trusted.o
 
 # KUnit tests
diff --git a/fs/hfsplus/file.c b/fs/hfsplus/file.c
new file mode 100644
index 000000000000..6b14095b2aa6
--- /dev/null
+++ b/fs/hfsplus/file.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/fs.h>
+#include <linux/uio.h>
+#include <linux/mount.h>
+
+#include "hfsplus_fs.h"
+#include "hfsplus_raw.h"
+
+static int hfsplus_file_open(struct inode *inode, struct file *file)
+{
+	if (HFSPLUS_IS_RSRC(inode))
+		inode = HFSPLUS_I(inode)->rsrc_inode;
+	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
+		return -EOVERFLOW;
+	atomic_inc(&HFSPLUS_I(inode)->opencnt);
+	return 0;
+}
+
+static int hfsplus_file_release(struct inode *inode, struct file *file)
+{
+	struct super_block *sb = inode->i_sb;
+
+	if (HFSPLUS_IS_RSRC(inode))
+		inode = HFSPLUS_I(inode)->rsrc_inode;
+	if (atomic_dec_and_test(&HFSPLUS_I(inode)->opencnt)) {
+		inode_lock(inode);
+		hfsplus_file_truncate(inode);
+		if (inode->i_flags & S_DEAD) {
+			hfsplus_delete_cat(inode->i_ino,
+					   HFSPLUS_SB(sb)->hidden_dir, NULL);
+			hfsplus_delete_inode(inode);
+		}
+		inode_unlock(inode);
+	}
+	return 0;
+}
+
+int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
+		       int datasync)
+{
+	struct inode *inode = file->f_mapping->host;
+	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
+	struct hfsplus_vh *vhdr = sbi->s_vhdr;
+	int error = 0, error2;
+
+	hfs_dbg("inode->i_ino %llu, start %llu, end %llu\n",
+		inode->i_ino, start, end);
+
+	error = file_write_and_wait_range(file, start, end);
+	if (error)
+		return error;
+
+	/*
+	 * Sync inode metadata into the catalog and extent trees.
+	 */
+	sync_inode_metadata(inode, 1);
+
+	/*
+	 * And explicitly write out the btrees.
+	 */
+	if (test_and_clear_bit(HFSPLUS_I_CAT_DIRTY,
+				&HFSPLUS_I(HFSPLUS_CAT_TREE_I(sb))->flags)) {
+		clear_bit(HFSPLUS_I_CAT_DIRTY, &hip->flags);
+		error = filemap_write_and_wait(sbi->cat_tree->inode->i_mapping);
+	}
+
+	if (test_and_clear_bit(HFSPLUS_I_EXT_DIRTY,
+				&HFSPLUS_I(HFSPLUS_EXT_TREE_I(sb))->flags)) {
+		clear_bit(HFSPLUS_I_EXT_DIRTY, &hip->flags);
+		error2 =
+			filemap_write_and_wait(sbi->ext_tree->inode->i_mapping);
+		if (!error)
+			error = error2;
+	}
+
+	if (sbi->attr_tree) {
+		if (test_and_clear_bit(HFSPLUS_I_ATTR_DIRTY,
+				&HFSPLUS_I(HFSPLUS_ATTR_TREE_I(sb))->flags)) {
+			clear_bit(HFSPLUS_I_ATTR_DIRTY, &hip->flags);
+			error2 =
+				filemap_write_and_wait(
+					    sbi->attr_tree->inode->i_mapping);
+			if (!error)
+				error = error2;
+		}
+	} else {
+		if (test_and_clear_bit(HFSPLUS_I_ATTR_DIRTY, &hip->flags))
+			pr_err("sync non-existent attributes tree\n");
+	}
+
+	if (test_and_clear_bit(HFSPLUS_I_ALLOC_DIRTY,
+				&HFSPLUS_I(sbi->alloc_file)->flags)) {
+		clear_bit(HFSPLUS_I_ALLOC_DIRTY, &hip->flags);
+		error2 = filemap_write_and_wait(sbi->alloc_file->i_mapping);
+		if (!error)
+			error = error2;
+	}
+
+	mutex_lock(&sbi->vh_mutex);
+	hfsplus_prepare_volume_header_for_commit(vhdr);
+	mutex_unlock(&sbi->vh_mutex);
+
+	error2 = hfsplus_commit_superblock(inode->i_sb);
+	if (!error)
+		error = error2;
+
+	if (!test_bit(HFSPLUS_SB_NOBARRIER, &sbi->flags))
+		blkdev_issue_flush(inode->i_sb->s_bdev);
+
+	return error;
+}
+
+const struct file_operations hfsplus_file_operations = {
+	.llseek		= generic_file_llseek,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
+	.mmap_prepare	= generic_file_mmap_prepare,
+	.splice_read	= filemap_splice_read,
+	.splice_write	= iter_file_splice_write,
+	.fsync		= hfsplus_file_fsync,
+	.open		= hfsplus_file_open,
+	.release	= hfsplus_file_release,
+	.unlocked_ioctl = hfsplus_ioctl,
+};
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index dd88053cc9b3..554733128fed 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -436,6 +436,11 @@ int hfsplus_rename_cat(u32 cnid, struct inode *src_dir, const struct qstr *src_n
 extern const struct inode_operations hfsplus_dir_inode_operations;
 extern const struct file_operations hfsplus_dir_operations;
 
+/* file.c */
+extern const struct file_operations hfsplus_file_operations;
+int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
+		       int datasync);
+
 /* extents.c */
 int hfsplus_ext_cmp_key(const hfsplus_btree_key *k1,
 			const hfsplus_btree_key *k2);
@@ -468,8 +473,6 @@ int hfsplus_cat_write_inode(struct inode *inode);
 int hfsplus_getattr(const struct mnt_idmap *idmap, const struct path *path,
 		    struct kstat *stat, u32 request_mask,
 		    unsigned int query_flags);
-int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
-		       int datasync);
 int hfsplus_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
 int hfsplus_fileattr_set(const struct mnt_idmap *idmap,
 			 struct dentry *dentry, struct file_kattr *fa);
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 8073fb99217d..b43422155e7e 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -269,35 +269,6 @@ static int hfsplus_get_perms(struct inode *inode,
 	return -EIO;
 }
 
-static int hfsplus_file_open(struct inode *inode, struct file *file)
-{
-	if (HFSPLUS_IS_RSRC(inode))
-		inode = HFSPLUS_I(inode)->rsrc_inode;
-	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
-		return -EOVERFLOW;
-	atomic_inc(&HFSPLUS_I(inode)->opencnt);
-	return 0;
-}
-
-static int hfsplus_file_release(struct inode *inode, struct file *file)
-{
-	struct super_block *sb = inode->i_sb;
-
-	if (HFSPLUS_IS_RSRC(inode))
-		inode = HFSPLUS_I(inode)->rsrc_inode;
-	if (atomic_dec_and_test(&HFSPLUS_I(inode)->opencnt)) {
-		inode_lock(inode);
-		hfsplus_file_truncate(inode);
-		if (inode->i_flags & S_DEAD) {
-			hfsplus_delete_cat(inode->i_ino,
-					   HFSPLUS_SB(sb)->hidden_dir, NULL);
-			hfsplus_delete_inode(inode);
-		}
-		inode_unlock(inode);
-	}
-	return 0;
-}
-
 static int hfsplus_setattr(const struct mnt_idmap *idmap,
 			   struct dentry *dentry, struct iattr *attr)
 {
@@ -354,83 +325,6 @@ int hfsplus_getattr(const struct mnt_idmap *idmap, const struct path *path,
 	return 0;
 }
 
-int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
-		       int datasync)
-{
-	struct inode *inode = file->f_mapping->host;
-	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
-	struct super_block *sb = inode->i_sb;
-	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
-	struct hfsplus_vh *vhdr = sbi->s_vhdr;
-	int error = 0, error2;
-
-	hfs_dbg("inode->i_ino %llu, start %llu, end %llu\n",
-		inode->i_ino, start, end);
-
-	error = file_write_and_wait_range(file, start, end);
-	if (error)
-		return error;
-
-	/*
-	 * Sync inode metadata into the catalog and extent trees.
-	 */
-	sync_inode_metadata(inode, 1);
-
-	/*
-	 * And explicitly write out the btrees.
-	 */
-	if (test_and_clear_bit(HFSPLUS_I_CAT_DIRTY,
-				&HFSPLUS_I(HFSPLUS_CAT_TREE_I(sb))->flags)) {
-		clear_bit(HFSPLUS_I_CAT_DIRTY, &hip->flags);
-		error = filemap_write_and_wait(sbi->cat_tree->inode->i_mapping);
-	}
-
-	if (test_and_clear_bit(HFSPLUS_I_EXT_DIRTY,
-				&HFSPLUS_I(HFSPLUS_EXT_TREE_I(sb))->flags)) {
-		clear_bit(HFSPLUS_I_EXT_DIRTY, &hip->flags);
-		error2 =
-			filemap_write_and_wait(sbi->ext_tree->inode->i_mapping);
-		if (!error)
-			error = error2;
-	}
-
-	if (sbi->attr_tree) {
-		if (test_and_clear_bit(HFSPLUS_I_ATTR_DIRTY,
-				&HFSPLUS_I(HFSPLUS_ATTR_TREE_I(sb))->flags)) {
-			clear_bit(HFSPLUS_I_ATTR_DIRTY, &hip->flags);
-			error2 =
-				filemap_write_and_wait(
-					    sbi->attr_tree->inode->i_mapping);
-			if (!error)
-				error = error2;
-		}
-	} else {
-		if (test_and_clear_bit(HFSPLUS_I_ATTR_DIRTY, &hip->flags))
-			pr_err("sync non-existent attributes tree\n");
-	}
-
-	if (test_and_clear_bit(HFSPLUS_I_ALLOC_DIRTY,
-				&HFSPLUS_I(sbi->alloc_file)->flags)) {
-		clear_bit(HFSPLUS_I_ALLOC_DIRTY, &hip->flags);
-		error2 = filemap_write_and_wait(sbi->alloc_file->i_mapping);
-		if (!error)
-			error = error2;
-	}
-
-	mutex_lock(&sbi->vh_mutex);
-	hfsplus_prepare_volume_header_for_commit(vhdr);
-	mutex_unlock(&sbi->vh_mutex);
-
-	error2 = hfsplus_commit_superblock(inode->i_sb);
-	if (!error)
-		error = error2;
-
-	if (!test_bit(HFSPLUS_SB_NOBARRIER, &sbi->flags))
-		blkdev_issue_flush(inode->i_sb->s_bdev);
-
-	return error;
-}
-
 static const struct inode_operations hfsplus_file_inode_operations = {
 	.setattr	= hfsplus_setattr,
 	.getattr	= hfsplus_getattr,
@@ -452,19 +346,6 @@ static const struct inode_operations hfsplus_special_inode_operations = {
 	.listxattr	= hfsplus_listxattr,
 };
 
-static const struct file_operations hfsplus_file_operations = {
-	.llseek		= generic_file_llseek,
-	.read_iter	= generic_file_read_iter,
-	.write_iter	= generic_file_write_iter,
-	.mmap_prepare	= generic_file_mmap_prepare,
-	.splice_read	= filemap_splice_read,
-	.splice_write	= iter_file_splice_write,
-	.fsync		= hfsplus_file_fsync,
-	.open		= hfsplus_file_open,
-	.release	= hfsplus_file_release,
-	.unlocked_ioctl = hfsplus_ioctl,
-};
-
 struct inode *hfsplus_new_inode(struct super_block *sb, struct inode *dir,
 				umode_t mode)
 {
-- 
2.53.0

