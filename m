Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 68AC87FB1
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 10:43:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3400E304048
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 08:43:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id IlviSk2TwWjVODRY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 08:43:10 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VbuOs-0002gO-Gp
	for xfs@oss.sgi.com; Thu, 31 Oct 2013 15:43:10 +0000
Date: Thu, 31 Oct 2013 08:43:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libxfs: stop caching inode structures
Message-ID: <20131031154310.GA10280@infradead.org>
References: <20131009130241.GA8754@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131009130241.GA8754@infradead.org>
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
To: xfs@oss.sgi.com

ping?

On Wed, Oct 09, 2013 at 06:02:41AM -0700, Christoph Hellwig wrote:
> Currently libxfs has a cache for xfs_inode structures.  Unlike in kernelspace
> where the inode cache, and the associated page cache for file data is used
> for all filesystem operations the libxfs inode cache is only used in few
> places:
> 
>  - the libxfs init code reads the root and realtime inodes when called from
>    xfs_db using a special flag, but these inode structure are never referenced
>    again
>  - mkfs uses namespace and bmap routines that take the xfs_inode structure
>    to create the root and realtime inodes, as well as any additional files
>    specified in the proto file
>  - the xfs_db attr code uses xfs_inode-based attr routines in the attrset
>    and attrget commands
>  - phase6 of xfs_repair uses xfs_inode-based routines for rebuilding
>    directories and moving files to the lost+found directory.
>  - phase7 of xfs_repair uses struct xfs_inode to modify the nlink count
>    of inodes.
> 
> So except in repair we never ever reuse a cached inode, and even in repair
> the logical inode caching doesn't help:
> 
>  - in phase 6a we iterate over each inode in the incore inode tree,
>    and if it's a directory check/rebuild it
>  - phase6b then updates the "." and ".." entries for directories
>    that need, which means we require the backing buffers.
>  - phase6c moves disconnected inodes to lost_found, which again needs
>    the backing buffer to actually do anything.
>  - phase7 then only touches inodes for which we need to reset i_nlink,
>    which always involves reading, modifying and writing the physical
>    inode.
>    which always involves modifying the . and .. entries.
> 
> Given these facts stop caching the inodes to reduce memory usage
> especially in xfs_repair, where this makes a different for large inode
> count inodes.  On the upper end this allows repair to complete for
> filesystem / amount of memory combinations that previously wouldn't.
> 
> With this we probably could increase the memory available to the buffer
> cache in xfs_repair, but trying to do so I got a bit lost - the current
> formula seems to magic to me to make any sense, and simply doubling the
> buffer cache size causes us to run out of memory given that the data cached
> in the buffer cache (typically lots of 8k inode buffers and few 4k other
> metadata buffers) are much bigger than the inodes cached in the inode
> cache.  We probably need a sizing scheme that takes the actual amount
> of memory allocated to the buffer cache into account to solve this better.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  include/libxfs.h      |    5 --
>  libxfs/init.c         |    9 -----
>  libxfs/rdwr.c         |   87 +++++++++++---------------------------------------
>  man/man8/xfs_repair.8 |    6 ---
>  mkfs/xfs_mkfs.c       |    1 
>  repair/xfs_repair.c   |   14 +-------
>  6 files changed, 23 insertions(+), 99 deletions(-)
> 
> Index: xfsprogs/include/libxfs.h
> ===================================================================
> --- xfsprogs.orig/include/libxfs.h	2013-10-09 12:36:31.000000000 +0000
> +++ xfsprogs/include/libxfs.h	2013-10-09 12:40:20.000000000 +0000
> @@ -257,7 +257,6 @@
>  #define LIBXFS_MOUNT_COMPAT_ATTR	0x0010
>  #define LIBXFS_MOUNT_ATTR2		0x0020
>  
> -#define LIBXFS_IHASHSIZE(sbp)		(1<<10)
>  #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
>  
>  extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
> @@ -440,7 +439,6 @@
>  extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
>  
>  extern int libxfs_bhash_size;
> -extern int libxfs_ihash_size;
>  
>  #define LIBXFS_BREAD	0x1
>  #define LIBXFS_BWRITE	0x2
> @@ -640,9 +638,6 @@
>  extern int	libxfs_iflush_int (xfs_inode_t *, xfs_buf_t *);
>  
>  /* Inode Cache Interfaces */
> -extern struct cache	*libxfs_icache;
> -extern struct cache_operations	libxfs_icache_operations;
> -extern void	libxfs_icache_purge (void);
>  extern int	libxfs_iget (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
>  				uint, xfs_inode_t **, xfs_daddr_t);
>  extern void	libxfs_iput (xfs_inode_t *, uint);
> Index: xfsprogs/libxfs/init.c
> ===================================================================
> --- xfsprogs.orig/libxfs/init.c	2013-10-09 12:36:31.000000000 +0000
> +++ xfsprogs/libxfs/init.c	2013-10-09 12:40:20.000000000 +0000
> @@ -22,9 +22,6 @@
>  
>  char *progname = "libxfs";	/* default, changed by each tool */
>  
> -struct cache *libxfs_icache;	/* global inode cache */
> -int libxfs_ihash_size;		/* #buckets in icache */
> -
>  struct cache *libxfs_bcache;	/* global buffer cache */
>  int libxfs_bhash_size;		/* #buckets in bcache */
>  
> @@ -335,9 +332,6 @@
>  	}
>  	if (needcd)
>  		chdir(curdir);
> -	if (!libxfs_ihash_size)
> -		libxfs_ihash_size = LIBXFS_IHASHSIZE(sbp);
> -	libxfs_icache = cache_init(libxfs_ihash_size, &libxfs_icache_operations);
>  	if (!libxfs_bhash_size)
>  		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
>  	libxfs_bcache = cache_init(libxfs_bhash_size, &libxfs_bcache_operations);
> @@ -866,7 +860,6 @@
>  	int			agno;
>  
>  	libxfs_rtmount_destroy(mp);
> -	libxfs_icache_purge();
>  	libxfs_bcache_purge();
>  
>  	for (agno = 0; agno < mp->m_maxagi; agno++) {
> @@ -882,7 +875,6 @@
>  libxfs_destroy(void)
>  {
>  	manage_zones(1);
> -	cache_destroy(libxfs_icache);
>  	cache_destroy(libxfs_bcache);
>  }
>  
> @@ -898,7 +890,6 @@
>  	time_t t;
>  	char *c;
>  
> -	cache_report(fp, "libxfs_icache", libxfs_icache);
>  	cache_report(fp, "libxfs_bcache", libxfs_bcache);
>  
>  	t = time(NULL);
> Index: xfsprogs/libxfs/rdwr.c
> ===================================================================
> --- xfsprogs.orig/libxfs/rdwr.c	2013-10-09 12:36:31.000000000 +0000
> +++ xfsprogs/libxfs/rdwr.c	2013-10-09 12:46:09.000000000 +0000
> @@ -993,26 +993,12 @@
>  
>  
>  /*
> - * Inode cache interfaces
> + * Inode cache stubs.
>   */
>  
>  extern kmem_zone_t	*xfs_ili_zone;
>  extern kmem_zone_t	*xfs_inode_zone;
>  
> -static unsigned int
> -libxfs_ihash(cache_key_t key, unsigned int hashsize)
> -{
> -	return ((unsigned int)*(xfs_ino_t *)key) % hashsize;
> -}
> -
> -static int
> -libxfs_icompare(struct cache_node *node, cache_key_t key)
> -{
> -	xfs_inode_t	*ip = (xfs_inode_t *)node;
> -
> -	return (ip->i_ino == *(xfs_ino_t *)key);
> -}
> -
>  int
>  libxfs_iget(xfs_mount_t *mp, xfs_trans_t *tp, xfs_ino_t ino, uint lock_flags,
>  		xfs_inode_t **ipp, xfs_daddr_t bno)
> @@ -1020,34 +1006,21 @@
>  	xfs_inode_t	*ip;
>  	int		error = 0;
>  
> -	if (cache_node_get(libxfs_icache, &ino, (struct cache_node **)&ip)) {
> -#ifdef INO_DEBUG
> -		fprintf(stderr, "%s: allocated inode, ino=%llu(%llu), %p\n",
> -			__FUNCTION__, (unsigned long long)ino, bno, ip);
> -#endif
> -		ip->i_ino = ino;
> -		ip->i_mount = mp;
> -		error = xfs_iread(mp, tp, ip, bno);
> -		if (error) {
> -			cache_node_purge(libxfs_icache, &ino,
> -					(struct cache_node *)ip);
> -			ip = NULL;
> -		}
> +	ip = kmem_zone_zalloc(xfs_inode_zone, 0);
> +	if (!ip)
> +		return ENOMEM;
> +
> +	ip->i_ino = ino;
> +	ip->i_mount = mp;
> +	error = xfs_iread(mp, tp, ip, bno);
> +	if (error) {
> +		kmem_zone_free(xfs_inode_zone, ip);
> +		*ipp = NULL;
> +		return error;
>  	}
> -	*ipp = ip;
> -	return error;
> -}
> -
> -void
> -libxfs_iput(xfs_inode_t *ip, uint lock_flags)
> -{
> -	cache_node_put(libxfs_icache, (struct cache_node *)ip);
> -}
>  
> -static struct cache_node *
> -libxfs_ialloc(cache_key_t key)
> -{
> -	return kmem_zone_zalloc(xfs_inode_zone, 0);
> +	*ipp = ip;
> +	return 0;
>  }
>  
>  static void
> @@ -1064,32 +1037,12 @@
>  		libxfs_idestroy_fork(ip, XFS_ATTR_FORK);
>  }
>  
> -static void
> -libxfs_irelse(struct cache_node *node)
> -{
> -	xfs_inode_t	*ip = (xfs_inode_t *)node;
> -
> -	if (ip != NULL) {
> -		if (ip->i_itemp)
> -			kmem_zone_free(xfs_ili_zone, ip->i_itemp);
> -		ip->i_itemp = NULL;
> -		libxfs_idestroy(ip);
> -		kmem_zone_free(xfs_inode_zone, ip);
> -		ip = NULL;
> -	}
> -}
> -
>  void
> -libxfs_icache_purge(void)
> +libxfs_iput(xfs_inode_t *ip, uint lock_flags)
>  {
> -	cache_purge(libxfs_icache);
> +	if (ip->i_itemp)
> +		kmem_zone_free(xfs_ili_zone, ip->i_itemp);
> +	ip->i_itemp = NULL;
> +	libxfs_idestroy(ip);
> +	kmem_zone_free(xfs_inode_zone, ip);
>  }
> -
> -struct cache_operations libxfs_icache_operations = {
> -	/* .hash */	libxfs_ihash,
> -	/* .alloc */	libxfs_ialloc,
> -	/* .flush */	NULL,
> -	/* .relse */	libxfs_irelse,
> -	/* .compare */	libxfs_icompare,
> -	/* .bulkrelse */ NULL
> -};
> Index: xfsprogs/mkfs/xfs_mkfs.c
> ===================================================================
> --- xfsprogs.orig/mkfs/xfs_mkfs.c	2013-10-09 12:36:31.000000000 +0000
> +++ xfsprogs/mkfs/xfs_mkfs.c	2013-10-09 12:40:20.000000000 +0000
> @@ -2909,7 +2909,6 @@
>  	 * Need to drop references to inodes we still hold, first.
>  	 */
>  	libxfs_rtmount_destroy(mp);
> -	libxfs_icache_purge();
>  	libxfs_bcache_purge();
>  
>  	/*
> Index: xfsprogs/repair/xfs_repair.c
> ===================================================================
> --- xfsprogs.orig/repair/xfs_repair.c	2013-09-09 14:34:49.000000000 +0000
> +++ xfsprogs/repair/xfs_repair.c	2013-10-09 12:40:20.000000000 +0000
> @@ -69,7 +69,6 @@
>  };
>  
>  
> -static int	ihash_option_used;
>  static int	bhash_option_used;
>  static long	max_mem_specified;	/* in megabytes */
>  static int	phase2_threads = 32;
> @@ -239,13 +238,13 @@
>  					pre_65_beta = 1;
>  					break;
>  				case IHASH_SIZE:
> -					libxfs_ihash_size = (int)strtol(val, NULL, 0);
> -					ihash_option_used = 1;
> +					do_warn(
> +		_("-o ihash option has been removed and will be ignored\n"));
>  					break;
>  				case BHASH_SIZE:
>  					if (max_mem_specified)
>  						do_abort(
> -			_("-o bhash option cannot be used with -m option\n"));
> +		_("-o bhash option cannot be used with -m option\n"));
>  					libxfs_bhash_size = (int)strtol(val, NULL, 0);
>  					bhash_option_used = 1;
>  					break;
> @@ -648,9 +647,7 @@
>  		unsigned long	max_mem;
>  		struct rlimit	rlim;
>  
> -		libxfs_icache_purge();
>  		libxfs_bcache_purge();
> -		cache_destroy(libxfs_icache);
>  		cache_destroy(libxfs_bcache);
>  
>  		mem_used = (mp->m_sb.sb_icount >> (10 - 2)) +
> @@ -709,11 +706,6 @@
>  			do_log(_("        - block cache size set to %d entries\n"),
>  				libxfs_bhash_size * HASH_CACHE_RATIO);
>  
> -		if (!ihash_option_used)
> -			libxfs_ihash_size = libxfs_bhash_size;
> -
> -		libxfs_icache = cache_init(libxfs_ihash_size,
> -						&libxfs_icache_operations);
>  		libxfs_bcache = cache_init(libxfs_bhash_size,
>  						&libxfs_bcache_operations);
>  	}
> Index: xfsprogs/man/man8/xfs_repair.8
> ===================================================================
> --- xfsprogs.orig/man/man8/xfs_repair.8	2013-09-09 14:34:49.000000000 +0000
> +++ xfsprogs/man/man8/xfs_repair.8	2013-10-09 12:40:20.000000000 +0000
> @@ -130,12 +130,6 @@
>  supported are:
>  .RS 1.0i
>  .TP
> -.BI ihash= ihashsize
> -overrides the default inode cache hash size. The total number of
> -inode cache entries are limited to 8 times this amount. The default
> -.I ihashsize
> -is 1024 (for a total of 8192 entries).
> -.TP
>  .BI bhash= bhashsize
>  overrides the default buffer cache hash size. The total number of
>  buffer cache entries are limited to 8 times this amount. The default
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
