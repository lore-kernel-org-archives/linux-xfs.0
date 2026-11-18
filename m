Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794962946;
	b=Y7otaOmqk2Ct/jPDfctJAXiSsMw1QEbOt/omZRdQpA1JdgKW8nWHncK2GpjnY+qd5T/a
	 qpynyTpJm/wcQnYW1fWvU2yvpSw8yF/FzX1In8BMeiDoStFyWhTOxxMQsnE/HFt5x4+nz
	 5d+PCA73+JoX+fin+tc72GlLhbMR7OvyCwF91Nd9wgcf/1aNYdPy9WdpM0Zp8eLxFv0dc
	 +kQI2ZXkq3euY9pw0vpIJXVZ6g7FFpAmZomEO9q2U7h3vW2uWsczg4NKgD1Cs05YYcPQu
	 lpAzLqYic9KwDrdn5khSf/Ej76PW337g87j/FLmQ855L/6/kDtIPGgOWx7+jLN4hA1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962946;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=70D/XfXA7IPfb0M2FCAo3a9RzZwIJbVOPAygShErvBI=;
	b=Iz5L9/bXP6tfrfrGarwbDZ7mnU33NoFVS8QaOoICMd6aeMl0wJb2ti9gqKG4s1mgJHSx
	 NSMT9mQyxdofsGFRC/wawqweI/zrwQhyizupAgsCraSKJyVzE0jO70zVZ/hoXEFgEZfMC
	 y7rXRu1eAizQySwCPh6zu+SR3Dmk/sy6d9DPHY3I7yb+m2G5gAw9U3SMVvC7UZJ9RtgK/
	 6HXNryR0KBwwStI+iikuRat7/2Ypke1J4kB65V9eW9VbDGnVuUkGQo8qkHf/4s46SyEqb
	 LYDYOot/Ue3lGqrH0n2kwSoDX8Huqp7Ao9UYzBxzZ7TTf51uauDQiz501zMo9O4puFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dubeyko.com;
	spf=pass smtp.mailfrom=dubeyko.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OiRdaden;
	arc=none smtp.remote-ip=209.85.128.175
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B700606A89A
	for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 00:49:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B700606A89A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OiRdaden
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8b4ea3c5afaso2844857b3.1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 16:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20260707.gappssmtp.com; s=20260707; t=1794962944; x=1795567744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=70D/XfXA7IPfb0M2FCAo3a9RzZwIJbVOPAygShErvBI=;
        b=OiRdadencFC/PnGmob23saGQPUhJByXUf/OEvpMjjTAhJqxygXY0o6FaLhVW/YCTC1
         fZkQlx8wri45EF8+ERCo8KfvhNeNvf9FsyHBIearrY4ghEj8WY8gD+fJyTfq2nYZZSwz
         jWcd5lA/W2bDBj6LbSskmXU0WKY3cASpra4EiraJLHkd9iDvSvWySQapp/zoQjZodgtt
         pew4WLNSV3c18N+WI7+MXQ1BSw/wIQfoSG/nxSSa7Gb+um0kr4Q4RNxdO2hs6eaKAS4F
         30uay38zO85zIxF1MU51ucn30Aup6fseRL91IeePGFKF+/zrnzkwEDSEQfMb8BDw0Z4I
         JIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794962944; x=1795567744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=70D/XfXA7IPfb0M2FCAo3a9RzZwIJbVOPAygShErvBI=;
        b=l2nIuIGnRVKy5GFac1LbsaPE+ffxBK4nc4Nb+kdjzjZR4cajHIOgYN30apSrUpO/MB
         QBYtC76VQb8UCf+JSChlT/ukqBLxSmW6m2isbrS4JvRabkuPol2/sO2t8vxQ+gPCf16e
         x0KktvxB5O+KQoa1VHcms+KEEtjpJ4TCAFGiSSx7xNvfUul7q22t3XaCgHu+9blV+bLb
         vtuwHUKg2FlnweQSyjpykcplcY29O9xqqbv6+Tww5Qma8vjrTLtIfrpO2Wl1jfnbkftl
         FAmr5mGXv2J/jbki4ms87ybhwWHPnqyXJnKtMwOGP4LXgoeJ7nqBwcb4R/f7RcoCZqVf
         Brnw==
X-Forwarded-Encrypted: i=1; AL+hErH6C+ZOcKQs6a+DOEbMiiNRgntd40qnb85bp7MfsgL0dX/3BfrJhLr3BZSQF17tMGpXfFCcda35Ef4=@vger.kernel.org
X-Gm-Message-State: APuU4Z9PVA48ga1uCMEGwHLW7uGhZx4pzNz2s0HOLzcPwgh+ifIXnVp+
	cfkpbhxMXRPIKqRoSvHsAafX+/VYvSDbS0ydNQMsjfSD9hoa3L1nt8uyOcMJ6mfGSnU=
