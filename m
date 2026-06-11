Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A40F34B66F
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781201162; cv=none; b=oz1B0gu6yaVn5xBEpcAj0g3WpP9OwDNmYByvkNRBIAlwlWrmK0O0BMAsm4XapWc4lpiL6sgn6agN8QJ1dxMFNsjQ5Jbv5KwGMhPBUx1K73W8ckgIWLq20CXFBQc1PsEwnPYDv4XLhU9T2BVkQeSs3zOYsBQYa757WAS1WHQkxT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781201162; c=relaxed/simple;
	bh=pUww7H2bjQMlRBPUphl7A7bqahuGoP+VGc5oETs7tsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laQMtriqRCaHmDJedTXQBz6M4kLN+GrgvtUnRe9pnIJa4HDDjSFVVmHRqGscKS1G7KU+YyvTMcVIyc9c1uOvt2zpKpJZGojZyH1jwtlsJ9ZsrkN7WlONKBOe+5MY1jEDyElCCmAE29B1Wk62l73gghrUA5wuoTIqGgAAyre/AH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bdebZCMs; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bdebZCMs"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-36dd65b95f2so203886a91.0
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 11:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781201160; x=1781805960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1j3eDvP8UchTgRE6DH/XADnZJh8JMdhP22aHpf9sOg=;
        b=bdebZCMsBTyacqNXLFQ8L9SL77p3ZximFZulorgN/gQ4pLM17zpfxmlufwQE7Y304n
         aOMEjs4qBOCGRZN7kL8y666+z5GdXOzb0wUPwvTw5Oq+5G4BWY6jZZE9Rx78hlLXA3Xm
         MaJrnMnozqHhQ/Yb8UXRo5l9VqvVlcoeu4+rXwz/An2ctFpPc/2OR5/QpWWtLgFB6Q6Z
         Gy18he7U2RkhzEAsXjPoVSCIhJKAmdvjGSBmfjh288+iJTIoZr5jw+mQ+G9BGlBhlo/q
         i1H0FMI7YZobu5jL602c59DZvGXZafjTbwhjb+ZFLVV0lSuOg1X4JVZ5Y8AqJ8s6vHHl
         SZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781201160; x=1781805960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v1j3eDvP8UchTgRE6DH/XADnZJh8JMdhP22aHpf9sOg=;
        b=szgfG/hf1zyzHh7Z6oMf2eKrVf3EbsEyV05513TvNLQ0ij3YzN0wErf8tC5eSimTF8
         LffsvVAeFFrNwwEWa664sCAEgpttJpyVuSbuRGjL/Q7yabnqCK/dKZlq/+xNzMCDf8qU
         4JeTw9tiQksuj2acOTZ7LYLlwO25xjM5WsRmmEX7AInUPcmHiF9CbMuu4uGaAUyUYlxR
         LfhrMO63wJsp2YHiOzQZoFt5N2DC807nQ3mkxA5KSMBaN1fGln92JrtC5CdiCB2PdJxY
         +vK64JPz9FbhpEXv5ahEI+StT5+F4bfa3ABqStY+bQ8EBAeVt0lIOUamtQdeLMmvSFXd
         R3Og==
X-Forwarded-Encrypted: i=1; AFNElJ+O+0XNAPvF9MtHUTvKxMFalIXE6Pc7UOysAGQtiPtw3NWwW2npIHEdPixA9goU66mW1oMLxAPg3ws=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5tRxCGSJLpL26lFF2SfDJEKARwqermpvXUsOLvtv/k3uRw4Ui
	GmgxJOGrutNpaeoJMHOlJMx1TKOPHY3H1yBn/qVtCmBK+zcl34eKKSfE
