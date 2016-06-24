Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A6BBC7CA4
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 02:53:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6852B304039
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:53:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id nWpddx8eUtYg1PVR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:53:01 -0700 (PDT)
Received: from [91.114.64.3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bGLvA-0002rZ-GQ
	for xfs@oss.sgi.com; Fri, 24 Jun 2016 07:53:01 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] xfs: remove __arch_pack
Date: Fri, 24 Jun 2016 09:52:47 +0200
Message-Id: <1466754767-10657-4-git-send-email-hch@lst.de>
In-Reply-To: <1466754767-10657-1-git-send-email-hch@lst.de>
References: <1466754767-10657-1-git-send-email-hch@lst.de>
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

Instead we always declare struct xfs_dir2_sf_hdr as packed.  That's
the expected layout, and while most major architectures do the packing
by default the new structure size and offset checker showed that not
only the ARM old ABI got this wrong, but various minor embedded
architectures did as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.h | 2 +-
 fs/xfs/xfs_linux.h            | 7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index f877bb1..685f23b 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -229,7 +229,7 @@ typedef struct xfs_dir2_sf_hdr {
 	__uint8_t		count;		/* count of entries */
 	__uint8_t		i8count;	/* count of 8-byte inode #s */
 	__uint8_t		parent[8];	/* parent dir inode number */
-} __arch_pack xfs_dir2_sf_hdr_t;
+} __packed xfs_dir2_sf_hdr_t;
 
 typedef struct xfs_dir2_sf_entry {
 	__u8			namelen;	/* actual name length */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index a8192dc..b8d64d5 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -328,13 +328,6 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
 	return x;
 }
 
-/* ARM old ABI has some weird alignment/padding */
-#if defined(__arm__) && !defined(__ARM_EABI__)
-#define __arch_pack __attribute__((packed))
-#else
-#define __arch_pack
-#endif
-
 #define ASSERT_ALWAYS(expr)	\
 	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