X-Gm-Gg: AZFdTZd1SUL8PSBN+oJG9T2wG2dRULls+lenXg5BHIOoOdB7ul5/r3auuVaEWK/ZrCi
	nRV8gkkUFw4KXBNwS+7l7t8fNbLDFWl4X+GHoHnLpII4ucNB8wFLkecI/Z9Zv7XYiTh2vyel8P0
	h3b95gStJAXQbFnqXKmn2cOgxUmUiS1e/T6QMlIKdlMc9TwcvJJ1JHNHtLYoNgBEPuLe5Dognbw
	+ZdsulmCE5GWkddjcEMXTgF6Rd0FZ+5rbEcCYiobcS7y5sukcMLQa5DWL6hRS3iIv7txTugIqey
	7i15kdS8Hs3m0s7CzsbzKEsSlWSFOs1I4mpImMW4EtaJVDzKyIJckqKuj7pL3TtfGNUFYWYkjW7
	1v8f8Vpi0t9ehUg1o8PRNo4aihhCa5RWde5r6+Ao5peDTdRAobzPCbScaqwWACOs3aIlwvFU95M
	kakZeuWizaVCS7KdQQW+41lwUVVvpfQQ9LkErBc/JE0kT3ShdUck4cfNnscAQcf+WZXO81Zzg4r
	tkyZLjnLhxSyeGkFHPp5U93r61qacwh6eK4zgdlzlNbLZUX/etL8uJIV3zHNSfxfVMpd6BGSw96
	SGAKK9faWxzwn4zQ3Z7PlYtO2xTJM3kqdTM+T4tNFnU+F2SA/gADsZl8wS5qtonvwXVJz+4Zz6h
	OCKFloWOMx0y2QgFKHNXBHUJyahHmbBtEmCcyfes1J1yDtQL9Vp5Qy+8+/o7s42VeIlKRYAQ=
X-Received: by 2002:a05:690c:d94:b0:8b0:8e22:d937 with SMTP id 00721157ae682-8b4fecfc3c3mr4128917b3.33.1794962944211;
        Tue, 17 Nov 2026 16:49:04 -0800 (PST)
Received: from system76-laptop.attlocal.net ([2600:1700:6476:1430:5fae:4d02:7055:94ad])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67dd56ead87sm729575d50.1.2026.11.17.16.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:49:03 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: glaubitz@physik.fu-berlin.de,
	frank.li@vivo.com,
	hch@lst.de
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	vdubeyko@coreweave.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v5 5/5] hfsplus: convert regular file I/O to iomap
Date: Tue, 17 Nov 2026 16:48:44 -0800
Message-ID: <20261118004844.3849979-6-slava@dubeyko.com>
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

Switch the HFS+ regular file data path from buffer heads and
blockdev_direct_IO() to iomap.

Add iomap.h and iomap.c with hfsplus_iomap_ops,
hfsplus_write_iomap_ops, hfsplus_writeback_ops and
hfsplus_write_dio_ops. iomap.c implements __hfsplus_iomap_begin(),
hfsplus_write_iomap_end(), hfsplus_iomap_cont_expand() and
hfsplus_writeback_range(), which are the basis of the HFS+ iomap
operations. Direct write completion uses the generic
iomap_dio_end_io() helper.

Implement iomap-based hfsplus_file_llseek(), hfsplus_file_read_iter()
and hfsplus_file_write_iter(). The volume capacity limit for writes is
enforced by generic_write_checks(), since s_maxbytes is already set
from the volume capacity.

Redefine hfsplus_aops as iomap-based operations for regular files.
As a result, hfsplus_direct_IO() is removed as a user of
blockdev_direct_IO(), and the LEGACY_DIRECT_IO dependency is dropped
from Kconfig. hfsplus_file_truncate() extends regular files by means
of hfsplus_iomap_cont_expand(), while other inodes still use the
write_begin/write_end path.

HFS+ does not support holes, so a write or truncate that extends a
file first zero-fills the range between the old end-of-file and the
new one by means of hfsplus_iomap_cont_expand(). Introduce
hfsplus_iomap_extend_size() that grows i_size, zero-fills the gap and
rolls back on failure, and use it in hfsplus_file_write_iter() and
hfsplus_setattr(). Introduce hfsplus_iomap_size_rollback() that waits
for in-flight direct I/O, sets i_size, truncates the page cache beyond
it and calls hfsplus_file_truncate() to release the blocks allocated
past it. It is not called when phys_size is below the new size, since
hfsplus_file_truncate() would zero-fill again in that case.

In hfsplus_file_write_iter(), roll back after the data write if fewer
bytes than requested were written: to the original size if nothing
was written, or to the current i_size after a short write. Queued
asynchronous direct I/O is skipped, because direct I/O beyond
phys_size is forced to be synchronous, so a queued request never
extends the file.

cc: Christoph Hellwig <hch@lst.de>
cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Yangtao Li <frank.li@vivo.com>
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
---
 fs/hfsplus/Kconfig      |   2 +-
 fs/hfsplus/Makefile     |   6 +-
 fs/hfsplus/extents.c    |  40 +++++--
 fs/hfsplus/file.c       | 187 ++++++++++++++++++++++++++++-
 fs/hfsplus/hfsplus_fs.h |  17 +++
 fs/hfsplus/inode.c      | 155 ++++++++++++------------
 fs/hfsplus/iomap.c      | 254 ++++++++++++++++++++++++++++++++++++++++
 fs/hfsplus/iomap.h      |  17 +++
 8 files changed, 583 insertions(+), 95 deletions(-)
 create mode 100644 fs/hfsplus/iomap.c
 create mode 100644 fs/hfsplus/iomap.h

