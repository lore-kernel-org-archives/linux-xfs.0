Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC69C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9086610D2
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhJNUUX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhJNUUW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADCC361027;
        Thu, 14 Oct 2021 20:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242697;
        bh=oFR0vNt729KrfKGPfT9phBpgBUVJ7TwuNcSOu3A501k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LE65kj03kPCwSLBmr7vcNjIIJASuEh/ruvs2Qdshe15EFTlUQS5Gq0RYA7uROfCq0
         B8p0qlTRrtqMqADQEYhgig/rmVA3ACatV4rIhNCP4RAn+xbOdtIX9Jm3VroSsWwZLC
         qkhLvJCBtrqLA5MYfBISwcGWEXaW5NbB57z9NjQml59JQI/8aQ6akEvqzc3LJwp5KQ
         VKSYZy03hrf3cNtNpiGovOZ2S2AgWOKmBQg3Tfhd+Uhvia0+zqhV0FsPr9GaVi2cNj
         +IZbYvpEj/lRj53ePXKQHB6N++XxrmCyleMcdwAK/S22MwwhpNG178N+7wB1q3VwS4
         qBCejj8b09TWQ==
Subject: [PATCH 15/17] xfs: kill XFS_BTREE_MAXLEVELS
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:18:17 -0700
Message-ID: <163424269738.756780.10973252654200722539.stgit@magnolia>
In-Reply-To: <163424261462.756780.16294781570977242370.stgit@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Nobody uses this symbol anymore, so kill it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.h |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index e488bfcc1fc0..fdf7090c74f4 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -92,8 +92,6 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 #define XFS_BTREE_STATS_ADD(cur, stat, val)	\
 	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
 
-#define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
-
 /*
  * The btree cursor zone hands out cursors that can handle up to this many
  * levels.  This is the known maximum for all btree types.

