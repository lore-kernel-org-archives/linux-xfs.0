Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BDCC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Oct 2022 14:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiJJObZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Oct 2022 10:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJJObZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2022 10:31:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FBFB5C;
        Mon, 10 Oct 2022 07:31:24 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id bp11so4574123wrb.9;
        Mon, 10 Oct 2022 07:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9W6fJqaiY306Xcvj7NQVcBf2jidCS9KF6ZaE4FOoSAw=;
        b=lFSLJNtZg7aySb11HILc8GRwsoQ8ITFGL56TkFHYScjObqvzH1OyVWcQ+IZhvj5VWn
         g1cxvXRUOgYSbtZY5b9pEIlSBgLMZzDkqURWgjE1wmL9Cpq2u8aU0CKvmAtHoDNch0W1
         DSloWwm4GKw/9uFpwtv4BsLLgHw98F1JMZG8yuvre9NSr6gFyjNPOfJAPfnK3EqKEjFD
         vcXyIoww74oC3EqI7sNxNudq9xKtpVgjrpKS+eGKI9gSMtmMimrYhtcnDoenxQLLEGdm
         Ut6NJZhcoJ/GO1cXlnVsMcF30aSVLxlqHfcAq7P8DrB700hXraCP10BUOqlr8J6lFipm
         ZpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9W6fJqaiY306Xcvj7NQVcBf2jidCS9KF6ZaE4FOoSAw=;
        b=WjHA3X1XQATosKWlkiRBhRKY3FoVpbwEaGGGjliSx8Iib3wbyTqx0Pj/4euwFQLBXu
         /pP//O5C9e+KaF1ryTPC1hvNK4BAmeQx5EHbJuzRlndfomSi2cQV/TFdJUheeskQpKkM
         efr+EMDns3yNON074nDrji0v9jh//GtEQGbc639Q2nPO2rPlzOgWTIoCCt0kbLgq95wP
         Y37pZZ92wGTU4VU1yiW4Geg7IUIiEfgYZ7LTDeqf2cu8IZdxu7o37yCBfmL1qoQKytPi
         aKW3Nj3uW3N86C7QxzsASYvR776InSTti18BPgwnHkL4YlAassvQeQp8wPDu3oLXZ8Nb
         nsSQ==
X-Gm-Message-State: ACrzQf0mliUke/qNTaFvoYXgZX8JRDmn7iH9HjhYRXh9+85WsPx8RKmc
        GbGR7bN0acohBm7XqtSXxRQ=
X-Google-Smtp-Source: AMsMyM6ijEZJGwyQ7LKHbfjb62oWOOcJT2eu6knCIqMhkC/VbFM16rdd36p7YjBlYyjFpjpnzJW8PA==
X-Received: by 2002:a05:6000:1887:b0:22e:5026:42c3 with SMTP id a7-20020a056000188700b0022e502642c3mr11667116wri.687.1665412282579;
        Mon, 10 Oct 2022 07:31:22 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id r17-20020a05600c459100b003b4a68645e9sm16223768wmo.34.2022.10.10.07.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 07:31:20 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, bllvm@lists.linux.dev
Subject: [PATCH] xfs: remove redundant pointer lip
Date:   Mon, 10 Oct 2022 15:31:19 +0100
Message-Id: <20221010143119.3191249-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The assignment to pointer lip is not really required, the pointer lip
is redundant and can be removed.

Cleans up clang-scan warning:
warning: Although the value stored to 'lip' is used in the enclosing
expression, the value is never actually read from 'lip'
[deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 fs/xfs/xfs_trans_ail.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 16fbf2a1144c..87db72758d1f 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -730,11 +730,10 @@ void
 xfs_ail_push_all_sync(
 	struct xfs_ail  *ailp)
 {
-	struct xfs_log_item	*lip;
 	DEFINE_WAIT(wait);
 
 	spin_lock(&ailp->ail_lock);
-	while ((lip = xfs_ail_max(ailp)) != NULL) {
+	while (xfs_ail_max(ailp)) {
 		prepare_to_wait(&ailp->ail_empty, &wait, TASK_UNINTERRUPTIBLE);
 		wake_up_process(ailp->ail_task);
 		spin_unlock(&ailp->ail_lock);
-- 
2.37.3

