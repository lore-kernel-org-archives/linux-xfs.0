Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KKewOt156178 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 15:40:59 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RttuGZkAOZP0WoGs for
	<xfs@oss.sgi.com>; Wed, 20 Jun 2012 13:40:57 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5KKevoc006852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 16:40:57 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q5KKerx5006294
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 16:40:56 -0400
Message-ID: <4FE23555.7070606@redhat.com>
Date: Wed, 20 Jun 2012 15:40:53 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_db: Fix extent record printing on big endian
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

Extent records which should have been printed as:

a.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,12,17,0]

for example, were instead being printed as:

a.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,12884910592,0,0]

in xfs_db.  It was simply mis-parsing the extent records due to wrong
#defines for big-endian machines.

It's been broken since at least xfsprogs-2.6.13, causing xfstests 021
to fail.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Why this works is, um ...left as an exercise to the reviewer for now ;)
TBH I get lost in xfs_db, and I'm not sure how endianness is handled,
but it's pretty clearly not like this!

diff --git a/db/btblock.c b/db/btblock.c
index f6e8a68..2c199b2 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -250,23 +250,12 @@ const field_t	bmapbtd_key_flds[] = {
 };
 #undef KOFF
 
-#ifndef XFS_NATIVE_HOST
-
 #define BMBT_EXNTFLAG_BITOFF	0
 #define BMBT_STARTOFF_BITOFF	(BMBT_EXNTFLAG_BITOFF + BMBT_EXNTFLAG_BITLEN)
 #define BMBT_STARTBLOCK_BITOFF	(BMBT_STARTOFF_BITOFF + BMBT_STARTOFF_BITLEN)
 #define BMBT_BLOCKCOUNT_BITOFF	\
 	(BMBT_STARTBLOCK_BITOFF + BMBT_STARTBLOCK_BITLEN)
 
-#else
-
-#define BMBT_EXNTFLAG_BITOFF	63
-#define BMBT_STARTOFF_BITOFF	(BMBT_EXNTFLAG_BITOFF - BMBT_STARTOFF_BITLEN)
-#define BMBT_STARTBLOCK_BITOFF	85 /* 128 - 43 (other 9 is in first word) */
-#define BMBT_BLOCKCOUNT_BITOFF	64 /* Start of second 64 bit container */
-
-#endif /* XFS_NATIVE_HOST */
-
 const field_t	bmapbta_rec_flds[] = {
 	{ "startoff", FLDT_CFILEOFFA, OI(BMBT_STARTOFF_BITOFF), C1, 0,
 	  TYP_ATTR },

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
