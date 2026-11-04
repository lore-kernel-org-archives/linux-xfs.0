Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815974;
	b=IMinTU+LrHKMKq+kSk5sD9bEi2bdwxI2l7y0QG4UcK7aU+kxsJrHZ+9xe8M61mYF78/H
	 sJPEQXlzw6Y9KxAMr/Qc1Un0VSxAeo/wqQil0F9EfW/yO304GctCF0/cfY2DuOH29N7+E
	 CzOHNh9VxNOZ+D2gxPidIY8Tj6PcQWihsUfNgmXWZyRD60ZULTUG7g+wg9O3IcbEecyjx
	 u97k3dwsqRdSEhRmrmXG+0HXMmNE2VViSf5uGb9I4BdCcZF4U/t7PO7CC8cyI8KN8fDpI
	 u1NYj72esh54DPpXu2pdNDfp1zIVMmFRh0q8WCnUqmG6bmJHHhtpNco4gYDFNkGppMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815974;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+uwyiGKRiSmAxxP7JEhVVA1bBtJMZWyBv1xo2sUemYU=;
	b=aNDeBdQDz7ef74lICrrNxXj2nB0ZdniFwb7eycVSnX908W2KFML+VaFaX0ODVh119zKs
	 zkuoA5Ez4SwujRxZgIpn8zODuo3qmRZIblS4xelVTMRX4P3Z8GLSZTasqBf40QaFd/Oj2
	 +qYniMlORoIM3DcPZRzYvEHN69c6bLr20k+4OXLkEyTLKCCfpU12v8KogOTcLk9FfCzIB
	 j3FherbX5gWBw7gugzgILnMSmdAxZM1T+qwuJz898nEnWVItodVaoxzpInZaMh5rvVfBd
	 CIb5MMqDIdsVJ13VqmlcivEQfsadS94rFObVyhXLenqgKo0neCiihLGQY30TicW7Vug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NOepbPM8;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E680606B213
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 18:12:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E680606B213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NOepbPM8
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b094e649d3so718833a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 04 Nov 2026 10:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793815973; x=1794420773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+uwyiGKRiSmAxxP7JEhVVA1bBtJMZWyBv1xo2sUemYU=;
        b=NOepbPM8aH9xzVcDb9e2vAUfCXmUfbrXv1pCHX0jZYfqplJ69+NRuA1u3Bdv5FBI5y
         3BrfpfU2LbfvoS0qIoiK+407efJqkuSfUh/wEhIg/+aZrXD+rnaMz0et6yYL2H6egD3A
         vyuaF9HgCSvJdti6GJoBbMx/GwZy8fiuzTsH1A6WM3RmTxm0a34EPDQFbxnbZObnreeX
         9gsKvRnwY8mxZA9LmTzEz+gZiyVvzrDe821sPdmKLzzT/s5GDr2ZOrGQQqpAzrVMwG7M
         cztXSD7Xi9P0tWf1KxbF4cWfFoAernnAIMSO4lcKAOOnQUh30PJry/rJWD8HWvEshgSI
         anIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793815973; x=1794420773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+uwyiGKRiSmAxxP7JEhVVA1bBtJMZWyBv1xo2sUemYU=;
        b=qG+IAeslJ3A8M9bSYxDvk3vo76idE+pr2+U3Cw65r8/2k8Ppx1Im75qFOlq6rPejdc
         z4gJXzmhqgZatbFBaKTCk1CKEq6rmXvCsz6mABfG1NKHJGUyVw8jb0i/AzPGFjMnkNCU
         IigmhhlXkOUoHwN4o+Jc5xZL2mm5tL2eIYH6PtwdPhWyNoKlGYfxumMY1cCQqrnwCZA7
         DxZAUnhCkGLA4s0vL8dqkXAgGqj/OffNus7uo991223+RZreKQgN9sVrGXzVA6JUcGe/
         4rhalYFirSJYWDugzbAgdwSaJtsM9Hj0Gg8vMPuTWzgyrbSDXD7oSZk1w17DgW0Im1aD
         Xzaw==