diff --git a/fs/hfsplus/Kconfig b/fs/hfsplus/Kconfig
index ca8401cb6954..b4432c64db3b 100644
--- a/fs/hfsplus/Kconfig
+++ b/fs/hfsplus/Kconfig
@@ -5,7 +5,7 @@ config HFSPLUS_FS
 	select BUFFER_HEAD
 	select NLS
 	select NLS_UTF8
-	select LEGACY_DIRECT_IO
+	select FS_IOMAP
 	help
 	  If you say Y here, you will be able to mount extended format
 	  Macintosh-formatted hard drive partitions with full read-write access.
diff --git a/fs/hfsplus/Makefile b/fs/hfsplus/Makefile
index 82738ce7ca4d..3ddea69a9c69 100644
--- a/fs/hfsplus/Makefile
+++ b/fs/hfsplus/Makefile
@@ -5,9 +5,9 @@
 
 obj-$(CONFIG_HFSPLUS_FS) += hfsplus.o
 
-hfsplus-objs := super.o options.o inode.o file.o ioctl.o extents.o catalog.o dir.o \
-		btree.o bnode.o brec.o bfind.o tables.o unicode.o wrapper.o bitmap.o \
-		part_tbl.o \
+hfsplus-objs := super.o options.o inode.o file.o iomap.o ioctl.o extents.o \
+		catalog.o dir.o btree.o bnode.o brec.o bfind.o tables.o \
+		unicode.o wrapper.o bitmap.o part_tbl.o \
 		attributes.o xattr.o xattr_user.o xattr_security.o xattr_trusted.o
 
 # KUnit tests
diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index bb5a1508498d..0928d64684aa 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -15,6 +15,7 @@
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
+#include "iomap.h"
 
 /* Compare two extents keys, returns 0 on same, pos/neg for difference */
 int hfsplus_ext_cmp_key(const hfsplus_btree_key *k1,
@@ -610,20 +611,33 @@ void hfsplus_file_truncate(struct inode *inode)
 		inode->i_ino, (long long)hip->phys_size, inode->i_size);
 
 	if (inode->i_size > hip->phys_size) {
-		struct address_space *mapping = inode->i_mapping;
-		struct folio *folio;
-		void *fsdata = NULL;
-		loff_t size = inode->i_size;
+		if (S_ISREG(inode->i_mode)) {
+			res = hfsplus_iomap_cont_expand(inode, hip->phys_size,
+							inode->i_size);
+			if (res)
+				return;
+
+			mark_inode_dirty(inode);
+		} else {
+			struct address_space *mapping = inode->i_mapping;
+			struct folio *folio;
+			void *fsdata = NULL;
+
+			res = hfsplus_write_begin(NULL, mapping,
+						  inode->i_size, 0,
+						  &folio, &fsdata);
+			if (res)
+				return;
+
+			res = generic_write_end(NULL, mapping,
+						inode->i_size, 0, 0,
+						folio, fsdata);
+			if (res < 0)
+				return;
+
+			mark_inode_dirty(inode);
+		}
 
-		res = hfsplus_write_begin(NULL, mapping, size, 0,
-					  &folio, &fsdata);
-		if (res)
-			return;
-		res = generic_write_end(NULL, mapping, size, 0, 0,
-					folio, fsdata);
-		if (res < 0)
-			return;
-		mark_inode_dirty(inode);
 		return;
 	}
 
diff --git a/fs/hfsplus/file.c b/fs/hfsplus/file.c
index 6b14095b2aa6..f34cd80351e5 100644
--- a/fs/hfsplus/file.c
+++ b/fs/hfsplus/file.c
@@ -3,9 +3,11 @@
 #include <linux/fs.h>
 #include <linux/uio.h>
 #include <linux/mount.h>
+#include <linux/iomap.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
+#include "iomap.h"
 
 static int hfsplus_file_open(struct inode *inode, struct file *file)
 {
@@ -14,6 +16,7 @@ static int hfsplus_file_open(struct inode *inode, struct file *file)
 	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
 		return -EOVERFLOW;
 	atomic_inc(&HFSPLUS_I(inode)->opencnt);
+	file->f_mode |= FMODE_CAN_ODIRECT;
 	return 0;
 }
 
@@ -113,10 +116,188 @@ int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
 	return error;
 }
 
