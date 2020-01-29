Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEFDC33CB2
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 06:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 635C420708
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 06:49:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U6WZgtnL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgA2Gt3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 01:49:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43060 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgA2Gt2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 01:49:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I+WRzRbkEmVcsGD0rCc/ZFXJqXvy5BASpe4e86R9DBQ=; b=U6WZgtnLW8kAD6VCGRCzAMVLn
        9jxrA6DlSZZBTo8+j71v43LzynRQYI5gd+L3IW7Gfgdbl5a9VED+kGo+go7q09u7j6v9iIgg60+Dp
        uP3HSCJD06KZBhjAoZ4WSCqYMFd2wjsIShpwPYwasElEnuAWu015WeQ9AM7IBwHyW1CqJjBypRqK2
        PZ2UeYwczqI26k2lHJItqLahBM8ffBuIYucd+2aFcNYDNJ/GAF/QQJQ/J4rc50wbKz3DUpqwnEe14
        vft71EyNEo7yogK6DT6+0r52BT+h+/zm7cuiEEwWgT/z12fK4AZHMynB3+++Jpy6YURbpU3x/KcOj
        UYMV7dGGA==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwhAG-0001Se-A0
        for linux-xfs@vger.kernel.org; Wed, 29 Jan 2020 06:49:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfsprogs: remove the ENABLE_GETTEXT substitution in platform_defs.h.in
Date:   Wed, 29 Jan 2020 07:49:19 +0100
Message-Id: <20200129064923.43088-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129064923.43088-1-hch@lst.de>
References: <20200129064923.43088-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

ENABLE_GETTEXT is already defined on the command line if enabled, no
need to duplicate it in platform_defs.h.in.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h.in | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 1f7ceafb..6cc56e31 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -36,8 +36,6 @@ typedef struct filldir		filldir_t;
 typedef unsigned short umode_t;
 #endif
 
-/* Define if you want gettext (I18N) support */
-#undef ENABLE_GETTEXT
 #ifdef ENABLE_GETTEXT
 # include <libintl.h>
 # define _(x)                   gettext(x)
-- 
2.24.1

