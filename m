Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F2D2652AF
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 12:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781265899; cv=none; b=TRQqAXfut2SEuT0JyB0qPnwEp9rgU5ngn2Mkj15h4ijXDW6sxJZHaFrOarq8p3P8huOyz9uei4AJfmLyKzzA626qtbZeKaL8tYT7MS6d4LcYk9fO5GHTXK+OBKkfEzKO0FIBzxcV2fhaaOFQ0CpgI8XRaH80uO/ofcskMoUKTng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781265899; c=relaxed/simple;
	bh=J2SXyGs8d4JkuUsxs/PN0reQlwz2/sAVP9o8Z/M8Tlc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fXnWd8JUvAu0D6093BU9RImbgEzohOHfP6xxJZxaYRTSX5QQlfcVk3D65UTGvMjw9O7ysGDlvGrNkpopgH/cdGx4jX/QqlDLqov2/ftD/y+YtOnqUx37VXyEObl1SFfW+I8EXkYDDMZb/Spzb9uUyYPBzceppbDGMhM3INeSHNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M+6pL9zR; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M+6pL9zR"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2bf30d530bdso8933015ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 05:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781265898; x=1781870698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U6ynri/CSVu9RSzvcDZrdysOG3Rc5mFfGCZtj812sXw=;
        b=M+6pL9zRTJTUfDEDwNMVGbvpdnq18TD3AarEaoQjy6ufDIhQvW9Ys7bEN2k/H77U0u
         1i/Rqi9O9t19uN/JYJNz32j9Kq3sDiEJ+WgJ0VbmLEHXkIUitNqYFm/u9aY4ZUncQ04Y
         VdllMJgsEbmq+5NqaM/Cq8lf/KV/l3g0Hhwodu89PpIX6xJ5QBHcoGg3Le3gO+uh8enw
         RFzdcTKdEBV8EYCTQ0lBh8+Ri3Fp89AXIIFRrMen9XKSRlFNPF/dNm7sN21UM5M+wiV9
         /8Ge9fqQwhLkO8tYkYdxJmBPbJBfEXUSNgXZmzX8y6OXQTRxkPlGhsvXwWaaQ10aqn1V
         bUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781265898; x=1781870698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6ynri/CSVu9RSzvcDZrdysOG3Rc5mFfGCZtj812sXw=;
        b=MYPkhSuf9WV1YFn1tGi06CgrJ2YCksNed9SGW68bI1HUX4b3x5u333Hwo1Ey6mYmbB
         ZaRIkJTUZWMhIAJgjJ1g1fT4jL9c0iVFIdZwcA6SLTwWi8bj9x6nlCQSe7m3PKSYaUyr
         6DCdK9eqZ5XwFw8NPuCs5yVsPOmrcaABRl7w2ALHmuemUh4f42AVEtMIDij588X9eQIG
         ihZ4kVPB+mTk4I41ItT+y0+syjpdNLbFuDss6y5OLN8X9+OLLj2ugsWv2sH+tMjgXNB7
         q2DH2xYqNdb6X0QZEnV4J2nlmBID2IJNHgtYVHvmYgLiIjOJrsbG6KTlyS3P5Zfcute6
         O6Dg==
X-Forwarded-Encrypted: i=1; AFNElJ8EcfwCbN6h/9AweXL8VcnCVdvSLRhAsZjx//zfIxWB28MAoAXGXBROdjNeMeS3D4mO9pfiSwIPnH4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdnupPbxkS/XPgT6NXuU8Si380tiDfIIkEFqdXqSYFhRpGYHtB
	r/QWC3KFL0oBSNrOr45xQhvxTz0E0i3LGvoI76omeQ0+d6Rx6N4Mfn2V
X-Gm-Gg: Acq92OFpK+bY62b7Kt2Fiy3m+9WTNelNXmzYtiMut6zsEAgbpPzX6pvsYOVnZWUYkzT
	GecmjffFsSTxRqgo6n2/5OSILitGCd5l8BfGeUaNy2+K0R/xN409IF9ssj/57yWrl9lQ/yx4lfk
	wRxHVe7AThSLsYtMIHgiP3K8A/yu2ReGsNkmYj+JGAjR/Z1hhUyPUIAS+e8XbZM7u/sUGIEse7K
	9TK9piloQGQ/jVcwAWDGrmG0hRuWYNco7hkLwnsrv/QaVewQn2Pona158eZfCukz4CNu4SpB09G
	vrJvYYS/Yc7yPG3++BTR5EpZa0qaOWh4UWumsh0F2DWPW93MQLVdeHcQhhoVxjkSTpiliC1dd0m
	FIi/xJ1+VmIlMLpCpqZK6Mj+PUqOXc29ab8X8MOZ3CjkFhgnbPNJgmN+DASnJyDI2YxP0hQF5Nr
	zzIDpoqmRTL0TFk5qAT96MgOgII6bZAxECucTRUp+spKzuqGLu5jYqOJSpPHAkxmPznVRIVodbM
	XRe9H2SsBBixeLkREpEN0sqaQBWV0d79QA19dtauBor9JJ71vKU5xO853l/PoTR+kqeXQfom4El
	4PyVEdTcQ7iPLf8SCXHvd0yt36BSo4iLxeTIYfes35qO3Yk=
