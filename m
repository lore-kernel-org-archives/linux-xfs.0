Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8793AC47247
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5469A21775
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LMWHV01G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgEIRBn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgEIRBm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:01:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A3BC061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=aKUskYfSWkgPDIbeqdiprqGv10yszAnsXDPPVZVxkkc=; b=LMWHV01GS2N0gtsH5IuMjrD4VV
        Po+nowpL5xVEXkrp0EwWJneoZD6vQRa9cMlUuMyVbo3U7ZuYhi+5YcYLSBXOD8nVZ2SqRJ2MibR4+
        qaeIfkoiOiQmvZzChUfVphZxV7BICPIDR/B2Xf4TnCXgy980qcumQ7Hm36NU9gwS1Fja+sfPLDwLY
        4haCGOWb83sy6PkQ7MZHuvvUzufPBf+YsdJBZCQQEMjwTchITefIPSq7m21rkh8WfREUVm3zbhxTn
        AjzMgXRaJp52rWNrwODPi1ke1BmPt2FyjeuM+Av3QcbgCjiVJxJFX1R4Ymr2U4yttu2c1H8d+tw3D
        zhg8vznA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSr8-00065S-BJ; Sat, 09 May 2020 17:01:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] db: ensure that create and replace are exclusive in attr_set_f
Date:   Sat,  9 May 2020 19:01:23 +0200
Message-Id: <20200509170125.952508-7-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509170125.952508-1-hch@lst.de>
References: <20200509170125.952508-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Clear the other flag when applying the create or replace option,
as the low-level libxfs can't handle both at the same time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db/attrset.c b/db/attrset.c
index e3575271..b86ecec7 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -99,9 +99,11 @@ attr_set_f(
 		/* modifiers */
 		case 'C':
 			args.attr_flags |= XATTR_CREATE;
+			args.attr_flags &= ~XATTR_REPLACE;
 			break;
 		case 'R':
 			args.attr_flags |= XATTR_REPLACE;
+			args.attr_flags &= ~XATTR_CREATE;
 			break;
 
 		case 'n':
-- 
2.26.2