+/*
+ * Fall back to buffered I/O for the tail of a write that
+ * iomap_dio_rw() could not perform directly (unaligned tail,
+ * or no blocks could be mapped without allocation
+ * outside the direct path).
+ */
+static ssize_t hfsplus_fallback_buffered_write(struct kiocb *iocb,
+						struct iov_iter *from)
+{
+	loff_t offset = iocb->ki_pos, end;
+	ssize_t written;
+	int ret;
+
+	iocb->ki_flags &= ~IOCB_DIRECT;
+
+	written = iomap_file_buffered_write(iocb, from,
+					    &hfsplus_write_iomap_ops,
+					    NULL, NULL);
+	if (written < 0)
+		return written;
+
+	end = iocb->ki_pos + written - 1;
+	ret = filemap_write_and_wait_range(iocb->ki_filp->f_mapping,
+					   offset, end);
+	if (ret)
+		return -EIO;
+
+	invalidate_mapping_pages(iocb->ki_filp->f_mapping,
+				 offset >> PAGE_SHIFT,
+				 end >> PAGE_SHIFT);
+
+	return written;
+}
+
+static ssize_t hfsplus_dio_write_iter(struct kiocb *iocb,
+					struct iov_iter *from,
+					unsigned int dio_flags)
+{
+	ssize_t ret;
+
+	ret = iomap_dio_rw(iocb, from,
+			   &hfsplus_write_iomap_ops,
+			   &hfsplus_write_dio_ops,
+			   dio_flags, NULL, 0);
+	if (ret == -ENOTBLK)
+		ret = 0;
+	else if (ret < 0)
+		return ret;
+
+	if (iov_iter_count(from)) {
+		ssize_t written;
+
+		written = hfsplus_fallback_buffered_write(iocb, from);
+		if (written < 0)
+			return written;
+		ret += written;
+	}
+
+	return ret;
+}
+
+static ssize_t hfsplus_file_write_iter(struct kiocb *iocb,
+					struct iov_iter *iter)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+	loff_t old_size;
+	ssize_t count;
+	ssize_t ret;
+	int err;
+
+	inode_lock(inode);
+
+	ret = generic_write_checks(iocb, iter);
+	if (ret <= 0)
+		goto unlock;
+
+	count = ret;
+	old_size = i_size_read(inode);
+
+	err = file_modified(file);
+	if (err) {
+		ret = err;
+		goto unlock;
+	}
+
+	if (iocb->ki_pos > i_size_read(inode)) {
+		err = hfsplus_iomap_extend_size(inode, iocb->ki_pos);
+		if (err) {
+			ret = err;
+			goto unlock;
+		}
+		mark_inode_dirty(inode);
+	}
+
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		unsigned int dio_flags = 0;
+
+		if (iocb->ki_pos + iov_iter_count(iter) >
+		    HFSPLUS_I(inode)->phys_size)
+			dio_flags |= IOMAP_DIO_FORCE_WAIT;
+
+		ret = hfsplus_dio_write_iter(iocb, iter, dio_flags);
+	} else {
+		ret = iomap_file_buffered_write(iocb, iter,
+						&hfsplus_write_iomap_ops,
+						NULL, NULL);
+	}
+
+	/*
+	 * On a failed write, undo the zero-filled extension so that the
+	 * file keeps its original size. On a short write, keep what was
+	 * written. Either way, release the blocks allocated beyond the
+	 * resulting end-of-file. Queued async direct I/O never extends
+	 * the file (it is forced synchronous beyond phys_size), so there
+	 * is nothing to undo for it.
+	 */
+	if (ret != -EIOCBQUEUED && ret < count) {
+		hfsplus_iomap_size_rollback(inode,
+					    ret > 0 ? i_size_read(inode) :
+						      old_size);
+	}
+
+unlock:
+	inode_unlock(inode);
+
+	if (ret > 0)
+		ret = generic_write_sync(iocb, ret);
+
+	return ret;
+}
+
+static ssize_t hfsplus_file_read_iter(struct kiocb *iocb,
+					struct iov_iter *iter)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	ssize_t ret;
+
+	inode_lock_shared(inode);
+
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		file_accessed(iocb->ki_filp);
+		ret = iomap_dio_rw(iocb, iter,
+				   &hfsplus_iomap_ops,
+				   NULL, 0, NULL, 0);
+	} else
+		ret = generic_file_read_iter(iocb, iter);
+
+	inode_unlock_shared(inode);
+
+	return ret;
+}
+
+static loff_t hfsplus_file_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	switch (whence) {
+	case SEEK_HOLE:
+		inode_lock_shared(inode);
+		offset = iomap_seek_hole(inode, offset, &hfsplus_iomap_ops);
+		inode_unlock_shared(inode);
+		break;
+	case SEEK_DATA:
+		inode_lock_shared(inode);
+		offset = iomap_seek_data(inode, offset, &hfsplus_iomap_ops);
+		inode_unlock_shared(inode);
+		break;
+	default:
+		return generic_file_llseek(file, offset, whence);
+	}
+
+	if (offset < 0)
+		return offset;
+
+	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
+}
+
 const struct file_operations hfsplus_file_operations = {
-	.llseek		= generic_file_llseek,
-	.read_iter	= generic_file_read_iter,
-	.write_iter	= generic_file_write_iter,
+	.llseek		= hfsplus_file_llseek,
+	.read_iter	= hfsplus_file_read_iter,
+	.write_iter	= hfsplus_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 0b07259041f9..abd5857cac2b 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -176,6 +176,22 @@ static inline struct hfsplus_sb_info *HFSPLUS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+/*
+ * Physical byte offset of allocation block 'dblock' on the volume.
+ */
+static inline loff_t hfsplus_ablock_to_phys_bytes(struct super_block *sb,
+						  u32 dblock)
+{
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
+	loff_t phys_bytes;
+
+	phys_bytes = dblock;
+	phys_bytes <<= sbi->fs_shift;
+	phys_bytes += sbi->blockoffset;
+	phys_bytes <<= sb->s_blocksize_bits;
+
+	return phys_bytes;
+}
 
 struct hfsplus_inode_info {
 	atomic_t opencnt;
@@ -456,6 +472,7 @@ void hfsplus_file_truncate(struct inode *inode);
 
 /* inode.c */
 extern const struct address_space_operations hfsplus_aops;
+extern const struct address_space_operations hfsplus_symlink_aops;
 extern const struct address_space_operations hfsplus_btree_aops;
 extern const struct dentry_operations hfsplus_dentry_operations;
 
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index b43422155e7e..540392799a23 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -18,15 +18,12 @@
 #include <linux/cred.h>
 #include <linux/uio.h>
 #include <linux/fileattr.h>
+#include <linux/iomap.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
 #include "xattr.h"
-
-static int hfsplus_read_folio(struct file *file, struct folio *folio)
-{
-	return block_read_full_folio(folio, hfsplus_get_block);
-}
+#include "iomap.h"
 
 static void hfsplus_write_failed(struct address_space *mapping, loff_t to)
 {
@@ -121,67 +118,13 @@ static bool hfsplus_release_folio(struct folio *folio, gfp_t mask)
 	return res ? try_to_free_buffers(folio) : false;
 }
 
-static ssize_t hfsplus_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
+static int hfsplus_btree_read_folio(struct file *file, struct folio *folio)
 {
-	struct file *file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
-	loff_t isize;
-	size_t count = iov_iter_count(iter);
-	loff_t end = iocb->ki_pos + count;
-	ssize_t ret;
-
-	/*
-	 * The hfsplus_get_block() only allows creating the next sequential block.
-	 * For direct writes beyond EOF, expand the file first.
-	 */
-	if (iov_iter_rw(iter) == WRITE && iocb->ki_pos > i_size_read(inode)) {
-		loff_t start_off, end_off;
-		loff_t start_page, end_page;
-
-		isize = i_size_read(inode);
-
-		/*
-		 * Wait for any in-flight DIO on this inode to finish before
-		 * calling generic_cont_expand_simple().
-		 */
-		inode_dio_wait(inode);
-
-		ret = generic_cont_expand_simple(inode, iocb->ki_pos);
-		if (ret)
-			return ret;
-
-		start_off = isize;
-		end_off = (end > 0) ? end - 1 : end;
-
-		ret = filemap_write_and_wait_range(mapping, start_off, end_off);
-		if (ret)
-			return ret;
-
-		start_page = start_off >> PAGE_SHIFT;
-		end_page = end_off >> PAGE_SHIFT;
-
-		invalidate_inode_pages2_range(mapping, start_page, end_page);
-	}
-
-	ret = blockdev_direct_IO(iocb, inode, iter, hfsplus_get_block);
-
-	/*
-	 * In case of error extending write may have instantiated a few
-	 * blocks outside i_size. Trim these off again.
-	 */
-	if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
-		isize = i_size_read(inode);
-
-		if (end > isize)
-			hfsplus_write_failed(mapping, end);
-	}
-
-	return ret;
+	return block_read_full_folio(folio, hfsplus_get_block);
 }
 
-static int hfsplus_writepages(struct address_space *mapping,
-			      struct writeback_control *wbc)
+static int hfsplus_btree_writepages(struct address_space *mapping,
+				    struct writeback_control *wbc)
 {
 	return mpage_writepages(mapping, wbc, hfsplus_get_block);
 }
@@ -189,8 +132,8 @@ static int hfsplus_writepages(struct address_space *mapping,
 const struct address_space_operations hfsplus_btree_aops = {
 	.dirty_folio	= block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
-	.read_folio	= hfsplus_read_folio,
-	.writepages	= hfsplus_writepages,
+	.read_folio	= hfsplus_btree_read_folio,
+	.writepages	= hfsplus_btree_writepages,
 	.write_begin	= hfsplus_write_begin,
 	.write_end	= generic_write_end,
 	.migrate_folio	= buffer_migrate_folio,
@@ -198,18 +141,70 @@ const struct address_space_operations hfsplus_btree_aops = {
 	.release_folio	= hfsplus_release_folio,
 };
 
-const struct address_space_operations hfsplus_aops = {
+static int hfsplus_symlink_read_folio(struct file *file, struct folio *folio)
+{
+	return block_read_full_folio(folio, hfsplus_get_block);
+}
+
+static int hfsplus_symlink_writepages(struct address_space *mapping,
+				      struct writeback_control *wbc)
+{
+	return mpage_writepages(mapping, wbc, hfsplus_get_block);
+}
+
+const struct address_space_operations hfsplus_symlink_aops = {
 	.dirty_folio	= block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
-	.read_folio	= hfsplus_read_folio,
+	.read_folio	= hfsplus_symlink_read_folio,
 	.write_begin	= hfsplus_write_begin,
 	.write_end	= generic_write_end,
 	.bmap		= hfsplus_bmap,
-	.direct_IO	= hfsplus_direct_IO,
-	.writepages	= hfsplus_writepages,
+	.writepages	= hfsplus_symlink_writepages,
 	.migrate_folio	= buffer_migrate_folio,
 };
 
+static int hfsplus_read_folio(struct file *file, struct folio *folio)
+{
+	iomap_bio_read_folio(folio, &hfsplus_iomap_ops);
+	return 0;
+}
+
+static void hfsplus_readahead(struct readahead_control *rac)
+{
+	iomap_bio_readahead(rac, &hfsplus_iomap_ops);
+}
+
+static int hfsplus_writepages(struct address_space *mapping,
+			      struct writeback_control *wbc)
+{
+	struct iomap_writepage_ctx wpc = {
+		.inode	= mapping->host,
+		.wbc	= wbc,
+		.ops	= &hfsplus_writeback_ops,
+	};
+
+	return iomap_writepages(&wpc);
+}
+
+static sector_t hfsplus_aop_bmap(struct address_space *mapping, sector_t block)
+{
+	return iomap_bmap(mapping, block, &hfsplus_iomap_ops);
+}
+
+const struct address_space_operations hfsplus_aops = {
+	.read_folio		= hfsplus_read_folio,
+	.readahead		= hfsplus_readahead,
+	.writepages		= hfsplus_writepages,
+	.dirty_folio		= iomap_dirty_folio,
+	.bmap			= hfsplus_aop_bmap,
+	.migrate_folio		= filemap_migrate_folio,
+	.is_partially_uptodate	= iomap_is_partially_uptodate,
+	.error_remove_folio	= generic_error_remove_folio,
+	.release_folio		= iomap_release_folio,
+	.invalidate_folio	= iomap_invalidate_folio,
+	.swap_activate		= hfsplus_iomap_swap_activate,
+};
+
 const struct dentry_operations hfsplus_dentry_operations = {
 	.d_hash       = hfsplus_hash_dentry,
 	.d_compare    = hfsplus_compare_dentry,
@@ -283,13 +278,23 @@ static int hfsplus_setattr(const struct mnt_idmap *idmap,
 	    attr->ia_size != i_size_read(inode)) {
 		inode_dio_wait(inode);
 		if (attr->ia_size > inode->i_size) {
-			error = generic_cont_expand_simple(inode,
-							   attr->ia_size);
+			error = hfsplus_iomap_extend_size(inode,
+							  attr->ia_size);
 			if (error)
 				return error;
+			truncate_setsize(inode, attr->ia_size);
+		} else {
+			bool did_zero = false;
+
+			error = iomap_truncate_page(inode, attr->ia_size,
+						    &did_zero,
+						    &hfsplus_write_iomap_ops,
+						    NULL, NULL);
+			if (error)
+				return error;
+			truncate_setsize(inode, attr->ia_size);
+			hfsplus_file_truncate(inode);
 		}
-		truncate_setsize(inode, attr->ia_size);
-		hfsplus_file_truncate(inode);
 		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	}
 
@@ -392,7 +397,7 @@ struct inode *hfsplus_new_inode(struct super_block *sb, struct inode *dir,
 		sbi->file_count++;
 		inode->i_op = &hfsplus_symlink_inode_operations;
 		inode_nohighmem(inode);
-		inode->i_mapping->a_ops = &hfsplus_aops;
+		inode->i_mapping->a_ops = &hfsplus_symlink_aops;
 		hip->clump_blocks = 1;
 	} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
 		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
@@ -533,7 +538,7 @@ int hfsplus_cat_read_inode(struct inode *inode, struct hfs_find_data *fd)
 		} else if (S_ISLNK(inode->i_mode)) {
 			inode->i_op = &hfsplus_symlink_inode_operations;
 			inode_nohighmem(inode);
-			inode->i_mapping->a_ops = &hfsplus_aops;
+			inode->i_mapping->a_ops = &hfsplus_symlink_aops;
 		} else {
 			inode->i_op = &hfsplus_special_inode_operations;
 			init_special_inode(inode, inode->i_mode,
diff --git a/fs/hfsplus/iomap.c b/fs/hfsplus/iomap.c
new file mode 100644
index 000000000000..6482d516d98c
--- /dev/null
+++ b/fs/hfsplus/iomap.c
@@ -0,0 +1,254 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/iomap.h>
+#include <linux/pagemap.h>
+
+#include "hfsplus_fs.h"
+#include "hfsplus_raw.h"
+#include "iomap.h"
+
+enum hfsplus_iomap_alloc {
+	HFSPLUS_IOMAP_NO_ALLOC,		/* look up an existing mapping only */
+	HFSPLUS_IOMAP_MAY_ALLOC,	/* allocate blocks as needed */
+};
+
+static int __hfsplus_iomap_begin(struct inode *inode, loff_t offset,
+				 loff_t length, unsigned int flags,
+				 struct iomap *iomap,
+				 enum hfsplus_iomap_alloc may_alloc)
+{
+	struct super_block *sb = inode->i_sb;
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
+	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
+	u32 ablock, dblock, max_blocks;
+	loff_t ablock_offset, ablock_bytes;
+	loff_t block_start;
+	bool is_new;
+	int err;
+
+	if (!may_alloc) {
+		/* Completely beyond EOF. Treat as hole */
+		if (i_size_read(inode) <= offset) {
+			iomap->type = IOMAP_HOLE;
+			iomap->addr = IOMAP_NULL_ADDR;
+			iomap->offset = offset;
+			iomap->length = length;
+			return 0;
+		}
+
+		/* Clamp length if the requested range goes beyond i_size */
+		if (offset + length > i_size_read(inode)) {
+			loff_t i_size = i_size_read(inode);
+			unsigned int blocksize = i_blocksize(inode);
+
+			length = round_up(i_size, blocksize) - offset;
+		}
+	}
+
+	ablock = offset >> sbi->alloc_blksz_shift;
+
+	err = hfsplus_map_extent(inode, ablock, may_alloc, &dblock,
+				 &max_blocks, NULL);
+	if (err)
+		return err;
+
+	ablock_offset = offset & (sbi->alloc_blksz - 1);
+	ablock_bytes = (loff_t)max_blocks << sbi->alloc_blksz_shift;
+
+	length = min_t(loff_t, length, ablock_bytes - ablock_offset);
+	block_start = round_down(offset, i_blocksize(inode));
+	is_new = may_alloc && block_start >= hip->phys_size;
+
+	/*
+	 * End a mapping of already initialized blocks at the first block
+	 * boundary at or above phys_size, so that the blocks past it start
+	 * a new mapping flagged IOMAP_F_NEW. The block holding an unaligned
+	 * phys_size (e.g. after the inode is read from disk or truncated)
+	 * stays in this mapping: ending it at phys_size itself would give
+	 * a length that is not a multiple of the logical block size, which
+	 * iomap direct I/O rejects with -EINVAL.
+	 */
+	if (may_alloc && !is_new)
+		length = min_t(loff_t, length,
+			       round_up(hip->phys_size, i_blocksize(inode)) -
+			       offset);
+
+	iomap->bdev = sb->s_bdev;
+	iomap->offset = offset;
+	iomap->length = length;
+	iomap->addr = hfsplus_ablock_to_phys_bytes(sb, dblock) + ablock_offset;
+	iomap->type = IOMAP_MAPPED;
+	iomap->flags = IOMAP_F_MERGED;
+
+	if (is_new)
+		iomap->flags |= IOMAP_F_NEW;
+
+	return 0;
+}
+
+static int hfsplus_iomap_begin(struct inode *inode, loff_t offset,
+				loff_t length, unsigned int flags,
+				struct iomap *iomap, struct iomap *srcmap)
+{
+	return __hfsplus_iomap_begin(inode, offset, length, flags, iomap,
+				     HFSPLUS_IOMAP_NO_ALLOC);
+}
+
+static int hfsplus_write_iomap_begin(struct inode *inode, loff_t offset,
+				     loff_t length, unsigned int flags,
+				     struct iomap *iomap, struct iomap *srcmap)
+{
+	return __hfsplus_iomap_begin(inode, offset, length, flags, iomap,
+				     HFSPLUS_IOMAP_MAY_ALLOC);
+}
+
+static DEFINE_IOMAP_ITER_NEXT(hfsplus_iomap_next, hfsplus_iomap_begin);
+
+const struct iomap_ops hfsplus_iomap_ops = {
+	.iomap_next = hfsplus_iomap_next,
+};
+
+/*
+ * Advance the allocated-and-zeroed high-water mark (hip->phys_size)
+ * to cover the newly written range.
+ *
+ * phys_size stays byte-granular when the written block was not newly
+ * allocated, because the rest of that block was never zeroed on disk.
+ * The block accounting is kept as hfsplus_inode_read_fork() and
+ * hfsplus_file_truncate() set it up: fs_blocks is phys_size rounded up
+ * to whole blocks, and the inode's byte count changes in whole blocks.
+ */
+static int hfsplus_write_iomap_end(struct inode *inode, loff_t pos,
+				   loff_t length, ssize_t written,
+				   unsigned int flags, struct iomap *iomap)
+{
+	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	sector_t fs_blocks;
+	loff_t end;
+
+	if (!written)
+		return 0;
+
+	end = pos + written;
+
+	if (iomap->flags & IOMAP_F_NEW)
+		end = round_up(end, sb->s_blocksize);
+
+	if (hip->phys_size >= end)
+		return written;
+
+	fs_blocks = DIV_ROUND_UP_ULL(end, sb->s_blocksize);
+	if (fs_blocks > hip->fs_blocks) {
+		inode_add_bytes(inode, (loff_t)(fs_blocks - hip->fs_blocks) <<
+				       sb->s_blocksize_bits);
+		hip->fs_blocks = fs_blocks;
+	}
+	hip->phys_size = end;
+	mark_inode_dirty(inode);
+
+	return written;
+}
+
+static DEFINE_IOMAP_ITER_NEXT_END(hfsplus_write_iomap_next,
+				  hfsplus_write_iomap_begin,
+				  hfsplus_write_iomap_end);
+
+const struct iomap_ops hfsplus_write_iomap_ops = {
+	.iomap_next	= hfsplus_write_iomap_next,
+};
+
+/*
+ * Zero the byte range [from, to) of a file that is being extended, where
+ * 'from' is the old end-of-file and 'to' the new one. Used by the extending
+ * write path, hfsplus_setattr() (truncate up) and hfsplus_file_truncate().
+ */
+int hfsplus_iomap_cont_expand(struct inode *inode, loff_t from, loff_t to)
+{
+	if (to <= from)
+		return 0;
+
+	return iomap_zero_range(inode, from, to - from, NULL,
+				&hfsplus_write_iomap_ops, NULL, NULL);
+}
+
+/*
+ * Undo a failed or short extending operation: set i_size to @size, drop
+ * the page cache beyond it and release the blocks allocated past it
+ * (including any clump preallocation made by hfsplus_file_extend()).
+ *
+ * Must be called with the inode lock held exclusively.
+ */
+void hfsplus_iomap_size_rollback(struct inode *inode, loff_t size)
+{
+	inode_dio_wait(inode);
+
+	i_size_write(inode, size);
+	truncate_pagecache(inode, size);
+
+	/*
+	 * hfsplus_file_truncate() would try to zero-fill again if
+	 * phys_size were below i_size, which is not what we want here.
+	 */
+	if (HFSPLUS_I(inode)->phys_size >= size)
+		hfsplus_file_truncate(inode);
+}
+
+/*
+ * Grow i_size to @new_size and zero-fill the gap from the old end-of-file,
+ * since HFS+ cannot represent holes. If zeroing fails part way (typically
+ * with -ENOSPC), roll back to the old i_size and release the blocks that
+ * were allocated for the partially zeroed range.
+ *
+ * Must be called with the inode lock held exclusively.
+ */
+int hfsplus_iomap_extend_size(struct inode *inode, loff_t new_size)
+{
+	loff_t old_size = i_size_read(inode);
+	int err;
+
+	i_size_write(inode, new_size);
+
+	err = hfsplus_iomap_cont_expand(inode, old_size, new_size);
+	if (err)
+		hfsplus_iomap_size_rollback(inode, old_size);
+
+	return err;
+}
+
+/*
+ * Called for each folio during writeback. If the folio falls outside
+ * the current iomap, remaps by calling __hfsplus_iomap_begin() again.
+ */
+static ssize_t hfsplus_writeback_range(struct iomap_writepage_ctx *wpc,
+					struct folio *folio, u64 offset,
+					unsigned int len, u64 end_pos)
+{
+	int err;
+
+	if (offset < wpc->iomap.offset ||
+	    offset >= wpc->iomap.offset + wpc->iomap.length) {
+		err = __hfsplus_iomap_begin(wpc->inode, offset, len, 0,
+					    &wpc->iomap,
+					    HFSPLUS_IOMAP_NO_ALLOC);
+		if (err)
+			return err;
+	}
+
+	return iomap_add_to_ioend(wpc, folio, offset, end_pos, len);
+}
+
+const struct iomap_writeback_ops hfsplus_writeback_ops = {
+	.writeback_range	= hfsplus_writeback_range,
+	.writeback_submit	= iomap_ioend_writeback_submit,
+};
+
+const struct iomap_dio_ops hfsplus_write_dio_ops = {
+	.end_io		= iomap_dio_end_io,
+};
+
+int hfsplus_iomap_swap_activate(struct swap_info_struct *sis,
+				 struct file *file, sector_t *span)
+{
+	return iomap_swapfile_activate(sis, file, span, &hfsplus_iomap_ops);
+}
diff --git a/fs/hfsplus/iomap.h b/fs/hfsplus/iomap.h
new file mode 100644
index 000000000000..53de07bf505a
--- /dev/null
+++ b/fs/hfsplus/iomap.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_HFSPLUS_IOMAP_H
+#define _LINUX_HFSPLUS_IOMAP_H
+
+extern const struct iomap_ops hfsplus_iomap_ops;
+extern const struct iomap_ops hfsplus_write_iomap_ops;
+extern const struct iomap_writeback_ops hfsplus_writeback_ops;
+extern const struct iomap_dio_ops hfsplus_write_dio_ops;
+
+int hfsplus_iomap_cont_expand(struct inode *inode, loff_t from, loff_t to);
+void hfsplus_iomap_size_rollback(struct inode *inode, loff_t size);
+int hfsplus_iomap_extend_size(struct inode *inode, loff_t new_size);
+int hfsplus_iomap_swap_activate(struct swap_info_struct *sis,
+				struct file *file, sector_t *span);
+
+#endif /* _LINUX_HFSPLUS_IOMAP_H */
-- 
2.53.0

