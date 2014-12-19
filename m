Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A967C7F3F
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 13:58:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A0F88F8050
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 11:58:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 2SEccg2nLUwJBoPb for <xfs@oss.sgi.com>;
	Fri, 19 Dec 2014 11:58:29 -0800 (PST)
Message-ID: <54948362.9070406@sandeen.net>
Date: Fri, 19 Dec 2014 13:58:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs_repair: fix max block offset test
References: <5489DA3B.5050908@redhat.com>
In-Reply-To: <5489DA3B.5050908@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>
Cc: Eryu Guan <eguan@redhat.com>

Eryu pointed out that in fstest xfs/071, we find corruption
reported at the end.  This test attempts to do IO at the
maximum possible offsets, and repair yields:

inode 1027 - extent offset too large - start 70, count 1, offset 2251799813685247
correcting nextents for inode 1027
bad data fork in inode 1027
would have cleared inode 1027

Repair is complaining that an extent *starts* at the maximum
block, but AFAICT, starting there is just fine, as long as
we also end there.  i.e. a one-block extent at the limit
is just fine.

So change the xfs_repair test to allow this situation.

Also, the warning text is a bit unclear, mixing in the physical
block w/ the logical block... rearrange that a little to make
it obvious.

Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Update the warning text

diff --git a/repair/dinode.c b/repair/dinode.c
index 38a6562..59824ec 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -667,12 +667,14 @@ _("inode %" PRIu64 " - bad extent overflows - start %" PRIu64 ", "
 					irec.br_startoff);
 				goto done;
 		}
-		if (irec.br_startoff >= fs_max_file_offset)  {
+		/* Ensure this extent does not extend beyond the max offset */
+		if (irec.br_startoff + irec.br_blockcount - 1 >
+							fs_max_file_offset) {
 			do_warn(
-_("inode %" PRIu64 " - extent offset too large - start %" PRIu64 ", "
-  "count %" PRIu64 ", offset %" PRIu64 "\n"),
-				ino, irec.br_startblock, irec.br_blockcount,
-				irec.br_startoff);
+_("inode %" PRIu64 " - extent exceeds max offset - start %" PRIu64 ", "
+  "count %" PRIu64 ", physical block %" PRIu64 "\n"),
+				ino, irec.br_startoff, irec.br_blockcount,
+				irec.br_startblock);
 			goto done;
 		}
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
