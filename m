Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC60CCA47F
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 20:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiFWUhP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 16:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiFWUhO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 16:37:14 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244F660F1B
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:37:14 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id p14so666169pfh.6
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tve9D8iQuxh5AgLBP6EM+21dbBb6xwy+MqCcMe7KYYM=;
        b=QtC9vHHy/4dtnGzk+Px0xr4KIq0bt2BOZqDepg+6soUZMfdh52UanGJIy3JI43PNHy
         pUndr4xumM73QR8iumLsXLhXVC74UevKL4xemsO4qf9hPu45YRbD8jwfS9gldYXYzbks
         P/NFl9w+xFp2mGgPlsnrLsadmnnR8j/r/xai/sGiyCi7iywBXswq1YGtDhi8Uv2LhNV4
         xDWikwelh8GONLSZYECIKQ4tL7ku8nxUmBTfRHr9q29spimJjKd0EgPGslWDgRX0o5bE
         LXqBnBk0w71ww1yQr0lhgZy0GG7M8aKkPEmO+q4ZEsKA8CBd1RECIFbzfBvC/RGPfJHG
         wyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tve9D8iQuxh5AgLBP6EM+21dbBb6xwy+MqCcMe7KYYM=;
        b=EDF6wLdyaB1p2WdNWlvHxn5nIYPl/ROR9HJuRQzhKXJlPH7n7wr+cHx/3jOGOPLBWP
         7dSHmWcZ8kI5PcqyYtrgWtAYJpGPqdpiHojmQTOQZjdiWh8mzfWK0CjrnkjgGpRX+q/E
         bCkRlJRyQ0/UuXXMWeKEN3uQev0fwZ8y4SIzM1R3tBEL6JZ+mTjLR0ziXlUxRy2pyeoo
         X3TpIk9zj1ZeiFO2AOO7Oixf+0OEl1hw7xp7fc13XBnPtGV2wU32LdoaOdLrQk/oORMU
         3fUN//BNEv4WPSUMgzDLjlK61uaA0IeA3GS0XSeSKSO3n9Bs1Xjm0e/4znMaEebVEIxw
         L3KQ==
X-Gm-Message-State: AJIora+uP0lnW3X9xBFbp+Q5f+YywptUXlREqnsu4BxldEIMuLBtdWNM
        LS2frUvj/zJqihnYSv3Ano0CYjQnvqo5+w==
X-Google-Smtp-Source: AGRyM1sFmzLdHbC5fmWxPJoCzrwCUyjZTrF4XYkzrj6O1s8EJpOcPng1zYWgovZu9kL3MT2iEesZAQ==
X-Received: by 2002:a63:f10c:0:b0:40d:4029:b250 with SMTP id f12-20020a63f10c000000b0040d4029b250mr6482360pgi.328.1656016633404;
        Thu, 23 Jun 2022 13:37:13 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:a654:18fe:feac:cac1])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902768c00b0016a17da4ad4sm228386pll.39.2022.06.23.13.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 13:37:13 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v3 5/7] xfs: check sb_meta_uuid for dabuf buffer recovery
Date:   Thu, 23 Jun 2022 13:36:39 -0700
Message-Id: <20220623203641.1710377-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220623203641.1710377-1-leah.rumancik@gmail.com>
References: <20220623203641.1710377-1-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.37.0.rc0.161.g10f37bed90-goog

