Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49298 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbeKUI3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 03:29:08 -0500
Subject: [PATCH 09/10] fsx: clean up copy/dedupe file range support.
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Nov 2018 13:57:45 -0800
Message-ID: <154275106538.8611.5991693163854449275.stgit@magnolia>
In-Reply-To: <154275100143.8611.10235098565750994724.stgit@magnolia>
References: <154275100143.8611.10235098565750994724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

copy_file_range() needs to obey read/write constraints otherwise is
blows up when direct IO is used.

FIDEDUPERANGE has a completely screwed up API for error reporting.
The ioctl succeeds even if dedupe fails, so you have to check
every individual dedupe operations for failure. Without this, dedupe
"succeeds" on kernels filesystems that don't even support dedupe...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsx.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index ec3defad..cea765d8 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1452,7 +1452,11 @@ do_dedupe_range(unsigned offset, unsigned length, unsigned dest)
 	fdr->info[0].dest_fd = fd;
 	fdr->info[0].dest_offset = dest;
 
-	if (ioctl(fd, FIDEDUPERANGE, fdr) == -1) {
+	if (ioctl(fd, FIDEDUPERANGE, fdr) == -1 ||
+	    fdr->info[0].status < 0) {
+		if (fdr->info[0].status < 0)
+			errno = -fdr->info[0].status;
+
 		if (errno == EOPNOTSUPP || errno == ENOTTY) {
 			if (!quiet && testcalls > simulatedopcount)
 				prt("skipping unsupported dedupe range\n");
@@ -1486,6 +1490,11 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
 	loff_t o1, o2;
 	ssize_t nr;
 
+	offset -= offset % readbdy;
+	dest -= dest % writebdy;
+	if (o_direct)
+		length -= length % readbdy;
+
 	if (length == 0) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping zero length copy range\n");
