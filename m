Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808B01D6DB5
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 13:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781097249; cv=none; b=CtJP38x3Ztjd73av81RO9sHCqYDVro/mD7I3NwUm0ypr7bclrsPzBbgoyiDE+sQ6dgz71qustKM9wtFOXR+1kNdee3jWDS9FTGyKQ49mQNTmXApCGvL/cGYHQWR6v1oVd2ZQAu6VliBf/4f8KntkwNcq7bCsQTGFFI9EyDXteVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781097249; c=relaxed/simple;
	bh=2Co9xpWvOpS+ugZcRMHwXMN85OSgEIWOjqRAiOy9agQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cd+D59UVQogQRESFBlwJ2i3SgpSK4lPVlMDIy1j9iWKsy/c736ZCPozZcn6pZwvqtaVqVx2Y/qJJu+fPvWSBoCKowUpBDTN6nTSejJ4qOvOpzzC7bda93SNqlVCSNE+faKM+lIetGHDaUbix5UBHrMOlry2GAAwzcjho+Yyz36Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SmffTHqB; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SmffTHqB"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2bf1cda2b17so49986275ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 06:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781097248; x=1781702048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2igjWtyCiyN9zbV+MQByKKwsuX9AtCFL3iCwtEAnNQg=;
        b=SmffTHqBN47NlnBcmKscIQnEQGq8e/SmnkMpQePSeFEHLswW4OC5sLQofeGznAH62b
         pDK0o5Bqo3G+rA703J4qwrofn5DusVQqWuhBg2353605098YRk/6NiDwjxrr+PooDrT5
         zlWKzbW5vigxAqVeiVU2tXOwjQsFciTzg7xdmnf4wlcHG6fBU1h8KeAh6H19Akv11MRA
         ljOi5GdJ++QjBF+APdk4lguTrllY3uOmU8EYNOqekdy0oo/k7MO4we/PoVtf1LM5glXc
         hjcDLcl3ZAES5MtLss20MxH1oWxOWVsb8j2Yg3LQbksWAlSMD7gGp/kldlNPkc+fCKAL
         d7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781097248; x=1781702048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2igjWtyCiyN9zbV+MQByKKwsuX9AtCFL3iCwtEAnNQg=;
        b=PwyjMs8Ab8vchRDRD/YJXC2Ud++OzAxcSXL1FNgOq2tU/7MniD4GOZkj9vTg4iqy8h
         BzqirDN7iIGyBxImK6ATkqnJTH6mp9bF1WKA+vGKphdCnZPq/Px7NCd9b0mifSX0gl+0
         oWrxrjGdmfz3KyNR6iissF/0bblwBy+vCefpmwAfEg0v2ThCW+z3IKkIdY1QPwMPHLGe
         CvZoarU9VH2j4sSeEZgNs2JEeJRcoHNkB77MpfYsexH++SX3uKrP2nQbvrOxWjBb5NxJ
         48cuxo6cirMlAE+WyNsAH7K0EhMYzchULxbwGXNoOG64f5z7/YLK1I54BpnxL+Uaqx9m
         wfYg==
X-Gm-Message-State: AOJu0YyfjHZh/auNvb/BjX93/Dze5D14woZ98j7IHErUjRIXAOrS/OMz
	lBQHQugV35ThAlh5b60/DBtnvzFYSzyk7pq7CN7oQ6Xb84flRudi0QHg
X-Gm-Gg: Acq92OFhAMPTNPbYO3KeQG+ibnszBFIQVNq4c5Iv9clYxLUG6d4KVNdTcMqjsF7xGCh
	5yv1+V+oExwKZD3BSirrJn6ppNtuhxsmHoAB9/0MaZPZKwcomNtQBXV0ZOrJrvFxXApXdWb3ewc
	mTW1/uW8ZVQRnp7WTimxCYVtzkW+sAYBRD/jAb+KJO3CPoNIgazswhL6gtprRPzXKPPipHthm8+
	bZDGnU4qI73kbdzN609ezpp+1OgGI/coC7Dez25cExubvB2j9hB5gSCzfYNzpeKdxiLriZnbqUk
	bjnKxGywDqy+ugiuNsHCkLKjG8uEhXCuvNtzNi4d4EIsVtD0RgRgGeZzG05wCftLh7TNWtfh/Pd
	L1riUYbm3xVds5rJ3jS/CV7Dm1CaXoDXE5BRfnWNWkqZZ8njOhKFX1ZRVq0+HRfNb2iy0lpLVS7
	22MYFFhkJVTFdjeiafALho5GCIUT2s9umFq/7f0eXVUB0HFiZKOrteLQu/7c0N2jNQVOcoNHb6F
	rcdSY+cV+3lBDgcelgomU395KkJQn8hBKCpihPoedfVaFYYTEgLDhwE5f9JPjumw/+OhgMXjf8H
	RK0lgSHFI80Af60XNpLIT4srn4/CqmPBLKd7zt9TjWCBi/s/9A==
X-Received: by 2002:a17:902:d2cd:b0:2c0:b74f:a58c with SMTP id d9443c01a7336-2c1ec7972e4mr210878825ad.16.1781097247866;
        Wed, 10 Jun 2026 06:14:07 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.d33bddc1d573818c7-tp.internal (160.248.124.34.bc.googleusercontent.com. [34.124.248.160])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16649ab01sm237743905ad.71.2026.06.10.06.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 06:14:07 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH] xfs: prevent close() from hanging on frozen filesystems
Date: Wed, 10 Jun 2026 13:13:41 +0000
Message-ID: <20260610131341.1733-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
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
process of freezing, as it waits to acquire the superblock's write lock.

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

We can safely skip this post-EOF cleanup optimization during a filesystem
freeze because:

1. Speculative preallocation is purely a performance heuristic to prevent
   fragmentation, not a requirement for file correctness or metadata
   consistency. The frozen snapshot remains completely consistent and safe,
   regardless of whether these post-EOF blocks are freed before or
   after thaw.

2. No space is permanently leaked. Any skipped speculative preallocations
   are safely preserved and will be scanned and reclaimed automatically by
   the background block garbage collection (blockgc) workers once the
   filesystem is thawed.

3. Precedent already exists in xfs_file_release() to skip this truncation:
   it already uses xfs_ilock_nowait() and silently skips the cleanup if
   the lock cannot be acquired, relying on background or future cleanup to
   avoid mmdeadlocks. Skipping under fsfreeze is highly consistent with
   this existing design.

Note that background blockgc and inodegc workers are already explicitly
stopped during freeze (via xfs_blockgc_stop() and xfs_inodegc_stop()),
leaving the synchronous xfs_file_release() path as the sole remaining
unblocked path that could attempt write transactions on a frozen
filesystem.

Fix this hang by checking if the filesystem is writable at the
SB_FREEZE_WRITE level in xfs_file_release() and returning early if it
is frozen or freezing.

A simple C reproducer demonstrating the hang (compile with -pthread):

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
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
 fs/xfs/xfs_file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 845a97c9b063..401403e066c9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1798,6 +1798,15 @@ xfs_file_release(
 	    xfs_is_zoned_inode(ip))
 		return 0;
 
+	/*
+	 * If the filesystem is frozen or freezing, don't trigger transactions
+	 * that would block close() indefinitely. Background block garbage
+	 * collection will clean up these speculative preallocations once
+	 * the filesystem thaws.
+	 */
+	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
+		return 0;
+
 	/*
 	 * If we can't get the iolock just skip truncating the blocks past EOF
 	 * because we could deadlock with the mmap_lock otherwise. We'll get
-- 
2.47.3

