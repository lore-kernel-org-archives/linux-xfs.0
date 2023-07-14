Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7CCC001DE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 08:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbjGNIv4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 04:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbjGNIvy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 04:51:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637C62702;
        Fri, 14 Jul 2023 01:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IgRNswv9gww1Ijnp4cSF7uAvKJ5XMzcE2orXIk8I3Qk=; b=3JRg7xuSfHRLdkh+jmfwOF6lYg
        wQ14X1QMAMzlEj5+w2n8PIalDGV96GUjD6UbFqW+L5xkJNj/j94vKTNKTNerKgZDjPrsAbvDzzxHV
        4/5q0MOIsWoRIAfUq/JXXoMM6KhlXR2hn0z/tX4agaBh+UiSrYoSbSUAAUaSLmTC14Ml50jHoXIkr
        otmWHL/xeF4Q1T1vlJ/d3WWGmD3f8+TJRu9iiR3axKm8SIYq3FExBg8Py0N5SEuvbukCOkjk4G9v+
        +D6oIQn3y2EWqUZfNBg6ut1rMQr94u6buHS6tSFicca9X/3xftkmGxVEHELdtWfyic+KWqMmrIA1a
        l9YNioNw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qKEWZ-005aIa-1w;
        Fri, 14 Jul 2023 08:51:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] iomap: micro optimize the ki_pos assignment in iomap_file_buffered_write
Date:   Fri, 14 Jul 2023 10:51:24 +0200
Message-Id: <20230714085124.548920-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230714085124.548920-1-hch@lst.de>
References: <20230714085124.548920-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We have the new value for ki_pos right at hand in iter.pos, so assign
that instead of recalculating it from ret.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 7cc9f7274883a5..aa8967cca1a31b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -875,7 +875,7 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 	if (unlikely(iter.pos == iocb->ki_pos))
 		return ret;
 	ret = iter.pos - iocb->ki_pos;
-	iocb->ki_pos += ret;
+	iocb->ki_pos = iter.pos;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
-- 
2.39.2

