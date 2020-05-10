Return-Path: <SRS0=ZB14=6Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C3AC54E8E
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0C6F2495A
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:14:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dYc+zvOe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEJHO6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 May 2020 03:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726743AbgEJHO6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:14:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F458C061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=mmFwmnBFZp6SC1NErGwqkY1fcIN6pLt7xlaczxMvVng=; b=dYc+zvOemC/cq3tHg0a3LrmKm4
        Jj0P+zrjVB1PsVJwsHggeHN8ONk6/hvERa1OH75ewsS3RxNfa9xCbmD8xX8N4lZh/QvdVD+/pgGuZ
        50QGWwcVX/IPxgxMQLBvVpKRKb2rel/bb6gQBiSaWHJb9MBMNLvwDRGF0wk7sac4+oHNTVree5iv8
        GO3DhXDsBDODoApbyGMS8ldIHIrzCASaAR209vj+tpZ4sDQn4ub0Xgge9ZjWWUv1jni21fexKtKne
        YfRm5GUn1zW3b0WTAoUVO9qV35mRya9mVJg8CquX3nZ8r65Z+7JMZqupDMD4Y+1tqf+qud94pIz7a
        szEEAHaQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgAr-0007i5-IQ; Sun, 10 May 2020 07:14:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] libxfs-apply: use git am instead of patch
Date:   Sun, 10 May 2020 09:14:55 +0200
Message-Id: <20200510071455.986111-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If neither guilt or stgit are used default to git am instead of patch
so that all the commit information is properly propagated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tools/libxfs-apply | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index deb9c225..3258272d 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -395,8 +395,8 @@ apply_patch()
 			fi
 		fi
 	else
-		echo "Applying with patch utility:"
-		patch -p1 < $_new_patch.2
+		echo "Applying with git am:"
+		git am -s $_new_patch.2
 		echo "Patch was applied in $REPO; check for rejects, etc"
 	fi
 
-- 
2.26.2