X-Received: by 2002:a17:903:2b0f:b0:2c0:b932:8680 with SMTP id d9443c01a7336-2c41050c85bmr33484555ad.10.1781265897496;
        Fri, 12 Jun 2026 05:04:57 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (139.104.87.34.bc.googleusercontent.com. [34.87.104.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c433844a70sm19082255ad.84.2026.06.12.05.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 05:04:57 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v3 0/2] xfs: resolve close() deadlocks on frozen filesystems
Date: Fri, 12 Jun 2026 12:04:44 +0000
Message-ID: <20260612120444.2270-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

Hi Carlos and Christoph,

Apologies for the mailing list noise in v2; a local stale patch file
collision caused the wrong files and version headers to be sent in the
previous posting. This v3 series contains the cleanly regenerated,
correct files with a distinct cover letter subject to prevent mail
thread merging.

This is version 3 of the patch series addressing the close() system call
hanging indefinitely on frozen XFS filesystems (Bugzilla #205833).

Based on Christoph's feedback, I have made the following improvements:
- Split the changes into a clean, 2-patch series separating the new
  trylock flag implementation from the deadlock fix itself.
- Extracted the case history, reproducer code, and discussion from the
  commit logs into this cover letter to keep commit logs surgically
  focused.
- Adjusted the parameter name in xfs_free_eofblocks() to trans_flags to
  make its usage stand out.
- Implemented a much cleaner, race-free state preservation logic in
  xfs_file_release() by omitting pre-setting XFS_EOFBLOCKS_RELEASED
  on the inode, setting it only upon successful truncation.
- Simplified the transaction allocation block, renamed the flag to
  XFS_TRANS_WRITECOUNT_TRYLOCK, and added the requested mutual-exclusivity
  assertion in __xfs_trans_alloc().
- Set up this series to be posted standalone (not threaded as a reply)
  per the standard kernel guidelines.

THE REAL-WORLD IMPACT (BUGZILLA & DOWNSTREAM CASES)
==================================================

When speculative post-EOF blocks are closed on XFS, the release path
synchronously attempts to free them via xfs_free_eofblocks(). This
allocates a write transaction (xfs_trans_alloc) which blocks
indefinitely on the superblock freeze write lock (sb_start_intwrite)
under fsfreeze.

This behavior has a long history of causing severe system disruption:
- Downstream Red Hat Bugzilla 1474726 (dating back to 2017) details
  complete system hangs during system backups when rsync and fsfreeze
  are used. Even seemingly harmless read-only commands like
  'cat /var/log/messages' would hang on close() in __sb_start_write
  via xfs_free_eofblocks, requiring a hard reboot.
- Downstream LeApp integration test scenarios consistently hit this hang.

Hanging on close() frequently triggers container healthcheck failures,
systemd service timeouts, and cluster failover cascades, which is
disruptive to user-space applications that view close() as resource
reclamation. No other major Linux filesystem (ext4, btrfs, etc.)
synchronously allocates write transactions during close() system calls.

THE SOLUTION: NON-BLOCKING SUPERBLOCK TRYLOCK
=============================================

Instead of performing racy pre-checks, this series introduces
XFS_TRANS_WRITECOUNT_TRYLOCK. When specified, __xfs_trans_alloc()
attempts to obtain freeze protection using sb_start_intwrite_trylock().
If that fails, it aborts allocation gracefully and returns -EAGAIN.

We then pass XFS_TRANS_WRITECOUNT_TRYLOCK during xfs_file_release(). If
the truncation fails due to a frozen filesystem (-EAGAIN), we cleanly
bypass setting XFS_EOFBLOCKS_RELEASED on the inode, ensuring subsequent
releases or the background blockgc garbage collector can successfully
clean them up once thawed.

REPRODUCER DETAILS (GPLV2 LICENSED)
===================================

As requested, I have added a GPLv2-compatible license to the C
reproducer provided below, and I will be working on wiring up this
reproducer into the official xfstests suite in the near future.

Compile with -pthread:

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
        if (statfs(argv[1], &sfs) < 0) {
            char *dir_buf = strdup(argv[1]);
            char *parent_dir = dirname(dir_buf);
            if (statfs(parent_dir, &sfs) < 0) {
                perror("statfs");
                free(dir_buf);
                return 1;
            }
            free(dir_buf);
        }
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
        if (!close_completed) printf("SUCCESS: close() hung!\n");
        ioctl(freeze_fd, FITHAW, 0);
        pthread_join(thread, NULL);
        unlink(argv[1]);
        return 0;
    }

Aditya Prakash Srivastava (2):
  xfs: add a XFS_TRANS_WRITECOUNT_TRYLOCK flag
  xfs: prevent close() from hanging on frozen filesystems

 fs/xfs/libxfs/xfs_shared.h |  3 +++
 fs/xfs/xfs_bmap_util.c     |  9 +++++----
 fs/xfs/xfs_bmap_util.h     |  2 +-
 fs/xfs/xfs_file.c          |  8 +++++---
 fs/xfs/xfs_icache.c        |  2 +-
 fs/xfs/xfs_inode.c         |  2 +-
 fs/xfs/xfs_trans.c         | 12 +++++++++++-
 7 files changed, 27 insertions(+), 11 deletions(-)

-- 
2.47.3

