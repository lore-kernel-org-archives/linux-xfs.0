Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D60FB29DF7
	for <xfs@oss.sgi.com>; Thu, 11 Dec 2014 11:54:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65C37AC004
	for <xfs@oss.sgi.com>; Thu, 11 Dec 2014 09:54:10 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Pr9HtJMImaarNZIT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Dec 2014 09:54:06 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBBHs5C1013989
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 11 Dec 2014 12:54:05 -0500
Message-ID: <5489DA3B.5050908@redhat.com>
Date: Thu, 11 Dec 2014 11:54:03 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: fix max block offset test
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
To: xfs-oss <xfs@oss.sgi.com>
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

Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/dinode.c b/repair/dinode.c
index 38a6562..ca57a61 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -667,7 +667,9 @@ _("inode %" PRIu64 " - bad extent overflows - start %" PRIu64 ", "
 					irec.br_startoff);
 				goto done;
 		}
-		if (irec.br_startoff >= fs_max_file_offset)  {
+		/* Ensure this extent does not extend beyond the max offset */
+		if (irec.br_startoff + irec.br_blockcount - 1 >
+							fs_max_file_offset) {
 			do_warn(
 _("inode %" PRIu64 " - extent offset too large - start %" PRIu64 ", "
   "count %" PRIu64 ", offset %" PRIu64 "\n"),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
