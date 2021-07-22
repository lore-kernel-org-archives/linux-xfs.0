Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28E1C6377D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC30161285
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhGVG6i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhGVG6i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 02:58:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C963C061575;
        Thu, 22 Jul 2021 00:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=+4rFdmenskUWQxcBu4amh8q6OQuokyNEeMtwp1CcRyY=; b=sl0i0s/4JaF4nO3ZjZvWvIn+1a
        Fzh1Q1x5xw+G9Sj6d78IIuHwpShq8CpoWau37jDGUL6tY0BQhoYFnyfs75x/Y4i3foNjSK3E9bM0h
        TPkTiLpDLPoNN1vkG43bxoal2O9vgmFpic3TvVn7+aKrJi+YBNAjNsbW+pr1pa9IwAx9XGbBBV1yN
        8/dchnK7iKbAlmFR83Kxap0JIntnOhb5Nufpydzs9GRqDm2l6gmFg+VNMrJykcsP5UcLOLZ9W3PzZ
        cw1L5NJpWCnH/+IcFDQBxQ7ly9F7+DwqgqbWjHHzBl5wk/AdoIfquvNW4Ls/wBMJjJHB7w+pOL/1C
        iELgfxmA==;
Received: from [2001:4bb8:193:7660:643c:9899:473:314a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6TI9-00A0Rk-7w; Thu, 22 Jul 2021 07:38:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 1/7] common/quota: allow removing quota options entirely in _qmount_option
Date:   Thu, 22 Jul 2021 09:38:26 +0200
Message-Id: <20210722073832.976547-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210722073832.976547-1-hch@lst.de>
References: <20210722073832.976547-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add support for dropping all quota related options instead of only
overriding them with new ones to _qmount_option.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

