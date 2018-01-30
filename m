Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38976 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752131AbeA3DjB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jan 2018 22:39:01 -0500
Date: Mon, 29 Jan 2018 19:38:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/2] mkfs: don't call values 'illegal', they're invalid
Message-ID: <20180130033857.GM9068@magnolia>
References: <151692412532.32390.5360363880930671862.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151692412532.32390.5360363880930671862.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Specifying invalid inputs to mkfs does not break any (reasonable) laws,
so the error message should complain about invalid inputs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7c9d148..6285b24 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -911,7 +911,7 @@ illegal(
 	const char	*value,
 	const char	*opt)
 {
-	fprintf(stderr, _("Illegal value %s for -%s option\n"), value, opt);
+	fprintf(stderr, _("Invalid value %s for -%s option\n"), value, opt);
 	usage();
 }
 
@@ -1267,7 +1267,7 @@ illegal_option(
 	const char		*reason)
 {
 	fprintf(stderr,
-		_("Illegal value %s for -%c %s option. %s\n"),
+		_("Invalid value %s for -%c %s option. %s\n"),
 		value, opts->name, opts->subopts[index],
 		reason ? reason : "");
 	usage();
