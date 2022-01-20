Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59947C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345400AbiATA0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344725AbiATA0A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:26:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD60C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:26:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA112B81911
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1476C004E1;
        Thu, 20 Jan 2022 00:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638357;
        bh=/scE1ITb93n5qQB3J7QMh/JXQwz1HmPzJVz/OPmSTJk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uTMWolsppXb8QrFMyYhCtx9cq7essjEQhVk+TU3e6BQ7veW33IYdej0dlZo7yUvvi
         Bza4BMS7eLoyc10UvLS9ycnIER6PHdyxlbc2Z4NKsrfUUcwVdRg1Oy2tvNctxh7Rmi
         xI1CskbzGTYaP6ajr4HTSFBdIZGrc/fYR/1HEad90uewAeFppNiqV3l7JWjn/moiDM
         uSZ1wRH+uR3H/kMxSHhXNbq83KDrNnrWyfz2iMDcLMx0DmlLZuDfOF/UJQ9lxvQGeb
         x1c1Qi0EqTtlzGnepZK1DFLIrh8RGQsU7xL4IdWwpnobTg+AbO2vuIkUMgGEevnXFO
         sfCxa+r6FpAxA==
Subject: [PATCH 30/48] xfs: kill XFS_BTREE_MAXLEVELS
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:25:57 -0800
Message-ID: <164263835738.865554.4017087053550319195.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: bc8883eb775dd18d8b84733d8b3a3955b72d103a

Nobody uses this symbol anymore, so kill it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.h |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index e488bfcc..fdf7090c 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -92,8 +92,6 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 #define XFS_BTREE_STATS_ADD(cur, stat, val)	\
 	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
 
-#define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
-
 /*
  * The btree cursor zone hands out cursors that can handle up to this many
  * levels.  This is the known maximum for all btree types.

