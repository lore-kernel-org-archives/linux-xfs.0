Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DCAC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 07:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 830366146D
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 07:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhA1HmG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 02:42:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231737AbhA1HjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 02:39:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611819464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BlFD86y0yUzbeJS0kSnp6QMi/kHvGDUkqdpZY2XhPCs=;
        b=WX+I1KVuJIjA2+/u4EMhigFQw0105p4Ba+V0Ow75eabtuJ83gt87X6wie1641Em00fjmvD
        2DnqBs82q0cNYdxP27aR7aly+N9E3q5GnkjI0NQ9VLRJgZ/X70dATLvR86NV83fF0SoUsh
        xKn3lmDyzq8NRJweCjKSBeuUTFrsyoc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-x2IVYMBFMmmO5CK0-iusyg-1; Thu, 28 Jan 2021 02:37:42 -0500
X-MC-Unique: x2IVYMBFMmmO5CK0-iusyg-1
Received: by mail-pj1-f70.google.com with SMTP id ds4so2866585pjb.8
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 23:37:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BlFD86y0yUzbeJS0kSnp6QMi/kHvGDUkqdpZY2XhPCs=;
        b=b9v8P7EVblmTrDhcHckN7YaLU9Efih+LK6N8vStbUhiGSsoMTwg2Sm/gqBRqUrMH4k
         w6PuXjPpadfXkvyAiAkOrqvfxPeAq/Rc2Q5/DIjtLF4Er+m49jxQPHIqXDWyd9Lk7qnd
         lLHaj5GW2GAilRIqDgLIF/r6u3N+fjk6XSBic6I7IUUcS3aB+mpXpzx7X844gYFE2UJa
         GMq9krmgGQBJ3PmbFZOLK4yxsFzapwnL6td3iLqM684m4YJIaHtiXfXhIWs6XZ1J+Z4f
         OpJzhPyBst7w6BGypKE83EWQZcmdO//X/L74SUoyIp8apTH9FPeka4vQssFSQjX3rxc0
         /sKA==
X-Gm-Message-State: AOAM5310pEJVxt7LYiWt3IogilpaF/y2iGiqyYt7/TGfPBLRNT7Om5SX
        QyrfRAbE6LwtspprTGFqiwFFER6O7NhWLZIM2wT1qJdhbWDGZVf5wdi39c6oiOLljHRhuvFcBOv
        KZJaB503lEXsgSCSgMzNTpUwQlT5QD1GwRJXLwzvB97ilp+jXIygctyDADzrkBQmJMM1/0WkI
X-Received: by 2002:a17:90a:886:: with SMTP id v6mr9883458pjc.143.1611819461077;
        Wed, 27 Jan 2021 23:37:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxPoGCFiZvOX/ncfNI5rRoJ5T4WfJJANHQFFjrZzwA7mBr4hNxij746Dfbj/6KXg452rBuSDQ==
X-Received: by 2002:a17:90a:886:: with SMTP id v6mr9883444pjc.143.1611819460782;
        Wed, 27 Jan 2021 23:37:40 -0800 (PST)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id n12sm4734897pff.29.2021.01.27.23.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 23:37:40 -0800 (PST)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 2/2] xfs_logprint: decode superblock updates correctly
Date:   Thu, 28 Jan 2021 18:37:08 +1100
Message-Id: <20210128073708.25572-3-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210128073708.25572-1-ddouwsma@redhat.com>
References: <20210128073708.25572-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Back when the way superblocks are logged changed, logprint wasnt
updated updated. Currently logprint displays incorrect accounting
information.

 SUPER BLOCK Buffer:
 icount: 6360863066640355328  ifree: 262144  fdblks: 0  frext: 0

 $ printf "0x%x\n" 6360863066640355328
 0x5846534200001000

Part of this decodes as 'XFSB', the xfs superblock magic number and not
the free space accounting.

Fix this by looking at the entire superblock buffer and using the format
structure as is done for the other allocation group headers.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 logprint/log_misc.c      | 22 +++++++++-------------
 logprint/log_print_all.c | 23 ++++++++++-------------
 2 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index d44e9ff7..929842d0 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -243,25 +243,21 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 	xlog_print_op_header(head, *i, ptr);
 	if (super_block) {
 		printf(_("SUPER BLOCK Buffer: "));
-		if (be32_to_cpu(head->oh_len) < 4*8) {
+		if (be32_to_cpu(head->oh_len) < sizeof(struct xfs_sb)) {
 			printf(_("Out of space\n"));
 		} else {
-			__be64		 a, b;
+			struct xfs_sb *sb, sb_s;
 
 			printf("\n");
-			/*
-			 * memmove because *ptr may not be 8-byte aligned
-			 */
-			memmove(&a, *ptr, sizeof(__be64));
-			memmove(&b, *ptr+8, sizeof(__be64));
+			/* memmove because *ptr may not be 8-byte aligned */
+			sb = &sb_s;
+			memmove(sb, *ptr, sizeof(struct xfs_sb));
 			printf(_("icount: %llu  ifree: %llu  "),
-			       (unsigned long long) be64_to_cpu(a),
-			       (unsigned long long) be64_to_cpu(b));
-			memmove(&a, *ptr+16, sizeof(__be64));
-			memmove(&b, *ptr+24, sizeof(__be64));
+				be64_to_cpu(sb->sb_icount),
+				be64_to_cpu(sb->sb_ifree) );
 			printf(_("fdblks: %llu  frext: %llu\n"),
-			       (unsigned long long) be64_to_cpu(a),
-			       (unsigned long long) be64_to_cpu(b));
+				be64_to_cpu(sb->sb_fdblocks),
+				be64_to_cpu(sb->sb_frextents));
 		}
 		super_block = 0;
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 2b9e810d..8ff87068 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -91,22 +91,19 @@ xlog_recover_print_buffer(
 		len = item->ri_buf[i].i_len;
 		i++;
 		if (blkno == 0) { /* super block */
-			printf(_("	SUPER Block Buffer:\n"));
+                        struct xfs_sb *sb = (struct xfs_sb *)p;
+			printf(_("	Super Block Buffer: (XFSB)\n"));
 			if (!print_buffer)
 				continue;
-		       printf(_("              icount:%llu ifree:%llu  "),
-			       (unsigned long long)
-				       be64_to_cpu(*(__be64 *)(p)),
-			       (unsigned long long)
-				       be64_to_cpu(*(__be64 *)(p+8)));
-		       printf(_("fdblks:%llu  frext:%llu\n"),
-			       (unsigned long long)
-				       be64_to_cpu(*(__be64 *)(p+16)),
-			       (unsigned long long)
-				       be64_to_cpu(*(__be64 *)(p+24)));
+			printf(_("		icount:%llu  ifree:%llu  "),
+					be64_to_cpu(sb->sb_icount),
+					be64_to_cpu(sb->sb_ifree));
+			printf(_("fdblks:%llu  frext:%llu\n"),
+					be64_to_cpu(sb->sb_fdblocks),
+					be64_to_cpu(sb->sb_frextents));
 			printf(_("		sunit:%u  swidth:%u\n"),
-			       be32_to_cpu(*(__be32 *)(p+56)),
-			       be32_to_cpu(*(__be32 *)(p+60)));
+			       be32_to_cpu(sb->sb_unit),
+			       be32_to_cpu(sb->sb_width));
 		} else if (be32_to_cpu(*(__be32 *)p) == XFS_AGI_MAGIC) {
 			int bucket, buckets;
 			agi = (xfs_agi_t *)p;
-- 
2.27.0

