Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42BDC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jun 2022 06:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiFXGhV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 02:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiFXGhU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 02:37:20 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C598562722;
        Thu, 23 Jun 2022 23:37:15 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l2-20020a05600c4f0200b0039c55c50482so2790700wmq.0;
        Thu, 23 Jun 2022 23:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7rlLJigxsmTZtJ4R8DtANGAf44bp6QS5yoCTt0RR5Z8=;
        b=cLZzlaGIrc63eP0gS62EWcw1aOAsdieRvLank/MHXlcEwZL/kAPZ6epZ/WSn7fxpn6
         s6fqceRX4GE+b5kLZPAiA8IldtIeY6JMHL+fsXPv+VDBFiw/6YdE3hZbpLx+FcwBjDhF
         4gr7QsooxzlJi9AiY0aPiCtTevFU+xsOFxOvb8EGsfAbruN4a3Yptss5kDQEYLiDFu7s
         fOxXEttlZRDmFAa5p5xwLP70ePB7jrJLG79O71Gqrng7kELmsMoZqffZqKgmKGw+KwDQ
         RTz7zQqV1jeMe76rz0hrmMXNhR5+jxLoqpFi1AzQZMwr9seirxHCaGzjrYY7loc/0uKH
         SikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7rlLJigxsmTZtJ4R8DtANGAf44bp6QS5yoCTt0RR5Z8=;
        b=za+Rya8f1quW+1Pm7WmnUtjOC5Xjk9Kb2NvrnIOya9MDhDURCo98YuGCb0l6/JBfGm
         T1crD9od4XpLbnJlVm+GYdids00HIC1sZF2/yqu/mXTkXZxyKN5PFCzLQCUNiBszBNac
         VqOTQ7VV8QMRRpKqe1JZmAzSZd4sc+KErTYeidlydUphHzKWGAvMyk9OehfOsIRanZAy
         oowIhuDGfll2ogQrTFMEeG77R3uwsvDgJYD/Y/q+i/S03+G6dLDF/6wugZfH2TmAiSv6
         MV0hkbMpJBSgdVHRy/UwpBrKrBG5XnTRbrqLLZVohIMzelnPeA/ip6BRh48SxILXFiyV
         01/g==
X-Gm-Message-State: AJIora+C9NgrjvSTLfLTa11QDT6z6F1NFu+WB1nJkTBE+60iowkJNMkw
        ALxxbQwkJrTie7PG21Z3410=
X-Google-Smtp-Source: AGRyM1uHebUAQGDzUEn9gKzgSQ0B70dHjpSWMYgjYhk5FTJhhqWRL5+MdolCX+g+FsaWfoq9zku3Hg==
X-Received: by 2002:a05:600c:646:b0:397:77ab:5eb7 with SMTP id p6-20020a05600c064600b0039777ab5eb7mr1941309wmm.166.1656052634299;
        Thu, 23 Jun 2022 23:37:14 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d67ce000000b0021b89c07b6asm1540653wrw.108.2022.06.23.23.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:37:13 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [5.10 CANDIDATE v2 5/5] xfs: check sb_meta_uuid for dabuf buffer recovery
Date:   Fri, 24 Jun 2022 09:37:02 +0300
Message-Id: <20220624063702.2380990-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624063702.2380990-1-amir73il@gmail.com>
References: <20220624063702.2380990-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 09654ed8a18cfd45027a67d6cbca45c9ea54feab upstream.

Got a report that a repeated crash test of a container host would
eventually fail with a log recovery error preventing the system from
mounting the root filesystem. It manifested as a directory leaf node
corruption on writeback like so:

 XFS (loop0): Mounting V5 Filesystem
 XFS (loop0): Starting recovery (logdev: internal)
 XFS (loop0): Metadata corruption detected at xfs_dir3_leaf_check_int+0x99/0xf0, xfs_dir3_leaf1 block 0x12faa158
 XFS (loop0): Unmount and run xfs_repair
 XFS (loop0): First 128 bytes of corrupted metadata buffer:
 00000000: 00 00 00 00 00 00 00 00 3d f1 00 00 e1 9e d5 8b  ........=.......
 00000010: 00 00 00 00 12 fa a1 58 00 00 00 29 00 00 1b cc  .......X...)....
 00000020: 91 06 78 ff f7 7e 4a 7d 8d 53 86 f2 ac 47 a8 23  ..x..~J}.S...G.#
 00000030: 00 00 00 00 17 e0 00 80 00 43 00 00 00 00 00 00  .........C......
 00000040: 00 00 00 2e 00 00 00 08 00 00 17 2e 00 00 00 0a  ................
 00000050: 02 35 79 83 00 00 00 30 04 d3 b4 80 00 00 01 50  .5y....0.......P
 00000060: 08 40 95 7f 00 00 02 98 08 41 fe b7 00 00 02 d4  .@.......A......
 00000070: 0d 62 ef a7 00 00 01 f2 14 50 21 41 00 00 00 0c  .b.......P!A....
 XFS (loop0): Corruption of in-memory data (0x8) detected at xfs_do_force_shutdown+0x1a/0x20 (fs/xfs/xfs_buf.c:1514).  Shutting down.
 XFS (loop0): Please unmount the filesystem and rectify the problem(s)
 XFS (loop0): log mount/recovery failed: error -117
 XFS (loop0): log mount failed

Tracing indicated that we were recovering changes from a transaction
at LSN 0x29/0x1c16 into a buffer that had an LSN of 0x29/0x1d57.
That is, log recovery was overwriting a buffer with newer changes on
disk than was in the transaction. Tracing indicated that we were
hitting the "recovery immediately" case in
xfs_buf_log_recovery_lsn(), and hence it was ignoring the LSN in the
buffer.

The code was extracting the LSN correctly, then ignoring it because
the UUID in the buffer did not match the superblock UUID. The
problem arises because the UUID check uses the wrong UUID - it
should be checking the sb_meta_uuid, not sb_uuid. This filesystem
has sb_uuid != sb_meta_uuid (which is fine), and the buffer has the
correct matching sb_meta_uuid in it, it's just the code checked it
against the wrong superblock uuid.

The is no corruption in the filesystem, and failing to recover the
buffer due to a write verifier failure means the recovery bug did
not propagate the corruption to disk. Hence there is no corruption
before or after this bug has manifested, the impact is limited
simply to an unmountable filesystem....

This was missed back in 2015 during an audit of incorrect sb_uuid
usage that resulted in commit fcfbe2c4ef42 ("xfs: log recovery needs
to validate against sb_meta_uuid") that fixed the magic32 buffers to
validate against sb_meta_uuid instead of sb_uuid. It missed the
magicda buffers....

Fixes: ce748eaa65f2 ("xfs: create new metadata UUID field and incompat flag")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index d44e8b4a3391..1d649462d731 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -805,7 +805,7 @@ xlog_recover_get_buf_lsn(
 	}
 
 	if (lsn != (xfs_lsn_t)-1) {
-		if (!uuid_equal(&mp->m_sb.sb_uuid, uuid))
+		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
 			goto recover_immediately;
 		return lsn;
 	}
-- 
2.25.1