X-Forwarded-Encrypted: i=1; AKwUvBx2SS/jOPWi5V4C20w+yAsK4n+u6Eqvi7rs04ADymK2U70p5kHK43/n91A/ui5J+nzuhBPj15sjvak=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Cl10IsISEY+7U3SETHNbREvUqdW2SXpfYSPTLIKpKChAOSdnW
	pguYCFfNTDn1lDW4AFymnrEjtJN0F9ydk6LAn51Ad2XCzEcy/fsi/89L
X-Gm-Gg: AYBFou0qVPG5/mHrMRJaeZrsYlyNbjtwqxvqQxwf53ro8ht5nIXfi1udnZCPbQNtL08
	PECV0xr9GouEWz8yiRJ2LH0PaFdGDw4wIdw1WCdfqNRROJ/dkd+Ar+OQlObjwTzyGUO5iUuGmUc
	48AdXgloqnF4k/e/QIx9HhB0iVS72kHIhQ2L4VteeDR/k4ZeIaqKAff8ZTyyx9gMXkl7PC4W57p
	xTIaOQEgnSMywk1vLUzM4pYbhDaB9hLapE3NJwKWSMzuIq1i+ih08Exb28gcIz4QdkUeRtTuSkB
	08gory5G5SxVtkSiHn/Sf/fEg59GH3hOCV6XHkcpjT8EB4Nx3RwrrscBKMXNddPaQu4c1rWeoiU
	gz8nEn1OS2TMDhUJVeHi/tq8iNKq0ayu+Mz/RJ0IC6d0H+ttzOoD5xPF4bIvgasZZSaM8pgrs/S
	vb2KJ3rdmfSeSxEVEiBkxLRyTs6bvjJ3MKi0z7J6hzYQuXkac6kG8rdPBbZSxAhiSmbZcl0NLNK
	c1LQV4Mw7c0Ab49Ow4H1sNGOHzBIb3mtDR3qydPR8vSxqll95t91myxMsVbc2WSkXBggmO8oEKc
	+oM27OWoTDw9oRwBVB/833JgknS7Df7+Y51OBC8HI4IRBQtBqfJHWKw72bcaGDRV2fOA7erpQR1
	8QcoByiP0dgdrh4IXYxC8uoldTqU=
X-Received: by 2002:a17:90b:33cb:b0:3a0:9640:803a with SMTP id 98e67ed59e1d1-3ae895a5c2fmr14528566a91.5.1793815973278;
        Wed, 04 Nov 2026 10:12:53 -0800 (PST)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b31a3efasm78326a91.9.2026.11.04.10.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:12:52 -0800 (PST)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	cem@kernel.org,
	djwong@kernel.org
Subject: [RFC PATCH 4/6] xfs: add range-drain state and latch-based DIO admission
Date: Wed,  4 Nov 2026 10:12:44 -0800
Message-ID: <027a4cae2ffb75a2801e6296298533da7d57a215.1793815542.git.vlovich@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793815542.git.vlovich@gmail.com>
References: <cover.1793815542.git.vlovich@gmail.com>
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

Prepare XFS for range draining with lazily allocated inode-private state,
retained across VFS inode recycling and freed at XFS inode reclamation.
Provide ->dio_drain_complete to resolve the state for older requests.

Register provisionally before the final latch range snapshot for every
direct read and write submission. Transfer the token to iomap, and obtain
a fresh admission for simple-read fallback or write-check retries.

Overlapping IOCB_NOWAIT requests return -EAGAIN. Blocking requests drop
IOLOCK before waiting for a nonoverlapping snapshot and contribute no DIO
count while asleep. Writers reacquire through
xfs_ilock_iocb_for_write(), repeat append and limit checks, and recheck
unaligned COW eligibility because a clone can share blocks while IOLOCK
is dropped.

Establish the final admission and ownership rules before enabling either
range-drain consumer.

