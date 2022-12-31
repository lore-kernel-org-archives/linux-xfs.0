Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB86C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 15:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbiLaPMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 31 Dec 2022 10:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbiLaPLq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 31 Dec 2022 10:11:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2E1D13C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 07:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672499402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DQKaXBioDSeHnseK3c0h99kI8+k/CfMG7MW+ZVRX6dc=;
        b=SMkuSeg/XZOOl1Ysn7Q651m67VA6oWW/u1Ddr665qHFz2QFcOKErFpw+FO0Vvbs+HUzAqx
        qF3HJcF4LagbApqdkNLEu1zHFUG4d/+v4BOm4IX5Ca+HCqLhszeQQVgR6LWxkbBxqF/WKO
        nMTP+Qp3tDl2QhSAIShoWjF8OQhe41Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-u81ISahlMmSRbFuzCDtAOQ-1; Sat, 31 Dec 2022 10:09:51 -0500
X-MC-Unique: u81ISahlMmSRbFuzCDtAOQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0332D80D183;
        Sat, 31 Dec 2022 15:09:51 +0000 (UTC)
Received: from pasta.redhat.com (ovpn-192-3.brq.redhat.com [10.40.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEDFE492B00;
        Sat, 31 Dec 2022 15:09:48 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Subject: [PATCH v5 9/9] xfs: Make xfs_iomap_folio_ops static
Date:   Sat, 31 Dec 2022 16:09:19 +0100
Message-Id: <20221231150919.659533-10-agruenba@redhat.com>
In-Reply-To: <20221231150919.659533-1-agruenba@redhat.com>
References: <20221231150919.659533-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Variable xfs_iomap_folio_ops isn't used outside xfs_iomap.c, so it
should be static.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 5bddf31e21eb..7d1795a9c742 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -98,7 +98,7 @@ xfs_get_folio(
 	return folio;
 }
 
-const struct iomap_folio_ops xfs_iomap_folio_ops = {
+static const struct iomap_folio_ops xfs_iomap_folio_ops = {
 	.get_folio		= xfs_get_folio,
 };
 
-- 
2.38.1

