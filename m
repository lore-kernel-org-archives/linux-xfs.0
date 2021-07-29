Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825E6C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6409060F5E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhG2Sp0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229896AbhG2SpZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:45:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C79960249;
        Thu, 29 Jul 2021 18:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584322;
        bh=xXFkHMZ2K+dnFzqj52bmi7fmJBfhHjzjrr+o9UdaQuk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RhlVBTcDHROAvURgRV7yfOeLrRoSqlMxuB845wBWfWKsAFkYOw9UYDoGrL7jbYz9c
         7kDntOvCEtKIC+xhOMVN9IJQX3vDsFUltjij2VWvU3OXSaFsUgo2X3d4GTSbMDKkHi
         yKyECGSCNlMdq/x6fHmVDBlK529jBcJ095p5v40Kl8gsikJcAYTVZAc+uJbsiJdhYO
         xSYnfHfNf2H4gIlDyruXYif+5GRzme/6w4PI2QkVzhnosdVrYpdusJQIeQi0cu6Yj0
         FHCunxGCpS/VSem4Un8ujN9GbCXYPDbPXlkcy71Bc3ZomcOq5DMFL0B1U/s1tUGYwA
         GZrg9XHnhxtLQ==
Subject: [PATCH 16/20] xfs: queue inodegc worker immediately on backlog
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:45:21 -0700
Message-ID: <162758432174.332903.11780876054270545225.stgit@magnolia>
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If an AG has hit the maximum number of inodes that it can queue for
inactivation, schedule the worker immediately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    6 ++++++
 fs/xfs/xfs_trace.h  |    1 +
 2 files changed, 7 insertions(+)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 17cc2ac76809..513d380b8b55 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -419,6 +419,12 @@ xfs_gc_delay_ms(
 					__return_address);
 			return 0;
 		}
+
+		/* Kick the worker immediately if we've hit the max backlog. */
+		if (pag->pag_ici_needs_inactive > XFS_INODEGC_MAX_BACKLOG) {
+			trace_xfs_inodegc_delay_backlog(pag);
+			return 0;
+		}
 		break;
 	default:
 		ASSERT(0);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 43fb699e6aaf..26fc5cf08d5b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -430,6 +430,7 @@ DEFINE_EVENT(xfs_inodegc_backlog_class, name,	\
 	TP_PROTO(struct xfs_perag *pag),	\
 	TP_ARGS(pag))
 DEFINE_INODEGC_BACKLOG_EVENT(xfs_inodegc_throttle_backlog);
+DEFINE_INODEGC_BACKLOG_EVENT(xfs_inodegc_delay_backlog);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),

