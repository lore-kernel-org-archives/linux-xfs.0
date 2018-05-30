Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33254 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754935AbeE3Dca (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 May 2018 23:32:30 -0400
Date: Tue, 29 May 2018 20:32:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_io: fix null pointer deref when complaining about scrub
 command
Message-ID: <20180530033215.GO30110@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't increment optind until we've validated that argv[optind] is a
valid scrub/repair subcommand and do not need to complain about
argv[optind].

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/scrub.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io/scrub.c b/io/scrub.c
index 604daed9..37ffe46b 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -166,12 +166,11 @@ parse_args(
 			break;
 		}
 	}
-	optind++;
-
 	if (type < 0) {
 		printf(_("Unknown type '%s'.\n"), argv[optind]);
 		return command_usage(cmdinfo);
 	}
+	optind++;
 
 	switch (d->type) {
 	case ST_INODE:
