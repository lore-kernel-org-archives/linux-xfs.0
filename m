Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04BEC433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 09:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 509DE239A1
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 09:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbhAUJKJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 04:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbhAUJKA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 04:10:00 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0DDC061757;
        Thu, 21 Jan 2021 01:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ym1CuL3+wqw+X8HU/55ILNdm6HWcfbAaWLvIFZ0mv1o=; b=nAqS2uGSPWn5NU7UYNNs4o9TK9
        i6LhP8Wa5mlAM3xsbIt1PXTbH3LcXUgrfGe+TkHb+6z/O8ErPgievz6s0mSX8fVq8vcx2zXACNi2L
        NAz3QFdwewAWEo9pKNHxSU7eFugg/Xsno7DqC67U9QLff6PvZHxae/H1CnCmYCHUku8j0HIClEtpn
        AjQL/35yS4hjUAnuuxaiy9ZJk+Xn4Cd/BDHXUSCcB3v0543nC4kExuSQs6U9ABNz0E7NAgu9MjYED
        b07bCtOvMvSbqRuNPmIWABpbgafpUVIN8CGZ98hK4INAwl5CcdhSuPbSMsgzv7nAeDKz1dfAdJja5
        phNeJIhw==;
Received: from [2001:4bb8:188:1954:d5b3:2657:287:e45f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2Vxg-00GqWX-0J; Thu, 21 Jan 2021 09:09:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, avi@scylladb.com,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 04/11] xfs: remove the buffered I/O fallback assert
Date:   Thu, 21 Jan 2021 09:58:59 +0100
Message-Id: <20210121085906.322712-5-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121085906.322712-1-hch@lst.de>
References: <20210121085906.322712-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The iomap code has been designed from the start not to do magic fallback,
so remove the assert in preparation for further code cleanups.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ae7313ccaa11ed..97836ec53397d4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -610,12 +610,6 @@ xfs_file_dio_write(
 out:
 	if (iolock)
 		xfs_iunlock(ip, iolock);
-
-	/*
-	 * No fallback to buffered IO after short writes for XFS, direct I/O
-	 * will either complete fully or return an error.
-	 */
-	ASSERT(ret < 0 || ret == count);
 	return ret;
 }
 
-- 
2.29.2

