Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54006 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752200AbeA3Dif (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jan 2018 22:38:35 -0500
Date: Mon, 29 Jan 2018 19:38:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/2] mkfs: don't crash on dswidth overflow
Message-ID: <20180130033830.GL9068@magnolia>
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

I ran mkfs.xfs -d su=1048576,sw=$((18 * 1048576)), forgetting that sw
takes a multiple of su (unlike swidth which takes any space unit).  I
was surprised when we hit a floating point exception, which I traced
back to an integer overflow when we calculate swidth from dsw.

So, do the 64-bit multiplication so we can detect the overflow and
complain about it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5f1ac9f..7c9d148 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2211,6 +2211,7 @@ calc_stripe_factors(
 	struct cli_params	*cli,
 	struct fs_topology	*ft)
 {
+	long long int	big_dswidth;
 	int		dsunit = 0;
 	int		dswidth = 0;
 	int		lsunit = 0;
@@ -2251,7 +2252,14 @@ _("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
 		}
 
 		dsunit  = (int)BTOBBT(dsu);
-		dswidth = dsunit * dsw;
+		big_dswidth = (long long int)dsunit * dsw;
+		if (big_dswidth > INT_MAX) {
+			fprintf(stderr,
+_("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
+				big_dswidth, dsunit);
+			usage();
+		}
+		dswidth = big_dswidth;
 	}
 
 	if (dsunit && (dswidth % dsunit != 0)) {
