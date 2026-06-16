Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67153C277B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 03:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781581124; cv=none; b=OImkVRGiq4AQ3nFJLi0bqdgzZaBNBPlQMVJeVRUjoeYlN5vTYvDk4pUwAR619+GknhT9fQPF3IZ9qkAoUnHt8X1CuWb0qTZY1uAlQ+3/SOoAeou8BfLvM0kKl2axKR28gXuf4zieHpLsO9/OXnpV0byb6AQh0Jtr0QW65m3MIUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781581124; c=relaxed/simple;
	bh=3PqVFK5Qs0v/UFqiFxhGkEcgLMlIZo7+73kLHHeWDrs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c1YEv//n+HVxhMIFsS/c+hRdtYAGHdNDXF6SY3ejvsdOPlyX71A+k1JwPglNcXioXFBYx95fMatcTFHVs7ONFRaktRFFzVutGrL83tJfi/B6xPfQlteKVMnsd05i8+txRr46G23lqaIQrCBtA12wXnQVQk44mcy8H+lV43bEHYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FG3I1dux; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FG3I1dux"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c8584e80bd9so1522593a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jun 2026 20:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781581121; x=1782185921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7cuipR5nyTRkoxASlXFyDRKdwacwZuLB0SxqeVX2e4U=;
        b=FG3I1duxDMGiaK98e0ELBatHPFgkDu9iwZLK/H3KQXssI4v1ghWTFe9SNGfm8KpzIT
         7rygkMGvuP+2+U9WuTRfFbER8iiPOoAP5fhP8T4j9RrUCjsXEduNSqZ3sFrT1LPc44f+
         c8pH73d2WkC6eGVeQ8BaLvukhFbqFY/vwRZ3W8eVPQyXa+M+rGWfOtRidJ7Lj69Umi8S
         H18Evfe77CHXgjZDBu3DjD8JA1Yh2J8cZtMpA9rJofE7/2ia+MU3TPU3zoqVZ42GBHe/
         mKebzEwFr1lHq/SmJzwh+ngUn4K514PL8CMeO98aLQuS8vyUt64w5MQagdGmaRBAyVNH
         qMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781581121; x=1782185921;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7cuipR5nyTRkoxASlXFyDRKdwacwZuLB0SxqeVX2e4U=;
        b=IGwtv2TRFodle/YBpxZ5k5+E70bkyklTnDrUEjjn/h2jXnGIykfIZ3b4tg+P4eQSAZ
         zqd7elNZNBovlcrcyiTTwS3sEnQ26B3GkwN97Ujak8q/hd02NKm1I+DbwEuLtVgfPUas
         W68ii0xTOxU0iCJ8bfp/5TqBvAd2FdsHwUFoWY6B1UrnLyzJ8Low/mh7n0YkI72SpBF5
         IuoyHZjCtL1gEhvanvZJTJtLQ0Wi/khYmeVNEFnHTBzjb3oJQgmoUiKfIZBksBmOLJDH
         X+o6ODMwsuULJpfUzf8gu3ttKfRv+vql2Qjmp5cx0fyGGIWDPK3gHPsq25zSwJD0WDo4
         1axg==
X-Gm-Message-State: AOJu0Yw+KCut5/TTKmpFk/BHXwa3vqps2AaCREeSPRqY4g2xjn1n5nn8
	3WmS9XjeSNDhgssZiGiSUqFgt3Lnhf9TsGnpBPoiYMybys7PHehbXxTD
X-Gm-Gg: Acq92OFfiw/KtsasZmdam3a1Q1kAv8E+e5TPX1YzDXabcI6tZ+/LjyJpjXbyOvG1gtN
	XZBozq2xCFc3Apzzrkno8xzmWziPVajK3WCYliD/P+HHNESYt253E2xq7ILsM7zihc6fRPv6Q6A
	qNQA+39PKUDcaUp5NvdmwpuqyYFYa8Lz5hcMxsrOU+qi9NRg9TMNYSY1wJ38Lph+d9uF9whlVwE
	J55qZP3QyL5P5Cwis6aqBdTTBKyDKdjIb36Tl525LE12e0kt75F1ugDYa1IqvmFece/qj8EAWJg
	wYi4ExtnhNHZATzTH8mNZ1rxmQlGyvKhzjA97BTGQ0fEtAw1YtLnkbC7kFjslt2utaCV11qtDiR
	H5YgZhBA7T32rPdZIbkArOBZORf+Ea9sXTbHdpEFxm75MPrcFvQaOCGxNW/bWght7RA3Y2xgv18
	JGVdj+ColNllbz6OsQtkkMUMOP8X3paxzx6IQg7gNIQUpFwUbQocUXppzRVhhNnRbcVvE5pXpnL
	u2GpQyUjX+/ISemru8HHIo6+FLroH50by78rhkyEXZjEyoib6pPxnt6eZm5SvBw3ttHSdKRH2r5
	1SrUeaBbTYMm34pCuflBY081EpgrGIvV8E6T
X-Received: by 2002:a05:6a20:c6ca:b0:3a2:f75f:73ef with SMTP id adf61e73a8af0-3b7e4d4fdf1mr1898224637.37.1781581121039;
        Mon, 15 Jun 2026 20:38:41 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.d33bddc1d573818c7-tp.internal (229.231.21.34.bc.googleusercontent.com. [34.21.231.229])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c866325d156sm10304173a12.13.2026.06.15.20.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 20:38:40 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v4 0/2] xfs: resolve close() deadlocks on frozen filesystems
Date: Tue, 16 Jun 2026 03:38:18 +0000
Message-ID: <20260616033821.2238-1-aditya.ansh182@gmail.com>
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

Apologies for the mailing list noise in v3; those patches were
accidentally sent as unthreaded emails due to a local Git configuration.
This v4 series is properly threaded under the cover letter standalone,
and has a distinct subject line to prevent mail client threading
collisions.

This is version 4 of the patch series addressing the close() system call
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
 fs/xfs/xfs_bmap_util.c     |  9 +++++----
 fs/xfs/xfs_bmap_util.h     |  2 +-
 fs/xfs/xfs_file.c          |  8 +++++---
 fs/xfs/xfs_icache.c        |  2 +-
 fs/xfs/xfs_inode.c         |  2 +-
 fs/xfs/xfs_trans.c         | 12 +++++++++++-
 7 files changed, 27 insertions(+), 11 deletions(-)

-- 
2.47.3