Provide optional root-only debugfs gates and counters for deterministic
filesystem selftests of request revalidation. The controls pin the selected
file and release paused tasks on close or timeout; normal builds omit them.

Signed-off-by: Vitali Lovich <vlovich@gmail.com>
---
 fs/xfs/Kconfig              |   9 ++
 fs/xfs/Makefile             |   2 +
 fs/xfs/tests/xfs_dio_test.c | 190 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dio_test.h       |  32 ++++++
 fs/xfs/xfs_file.c           | 162 ++++++++++++++++++++++++++++--
 fs/xfs/xfs_icache.c         |   2 +
 fs/xfs/xfs_inode.h          |   1 +
 fs/xfs/xfs_iops.c           |   9 ++
 fs/xfs/xfs_reflink.c        |   2 +
 fs/xfs/xfs_super.c          |   2 +
 10 files changed, 401 insertions(+), 10 deletions(-)
 create mode 100644 fs/xfs/tests/xfs_dio_test.c
 create mode 100644 fs/xfs/xfs_dio_test.h

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index b99da294e9a3..9d36201b5cdc 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -204,6 +204,15 @@ config XFS_WARN
 	  However, similar to XFS_DEBUG, it is only advisable to use this if you
 	  are debugging a particular problem.
 
+config XFS_DIO_TEST
+	bool "XFS direct I/O filesystem selftest synchronization"
+	depends on XFS_FS && DEBUG_FS
+	help
+	  Enable root-only debugfs synchronization and event counters used by
+	  direct I/O selftests on a mounted XFS filesystem. Tests can pause a
+	  selected inode at explicit events; closing the control file or a
+	  ten-second timeout releases paused tasks. Say N for production kernels.
+
 config XFS_DEBUG
 	bool "XFS Debugging support"
 	depends on XFS_FS
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 399a207f2d0e..2c31202b6ba1 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -110,6 +110,8 @@ xfs-y				+= xfs_aops.o \
 				   xfs_verify_media.o \
 				   xfs_xattr.o
 
+xfs-$(CONFIG_XFS_DIO_TEST) += tests/xfs_dio_test.o
+
 # low-level transaction/log code
 xfs-y				+= xfs_log.o \
 				   xfs_log_cil.o \
