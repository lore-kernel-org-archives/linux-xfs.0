Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815977;
	b=G8L4nk4Cw7QcVVCIYVZRZB+Mu3MHWOXkWWLs0ZZprsK8OnHrABvl4GXF2pssP1eopbvW
	 2g5jHbZ719wqlVT7V2FgEZw9SS0mMDO38r7Ybi2XEtglk7/HInOOPKuxLg1yXmm6JOaUP
	 9hP0pGNJAX0dqleY8phvZPFWnaa/6LEtiP2yWMrV5aourd6wi/JbbwWlA18EF+NTRVxZz
	 3qL12qaBRf5zmulcDEput0dqDBCZiAmc1zTlWOb2rSKdwNPjqGxrOMPtGKPZu0geb8QeU
	 8jv6Ay1K1UxsOJBiN+Q5tFO7TRJFy2SQGHD8he6SLEtnTg5YqtlGFWHnfA5aoUHl5JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815977;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4uZX4nXlMndOJUkjBA4nnTSJpRObFhe7/4MI/7nLwfs=;
	b=O+PPuELMKSdTdZCRtdsw6hFgPH/ET038W8R9jnG6YHClVrpK7ZkJ6oLIfQVGfvHlXP80
	 A+rPS1s/ZPhC0JJzChDE+rXKRaIILzYNFo8XvtFz2DmVr2nF2VGee0UtrzdisvPaz03WK
	 y36ugvnKhHMd9cM0JEJ/bwEOX+kkiIQ+9ANpuPbRMLr09r8xemXtN4aCj/ve1jffKuUSK
	 4izyGuEOcUQ4Js6gxfw9BD4lvGKAqakraX3LjDB6s+246Feiy/VpiFABd6pYTLSU8gOgU
	 owfb+rNmMq15Sdz8fHDdHHzrgXtMSCBCR9uoX4hn69iWbJt4NS/4EJBEjF4db5OyLjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mZEesV8W;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BB7606B221
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 18:12:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5BB7606B221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mZEesV8W
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so721345a91.3
        for <linux-xfs@vger.kernel.org>; Wed, 04 Nov 2026 10:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793815975; x=1794420775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4uZX4nXlMndOJUkjBA4nnTSJpRObFhe7/4MI/7nLwfs=;
        b=mZEesV8WXGpCusS7zoM7GV6Tk7/sB85eaZPnOgjfS9f0zCk3zh35csLXtkNSFSIURA
         YwTzAUziulX10HZSw39AuHoDjLA0b/37h0RFdU433s4oUn6XkWlKUjQOnIwSeJ/CGYPb
         DbdoHPoU8uHnQ9Si1Y7gE+vaKONl5XhDaKyDA8BvxU/mp7WGGIHWSGHvkCiavN/i7Y6M
         ZKDcCHqBZa4KzGQy2nonRxNDzsUfMCIw44IkddQUcPW7jQGLUSuSTG+DnF4E8nqOrjJR
         q0aiR8RxhyWTA6Cw7G+jL5YKhCwo1kBQJ2ZatPxz9eDCGIT2lDqDSAE8LT2yKvYKKQzi
         cuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793815975; x=1794420775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4uZX4nXlMndOJUkjBA4nnTSJpRObFhe7/4MI/7nLwfs=;
        b=0bdDnFs8Pr5riYuvBMcFYlEwhBSZHtGoAi8uET1ueckRh3iHrBEKxAQOKUqmALzn+e
         HhBQ2MXRrl9fomNVxdCP9NUnSsNeZoq7RGshjasa/Qlo4dVFbccrWSkG4HVgJsovVbd9
         KJUEPfbAjMB+rl42sQUyuhDpjP4PRQqhw7eeWusmV7+A8WlRFZqp7ex4BkWdUr/FFMZb
         O4MqOH6JtnBhoQLyvOqS4zqlyZv97/wJNDTMU7PdbFjqFi9GyhjdrznrBoAjZWFqeyTS
         DX/hi+k+KToScEIlCpqGYsveXe8+SZ4/PptljXXqvphlFtF/gJPOi88CT7cv9Sj3US6a
         /vqQ==
X-Forwarded-Encrypted: i=1; AKwUvBwuhDEYMA9KcRgw5cpxJjBBNYqAukjV1p/rm2Wm3bAzav2xdZIWwS/lJRHIrElPa4Q1e5ZLL+EEH8U=@vger.kernel.org
X-Gm-Message-State: APuU4Z901+rCmo1qycTYuA2f28RdaUH1Bs2qs3GDbjV7fdVnLJQ7b9UT
	tywUoPo45zwJice03DWJ4CgSGTa6TPESxN5nEq2aieJ2L6p1idVuzReo
X-Gm-Gg: AYBFou0vJ3GkGyAFu+7Jt9Opedpa9ABMlioXcZymKV/8qvadMqpccRG4NJI7SsmoUBb
	LnpB1ECqz5MGGhxYaeamXWAmyZfVXBt3J+KiTTPxxrJzmFzAk/Dgzj18Y3h+Ax3+b1hIGAWy4C4
	f0FXXNplaxKH8rtSyARSWlzQYH2Fy9l8Rcb0AhjvxNfKUrGhTlHi0KJnC7C33hkctXvBTPZ+oaK
	2PkYCNs48pys1yXCWUU+6w3u+gojpWF3fVWqi4YCNUs7WObCa4tZan0mY2My93jq8k6NmJjCcRT
	3uRcSXocmdBQ+qnU6Lwy1BuiCjcm11L7GClVN5q5UK3MY/RsThMTR/6GBSiA8YNi9t/VjZFuOxG
	ji9WjE+XmvBlzLie/Q9+k94NnNo7TyOydI57DIf+2td/1u8q6sRCmY/bgXvq2ktwGHwTuxfAd+9
	UvXtDXrKJCrzB21m/cPn0RSca5nOCnIHRURiCTAMEMJeTn3rUowWRhjH75kTj4rB/KNgAr1vKPG
	WE9zFgXJ6vGXJ7OVUYLUvLahZK5uwbuJlXrbVwbs3zELlJU3aM1tBV5PnH4gaE5CziltV8xQUXz
	qeo39eCdbJnpRgpTmFgXq84DViIzBF8+2wWywtHCyznenZOiMFT53yGliinwnoShN3FXHxeoAwZ
	Gyq8DhJVcDvY5YgPD8+wK7llyRaU=
X-Received: by 2002:a17:90b:1845:b0:3ac:b145:8f4 with SMTP id 98e67ed59e1d1-3ae8983919amr13278765a91.41.1793815974659;
        Wed, 04 Nov 2026 10:12:54 -0800 (PST)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b31a3efasm78326a91.9.2026.11.04.10.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:12:54 -0800 (PST)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	cem@kernel.org,
	djwong@kernel.org
Subject: [RFC PATCH 5/6] xfs: use range-based DIO draining for aligned hole punches
Date: Wed,  4 Nov 2026 10:12:45 -0800
Message-ID: <8594c094b34fc65afe253bc4fe81032e5efd0de7.1793815542.git.vlovich@gmail.com>
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

Hole punching holds exclusive IOLOCK while draining DIO and modifying
the range, blocking new submissions throughout the inode. Use shared
IOLOCK and a latch-published range exclusion for eligible aligned
data-device punches so disjoint new DIO can proceed.

Reject obvious ineligible requests before allocating drain state or
taking the drain mutex. Obtain the drain mutex before IOLOCK and recheck
eligibility under shared IOLOCK. A waiter must not hold shared IOLOCK
while the mutex owner may drop and reacquire IOLOCK exclusively during
write checks. Retain the existing path for DAX, realtime,
privilege/capability stripping (!IS_NOSEC), reflink remapping, unaligned
punches, layout breaking, or an unrepresentable rounded endpoint. Round
the exclusion to the larger of the allocation unit and PAGE_SIZE,
matching cache invalidation.

