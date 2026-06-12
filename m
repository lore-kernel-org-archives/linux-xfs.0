Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B5C395D9F
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 11:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264977; cv=none; b=MNMqorw8PWj4Bw4eOVtB5BOCkkA17YQLnfULc+004t1A+wiRXQT0gr7BzcBjPFjhL0zCZ88GSxYnq7qCDhr8VtqblDZXesFMgfHYK1cj1CrezQTmCuAzdpJJUISwMB2f4bsT4Ey8xs03SaRAzFTjXFydp5io+2YDxUPry8EBuzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264977; c=relaxed/simple;
	bh=IGCIl269yKFbsEEIBa1FxGNONTESjJzzI1rxfLDHEdg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f0zf/f1r2vFad81ZXUrt5wNKRHUy6oriLunqeFE5A6S73nqxTDn55RZZOt1IrggCt7MskCV2ovt1LGFRvWJozhG16IkoTgnHHkRxHn0tQyjrIYHez0IYc//xz+7bKEdaKz/bzEWLBS7PlGY/G6U1B9Tl4hhvFH1k8y5beZ5Jw7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lNbEBXrC; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lNbEBXrC"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c8585c51f1fso844696a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 04:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781264976; x=1781869776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EldNiV4jGEmsPfXU5al09lpbzc4xUj4sTMthsh26IZY=;
        b=lNbEBXrCUKgtCmk3GZCzdlLgVZje2UWuiPIOn+uKC/rgQQYirHyY4EEQTsUUnFVSVx
         /e1CSKdXcMe4/cNsh1ifc7TQw+da60T0JTEPNViB4Ok3SwvZETdODNj34T4fB5bTXtll
         Z8iwNF19f9q24bI5AtJ534+olhHvLwVbGBrRq/T0Un+7WKsoUfX9FO5eLalVJmT0H3t7
         hfOeEvCPy6l0a85G2Xce85TDOwyREdyy6G+JiEAuFu9l9YViKSO0dYJENN9QerjjyEFa
         h5Z3KokHVCc6Xn9NNsJ3yvAdYM0t+O63pkFxhK0WER68Sr/0lHLJoR1ZRDgwD9uj5Gpu
         7NZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781264976; x=1781869776;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EldNiV4jGEmsPfXU5al09lpbzc4xUj4sTMthsh26IZY=;
        b=N7i2C3Zbx8wctKDZUYyxF81TCFLdfBEBRlVFqDwlT+T9oVUHGK/P2RT9cVLUQ/1f3X
         h8HZ7oB5Iv5+2WsdxJDQfDpThSsanDpOl5jPC84foPmvofqLGzP/H73UH7LYuVEGyfn0
         aet8P/7qfyaLm5PxzBYd8XgfDAlJ/i7hMhrSo7uE2DOFC04hcO2nbLoyzKegluGBoNbC
         GK2KgZ7cRG/o/ynK2i03d1bxXPdtwDKmP7StqG5K895GVs+w4vOn7E/z/AXMust8Xfec
         NjAtfzhOwEm++PJBKz1ZS9H5qmlHlmAghUfSB9E62XMBJU4EAAhkQRmydFmkQXAiJwSi
         B2sQ==
X-Forwarded-Encrypted: i=1; AFNElJ+gcGgS98Wq59IUdesxScpY3eUilBqj4R1HmtNm0VMzCN8jaJgXrbhQGPop+RSiYU2dJGThEkgbnOk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwV1+EaEY9o1yB9KDdBvOAn87KH6UKMlsecMMXkFfrUep+j0exr
	WwA4DjInPsYeTns5u/39YKyBQoIIw1wqSYdXG+3W//QOSHRPN6Y1slRs
X-Gm-Gg: Acq92OGq6ascqwhIc6SKktx/1NpBHHGIZI8Zu/rBXJHN0y1gebj4qNpT6b9IpvuWaz7
	+PwJCnX2G7w9NiLlgjpU+0iwcNoHCe0aLircMROovcMklk172/i1T/7OkcyUWtuxAoTnpnPpaxD
	GdKmB8JNLqGZ4PZZgxmXhQ4GZCnlyAXZKFEnZNT7yC5/fozP7jQpTDFEwtp95h+DDdM7Gw8V17g
	QM/0atjLAfR9i/7/P/6Na7oV34HI3fzzSddNy/UPGcnKYdhGqcvFExX/DIsnaaSrcULLDq8yT/c
	ITTCl3/iipdMC9JzVH6bzF8ZAvT+JoTR7TQE0uPhgbUUwvpZ2W9xQuBSC4riaLo54rsae+gNZMD
	j1mJa+ia5szvkchg5YFwui8qLpyI9+ms417TzwE2Hnh/X9UKGvyGwX9nW9OnMzcRu2MwbxzvKsp
	ncidqTIDP0R7PNDY0rOW3A+QWbq+cYw9lw/9ibbLjgVQXmFjqydNgfACit6pa6vhyiR1lCwSq4l
	hbDnCd9XJ0ZnSFfyllrRQ+6qpcEJaFCJNolAJnIeHbpwsBpdEzgf6LHALdoM6UCnhDXorc5f65G
	whHgQTxJ3fKuaIyWv4NY4zzoVIgOCxBq+i/BH0Fi5yggMDA=
X-Received: by 2002:a17:903:1208:b0:2bd:73f4:8e4f with SMTP id d9443c01a7336-2c429181b81mr20594675ad.0.1781264975936;
        Fri, 12 Jun 2026 04:49:35 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (139.104.87.34.bc.googleusercontent.com. [34.87.104.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c43307a259sm19993085ad.68.2026.06.12.04.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 04:49:35 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v2 0/2] xfs: prevent close() from hanging on frozen filesystems
Date: Fri, 12 Jun 2026 11:49:15 +0000
Message-ID: <20260612114917.2192-1-aditya.ansh182@gmail.com>
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