X-Gm-Gg: Acq92OHGI2d9bloU2L54ogsTlD2y39YRCiB4NT74HhgpB/TJ5IyX7mrHxjU7UbvjCDk
	HQSx8l46u/kYhTGSwCGl1ZtOuQBUgw8D8VLxneLF+6ZqH0MioTJXsQnC2r6joh6KSO+ek497QJB
	h1muIP1kzUdV4THFgr1JIRBI47UZIpotZ3tfvBe0M5tRehu99bkflG2sHAxmoKn9rWuEYgc7K4K
	rDd9o6Rj1QhvdCU59JCdpFgevFlnv5XRieIDzN2CczUmWl9xZeeempHCdVwff8LEn5L2tHnw9Oi
	Gt2PcSNSgSvae/JDPNXH09Zh8w4edHWlW6e/cH5ewn8WbfwLTf0WB+wXSZF85EQTSDM5d5Ge55Q
	EA34gk7vXxfWNLr5f7zzm2hOLLEr4dhKiSSB3w1ninQhUHk9xpbd6gHG/etTKChPp2W4sc5dNzN
	/89y0AQ36EQe1UpBk6FgMHfiOHXG51gOZ+j1WIiIQ9I7Myy2IzlI2+cmvFtOhUdo+h9kxkSSXfq
	UMMl96FvzFvVu5aAmYzdluCyxRNWlZPbaQxfs8mUOiqqIhpWd7/3kT8gw6dWpfKqr/SU5xwdhG6
	cYYC3lmXLdBSzFBqbWvBR8yfz9xgz/HAaz/z
X-Received: by 2002:a17:90b:3f43:b0:36a:8254:8eb1 with SMTP id 98e67ed59e1d1-3780375948emr3053052a91.6.1781201159504;
        Thu, 11 Jun 2026 11:05:59 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (86.147.142.34.bc.googleusercontent.com. [34.142.147.86])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37752b5a8ecsm4131788a91.7.2026.06.11.11.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 11:05:59 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v2] xfs: prevent close() from hanging on frozen filesystems
Date: Thu, 11 Jun 2026 18:05:32 +0000
Message-ID: <20260611180532.1725-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ailmd8JNOT62E6vD@infradead.org>
References: <ailmd8JNOT62E6vD@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

When a file with active speculative post-EOF preallocations is closed,
xfs_file_release() synchronously triggers xfs_free_eofblocks() to clean
them up. This requires allocating a write transaction (xfs_trans_alloc),
which blocks indefinitely if the filesystem is currently frozen or in the
process of freezing, as it waits to acquire the superblock's write lock
via sb_start_intwrite().

As a result, a close() system call on a read-write file descriptor can
hang indefinitely in percpu_rwsem_wait() until the filesystem is thawed,
even if the file is closed by a non-writer process or after all writing
activity has already ceased.

This issue has been seen across multiple downstream environments and has a
long history of causing severe system disruption. For example:
- Downstream Red Hat Bugzilla 1474726 (dating back to 2017) details
  complete system hangs during system backups when rsync and fsfreeze
  are used. Even seemingly harmless read-only commands like
  'cat /var/log/messages' would hang on close() in __sb_start_write
  via xfs_free_eofblocks, requiring a hard reboot.
- Downstream LeApp integration test scenarios (e.g. systemd-rsync migration
  checks) consistently hit this hang when trying to freeze the system.

Historically, XFS maintainers dismissed this behavior as NOTABUG, claiming
that close() is not a read-only operation and is expected to block since it
allocates write transactions. However, this behavior is highly disruptive.
User-space applications view close() as a resource reclamation system call,
not a write operation, and do not expect it to block. Hanging on close()
frequently triggers container healthcheck failures, systemd service
timeouts, and cluster failover cascades.

Additionally, no other major Linux filesystem (such as ext4 or btrfs)
synchronously allocates write transactions during close() system calls,
making this hang a highly unexpected and disruptive behavior unique to XFS.

To fix this properly and avoid any potential race conditions where a freeze
might come in immediately after a writable check (such as xfs_fs_writable),
we introduce a new transaction allocation flag: XFS_TRANS_TRYLOCK.