Drain the pre-cutover cohort before taking MMAPLOCK: an in-flight DIO
can fault in a buffer backed by the same file. Skip unnecessary partial
block zeroing for aligned data-device punches so the operation can retain
shared IOLOCK. Keep the exclusion through extent removal and any required
synchronous log force, and report allocation or drain-start errors.

Add a filesystem selftest that parks registered DIO in a userfaultfd
fault, observes the active exclusion, and checks disjoint progress and
overlapping NOWAIT write rejection. Race faulting same-inode buffers
with punching, using synchronous and AIO extending and COW writes, and
verify clone isolation.

Exercise repeated exclusion retries and append-position/limit changes
while IOLOCK is dropped, including iterator expansion and a limit that
changes DIO alignment.

Verify completed and in-progress reflink remaps during the unlocked
window, including exact shared-extent evidence, unaligned COW fallback,
exclusive lock reacquisition and clone isolation.

Signed-off-by: Vitali Lovich <vlovich@gmail.com>
---
 fs/xfs/xfs_bmap_util.c                        |   9 +-
 fs/xfs/xfs_file.c                             |  88 ++++
 fs/xfs/xfs_inode.c                            |  10 +
 tools/testing/selftests/filesystems/Makefile  |   6 +
 .../selftests/filesystems/xfs_dio_admission.c | 380 +++++++++++++++++
 .../selftests/filesystems/xfs_dio_drain.c     | 371 +++++++++++++++++
 .../selftests/filesystems/xfs_dio_remap.c     | 391 ++++++++++++++++++
 7 files changed, 1253 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/filesystems/xfs_dio_admission.c
 create mode 100644 tools/testing/selftests/filesystems/xfs_dio_drain.c
 create mode 100644 tools/testing/selftests/filesystems/xfs_dio_remap.c

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 865aec3ae5ab..30759c6f94d3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -889,8 +889,8 @@ xfs_free_file_space(
 		return 0;
 
 	/*
-	 * Now AIO and DIO has drained we flush and (if necessary) invalidate
-	 * the cached range over the first operation we are about to run.
+	 * The caller has excluded and drained DIO over the affected range.
+	 * Flush and invalidate the cached range before removing its mappings.
 	 */
 	error = xfs_flush_unmap_range(ip, offset, len);
 	if (error)
@@ -917,6 +917,11 @@ xfs_free_file_space(
 		}
 	}
 
