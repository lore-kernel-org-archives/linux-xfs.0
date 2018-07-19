Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48540 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727615AbeGSWIV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 18:08:21 -0400
From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] mkfs: avoid divide-by-zero when hardware reports optimal i/o
 size as 0
Message-ID: <6f62dbc6-f516-e8b5-1f08-6be227a61219@suse.com>
Date: Thu, 19 Jul 2018 17:23:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>

Commit 051b4e37f5e (mkfs: factor AG alignment) factored out the
AG alignment code into a separate function.  It got rid of
redundant checks for dswidth != 0 since calc_stripe_factors was
supposed to guarantee that if dsunit is non-zero dswidth will be
as well.  Unfortunately, there's hardware out there that reports its
optimal i/o size as larger than the maximum i/o size, which the kernel
treats as broken and zeros out the optimal i/o size.  We'll accept
the multi-sector dsunit but have a zero dswidth and hit a divide-by-zero
in align_ag_geometry.

To resolve this we can check the topology before consuming it, default
to using the stripe unit as the stripe width, and warn the user about it.

Fixes: 051b4e37f5e (mkfs: factor AG alignment)
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 mkfs/xfs_mkfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a135e06e..35542e57 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2295,6 +2295,12 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
 	if (!dsunit) {
 		dsunit = ft->dsunit;
 		dswidth = ft->dswidth;
+		if (dsunit && dswidth == 0) {
+			fprintf(stderr,
+_("%s: Volume reports stripe unit of %d bytes but stripe width of 0.  Using stripe width of %d bytes, which may not be optimal.\n"),
+				progname, dsunit << 9, dsunit << 9);
+			dswidth = dsunit;
+		}
 		use_dev = true;
 	} else {
 		/* check and warn is alignment is sub-optimal */
-- 
2.16.4


