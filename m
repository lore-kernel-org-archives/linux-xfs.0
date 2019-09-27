Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0183DC4360C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 15:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3C65217D9
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 15:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfI0Pqn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Sep 2019 11:46:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfI0Pqm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Sep 2019 11:46:42 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E107A3023080
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2019 15:46:42 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFA8B614C1
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2019 15:46:42 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: remove unused flags arg from xfs_get_aghdr_buf()
Message-ID: <2f4d86a1-0cb9-f859-b120-34d1b511942f@redhat.com>
Date:   Fri, 27 Sep 2019 10:46:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 27 Sep 2019 15:46:42 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The flags op is always passed as zero, so remove it.

(xfs_buf_get_uncached takes flags to support XBF_NO_IOACCT for
the sb, but that should never be relevant for xfs_get_aghdr_buf)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 5de296b34ab1..14fbdf22b7e7 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -28,12 +28,11 @@ xfs_get_aghdr_buf(
 	struct xfs_mount	*mp,
 	xfs_daddr_t		blkno,
 	size_t			numblks,
-	int			flags,
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
 
-	bp = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, flags);
+	bp = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, 0);
 	if (!bp)
 		return NULL;
 
@@ -345,7 +344,7 @@ xfs_ag_init_hdr(
 {
 	struct xfs_buf		*bp;
 
-	bp = xfs_get_aghdr_buf(mp, id->daddr, id->numblks, 0, ops);
+	bp = xfs_get_aghdr_buf(mp, id->daddr, id->numblks, ops);
 	if (!bp)
 		return -ENOMEM;
 

