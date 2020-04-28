Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4EC4C83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 06:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90BB6206B9
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 06:22:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WhYJ8dlj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgD1GWn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 02:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726042AbgD1GWn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 02:22:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D674EC03C1A9
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 23:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sCetOEOvMHo8g9FgK5oqXISx36OTh3ArNOUkexRXZlw=; b=WhYJ8dljUIBbyJp1BJ4DNr4Tbh
        7ol1xTyWcc1xezaGGbXCjnGx80deMoRFLP/H7+yKiPJglhXtPgwSUQknAqW+bDK38QBCUJoRrhMhU
        eMuZbISwjv7gTZtvxcSrGCeKOwmaaGBDLDY+FMMWKoTegOGi6zU16S/MJkKHjtK1M1112qwwG2ruG
        KOdZ5F8ZiNdt/+YH+Mt9ruLgoYXqufb1jolOUqpzfErkM9it4QxF52GjWpXXTziK9JKm/P+kNNkNF
        /0NJQ+Rr9Cj2BP3R8PmrGn8X8SnGDSxXaXr6Gi3K0G56nnt3jr3ez6Ip+JkT9MPjEWWWnO/DtqCmK
        Dz5XQIvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jTJdi-0005ro-Oe; Tue, 28 Apr 2020 06:22:42 +0000
Date:   Mon, 27 Apr 2020 23:22:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/19] xfs: refactor log recovery
Message-ID: <20200428062242.GB18850@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With all patches applied we can also drop several includes in
xfs_log_recovery.c:

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b210457d6ba23..9250c29193a71 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -18,21 +18,13 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
-#include "xfs_inode_item.h"
-#include "xfs_extfree_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
-#include "xfs_quota.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_error.h"
-#include "xfs_dir2.h"
-#include "xfs_rmap_item.h"
 #include "xfs_buf_item.h"
-#include "xfs_refcount_item.h"
-#include "xfs_bmap_item.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
