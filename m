Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55834 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbeF0CsH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 22:48:07 -0400
Subject: [PATCH 01/10] libxfs: remove crc32 functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 26 Jun 2018 19:47:51 -0700
Message-ID: <153006767107.20121.10431562348589361605.stgit@magnolia>
In-Reply-To: <153006766483.20121.9285982017465570544.stgit@magnolia>
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

XFS uses crc32c, not crc32.  Remove the unnecessary crc32 code, which
decreases binary size by the 8K crc32 table.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 include/libxfs.h        |    3 
 libxfs/crc32.c          |  373 +++++++++++++----------------------------------
 libxfs/crc32defs.h      |   57 -------
 libxfs/gen_crc32table.c |   64 --------
 libxfs/libxfs_priv.h    |    3 
 5 files changed, 102 insertions(+), 398 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index fbaae089..109866de 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -43,10 +43,7 @@
 
 
 /* CRC stuff, buffer API dependent on it */
-extern uint32_t crc32_le(uint32_t crc, unsigned char const *p, size_t len);
 extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
-
-#define crc32(c,p,l)	crc32_le((c),(unsigned char const *)(p),(l))
 #define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
 
 #include "xfs_cksum.h"
diff --git a/libxfs/crc32.c b/libxfs/crc32.c
index b25b0a9c..a80a0c54 100644
--- a/libxfs/crc32.c
+++ b/libxfs/crc32.c
@@ -49,15 +49,9 @@ typedef __u32	u64;
 # define tole(x) (x)
 #endif
 
-#if CRC_BE_BITS > 8
-# define tobe(x) ((__force u32) __constant_cpu_to_be32(x))
-#else
-# define tobe(x) (x)
-#endif
-
 #include "crc32table.h"
 
-#if CRC_LE_BITS > 8 || CRC_BE_BITS > 8
+#if CRC_LE_BITS > 8
 
 /* implements slicing-by-4 or slicing-by-8 algorithm */
 static inline u32