diff --git a/fs/xfs/tests/xfs_dio_test.c b/fs/xfs/tests/xfs_dio_test.c
new file mode 100644
index 000000000000..5d7df903198d
--- /dev/null
+++ b/fs/xfs/tests/xfs_dio_test.c
@@ -0,0 +1,190 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Test-only synchronization for real filesystem DIO selftests. */
+#include <linux/debugfs.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/magic.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/wait.h>
+#include "xfs_dio_test.h"
+
+static DEFINE_MUTEX(control_lock);
+static DEFINE_SPINLOCK(state_lock);
+static DECLARE_WAIT_QUEUE_HEAD(event_wait);
+static struct inode *target;
+static struct file *target_file;
+static unsigned long generation;
+static bool opened;
+static unsigned long gates, timedout;
+static unsigned long hits[XFS_DIO_TEST_NR_EVENTS];
+static unsigned long values[XFS_DIO_TEST_NR_EVENTS];
+
+void xfs_dio_test_event(struct inode *inode, enum xfs_dio_test_event event,
+		unsigned long value)
+{
+	bool pause;
+	unsigned long current_generation;
+
+	spin_lock(&state_lock);
+	if (target != inode) {
+		spin_unlock(&state_lock);
+		return;
+	}
+	hits[event]++;
+	values[event] = value;
+	pause = gates & BIT(event);
+	current_generation = generation;
+	spin_unlock(&state_lock);
+	wake_up_all(&event_wait);
+	if (pause && !wait_event_timeout(event_wait,
+			READ_ONCE(generation) != current_generation ||
+			!(READ_ONCE(gates) & BIT(event)), 10 * HZ)) {
+		spin_lock(&state_lock);
+		if (generation == current_generation) {
+			timedout++;
+			gates = 0;
+		}
+		spin_unlock(&state_lock);
+		wake_up_all(&event_wait);
+	}
+}
+
+static int dio_test_open(struct inode *inode, struct file *file)
+{
+	int error = 0;
+
+	mutex_lock(&control_lock);
+	if (opened)
+		error = -EBUSY;
+	else
+		opened = true;
+	mutex_unlock(&control_lock);
+	return error;
+}
+
+static int dio_test_release(struct inode *inode, struct file *file)
+{
+	struct file *old;
+
+	mutex_lock(&control_lock);
+	spin_lock(&state_lock);
+	old = target_file;
+	target_file = NULL;
+	target = NULL;
+	generation++;
+	gates = 0;
+	spin_unlock(&state_lock);
+	wake_up_all(&event_wait);
+	if (old)
+		fput(old);
+	opened = false;
+	mutex_unlock(&control_lock);
+	return 0;
+}
+
+static ssize_t dio_test_read(struct file *file, char __user *buf, size_t len,
+		loff_t *ppos)
+{
+	char result[512];
+	unsigned int i, nr;
+
+	spin_lock(&state_lock);
+	nr = scnprintf(result, sizeof(result), "%lu %lu\n", gates, timedout);
+	for (i = 0; i < XFS_DIO_TEST_NR_EVENTS; i++)
+		nr += scnprintf(result + nr, sizeof(result) - nr, "%lu %lu\n",
+				hits[i], values[i]);
+	spin_unlock(&state_lock);
+	return simple_read_from_buffer(buf, len, ppos, result, nr);
+}
+
+static ssize_t dio_test_write(struct file *file, const char __user *buf,
+		size_t len, loff_t *ppos)
+{
+	char command[80];
+	struct inode *inode;
+	unsigned long mask;
+	int fd, error = 0;
+
+	if (!len || len >= sizeof(command))
+		return -EINVAL;
+	if (copy_from_user(command, buf, len))
+		return -EFAULT;
+	command[len] = 0;
+	mutex_lock(&control_lock);
+	if (sysfs_streq(command, "release")) {
+		spin_lock(&state_lock);
+		gates = 0;
+		spin_unlock(&state_lock);
+		wake_up_all(&event_wait);
+		goto out;
+	}
+	if (sscanf(command, "gate %lu", &mask) == 1) {
+		if (mask >= BIT(XFS_DIO_TEST_NR_EVENTS)) {
+			error = -EINVAL;
+			goto out;
+		}
+		spin_lock(&state_lock);
+		gates = mask;
+		spin_unlock(&state_lock);
+		wake_up_all(&event_wait);
+		goto out;
+	}
+	if (sscanf(command, "release %lu", &mask) == 1) {
+		spin_lock(&state_lock);
+		gates &= ~mask;
+		spin_unlock(&state_lock);
+		wake_up_all(&event_wait);
+		goto out;
+	}
+	if (sscanf(command, "arm %d %lu", &fd, &mask) != 2 ||
+	    mask >= BIT(XFS_DIO_TEST_NR_EVENTS)) {
+		error = -EINVAL;
+		goto out;
+	}
+	{
+		CLASS(fd, f)(fd);
+
+		if (fd_empty(f)) {
+			error = -EBADF;
+			goto out;
+		}
+		inode = file_inode(fd_file(f));
+		if (inode->i_sb->s_magic != XFS_SUPER_MAGIC || !S_ISREG(inode->i_mode)) {
+			error = -EINVAL;
+			goto out;
+		}
+		spin_lock(&state_lock);
+		if (target) {
+			error = -EBUSY;
+		} else {
+			target_file = get_file(fd_file(f));
+			target = inode;
+			generation++;
+			gates = mask;
+			timedout = 0;
+			memset(hits, 0, sizeof(hits));
+			memset(values, 0, sizeof(values));
+		}
+		spin_unlock(&state_lock);
+	}
+out:
+	mutex_unlock(&control_lock);
+	return error ? error : len;
+}
+
+static const struct file_operations dio_test_fops = {
+	.owner = THIS_MODULE,
+	.open = dio_test_open,
+	.release = dio_test_release,
+	.read = dio_test_read,
+	.write = dio_test_write,
+	.llseek = default_llseek,
+};
+
+void xfs_dio_test_init(struct dentry *parent)
+{
+	debugfs_create_file("dio_test", 0600, parent, NULL, &dio_test_fops);
+}
diff --git a/fs/xfs/xfs_dio_test.h b/fs/xfs/xfs_dio_test.h
new file mode 100644
index 000000000000..178b668580d8
--- /dev/null
+++ b/fs/xfs/xfs_dio_test.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __XFS_DIO_TEST_H__
+#define __XFS_DIO_TEST_H__
+
+struct inode;
+struct dentry;
+
+enum xfs_dio_test_event {
+	XFS_DIO_TEST_BATCH_LEADER,
+	XFS_DIO_TEST_BATCH_FOLLOWER,
+	XFS_DIO_TEST_BATCH_COLLECT,
+	XFS_DIO_TEST_BATCH_ZERO,
+	XFS_DIO_TEST_WAIT_UNLOCKED,
+	XFS_DIO_TEST_WRITE_CHECKS,
+	XFS_DIO_TEST_WRITE_ADMIT,
+	XFS_DIO_TEST_WRITE_REJECT,
+	XFS_DIO_TEST_UNALIGNED_RECHECK,
+	XFS_DIO_TEST_REMAP_ACTIVE,
+	XFS_DIO_TEST_REMAP_UPGRADE,
+	XFS_DIO_TEST_NR_EVENTS,
+};
+
+#ifdef CONFIG_XFS_DIO_TEST
+void xfs_dio_test_init(struct dentry *parent);
+void xfs_dio_test_event(struct inode *inode, enum xfs_dio_test_event event,
+		unsigned long value);
+#else
+static inline void xfs_dio_test_init(struct dentry *parent) { }
+static inline void xfs_dio_test_event(struct inode *inode,
+		enum xfs_dio_test_event event, unsigned long value) { }
+#endif
+#endif
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 124a037cfa9f..e7452343671b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -11,6 +11,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_dio_test.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
@@ -38,6 +39,7 @@
 #include <linux/mount.h>
 #include <linux/filelock.h>
 #include <linux/bio-integrity.h>
