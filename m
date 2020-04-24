Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B725AC55191
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 12:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88FDA20736
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 12:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587731572;
	bh=D/WkIwVgvEMD3xO8gDUh7kVDLW+mEo/bNDyZXVnhDOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=dCjkynaPdBVsLQxB9yrNaDxw0lMxi13qciF9b9xnHSOcto92bVln3wCgU8r5vTwPp
	 8ooGRzcgtaR8lBJXlwt9915RSg0WvnLJmPORIIvOHv/n1SMDN+tiH1PO9PSOt/dp7X
	 cyoic1aYMZrJ9wTYv+bvNNOqymAWjniyt40YMu5I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgDXMWt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbgDXMWs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Apr 2020 08:22:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E141215A4;
        Fri, 24 Apr 2020 12:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587730968;
        bh=D/WkIwVgvEMD3xO8gDUh7kVDLW+mEo/bNDyZXVnhDOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6Uw/fDFjIAlFUeGmRpiIkhpMV7nOzajY3LG1D8iDp9/rMxh7rLJt1c7TGmV3heXT
         mk1cI2mz4o3hkriVHG6O7DiTeZ+AladZLPJmjip4JYri2Keqpvg2Leniytmnm74WN8
         mxj1or9vkvx5GKTnd4y3rhcADkmcitm4v7Bk03QA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 09/38] xfs: fix partially uninitialized structure in xfs_reflink_remap_extent
Date:   Fri, 24 Apr 2020 08:22:07 -0400
Message-Id: <20200424122237.9831-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122237.9831-1-sashal@kernel.org>
References: <20200424122237.9831-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit c142932c29e533ee892f87b44d8abc5719edceec ]

In the reflink extent remap function, it turns out that uirec (the block
mapping corresponding only to the part of the passed-in mapping that got
unmapped) was not fully initialized.  Specifically, br_state was not
being copied from the passed-in struct to the uirec.  This could lead to
unpredictable results such as the reflinked mapping being marked
unwritten in the destination file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_reflink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b0ce04ffd3cd2..107bf2a2f3448 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1051,6 +1051,7 @@ xfs_reflink_remap_extent(
 		uirec.br_startblock = irec->br_startblock + rlen;
 		uirec.br_startoff = irec->br_startoff + rlen;
 		uirec.br_blockcount = unmap_len - rlen;
+		uirec.br_state = irec->br_state;
 		unmap_len = rlen;
 
 		/* If this isn't a real mapping, we're done. */
-- 
2.20.1

