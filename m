Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3E4C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6866A20746
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:39:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iLIsBAf0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgEIQjK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbgEIQjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:39:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E16C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 09:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=LuthuZyiYy3qvyQ1SjLtcJxg6MHHbbCOvgepiCkBCaA=; b=iLIsBAf0Hv4O8Zcs0QBcwHK0GR
        KpWB3XVwVUPwG8WXBmNPCLPddkBGX/YDbK+zWN2OD4XtRW7+qdOKnv9h+MHuZLeAu+3aBOUosbzAb
        BJWooCL7dHJvMAWPNs550MvuhNNUOcT7vkSBhZ7dJrLO14F55KdGhKagzZnfPrDzn8Z6+O3/8ANpK
        IXX+omNFlxaksGP3vsKUFmyLA2mJ4QYtLmhWWhRwfxWX/5rOEe+6feAhn4ygEpcC1ensfhxzqVrvX
        txy1LpXtByA5Vs6DqiYl9U4voTwni0KZiiI1gV8rPbfgMijX+l0MAbVvcAeaTuGs/nR77biWWi7Wj
        nufJezmA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSVH-0000KC-4G; Sat, 09 May 2020 16:39:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [RFC] support git am in tools/libxfs-apply
Date:   Sat,  9 May 2020 18:39:04 +0200
Message-Id: <20200509163904.883146-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Here is my local hack for using git am in tools/libxfs-apply.  What
would be the best way to integrate it for real?

---
 tools/libxfs-apply | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index deb9c225..923dc10f 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -396,7 +396,7 @@ apply_patch()
 		fi
 	else
 		echo "Applying with patch utility:"
-		patch -p1 < $_new_patch.2
+		git am -s $_new_patch.2
 		echo "Patch was applied in $REPO; check for rejects, etc"
 	fi
 
-- 
2.26.2

