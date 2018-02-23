Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53300 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751381AbeBWQWb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Feb 2018 11:22:31 -0500
Date: Fri, 23 Feb 2018 08:22:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] fsstress: avoid infinite loops in clonerange_f
Message-ID: <20180223162224.GD14582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: Luis Henriques <lhenriques@suse.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Evidently ceph will report a 4M blocksize, which trips clonerange_f's
clumsy attempt to avoid reflinking an extent on top of itself.  The
original code assumed that "pick a random destination up to 1MB past the
end of the file" would suffice, but that clearly won't with a 4M
blocksize.  Instead, we'll change it to 1024*blksize.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Tested-by: Luis Henriques <lhenriques@suse.com>
---
 ltp/fsstress.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 935f5de..e107099 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2222,6 +2222,7 @@ clonerange_f(
 	off64_t			lr;
 	off64_t			off1;
 	off64_t			off2;
+	off64_t			max_off2;
 	size_t			len;
 	int			v1;
 	int			v2;
@@ -2305,9 +2306,10 @@ clonerange_f(
 	 * If srcfile == destfile, randomly generate destination ranges
 	 * until we find one that doesn't overlap the source range.
 	 */
+	max_off2 = MIN(stat2.st_size + (1024ULL * stat2.st_blksize), MAXFSIZE);
 	do {
 		lr = ((int64_t)random() << 32) + random();
-		off2 = (off64_t)(lr % MIN(stat2.st_size + (1024 * 1024), MAXFSIZE));
+		off2 = (off64_t)(lr % max_off2);
 		off2 %= maxfsize;
 		off2 &= ~(stat2.st_blksize - 1);
 	} while (stat1.st_ino == stat2.st_ino && llabs(off2 - off1) < len);