@@ -174,20 +168,11 @@ static inline u32 __pure crc32_le_generic(u32 crc, unsigned char const *p,
 }
 
 #if CRC_LE_BITS == 1
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
-{
-	return crc32_le_generic(crc, p, len, NULL, CRCPOLY_LE);
-}
 u32 __pure crc32c_le(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len, NULL, CRC32C_POLY_LE);
 }
 #else
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
-{
-	return crc32_le_generic(crc, p, len,
-			(const u32 (*)[256])crc32table_le, CRCPOLY_LE);
-}
 u32 __pure crc32c_le(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len,
@@ -720,211 +705,109 @@ static struct crc_test {
 	u32 crc;	/* random starting crc */
 	u32 start;	/* random 6 bit offset in buf */
 	u32 length;	/* random 11 bit length of test */
-	u32 crc_le;	/* expected crc32_le result */
-	u32 crc_be;	/* expected crc32_be result */
 	u32 crc32c_le;	/* expected crc32c_le result */
 } test[] =
 {
-	{0x674bf11d, 0x00000038, 0x00000542, 0x0af6d466, 0xd8b6e4c1,
-	 0xf6e93d6c},
-	{0x35c672c6, 0x0000003a, 0x000001aa, 0xc6d3dfba, 0x28aaf3ad,
-	 0x0fe92aca},
-	{0x496da28e, 0x00000039, 0x000005af, 0xd933660f, 0x5d57e81f,
-	 0x52e1ebb8},
-	{0x09a9b90e, 0x00000027, 0x000001f8, 0xb45fe007, 0xf45fca9a,
-	 0x0798af9a},
-	{0xdc97e5a9, 0x00000025, 0x000003b6, 0xf81a3562, 0xe0126ba2,
-	 0x18eb3152},
-	{0x47c58900, 0x0000000a, 0x000000b9, 0x8e58eccf, 0xf3afc793,
-	 0xd00d08c7},
-	{0x292561e8, 0x0000000c, 0x00000403, 0xa2ba8aaf, 0x0b797aed,
-	 0x8ba966bc},
-	{0x415037f6, 0x00000003, 0x00000676, 0xa17d52e8, 0x7f0fdf35,
-	 0x11d694a2},
-	{0x3466e707, 0x00000026, 0x00000042, 0x258319be, 0x75c484a2,
-	 0x6ab3208d},
-	{0xafd1281b, 0x00000023, 0x000002ee, 0x4428eaf8, 0x06c7ad10,
-	 0xba4603c5},
-	{0xd3857b18, 0x00000028, 0x000004a2, 0x5c430821, 0xb062b7cb,
-	 0xe6071c6f},
-	{0x1d825a8f, 0x0000002b, 0x0000050b, 0xd2c45f0c, 0xd68634e0,
-	 0x179ec30a},
-	{0x5033e3bc, 0x0000000b, 0x00000078, 0xa3ea4113, 0xac6d31fb,
-	 0x0903beb8},
-	{0x94f1fb5e, 0x0000000f, 0x000003a2, 0xfbfc50b1, 0x3cfe50ed,
-	 0x6a7cb4fa},
-	{0xc9a0fe14, 0x00000009, 0x00000473, 0x5fb61894, 0x87070591,
-	 0xdb535801},
-	{0x88a034b1, 0x0000001c, 0x000005ad, 0xc1b16053, 0x46f95c67,
-	 0x92bed597},
-	{0xf0f72239, 0x00000020, 0x0000026d, 0xa6fa58f3, 0xf8c2c1dd,
-	 0x192a3f1b},
-	{0xcc20a5e3, 0x0000003b, 0x0000067a, 0x7740185a, 0x308b979a,
-	 0xccbaec1a},
-	{0xce589c95, 0x0000002b, 0x00000641, 0xd055e987, 0x40aae25b,
-	 0x7eabae4d},
-	{0x78edc885, 0x00000035, 0x000005be, 0xa39cb14b, 0x035b0d1f,
-	 0x28c72982},
-	{0x9d40a377, 0x0000003b, 0x00000038, 0x1f47ccd2, 0x197fbc9d,
-	 0xc3cd4d18},
-	{0x703d0e01, 0x0000003c, 0x000006f1, 0x88735e7c, 0xfed57c5a,
-	 0xbca8f0e7},
-	{0x776bf505, 0x0000000f, 0x000005b2, 0x5cc4fc01, 0xf32efb97,
-	 0x713f60b3},
-	{0x4a3e7854, 0x00000027, 0x000004b8, 0x8d923c82, 0x0cbfb4a2,
-	 0xebd08fd5},
-	{0x209172dd, 0x0000003b, 0x00000356, 0xb89e9c2b, 0xd7868138,
-	 0x64406c59},
-	{0x3ba4cc5b, 0x0000002f, 0x00000203, 0xe51601a9, 0x5b2a1032,
-	 0x7421890e},
-	{0xfc62f297, 0x00000000, 0x00000079, 0x71a8e1a2, 0x5d88685f,
-	 0xe9347603},
-	{0x64280b8b, 0x00000016, 0x000007ab, 0x0fa7a30c, 0xda3a455f,
-	 0x1bef9060},
-	{0x97dd724b, 0x00000033, 0x000007ad, 0x5788b2f4, 0xd7326d32,
-	 0x34720072},
-	{0x61394b52, 0x00000035, 0x00000571, 0xc66525f1, 0xcabe7fef,
-	 0x48310f59},
-	{0x29b4faff, 0x00000024, 0x0000006e, 0xca13751e, 0x993648e0,
-	 0x783a4213},
-	{0x29bfb1dc, 0x0000000b, 0x00000244, 0x436c43f7, 0x429f7a59,
-	 0x9e8efd41},
-	{0x86ae934b, 0x00000035, 0x00000104, 0x0760ec93, 0x9cf7d0f4,
-	 0xfc3d34a5},
-	{0xc4c1024e, 0x0000002e, 0x000006b1, 0x6516a3ec, 0x19321f9c,
-	 0x17a52ae2},
-	{0x3287a80a, 0x00000026, 0x00000496, 0x0b257eb1, 0x754ebd51,
-	 0x886d935a},
-	{0xa4db423e, 0x00000023, 0x0000045d, 0x9b3a66dc, 0x873e9f11,
-	 0xeaaeaeb2},
-	{0x7a1078df, 0x00000015, 0x0000014a, 0x8c2484c5, 0x6a628659,
-	 0x8e900a4b},
-	{0x6048bd5b, 0x00000006, 0x0000006a, 0x897e3559, 0xac9961af,
-	 0xd74662b1},
-	{0xd8f9ea20, 0x0000003d, 0x00000277, 0x60eb905b, 0xed2aaf99,
-	 0xd26752ba},
-	{0xea5ec3b4, 0x0000002a, 0x000004fe, 0x869965dc, 0x6c1f833b,
-	 0x8b1fcd62},
-	{0x2dfb005d, 0x00000016, 0x00000345, 0x6a3b117e, 0xf05e8521,
-	 0xf54342fe},
-	{0x5a214ade, 0x00000020, 0x000005b6, 0x467f70be, 0xcb22ccd3,
-	 0x5b95b988},
-	{0xf0ab9cca, 0x00000032, 0x00000515, 0xed223df3, 0x7f3ef01d,
-	 0x2e1176be},
-	{0x91b444f9, 0x0000002e, 0x000007f8, 0x84e9a983, 0x5676756f,
-	 0x66120546},
-	{0x1b5d2ddb, 0x0000002e, 0x0000012c, 0xba638c4c, 0x3f42047b,
-	 0xf256a5cc},
-	{0xd824d1bb, 0x0000003a, 0x000007b5, 0x6288653b, 0x3a3ebea0,
-	 0x4af1dd69},
-	{0x0470180c, 0x00000034, 0x000001f0, 0x9d5b80d6, 0x3de08195,
-	 0x56f0a04a},
-	{0xffaa3a3f, 0x00000036, 0x00000299, 0xf3a82ab8, 0x53e0c13d,
-	 0x74f6b6b2},
-	{0x6406cfeb, 0x00000023, 0x00000600, 0xa920b8e8, 0xe4e2acf4,
-	 0x085951fd},
-	{0xb24aaa38, 0x0000003e, 0x000004a1, 0x657cc328, 0x5077b2c3,
-	 0xc65387eb},
-	{0x58b2ab7c, 0x00000039, 0x000002b4, 0x3a17ee7e, 0x9dcb3643,
-	 0x1ca9257b},
-	{0x3db85970, 0x00000006, 0x000002b6, 0x95268b59, 0xb9812c10,
-	 0xfd196d76},
-	{0x857830c5, 0x00000003, 0x00000590, 0x4ef439d5, 0xf042161d,
-	 0x5ef88339},
-	{0xe1fcd978, 0x0000003e, 0x000007d8, 0xae8d8699, 0xce0a1ef5,
-	 0x2c3714d9},
-	{0xb982a768, 0x00000016, 0x000006e0, 0x62fad3df, 0x5f8a067b,
-	 0x58576548},
-	{0x1d581ce8, 0x0000001e, 0x0000058b, 0xf0f5da53, 0x26e39eee,
-	 0xfd7c57de},
-	{0x2456719b, 0x00000025, 0x00000503, 0x4296ac64, 0xd50e4c14,
-	 0xd5fedd59},
-	{0xfae6d8f2, 0x00000000, 0x0000055d, 0x057fdf2e, 0x2a31391a,
-	 0x1cc3b17b},
-	{0xcba828e3, 0x00000039, 0x000002ce, 0xe3f22351, 0x8f00877b,
-	 0x270eed73},
-	{0x13d25952, 0x0000000a, 0x0000072d, 0x76d4b4cc, 0x5eb67ec3,
-	 0x91ecbb11},
-	{0x0342be3f, 0x00000015, 0x00000599, 0xec75d9f1, 0x9d4d2826,
-	 0x05ed8d0c},
-	{0xeaa344e0, 0x00000014, 0x000004d8, 0x72a4c981, 0x2064ea06,
-	 0x0b09ad5b},
-	{0xbbb52021, 0x0000003b, 0x00000272, 0x04af99fc, 0xaf042d35,
-	 0xf8d511fb},
-	{0xb66384dc, 0x0000001d, 0x000007fc, 0xd7629116, 0x782bd801,
-	 0x5ad832cc},
-	{0x616c01b6, 0x00000022, 0x000002c8, 0x5b1dab30, 0x783ce7d2,
-	 0x1214d196},
-	{0xce2bdaad, 0x00000016, 0x0000062a, 0x932535c8, 0x3f02926d,
-	 0x5747218a},
-	{0x00fe84d7, 0x00000005, 0x00000205, 0x850e50aa, 0x753d649c,
-	 0xde8f14de},
-	{0xbebdcb4c, 0x00000006, 0x0000055d, 0xbeaa37a2, 0x2d8c9eba,
-	 0x3563b7b9},
-	{0xd8b1a02a, 0x00000010, 0x00000387, 0x5017d2fc, 0x503541a5,
-	 0x071475d0},
-	{0x3b96cad2, 0x00000036, 0x00000347, 0x1d2372ae, 0x926cd90b,
-	 0x54c79d60},
-	{0xc94c1ed7, 0x00000005, 0x0000038b, 0x9e9fdb22, 0x144a9178,
-	 0x4c53eee6},
-	{0x1aad454e, 0x00000025, 0x000002b2, 0xc3f6315c, 0x5c7a35b3,
-	 0x10137a3c},
-	{0xa4fec9a6, 0x00000000, 0x000006d6, 0x90be5080, 0xa4107605,
-	 0xaa9d6c73},
-	{0x1bbe71e2, 0x0000001f, 0x000002fd, 0x4e504c3b, 0x284ccaf1,
-	 0xb63d23e7},
-	{0x4201c7e4, 0x00000002, 0x000002b7, 0x7822e3f9, 0x0cc912a9,
-	 0x7f53e9cf},
-	{0x23fddc96, 0x00000003, 0x00000627, 0x8a385125, 0x07767e78,
-	 0x13c1cd83},
-	{0xd82ba25c, 0x00000016, 0x0000063e, 0x98e4148a, 0x283330c9,
-	 0x49ff5867},
-	{0x786f2032, 0x0000002d, 0x0000060f, 0xf201600a, 0xf561bfcd,
-	 0x8467f211},
-	{0xfebe4e1f, 0x0000002a, 0x000004f2, 0x95e51961, 0xfd80dcab,
-	 0x3f9683b2},
-	{0x1a6e0a39, 0x00000008, 0x00000672, 0x8af6c2a5, 0x78dd84cb,
-	 0x76a3f874},
-	{0x56000ab8, 0x0000000e, 0x000000e5, 0x36bacb8f, 0x22ee1f77,
-	 0x863b702f},
-	{0x4717fe0c, 0x00000000, 0x000006ec, 0x8439f342, 0x5c8e03da,
-	 0xdc6c58ff},
-	{0xd5d5d68e, 0x0000003c, 0x000003a3, 0x46fff083, 0x177d1b39,
-	 0x0622cc95},
-	{0xc25dd6c6, 0x00000024, 0x000006c0, 0x5ceb8eb4, 0x892b0d16,
-	 0xe85605cd},
-	{0xe9b11300, 0x00000023, 0x00000683, 0x07a5d59a, 0x6c6a3208,
-	 0x31da5f06},
-	{0x95cd285e, 0x00000001, 0x00000047, 0x7b3a4368, 0x0202c07e,
-	 0xa1f2e784},
-	{0xd9245a25, 0x0000001e, 0x000003a6, 0xd33c1841, 0x1936c0d5,
-	 0xb07cc616},
-	{0x103279db, 0x00000006, 0x0000039b, 0xca09b8a0, 0x77d62892,
-	 0xbf943b6c},
-	{0x1cba3172, 0x00000027, 0x000001c8, 0xcb377194, 0xebe682db,
-	 0x2c01af1c},
-	{0x8f613739, 0x0000000c, 0x000001df, 0xb4b0bc87, 0x7710bd43,
-	 0x0fe5f56d},
-	{0x1c6aa90d, 0x0000001b, 0x0000053c, 0x70559245, 0xda7894ac,
-	 0xf8943b2d},
-	{0xaabe5b93, 0x0000003d, 0x00000715, 0xcdbf42fa, 0x0c3b99e7,
-	 0xe4d89272},
-	{0xf15dd038, 0x00000006, 0x000006db, 0x6e104aea, 0x8d5967f2,
-	 0x7c2f6bbb},
-	{0x584dd49c, 0x00000020, 0x000007bc, 0x36b6cfd6, 0xad4e23b2,
-	 0xabbf388b},
-	{0x5d8c9506, 0x00000020, 0x00000470, 0x4c62378e, 0x31d92640,
-	 0x1dca1f4e},
-	{0xb80d17b0, 0x00000032, 0x00000346, 0x22a5bb88, 0x9a7ec89f,
-	 0x5c170e23},
-	{0xdaf0592e, 0x00000023, 0x000007b0, 0x3cab3f99, 0x9b1fdd99,
-	 0xc0e9d672},
-	{0x4793cc85, 0x0000000d, 0x00000706, 0xe82e04f6, 0xed3db6b7,
-	 0xc18bdc86},
-	{0x82ebf64e, 0x00000009, 0x000007c3, 0x69d590a9, 0x9efa8499,
-	 0xa874fcdd},
-	{0xb18a0319, 0x00000026, 0x000007db, 0x1cf98dcc, 0x8fa9ad6a,
-	 0x9dc0bb48},
+	{0x674bf11d, 0x00000038, 0x00000542, 0xf6e93d6c},
+	{0x35c672c6, 0x0000003a, 0x000001aa, 0x0fe92aca},
+	{0x496da28e, 0x00000039, 0x000005af, 0x52e1ebb8},
+	{0x09a9b90e, 0x00000027, 0x000001f8, 0x0798af9a},
+	{0xdc97e5a9, 0x00000025, 0x000003b6, 0x18eb3152},
+	{0x47c58900, 0x0000000a, 0x000000b9, 0xd00d08c7},
+	{0x292561e8, 0x0000000c, 0x00000403, 0x8ba966bc},
+	{0x415037f6, 0x00000003, 0x00000676, 0x11d694a2},
+	{0x3466e707, 0x00000026, 0x00000042, 0x6ab3208d},
+	{0xafd1281b, 0x00000023, 0x000002ee, 0xba4603c5},
+	{0xd3857b18, 0x00000028, 0x000004a2, 0xe6071c6f},
+	{0x1d825a8f, 0x0000002b, 0x0000050b, 0x179ec30a},
+	{0x5033e3bc, 0x0000000b, 0x00000078, 0x0903beb8},
+	{0x94f1fb5e, 0x0000000f, 0x000003a2, 0x6a7cb4fa},
+	{0xc9a0fe14, 0x00000009, 0x00000473, 0xdb535801},
+	{0x88a034b1, 0x0000001c, 0x000005ad, 0x92bed597},
+	{0xf0f72239, 0x00000020, 0x0000026d, 0x192a3f1b},
+	{0xcc20a5e3, 0x0000003b, 0x0000067a, 0xccbaec1a},
+	{0xce589c95, 0x0000002b, 0x00000641, 0x7eabae4d},
+	{0x78edc885, 0x00000035, 0x000005be, 0x28c72982},
+	{0x9d40a377, 0x0000003b, 0x00000038, 0xc3cd4d18},
+	{0x703d0e01, 0x0000003c, 0x000006f1, 0xbca8f0e7},
+	{0x776bf505, 0x0000000f, 0x000005b2, 0x713f60b3},
+	{0x4a3e7854, 0x00000027, 0x000004b8, 0xebd08fd5},
+	{0x209172dd, 0x0000003b, 0x00000356, 0x64406c59},
+	{0x3ba4cc5b, 0x0000002f, 0x00000203, 0x7421890e},
+	{0xfc62f297, 0x00000000, 0x00000079, 0xe9347603},
+	{0x64280b8b, 0x00000016, 0x000007ab, 0x1bef9060},
+	{0x97dd724b, 0x00000033, 0x000007ad, 0x34720072},
+	{0x61394b52, 0x00000035, 0x00000571, 0x48310f59},
+	{0x29b4faff, 0x00000024, 0x0000006e, 0x783a4213},
+	{0x29bfb1dc, 0x0000000b, 0x00000244, 0x9e8efd41},
+	{0x86ae934b, 0x00000035, 0x00000104, 0xfc3d34a5},
+	{0xc4c1024e, 0x0000002e, 0x000006b1, 0x17a52ae2},
+	{0x3287a80a, 0x00000026, 0x00000496, 0x886d935a},
+	{0xa4db423e, 0x00000023, 0x0000045d, 0xeaaeaeb2},
+	{0x7a1078df, 0x00000015, 0x0000014a, 0x8e900a4b},
+	{0x6048bd5b, 0x00000006, 0x0000006a, 0xd74662b1},
+	{0xd8f9ea20, 0x0000003d, 0x00000277, 0xd26752ba},
+	{0xea5ec3b4, 0x0000002a, 0x000004fe, 0x8b1fcd62},
+	{0x2dfb005d, 0x00000016, 0x00000345, 0xf54342fe},
+	{0x5a214ade, 0x00000020, 0x000005b6, 0x5b95b988},
+	{0xf0ab9cca, 0x00000032, 0x00000515, 0x2e1176be},
+	{0x91b444f9, 0x0000002e, 0x000007f8, 0x66120546},
+	{0x1b5d2ddb, 0x0000002e, 0x0000012c, 0xf256a5cc},
+	{0xd824d1bb, 0x0000003a, 0x000007b5, 0x4af1dd69},
+	{0x0470180c, 0x00000034, 0x000001f0, 0x56f0a04a},
+	{0xffaa3a3f, 0x00000036, 0x00000299, 0x74f6b6b2},
+	{0x6406cfeb, 0x00000023, 0x00000600, 0x085951fd},
+	{0xb24aaa38, 0x0000003e, 0x000004a1, 0xc65387eb},
+	{0x58b2ab7c, 0x00000039, 0x000002b4, 0x1ca9257b},
+	{0x3db85970, 0x00000006, 0x000002b6, 0xfd196d76},
+	{0x857830c5, 0x00000003, 0x00000590, 0x5ef88339},
+	{0xe1fcd978, 0x0000003e, 0x000007d8, 0x2c3714d9},
+	{0xb982a768, 0x00000016, 0x000006e0, 0x58576548},
+	{0x1d581ce8, 0x0000001e, 0x0000058b, 0xfd7c57de},
+	{0x2456719b, 0x00000025, 0x00000503, 0xd5fedd59},
+	{0xfae6d8f2, 0x00000000, 0x0000055d, 0x1cc3b17b},
+	{0xcba828e3, 0x00000039, 0x000002ce, 0x270eed73},
+	{0x13d25952, 0x0000000a, 0x0000072d, 0x91ecbb11},
+	{0x0342be3f, 0x00000015, 0x00000599, 0x05ed8d0c},
+	{0xeaa344e0, 0x00000014, 0x000004d8, 0x0b09ad5b},
+	{0xbbb52021, 0x0000003b, 0x00000272, 0xf8d511fb},
+	{0xb66384dc, 0x0000001d, 0x000007fc, 0x5ad832cc},
+	{0x616c01b6, 0x00000022, 0x000002c8, 0x1214d196},
+	{0xce2bdaad, 0x00000016, 0x0000062a, 0x5747218a},
+	{0x00fe84d7, 0x00000005, 0x00000205, 0xde8f14de},
+	{0xbebdcb4c, 0x00000006, 0x0000055d, 0x3563b7b9},
+	{0xd8b1a02a, 0x00000010, 0x00000387, 0x071475d0},
+	{0x3b96cad2, 0x00000036, 0x00000347, 0x54c79d60},
+	{0xc94c1ed7, 0x00000005, 0x0000038b, 0x4c53eee6},
+	{0x1aad454e, 0x00000025, 0x000002b2, 0x10137a3c},
+	{0xa4fec9a6, 0x00000000, 0x000006d6, 0xaa9d6c73},
+	{0x1bbe71e2, 0x0000001f, 0x000002fd, 0xb63d23e7},
+	{0x4201c7e4, 0x00000002, 0x000002b7, 0x7f53e9cf},
+	{0x23fddc96, 0x00000003, 0x00000627, 0x13c1cd83},
+	{0xd82ba25c, 0x00000016, 0x0000063e, 0x49ff5867},
+	{0x786f2032, 0x0000002d, 0x0000060f, 0x8467f211},
+	{0xfebe4e1f, 0x0000002a, 0x000004f2, 0x3f9683b2},
+	{0x1a6e0a39, 0x00000008, 0x00000672, 0x76a3f874},
+	{0x56000ab8, 0x0000000e, 0x000000e5, 0x863b702f},
+	{0x4717fe0c, 0x00000000, 0x000006ec, 0xdc6c58ff},
+	{0xd5d5d68e, 0x0000003c, 0x000003a3, 0x0622cc95},
+	{0xc25dd6c6, 0x00000024, 0x000006c0, 0xe85605cd},
+	{0xe9b11300, 0x00000023, 0x00000683, 0x31da5f06},
+	{0x95cd285e, 0x00000001, 0x00000047, 0xa1f2e784},
+	{0xd9245a25, 0x0000001e, 0x000003a6, 0xb07cc616},
+	{0x103279db, 0x00000006, 0x0000039b, 0xbf943b6c},
+	{0x1cba3172, 0x00000027, 0x000001c8, 0x2c01af1c},
+	{0x8f613739, 0x0000000c, 0x000001df, 0x0fe5f56d},
+	{0x1c6aa90d, 0x0000001b, 0x0000053c, 0xf8943b2d},
+	{0xaabe5b93, 0x0000003d, 0x00000715, 0xe4d89272},
+	{0xf15dd038, 0x00000006, 0x000006db, 0x7c2f6bbb},
+	{0x584dd49c, 0x00000020, 0x000007bc, 0xabbf388b},
+	{0x5d8c9506, 0x00000020, 0x00000470, 0x1dca1f4e},
+	{0xb80d17b0, 0x00000032, 0x00000346, 0x5c170e23},
+	{0xdaf0592e, 0x00000023, 0x000007b0, 0xc0e9d672},
+	{0x4793cc85, 0x0000000d, 0x00000706, 0xc18bdc86},
+	{0x82ebf64e, 0x00000009, 0x000007c3, 0xa874fcdd},
+	{0xb18a0319, 0x00000026, 0x000007db, 0x9dc0bb48},
 };
 
 static int crc32c_test(void)
@@ -968,57 +851,6 @@ static int crc32c_test(void)
 	return errors;
 }
 
