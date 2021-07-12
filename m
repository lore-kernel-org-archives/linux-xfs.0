Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9041BC07E9A
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B49261106
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhGLLPO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 07:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbhGLLPO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jul 2021 07:15:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2D8C0613DD;
        Mon, 12 Jul 2021 04:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=V+KO/u3GnG66QraDJkDTkR2XI53P0PtTs8keaHE0kos=; b=f+Z9xzezHTbYMKMJj9BXx+uZoa
        lu4grSXUKSolJxjdo5RuNAhQrF8NEAqz9V6sWViVNP8CDDwGob1q0tS/HoEW/69nlSmghSZg1Zc4U
        v2czbOvp83EFsx2zcbvNsoUBHVglWTKNKiflS4pkx9iCZSy5HRKKr1dOcodFE1ItQIogI8wIR6+On
        H92gXnVCbnVZIsIz/00/8bjXr9MQX+KtKscdr5rv+hl5aWSdjTLQkG7IGOHmaIpn70Gzjs6aBk7gD
        OCev6KyYwQscJaoMS4WwWSPtDzj3paD/J0f9F9ifHvL/gxJejMYGS0/TxpQ1yN1L7OmA3S5Rmzlgk
        9o+QZfZg==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2tr0-00HXDS-2Y; Mon, 12 Jul 2021 11:12:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] common/quota: allow removing quota options entirely in _qmount_option
Date:   Mon, 12 Jul 2021 13:11:41 +0200
Message-Id: <20210712111146.82734-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712111146.82734-1-hch@lst.de>
References: <20210712111146.82734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add support for dropping all quota related options instead of only
overriding them with new ones to _qmount_option.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/quota | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/common/quota b/common/quota
index 883a28a2..7fa1a61a 100644
--- a/common/quota
+++ b/common/quota
@@ -263,7 +263,9 @@ _qmount_option()
 			-e 's/prjquota/quota/g'`
 	fi
 	# Ensure we have the given quota option - duplicates are fine
-	export MOUNT_OPTIONS="$MOUNT_OPTIONS -o $OPTS"
+	if [ -n "$OPTS" ]; then
+		export MOUNT_OPTIONS="$MOUNT_OPTIONS -o $OPTS"
+	fi
 	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
 }
 
-- 
2.30.2