When XFS_TRANS_TRYLOCK is set, __xfs_trans_alloc() attempts to obtain
freeze protection using sb_start_intwrite_trylock() instead of blocking
on sb_start_intwrite(). If the trylock fails, the allocation is aborted
gracefully, freeing the newly allocated transaction handle and returning
-EAGAIN.

We then extend xfs_free_eofblocks() to accept transaction allocation flags,
and pass XFS_TRANS_TRYLOCK during xfs_file_release(). If the call returns
-EAGAIN, we cleanly clear the XFS_EOFBLOCKS_RELEASED flag so that
subsequent releases or the background blockgc garbage collector can get
another chance to clean up these speculative preallocations once the
filesystem thaws.

This approach is safe, race-free, and ensures close() never blocks on
frozen filesystems.

As requested, I have added a GPLv2-compatible license to the C reproducer
provided below, and I will be working on wiring up this reproducer into
the standard xfstests suite in the near future.

A simple GPLv2-licensed C reproducer demonstrating the hang (compile
with -pthread):

    /*
     * GPLv2-compatible XFS freeze close() hang reproducer.
     * Copyright (c) 2026 Aditya Prakash Srivastava. All Rights Reserved.
     */
    #define _GNU_SOURCE
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <unistd.h>
    #include <fcntl.h>
    #include <pthread.h>
    #include <sys/ioctl.h>
    #include <sys/vfs.h>
    #include <linux/fs.h>
    #include <libgen.h>

    volatile int close_started = 0;
    volatile int close_completed = 0;

    void *close_thread(void *arg) {
        int fd = *(int *)arg;
        close_started = 1;
        close(fd);
        close_completed = 1;
        return NULL;
    }

    int main(int argc, char *argv[]) {
        struct statfs sfs;
        statfs(argv[1], &sfs);
        if (sfs.f_type != 0x58465342) return 1;

        int freeze_fd = open(dirname(strdup(argv[1])), O_RDONLY);
        int write_fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
        char buf[65536] = {0};
        for (int i = 0; i < 320; i++) write(write_fd, buf, sizeof(buf));

        ioctl(freeze_fd, FIFREEZE, 0);
        pthread_t thread;
        pthread_create(&thread, NULL, close_thread, &write_fd);
        while (!close_started) usleep(1000);
        usleep(1000000); // Wait 1s
        if (!close_completed) printf("SUCCESS: close() hung!\\n");
        ioctl(freeze_fd, FITHAW, 0);
        pthread_join(thread, NULL);
        unlink(argv[1]);
        return 0;
    }

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205833
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1474726
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
Changes since v1:
- Drop the racy xfs_fs_writable() check from the previous version.
- Introduce the new XFS_TRANS_TRYLOCK transaction flag.
- Attempt non-blocking superblock locking via sb_start_intwrite_trylock()
  when XFS_TRANS_TRYLOCK is set, returning -EAGAIN on failure.
- Update xfs_free_eofblocks() to accept flags, allowing xfs_file_release()
  to handle -EAGAIN and gracefully retry/defer post-thaw.
- Add GPLv2-compatible licensing to the C reproducer.

 fs/xfs/libxfs/xfs_shared.h |  3 +++
 fs/xfs/xfs_bmap_util.c     |  9 +++++----
 fs/xfs/xfs_bmap_util.h     |  2 +-
 fs/xfs/xfs_file.c          | 13 +++++++++++--
 fs/xfs/xfs_icache.c        |  2 +-
 fs/xfs/xfs_inode.c         |  2 +-
 fs/xfs/xfs_trans.c         | 18 ++++++++++++++++--
 7 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index b1e0d9bc1f7d..6b2a1026ff60 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -164,6 +164,9 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 /* Transaction has locked the rtbitmap and rtsum inodes */
 #define XFS_TRANS_RTBITMAP_LOCKED	(1u << 9)
 
