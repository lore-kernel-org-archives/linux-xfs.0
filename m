Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01CC3D45E4
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 05:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781588352; cv=none; b=oLzBMPFR85Rf6CQRuh4NSxfJxbBuGdl+uSQ0F4pkpJHRV7r7anMoCwGuHOm7JZq1ieTPxT1fSpjMXJQ5Ko7Dt/5kz2kff0+hDXomZfAypIwUpALKpNrmzZle50mChK8rodmdbrVqFbfPWFK+3gQDT16T9wXcN4yJjFZWimgTqxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781588352; c=relaxed/simple;
	bh=XZq0fylLl6OUfTDzNiI+5fcy1x6TukxRfVkFtvKluW8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ks6mNDPHsLKK99pCQn6s04Y28/6bqKBY7hsR2Pb0BTKV+DPZpXkJ4xEdZPMHThl9lGf4IOFkAYbZKWp4/cZ3oqiFsvoAsZzAzbV7DVuxFwFsolCsC11VaUZ+xyQhwf/BrrkF8ISI13Daw6rMh/cMTrq8k6svArOXCv9TmYCug7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lg05tRCE; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lg05tRCE"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-36ba3ea5c46so2381092a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jun 2026 22:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781588348; x=1782193148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RNsJ5DSu4EhaIVnt1Ih0mAFCo9++mRF3VgHaddQV5DI=;
        b=lg05tRCEcBOU+DkvfE/inpFws+ApjYjEq13zGWQoIAKCxBlaghZVqn/w3PHBtlvLGb
         5ikhmw72vTzskzOVf6vMHRFK9sJpworB0hndl7T+U/lSVgSg4GS6rK6zXabBKYuBvqsp
         4NQ+s7Ety+rm/R9jwwvIYjUmkxrXeFpr899G8bAfV5+r/IZ6FWFb10Das77JCtOsIRCp
         Pm7F7Mh1D6cN6mrkx788Qmhw7xn+kBXYaRe1SBwMAnohA1les6+0yMd2ksBApweAmoQg
         0GIOVs8e8EWAjAKXSB484ELkFraZtlZcAGVX1wmWS3PDAvgamy+qdaJNn3inmqsc3zvJ
         tKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781588348; x=1782193148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RNsJ5DSu4EhaIVnt1Ih0mAFCo9++mRF3VgHaddQV5DI=;
        b=ecD89nGjZWPjTjr+QGSBukqsOQn8YIvkOX36EEo1MjA++hXf+/Dm8wjNPndSesnfZT
         KjDA5tqcBBFK8BfPcraJUBc9LbS0Csx0/GETa+mNu0qPNZ4ke/h1iF72Re3dbY8TzhSN
         0NVxfZt50aV+ODqj2a5wkkde+nWr7ROdAAY9rjCRJ4jQVQabJyA2TP14sVdUiBWQnV5I
         B+iEX9LbfGhl9qG6+4cVvjl0ygGGakJ42JCUiw7ttQ+Z0SaPL6C7FXHXRSybJy47/PIp
         RAZz2Wiyz46W0K8A5Dr7+0dJ0xOmji0M4MvFvkocUMStOOazTD8V3JHNs2IjuvlwE91Q
         7Btw==
X-Gm-Message-State: AOJu0YzYQosDJbNw6OW+O3HEYHtjy/yrxWoQ8npC7x1xlMZp+Dt31aDz
	uc9Vi1sXAjfNjhirvvciuHGOq+dfB3AytJmIeaMK0XoK6NbAdBa+xS3YFVQbD1PBqck=
X-Gm-Gg: Acq92OFl4sQ8GWaGiyNGme4SlrwX55RTmQ+GCVoC1h/McCsmxnry45fbkvZYjR/ZY8M
	zywFywV5MBkZ6WDokAxJBNMAz8pzZJv5fk/NoY17sA0UX7KtVWGRV0L2eNgCk3omfXKSkfrsa1Q
	SelfL9DMjtpwS+4RYWy1aQVsYDj96xRYBdkjbJs0Icnlrd5mOUM2Yifw8VFoicZdRBVI0F1A8XT
	JZ73SgkHueZXZ43s82+ffFF8D3u1l0oJU6eEz+RAga0acmC+wCpYWhxlqVZY8hI9FVI0RGL0xDV
	FqsZ7rLUi0ozj15OEzQIe/NtVKCA/tMG17PGuLsrMhsLmY94YBYqUaX6nea1f9YPEdxJC7agNt8
	9PQVBmikKWRqfgtp5LJezqTSaJqKI/7ZrnqN0dqFfqOQc8XcEjYGTelP1QlAKAb3ZY6BBLUifzb
	T8UFRCKZoOLBfXae/ku7oxdFZlPPdzoMMmVTYHvleQgI4Pw2ZMj83cvmNSYbZP5rQusVzRFGR6D
	+0aQxq1BqciwhSzy5IYhGgQwq0sOcT0rrWTkDESu6LmMNEkRmXsr+ICnR3faq3eZStbIr5sH0vW
	dsiQVmvSZZAAe8c/lGaAZuhhAROusouNhvJItlY=
X-Received: by 2002:a17:90b:2749:b0:369:932a:2b8a with SMTP id 98e67ed59e1d1-37a01e2e4d2mr17137580a91.1.1781588347662;
        Mon, 15 Jun 2026 22:39:07 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (107.43.110.136.bc.googleusercontent.com. [136.110.43.107])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c5220edd1sm1386518a91.12.2026.06.15.22.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 22:39:07 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v5 0/2] xfs: resolve close() deadlocks on frozen filesystems
Date: Tue, 16 Jun 2026 05:38:48 +0000
Message-ID: <20260616053850.2188-1-aditya.ansh182@gmail.com>
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

This is version 5 of the patch series addressing the close() system call
hanging indefinitely on frozen XFS filesystems (Bugzilla #205833).

Based on Christoph's feedback, I have made the following improvements:
- Added Christoph Hellwig's Reviewed-by tag to Patch 1.
- Wrapped the overly long xfs_trans_alloc line inside xfs_free_eofblocks()
  to conform to Linux line length guidelines.
- Corrected the Patch 2 commit log phrasing to state that we are
  adding the trans_flags parameter rather than renaming it compared
  to upstream.

As requested, I have also submitted the corresponding regression test to
the xfstests mailing list (using tests/xfs/842 with a GPLv2-licensed
helper program). The fstests maintainer (Zorro Lang) reviewed the test
and has indicated that he will wait for this kernel patch to make it
through before merging the test suite additions.

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
reproducer provided below, and I have also sent a corresponding patch to
the xfstests mailing list. The fstests maintainer (Zorro Lang) reviewed
the patch and indicated that he will wait for this kernel patch series
to be merged before pulling the test suite additions.

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

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205833
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1474726

Aditya Prakash Srivastava (2):
  xfs: add a XFS_TRANS_WRITECOUNT_TRYLOCK flag
  xfs: prevent close() from hanging on frozen filesystems

 fs/xfs/libxfs/xfs_shared.h |  3 +++
 fs/xfs/xfs_bmap_util.c     | 10 ++++++----
 fs/xfs/xfs_bmap_util.h     |  2 +-
 fs/xfs/xfs_file.c          |  8 +++++---
 fs/xfs/xfs_icache.c        |  2 +-
 fs/xfs/xfs_inode.c         |  2 +-
 fs/xfs/xfs_trans.c         | 12 +++++++++++-
 7 files changed, 28 insertions(+), 11 deletions(-)

-- 
2.47.3

