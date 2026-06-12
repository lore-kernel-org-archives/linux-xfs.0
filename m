Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9EB3C4572
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 11:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263399; cv=none; b=eTABVGf/UnDrLFNnRnHepnApjLoFnuuGtIBODaPGABUdgjG8frfwmf39gdVxnNU3vywdE5J2CWTQgx33b/gPepCmeFQbCU/nQRJdA04WJBA28E08r5HrZeGYJMbKtm+TrXD7ehpSp6lx1443PaSIGWeYaRn8DJ7m8KqOlyGWkIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263399; c=relaxed/simple;
	bh=AR/gXDvQa8V59BkIKH/M6bRBJlR7wPrBkvH1W5rDDuE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sDpfQkwp1G1K+7sg84qPmQDTfaOVMsxCRQm0beiAxsI37No2IfE+VTD81lbiQnPIX94gRFbS98akPS1vl+0czqgsQ2u6+jhH7kMhlYolWWSpp01UJLUvklH8/oSNRg1frrBDUe4YS/eXLQ2JKGqOyfvEeN62psvudwuIFOyV5jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iegbStcz; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iegbStcz"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-36b900f350fso796589a91.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 04:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781263395; x=1781868195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GFzPHIwQn8KMYsLYr92ugG/vnKOznti7A0IwS9LbOVw=;
        b=iegbStczSgby8Kw42s1Wvi6sYXU57TUvFhrjoVUxXWyLwVq4N5G09Ijw7wjJEZ+xtd
         zQOF0+yTAa2ws5dthAxdEe77VuY4Gj2FqILGbqZYqKVbQrkk9WgmLS1ChSvag9VO5s7J
         yDd1+Yrg7RWiaqCciqWm+hzfAHXpJUS25Ao73482HxUDIvnXzoYqw39YEiiMZ/rrBnt4
         1Zvx1lpXZwh1G294dy0UfL0JPyFrV/SY8tpsbTIK0fvcUKbe25meqRfVYdLvsNWMk/FD
         RzrPTTXLhwmGWvblELKIpqQfJsOAynZbnv3te4C3eYNSNOEm+xiySpODPdPniPSB7qX6
         Yp9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263395; x=1781868195;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GFzPHIwQn8KMYsLYr92ugG/vnKOznti7A0IwS9LbOVw=;
        b=YJOVx7iLVh/aDacVNeNajHhbMKetFHHX2SetyFTh3byOId+KFvQ0aGKVnD2DzWYkub
         Zi47zMn+phw2malCGlbZlcBB0t4xeC18evZwe1N4oCOxBGlsyyTNNGmCOSXAceB4Y9qK
         lYLGn2WXhlJVVKpVYsFFjVvkVZ4csUH7KMDGD5XzeVUHRVjI6fZ6x/wNZYKCya4N2FG5
         LSzfsdir9x1fF8ScvtV5/JZaFIag0pgXSDYnXtZs/pplnCYyJPdYw/nsey+8+JnuQArk
         YAvWufbsAQODAZq1uS+H+ODiUJy9H9nkdpCHBmH2yqccPTG3T2FagXV6A0RvuSQ5Kaq+
         StRg==
X-Forwarded-Encrypted: i=1; AFNElJ+W1a3641hMzajEw9pytSZYI/TcnXvRYjDrhvHuJy+0mVLc/HZfAoQD4VwOdckmyQC23m0657hEtlI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnvp+fOxxuEp404otw7Ih+f3tGiDKz0CJypuGuTzpZffk911h1
	1LB5okpmAGzmlq6K00OynoOaQdHOYYN4S1V1w7w+KwdFni8U/mX2zVjzG1HPRDZlTMk=
