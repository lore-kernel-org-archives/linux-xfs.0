Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 86B6E7F55
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 14:25:08 -0600 (CST)
Received: from eagdhcp-232-183.americas.sgi.com
	(eagdhcp-232-183.americas.sgi.com [128.162.232.183])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04139AC005
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 12:25:04 -0800 (PST)
Received: from eagdhcp-232-183.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-183.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s1DKP6Pq005446
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 14:25:06 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-183.americas.sgi.com)
Message-Id: <20140213202555.996721782@sgi.com>
Date: Thu, 13 Feb 2014 14:25:36 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v3] xfs_db: fix the setting of unaligned directory fields
References: <20140210230923.268327906@sgi.com>
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
fields are difficult on both big and little endian machines.
The setting of extentflag was completely broken.

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

Since the output fields and the lengths are not aligned to a byte,
setbitval requires them to be entered in big endian and properly
byte/nibble shifted. The extentflag output was aligned to a byte
but was not shifted correctly.

Convert the input to big endian on little endian machines and
nibble/byte shift on all platforms so setbitval can set the bits
correctly.

Clean some whitespace while in the setbitbal() function.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
v3:
 Hex input is not a number.
 More ten year old white space cleanups.

v2:
 Ignore extra characters in input.
 Fix hash input if still used as an integer input.
  It was broken on big endian, but someone may use this input in a
  little endian script.
 Add documentation.
 Did more clean up.

 db/bit.c   |   84 ++++++++++++------------------
 db/write.c |  166 ++++++++++++++++++++++++++++++++++++++++---------------------
 2 files changed, 143 insertions(+), 107 deletions(-)

Index: b/db/bit.c
===================================================================
--- a/db/bit.c
+++ b/db/bit.c
@@ -128,57 +128,41 @@ getbitval(
 	return rval;
 }
 
+/*
+ * The input data can be 8, 16, 32, and 64 sized numeric values
+ * aligned on a byte boundry, or odd sized numbers stored on odd
+ * aligned offset (for example the bmbt fields).
+ *
+ * The input data sent to this routine has been converted to big endian
+ * and has been adjusted in the array so that the first input bit is to
+ * be written in the first bit in the output.
+ *
+ * If the field length and the output buffer are byte aligned, then use
+ * memcpy from the input to the output, but if either entries are not byte
+ * aligned, then loop over the entire bit range reading the input value
+ * and set/clear the matching bit in the output.
+ *
+ * example when ibuf is not multiple of a byte in length:
+ *
+ * ibuf:	| BBBBBBBB | bbbxxxxx |
+ *		  \\\\\\\\--\\\\
+ * obuf+bitoff:	| xBBBBBBB | Bbbbxxxx |
+ *
+ */
 void
 setbitval(
-	void *obuf,      /* buffer to write into */
-	int bitoff,      /* bit offset of where to write */
-	int nbits,       /* number of bits to write */
-	void *ibuf)      /* source bits */
+	void	*obuf,		/* start of buffer to write into */
+	int	bitoff,		/* bit offset into the output buffer */
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
+	char	*in = ibuf;
+	char	*out = obuf;
+	int	bit;
+
+	if (bitoff % NBBY || nbits % NBBY) {
+		for (bit=0; bit < nbits; bit++)
+			setbit(out, bit + bitoff, getbit(in, bit));
+	} else
+		memcpy(out + byteize(bitoff), in, byteize(nbits));
 }