+#include <linux/wait_bit.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -206,6 +208,8 @@ xfs_ilock_iocb_for_write(
 	    xfs_iflags_test(ip, XFS_IREMAPPING)) {
 		xfs_iunlock(ip, *lock_mode);
 		*lock_mode = XFS_IOLOCK_EXCL;
+		xfs_dio_test_event(VFS_I(ip), XFS_DIO_TEST_REMAP_UPGRADE,
+				*lock_mode);
 		return xfs_ilock_iocb(iocb, *lock_mode);
 	}
 
@@ -226,6 +230,80 @@ xfs_dio_read_bounce_submit_io(
 			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
 }
 
+static bool
+xfs_dio_range_overlap(
+	struct xfs_inode	*ip,
+	loff_t			pos,
+	size_t			len)
+{
+	struct inode_dio_drain	*drain;
+	bool			overlap;
+
+	/* Acquire the initialized allocation published by inode_dio_drain_get(). */
+	drain = smp_load_acquire(&ip->i_dio_drain);
+	overlap = inode_dio_drain_overlap(VFS_I(ip), drain, pos, len);
+	return overlap;
+}
+
+/* Register provisionally before the final exclusion snapshot. */
+static bool
+xfs_dio_try_begin(
+	struct xfs_inode	*ip,
+	loff_t			pos,
+	size_t			len,
+	unsigned int		*dio_flags)
+{
+	bool			generation;
+
+	if (!inode_dio_try_begin(VFS_I(ip), &ip->i_dio_drain, pos, len,
+			&generation))
+		return false;
+	*dio_flags &= ~IOMAP_DIO_GENERATION;
+	*dio_flags |= IOMAP_DIO_ACCOUNTED;
+	if (generation)
+		*dio_flags |= IOMAP_DIO_GENERATION;
+	return true;
+}
+
+/* No request is counted while waiting for an overlapping exclusion. */
+static int
+xfs_dio_range_wait(
+	struct kiocb		*iocb,
+	size_t			len,
+	unsigned int		*iolock,
+	bool			write)
+{
+	struct inode		*inode = file_inode(iocb->ki_filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct inode_dio_drain	*drain;
+	int			waited = 0;
+	int			error;
+
+	while (xfs_dio_range_overlap(ip, iocb->ki_pos, len)) {
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+		/* The successful overlap check acquired this permanent allocation. */
+		drain = READ_ONCE(ip->i_dio_drain);
+		xfs_iunlock(ip, *iolock);
+		xfs_dio_test_event(inode, XFS_DIO_TEST_WAIT_UNLOCKED,
+				iocb->ki_pos);
+		wait_var_event(&inode->i_dio_count,
+			!inode_dio_drain_overlap(inode, drain, iocb->ki_pos, len));
+		/* Re-evaluate the required write lock mode after dropping IOLOCK. */
+		if (write) {
+			error = xfs_ilock_iocb_for_write(iocb, iolock);
+			if (error) {
+				*iolock = 0;
+				return error;
+			}
+		} else {
+			xfs_ilock(ip, *iolock);
+		}
+		waited = 1;
+	}
+	return waited;
+}
+
 static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
 	.submit_io	= xfs_dio_read_bounce_submit_io,
 	.bio_set	= &iomap_ioend_bioset,
@@ -237,6 +315,10 @@ xfs_file_dio_read(
 	struct iov_iter		*to)
 {
 	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
+	unsigned int		iolock = XFS_IOLOCK_SHARED;
+	unsigned int		dio_flags = 0;
+	bool			bounce = mapping_stable_writes(iocb->ki_filp->f_mapping);
+	bool			simple = !bounce;
 	ssize_t			ret;
 
 	trace_xfs_file_direct_read(iocb, to);
@@ -249,15 +331,27 @@ xfs_file_dio_read(
 	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
 	if (ret)
 		return ret;
-	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
+retry:
+	ret = xfs_dio_range_wait(iocb, iov_iter_count(to), &iolock, false);
+	if (ret < 0)
+		goto out_unlock;
+	if (!xfs_dio_try_begin(ip, iocb->ki_pos, iov_iter_count(to), &dio_flags))
+		goto retry;
+	if (!simple) {
 		ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops,
-				&xfs_dio_read_bounce_ops, 0, NULL, 0);
+					bounce ? &xfs_dio_read_bounce_ops : NULL,
+					dio_flags,
+					NULL, 0);
 	} else {
-		ret = iomap_dio_read_simple(iocb, to, xfs_read_iomap_begin, 0);
-		if (ret == -ENOTBLK)
-			ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
-					0, NULL, 0);
+		ret = iomap_dio_read_simple(iocb, to, xfs_read_iomap_begin,
+				dio_flags);
+		if (ret == -ENOTBLK) {
+			/* Fallback needs a fresh admission and registration. */
+			simple = false;
+			goto retry;
+		}
 	}
