Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA0BC7EE2C
	for <linux-xfs@archiver.kernel.org>; Mon, 29 May 2023 00:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjE2AIf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 May 2023 20:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjE2AIf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2023 20:08:35 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD184C4
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 17:08:33 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-253340db64fso2553206a91.2
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 17:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685318913; x=1687910913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oGS54EbJNEjPNc5qKbjFvZzLWYRCNxLj06sBg/N74NI=;
        b=aVwQnpSNYX6aI2BsQH/CHupUcZQdn/cZA5ZLvsy0aA1s60KsBcqd/BbD8kJbPzhBA3
         wYpXxllxn981drPPB5vXo9bN5x2EK2Hqiw6GY8CRRBmYYuCUzbEQDdiMTEYyzsu+wxs1
         uXXpUKZGU2rPh/gq3ee8x4bYzgQ2In8U7hUs+uuhq1NHsmw817uW/Wh6YxRrK2bMMdR1
         SSXP/sr7xqayXFw0LRWiGtmgdVaTYH5u46tBNIpdXqrIWt8fBQd3xFQQEMv61hqpi/ln
         YUhFD9ZirihOCKOzGpPGMSfIONl0X1zls2OeF5zcsamdHeBiDiBlaUAEFqtau8tYXE7G
         sQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685318913; x=1687910913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGS54EbJNEjPNc5qKbjFvZzLWYRCNxLj06sBg/N74NI=;
        b=Pm9PJMqQMIoq/2cw7hehesIvQGABHzX/9FPk5R2RLS+cdhzjp9NR42fVnHWdQYMD6t
         dw+e1Ao7vb4VTZzykU/X1urf3T+AZkYwYTDPrFhYE861Ey0QS7EKPSBCF1zltNM4pqUv
         HqtwT+9J0NNson0cLp2eWNM9MwAGtd98+QnJsEVsvjSq06ihnOIoue9d7FjkyxwohxHR
         nYf2EjsFXGaSD+l0qsiLRjR7a6l6ccv3+7IUB4dLUlc+2Ux6BGee34reKTytEba1h0Ot
         1t0F6q3xbhUw8dNg3OXanVGsMUYnBZHNTH6RDdu7fqzHvmZeQf3OFTC/i+sTypNoc/bL
         1FUA==
X-Gm-Message-State: AC+VfDx6L5Wz1tp/oOUaK6WjkA2Y7a4DN5qoQ/c860Q1lsAcZJ9wLMz/
        Yt4T7byV33/6CyeAaO+loZpZVXf2TPgkuNag1GU=
X-Google-Smtp-Source: ACHHUZ4cgrMMcJwqNpURS9Oqc2IpfyV8S3zUDEQfOOlT4DGYAUDiIZ2UMfr9fhaq4srctMdsbg5SzA==
X-Received: by 2002:a17:90a:ebcb:b0:255:c5f7:ff3e with SMTP id cf11-20020a17090aebcb00b00255c5f7ff3emr9578512pjb.4.1685318913170;
        Sun, 28 May 2023 17:08:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id h22-20020a17090aa89600b0025315f7fef7sm7626289pjq.33.2023.05.28.17.08.31
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 17:08:32 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1q3QR2-00575x-2e
        for linux-xfs@vger.kernel.org;
        Mon, 29 May 2023 10:08:28 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1q3QR2-00A6VS-1U
        for linux-xfs@vger.kernel.org;
        Mon, 29 May 2023 10:08:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: fix agf/agfl verification on v4 filesystems
Date:   Mon, 29 May 2023 10:08:23 +1000
Message-Id: <20230529000825.2325477-2-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529000825.2325477-1-david@fromorbit.com>
References: <20230529000825.2325477-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When a v4 filesystem has fl_last - fl_first != fl_count, we do not
not detect the corruption and allow the AGF to be used as it if was
fully valid. On V5 filesystems, we reset the AGFL to empty in these
cases and avoid the corruption at a small cost of leaked blocks.

If we don't catch the corruption on V4 filesystems, bad things
happen later when an allocation attempts to trim the free list
and either double-frees stale entries in the AGFl or tries to free
NULLAGBNO entries.

