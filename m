Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278B8C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10E0C61008
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbhHQXoJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:44:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236443AbhHQXoI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:44:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E677161008;
        Tue, 17 Aug 2021 23:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243815;
        bh=2wNMTLaCHwCrHQGbYSLud7eC0OEV9dXTmWT0idIcfwM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OpQPhrgepqmoW2MY6T4/FAYSM3DUqPPssUcASucK6hOENC1mYVx8C92gKek1ix3EB
         4VRbmyJH3jPjdUT8dnXI4WgEYx7lG+UY7R+inGQLBEAVEmsruXu9+BE13RIPeBJsgt
         LhdHgFsG3+MDbUyq+G3sw+Vni/q7QEthYRItUhjlAGvYyg+hyfCjAH6Gy3iOUFybM1
         CjH79MnNMOysFyAHUB69DwS2QYUMaQjGUbCmMTc6fiUFb+IFCKJGagqlxERN5vj6gG
         d5qumy3ayYU1bjk6DdYmgRgYFwN1+GpwiX0tmTSOUkUbGDpoWfpoCfwStDPNX31iU/
         9+Uid/BpAZA1A==
Subject: [PATCH 15/15] xfs: decode scrub flags in ftrace output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:43:34 -0700
Message-ID: <162924381463.761813.16823449335256904439.stgit@magnolia>
In-Reply-To: <162924373176.761813.10896002154570305865.stgit@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When using pretty-printed scrub tracepoints, decode the meaning of the
scrub flags as strings for easier reading.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 2777d882819d..e9b81b7645c1 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -79,6 +79,16 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
 	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }
 
+#define XFS_SCRUB_FLAG_STRINGS \
+	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \
+	{ XFS_SCRUB_OFLAG_CORRUPT,		"corrupt" }, \
+	{ XFS_SCRUB_OFLAG_PREEN,		"preen" }, \
+	{ XFS_SCRUB_OFLAG_XFAIL,		"xfail" }, \
+	{ XFS_SCRUB_OFLAG_XCORRUPT,		"xcorrupt" }, \
+	{ XFS_SCRUB_OFLAG_INCOMPLETE,		"incomplete" }, \
+	{ XFS_SCRUB_OFLAG_WARNING,		"warning" }, \
+	{ XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED,	"norepair" }
+
 DECLARE_EVENT_CLASS(xchk_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),
@@ -103,14 +113,14 @@ DECLARE_EVENT_CLASS(xchk_class,
 		__entry->flags = sm->sm_flags;
 		__entry->error = error;
 	),
-	TP_printk("dev %d:%d ino 0x%llx type %s agno 0x%x inum 0x%llx gen 0x%x flags 0x%x error %d",
+	TP_printk("dev %d:%d ino 0x%llx type %s agno 0x%x inum 0x%llx gen 0x%x flags (%s) error %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->agno,
 		  __entry->inum,
 		  __entry->gen,
-		  __entry->flags,
+		  __print_flags(__entry->flags, "|", XFS_SCRUB_FLAG_STRINGS),
 		  __entry->error)
 )
 #define DEFINE_SCRUB_EVENT(name) \

