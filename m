Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57190 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752602AbeA3EN7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Jan 2018 23:13:59 -0500
Subject: [PATCH 7/2] mkfs: more sunit/swidth sanity checking
References: <151692412532.32390.5360363880930671862.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1c6697a8-3e71-31b5-e07d-375eb766f85c@sandeen.net>
Date: Mon, 29 Jan 2018 22:13:58 -0600
MIME-Version: 1.0
In-Reply-To: <151692412532.32390.5360363880930671862.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

This fixes 2 issues with stripe geometry validation.

# mkfs.xfs -d sunit=64,swidth=0 ...
both data sunit and data swidth options must be specified

But I did specify it, I specified 0!

So use cli_opt_set() to detect that it was specified.

But we can't allow the above configuration (in fact it causes
a % 0 later in mkfs), so catch it in the "swidth must be a
multiple of sunit" test a bit further down.

(sunit=0,swidth=0 /is/ valid, it's used to override disk
geometry if desired.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

don't mind my mkfs patch series hijacking! ;)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f527476..219b209 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2233,7 +2233,7 @@ calc_stripe_factors(
 		dsw = cli->dsw;
 
 	/* data sunit/swidth options */
-	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
+	if (cli_opt_set(&dopts, D_SUNIT) != cli_opt_set(&dopts, D_SWIDTH)) {
 		fprintf(stderr,
 _("both data sunit and data swidth options must be specified\n"));
 		usage();
@@ -2241,7 +2241,7 @@ _("both data sunit and data swidth options must be specified\n"));
 
 	/* convert dsu/dsw to dsunit/dswidth and use them from now on */
 	if (dsu || dsw) {
-		if ((dsu && !dsw) || (!dsu && dsw)) {
+		if (cli_opt_set(&dopts, D_SU) != cli_opt_set(&dopts, D_SW)) {
 			fprintf(stderr,
 _("both data su and data sw options must be specified\n"));
 			usage();
@@ -2264,7 +2264,7 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
 		dswidth = big_dswidth;
 	}
 
-	if (dsunit && (dswidth % dsunit != 0)) {
+	if (dsunit && (!dswidth || (dswidth % dsunit != 0))) {
 		fprintf(stderr,
 _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
 			dswidth, dsunit);

