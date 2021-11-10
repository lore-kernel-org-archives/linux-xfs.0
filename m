Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF08C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 01:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BF0C610F8
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 01:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhKJCBI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Nov 2021 21:01:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhKJCBH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Nov 2021 21:01:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B42B61181;
        Wed, 10 Nov 2021 01:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636509501;
        bh=C1OELFFKyU6zTcMaTb1y3N5hhpMIcrCS7xf69SVizgU=;
        h=Date:From:To:Cc:Subject:From;
        b=O9F/wwyUl9RWRvzCodO/jlIDoNU/R+lfWs7y9Uog2GAZWzfYkMqvenbAf6gT1KLTM
         JwdGE6VmqjQRjSp1NhaRqF/tc7c0LJ8CtpRtjlUo79I88mU2OjdNgW93fnistQcp7u
         Su4FOjiN/PMGHn4wCzD/kAfqR2Evsnq9GERjH2nPWLehG8hCqnVx2teGRHxekOIAVG
         laaEslPQ+v2bBmNFk6LN/hGbCytyyBo9MgXtjiqx/fJxLNDj5YDv/vmTSskbaw/MMF
         Gs4vMa2mpsm7SWCt/lkG+zxDOZuIKfiLzedA+Zg+wDqOXwjVuj8Bp8VkQeOIepcV14
         3SgMWub+GJW5Q==
Date:   Tue, 9 Nov 2021 17:58:20 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>
Subject: [PATCH] design: fix computation of buffer log item bitmap size
Message-ID: <20211110015820.GX24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Wengang Wang was trying to work through a buffer log item by consulting
the ondisk format documentation, and was confused by the formula given
in section 14.3.14 regarding the size of blf_data_map, aka the dirty
bitmap for buffer log items.  We noticed that the documentation doesn't
match what the kernel actually does, so let's fix this.

Reported-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../journaling_log.asciidoc                        |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index 1dba56e..894d3e5 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -992,7 +992,7 @@ The size of +blf_data_map+, in 32-bit words.
 This variable-sized array acts as a dirty bitmap for the logged buffer.  Each
 1 bit represents a dirty region in the buffer, and each run of 1 bits
 corresponds to a subsequent log item containing the new contents of the buffer
-area.  Each bit represents +(blf_len * 512) / (blf_map_size * NBBY)+ bytes.
+area.  Each bit represents +(blf_len * 512) / (blf_map_size * sizeof(unsigned int) * NBBY)+ bytes.
 
 [[Buffer_Data_Log_Item]]
 === Buffer Data Log Item