-static int crc32_test(void)
-{
-	int i;
-	int errors = 0;
-	int bytes = 0;
-	struct timeval start, stop;
-	uint64_t usec;
-
-	/* keep static to prevent cache warming code from
-	 * getting eliminated by the compiler */
-	static u32 crc;
-
-	/* pre-warm the cache */
-	for (i = 0; i < 100; i++) {
-		bytes += 2*test[i].length;
-
-		crc ^= crc32_le(test[i].crc, test_buf +
-		    test[i].start, test[i].length);
-
-#if 0 /* not used */
-		crc ^= crc32_be(test[i].crc, test_buf +
-		    test[i].start, test[i].length);
-#endif
-	}
-
-	gettimeofday(&start, NULL);
-	for (i = 0; i < 100; i++) {
-		if (test[i].crc_le != crc32_le(test[i].crc, test_buf +
-		    test[i].start, test[i].length))
-			errors++;
-
-#if 0 /* not used */
-		if (test[i].crc_be != crc32_be(test[i].crc, test_buf +
-		    test[i].start, test[i].length))
-			errors++;
-#endif
-	}
-	gettimeofday(&stop, NULL);
-
-	usec = stop.tv_usec - start.tv_usec +
-		1000000000 * (stop.tv_sec - start.tv_sec);
-
-	if (errors)
-		printf("crc32: %d self tests failed\n", errors);
-	else {
-		printf("crc32: tests passed, %d bytes in %" PRIu64 " usec\n",
-			bytes, usec);
-	}
-
-	return errors;
-}
 /*
  * make sure we always return 0 for a successful test run, and non-zero for a
  * failed run. The build infrastructure is looking for this information to
@@ -1030,8 +862,7 @@ int main(int argc, char **argv)
 
 	printf("CRC_LE_BITS = %d\n", CRC_LE_BITS);
 
-	errors = crc32_test();
-	errors += crc32c_test();
+	errors = crc32c_test();
 
 	return errors != 0;
 }
diff --git a/libxfs/crc32defs.h b/libxfs/crc32defs.h
index 2999782e..57c328c2 100644
--- a/libxfs/crc32defs.h
+++ b/libxfs/crc32defs.h
@@ -32,14 +32,6 @@
  */
 #define CRC_LE_BITS 64
 
