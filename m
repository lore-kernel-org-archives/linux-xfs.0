Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A5B5F29E02
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 22:19:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 83D8E8F8039
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 20:19:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CUMJJaI5CK7uPAEa for
	<xfs@oss.sgi.com>; Fri, 04 Oct 2013 20:19:41 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r953JeMK019227
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 4 Oct 2013 23:19:41 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r952K3Qo020421
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 4 Oct 2013 22:20:04 -0400
Message-ID: <524F7753.8050801@redhat.com>
Date: Fri, 04 Oct 2013 21:20:03 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: fix crc32 build on big endian
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

While kernelspace can test #ifdef __LITTLE_ENDIAN, this
doesn't work in userspace.  __LITTLE_ENDIAN is defined -
as is __BIG_ENDIAN.

So we build on all boxes as __LITTLE_ENDIAN, and the
self-test (thankfully!) fails on big endian boxes.

Fix this by testing __BYTE_ORDER values.

And add an else which should never be hit, but just in case...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/crc32.c b/libxfs/crc32.c
index 1c0d958..0f847d2 100644
--- a/libxfs/crc32.c
+++ b/libxfs/crc32.c
@@ -63,18 +63,20 @@ typedef __u32	u64;
 static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
-# ifdef __LITTLE_ENDIAN
+#if __BYTE_ORDER == __LITTLE_ENDIAN
 #  define DO_CRC(x) crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8)
 #  define DO_CRC4 (t3[(q) & 255] ^ t2[(q >> 8) & 255] ^ \
 		   t1[(q >> 16) & 255] ^ t0[(q >> 24) & 255])
 #  define DO_CRC8 (t7[(q) & 255] ^ t6[(q >> 8) & 255] ^ \
 		   t5[(q >> 16) & 255] ^ t4[(q >> 24) & 255])
-# else
+# elif __BYTE_ORDER == __BIG_ENDIAN
 #  define DO_CRC(x) crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
 #  define DO_CRC4 (t0[(q) & 255] ^ t1[(q >> 8) & 255] ^ \
 		   t2[(q >> 16) & 255] ^ t3[(q >> 24) & 255])
 #  define DO_CRC8 (t4[(q) & 255] ^ t5[(q >> 8) & 255] ^ \
 		   t6[(q >> 16) & 255] ^ t7[(q >> 24) & 255])
+# else
+#  error What endian are you?
 # endif
 	const u32 *b;
 	size_t    rem_len;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
