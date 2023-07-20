Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2DC0C04A94
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 18:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjGTSNW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 14:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjGTSNV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 14:13:21 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C068AE6F
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 11:13:20 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-34637e55d9dso1179125ab.1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 11:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689876800; x=1690481600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Evtw5/CKfgOAfc/VQ4aHsJxNdKm95vnozn2z+EJmynA=;
        b=2FZWTI6VE/8V0avffLim6HIwlxD9Fk2MtUln2XBht9nr7LlA02/G+cdms+E2P1SqX/
         HuvnxtiX+9vWPOpcH4gnsA+7c3lSZM2wtY24DPAKQCEEcEeWOhT3WiI/2xVQ8HIFN31W
         1614oB0Lg3n2wiX+b4OV2JZCbBVrUaXcpPVXl6MnWEIHtETEwB7RiMq/wPu+XA6kbzBR
         YgPF0aQppdrVuLkXBF9mc1wJU86C5ASd9XkupSuUroSPNP3OulB86OrEOK0zvXglZEHJ
         t1F3hQTNxBee51uRpPwUDh0YrAIM/9xN7NF1MEOKdXD3GCYNhqa54dLWUgHZjJYE+ErR
         /z8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689876800; x=1690481600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Evtw5/CKfgOAfc/VQ4aHsJxNdKm95vnozn2z+EJmynA=;
        b=N3ZDBvJKNg4jQqRIn5ibfoK0/A5O/dJzm4Pzo2OS+7qg0JgqUOh80VOcSEN5sDJJWU
         uXp2ISQ76x3YqWehcwzGDSFWouTm23wgE/riCoOtd7RBhfrMaSF7LbWac7Hldv4JAw7B
         ZkdMPUjIKGSGGxcbEEZHNxQiPHaY1ub5YRYvWSi06sEgllrlvUcun+r7gmR2ruvYqLHU
         whpkM36wL5y2+EVBQpBTsdxEr6eBpu/u4PL7xrtAbeDubS1BaK9Jo2EeTDmmSUtG/WL7
         tKt4KSSp7dcRrFLVj71pBjnIzbtjkmxlprTn13Pzfci4Ul7eIAmrk1XJ5mRVFGdwOiK0
         BO3Q==
X-Gm-Message-State: ABy/qLaETMG/6niRg2KuHlhaIrpHIj3qvDV2oXMjff5og4i3i98FYlwB
        IaGrGiClvAN6UUwhAm62l9oQYw==
X-Google-Smtp-Source: APBJJlFssnsUezB0DYxfeknIGY4IWa5Hun4JEj8st3lJH1IWgoUsLVFo7skmJAH77DlOnsrYnJF1TA==
X-Received: by 2002:a92:c243:0:b0:346:1919:7cb1 with SMTP id k3-20020a92c243000000b0034619197cb1mr12076111ilo.2.1689876800080;
        Thu, 20 Jul 2023 11:13:20 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v6-20020a92c6c6000000b003457e1daba8sm419171ilm.8.2023.07.20.11.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 11:13:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/8] iomap: completed polled IO inline
Date:   Thu, 20 Jul 2023 12:13:06 -0600
Message-Id: <20230720181310.71589-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720181310.71589-1-axboe@kernel.dk>
References: <20230720181310.71589-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Polled IO is only allowed for conditions where task completion is safe
anyway, so we can always complete it inline. This cannot easily be
checked with a submission side flag, as the block layer may clear the
polled flag and turn it into a regular IO instead. Hence we need to
check this at completion time. If REQ_POLLED is still set, then we know
that this IO was successfully polled, and is completing in task context.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 9f97d0d03724..c3ea1839628f 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -173,9 +173,19 @@ void iomap_dio_bio_end_io(struct bio *bio)
 	}
 
 	/*
-	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline
+	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline.
+	 * Ditto for polled requests - if the flag is still at completion
+	 * time, then we know the request was actually polled and completion
+	 * is called from the task itself. This is why we need to check it
+	 * here rather than flag it at issue time.
 	 */
-	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
+	if ((dio->flags & IOMAP_DIO_INLINE_COMP) || (bio->bi_opf & REQ_POLLED)) {
+		/*
+		 * For polled IO, we need to clear ->private as it points to
+		 * the bio being polled for. The completion side uses it to
+		 * know if a given request has been found yet or not. For
+		 * non-polled IO, ->private isn't applicable.
+		 */
 		WRITE_ONCE(iocb->private, NULL);
 		iomap_dio_complete_work(&dio->aio.work);
 		goto release_bio;
-- 
2.40.1