Index: b/db/write.c
===================================================================
--- a/db/write.c
+++ b/db/write.c
@@ -439,55 +439,78 @@ convert_oct(
 
 #define NYBBLE(x) (isdigit(x)?(x-'0'):(tolower(x)-'a'+0xa))
 
+/*
+ * convert_arg allow input in the following forms:
+ * A string ("ABTB") whose ASCII value is placed in an array in the order
+ * matching the input.
+ *
+ * An even number of hex numbers. If the length is greater than
+ * 64 bits, then the output is an array of bytes whose top nibble
+ * is the first hex digit in the input, the lower nibble is the second
+ * hex digit in the input. UUID entries are entered in this manner.
+ * If the length is 64 bits or less, then treat the hex input characters
+ * as a number used with setbitval().
+ *
+ * A decimal or hexadecimal integer to be used with setbitval().
+ *	---
+ * Numbers that will use setbitval() are in big endian format and
+ * are adjusted in the array so that the first input bit is to be
+ * be written to the first bit in the output.
+ */
 static char *
 convert_arg(
-	char *arg,
-	int  bit_length)
+	char		*arg,
+	int		bit_length)
 {
-	int i;
-	static char *buf = NULL;
-	char *rbuf;
-	long long *value;
-	int alloc_size;
-	char *ostr;
-	int octval, ret;
+	int		i;
+	int		alloc_size;
+	int		octval;
+	int		offset;
+	int		ret;
+	static char	*buf = NULL;
+	char		*endp;
+	char		*rbuf;
+	char		*ostr;
+	__u64		*value;
+	__u64		val = 0;
 
 	if (bit_length <= 64)
 		alloc_size = 8;
 	else
-		alloc_size = (bit_length+7)/8;
+		alloc_size = (bit_length + 7)/8;
 
 	buf = xrealloc(buf, alloc_size);
 	memset(buf, 0, alloc_size);
-	value = (long long *)buf;
+	value = (__u64 *)buf;
 	rbuf = buf;
 
 	if (*arg == '\"') {
-		/* handle strings */
+		/* input a string and output ASCII array of characters */
 
 		/* zap closing quote if there is one */
-		if ((ostr = strrchr(arg+1, '\"')) != NULL)
+		if ((ostr = strrchr(arg + 1, '\"')) != NULL)
 			*ostr = '\0';
 
-		ostr = arg+1;
+		ostr = arg + 1;
 		for (i = 0; i < alloc_size; i++) {
 			if (!*ostr)
 				break;
 
-			/* do octal */
+			/* do octal conversion */
 			if (*ostr == '\\') {
-				if (*(ostr+1) >= '0' || *(ostr+1) <= '7') {
-					ret = convert_oct(ostr+1, &octval);
+				if (*(ostr + 1) >= '0' || *(ostr + 1) <= '7') {
+					ret = convert_oct(ostr + 1, &octval);
 					*rbuf++ = octval;
-					ostr += ret+1;
+					ostr += ret + 1;
 					continue;
 				}
 			}
 			*rbuf++ = *ostr++;
 		}
-
 		return buf;
-	} else if (arg[0] == '#' || ((arg[0] != '-') && strchr(arg,'-'))) {
+	}
+
+	if (arg[0] == '#' || ((arg[0] != '-') && strchr(arg,'-'))) {
 		/*
 		 * handle hex blocks ie
 		 *    #00112233445566778899aabbccddeeff
@@ -496,48 +519,77 @@ convert_arg(
 		 *
 		 * (but if it starts with "-" assume it's just an integer)
 		 */
-		int bytes=bit_length/8;
+		int bytes = bit_length / NBBY;
+
+		/* is this an array of hec numbers? */
+		if (bit_length % NBBY)
+			return NULL;
 
 		/* skip leading hash */
-		if (*arg=='#') arg++;
+		if (*arg == '#') arg++;
 
 		while (*arg && bytes--) {
-		    /* skip hypens */
-		    while (*arg=='-') arg++;
+			/* skip hypens */
+			while (*arg == '-') arg++;
 
-		    /* get first nybble */
-		    if (!isxdigit((int)*arg)) return NULL;
-		    *rbuf=NYBBLE((int)*arg)<<4;
-		    arg++;
-
-		    /* skip more hyphens */
-		    while (*arg=='-') arg++;
-
-		    /* get second nybble */
-		    if (!isxdigit((int)*arg)) return NULL;
-		    *rbuf++|=NYBBLE((int)*arg);
-		    arg++;
+			/* get first nybble */
+			if (!isxdigit((int)*arg))
+				return NULL;
+			*rbuf = NYBBLE((int)*arg) << 4;
+			arg++;
+
+			/* skip more hyphens */
+			while (*arg == '-')
+				arg++;
+
+			/* get second nybble */
+			if (!isxdigit((int)*arg))
+				return NULL;
+			*rbuf++ |= NYBBLE((int)*arg);
+			arg++;
 		}
-		if (bytes<0&&*arg) return NULL;
+		if (bytes < 0 && *arg)
+			return NULL;
+
 		return buf;
-	} else {
-		/*
-		 * handle integers
-		 */
-		*value = strtoll(arg, NULL, 0);
+	} 
 
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
-		return rbuf;
-	}
+	/* handle decimal / hexadecimal integers */
+	val = strtoll(arg, &endp, 0);
+	/* return if not a clean number */
+	if (*endp != '\0')
+		return NULL;
+
+	/* Is this value valid for the bit length? */
+	if ((val >> bit_length) > 0)
+		return NULL;
+	/*
+	 * If the length of the field is not a multiple of a byte, push
+	 * the bits up in the field, so the most signicant field bit is
+	 * the most significant bit in the byte:
+	 *
+	 * before:
+	 * val  |----|----|----|----|----|--MM|mmmm|llll|
+	 * after
+	 * val  |----|----|----|----|----|MMmm|mmll|ll00|
+	 */
+	offset = bit_length % NBBY;
+	if (offset)
+		val <<= (NBBY - offset);
+
+	/*
+	 * convert to big endian and copy into the array
+	 * rbuf |----|----|----|----|----|MMmm|mmll|ll00|
+	 */
+	*value = cpu_to_be64(val);
+
+	/*
+	 * Align the array to point to the field in the array.
+	 *  rbuf  = |MMmm|mmll|ll00|
+	 */
+	offset = sizeof(__be64) - 1 - ((bit_length - 1)/ sizeof(__be64));
+	rbuf += offset;
+	return rbuf;
 }
 
 
@@ -550,9 +602,9 @@ write_struct(
 {
 	const ftattr_t	*fa;
 	flist_t		*fl;
-	flist_t         *sfl;
-	int             bit_length;
-	char            *buf;
+	flist_t		*sfl;
+	int		bit_length;
+	char		*buf;
 	int		parentoffset;
 
 	if (argc != 2) {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