+/* Try lock filesystem superblock for freeze protection */
+#define XFS_TRANS_TRYLOCK		(1u << 10)
+
 /*
  * Field values for xfs_trans_mod_sb.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0ab00615f1ad..56c7919bf1e5 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -574,7 +574,8 @@ xfs_can_free_eofblocks(
  */
 int
 xfs_free_eofblocks(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	uint			flags)
 {
 	struct xfs_trans	*tp;
 	struct xfs_mount	*mp = ip->i_mount;
@@ -604,9 +605,9 @@ xfs_free_eofblocks(
 		return 0;
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, flags, &tp);
 	if (error) {
-		ASSERT(xfs_is_shutdown(mp));
+		ASSERT(error == -EAGAIN || xfs_is_shutdown(mp));
 		return error;
 	}
 
@@ -928,7 +929,7 @@ xfs_prepare_shift(
 	 * into the accessible region of the file.
 	 */
 	if (xfs_can_free_eofblocks(ip)) {
-		error = xfs_free_eofblocks(ip);
+		error = xfs_free_eofblocks(ip, 0);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index c477b3361630..227371579205 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -66,7 +66,7 @@ int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip);
-int	xfs_free_eofblocks(struct xfs_inode *ip);
+int	xfs_free_eofblocks(struct xfs_inode *ip, uint flags);
 
 int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
 			 struct xfs_swapext *sx);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 845a97c9b063..16aba428854e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1807,8 +1807,17 @@ xfs_file_release(
 	if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
 	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 		if (xfs_can_free_eofblocks(ip) &&
-		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
-			xfs_free_eofblocks(ip);
+		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED)) {
+			int error = xfs_free_eofblocks(ip, XFS_TRANS_TRYLOCK);
+
+			/*
+			 * If transaction allocation fails due to a frozen/freezing
+			 * filesystem, clear the released flag so that subsequent
+			 * releases or background blockgc can retry post-thaw.
+			 */
+			if (error == -EAGAIN)
+				xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEASED);
+		}
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2040a9292ee6..c575b4acb24c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1259,7 +1259,7 @@ xfs_inode_free_eofblocks(
 	*lockflags |= XFS_IOLOCK_EXCL;
 
 	if (xfs_can_free_eofblocks(ip))
-		return xfs_free_eofblocks(ip);
+		return xfs_free_eofblocks(ip, 0);
 
 	/* inode could be preallocated */
 	trace_xfs_inode_free_eofblocks_invalid(ip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9978ac1422fc..1c75f51af4d7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1423,7 +1423,7 @@ xfs_inactive(
 		 * reference to the inode at this point anyways.
 		 */
 		if (xfs_can_free_eofblocks(ip))
-			error = xfs_free_eofblocks(ip);
+			error = xfs_free_eofblocks(ip, 0);
 
 		goto out;
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 148cc32449c1..b214ef5c28c1 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -218,8 +218,20 @@ __xfs_trans_alloc(
 	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) || xfs_has_lazysbcount(mp));
 
 	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
-	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
-		sb_start_intwrite(mp->m_super);
+	if (!(flags & XFS_TRANS_NO_WRITECOUNT)) {
+		/*
+		 * If TRYLOCK is specified, attempt a non-blocking lock to
+		 * avoid blocking indefinitely on frozen/freezing filesystems.
+		 */
+		if (flags & XFS_TRANS_TRYLOCK) {
+			if (!sb_start_intwrite_trylock(mp->m_super)) {
+				kmem_cache_free(xfs_trans_cache, tp);
+				return ERR_PTR(-EAGAIN);
+			}
+		} else {
+			sb_start_intwrite(mp->m_super);
+		}
+	}
 	xfs_trans_set_context(tp);
 	tp->t_flags = flags;
 	tp->t_mountp = mp;
@@ -252,6 +264,8 @@ xfs_trans_alloc(
 	 */
 retry:
 	tp = __xfs_trans_alloc(mp, flags);
+	if (IS_ERR(tp))
+		return PTR_ERR(tp);
 	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error == -ENOSPC && want_retry) {
-- 
2.47.3

