Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E25FC48BDF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 22:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF3A6613E7
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 22:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFJWj5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 18:39:57 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:42255 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230001AbhFJWj4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 18:39:56 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 06E211B24D0;
        Fri, 11 Jun 2021 08:37:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lrTJ5-00BJBQ-Ei; Fri, 11 Jun 2021 08:37:47 +1000
Date:   Fri, 11 Jun 2021 08:37:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH] xfs: perag may be null in xfs_imap()
Message-ID: <20210610223747.GR664593@dread.disaster.area>
References: <YMGuMliXClE/dz5y@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMGuMliXClE/dz5y@mwanda>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=nGEny-X-3y5f4hnbiasA:9 a=CjuIK1q_8ugA:10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Dan Carpenter's static checker reported:

The patch 7b13c5155182: "xfs: use perag for ialloc btree cursors"
from Jun 2, 2021, leads to the following Smatch complaint:

    fs/xfs/libxfs/xfs_ialloc.c:2403 xfs_imap()
    error: we previously assumed 'pag' could be null (see line 2294)

And it's right. Fix it.

Fixes: 7b13c5155182 ("xfs: use perag for ialloc btree cursors")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 654a8d9681e1..57d9cb632983 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2398,7 +2398,8 @@ xfs_imap(
 	}
 	error = 0;
 out_drop:
-	xfs_perag_put(pag);
+	if (pag)
+		xfs_perag_put(pag);
 	return error;
 }
 
