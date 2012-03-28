Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2SKZ6KT188716 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 15:35:07 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gC6v4CZXbd8obpEk for
	<xfs@oss.sgi.com>; Wed, 28 Mar 2012 13:35:05 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q2SKZ5dS021330
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 16:35:05 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q2SKZ4R8000807
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 16:35:04 -0400
Message-ID: <4F7375F7.5090305@redhat.com>
Date: Wed, 28 Mar 2012 15:35:03 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] mkfs.xfs: print std info if agcount makes agsize out of bounds
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
To: xfs-oss <xfs@oss.sgi.com>

When specifying a too-small agcount with stripe geometry,
mkfs.xfs can fail with a somewhat unexpected message:

$ mkfs.xfs -f -d file,name=fsfile,size=9764864000b,agcount=31,su=512k,sw=20
Allocation group size (314995613) is not a multiple of the stripe unit (128)

This strikes me as especially odd because normally, mkfs.xfs
tries to fix up the agsize to be a stripe multiple.  The only way
we get to the above error message is if ag _size_ is out of bounds;
exiting with an error about alignment rather than about size
seems odd.

Maybe below is too clever, but if by the time we've decided that
agsize is out of bounds after rounding it both up and down,
as necessary, to get to a stripe-width multiple, calling
validate_ag_geometry() will give us the same standard message as
if we had specified no stripe geometry:

$ mkfs/mkfs.xfs -f -d file,name=fsfile,size=9764864000b,agcount=31,su=512k,sw=20
agsize (314995613b) too big, maximum is 268435455 blocks
Usage: mkfs.xfs
...

$ mkfs/mkfs.xfs -f -d file,name=fsfile,size=9764864000b,agcount=31
agsize (314995613b) too big, maximum is 268435455 blocks
Usage: mkfs.xfs
...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5445b6f..1f829c5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2174,9 +2174,12 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 				if (nodsflag) {
 					dsunit = dswidth = 0;
 				} else {
-					fprintf(stderr,
-_("Allocation group size (%lld) is not a multiple of the stripe unit (%d)\n"),
-						(long long)agsize, dsunit);
+					/*
+					 * agsize is out of bounds, this will
+					 * print nice details & exit.
+					 */
+					validate_ag_geometry(blocklog, dblocks,
+							    agsize, agcount);
 					exit(1);
 				}
 			}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
