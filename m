Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7B5C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 08:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50E8120640
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 08:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbfIRIZD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 04:25:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfIRIZC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 04:25:02 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B4CAF3082B3F;
        Wed, 18 Sep 2019 08:25:02 +0000 (UTC)
Received: from pegasus.maiolino.com (ovpn-204-62.brq.redhat.com [10.40.204.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C81485D9D5;
        Wed, 18 Sep 2019 08:25:01 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     bfoster@redhat.com, david@fromorbit.com
Subject: [PATCH 2/2] xfs: Limit total allocation request to maximum possible
Date:   Wed, 18 Sep 2019 10:24:53 +0200
Message-Id: <20190918082453.25266-3-cmaiolino@redhat.com>
In-Reply-To: <20190918082453.25266-1-cmaiolino@redhat.com>
References: <20190918082453.25266-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 18 Sep 2019 08:25:02 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The original allocation request may have a total value way beyond
possible limits.

Trim it down to the maximum possible if needed

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 07aad70f3931..3aa0bf5cc7e3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3477,6 +3477,11 @@ xfs_bmap_btalloc(
 			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
 		else
 			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
+
+		/* We can never have total larger than blen, so trim it now */
+		if (args.total > blen)
+			args.total = blen;
+
 		if (error)
 			return error;
 	} else if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
-- 
2.20.1

