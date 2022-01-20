Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537C8C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345095AbiATATO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:19:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57480 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345061AbiATATO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:19:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDE7861506
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32212C004E1;
        Thu, 20 Jan 2022 00:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637953;
        bh=TWOw9M4Kcvvpw2DQ+GNR1cnlFYnJX1WF5J3B2SGkXpg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SIe8bqzII2kwgORK2vC51n2NDH/+tP1qimKlh+wigJLP+Fi4/451NckCuMyWTKH/h
         xjHeGzlbjWUDCMVSo2hhO3wmjuArZkXGPykeZm4HjJ6x4cvw3QIoPmGszZgg8Fpm/u
         bWiTnqhcyQuFElcrbIHA8LxOd6qiCcIntdW1tub+TiG48MmxtTfsuD09Gkh2XdXZ2L
         rx0REP4q+lLvrVyMDeRIFvjp3LZKPiM/iVdy3V39sDkIMTihykoc7IGL54y6Xea+Jd
         0QpbvS9WMNXsEzIGzrxEE4ioHRAa4hZ5LhwkoDeGC9nJUm3urezYussjB7OCj+UF3r
         N9eK+wxkyLFYw==
Subject: [PATCH 20/45] xfs: resolve fork names in trace output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:19:12 -0800
Message-ID: <164263795293.860211.15810880600714095500.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: f93f85f77aa80f3e4d5bada01248c98da32933c5

Emit whichfork values as text strings in the ftrace output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_types.h |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 0870ef6f..b6da06b4 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -87,6 +87,11 @@ typedef void *		xfs_failaddr_t;
 #define	XFS_ATTR_FORK	1
 #define	XFS_COW_FORK	2
 
+#define XFS_WHICHFORK_STRINGS \
+	{ XFS_DATA_FORK, 	"data" }, \
+	{ XFS_ATTR_FORK,	"attr" }, \
+	{ XFS_COW_FORK,		"cow" }
+
 /*
  * Min numbers of data/attr fork btree root pointers.
  */