+out_unlock:
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	return ret;
@@ -436,9 +530,10 @@ xfs_file_write_zero_eof(
 /*
  * Common pre-write limit and setup checks.
  *
- * Called with the iolock held either shared and exclusive according to
- * @iolock, and returns with it held.  Might upgrade the iolock to exclusive
- * if called for a direct write beyond i_size.
+ * Called with the iolock held shared or exclusive according to @iolock.
+ * Returns with it held unless reacquisition fails, in which case *@iolock
+ * is set to zero.  Might upgrade the iolock to exclusive if called for a
+ * direct write beyond i_size.
  */
 STATIC ssize_t
 xfs_file_write_checks(
@@ -453,10 +548,25 @@ xfs_file_write_checks(
 	ssize_t			error;
 
 restart:
+	/* Normalize append position and enforce limits before range admission. */
 	error = generic_write_checks(iocb, from);
+	xfs_dio_test_event(inode, XFS_DIO_TEST_WRITE_CHECKS,
+			iov_iter_count(from));
 	if (error <= 0)
 		return error;
 
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		error = xfs_dio_range_wait(iocb, iov_iter_count(from), iolock,
+				true);
+		if (error < 0)
+			return error;
+		if (error) {
+			iov_iter_reexpand(from, count);
+			/* EOF and limits can change while IOLOCK is dropped. */
+			goto restart;
+		}
+	}
+
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		error = break_layout(inode, false);
 		if (error == -EWOULDBLOCK)
@@ -735,6 +845,7 @@ xfs_file_dio_write_aligned(
 {
 	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	unsigned int		dio_flags = 0;
+	size_t			count = iov_iter_count(from);
 	ssize_t			ret;
 
 	/*
@@ -748,6 +859,7 @@ xfs_file_dio_write_aligned(
 	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
+retry_checks:
 	ret = xfs_file_write_checks(iocb, from, &iolock, ac);
 	if (ret)
 		goto out_unlock;
@@ -763,10 +875,18 @@ xfs_file_dio_write_aligned(
 	}
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
 		dio_flags |= IOMAP_DIO_BOUNCE;
+	xfs_dio_test_event(VFS_I(ip), XFS_DIO_TEST_WRITE_ADMIT, iocb->ki_pos);
+	if (!xfs_dio_try_begin(ip, iocb->ki_pos, iov_iter_count(from), &dio_flags)) {
+		xfs_dio_test_event(VFS_I(ip), XFS_DIO_TEST_WRITE_REJECT,
+				iocb->ki_pos);
+		iov_iter_reexpand(from, count);
+		goto retry_checks;
+	}
 	trace_xfs_file_direct_write(iocb, from);
 	ret = iomap_dio_rw(iocb, from, ops, dops, dio_flags, ac, 0);
 out_unlock:
-	xfs_iunlock(ip, iolock);
+	if (iolock)
+		xfs_iunlock(ip, iolock);
 	return ret;
 }
 
@@ -827,6 +947,7 @@ xfs_file_dio_write_atomic(
 	if (ret)
 		return ret;
 
+retry_checks:
 	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
 	if (ret)
 		goto out_unlock;
@@ -840,6 +961,10 @@ xfs_file_dio_write_atomic(
 	trace_xfs_file_direct_write(iocb, from);
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
 		dio_flags |= IOMAP_DIO_BOUNCE;
+	if (!xfs_dio_try_begin(ip, iocb->ki_pos, iov_iter_count(from), &dio_flags)) {
+		iov_iter_reexpand(from, ocount);
+		goto retry_checks;
+	}
 	ret = iomap_dio_rw(iocb, from, dops, &xfs_dio_write_ops, dio_flags,
 			NULL, 0);
 
@@ -917,10 +1042,22 @@ xfs_file_dio_write_unaligned(
 		goto out_unlock;
 	}
 
+retry_checks:
 	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
 	if (ret)
 		goto out_unlock;
 
+	if (IS_ENABLED(CONFIG_XFS_DIO_TEST))
+		xfs_dio_test_event(VFS_I(ip), XFS_DIO_TEST_UNALIGNED_RECHECK,
+				(iolock << 8) | xfs_is_cow_inode(ip));
+
+	/* The checks can drop IOLOCK, allowing a clone to share this block. */
+	if (xfs_is_cow_inode(ip)) {
+		trace_xfs_reflink_bounce_dio_write(iocb, from);
+		ret = -ENOTBLK;
+		goto out_unlock;
+	}
+
 	/*
 	 * If we are doing exclusive unaligned I/O, this must be the only I/O
 	 * in-flight.  Otherwise we risk data corruption due to unwritten extent
@@ -932,6 +1069,11 @@ xfs_file_dio_write_unaligned(
 
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
 		flags |= IOMAP_DIO_BOUNCE;
+	xfs_dio_test_event(VFS_I(ip), XFS_DIO_TEST_WRITE_ADMIT, iocb->ki_pos);
+	if (!xfs_dio_try_begin(ip, iocb->ki_pos, iov_iter_count(from), &flags)) {
+		iov_iter_reexpand(from, count);
+		goto retry_checks;
+	}
 
 	trace_xfs_file_direct_write(iocb, from);
 	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index de8be344e987..e26df6894618 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -110,6 +110,7 @@ xfs_inode_alloc(
 	ip->i_mount = mp;
 	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
 	ip->i_cowfp = NULL;
+	ip->i_dio_drain = NULL;
 	memset(&ip->i_af, 0, sizeof(ip->i_af));
 	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
 	memset(&ip->i_df, 0, sizeof(ip->i_df));
@@ -156,6 +157,7 @@ xfs_inode_free_callback(
 		xfs_inode_item_destroy(ip);
 	}
 
+	kfree(ip->i_dio_drain);
 	kmem_cache_free(xfs_inode_cache, ip);
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 75eff68c1e39..04907a7b431f 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -41,6 +41,7 @@ typedef struct xfs_inode {
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	struct rw_semaphore	i_lock;		/* inode lock */
 	atomic_t		i_pincount;	/* inode pin count */
+	struct inode_dio_drain	*i_dio_drain; /* lazily allocated DIO drain */
 	struct llist_node	i_gclist;	/* deferred inactivation list */
 
 	/*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d307ec97fac8..dec2139c0c6f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1278,6 +1278,14 @@ xfs_vn_tmpfile(
 	return finish_open_simple(file, err);
 }
 
+static void
+xfs_vn_dio_drain_complete(
+	struct inode		*inode)
+{
+	/* The generation cutover orders i_dio_drain initialization before this callback. */
+	inode_dio_drain_complete(inode, READ_ONCE(XFS_I(inode)->i_dio_drain));
+}
+
 static const struct inode_operations xfs_inode_operations = {
 	.get_inode_acl		= xfs_get_acl,
 	.set_acl		= xfs_set_acl,
@@ -1289,6 +1297,7 @@ static const struct inode_operations xfs_inode_operations = {
 	.sync_lazytime		= xfs_vn_sync_lazytime,
 	.fileattr_get		= xfs_fileattr_get,
 	.fileattr_set		= xfs_fileattr_set,
+	.dio_drain_complete	= xfs_vn_dio_drain_complete,
 };
 
 static const struct inode_operations xfs_dir_inode_operations = {
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 104542b10d9e..3e1b7d628477 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -12,6 +12,7 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_inode.h"
+#include "xfs_dio_test.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
@@ -1763,6 +1764,7 @@ xfs_reflink_remap_prep(
 	xfs_iflags_set(src, XFS_IREMAPPING);
 	if (inode_in != inode_out)
 		xfs_ilock_demote(src, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
+	xfs_dio_test_event(inode_in, XFS_DIO_TEST_REMAP_ACTIVE, 0);
 
 	return 0;
 out_unlock:
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a06132aa384..a7e84ddd145b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -12,6 +12,7 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_dio_test.h"
 #include "xfs_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
@@ -2677,6 +2678,7 @@ init_xfs_fs(void)
 		goto out_cleanup_procfs;
 
 	xfs_debugfs = xfs_debugfs_mkdir("xfs", NULL);
+	xfs_dio_test_init(xfs_debugfs);
 
 	xfs_kset = kset_create_and_add("xfs", NULL, fs_kobj);
 	if (!xfs_kset) {
-- 
2.56.0

