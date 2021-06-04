Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8366C48BC2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 21:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2675613F4
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 21:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhFDVMD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 17:12:03 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:39596 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbhFDVMC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jun 2021 17:12:02 -0400
Received: by mail-qk1-f201.google.com with SMTP id o14-20020a05620a130eb02902ea53a6ef80so7406528qkj.6
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 14:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=91peql34DHbFUki+AbIkoVzV6GEWt4wa1rjinU0Vj1o=;
        b=NWM6rSqjQWgBV4b0PQCeKKpM41Gh30JBudqV4IzVKloaLmDl/Elq/REtE98KKwRDDK
         RoyIta1OKr/9Zo6G9QXrLium4ej+9gKZTVPYUePqI1jhOJgobWyhOoEeUm6Z8HlMRjIr
         Qx4GLl9jime2jzklU9y2MF4l4VIiast22wwPkx8CULvJraclZ2P+a0Rou3l70zG/oHiq
         1UjT69ghMT/VyqfhLtg/Z6iCpGrigd9QganfvoleBrBwR0XeBn1h+LbhUsV4OYDFF6iX
         rkUigqHsbMPT6bWEOC6ezUgYqzhG+7kTT2s2TUnbwbfhC+8Z9agd+FqZP4QJKKf7EKS3
         yU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=91peql34DHbFUki+AbIkoVzV6GEWt4wa1rjinU0Vj1o=;
        b=Awdu9LwzS5OMNX3D82SCa1Xuez/kpnNNhdDZxbqQuKfWhemTmbtKPWJbDFpsLnQvK+
         FSrzNc2T5Qp4AdMhwySLr1+wn0TBB8Wo5r3AohDW4slMFNJnKmQFzvMfgttymOdbDndl
         Scuhtj6/a8Y2IuTk3TntxXB4A+VrZLCzvWV7WvCCxxZr1HlcMv3qxThd6i5rJ7Kio3Xt
         1rsJLZenyi9OxrBSHOqje6cqedzljMmvaUG+4XC/fUs/rrOaS2ZhsWBxV1qO0ENthIRY
         bZbtkQQaAVLawPAZr2E4ieqsd3745pp22XkoYi6epm70rdRKnpKP5Y6qc5gTWdqfmnnu
         xvYg==
X-Gm-Message-State: AOAM530uALAaAWLFZmYmHzRk7lZbURnX1AYWXHcCphMPcMU5yStbcrvU
        YxIiXvDtrnzufeTAeyOSha3hmm71wbM=
X-Google-Smtp-Source: ABdhPJyxZNAgaBzH8MB4R3w5D0FDEiNYSY0E6g3pRNVW4sq6jgFG0GaBevF/RjxS6fOw2/bE9D33hwV+eRU=
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a05:6214:428:: with SMTP id
 a8mr3037233qvy.3.1622840954643; Fri, 04 Jun 2021 14:09:14 -0700 (PDT)
Date:   Fri,  4 Jun 2021 21:09:01 +0000
In-Reply-To: <20210604210908.2105870-1-satyat@google.com>
Message-Id: <20210604210908.2105870-3-satyat@google.com>
Mime-Version: 1.0
References: <20210604210908.2105870-1-satyat@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v9 2/9] block: blk-crypto: relax alignment requirements for
 bvecs in bios
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

blk-crypto only accepted bios whose bvecs' offsets and lengths were aligned
to the crypto data unit size, since blk-crypto-fallback required that to
work correctly.

Now that the blk-crypto-fallback has been updated to work without that
assumption, we relax the alignment requirement - blk-crypto now only needs
the total size of the bio to be aligned to the crypto data unit size.

Co-developed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 block/blk-crypto.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index c5bdaafffa29..06f81e64151d 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -200,22 +200,6 @@ bool bio_crypt_ctx_mergeable(struct bio_crypt_ctx *bc1, unsigned int bc1_bytes,
 	return !bc1 || bio_crypt_dun_is_contiguous(bc1, bc1_bytes, bc2->bc_dun);
 }
 
-/* Check that all I/O segments are data unit aligned. */
-static bool bio_crypt_check_alignment(struct bio *bio)
-{
-	const unsigned int data_unit_size =
-		bio->bi_crypt_context->bc_key->crypto_cfg.data_unit_size;
-	struct bvec_iter iter;
-	struct bio_vec bv;
-
-	bio_for_each_segment(bv, bio, iter) {
-		if (!IS_ALIGNED(bv.bv_len | bv.bv_offset, data_unit_size))
-			return false;
-	}
-
-	return true;
-}
-
 blk_status_t __blk_crypto_init_request(struct request *rq)
 {
 	return blk_ksm_get_slot_for_key(rq->q->ksm, rq->crypt_ctx->bc_key,
@@ -271,7 +255,8 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 		goto fail;
 	}
 
-	if (!bio_crypt_check_alignment(bio)) {
+	if (!IS_ALIGNED(bio->bi_iter.bi_size,
+			bc_key->crypto_cfg.data_unit_size)) {
 		bio->bi_status = BLK_STS_IOERR;
 		goto fail;
 	}
-- 
2.32.0.rc1.229.g3e70b5a671-goog