Either way, this is bad. Prevent this from happening by using the
AGFL_NEED_RESET logic for v4 filesysetms, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 59 ++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 61eb65be17f3..fd3293a8c659 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -628,6 +628,25 @@ xfs_alloc_fixup_trees(
 	return 0;
 }
 
+/*
+ * We do not verify the AGFL contents against AGF-based index counters here,
+ * even though we may have access to the perag that contains shadow copies. We
+ * don't know if the AGF based counters have been checked, and if they have they
+ * still may be inconsistent because they haven't yet been reset on the first
+ * allocation after the AGF has been read in.
+ *
+ * This means we can only check that all agfl entries contain valid or null
+ * values because we can't reliably determine the active range to exclude
+ * NULLAGBNO as a valid value.
+ *
+ * However, we can't even do that for v4 format filesystems because there are
+ * old versions of mkfs out there that does not initialise the AGFL to known,
+ * verifiable values. HEnce we can't tell the difference between a AGFL block
+ * allocated by mkfs and a corrupted AGFL block here on v4 filesystems.
+ *
+ * As a result, we can only fully validate AGFL block numbers when we pull them
+ * from the freelist in xfs_alloc_get_freelist().
+ */
 static xfs_failaddr_t
 xfs_agfl_verify(
 	struct xfs_buf	*bp)
@@ -637,12 +656,6 @@ xfs_agfl_verify(
 	__be32		*agfl_bno = xfs_buf_to_agfl_bno(bp);
 	int		i;
 
-	/*
-	 * There is no verification of non-crc AGFLs because mkfs does not
-	 * initialise the AGFL to zero or NULL. Hence the only valid part of the
-	 * AGFL is what the AGF says is active. We can't get to the AGF, so we
-	 * can't verify just those entries are valid.
-	 */
 	if (!xfs_has_crc(mp))
 		return NULL;
 
@@ -2321,12 +2334,16 @@ xfs_free_agfl_block(
 }
 
 /*
- * Check the agfl fields of the agf for inconsistency or corruption. The purpose
- * is to detect an agfl header padding mismatch between current and early v5
- * kernels. This problem manifests as a 1-slot size difference between the
- * on-disk flcount and the active [first, last] range of a wrapped agfl. This
- * may also catch variants of agfl count corruption unrelated to padding. Either
- * way, we'll reset the agfl and warn the user.
+ * Check the agfl fields of the agf for inconsistency or corruption.
+ *
+ * The original purpose was to detect an agfl header padding mismatch between
+ * current and early v5 kernels. This problem manifests as a 1-slot size
+ * difference between the on-disk flcount and the active [first, last] range of
+ * a wrapped agfl.
+ *
+ * However, we need to use these same checks to catch agfl count corruptions
+ * unrelated to padding. This could occur on any v4 or v5 filesystem, so either
+ * way, we need to reset the agfl and warn the user.
  *
  * Return true if a reset is required before the agfl can be used, false
  * otherwise.
@@ -2342,10 +2359,6 @@ xfs_agfl_needs_reset(
 	int			agfl_size = xfs_agfl_size(mp);
 	int			active;
 
-	/* no agfl header on v4 supers */
-	if (!xfs_has_crc(mp))
-		return false;
-
 	/*
 	 * The agf read verifier catches severe corruption of these fields.
 	 * Repeat some sanity checks to cover a packed -> unpacked mismatch if
@@ -2889,6 +2902,19 @@ xfs_alloc_put_freelist(
 	return 0;
 }
 
+/*
+ * Verify the AGF is consistent.
+ *
+ * We do not verify the AGFL indexes in the AGF are fully consistent here
+ * because of issues with variable on-disk structure sizes. Instead, we check
+ * the agfl indexes for consistency when we initialise the perag from the AGF
+ * information after a read completes.
+ *
+ * If the index is inconsistent, then we mark the perag as needing an AGFL
+ * reset. The first AGFL update performed then resets the AGFL indexes and
+ * refills the AGFL with known good free blocks, allowing the filesystem to
+ * continue operating normally at the cost of a few leaked free space blocks.
+ */
 static xfs_failaddr_t
 xfs_agf_verify(
 	struct xfs_buf		*bp)
@@ -2962,7 +2988,6 @@ xfs_agf_verify(
 		return __this_address;
 
 	return NULL;
-
 }
 
 static void
-- 
2.40.1

