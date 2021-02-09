Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFC8C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98EFB64E4F
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhBIEQy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:16:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230320AbhBIENr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:13:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A446064EC6;
        Tue,  9 Feb 2021 04:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843855;
        bh=7/HQ9xhCLOMhJSCaFz7ZOmPJ5lxK46e95CihtSZ4pbI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iBPBHK7B7ih7GguIKB2pK7l4q3cqj3b8kz+GDtLADLzGdRrq6Nva5zgGp2jP/PGRm
         bXD85E4BQjWFXUXhuVCrcqasFp74CbI22UBbe2uXuSBWROaAtsYUwQWOh8B6y+jWVB
         ZQ1XOMn46CKDykQEHTHpF0vi8gF+KE89IaSfNKiVNV59sPYAINYBPHsAsg0RNzSR9i
         J0YAM7HFm64ABFkO3hJhDUedIhq5vUlwBqO6bQvI5bPzyhHisUP1/kcZxWD8Znoh0Y
         RhxmU948tsXYORjss8xJBpelU9m2erZkH0md3AN3DaaEx/xSYwKt48gzK/3gWbiWdV
         tkaInvLXyuyEQ==
Subject: [PATCH 09/10] xfs_repair: add a testing hook for NEEDSREPAIR
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:10:55 -0800
Message-ID: <161284385516.3057868.355176047687079022.stgit@magnolia>
In-Reply-To: <161284380403.3057868.11153586180065627226.stgit@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
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
---
 repair/globals.c    |    1 +
 repair/globals.h    |    2 ++
 repair/phase1.c     |    5 +++++
 repair/xfs_repair.c |    7 +++++++
 4 files changed, 15 insertions(+)


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
diff --git a/repair/phase1.c b/repair/phase1.c
index b26d25f8..57f72cd0 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -170,5 +170,10 @@ _("Cannot disable lazy-counters on V5 fs\n"));
 	 */
 	sb_ifree = sb_icount = sb_fdblocks = sb_frextents = 0;
 
+	/* Simulate a crash after setting needsrepair. */
+	if (primary_sb_modified && add_needsrepair &&
+	    abort_after_force_needsrepair)
+		exit(55);
+
 	free(sb);
 }
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index ee377e8a..ae7106a6 100644
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
@@ -795,6 +800,8 @@ force_needsrepair(
 		error = -libxfs_bwrite(bp);
 		if (error)
 			do_log(_("couldn't force needsrepair, err=%d\n"), error);
+		if (abort_after_force_needsrepair)
+			exit(55);
 	}
 	if (bp)
 		libxfs_buf_relse(bp);

