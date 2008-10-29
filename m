Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 12:08:53 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9TJ8deq010100
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 12:08:39 -0700
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DC408F8073
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 12:08:37 -0700 (PDT)
Date: Wed, 29 Oct 2008 14:12:59 -0500
From: "Bill O'Donnell" <billodo@sgi.com>
Subject: Re: [PATCH 4/9] add infrastructure for crc in metadata
Message-ID: <20081029191259.GA21157@sgi.com>
References: <20080925225629.GE9822@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925225629.GE9822@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@sgi.com

Hi Christoph-
Unless I'm mistaken, this patch (4/9) is redundant.  
Its already covered by previous patchset from Sep 15 (add crcs for btree blocks)
Cheers-
Bill

On Fri, Sep 26, 2008 at 12:56:29AM +0200, Christoph Hellwig wrote:
| 
|  - add a mount feature bit for CRC enabled filesystems
|  - add some helpers for generating and verifying the CRCs
|  - add a copy_uuid helper
|  - add a pre-io callback to xfs_buf for calculating the CRCs
| 
| The checksumming helpers are losely based on similar ones in sctp,
| all other bits come from Dave Chinner.
| 
| 
| Signed-off-by: Christoph Hellwig <hch@lst.de>
| 
| Index: linux-2.6-xfs/fs/xfs/Kconfig
| ===================================================================
| --- linux-2.6-xfs.orig/fs/xfs/Kconfig	2008-09-25 20:04:39.000000000 +0200
| +++ linux-2.6-xfs/fs/xfs/Kconfig	2008-09-25 20:04:58.000000000 +0200
| @@ -1,6 +1,6 @@
|  config XFS_FS
|  	tristate "XFS filesystem support"
| -	depends on BLOCK
| +	depends on BLOCK && LIBCRC32C
|  	help
|  	  XFS is a high performance journaling filesystem which originated
|  	  on the SGI IRIX platform.  It is completely multi-threaded, can
| Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
| ===================================================================
| --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2008-09-25 20:04:39.000000000 +0200
| +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h	2008-09-25 20:04:58.000000000 +0200
| @@ -77,6 +77,7 @@
|  #include <linux/spinlock.h>
|  #include <linux/random.h>
|  #include <linux/ctype.h>
| +#include <linux/crc32c.h>
|  
|  #include <asm/page.h>
|  #include <asm/div64.h>
| Index: linux-2.6-xfs/fs/xfs/xfs_sb.h
| ===================================================================
| --- linux-2.6-xfs.orig/fs/xfs/xfs_sb.h	2008-09-25 20:04:39.000000000 +0200
| +++ linux-2.6-xfs/fs/xfs/xfs_sb.h	2008-09-25 20:05:06.000000000 +0200
| @@ -79,10 +79,12 @@ struct xfs_mount;
|  #define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters */
|  #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
|  #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
| +#define XFS_SB_VERSION2_CRCBIT		0x00000020	/* metadata has CRCs */
|  
|  #define	XFS_SB_VERSION2_OKREALFBITS	\
|  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
| -	 XFS_SB_VERSION2_ATTR2BIT)
| +	 XFS_SB_VERSION2_ATTR2BIT | \
| +	 XFS_SB_VERSION2_CRCBIT)
|  #define	XFS_SB_VERSION2_OKSASHFBITS	\
|  	(0)
|  #define XFS_SB_VERSION2_OKREALBITS	\
| @@ -494,6 +496,12 @@ static inline void xfs_sb_version_remove
|  		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
|  }
|  
| +static inline int xfs_sb_version_hascrc(xfs_sb_t *sbp)
| +{
| +	return (xfs_sb_version_hasmorebits(sbp) &&
| +		(sbp->sb_features2 & XFS_SB_VERSION2_CRCBIT));
| +}
| +
|  /*
|   * end of superblock version macros
|   */
| Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
| ===================================================================
| --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2008-09-25 20:04:39.000000000 +0200
| +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c	2008-09-25 20:04:58.000000000 +0200
| @@ -1179,6 +1179,14 @@ _xfs_buf_ioapply(
|  		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
|  	}
|  
| +	/*
| +	 * call out to buffer specific pre-write I/O functions. Used for
| +	 * validation of buffers and CRC calculations prior to I/O issue.
| +	 */
| +	if (bp->b_io_callback && (bp->b_flags & XBF_WRITE))
| +		bp->b_io_callback(bp);
| +
| +
|  	/* Special code path for reading a sub page size buffer in --
|  	 * we populate up the whole page, and hence the other metadata
|  	 * in the same page.  This optimization is only valid when the
| Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h
| ===================================================================
| --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2008-09-25 20:04:39.000000000 +0200
| +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h	2008-09-25 20:04:58.000000000 +0200
| @@ -166,6 +166,8 @@ typedef struct xfs_buf {
|  	unsigned int		b_offset;	/* page offset in first page */
|  	struct page		**b_pages;	/* array of page pointers */
|  	struct page		*b_page_array[XB_PAGES]; /* inline pages */
| +	void			(*b_io_callback)(struct xfs_buf *);
| +						/* pre-write I/O callback */
|  #ifdef XFS_BUF_LOCK_TRACKING
|  	int			b_last_holder;
|  #endif
| @@ -228,6 +230,16 @@ static inline int xfs_buf_geterror(xfs_b
|  /* Buffer Utility Routines */
|  extern xfs_caddr_t xfs_buf_offset(xfs_buf_t *, size_t);
|  
| +/*
| + * Set the function that should be called immediately prior
| + * to a write I/O being issued on this buffer.
| + */
| +static inline void
| +xfs_buf_set_io_callback(xfs_buf_t *bp, void (*func)(xfs_buf_t *))
| +{
| +	bp->b_io_callback = func;
| +}
| +
|  /* Pinning Buffer Storage in Memory */
|  extern void xfs_buf_pin(xfs_buf_t *);
|  extern void xfs_buf_unpin(xfs_buf_t *);
| Index: linux-2.6-xfs/fs/xfs/support/uuid.c
| ===================================================================
| --- linux-2.6-xfs.orig/fs/xfs/support/uuid.c	2008-09-25 20:04:39.000000000 +0200
| +++ linux-2.6-xfs/fs/xfs/support/uuid.c	2008-09-25 20:04:58.000000000 +0200
| @@ -72,6 +72,12 @@ uuid_equal(uuid_t *uuid1, uuid_t *uuid2)
|  	return memcmp(uuid1, uuid2, sizeof(uuid_t)) ? 0 : 1;
|  }
|  
| +void
| +uuid_copy(uuid_t *dst, uuid_t *src)
| +{
| +	memcpy(dst, src, sizeof(uuid_t));
| +}
| +
|  /*
|   * Given a 128-bit uuid, return a 64-bit value by adding the top and bottom
|   * 64-bit words.  NOTE: This function can not be changed EVER.  Although
| Index: linux-2.6-xfs/fs/xfs/support/uuid.h
| ===================================================================
| --- linux-2.6-xfs.orig/fs/xfs/support/uuid.h	2008-09-25 20:04:39.000000000 +0200
| +++ linux-2.6-xfs/fs/xfs/support/uuid.h	2008-09-25 20:04:58.000000000 +0200
| @@ -25,6 +25,7 @@ typedef struct {
|  extern void uuid_create_nil(uuid_t *uuid);
|  extern int uuid_is_nil(uuid_t *uuid);
|  extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
| +extern void uuid_copy(uuid_t *dst, uuid_t *src);
|  extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
|  extern __uint64_t uuid_hash64(uuid_t *uuid);
|  extern int uuid_table_insert(uuid_t *uuid);
| Index: linux-2.6-xfs/fs/xfs/xfs_cksum.h
| ===================================================================
| --- /dev/null	1970-01-01 00:00:00.000000000 +0000
| +++ linux-2.6-xfs/fs/xfs/xfs_cksum.h	2008-09-25 20:09:52.000000000 +0200
| @@ -0,0 +1,62 @@
| +#ifndef _XFS_CKSUM_H
| +#define _XFS_CKSUM_H 1
| +
| +#define XFS_CRC_SEED	(~(__uint32_t)0)
| +
| +/*
| + * Calculate the intermediate checksum for a buffer that has the CRC field
| + * inside it.  The offset of the 32bit crc fields is passed as the
| + * cksum_offset parameter.
| + */
| +static inline __uint32_t
| +xfs_start_cksum(char *buffer, size_t length, unsigned long cksum_offset)
| +{
| +	__uint32_t zero = 0;
| +	__uint32_t crc;
| +
| +	/* Calculate CRC up to the checksum. */
| +	crc = crc32c(XFS_CRC_SEED, buffer, cksum_offset);
| +
| +	/* Skip checksum field */
| +	crc = crc32c(crc, &zero, sizeof(__u32));
| +
| +	/* Calculate the rest of the CRC. */
| +	return crc32c(crc, &buffer[cksum_offset + sizeof(__be32)],
| +		      length - (cksum_offset + sizeof(__be32)));
| +}
| +
| +/*
| + * Convert the intermediate checksum to the final ondisk format.
| + *
| + * Note that crc32c is already endianess agnostic, so no additional
| + * byte swap is needed.
| + */
| +static inline __be32
| +xfs_end_cksum(__uint32_t crc)
| +{
| +	return (__force __be32)~crc;
| +}
| +
| +/*
| + * Helper to generate the checksum for a buffer.
| + */
| +static inline void
| +xfs_update_cksum(char *buffer, size_t length, unsigned long cksum_offset)
| +{
| +	__uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
| +
| +	*(__be32 *)(buffer + cksum_offset) = xfs_end_cksum(crc);
| +}
| +
| +/*
| + * Helper to verify the checksum for a buffer.
| + */
| +static inline int
| +xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
| +{
| +	__uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
| +
| +	return *(__be32 *)(buffer + cksum_offset) == xfs_end_cksum(crc);
| +}
| +
| +#endif /* _XFS_CKSUM_H */
| 
| -- 
| 
| 

-- 
Bill O'Donnell
SGI
billodo@sgi.com