+	/* An aligned data-device punch needs no partial-block zeroing. */
+	if (!XFS_IS_REALTIME_INODE(ip) &&
+	    !((offset | len) & mp->m_blockmask))
+		return 0;
+
 	/*
 	 * Now that we've unmap all full blocks we'll have to zero out any
 	 * partial block at the beginning and/or end.  xfs_zero_range is smart
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e7452343671b..ad83328b7350 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1682,6 +1682,90 @@ xfs_falloc_allocate_range(
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
 		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
+/*
+ * Aligned punches do not change the file size or zero partial
+ * blocks.  Exclude only the range that cache invalidation can touch, while
+ * retaining the shared IOLOCK to exclude truncate and buffered writes.
+ */
+STATIC bool
+xfs_file_punch_hole_range(
+	struct file		*file,
+	loff_t			offset,
+	loff_t			len,
+	long			*result)
+{
+	struct inode		*inode = file_inode(file);
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct inode_dio_drain	*drain;
+	loff_t			rounding, start, last;
+	unsigned int		inode_flags = READ_ONCE(inode->i_flags);
+	unsigned int		iolock = XFS_IOLOCK_SHARED;
+	bool			handled = false;
+	int			error;
+
+	/*
+	 * Avoid drain allocation and serialization for obvious fallbacks.
+	 * Only data-device files qualify, so check alignment to the filesystem
+	 * block size. Recheck mutable inode state after acquiring IOLOCK.
+	 */
+	if ((inode_flags & S_DAX) || !(inode_flags & S_NOSEC) ||
+	    (READ_ONCE(ip->i_diflags) & XFS_DIFLAG_REALTIME) ||
+	    (READ_ONCE(ip->i_flags) & XFS_IREMAPPING) ||
+	    !IS_ALIGNED(offset | len, i_blocksize(inode)))
+		return false;
+
+	drain = inode_dio_drain_get(&ip->i_dio_drain);
+	if (IS_ERR(drain)) {
+		*result = PTR_ERR(drain);
+		return true;
+	}
+	mutex_lock(&drain->lock);
+	xfs_ilock(ip, iolock);
+	if (IS_DAX(inode) || XFS_IS_REALTIME_INODE(ip) || !IS_NOSEC(inode) ||
+	    xfs_iflags_test(ip, XFS_IREMAPPING) ||
+	    !xfs_is_falloc_aligned(ip, offset, len))
+		goto out_unlock;
+
+	rounding = max_t(loff_t, xfs_inode_alloc_unitsize(ip), PAGE_SIZE);
+	/* The invalidation range must remain representable even beyond EOF. */
+	if (offset + len > rounddown_64(LLONG_MAX, rounding))
+		goto out_unlock;
+	start = rounddown_64(offset, rounding);
+	last = roundup_64(offset + len, rounding) - 1;
+
+	/* Fall back to the exclusive path if breaking a layout would block or fail. */
+	if (break_layout(inode, false))
+		goto out_unlock;
+
+	handled = true;
+	/*
+	 * IS_NOSEC was checked under shared IOLOCK, which excludes chmod and
+	 * security xattr changes that could clear S_NOSEC. file_modified() can
+	 * update timestamps without stripping privileges under shared IOLOCK.
+	 */
+	error = file_modified(file);
+	if (error)
+		goto out_result;
+
+	/* DIO can fault in a buffer from this file. Drain before MMAPLOCK. */
+	error = inode_dio_drain_start(inode, drain, start, last);
+	if (error)
+		goto out_result;
+	inode_dio_drain_wait(inode, drain);
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+	error = xfs_free_file_space(ip, offset, len, NULL);
+	if (!error && xfs_file_sync_writes(file))
+		error = xfs_log_force_inode(ip);
+	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
+	inode_dio_drain_finish(inode, drain);
+out_result:
+	*result = error;
+out_unlock:
+	xfs_iunlock(ip, iolock);
+	mutex_unlock(&drain->lock);
+	return handled;
+}
+
 STATIC long
 __xfs_file_fallocate(
 	struct file		*file,
@@ -1695,6 +1779,10 @@ __xfs_file_fallocate(
 	long			error;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 
+	if (mode == (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE) &&
+	    xfs_file_punch_hole_range(file, offset, len, &error))
+		return error;
+
 	xfs_ilock(ip, iolock);
 	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
 	if (error)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 05a14da28031..b8119abab30a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -118,6 +118,16 @@ xfs_lock_flags_assert(
  *
  * i_rwsem -> invalidate_lock -> page_lock -> i_ilock
  *
+ * DIO range drainers add an outer mutex:
+ *
+ * i_dio_drain->lock -> i_rwsem -> invalidate_lock -> page_lock -> i_ilock
+ *
+ * Never wait for the drain mutex while holding IOLOCK: its owner may drop
+ * shared IOLOCK and reacquire it exclusively during write checks. A waiter
+ * holding shared IOLOCK would prevent that upgrade and deadlock both drainers.
+ * The mutex stays held through exclusion removal, including extent freeing
+ * and any synchronous log force. DIO admission and completion do not take it.
+ *
  * mmap_lock locking order:
  *
  * i_rwsem -> page lock -> mmap_lock
diff --git a/tools/testing/selftests/filesystems/Makefile b/tools/testing/selftests/filesystems/Makefile
index fbd5c27505ef..0c572f10fa71 100644
--- a/tools/testing/selftests/filesystems/Makefile
+++ b/tools/testing/selftests/filesystems/Makefile
@@ -5,7 +5,13 @@ TEST_GEN_PROGS := devpts_pts anon_inode_test kernfs_test fclog ustat_test rw_hin
 TEST_GEN_PROGS += idmapped_tmpfile
 TEST_GEN_PROGS_EXTENDED := dnotify_test
 
+TEST_GEN_PROGS_EXTENDED += xfs_dio_drain xfs_dio_admission xfs_dio_remap
+
 include ../lib.mk
 
+$(OUTPUT)/xfs_dio_drain: LDLIBS += -pthread
+$(OUTPUT)/xfs_dio_admission: LDLIBS += -pthread
+$(OUTPUT)/xfs_dio_remap: LDLIBS += -pthread
+
 $(OUTPUT)/idmapped_tmpfile: LDLIBS += -lcap
 $(OUTPUT)/idmapped_tmpfile: utils.c
diff --git a/tools/testing/selftests/filesystems/xfs_dio_admission.c b/tools/testing/selftests/filesystems/xfs_dio_admission.c
new file mode 100644
index 000000000000..3162de34b2b8
--- /dev/null
+++ b/tools/testing/selftests/filesystems/xfs_dio_admission.c
@@ -0,0 +1,380 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Deterministic real-syscall admission retries; see CONFIG_XFS_DIO_TEST. */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/fs.h>
+#include <linux/magic.h>
+#include <linux/userfaultfd.h>
+#include <poll.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/resource.h>
+#include <sys/stat.h>
+#include <sys/statfs.h>
+#include <sys/syscall.h>
+#include <sys/uio.h>
+#include <time.h>
+#include <unistd.h>
+#include "../kselftest.h"
+
+/* Event indices in fs/xfs/xfs_dio_test.h. */
+enum { WAIT_UNLOCKED = 4, WRITE_CHECKS, WRITE_ADMIT, WRITE_REJECT, EVENTS };
+#define GATE(event) (1UL << (event))
+struct snapshot { unsigned long gates, timedout, hits[EVENTS], value[EVENTS]; };
+struct request {
+	int fd;
+	void *buffer;
+	size_t length;
+	off_t offset;
+	bool read, punch;
+	ssize_t result;
+	int error;
+};
+struct parked_read {
+	struct request req;
+	pthread_t thread;
+	int uffd;
+};
+
+static void die(const char *what)
+{
+	ksft_exit_fail_msg("%s: %s\n", what, strerror(errno));
+}
+
+static long long milliseconds(void)
+{
+	struct timespec now;
+
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	return now.tv_sec * 1000LL + now.tv_nsec / 1000000;
+}
+
+static void *submit(void *data)
+{
+	struct request *r = data;
+
+	if (r->punch)
+		r->result = fallocate(r->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				r->offset, r->length);
+	else if (r->read)
+		r->result = pread(r->fd, r->buffer, r->length, r->offset);
+	else
+		r->result = pwrite(r->fd, r->buffer, r->length, r->offset);
+	r->error = errno;
+	return NULL;
+}
+
+static void command(int control, const char *verb, unsigned long value)
+{
+	char text[80];
+	int len = snprintf(text, sizeof(text), "%s %lu", verb, value);
+
+	if (write(control, text, len) != len)
+		die("DIO test command");
+}
+
+static int arm(int fd, unsigned long gates)
+{
+	char text[80];
+	int control = open("/sys/kernel/debug/xfs/dio_test", O_RDWR);
+	int len;
+
+	if (control < 0)
+		return -1;
+	len = snprintf(text, sizeof(text), "arm %d %lu", fd, gates);
+	if (write(control, text, len) != len)
+		die("arm DIO test");
+	return control;
+}
+
+static struct snapshot snapshot(int control)
+{
+	struct snapshot s = { };
+	char buffer[2048], *cursor, *next;
+	ssize_t n = pread(control, buffer, sizeof(buffer) - 1, 0);
+
+	if (n <= 0)
+		die("read DIO test state");
+	buffer[n] = 0;
+	if (sscanf(buffer, "%lu %lu", &s.gates, &s.timedout) != 2)
+		die("parse DIO test state");
+	cursor = strchr(buffer, '\n');
+	for (int i = 0; i < EVENTS; i++) {
+		if (!cursor || sscanf(cursor + 1, "%lu %lu", &s.hits[i],
+				&s.value[i]) != 2)
+			die("parse DIO test event");
+		next = strchr(cursor + 1, '\n');
+		cursor = next;
+	}
+	return s;
+}
+
+static void wait_event(int control, int event, unsigned long count)
+{
+	long long deadline = milliseconds() + 5000;
+
+	do {
+		struct snapshot s = snapshot(control);
+
+		if (s.hits[event] >= count && !s.timedout)
+			return;
+		usleep(1000);
+	} while (milliseconds() < deadline);
+	ksft_exit_fail_msg("DIO event %d did not reach %lu\n", event, count);
+}
+
+static void park_read(struct parked_read *old, int fd, size_t unit)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	struct uffdio_register reg = { .mode = UFFDIO_REGISTER_MODE_MISSING };
+	struct uffd_msg message;
+	struct pollfd pollfd;
+
+	memset(old, 0, sizeof(*old));
+	old->req = (struct request){ .fd = fd, .length = unit,
+		.offset = unit, .read = true };
+	old->req.buffer = mmap(NULL, unit, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (old->req.buffer == MAP_FAILED)
+		die("missing read destination");
+	old->uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	reg.range.start = (uintptr_t)old->req.buffer;
+	reg.range.len = unit;
+	if (old->uffd < 0 || ioctl(old->uffd, UFFDIO_API, &api) ||
+	    ioctl(old->uffd, UFFDIO_REGISTER, &reg))
+		die("kernel-fault userfaultfd required by admission test");
+	if (pthread_create(&old->thread, NULL, submit, &old->req))
+		die("parked read thread");
+	pollfd = (struct pollfd){ .fd = old->uffd, .events = POLLIN };
+	if (poll(&pollfd, 1, 5000) != 1 ||
+	    read(old->uffd, &message, sizeof(message)) != sizeof(message) ||
+	    message.event != UFFD_EVENT_PAGEFAULT)
+		ksft_exit_fail_msg("read did not register and reach GUP\n");
+}
+
+static void release_read(struct parked_read *old, void *buffer, size_t unit)
+{
+	struct uffdio_copy copy = { .src = (uintptr_t)buffer,
+		.dst = (uintptr_t)old->req.buffer, .len = unit };
+
+	if (ioctl(old->uffd, UFFDIO_COPY, &copy))
+		die("release registered read");
+	pthread_join(old->thread, NULL);
+	if (old->req.result != (ssize_t)unit)
+		ksft_exit_fail_msg("registered read result %zd\n", old->req.result);
+	close(old->uffd);
+	munmap(old->req.buffer, unit);
+}
+
+static void wait_exclusion(int fd, void *buffer, size_t unit, off_t offset)
+{
+	struct iovec iov = { .iov_base = buffer, .iov_len = unit };
+	long long deadline = milliseconds() + 5000;
+
+	do {
+		if (preadv2(fd, &iov, 1, offset, RWF_NOWAIT) == -1 && errno == EAGAIN)
+			return;
+		usleep(1000);
+	} while (milliseconds() < deadline);
+	ksft_exit_fail_msg("real drainer did not publish exclusion\n");
+}
+
+static void prefill(int fd, void *buffer, size_t unit)
+{
+	memset(buffer, 0x5a, 16 * unit);
+	if (ftruncate(fd, 0) || pwrite(fd, buffer, 8 * unit, 0) != 8 * (ssize_t)unit ||
+	    fsync(fd))
+		die("prefill");
+}
+
+static bool bytes_equal(const void *buffer, size_t length, unsigned char value)
+{
+	const unsigned char *bytes = buffer;
+
+	for (size_t i = 0; i < length; i++)
+		if (bytes[i] != value)
+			return false;
+	return true;
+}
+
+/* Two distinct real punch exclusions must reject the same writer twice. */
+static int repeated_admission(int fd, void *buffer, size_t unit)
+{
+	struct request writer = { .fd = fd, .buffer = buffer, .length = unit,
+		.offset = 4 * unit };
+	struct request punch = { .fd = fd, .length = unit,
+		.offset = writer.offset,
+		.punch = true };
+	struct snapshot s;
+	pthread_t writing, punching;
+	int control;
+	bool ok = true;
+
+	prefill(fd, buffer, unit);
+	control = arm(fd, GATE(WRITE_ADMIT));
+	if (control < 0)
+		return -1;
+	if (pthread_create(&writing, NULL, submit, &writer))
+		die("writer thread");
+	for (unsigned int round = 1; round <= 2; round++) {
+		struct parked_read old;
+
+		wait_event(control, WRITE_ADMIT, round);
+		park_read(&old, fd, unit);
+		if (pthread_create(&punching, NULL, submit, &punch))
+			die("punch thread");
+		wait_exclusion(fd, buffer + unit, unit, writer.offset);
+		command(control, "gate", GATE(WAIT_UNLOCKED));
+		wait_event(control, WAIT_UNLOCKED, round);
+		s = snapshot(control);
+		ok &= s.hits[WRITE_REJECT] == round;
+		release_read(&old, buffer + unit, unit);
+		pthread_join(punching, NULL);
+		ok &= punch.result == 0;
+		command(control, "gate", round == 1 ? GATE(WRITE_ADMIT) : 0);
+	}
+	pthread_join(writing, NULL);
+	s = snapshot(control);
+	ok &= writer.result == (ssize_t)unit && s.hits[WRITE_REJECT] == 2 &&
+		s.hits[WAIT_UNLOCKED] == 2 && s.hits[WRITE_ADMIT] == 3 &&
+		s.hits[WRITE_CHECKS] == 5 && !s.timedout;
+	ok &= pread(fd, buffer + unit, unit, writer.offset) == (ssize_t)unit &&
+		bytes_equal(buffer + unit, unit, 0x5a);
+	ksft_print_msg("retry evidence: checks=%lu tries=%lu rejects=%lu waits=%lu\n",
+		s.hits[WRITE_CHECKS], s.hits[WRITE_ADMIT], s.hits[WRITE_REJECT],
+		s.hits[WAIT_UNLOCKED]);
+	close(control);
+	return ok;
+}
+
+/* Move EOF and change the process limit with the writer's IOLOCK dropped. */
+static int append_revalidation(int fd, void *buffer, size_t unit, int mode)
+{
+	struct parked_read old;
+	struct request drain = { .fd = fd, .length = 2 * unit,
+		.offset = 8 * unit, .punch = true };
+	struct request writer = { .buffer = buffer, .length = 2 * unit };
+	struct rlimit saved, limit;
+	struct snapshot s;
+	struct stat st;
+	pthread_t draining, writing;
+	char path[64];
+	int control, appendfd;
+	bool ok;
+	bool expand = mode == 1, unaligned = mode == 2;
+	size_t expected = unaligned ? 1 : (expand ? 2 : 1) * unit;
+
+	prefill(fd, buffer, unit);
+	park_read(&old, fd, unit);
+	if (pthread_create(&draining, NULL, submit, &drain))
+		die("append-range punch thread");
+	wait_exclusion(fd, buffer + 2 * unit, unit, 8 * unit);
+	control = arm(fd, GATE(WAIT_UNLOCKED));
+	if (control < 0) {
+		release_read(&old, buffer + 2 * unit, unit);
+		pthread_join(draining, NULL);
+		return -1;
+	}
+	snprintf(path, sizeof(path), "/proc/self/fd/%d", fd);
+	appendfd = open(path, O_RDWR | O_DIRECT | O_APPEND);
+	if (appendfd < 0 || getrlimit(RLIMIT_FSIZE, &saved))
+		die("append descriptor/limit");
+	limit = saved;
+	limit.rlim_cur = expand ? 9 * unit : RLIM_INFINITY;
+	if (setrlimit(RLIMIT_FSIZE, &limit))
+		die("initial write limit");
+	writer.fd = appendfd;
+	if (pthread_create(&writing, NULL, submit, &writer))
+		die("append writer thread");
+	wait_event(control, WAIT_UNLOCKED, 1);
+	s = snapshot(control);
+	ok = s.value[WAIT_UNLOCKED] == 8 * unit &&
+		s.value[WRITE_CHECKS] == (expand ? unit : 2 * unit);
+	limit.rlim_cur = unaligned ? 14 * unit + 1 : (expand ? 16 : 15) * unit;
+	if (setrlimit(RLIMIT_FSIZE, &limit))
+		die("updated write limit");
+	release_read(&old, buffer + 2 * unit, unit);
+	pthread_join(draining, NULL);
+	ok &= drain.result == 0;
+	if (ftruncate(fd, 14 * unit))
+		die("move append EOF while IOLOCK dropped");
+	command(control, "gate", 0);
+	pthread_join(writing, NULL);
+	if (setrlimit(RLIMIT_FSIZE, &saved))
+		die("restore write limit");
+	s = snapshot(control);
+	ok &= (unaligned ? writer.result == -1 && writer.error == EINVAL :
+		writer.result == (ssize_t)expected) && s.hits[WRITE_CHECKS] == 2 &&
+		s.hits[WAIT_UNLOCKED] == 1 && s.value[WRITE_ADMIT] == 14 * unit &&
+		s.value[WRITE_CHECKS] == expected && !s.timedout;
+	ok &= !fstat(fd, &st) && st.st_size == (off_t)(14 * unit + (unaligned ? 0 : expected));
+	if (!unaligned)
+		ok &= pread(fd, buffer + 2 * unit, expected, 14 * unit) == (ssize_t)expected &&
+			bytes_equal(buffer + 2 * unit, expected, 0x5a);
+	ok &= pread(fd, buffer + 2 * unit, unit, 8 * unit) == (ssize_t)unit &&
+		bytes_equal(buffer + 2 * unit, unit, 0);
+	ksft_print_msg("append evidence: checks=%lu initial_count=%zu final_count=%lu "
+		"position=%lu result=%zd\n", s.hits[WRITE_CHECKS],
+		expand ? unit : 2 * unit, s.value[WRITE_CHECKS],
+		s.value[WRITE_ADMIT], writer.result);
+	close(appendfd);
+	close(control);
+	return ok;
+}
+
+static void timeout_handler(int signal)
+{
+	(void)signal;
+	_exit(KSFT_FAIL);
+}
+
+int main(int argc, char **argv)
+{
+	struct statfs fs;
+	char *path;
+	void *buffer;
+	size_t unit;
+	int fd, result, failed = 0;
+
+	ksft_print_header();
+	if (argc != 2 || statfs(argv[1], &fs) || fs.f_type != XFS_SUPER_MAGIC)
+		ksft_exit_skip("requires a writable XFS directory\n");
+	unit = sysconf(_SC_PAGESIZE);
+	if ((size_t)fs.f_bsize > unit)
+		unit = fs.f_bsize;
+	if (asprintf(&path, "%s/xfs-admission-XXXXXX", argv[1]) < 0 ||
+	    posix_memalign(&buffer, unit, 16 * unit))
+		die("test allocation");
+	fd = mkostemp(path, O_DIRECT);
+	if (fd < 0)
+		die("test file");
+	unlink(path);
+	free(path);
+	signal(SIGALRM, timeout_handler);
+	alarm(40);
+	ksft_set_plan(4);
+	result = repeated_admission(fd, buffer, unit);
+	if (result < 0)
+		ksft_exit_skip("requires CONFIG_XFS_DIO_TEST and mounted debugfs\n");
+	ksft_test_result(result, "released writer retries two successive exclusions\n");
+	failed |= !result;
+	for (int mode = 0; mode < 3; mode++) {
+		const char *names[] = { "reduced aligned", "expanded", "reduced unaligned" };
+
+		result = append_revalidation(fd, buffer, unit, mode);
+		ksft_test_result(result == 1, "dropped IOLOCK revalidates append and %s limit\n",
+				names[mode]);
+		failed |= result != 1;
+	}
+	alarm(0);
+	free(buffer);
+	close(fd);
+	ksft_exit(!failed);
+}
diff --git a/tools/testing/selftests/filesystems/xfs_dio_drain.c b/tools/testing/selftests/filesystems/xfs_dio_drain.c
new file mode 100644
index 000000000000..f2e005f6e896
--- /dev/null
+++ b/tools/testing/selftests/filesystems/xfs_dio_drain.c
@@ -0,0 +1,371 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Run against a writable XFS directory. CONFIG_USERFAULTFD and permission to
+ * handle kernel-originated faults are needed for the controlled cohort cases.
+ * The mapped-source cases need CONFIG_AIO; the COW case also needs reflink.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/magic.h>
+#include <linux/aio_abi.h>
+#include <linux/fs.h>
+#include <linux/userfaultfd.h>
+#include <poll.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stdatomic.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/statfs.h>
+#include <sys/syscall.h>
+#include <sys/uio.h>
+#include <time.h>
+#include <unistd.h>
+#include "../kselftest.h"
+
+struct request {
+	int fd;
+	void *buffer;
+	size_t length;
+	off_t offset;
+	bool punch;
+	bool aio;
+	pthread_barrier_t *start;
+	atomic_bool done;
+	ssize_t result;
+};
+
+static ssize_t submit_aio(struct request *req)
+{
+	aio_context_t context = 0;
+	struct iocb cb = {
+		.aio_lio_opcode = IOCB_CMD_PWRITE, .aio_fildes = req->fd,
+		.aio_buf = (uintptr_t)req->buffer, .aio_nbytes = req->length,
+		.aio_offset = req->offset,
+	};
+	struct iocb *list[] = { &cb };
+	struct io_event event;
+	struct timespec timeout = { .tv_sec = 5 };
+	ssize_t result;
+
+	if (syscall(__NR_io_setup, 1, &context))
+		return -errno;
+	if (syscall(__NR_io_submit, context, 1, list) != 1)
+		result = -errno;
+	else if (syscall(__NR_io_getevents, context, 1, 1, &event, &timeout) != 1)
+		result = -ETIMEDOUT;
+	else
+		result = event.res;
+	syscall(__NR_io_destroy, context);
+	return result;
+}
+
+static void *submit(void *data)
+{
+	struct request *req = data;
+
+	if (req->start)
+		pthread_barrier_wait(req->start);
+	if (req->punch)
+		req->result = fallocate(req->fd,
+			FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+			req->offset, req->length);
+	else if (req->aio)
+		req->result = submit_aio(req);
+	else
+		req->result = pwrite(req->fd, req->buffer, req->length, req->offset);
+	atomic_store(&req->done, true);
+	return NULL;
+}
+
+static long long milliseconds(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	return (long long)ts.tv_sec * 1000 + ts.tv_nsec / 1000000;
+}
+
+static void timeout_handler(int sig)
+{
+	static const char message[] = "XFS DIO drain test timed out\n";
+
+	(void)sig;
+	if (write(STDERR_FILENO, message, sizeof(message) - 1) < 0)
+		_exit(KSFT_FAIL);
+	_exit(KSFT_FAIL);
+}
+
+static int faultfd(void *buffer, size_t length)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	struct uffdio_register reg = {
+		.range = { .start = (uintptr_t)buffer, .len = length },
+		.mode = UFFDIO_REGISTER_MODE_MISSING,
+	};
+	int fd;
+
+	/* Kernel-originated GUP faults must be handled, so omit USER_MODE_ONLY. */
+	fd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (fd < 0)
+		return -1;
+	if (ioctl(fd, UFFDIO_API, &api) || ioctl(fd, UFFDIO_REGISTER, &reg)) {
+		close(fd);
+		return -1;
+	}
+	return fd;
+}
+
+/*
+ * Stop a real, registered DIO in GUP. A drain must wait for this old request,
+ * although its file range is disjoint from the punch or post-EOF gap.
+ * Probe the exclusion before checking that newer disjoint I/O can complete.
+ */
+static int cohort_test(int fd, size_t unit, bool eof)
+{
+	struct request old = { .fd = fd, .length = unit, .offset = unit };
+	struct request drain = { .fd = fd, .length = unit,
+		.offset = (eof ? 10 : 4) * unit, .punch = !eof };
+	struct uffd_msg message;
+	struct uffdio_copy copy = { .len = unit };
+	struct pollfd pollfd;
+	struct iovec iov;
+	pthread_t writer, drainer;
+	void *buffer, *missing;
+	long long deadline;
+	bool excluded = false, progressed = false, rejected_write = false, ok = true;
+	int uffd;
+	ssize_t ret;
+
+	if (posix_memalign(&buffer, unit, 12 * unit))
+		ksft_exit_fail_msg("aligned allocation failed\n");
+	memset(buffer, 0x5a, 12 * unit);
+	if (ftruncate(fd, 0) || pwrite(fd, buffer, 8 * unit, 0) != 8 * (ssize_t)unit ||
+	    fsync(fd))
+		ksft_exit_fail_msg("prefill failed: %s\n", strerror(errno));
+	missing = mmap(NULL, unit, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (missing == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+	uffd = faultfd(missing, unit);
+	if (uffd < 0) {
+		free(buffer);
+		munmap(missing, unit);
+		return -1;
+	}
+	old.buffer = missing;
+	drain.buffer = buffer;
+	if (pthread_create(&writer, NULL, submit, &old))
+		ksft_exit_fail_msg("writer creation failed\n");
+	pollfd = (struct pollfd){ .fd = uffd, .events = POLLIN };
+	if (poll(&pollfd, 1, 5000) != 1 ||
+	    read(uffd, &message, sizeof(message)) != sizeof(message) ||
+	    message.event != UFFD_EVENT_PAGEFAULT)
+		ksft_exit_fail_msg("DIO did not reach the controlled GUP fault\n");
+	if (pthread_create(&drainer, NULL, submit, &drain))
+		ksft_exit_fail_msg("drainer creation failed\n");
+	iov = (struct iovec){ .iov_base = buffer + unit, .iov_len = unit };
+	deadline = milliseconds() + 5000;
+	do {
+		ret = preadv2(fd, &iov, 1, (eof ? 8 : 4) * unit, RWF_NOWAIT);
+		if (ret == -1 && errno == EAGAIN) {
+			excluded = true;
+			break;
+		}
+		if (atomic_load(&drain.done))
+			break;
+		usleep(1000);
+	} while (milliseconds() < deadline);
+	if (excluded) {
+		/* This must succeed before the stalled old request is released. */
+		ret = preadv2(fd, &iov, 1, 0, RWF_NOWAIT);
+		progressed = ret == (ssize_t)unit;
+		ret = pwritev2(fd, &iov, 1, (eof ? 8 : 4) * unit, RWF_NOWAIT);
+		rejected_write = ret == -1 && errno == EAGAIN;
+	}
+	ok = excluded && progressed && rejected_write && !atomic_load(&drain.done) &&
+		!atomic_load(&old.done);
+	if (!ok)
+		ksft_print_msg("%s: exclusion=%d disjoint-progress=%d drain-done=%d\n",
+			       eof ? "EOF" : "punch", excluded, progressed,
+			       atomic_load(&drain.done));
+	/* Resolve every missing source page and release both operations. */
+	memset(buffer, 0x5a, unit);
+	copy.src = (uintptr_t)buffer;
+	copy.dst = (uintptr_t)missing;
+	if (ioctl(uffd, UFFDIO_COPY, &copy))
+		ksft_exit_fail_msg("UFFDIO_COPY failed: %s\n", strerror(errno));
+	pthread_join(writer, NULL);
+	pthread_join(drainer, NULL);
+	ok &= old.result == (ssize_t)unit;
+	ok &= drain.result == (eof ? (ssize_t)unit : 0);
+	if (fsync(fd))
+		ok = false;
+	memset(buffer, 0xff, 12 * unit);
+	ret = pread(fd, buffer, (eof ? 11 : 8) * unit, 0);
+	ok &= ret == (eof ? 11 : 8) * (ssize_t)unit;
+	for (size_t i = 0; i < (eof ? 11 : 8) * unit; i++) {
+		unsigned char expected = 0x5a;
+
+		if (eof ? i >= 8 * unit && i < 10 * unit :
+			  i >= 4 * unit && i < 5 * unit)
+			expected = 0;
+		if (((unsigned char *)buffer)[i] != expected) {
+			ksft_print_msg("bad preserved data/gap at byte %zu\n", i);
+			ok = false;
+			break;
+		}
+	}
+	close(uffd);
+	munmap(missing, unit);
+	free(buffer);
+	return ok;
+}
+
+static bool bytes_equal(const void *buffer, size_t length, unsigned char value)
+{
+	const unsigned char *p = buffer;
+
+	for (size_t i = 0; i < length; i++) {
+		if (p[i] != value)
+			return false;
+	}
+	return true;
+}
+
+/* Exercise the MMAPLOCK fault dependency and real asynchronous COW end_io. */
+static int mapped_source_test(int fd, int clonefd, size_t unit, bool cow)
+{
+	void *buffer, *source;
+	bool ok = true;
+
+	if (posix_memalign(&buffer, unit, 8 * unit))
+		ksft_exit_fail_msg("aligned allocation failed\n");
+	memset(buffer, 0x5a, 8 * unit);
+	if (ftruncate(fd, 0) || pwrite(fd, buffer, 8 * unit, 0) != 8 * (ssize_t)unit ||
+	    fsync(fd))
+		ksft_exit_fail_msg("mapped source prefill failed\n");
+	source = mmap(NULL, unit, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (source == MAP_FAILED)
+		ksft_exit_fail_msg("file source mmap failed\n");
+	for (unsigned int round = 0; round < 64; round++) {
+		pthread_barrier_t barrier;
+		struct request writer = { .fd = fd, .buffer = source,
+			.length = unit, .offset = (cow ? 2 : 10) * unit,
+			.aio = round & 1, .start = &barrier };
+		struct request punch = { .fd = fd, .length = unit,
+			.offset = 4 * unit, .punch = true, .start = &barrier };
+		pthread_t writing, punching;
+
+		if (ftruncate(fd, 8 * unit))
+			ksft_exit_fail_msg("mapped source truncate failed\n");
+		if (cow) {
+			memset(buffer, 0xa5, unit);
+			if (pwrite(fd, buffer, unit, 2 * unit) != (ssize_t)unit || fsync(fd))
+				ksft_exit_fail_msg("COW destination prefill failed\n");
+			if (ioctl(clonefd, FICLONE, fd)) {
+				if (errno == EOPNOTSUPP || errno == ENOTTY) {
+					munmap(source, unit);
+					free(buffer);
+					return -1;
+				}
+				ksft_exit_fail_msg("FICLONE failed: %s\n", strerror(errno));
+			}
+		}
+		/* Drop PTEs and clean cache so GUP must fault through this inode. */
+		if (madvise(source, unit, MADV_DONTNEED) ||
+		    posix_fadvise(fd, 0, unit, POSIX_FADV_DONTNEED))
+			ksft_exit_fail_msg("cannot evict mapped source\n");
+		if (pthread_barrier_init(&barrier, NULL, 3) ||
+		    pthread_create(&writing, NULL, submit, &writer) ||
+		    pthread_create(&punching, NULL, submit, &punch))
+			ksft_exit_fail_msg("mapped source thread setup failed\n");
+		pthread_barrier_wait(&barrier);
+		pthread_join(writing, NULL);
+		pthread_join(punching, NULL);
+		pthread_barrier_destroy(&barrier);
+		if (writer.result == -ENOSYS) {
+			munmap(source, unit);
+			free(buffer);
+			return -1;
+		}
+		ok &= writer.result == (ssize_t)unit && punch.result == 0;
+		ok &= pread(fd, buffer, unit, writer.offset) == (ssize_t)unit &&
+			bytes_equal(buffer, unit, 0x5a);
+		ok &= pread(fd, buffer, unit, 4 * unit) == (ssize_t)unit &&
+			bytes_equal(buffer, unit, 0);
+		if (cow)
+			ok &= pread(clonefd, buffer, unit, 2 * unit) == (ssize_t)unit &&
+				bytes_equal(buffer, unit, 0xa5);
+		if (!ok)
+			break;
+	}
+	munmap(source, unit);
+	free(buffer);
+	return ok;
+}
+
+int main(int argc, char **argv)
+{
+	struct statfs fs;
+	char *path;
+	size_t unit;
+	int fd, clonefd, result, failed = 0;
+
+	ksft_print_header();
+	if (argc != 2)
+		ksft_exit_skip("usage: %s WRITABLE_XFS_DIRECTORY\n", argv[0]);
+	if (statfs(argv[1], &fs) || fs.f_type != XFS_SUPER_MAGIC)
+		ksft_exit_skip("requires a writable XFS directory\n");
+	unit = sysconf(_SC_PAGESIZE);
+	if ((size_t)fs.f_bsize > unit)
+		unit = fs.f_bsize;
+	if (asprintf(&path, "%s/xfs-dio-drain-XXXXXX", argv[1]) < 0)
+		ksft_exit_fail_msg("path allocation failed\n");
+	fd = mkostemp(path, O_DIRECT);
+	if (fd < 0)
+		ksft_exit_fail_msg("open failed: %s\n", strerror(errno));
+	unlink(path);
+	free(path);
+	if (asprintf(&path, "%s/xfs-dio-clone-XXXXXX", argv[1]) < 0)
+		ksft_exit_fail_msg("clone path allocation failed\n");
+	clonefd = mkostemp(path, O_DIRECT);
+	if (clonefd < 0)
+		ksft_exit_fail_msg("clone file open failed\n");
+	unlink(path);
+	free(path);
+	signal(SIGALRM, timeout_handler);
+	alarm(30);
+	ksft_set_plan(3);
+	for (int eof = 0; eof < 1; eof++) {
+		result = cohort_test(fd, unit, eof);
+		if (result < 0)
+			ksft_test_result_skip("%s drain needs kernel-fault userfaultfd support\n",
+					      eof ? "EOF" : "punch");
+		else {
+			ksft_test_result(result, "%s drain permits disjoint I/O\n",
+					 eof ? "EOF" : "punch");
+			failed |= !result;
+		}
+	}
+	for (int cow = 0; cow < 2; cow++) {
+		result = mapped_source_test(fd, clonefd, unit, cow);
+		if (result < 0)
+			ksft_test_result_skip("mapped source test needs AIO%s\n",
+					      cow ? " and reflink support" : "");
+		else {
+			ksft_test_result(result, "same-inode faulting source: %s vs punch\n",
+					 cow ? "sync/AIO COW writes" : "sync/AIO extending writes");
+			failed |= !result;
+		}
+	}
+	close(clonefd);
+	alarm(0);
+	close(fd);
+	ksft_exit(!failed);
+}
diff --git a/tools/testing/selftests/filesystems/xfs_dio_remap.c b/tools/testing/selftests/filesystems/xfs_dio_remap.c
new file mode 100644
index 000000000000..8460a932d195
--- /dev/null
+++ b/tools/testing/selftests/filesystems/xfs_dio_remap.c
@@ -0,0 +1,391 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Deterministic real-syscall admission retries; see CONFIG_XFS_DIO_TEST. */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/fs.h>
+#include <linux/fiemap.h>
+#include <linux/magic.h>
+#include <linux/userfaultfd.h>
+#include <poll.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/resource.h>
+#include <sys/stat.h>
+#include <sys/statfs.h>
+#include <sys/syscall.h>
+#include <sys/uio.h>
+#include <time.h>
+#include <unistd.h>
+#include "../kselftest.h"
+
+/* Event indices in fs/xfs/xfs_dio_test.h. */
+enum { BATCH_COLLECT = 2, WAIT_UNLOCKED = 4, WRITE_CHECKS, WRITE_ADMIT,
+	WRITE_REJECT, UNALIGNED_RECHECK, REMAP_ACTIVE, REMAP_UPGRADE, EVENTS };
+#define GATE(event) (1UL << (event))
+struct snapshot { unsigned long gates, timedout, hits[EVENTS], value[EVENTS]; };
+struct request {
+	int fd;
+	void *buffer;
+	size_t length;
+	off_t offset;
+	bool read, punch;
+	ssize_t result;
+	int error;
+};
+struct parked_read {
+	struct request req;
+	pthread_t thread;
+	int uffd;
+};
+
+static void die(const char *what)
+{
+	ksft_exit_fail_msg("%s: %s\n", what, strerror(errno));
+}
+
+static long long milliseconds(void)
+{
+	struct timespec now;
+
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	return now.tv_sec * 1000LL + now.tv_nsec / 1000000;
+}
+
+static void *submit(void *data)
+{
+	struct request *r = data;
+
+	if (r->punch)
+		r->result = fallocate(r->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				r->offset, r->length);
+	else if (r->read)
+		r->result = pread(r->fd, r->buffer, r->length, r->offset);
+	else
+		r->result = pwrite(r->fd, r->buffer, r->length, r->offset);
+	r->error = errno;
+	return NULL;
+}
+
+static void command(int control, const char *verb, unsigned long value)
+{
+	char text[80];
+	int len = snprintf(text, sizeof(text), "%s %lu", verb, value);
+
+	if (write(control, text, len) != len)
+		die("DIO test command");
+}
+
+static int arm(int fd, unsigned long gates)
+{
+	char text[80];
+	int control = open("/sys/kernel/debug/xfs/dio_test", O_RDWR);
+	int len;
+
+	if (control < 0)
+		return -1;
+	len = snprintf(text, sizeof(text), "arm %d %lu", fd, gates);
+	if (write(control, text, len) != len)
+		die("arm DIO test");
+	return control;
+}
+
+static struct snapshot snapshot(int control)
+{
+	struct snapshot s = { };
+	char buffer[2048], *cursor, *next;
+	ssize_t n = pread(control, buffer, sizeof(buffer) - 1, 0);
+
+	if (n <= 0)
+		die("read DIO test state");
+	buffer[n] = 0;
+	if (sscanf(buffer, "%lu %lu", &s.gates, &s.timedout) != 2)
+		die("parse DIO test state");
+	cursor = strchr(buffer, '\n');
+	for (int i = 0; i < EVENTS; i++) {
+		if (!cursor || sscanf(cursor + 1, "%lu %lu", &s.hits[i],
+				&s.value[i]) != 2)
+			die("parse DIO test event");
+		next = strchr(cursor + 1, '\n');
+		cursor = next;
+	}
+	return s;
+}
+
+static void wait_event(int control, int event, unsigned long count)
+{
+	long long deadline = milliseconds() + 5000;
+
+	do {
+		struct snapshot s = snapshot(control);
+
+		if (s.hits[event] >= count && !s.timedout)
+			return;
+		usleep(1000);
+	} while (milliseconds() < deadline);
+	ksft_exit_fail_msg("DIO event %d did not reach %lu\n", event, count);
+}
+
+static void park_read(struct parked_read *old, int fd, size_t unit)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	struct uffdio_register reg = { .mode = UFFDIO_REGISTER_MODE_MISSING };
+	struct uffd_msg message;
+	struct pollfd pollfd;
+
+	memset(old, 0, sizeof(*old));
+	old->req = (struct request){ .fd = fd, .length = unit,
+		.offset = unit, .read = true };
+	old->req.buffer = mmap(NULL, unit, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (old->req.buffer == MAP_FAILED)
+		die("missing read destination");
+	old->uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	reg.range.start = (uintptr_t)old->req.buffer;
+	reg.range.len = unit;
+	if (old->uffd < 0 || ioctl(old->uffd, UFFDIO_API, &api) ||
+	    ioctl(old->uffd, UFFDIO_REGISTER, &reg))
+		die("kernel-fault userfaultfd required by admission test");
+	if (pthread_create(&old->thread, NULL, submit, &old->req))
+		die("parked read thread");
+	pollfd = (struct pollfd){ .fd = old->uffd, .events = POLLIN };
+	if (poll(&pollfd, 1, 5000) != 1 ||
+	    read(old->uffd, &message, sizeof(message)) != sizeof(message) ||
+	    message.event != UFFD_EVENT_PAGEFAULT)
+		ksft_exit_fail_msg("read did not register and reach GUP\n");
+}
+
+static void release_read(struct parked_read *old, void *buffer, size_t unit)
+{
+	struct uffdio_copy copy = { .src = (uintptr_t)buffer,
+		.dst = (uintptr_t)old->req.buffer, .len = unit };
+
+	if (ioctl(old->uffd, UFFDIO_COPY, &copy))
+		die("release registered read");
+	pthread_join(old->thread, NULL);
+	if (old->req.result != (ssize_t)unit)
+		ksft_exit_fail_msg("registered read result %zd\n", old->req.result);
+	close(old->uffd);
+	munmap(old->req.buffer, unit);
+}
+
+static void wait_exclusion(int fd, void *buffer, size_t unit, off_t offset)
+{
+	struct iovec iov = { .iov_base = buffer, .iov_len = unit };
+	long long deadline = milliseconds() + 5000;
+
+	do {
+		if (preadv2(fd, &iov, 1, offset, RWF_NOWAIT) == -1 && errno == EAGAIN)
+			return;
+		usleep(1000);
+	} while (milliseconds() < deadline);
+	ksft_exit_fail_msg("real drainer did not publish exclusion\n");
+}
+
+static void prefill(int fd, void *buffer, size_t unit)
+{
+	memset(buffer, 0x5a, 16 * unit);
+	if (ftruncate(fd, 0) || pwrite(fd, buffer, 8 * unit, 0) != 8 * (ssize_t)unit ||
+	    fsync(fd))
+		die("prefill");
+}
+
+static bool bytes_equal(const void *buffer, size_t length, unsigned char value)
+{
+	const unsigned char *bytes = buffer;
+
+	for (size_t i = 0; i < length; i++)
+		if (bytes[i] != value)
+			return false;
+	return true;
+}
+
+/* FIEMAP proves sharing of the exact partial block before the writer resumes. */
+static bool shared_extent(int fd, off_t offset, uint64_t *physical)
+{
+	struct {
+		struct fiemap map;
+		struct fiemap_extent extent;
+	} request = { .map = { .fm_start = offset, .fm_length = 512,
+		.fm_flags = FIEMAP_FLAG_SYNC, .fm_extent_count = 1 } };
+
+	if (ioctl(fd, FS_IOC_FIEMAP, &request))
+		die("FIEMAP sharing proof");
+	if (request.map.fm_mapped_extents != 1 ||
+	    !(request.extent.fe_flags & FIEMAP_EXTENT_SHARED))
+		return false;
+	*physical = request.extent.fe_physical + offset - request.extent.fe_logical;
+	return true;
+}
+
+struct clone_request { int source, destination, result, error; };
+
+static void *clone_file(void *data)
+{
+	struct clone_request *r = data;
+
+	r->result = ioctl(r->destination, FICLONE, r->source);
+	r->error = errno;
+	return NULL;
+}
+
+/* Change COW eligibility only after observing the writer drop its IOLOCK. */
+static bool remap_revalidation(int fd, int clonefd, void *buffer, size_t unit,
+		bool active)
+{
+	struct parked_read old;
+	struct request punch = { .fd = fd, .offset = 4 * unit,
+		.length = unit, .punch = true };
+	struct request writer = { .fd = fd, .offset = 4 * unit + 512,
+		.buffer = buffer, .length = 512 };
+	struct clone_request clone = { .source = fd, .destination = clonefd };
+	struct snapshot s;
+	pthread_t punching, writing, cloning;
+	uint64_t source_physical = 0, clone_physical = 0;
+	char path[64];
+	int control, buffered;
+	bool ok;
+
+	prefill(fd, buffer, unit);
+	/* First write must really enter the unaligned direct path, before COW. */
+	if (ftruncate(clonefd, 0))
+		die("clear clone");
+	control = arm(fd, GATE(WAIT_UNLOCKED));
+	if (control < 0)
+		ksft_exit_skip("requires CONFIG_XFS_DIO_TEST and mounted debugfs\n");
+	park_read(&old, fd, unit);
+	if (pthread_create(&punching, NULL, submit, &punch))
+		die("punch thread");
+	wait_exclusion(fd, buffer + unit, unit, punch.offset);
+	memset(buffer, 0xa5, 512);
+	if (pthread_create(&writing, NULL, submit, &writer))
+		die("unaligned writer");
+	wait_event(control, WAIT_UNLOCKED, 1);
+	s = snapshot(control);
+	ok = s.value[WAIT_UNLOCKED] == (unsigned long)writer.offset &&
+		s.hits[UNALIGNED_RECHECK] == 0 && s.hits[WRITE_CHECKS] == 1;
+	release_read(&old, buffer + unit, unit);
+	pthread_join(punching, NULL);
+	ok &= punch.result == 0;
+	/* Restore a real allocated block after the punch, still with writer gated. */
+	snprintf(path, sizeof(path), "/proc/self/fd/%d", fd);
+	buffered = open(path, O_RDWR);
+	memset(buffer + unit, 0x5a, unit);
+	if (buffered < 0 || pwrite(buffered, buffer + unit, unit, 4 * unit) !=
+	    (ssize_t)unit || fsync(buffered))
+		die("restore block before clone");
+	close(buffered);
+	if (active)
+		command(control, "gate", GATE(WAIT_UNLOCKED) | GATE(REMAP_ACTIVE));
+	if (pthread_create(&cloning, NULL, clone_file, &clone))
+		die("reflink thread");
+	if (active) {
+		wait_event(control, REMAP_ACTIVE, 1);
+		/* Source IOLOCK is now shared, with IREMAPPING set. */
+		command(control, "release", GATE(WAIT_UNLOCKED));
+		wait_event(control, REMAP_UPGRADE, 1);
+		command(control, "release", GATE(REMAP_ACTIVE));
+	}
+	pthread_join(cloning, NULL);
+	if (clone.result)
+		ksft_exit_fail_msg("FICLONE failed: %s\n", strerror(clone.error));
+	/* Completed case can prove extent sharing before allowing any write. */
+	if (!active) {
+		ok &= shared_extent(fd, writer.offset, &source_physical) &&
+			shared_extent(clonefd, writer.offset, &clone_physical) &&
+			source_physical == clone_physical;
+		command(control, "gate", 0);
+	}
+	pthread_join(writing, NULL);
+	s = snapshot(control);
+	ok &= writer.result == 512 && !s.timedout && s.hits[WAIT_UNLOCKED] == 1 &&
+		s.hits[UNALIGNED_RECHECK] == 1 && s.hits[WRITE_ADMIT] == 0 &&
+		/* IOLOCK_EXCL=1, IOLOCK_SHARED=2; low bit records COW eligibility. */
+		s.value[UNALIGNED_RECHECK] == ((active ? 1UL : 2UL) << 8 | 1UL) &&
+		s.hits[REMAP_UPGRADE] == (unsigned long)active;
+	/* The last write-check pass is the buffered COW fallback. */
+	ok &= s.hits[WRITE_CHECKS] == 4 && !fsync(fd) && !fsync(clonefd);
+	ok &= pread(fd, buffer + unit, unit, 4 * unit) == (ssize_t)unit &&
+		bytes_equal(buffer + unit, 512, 0x5a) &&
+		bytes_equal(buffer + unit + 512, 512, 0xa5) &&
+		bytes_equal(buffer + unit + 1024, unit - 1024, 0x5a);
+	ok &= pread(clonefd, buffer + unit, unit, 4 * unit) == (ssize_t)unit &&
+		bytes_equal(buffer + unit, unit, 0x5a);
+	ksft_print_msg("remap evidence: active=%d waits=%lu upgrades=%lu rechecks=%lu "
+		"lock_cow=%lu checks=%lu admits=%lu shared_physical=%llu result=%zd\n", active,
+		s.hits[WAIT_UNLOCKED], s.hits[REMAP_UPGRADE], s.hits[UNALIGNED_RECHECK],
+		s.value[UNALIGNED_RECHECK], s.hits[WRITE_CHECKS], s.hits[WRITE_ADMIT],
+		(unsigned long long)source_physical, writer.result);
+	close(control);
+	return ok;
+}
+
+static void timeout_handler(int signal)
+{
+	(void)signal;
+	_exit(KSFT_FAIL);
+}
+
+int main(int argc, char **argv)
+{
+	struct statfs fs;
+	char *path;
+	void *buffer;
+	size_t unit;
+	int fd, clonefd, failed = 0;
+
+	ksft_print_header();
+	if (argc != 2 || statfs(argv[1], &fs) || fs.f_type != XFS_SUPER_MAGIC)
+		ksft_exit_skip("requires a writable XFS directory\n");
+	unit = sysconf(_SC_PAGESIZE);
+	if ((size_t)fs.f_bsize > unit)
+		unit = fs.f_bsize;
+	if (asprintf(&path, "%s/xfs-remap-XXXXXX", argv[1]) < 0 ||
+	    posix_memalign(&buffer, unit, 16 * unit))
+		die("test allocation");
+	fd = mkostemp(path, O_DIRECT);
+	if (fd < 0)
+		die("test file");
+	unlink(path);
+	free(path);
+	if (asprintf(&path, "%s/xfs-clone-XXXXXX", argv[1]) < 0)
+		die("clone path");
+	clonefd = mkostemp(path, O_DIRECT);
+	if (clonefd < 0)
+		die("clone file");
+	unlink(path);
+	free(path);
+	signal(SIGALRM, timeout_handler);
+	alarm(40);
+	ksft_set_plan(2);
+	for (int active = 0; active < 2; active++) {
+		/* Each case needs an inode that has never carried the reflink flag. */
+		bool ok = remap_revalidation(fd, clonefd, buffer, unit, active);
+
+		ksft_test_result(ok, "dropped IOLOCK rechecks %s reflink and unaligned COW\n",
+			active ? "active" : "completed");
+		failed |= !ok;
+		/* Reflink flags persist, so use a fresh writer inode for each case. */
+		if (!active) {
+			close(fd);
+			if (asprintf(&path, "%s/xfs-remap-XXXXXX", argv[1]) < 0)
+				die("second path");
+			fd = mkostemp(path, O_DIRECT);
+			if (fd < 0)
+				die("second inode");
+			unlink(path);
+			free(path);
+		}
+	}
+	alarm(0);
+	close(fd);
+	close(clonefd);
+	free(buffer);
+	ksft_exit(!failed);
+}
-- 
2.56.0

