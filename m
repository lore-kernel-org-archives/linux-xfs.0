Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 119B329DF8
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 15:04:45 -0600 (CST)
Received: from eagdhcp-232-208.americas.sgi.com
	(eagdhcp-232-208.americas.sgi.com [128.162.232.208])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9D648F8035
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 13:04:41 -0800 (PST)
Received: from eagdhcp-232-208.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-208.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s17L4iej003119
	for <xfs@oss.sgi.com>; Fri, 7 Feb 2014 15:04:44 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-208.americas.sgi.com)
Message-Id: <20140207210348.249387765@sgi.com>
Date: Fri, 07 Feb 2014 16:03:42 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs_db: fix the setting of unaligned directory fields
Content-Disposition: inline; filename=xfs_db-fix-dir-settings.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Setting the directory startoff, startblock, and blockcount
bit fields is difficult on both big and little endian machines.
The setting of extentflag bit field was completely broken.

big endian test:
xfs_db> write u.bmx[0].startblock 12
u.bmx[0].startblock = 0
xfs_db> write u.bmx[0].startblock 0xc0000
u.bmx[0].startblock = 192

little endian test:
xfs_db> write u.bmx[0].startblock 12
u.bmx[0].startblock = 211106232532992
xfs_db> write u.bmx[0].startblock 0xc0000
u.bmx[0].startblock = 3221225472

Since these output fields and the lengths are not aligned to a byte,
setbitval requires them to be entered in big endian and properly
byte/nibble shifted. The extentflag out field is aligned to a byte
boundary but was not shifted correctly.

Convert the input to big endian on little endian machines and
bit/byte shift on all platforms so setbitval can set the bits
correctly. As noted in the comment, the bit shift must be done
before doing the endian conversion or end result will be shifted
in the wrong direction..

Clean some whitespace while in the setbitbal() function.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 db/bit.c   |   68 ++++++++++++++++---------------------------------------------
 db/write.c |   25 +++++++++++++---------
 2 files changed, 33 insertions(+), 60 deletions(-)

Index: b/db/bit.c
===================================================================
--- a/db/bit.c
+++ b/db/bit.c
@@ -130,55 +130,23 @@ getbitval(
 
 void
 setbitval(
-	void *obuf,      /* buffer to write into */
-	int bitoff,      /* bit offset of where to write */
-	int nbits,       /* number of bits to write */
-	void *ibuf)      /* source bits */
+	void	*obuf,		/* buffer to write into */
+	int	bitoff,		/* bit offset of where to write */
+	int	nbits,		/* number of bits to write */
+	void	*ibuf)		/* source bits */
 {
-	char    *in           = (char *)ibuf;
-	char    *out          = (char *)obuf;
-
-	int     bit;
-
-#if BYTE_ORDER == LITTLE_ENDIAN
-	int     big           = 0;
-#else
-	int     big           = 1;
-#endif
-
-	/* only need to swap LE integers */
-	if (big || (nbits!=16 && nbits!=32 && nbits!=64) ) {
-		/* We don't have type info, so we can only assume
-		 * that 2,4 & 8 byte values are integers. sigh.
-		 */
-
-		/* byte aligned ? */
-		if (bitoff%NBBY) {
-			/* no - bit copy */
-			for (bit=0; bit<nbits; bit++)
-				setbit(out, bit+bitoff, getbit(in, bit));
-		} else {
-			/* yes - byte copy */
-			memcpy(out+byteize(bitoff), in, byteize(nbits));
-		}
-
-	} else {
-		int     ibit;
-		int     obit;
-
-		/* we need to endian swap this value */
-
-		out+=byteize(bitoff);
-		obit=bitoffs(bitoff);
-
-		ibit=nbits-NBBY;
-
-		for (bit=0; bit<nbits; bit++) {
-			setbit(out, bit+obit, getbit(in, ibit));
-			if (ibit%NBBY==NBBY-1)
-				ibit-=NBBY*2-1;
-			else
-				ibit++;
-		}
-	}
+	char	*in	= (char *)ibuf;
+	char	*out	= (char *)obuf;
+	int	bit;
+
+	/*
+	 * The input data is in big endian and aligned to the bit length.
+	 * Set the individual bits if the destination field or the source
+	 * end are not aligned.
+	 */
+	if (bitoff % NBBY || nbits % NBBY) {
+		for (bit=0; bit<nbits; bit++)
+			setbit(out, bit+bitoff, getbit(in, bit));
+	} else
+		memcpy(out+byteize(bitoff), in, byteize(nbits));
 }
Index: b/db/write.c
===================================================================
--- a/db/write.c
+++ b/db/write.c
@@ -451,6 +451,7 @@ convert_arg(
 	int alloc_size;
 	char *ostr;
 	int octval, ret;
+	int offadj;
 
 	if (bit_length <= 64)
 		alloc_size = 8;
@@ -526,16 +527,20 @@ convert_arg(
 		 */
 		*value = strtoll(arg, NULL, 0);
 
-#if __BYTE_ORDER == BIG_ENDIAN
-		/* hackery for big endian */
-		if (bit_length <= 8) {
-			rbuf += 7;
-		} else if (bit_length <= 16) {
-			rbuf += 6;
-		} else if (bit_length <= 32) {
-			rbuf += 4;
-		}
-#endif
+		/*
+		 * Align the significant bits in the result length.
+		 * Must be done before the endian conversion.
+		 */
+		offadj = bit_length % NBBY;
+		if (offadj)
+			*value <<= (8 - offadj);
+
+		/* convert to big endian */
+		*value = cpu_to_be64(*value);
+
+		/* Align the signifant bytes in the result length. */
+		offadj = 7 - (bit_length - 1)/ 8;
+		rbuf += offadj;
 		return rbuf;
 	}
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