-/*
- * There are multiple 16-bit CRC polynomials in common use, but this is
- * *the* standard CRC-32 polynomial, first popularized by Ethernet.
- * x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x^1+x^0
- */
-#define CRCPOLY_LE 0xedb88320
-#define CRCPOLY_BE 0x04c11db7
-
 /*
  * This is the CRC32c polynomial, as outlined by Castagnoli.
  * x^32+x^28+x^27+x^26+x^25+x^23+x^22+x^20+x^19+x^18+x^14+x^13+x^11+x^10+x^9+
@@ -47,46 +39,6 @@
  */
 #define CRC32C_POLY_LE 0x82F63B78
 
-/* Try to choose an implementation variant via Kconfig */
-#ifdef CONFIG_CRC32_SLICEBY8
-# define CRC_LE_BITS 64
-# define CRC_BE_BITS 64
-#endif
-#ifdef CONFIG_CRC32_SLICEBY4
-# define CRC_LE_BITS 32
-# define CRC_BE_BITS 32
-#endif
-#ifdef CONFIG_CRC32_SARWATE
-# define CRC_LE_BITS 8
-# define CRC_BE_BITS 8
-#endif
-#ifdef CONFIG_CRC32_BIT
-# define CRC_LE_BITS 1
-# define CRC_BE_BITS 1
-#endif
-
-/*
- * How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and 64.
- * For less performance-sensitive, use 4 or 8 to save table size.
- * For larger systems choose same as CPU architecture as default.
- * This works well on X86_64, SPARC64 systems. This may require some
- * elaboration after experiments with other architectures.
- */
-#ifndef CRC_LE_BITS
-#  ifdef CONFIG_64BIT
-#  define CRC_LE_BITS 64
-#  else
-#  define CRC_LE_BITS 32
-#  endif
-#endif
-#ifndef CRC_BE_BITS
-#  ifdef CONFIG_64BIT
-#  define CRC_BE_BITS 64
-#  else
-#  define CRC_BE_BITS 32
-#  endif
-#endif
-
 /*
  * Little-endian CRC computation.  Used with serial bit streams sent
  * lsbit-first.  Be sure to use cpu_to_le32() to append the computed CRC.
@@ -95,12 +47,3 @@
 	CRC_LE_BITS & CRC_LE_BITS-1
 # error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32, 64}"
 #endif
-
-/*
- * Big-endian CRC computation.  Used with serial bit streams sent
- * msbit-first.  Be sure to use cpu_to_be32() to append the computed CRC.
- */
-#if CRC_BE_BITS > 64 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
-	CRC_BE_BITS & CRC_BE_BITS-1
-# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32, 64}"
-#endif
diff --git a/libxfs/gen_crc32table.c b/libxfs/gen_crc32table.c
index 574a2d1a..d5724326 100644
--- a/libxfs/gen_crc32table.c
+++ b/libxfs/gen_crc32table.c
@@ -12,22 +12,8 @@
 # define LE_TABLE_SIZE (1 << CRC_LE_BITS)
 #endif
 
