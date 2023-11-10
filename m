Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30835C4167D
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 18:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345123AbjKJSdv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 13:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345935AbjKJSc4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 13:32:56 -0500
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA33E769A
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 22:35:56 -0800 (PST)
Received: by mail-vk1-xa2c.google.com with SMTP id 71dfb90a1353d-495eb6e2b80so699147e0c.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Nov 2023 22:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699598156; x=1700202956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAgzcH6FFhfbjo0YkD02u992ODaRxIrDZcHhICDx4Xc=;
        b=FSmtP+syP8OG6q4yfrB9fp+f0zliJxBbg65DOE1955nNwVkAyjYUmP1U8IffG6S68w
         jy4lIoaLXBK6YfhEAlRUHhJPrbwAU96igN8B2775LHl0XSIdWx2EyptqumqPLercw39V
         2wM37ssjy1Ehc5FQ9M3tBNGZoy2XGBWXyQUZe+Ls0Mnn+/sh4o+dbHHo+n+e1yQ6QJSI
         G6Cp2TyCnIkt020fVobR3Q/bZvCrGe+E0x/yPqlUW/oAR17j0ViZyBa0SalLSzWrS/i8
         pzIj0Q07dRreaezrk9da1asts0xRK8YKUvFBTJo8rJgl/Z2rSQVJpyxp/oWPqvwZd4wn
         kgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699598156; x=1700202956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qAgzcH6FFhfbjo0YkD02u992ODaRxIrDZcHhICDx4Xc=;
        b=a7vJuZWBM5/smAyeOdmGUzLLblOdG8oy4v2iT40nb9hRByZSL/RTsqFTBgV2Ry5OU6
         vkTzECas3bRIFuUu7PcMntt1FKssTMunup4aPmjN+/uE3qHF3faGSMUUtI54Kfhi6Umx
         +Gd5gr423z5yxzAhPSsQp/Squae4ObplAgxSy2LoCzu3tVeTtlTarH4vt8KZLKc4I39d
         qOn3PUlN+SJQk6GVCDrXe0lhA9JtDgaFY1W/TJXB0rZUx4Ec+qCVtyNsIdmLz5bJfiT3
         DssOxWOPfVMT6A0NqZbkCeyCU9tGPgBAqJiXDO5W6DoWcwbC6ZkYvftiIGAPZ2qEL2n/
         NgBQ==
X-Gm-Message-State: AOJu0YzrwbEALIrH3DXD9PQ4pqvf0/6KeMfD2F4lvAy8lNuvQnMBFLkx
        Cxbd0JmJAmMx50vznlqlNbdrSDZcZHxAPye6SCg=
X-Google-Smtp-Source: AGHT+IGeGB0nvjJ9ovXVOONcVOWKrKTYTcxW4uwrb0x7AObsTnKz7JFJpdIz1TdPp1R0GMvRIth4qA==
X-Received: by 2002:a05:620a:2682:b0:775:7be2:8c8 with SMTP id c2-20020a05620a268200b007757be208c8mr7006165qkp.61.1699591505744;
        Thu, 09 Nov 2023 20:45:05 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id g1-20020aa78181000000b0065a1b05193asm11529825pfi.185.2023.11.09.20.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 20:45:05 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1r1JOB-00AbtL-1M;
        Fri, 10 Nov 2023 15:45:03 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1r1JOB-000000039Jf-01tP;
        Fri, 10 Nov 2023 15:45:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     zlang@redhat.com
Subject: [PATCH 2/2] xfs: recovery should not clear di_flushiter unconditionally
Date:   Fri, 10 Nov 2023 15:33:14 +1100
Message-ID: <20231110044500.718022-3-david@fromorbit.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231110044500.718022-1-david@fromorbit.com>
References: <20231110044500.718022-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because on v3 inodes, di_flushiter doesn't exist. It overlaps with
zero padding in the inode, except when NREXT64=1 configurations are
in use and the zero padding is no longer padding but holds the 64
bit extent counter.

This manifests obviously on big endian platforms (e.g. s390) because
the log dinode is in host order and the overlap is the LSBs of the
extent count field. It is not noticed on little endian machines
because the overlap is at the MSB end of the extent count field and
we need to get more than 2^^48 extents in the inode before it
manifests. i.e. the heat death of the universe will occur before we
see the problem in little endian machines.

This is a zero-day issue for NREXT64=1 configuraitons on big endian
machines. Fix it by only clearing di_flushiter on v2 inodes during
recovery.

Fixes: 9b7d16e34bbe ("xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers")
cc: stable@kernel.org # 5.19+
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item_recover.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index f4c31c2b60d5..dbdab4ce7c44 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -371,24 +371,26 @@ xlog_recover_inode_commit_pass2(
 	 * superblock flag to determine whether we need to look at di_flushiter
 	 * to skip replay when the on disk inode is newer than the log one
 	 */
-	if (!xfs_has_v3inodes(mp) &&
-	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
-		/*
-		 * Deal with the wrap case, DI_MAX_FLUSH is less
-		 * than smaller numbers
-		 */
-		if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
-		    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
-			/* do nothing */
-		} else {
-			trace_xfs_log_recover_inode_skip(log, in_f);
-			error = 0;
-			goto out_release;
+	if (!xfs_has_v3inodes(mp)) {
+		if (ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
+			/*
+			 * Deal with the wrap case, DI_MAX_FLUSH is less
+			 * than smaller numbers
+			 */
+			if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
+			    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
+				/* do nothing */
+			} else {
+				trace_xfs_log_recover_inode_skip(log, in_f);
+				error = 0;
+				goto out_release;
+			}
 		}
+
+		/* Take the opportunity to reset the flush iteration count */
+		ldip->di_flushiter = 0;
 	}
 
-	/* Take the opportunity to reset the flush iteration count */
-	ldip->di_flushiter = 0;
 
 	if (unlikely(S_ISREG(ldip->di_mode))) {
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
-- 
2.42.0