X-Gm-Gg: Acq92OGxgOAOy/Nur7bvTixYnPATXaalvgZGy51Pi72C4eRWZL6sO60cksnWjbNMsMd
	kcEzhsn6Qct/YSOXG7/tYm37OnEJ49jzsUizYphhaz5uab24R3Nmc/sYnC5zu4yLEzdLUAwVlKJ
	0OZJTUZlGq3kuEnXsvd57aasV1EB4mu4rIu4E0EQ8NmnNgm9YvCOU7OOllHAqz4Ph0H65ce3DlB
	+PaLjs2ILzDxhhX10DmJTadofmBM9Ntrg8nCRpFyriaB98WBqibsN+LLhQ0x8zBrFAQrz+rLIFG
	NLfHreUruzqoxCqAPYh5s5JZ/0v0OJBTCu3YclQ2IBRAyCzVnu8r7VhDzxyyo7IJpYuMh7+DvMJ
	aA5DXHmW00nvx1OG4i1mdE67BIJmN/YpoWmxnJDclSIraQkxzE7v0U98OH3scjhQbzaWwaa8FBR
	dqRll7zPFl3UbNtOxd/4ZNLOWoKPa0cAl/N4v1Ihv1aUEfE+xHcGDxvzYKoCpYPwKItTET7cWlH
	qQLRMYx4WuwGzq0AZT7Gm3rYnNp7swCN3DT+VrLtEZTiDdgczMbLUXsDOEKsgrO0VuEUzgUBbzW
	xBOFXBtqm7iuTw3cvocuFWg/fNU+rsppGmYI
X-Received: by 2002:a05:6a21:6d93:b0:3b4:605c:2163 with SMTP id adf61e73a8af0-3b783b403bcmr3235835637.4.1781263395438;
        Fri, 12 Jun 2026 04:23:15 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (139.104.87.34.bc.googleusercontent.com. [34.87.104.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c866519ef8dsm1808822a12.25.2026.06.12.04.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 04:23:14 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v2 0/2] xfs: prevent close() from hanging on frozen filesystems
Date: Fri, 12 Jun 2026 11:22:50 +0000
Message-ID: <20260612112252.1697-1-aditya.ansh182@gmail.com>
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

This is version 2 of the patch series addressing the close() system call
hanging indefinitely on frozen XFS filesystems (Bugzilla #205833).

Based on Christoph's feedback, we have made the following improvements:
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

### The Real-world Impact (Bugzilla & Downstream Cases)
When speculative post-EOF blocks are closed on XFS, the release path
synchronously attempts to free them via xfs_free_eofblocks(). This allocates
a write transaction (xfs_trans_alloc) which blocks indefinitely on the
superblock freeze write lock (sb_start_intwrite) under fsfreeze.

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

### The Solution: Non-blocking Superblock Trylock
Instead of performing racy pre-checks, this series introduces
XFS_TRANS_WRITECOUNT_TRYLOCK. When specified, __xfs_trans_alloc() attempts
to obtain freeze protection using sb_start_intwrite_trylock(). If that fails,
it aborts allocation gracefully and returns -EAGAIN.

We then pass XFS_TRANS_WRITECOUNT_TRYLOCK during xfs_file_release(). If
the truncation fails due to a frozen filesystem (-EAGAIN), we cleanly bypass
setting XFS_EOFBLOCKS_RELEASED on the inode, ensuring subsequent releases
or the background blockgc garbage collector can successfully clean them up
once thawed.

### Reproducer Details (GPLv2 Licensed)
As requested, I have added a GPLv2-compatible license to the C reproducer
provided below. I will also be working to wire up this reproducer into the
official xfstests suite in the near future.

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
 fs/xfs/xfs_bmap_util.c     |  7 ++++---
 fs/xfs/xfs_bmap_util.h     |  2 +-
 fs/xfs/xfs_file.c          | 12 ++++++------
 fs/xfs/xfs_icache.c        |  2 +-
 fs/xfs/xfs_inode.c         |  2 +-
 fs/xfs/xfs_trans.c         | 14 ++++++++++++--
 7 files changed, 28 insertions(+), 11 deletions(-)

-- 
2.43.0