-#if CRC_BE_BITS > 8
-# define BE_TABLE_ROWS (CRC_BE_BITS/8)
-# define BE_TABLE_SIZE 256
-#else
-# define BE_TABLE_ROWS 1
-# define BE_TABLE_SIZE (1 << CRC_BE_BITS)
-#endif
-
-static uint32_t crc32table_le[LE_TABLE_ROWS][256];
 static uint32_t crc32ctable_le[LE_TABLE_ROWS][256];
 
-/*
- * big endian ordered CRC not used by XFS.
-static uint32_t crc32table_be[BE_TABLE_ROWS][256];
- */
-
 /**
  * crc32init_le() - allocate and initialize LE table data
  *
@@ -57,42 +43,11 @@ static void crc32init_le_generic(const uint32_t polynomial,
 	}
 }
 
-static void crc32init_le(void)
-{
-	crc32init_le_generic(CRCPOLY_LE, crc32table_le);
-}
-
 static void crc32cinit_le(void)
 {
 	crc32init_le_generic(CRC32C_POLY_LE, crc32ctable_le);
 }
 
-/**
- * crc32init_be() - allocate and initialize BE table data
- */
-#if 0 /* not used */
-static void crc32init_be(void)
-{
-	unsigned i, j;
-	uint32_t crc = 0x80000000;
-
-	crc32table_be[0][0] = 0;
-
-	for (i = 1; i < BE_TABLE_SIZE; i <<= 1) {
-		crc = (crc << 1) ^ ((crc & 0x80000000) ? CRCPOLY_BE : 0);
-		for (j = 0; j < i; j++)
-			crc32table_be[0][i + j] = crc ^ crc32table_be[0][j];
-	}
-	for (i = 0; i < BE_TABLE_SIZE; i++) {
-		crc = crc32table_be[0][i];
-		for (j = 1; j < BE_TABLE_ROWS; j++) {
-			crc = crc32table_be[0][(crc >> 24) & 0xff] ^ (crc << 8);
-			crc32table_be[j][i] = crc;
-		}
-	}
-}
-#endif
-
 static void output_table(uint32_t (*table)[256], int rows, int len, char *trans)
 {
 	int i, j;
@@ -112,25 +67,6 @@ int main(int argc, char** argv)
 {
 	printf("/* this file is generated - do not edit */\n\n");
 
-	if (CRC_LE_BITS > 1) {
-		crc32init_le();
-		printf("static u32 crc32table_le[%d][%d] = {",
-		       LE_TABLE_ROWS, LE_TABLE_SIZE);
-		output_table(crc32table_le, LE_TABLE_ROWS,
-			     LE_TABLE_SIZE, "tole");
-		printf("};\n");
-	}
-
-#if 0	/* not used by xfsprogs */
-	if (CRC_BE_BITS > 1) {
-		crc32init_be();
-		printf("static u32 crc32table_be[%d][%d] = {",
-		       BE_TABLE_ROWS, BE_TABLE_SIZE);
-		output_table(crc32table_be, LE_TABLE_ROWS,
-			     BE_TABLE_SIZE, "tobe");
-		printf("};\n");
-	}
-#endif
 	if (CRC_LE_BITS > 1) {
 		crc32cinit_le();
 		printf("static u32 crc32ctable_le[%d][%d] = {",
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 9f46810e..85f13950 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -55,10 +55,7 @@
 #include "xfs_fs.h"
 
 /* CRC stuff, buffer API dependent on it */
-extern uint32_t crc32_le(uint32_t crc, unsigned char const *p, size_t len);
 extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
-
-#define crc32(c,p,l)	crc32_le((c),(unsigned char const *)(p),(l))
 #define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
 
 #include "xfs_cksum.h"

