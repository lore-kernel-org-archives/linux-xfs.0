Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15E2C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F68864E3E
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhBKXAo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:00:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhBKXAg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 18:00:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E4C964E56;
        Thu, 11 Feb 2021 22:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613084393;
        bh=mqUbxIPBUA/n7QCoXV1GrEjb+C10PTYhbrk4IEF2qx8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hu+8+ucd2C0tCeAQqRZGBTwH1hFoE/NRFqdDqtlrVWNYv+zMDKERAEjp39UNeeBTz
         D0zC8ObVhAw3/W8EVI5dbn8SXx1Vs71JgBM5KfEcKD6CD0aF1Iff264ll0fwAPzD7a
         4mcmZvyCkr3aN843cmn6lWvP96jgt/gABEIYhyfT49h8EynZNjVsmlvkZUCH0mWCXw
         cnye76Pe3x+Ru4Z2liQaiM4rEizeVr+EtVPkOElnohD4HnSkM4qeHFt/KPd9+iSRFd
         t9AfffHsGKAlhbDam0pQXCgmV/9Ch94lPsZ7dwWzc2dXw1mew+apaXWCwmskK2f2s9
         sgMjymZe2i4gA==
Subject: [PATCH 09/11] xfs_repair: add a testing hook for NEEDSREPAIR
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Thu, 11 Feb 2021 14:59:52 -0800
Message-ID: <161308439253.3850286.5243500865602980663.stgit@magnolia>
In-Reply-To: <161308434132.3850286.13801623440532587184.stgit@magnolia>
References: <161308434132.3850286.13801623440532587184.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Simulate a crash when anyone calls force_needsrepair.  This is a debug
knob so that we can test that the kernel won't mount after setting
needsrepair and that a re-run of xfs_repair will clear the flag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/globals.c    |    1 +
 repair/globals.h    |    2 ++
 repair/phase2.c     |    4 ++++
 repair/xfs_repair.c |    5 +++++
 4 files changed, 12 insertions(+)


diff --git a/repair/globals.c b/repair/globals.c
index 699a96ee..b0e23864 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -40,6 +40,7 @@ int	dangerously;		/* live dangerously ... fix ro mount */
 int	isa_file;
 int	zap_log;
 int	dumpcore;		/* abort, not exit on fatal errs */
+bool	abort_after_force_needsrepair;
 int	force_geo;		/* can set geo on low confidence info */
 int	assume_xfs;		/* assume we have an xfs fs */
 char	*log_name;		/* Name of log device */
diff --git a/repair/globals.h b/repair/globals.h
index 043b3e8e..9fa73b2c 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -82,6 +82,8 @@ extern int	isa_file;
 extern int	zap_log;
 extern int	dumpcore;		/* abort, not exit on fatal errs */
 extern int	force_geo;		/* can set geo on low confidence info */
+/* Abort after forcing NEEDSREPAIR to test its functionality */
+extern bool	abort_after_force_needsrepair;
 extern int	assume_xfs;		/* assume we have an xfs fs */
 extern char	*log_name;		/* Name of log device */
 extern int	log_spec;		/* Log dev specified as option */
diff --git a/repair/phase2.c b/repair/phase2.c
index 9a8d42e1..177e0831 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -183,6 +183,10 @@ upgrade_filesystem(
                         do_error(
 	_("filesystem feature upgrade failed, err=%d\n"),
                                         error);
+
+		/* Simulate a crash after setting needsrepair. */
+		if (abort_after_force_needsrepair)
+			exit(55);
         }
         if (bp)
                 libxfs_buf_relse(bp);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index a613505f..293d89b1 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -44,6 +44,7 @@ enum o_opt_nums {
 	BLOAD_LEAF_SLACK,
 	BLOAD_NODE_SLACK,
 	NOQUOTA,
+	FORCE_NEEDSREPAIR_ABORT,
 	O_MAX_OPTS,
 };
 
@@ -57,6 +58,7 @@ static char *o_opts[] = {
 	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
 	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
 	[NOQUOTA]		= "noquota",
+	[FORCE_NEEDSREPAIR_ABORT] = "debug_force_needsrepair_abort",
 	[O_MAX_OPTS]		= NULL,
 };
 
@@ -282,6 +284,9 @@ process_args(int argc, char **argv)
 		_("-o debug_bload_node_slack requires a parameter\n"));
 					bload_node_slack = (int)strtol(val, NULL, 0);
 					break;
+				case FORCE_NEEDSREPAIR_ABORT:
+					abort_after_force_needsrepair = true;
+					break;
 				case NOQUOTA:
 					quotacheck_skip();
 					break;

