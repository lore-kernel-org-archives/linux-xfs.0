Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EEmwJ5024140 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 09:48:58 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 723018F8050
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 07:50:08 -0700 (PDT)
Subject: [PATCH 01/11] xfstests: randholes: Fix two bugs
From: Alex Elder <aelder@sgi.com>
Date: Thu, 14 Oct 2010 09:49:43 -0500
Message-ID: <1287067783.2362.203.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This patch fixes two bugs in the "randholes" test program.

First, it is possible for findblock() to return -1 if the random
block number it picks is at or above the highest in-range block
that's already been selected.  But this case isn't checked and
the value is blindly used thereafter as if it were valid.  Just
exit if this ever occurs.

Second, when the "alloconly" option is is set, blocks are
preallocated in the target file rather than actually writing them.
But unlike when the blocks are written and subsequently read, the
preallocated blocks are *not* offset by the fileoffset parameter.

I'm pretty sure nobody every noticed this because the program itself
doesn't do any verification when blocks are only preallocated.  But
it's an inconsistency and I think it ought to be fixed.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 src/randholes.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: b/src/randholes.c
===================================================================
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -249,11 +249,16 @@ writeblks(char *fname, int fd)
 			fflush(stdout);
 		}
 		block = findblock();
-		offset = (__uint64_t)block * blocksize;
+		if (block < 0) {
+		    perror("findblock");
+		    exit(1);
+		}
+
+		offset = (__uint64_t) block * blocksize;
 		if (alloconly) {
                         if (test) continue;
                         
-			fl.l_start = offset;
+			fl.l_start = fileoffset + offset;
 			fl.l_len = blocksize;
 			fl.l_whence = 0;
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
