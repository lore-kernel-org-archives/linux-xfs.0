Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943FFCCA47F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 18:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiFPS2j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377907AbiFPS2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 14:28:31 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA9D47570
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:30 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id u18so1924634plb.3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y7CVcm9SkiGC++dabxCXTEj91DGKOxCAfnQz83I7V8k=;
        b=HRYdBGXdg1ADKsKeyxxERaY+7jCUIGVxbUtge4bFXLtNmOn8PVkusWJxOECp9xdHeT
         79gq/r8CknCEi697Va/cE2saSPZWpaLQjDksbNsX7WHGVN1J5cFGZkEd3a6iLSAUze08
         fR466OY/4AruaehfCIOhpIeKINEjBLApydFW9q7nMVwoQK8sduy0IDhlbNL69yCUuSJM
         VZ9Vhi1YfLOHh0LYwPAFY8FekRztEAeLXVcWaJAfh9VRLGVIlCE4DRiWKzpmWWG2wvrS
         AZWuwcri5gdSHhnfyv05SPhGTt/a54hKl2m71LU+w+lJv0Qy4XamBBpzgqZRsyyHFJX7
         YvZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y7CVcm9SkiGC++dabxCXTEj91DGKOxCAfnQz83I7V8k=;
        b=XJgmf6l5wngLid6Sjc0m4d2FJyeVzLOXFv06N4tG7/xG3lfHtUlE8U0uYJfIxRmy33
         dBUn2cg2JafwJhBHMQ/XZZqxTXL0G3mhrPdSsYqtW/YYKR+Sn05IRF5KO8qRiHVPcMnP
         TJvZdGK4/w+lTVd3D5JctKSsOqbxDsDT6aLECcO81SO3oz/jGKkZmPqZtvndNsuSAayA
         U6UBUshzmxN+Kcpgqh4PHjTVEmVYQCXLkZ9VQXXRflUdjWstV1haD68Uv3zy6AUtwWz5
         zHXYrDvgbSaQaowVCEiuJCdNshzU0DPNF+5OoG0cGpxaik5P5DT5CQp0X/UJc04CCgXl
         mCZA==
X-Gm-Message-State: AJIora+VU1GMrUqpqYmZhN8mKgMxI8NjGrds0fzrok1pcyh69UcQq7+0
        MqOkPmyEnyl2uyoYBvCUJWCqEuJA8D9mdA==
X-Google-Smtp-Source: AGRyM1uLbszrR/aE/C9BbzkJWbpyhR9EPWMCqNRj6Vrn/wUyanRBhm1SqCzZKlad5L8F+gqfZDTcDg==
X-Received: by 2002:a17:90a:f483:b0:1ea:84a5:222c with SMTP id bx3-20020a17090af48300b001ea84a5222cmr6372981pjb.47.1655404109556;
        Thu, 16 Jun 2022 11:28:29 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:fd57:7edc:385a:c1be])
        by smtp.gmail.com with ESMTPSA id fs20-20020a17090af29400b001ea75a02805sm4131511pjb.52.2022.06.16.11.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:28:29 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     mcgrof@kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v2 5/8] xfs: check sb_meta_uuid for dabuf buffer recovery
Date:   Thu, 16 Jun 2022 11:27:46 -0700
Message-Id: <20220616182749.1200971-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220616182749.1200971-1-leah.rumancik@gmail.com>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 09654ed8a18cfd45027a67d6cbca45c9ea54feab ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_buf_item_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index a476c7ef5d53..991fbf1eb564 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -816,7 +816,7 @@ xlog_recover_get_buf_lsn(
 	}
 
 	if (lsn != (xfs_lsn_t)-1) {
-		if (!uuid_equal(&mp->m_sb.sb_uuid, uuid))
+		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
 			goto recover_immediately;
 		return lsn;
 	}
-- 
2.36.1.476.g0c4daa206d-goog

