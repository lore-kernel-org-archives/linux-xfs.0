Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Jul 2006 01:11:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6S8AxDW014591
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 01:11:10 -0700
Date: Fri, 28 Jul 2006 18:10:13 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: Review: xfs_repair fixes for dir2 corruption
Message-ID: <20060728181013.C2197701@wobbly.melbourne.sgi.com>
References: <20060728091735.B2196410@wobbly.melbourne.sgi.com> <200607280155.LAA12814@larry.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200607280155.LAA12814@larry.melbourne.sgi.com>; from bnaujok@melbourne.sgi.com on Fri, Jul 28, 2006 at 11:58:52AM +1000
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>, mvalluri@sgi.com
Cc: xfs@oss.sgi.com

On Fri, Jul 28, 2006 at 11:58:52AM +1000, Barry Naujok wrote:
> This patch addresses the following xfs_repair issues:

The libxfs cache stuff looks good to me.  Maybe Madan can cast
an eye over the repair changes for ya?

cheers.

>   - Can rebuild most corrupted directories. Some will be 
>     beyond repair and the contents of those will end up 
>     in lost+found.
>   - Fixed potential problems with the duplicate name 
>     checking by properly referencing the buffers where
>     the names are stored.
>   - Unified the two hash lists used in directory checks.
>   - Fixed a case where incorrectly reference counted and
>     dirty buffers were never written to disk (most 
>     common observation of this is an inaccessible 
>     lost+found directory after a repair).
> 
> For those that are keen to fix the 16777216 problem, give this patch a go.
> 
> 
> 
> 
> ===========================================================================
> xfsprogs/include/cache.h
> ===========================================================================
> 
> --- a/xfsprogs/include/cache.h	2006-07-28 11:46:09.000000000 +1000
> +++ b/xfsprogs/include/cache.h	2006-07-27 16:17:47.804986322 +1000
> @@ -30,6 +30,7 @@ struct cache_node;
>  typedef void *cache_key_t;
>  typedef void (*cache_walk_t)(struct cache_node *);
>  typedef struct cache_node * (*cache_node_alloc_t)(void);
> +typedef void (*cache_node_flush_t)(struct cache_node *);
>  typedef void (*cache_node_relse_t)(struct cache_node *);
>  typedef unsigned int (*cache_node_hash_t)(cache_key_t, unsigned int);
>  typedef int (*cache_node_compare_t)(struct cache_node *, cache_key_t);
> @@ -38,6 +39,7 @@ typedef unsigned int (*cache_bulk_relse_
>  struct cache_operations {
>  	cache_node_hash_t	hash;
>  	cache_node_alloc_t	alloc;
> +	cache_node_flush_t	flush;
>  	cache_node_relse_t	relse;
>  	cache_node_compare_t	compare;
>  	cache_bulk_relse_t	bulkrelse;	/* optional */
> @@ -49,6 +51,7 @@ struct cache {
>  	pthread_mutex_t		c_mutex;	/* node count mutex */
>  	cache_node_hash_t	hash;		/* node hash function */
>  	cache_node_alloc_t	alloc;		/* allocation function */
> +	cache_node_flush_t	flush;		/* flush dirty data function */
>  	cache_node_relse_t	relse;		/* memory free function */
>  	cache_node_compare_t	compare;	/* comparison routine */
>  	cache_bulk_relse_t	bulkrelse;	/* bulk release routine */
> @@ -75,6 +78,7 @@ struct cache *cache_init(unsigned int, s
>  void cache_destroy(struct cache *);
>  void cache_walk(struct cache *, cache_walk_t);
>  void cache_purge(struct cache *);
> +void cache_flush(struct cache *);
>  
>  int cache_node_get(struct cache *, cache_key_t, struct cache_node **);
>  void cache_node_put(struct cache_node *);
> 
> ===========================================================================
> xfsprogs/include/libxfs.h
> ===========================================================================
> 
> --- a/xfsprogs/include/libxfs.h	2006-07-28 11:46:09.000000000 +1000
> +++ b/xfsprogs/include/libxfs.h	2006-07-27 16:34:45.308344014 +1000
> @@ -257,6 +257,7 @@ extern int	libxfs_writebuf_int (xfs_buf_
>  extern struct cache	*libxfs_bcache;
>  extern struct cache_operations	libxfs_bcache_operations;
>  extern void	libxfs_bcache_purge (void);
> +extern void	libxfs_bcache_flush (void);
>  extern xfs_buf_t	*libxfs_getbuf (dev_t, xfs_daddr_t, int);
>  extern void	libxfs_putbuf (xfs_buf_t *);
>  extern void	libxfs_purgebuf (xfs_buf_t *);
> @@ -467,6 +468,8 @@ extern int	libxfs_bmap_finish (xfs_trans
>  				xfs_fsblock_t, int *);
>  extern int	libxfs_bmap_next_offset (xfs_trans_t *, xfs_inode_t *,
>  				xfs_fileoff_t *, int);
> +extern int	libxfs_bmap_last_offset(xfs_trans_t *, xfs_inode_t *, 
> +				xfs_fileoff_t *, int);
>  extern int	libxfs_bunmapi (xfs_trans_t *, xfs_inode_t *, xfs_fileoff_t,
>  				xfs_filblks_t, int, xfs_extnum_t,
>  				xfs_fsblock_t *, xfs_bmap_free_t *, int *);
> 
> ===========================================================================
> xfsprogs/libxfs/cache.c
> ===========================================================================
> 
> --- a/xfsprogs/libxfs/cache.c	2006-07-28 11:46:09.000000000 +1000
> +++ b/xfsprogs/libxfs/cache.c	2006-07-27 17:42:43.812685388 +1000
> @@ -60,6 +60,7 @@ cache_init(
>  	cache->c_hashsize = hashsize;
>  	cache->hash = cache_operations->hash;
>  	cache->alloc = cache_operations->alloc;
> +	cache->flush = cache_operations->flush;
>  	cache->relse = cache_operations->relse;
>  	cache->compare = cache_operations->compare;
>  	cache->bulkrelse = cache_operations->bulkrelse ?
> @@ -422,6 +423,39 @@ cache_purge(
>  		cache_abort();
>  	}
>  #endif
> +	/* flush any remaining nodes to disk */
> +	cache_flush(cache);
> +}
> +
> +/*
> + * Flush all nodes in the cache to disk. 
> + */
> +void
> +cache_flush(
> +	struct cache *		cache)
> +{
> +	struct cache_hash *	hash;
> +	struct list_head *	head;
> +	struct list_head *	pos;
> +	struct cache_node *	node;
> +	int			i;
> +	
> +	if (!cache->flush)
> +		return;
> +	
> +	for (i = 0; i < cache->c_hashsize; i++) {
> +		hash = &cache->c_hash[i];
> +		
> +		pthread_mutex_lock(&hash->ch_mutex);
> +		head = &hash->ch_list;
> +		for (pos = head->next; pos != head; pos = pos->next) {
> +			node = (struct cache_node *)pos;
> +			pthread_mutex_lock(&node->cn_mutex);
> +			cache->flush(node);
> +			pthread_mutex_unlock(&node->cn_mutex);
> +		}
> +		pthread_mutex_unlock(&hash->ch_mutex);
> +	}
>  }
>  
>  #define	HASH_REPORT	(3*HASH_CACHE_RATIO)
> 
> ===========================================================================
> xfsprogs/libxfs/rdwr.c
> ===========================================================================
> 
> --- a/xfsprogs/libxfs/rdwr.c	2006-07-28 11:46:09.000000000 +1000
> +++ b/xfsprogs/libxfs/rdwr.c	2006-07-27 16:40:56.612373938 +1000
> @@ -416,6 +416,15 @@ libxfs_iomove(xfs_buf_t *bp, uint boff, 
>  }
>  
>  static void
> +libxfs_bflush(struct cache_node *node)
> +{
> +	xfs_buf_t		*bp = (xfs_buf_t *)node;
> +
> +	if ((bp != NULL) && (bp->b_flags & LIBXFS_B_DIRTY))
> +		libxfs_writebufr(bp);
> +}
> +
> +static void
>  libxfs_brelse(struct cache_node *node)
>  {
>  	xfs_buf_t		*bp = (xfs_buf_t *)node;
> @@ -442,9 +451,16 @@ libxfs_bcache_purge(void)
>  	cache_purge(libxfs_bcache);
>  }
>  
> +void 
> +libxfs_bcache_flush(void)
> +{
> +	cache_flush(libxfs_bcache);
> +}
> +
>  struct cache_operations libxfs_bcache_operations = {
>  	/* .hash */	libxfs_bhash,
>  	/* .alloc */	libxfs_balloc,
> +	/* .flush */	libxfs_bflush,
>  	/* .relse */	libxfs_brelse,
>  	/* .compare */	libxfs_bcompare,
>  	/* .bulkrelse */ NULL	/* TODO: lio_listio64 interface? */
> @@ -649,6 +665,7 @@ libxfs_icache_purge(void)
>  struct cache_operations libxfs_icache_operations = {
>  	/* .hash */	libxfs_ihash,
>  	/* .alloc */	libxfs_ialloc,
> +	/* .flush */	NULL,
>  	/* .relse */	libxfs_irelse,
>  	/* .compare */	libxfs_icompare,
>  	/* .bulkrelse */ NULL
> 
> ===========================================================================
> xfsprogs/libxfs/xfs.h
> ===========================================================================
> 
> --- a/xfsprogs/libxfs/xfs.h	2006-07-28 11:46:09.000000000 +1000
> +++ b/xfsprogs/libxfs/xfs.h	2006-07-25 12:05:31.917896892 +1000
> @@ -98,6 +98,7 @@
>  #define xfs_bmapi_single		libxfs_bmapi_single
>  #define xfs_bmap_finish			libxfs_bmap_finish
>  #define xfs_bmap_del_free		libxfs_bmap_del_free
> +#define xfs_bmap_last_offset		libxfs_bmap_last_offset
>  #define xfs_bunmapi			libxfs_bunmapi
>  #define xfs_free_extent			libxfs_free_extent
>  #define xfs_rtfree_extent		libxfs_rtfree_extent
> 
> ===========================================================================
> xfsprogs/repair/phase6.c
> ===========================================================================
> 
> --- a/xfsprogs/repair/phase6.c	2006-07-28 11:46:09.000000000 +1000
> +++ b/xfsprogs/repair/phase6.c	2006-07-28 11:30:50.033905530 +1000
> @@ -36,43 +36,35 @@ static int orphanage_entered;
>  
>  /*
>   * Data structures and routines to keep track of directory entries
> - * and whether their leaf entry has been seen
> + * and whether their leaf entry has been seen. Also used for name
> + * duplicate checking and rebuilding step if required.
>   */
>  typedef struct dir_hash_ent {
> -	struct dir_hash_ent	*next;	/* pointer to next entry */
> +	struct dir_hash_ent	*nextbyaddr;/* pointer to next entry */
> +	struct dir_hash_ent	*nextbyhash;
> +	struct dir_hash_ent	*nextbyorder;
>  	xfs_dir2_leaf_entry_t	ent;	/* address and hash value */
> +	xfs_ino_t 		inum;	/* inode of name */
>  	short			junkit;	/* name starts with / */
>  	short			seen;	/* have seen leaf entry */
> +	int	  	    	namelen;/* length of name */
> +	uchar_t    	    	*name;	/* pointer to name (no NULL) */
>  } dir_hash_ent_t;
>  
>  typedef struct dir_hash_tab {
>  	int			size;	/* size of hash table */
> -	dir_hash_ent_t		*tab[1];/* actual hash table, variable size */
> +	int			names_duped;
> +	dir_hash_ent_t		*first;
> +	dir_hash_ent_t		*last;
> +	dir_hash_ent_t		**byhash;/* actual hash table, variable size */
> +	dir_hash_ent_t		**byaddr;/* actual hash table, variable size */
>  } dir_hash_tab_t;
> +
>  #define	DIR_HASH_TAB_SIZE(n)	\
> -	(offsetof(dir_hash_tab_t, tab) + (sizeof(dir_hash_ent_t *) * (n)))
> +	(sizeof(dir_hash_tab_t) + (sizeof(dir_hash_ent_t *) * (n) * 2))
>  #define	DIR_HASH_FUNC(t,a)	((a) % (t)->size)
>  
>  /*
> - * Track names to check for duplicates in a directory.
> - */
> -
> -typedef struct name_hash_ent {
> -	struct name_hash_ent	*next;	/* pointer to next entry */
> -	xfs_dahash_t		hashval;/* hash value of name */
> -	int	  	    	namelen;/* length of name */
> -	uchar_t    	    	*name;	/* pointer to name (no NULL) */
> -} name_hash_ent_t;		
> -
> -typedef struct name_hash_tab {
> -	int			size;	/* size of hash table */
> -	name_hash_ent_t		*tab[1];/* actual hash table, variable size */
> -} name_hash_tab_t;
> -#define	NAME_HASH_TAB_SIZE(n)	\
> -	(offsetof(name_hash_tab_t, tab) + (sizeof(name_hash_ent_t *) * (n)))
> -#define	NAME_HASH_FUNC(t,a)	((a) % (t)->size)
> -
> -/*
>   * Track the contents of the freespace table in a directory.
>   */
>  typedef struct freetab {
> @@ -94,28 +86,75 @@ typedef struct freetab {
>  #define	DIR_HASH_CK_BADSTALE	5
>  #define	DIR_HASH_CK_TOTAL	6
>  
> -static void
> +/*
> + * Returns 0 if the name already exists (ie. a duplicate)
> + */
> +static int
>  dir_hash_add(
>  	dir_hash_tab_t		*hashtab,
> -	xfs_dahash_t		hash,
> -	xfs_dir2_dataptr_t	addr,
> -	int			junk)
> -{
> -	int			i;
> +	xfs_dir2_dataptr_t	addr,	
> +	xfs_ino_t		inum,
> +	int			namelen,
> +	uchar_t			*name)
> +{
> +	xfs_dahash_t		hash = 0;
> +	int			byaddr;
> +	int			byhash = 0;
>  	dir_hash_ent_t		*p;
> -
> -	i = DIR_HASH_FUNC(hashtab, addr);
> +	int			dup;
> +	short			junk;
> +	
> +	junk = name[0] == '/';
> +	byaddr = DIR_HASH_FUNC(hashtab, addr);
> +	dup = 0;
> +
> +	if (!junk) {
> +		hash = libxfs_da_hashname(name, namelen);
> +		byhash = DIR_HASH_FUNC(hashtab, hash);
> +
> +		/* 
> +		 * search hash bucket for existing name.
> +		 */
> +		for (p = hashtab->byhash[byhash]; p; p = p->nextbyhash) {
> +			if (p->ent.hashval == hash && p->namelen == namelen) {
> +				if (memcmp(p->name, name, namelen) == 0) {
> +					dup = 1;
> +					break;
> +				}
> +			}
> +		}
> +	}
> +	
>  	if ((p = malloc(sizeof(*p))) == NULL)
>  		do_error(_("malloc failed in dir_hash_add (%u bytes)\n"),
>  			sizeof(*p));
> -	p->next = hashtab->tab[i];
> -	hashtab->tab[i] = p;
> -	if (!(p->junkit = junk))
> +	
> +	p->nextbyaddr = hashtab->byaddr[byaddr];
> +	hashtab->byaddr[byaddr] = p;
> +	if (hashtab->last) 
> +		hashtab->last->nextbyorder = p;
> +	else
> +		hashtab->first = p;
> +	p->nextbyorder = NULL;
> +	hashtab->last = p;
> +	
> +	if (!(p->junkit = junk)) {
>  		p->ent.hashval = hash;
> +		p->nextbyhash = hashtab->byhash[byhash];
> +		hashtab->byhash[byhash] = p;
> +	}
>  	p->ent.address = addr;
> +	p->inum = inum;
>  	p->seen = 0;
> +	p->namelen = namelen;
> +	p->name = name;
> +	
> +	return !dup;
>  }
>  
> +/*
> + * checks to see if any data entries are not in the leaf blocks 
> + */
>  static int
>  dir_hash_unseen(
>  	dir_hash_tab_t	*hashtab)
> @@ -124,7 +163,7 @@ dir_hash_unseen(
>  	dir_hash_ent_t	*p;
>  
>  	for (i = 0; i < hashtab->size; i++) {
> -		for (p = hashtab->tab[i]; p; p = p->next) {
> +		for (p = hashtab->byaddr[i]; p; p = p->nextbyaddr) {
>  			if (p->seen == 0)
>  				return 1;
>  		}
> @@ -173,8 +212,10 @@ dir_hash_done(
>  	dir_hash_ent_t	*p;
>  
>  	for (i = 0; i < hashtab->size; i++) {
> -		for (p = hashtab->tab[i]; p; p = n) {
> -			n = p->next;
> +		for (p = hashtab->byaddr[i]; p; p = n) {
> +			n = p->nextbyaddr;
> +			if (hashtab->names_duped)
> +				free(p->name);
>  			free(p);
>  		}
>  	}
> @@ -196,6 +237,10 @@ dir_hash_init(
>  	if ((hashtab = calloc(DIR_HASH_TAB_SIZE(hsize), 1)) == NULL)
>  		do_error(_("calloc failed in dir_hash_init\n"));
>  	hashtab->size = hsize;
> +	hashtab->byhash = (dir_hash_ent_t**)((char *)hashtab + 
> +		sizeof(dir_hash_tab_t));
> +	hashtab->byaddr = (dir_hash_ent_t**)((char *)hashtab + 
> +		sizeof(dir_hash_tab_t) + sizeof(dir_hash_ent_t*) * hsize);
>  	return hashtab;
>  }
>  
> @@ -209,7 +254,7 @@ dir_hash_see(
>  	dir_hash_ent_t		*p;
>  
>  	i = DIR_HASH_FUNC(hashtab, addr);
> -	for (p = hashtab->tab[i]; p; p = p->next) {
> +	for (p = hashtab->byaddr[i]; p; p = p->nextbyaddr) {
>  		if (p->ent.address != addr)
>  			continue;
>  		if (p->seen)
> @@ -222,6 +267,10 @@ dir_hash_see(
>  	return DIR_HASH_CK_NODATA;
>  }
>  
> +/*
> + * checks to make sure leafs match a data entry, and that the stale
> + * count is valid.
> + */
>  static int
>  dir_hash_see_all(
>  	dir_hash_tab_t		*hashtab,
> @@ -246,81 +295,25 @@ dir_hash_see_all(
>  }
>  
>  /*
> - * Returns 0 if the name already exists (ie. a duplicate)
> + * Convert name pointers into locally allocated memory
>   */
> -static int
> -name_hash_add(
> -	name_hash_tab_t		*nametab,
> -	uchar_t			*name,
> -	int			namelen)
> +static void
> +dir_hash_dup_names(dir_hash_tab_t *hashtab)
>  {
> -	xfs_dahash_t		hash;
> -	int			i;
> -	name_hash_ent_t		*p;
> -
> -	hash = libxfs_da_hashname(name, namelen);
> -			
> -	i = NAME_HASH_FUNC(nametab, hash);
> -	
> -	/* 
> -	 * search hash bucket for existing name.
> -	 */
> -	for (p = nametab->tab[i]; p; p = p->next) {
> -		if (p->hashval == hash && p->namelen == namelen) {
> -			if (memcmp(p->name, name, namelen) == 0) 
> -				return 0; /* exists */
> -		}
> -	}
> -	
> -	if ((p = malloc(sizeof(*p))) == NULL)
> -		do_error(_("malloc failed in name_hash_add (%u bytes)\n"),
> -			sizeof(*p));
> +	uchar_t			*name;
> +	dir_hash_ent_t		*p;
>  	
> -	p->next = nametab->tab[i];
> -	p->hashval = hash;
> -	p->name = name;
> -	p->namelen = namelen;
> -	nametab->tab[i] = p;
> +	if (hashtab->names_duped)
> +		return;
>  	
> -	return 1;	/* success, no duplicate */
> -}
> -
> -static name_hash_tab_t *
> -name_hash_init(
> -	xfs_fsize_t	size)
> -{
> -	name_hash_tab_t	*nametab;
> -	int		hsize;
> -
> -	hsize = size / (16 * 4);
> -	if (hsize > 1024)
> -		hsize = 1024;
> -	else if (hsize < 16)
> -		hsize = 16;
> -	if ((nametab = calloc(NAME_HASH_TAB_SIZE(hsize), 1)) == NULL)
> -		do_error(_("calloc failed in name_hash_init\n"));
> -	nametab->size = hsize;
> -	return nametab;
> -}
> -
> -static void
> -name_hash_done(
> -	name_hash_tab_t	*nametab)
> -{
> -	int		i;
> -	name_hash_ent_t	*n;
> -	name_hash_ent_t	*p;
> -
> -	for (i = 0; i < nametab->size; i++) {
> -		for (p = nametab->tab[i]; p; p = n) {
> -			n = p->next;
> -			free(p);
> -		}
> +	for (p = hashtab->first; p; p = p->nextbyorder) {
> +		name = malloc(p->namelen);
> +		memcpy(name, p->name, p->namelen);
> +		p->name = name;
>  	}
> -	free(nametab);
> +	hashtab->names_duped = 1;
>  }
>  
> -
>  /*
>   * Version 1 or 2 directory routine wrappers
>  */
> @@ -1385,7 +1378,8 @@ lf_block_dir_entry_check(xfs_mount_t		*m
>  			dir_stack_t		*stack,
>  			ino_tree_node_t		*current_irec,
>  			int			current_ino_offset,
> -			name_hash_tab_t		*nametab)
> +			dir_hash_tab_t		*hashtab,
> +			xfs_dablk_t		da_bno)
>  {
>  	xfs_dir_leaf_entry_t	*entry;
>  	ino_tree_node_t		*irec;
> @@ -1545,7 +1539,9 @@ lf_block_dir_entry_check(xfs_mount_t		*m
>  		/*
>  		 * check for duplicate names in directory.
>  		 */ 
> -		if (!name_hash_add(nametab, namest->name, entry->namelen)) {
> +		if (!dir_hash_add(hashtab, (da_bno << mp->m_sb.sb_blocklog) + 
> +						entry->nameidx, 
> +				lino, entry->namelen, namest->name)) {
>  			do_warn(
>  		_("entry \"%s\" (ino %llu) in dir %llu is a duplicate name"),
>  				fname, lino, ino);
> @@ -1635,7 +1631,7 @@ longform_dir_entry_check(xfs_mount_t	*mp
>  			dir_stack_t	*stack,
>  			ino_tree_node_t	*irec,
>  			int		ino_offset,
> -			name_hash_tab_t	*nametab)
> +			dir_hash_tab_t	*hashtab)
>  {
>  	xfs_dir_leafblock_t	*leaf;
>  	xfs_buf_t		*bp;
> @@ -1677,8 +1673,6 @@ longform_dir_entry_check(xfs_mount_t	*mp
>  
>  		leaf = (xfs_dir_leafblock_t *)XFS_BUF_PTR(bp);
>  
> -		da_bno = INT_GET(leaf->hdr.info.forw, ARCH_CONVERT);
> -
>  		if (INT_GET(leaf->hdr.info.magic, ARCH_CONVERT) !=
>  		    XFS_DIR_LEAF_MAGIC)  {
>  			if (!no_modify)  {
> @@ -1699,9 +1693,11 @@ _("bad magic # (0x%x) for dir ino %llu l
>  		}
>  
>  		if (!skipit)
> -			lf_block_dir_entry_check(mp, ino, leaf, &dirty,
> -						num_illegal, need_dot, stack,
> -						irec, ino_offset, nametab);
> +			lf_block_dir_entry_check(mp, ino, leaf, &dirty, 
> +					num_illegal, need_dot, stack, irec, 
> +					ino_offset, hashtab, da_bno);
> +
> +		da_bno = INT_GET(leaf->hdr.info.forw, ARCH_CONVERT);
>  
>  		ASSERT(dirty == 0 || (dirty && !no_modify));
>  
> @@ -1745,6 +1741,127 @@ _("can't map leaf block %d in dir %llu, 
>  }
>  
>  /*
> + * Unexpected failure during the rebuild will leave the entries in
> + * lost+found on the next run
> + */
> +
> +static void 
> +longform_dir2_rebuild(
> +	xfs_mount_t	*mp,
> +	xfs_ino_t	ino,
> +	xfs_inode_t	*ip,
> +	dir_hash_tab_t	*hashtab)
> +{
> +	int			error;
> +	int			nres;
> +	xfs_trans_t		*tp;
> +	xfs_fileoff_t		lastblock;
> +	xfs_fsblock_t		firstblock;
> +	xfs_bmap_free_t		flist;
> +	xfs_ino_t		parentino;
> +	xfs_inode_t		*pip;
> +	int			byhash;
> +	dir_hash_ent_t		*p;
> +	int			committed;
> +	int			done;
> +	
> +	/* 
> +	 * trash directory completely and rebuild from scratch using the
> +	 * name/inode pairs in the hash table
> +	 */
> +	 
> +	do_warn(_("rebuilding directory inode %llu\n"), ino);
> +	
> +	/* 
> +	 * first attempt to locate the parent inode, if it can't be found,
> +	 * we'll use the lost+found inode 
> +	 */
> +	byhash = DIR_HASH_FUNC(hashtab, libxfs_da_hashname((uchar_t*)"..", 2));
> +	parentino = orphanage_ino;
> +	for (p = hashtab->byhash[byhash]; p; p = p->nextbyhash) {
> +		if (p->namelen == 2 && p->name[0] == '.' && p->name[1] == '.') {
> +			parentino = p->inum;
> +			break;
> +		}
> +	}
> +
> +	XFS_BMAP_INIT(&flist, &firstblock);
> +		
> +	tp = libxfs_trans_alloc(mp, 0);
> +	nres = XFS_REMOVE_SPACE_RES(mp);
> +	error = libxfs_trans_reserve(tp, nres, XFS_REMOVE_LOG_RES(mp), 0,
> +			XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
> +	if (error)
> +		res_failed(error);
> +	libxfs_trans_ijoin(tp, ip, 0);
> +	libxfs_trans_ihold(tp, ip);
> +	
> +	if ((error = libxfs_bmap_last_offset(tp, ip, &lastblock, 
> +						XFS_DATA_FORK)))
> +		do_error(_("xfs_bmap_last_offset failed -- error - %d\n"), 
> +			error);
> +	
> +	/* re-init the directory to shortform */
> +	if ((error = libxfs_trans_iget(mp, tp, parentino, 0, 0, &pip)))
> +		do_error(
> +		_("couldn't iget parent inode %llu -- error - %d\n"),
> +			parentino, error);
> +
> +	/* free all data, leaf, node and freespace blocks */
> +	
> +	if ((error = libxfs_bunmapi(tp, ip, 0, lastblock, 
> +			XFS_BMAPI_METADATA, 0, &firstblock, &flist,
> +			&done))) 
> +		do_error(_("xfs_bunmapi failed -- error - %d\n"), error);
> +	ASSERT(done);
> +
> +	libxfs_dir2_init(tp, ip, pip);
> +	
> +	error = libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
> +				
> +	libxfs_trans_commit(tp, 
> +			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC, 0);
> +		
> +	/* go through the hash list and re-add the inodes */
> +
> +	for (p = hashtab->first; p; p = p->nextbyorder) {
> +		
> +		if (p->name[0] == '/' || (p->name[0] == '.' && (p->namelen == 1 
> +				|| (p->namelen == 2 && p->name[1] == '.'))))
> +			continue;
> +		
> +		tp = libxfs_trans_alloc(mp, 0);
> +		nres = XFS_CREATE_SPACE_RES(mp, p->namelen);
> +		if ((error = libxfs_trans_reserve(tp, nres, 
> +				XFS_CREATE_LOG_RES(mp), 0,
> +				XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT)))
> +			do_error(
> +	_("space reservation failed (%d), filesystem may be out of space\n"),
> +				error);
> +
> +		libxfs_trans_ijoin(tp, ip, 0);
> +		libxfs_trans_ihold(tp, ip);
> +
> +		XFS_BMAP_INIT(&flist, &firstblock);
> +		if ((error = libxfs_dir2_createname(tp, ip, (char*)p->name, 
> +				p->namelen, p->inum, &firstblock, &flist, nres)))
> +			do_error(
> +_("name create failed in ino %llu (%d), filesystem may be out of space\n"),
> +				ino, error);
> +
> +		if ((error = libxfs_bmap_finish(&tp, &flist, firstblock, 
> +				&committed)))
> +			do_error(
> +	_("bmap finish failed (%d), filesystem may be out of space\n"),
> +				error);
> +
> +		libxfs_trans_commit(tp, 
> +				XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC, 0);
> +	}
> +}
> +
> +
> +/*
>   * Kill a block in a version 2 inode.
>   * Makes its own transaction.
>   */
> @@ -1807,7 +1924,6 @@ longform_dir2_entry_check_data(
>  	xfs_dabuf_t		**bpp,
>  	dir_hash_tab_t		*hashtab,
>  	freetab_t		**freetabp,
> -	name_hash_tab_t		*nametab,
>  	xfs_dablk_t		da_bno,
>  	int			isblock)
>  {
> @@ -1828,6 +1944,7 @@ longform_dir2_entry_check_data(
>  	freetab_t		*freetab;
>  	int			i;
>  	int			ino_offset;
> +	xfs_ino_t		inum;
>  	ino_tree_node_t		*irec;
>  	int			junkit;
>  	int			lastfree;
> @@ -1956,8 +2073,7 @@ longform_dir2_entry_check_data(
>  	libxfs_trans_ijoin(tp, ip, 0);
>  	libxfs_trans_ihold(tp, ip);
>  	libxfs_da_bjoin(tp, bp);
> -	if (isblock)
> -		libxfs_da_bhold(tp, bp);
> +	libxfs_da_bhold(tp, bp);
>  	XFS_BMAP_INIT(&flist, &firstblock);
>  	if (INT_GET(d->hdr.magic, ARCH_CONVERT) != wantmagic) {
>  		do_warn(_("bad directory block magic # %#x for directory inode "
> @@ -1987,7 +2103,7 @@ longform_dir2_entry_check_data(
>  	while (ptr < endptr) {
>  		dup = (xfs_dir2_data_unused_t *)ptr;
>  		if (INT_GET(dup->freetag, ARCH_CONVERT) ==
> -		    XFS_DIR2_DATA_FREE_TAG) {
> +		    				XFS_DIR2_DATA_FREE_TAG) {
>  			if (lastfree) {
>  				do_warn(_("directory inode %llu block %u has "
>  					  "consecutive free entries: "),
> @@ -2011,10 +2127,24 @@ longform_dir2_entry_check_data(
>  		addr = XFS_DIR2_DB_OFF_TO_DATAPTR(mp, db, ptr - (char *)d);
>  		dep = (xfs_dir2_data_entry_t *)ptr;
>  		ptr += XFS_DIR2_DATA_ENTSIZE(dep->namelen);
> +		inum = INT_GET(dep->inumber, ARCH_CONVERT);
>  		lastfree = 0;
> -		dir_hash_add(hashtab,
> -			libxfs_da_hashname((uchar_t *)dep->name, dep->namelen),
> -			addr, dep->name[0] == '/');
> +		if (!dir_hash_add(hashtab, addr, inum, dep->namelen, 
> +				dep->name)) {
> +			do_warn(
> +		_("entry \"%s\" (ino %llu) in dir %llu is a duplicate name"),
> +				fname, inum, ip->i_ino);
> +			if (!no_modify) {
> +				if (verbose)
> +					do_warn(
> +					_(", marking entry to be junked\n"));
> +				else
> +					do_warn("\n");
> +			} else {
> +				do_warn(_(", would junk entry\n"));
> +			}
> +			dep->name[0] = '/';
> +		}
>  		/*
>  		 * skip bogus entries (leading '/').  they'll be deleted
>  		 * later.  must still log it, else we leak references to
> @@ -2029,7 +2159,7 @@ longform_dir2_entry_check_data(
>  		junkit = 0;
>  		bcopy(dep->name, fname, dep->namelen);
>  		fname[dep->namelen] = '\0';
> -		ASSERT(INT_GET(dep->inumber, ARCH_CONVERT) != NULLFSINO);
> +		ASSERT(inum != NULLFSINO);
>  		/*
>  		 * skip the '..' entry since it's checked when the
>  		 * directory is reached by something else.  if it never
> @@ -2039,7 +2169,7 @@ longform_dir2_entry_check_data(
>  		if (dep->namelen == 2 && dep->name[0] == '.' &&
>  		    dep->name[1] == '.')
>  			continue;
> -		ASSERT(no_modify || !verify_inum(mp, INT_GET(dep->inumber, ARCH_CONVERT)));
> +		ASSERT(no_modify || !verify_inum(mp, inum));
>  		/*
>  		 * special case the . entry.  we know there's only one
>  		 * '.' and only '.' points to itself because bogus entries
> @@ -2049,7 +2179,7 @@ longform_dir2_entry_check_data(
>  		 * '..' is already accounted for or will be taken care
>  		 * of when directory is moved to orphanage.
>  		 */
> -		if (ip->i_ino == INT_GET(dep->inumber, ARCH_CONVERT))  {
> +		if (ip->i_ino == inum)  {
>  			ASSERT(dep->name[0] == '.' && dep->namelen == 1);
>  			add_inode_ref(current_irec, current_ino_offset);
>  			*need_dot = 0;
> @@ -2062,23 +2192,18 @@ longform_dir2_entry_check_data(
>  		 * just skip it.  no need to process it and it's ..
>  		 * link is already accounted for.
>  		 */
> -		if (INT_GET(dep->inumber, ARCH_CONVERT) == orphanage_ino &&
> -		    strcmp(fname, ORPHANAGE) == 0)
> +		if (inum == orphanage_ino && strcmp(fname, ORPHANAGE) == 0)
>  			continue;
>  		/*
>  		 * skip entries with bogus inumbers if we're in no modify mode
>  		 */
> -		if (no_modify &&
> -		    verify_inum(mp, INT_GET(dep->inumber, ARCH_CONVERT)))
> +		if (no_modify && verify_inum(mp, inum))
>  			continue;
>  		/*
>  		 * ok, now handle the rest of the cases besides '.' and '..'
>  		 */
> -		irec = find_inode_rec(
> -			XFS_INO_TO_AGNO(mp,
> -				INT_GET(dep->inumber, ARCH_CONVERT)),
> -			XFS_INO_TO_AGINO(mp,
> -				INT_GET(dep->inumber, ARCH_CONVERT)));
> +		irec = find_inode_rec(XFS_INO_TO_AGNO(mp, inum),
> +					XFS_INO_TO_AGINO(mp, inum));
>  		if (irec == NULL)  {
>  			nbad++;
>  			do_warn(_("entry \"%s\" in directory inode %llu points "
> @@ -2093,9 +2218,7 @@ longform_dir2_entry_check_data(
>  			}
>  			continue;
>  		}
> -		ino_offset = XFS_INO_TO_AGINO(mp,
> -				INT_GET(dep->inumber, ARCH_CONVERT)) -
> -					irec->ino_startnum;
> +		ino_offset = XFS_INO_TO_AGINO(mp, inum) - irec->ino_startnum;
>  		/*
>  		 * if it's a free inode, blow out the entry.
>  		 * by now, any inode that we think is free
> @@ -2106,18 +2229,13 @@ longform_dir2_entry_check_data(
>  			 * don't complain if this entry points to the old
>  			 * and now-free lost+found inode
>  			 */
> -			if (verbose || no_modify ||
> -			    INT_GET(dep->inumber, ARCH_CONVERT) !=
> -			    old_orphanage_ino)
> +			if (verbose || no_modify || inum != old_orphanage_ino)
>  				do_warn(
>  	_("entry \"%s\" in directory inode %llu points to free inode %llu"),
> -					fname, ip->i_ino,
> -					INT_GET(dep->inumber, ARCH_CONVERT));
> +					fname, ip->i_ino, inum);
>  			nbad++;
>  			if (!no_modify)  {
> -				if (verbose ||
> -				    INT_GET(dep->inumber, ARCH_CONVERT) !=
> -				    old_orphanage_ino)
> +				if (verbose || inum != old_orphanage_ino)
>  					do_warn(
>  					_(", marking entry to be junked\n"));
>  				else
> @@ -2130,28 +2248,6 @@ longform_dir2_entry_check_data(
>  			continue;
>  		}
>  		/*
> -		 * check for duplicate names in directory.
> -		 */ 
> -		if (!name_hash_add(nametab, dep->name, dep->namelen)) {
> -			do_warn(
> -		_("entry \"%s\" (ino %llu) in dir %llu is a duplicate name"),
> -				fname, INT_GET(dep->inumber, ARCH_CONVERT),
> -				ip->i_ino);
> -			nbad++;
> -			if (!no_modify) {
> -				if (verbose)
> -					do_warn(
> -					_(", marking entry to be junked\n"));
> -				else
> -					do_warn("\n");
> -				dep->name[0] = '/';
> -				libxfs_dir2_data_log_entry(tp, bp, dep);
> -			} else {
> -				do_warn(_(", would junk entry\n"));
> -			}
> -			continue;
> -		}
> -		/*
>  		 * check easy case first, regular inode, just bump
>  		 * the link count and continue
>  		 */
> @@ -2172,22 +2268,17 @@ longform_dir2_entry_check_data(
>  			junkit = 1;
>  			do_warn(
>  _("entry \"%s\" in dir %llu points to an already connected directory inode %llu,\n"),
> -				fname, ip->i_ino,
> -				INT_GET(dep->inumber, ARCH_CONVERT));
> +				fname, ip->i_ino, inum);
>  		} else if (parent == ip->i_ino)  {
>  			add_inode_reached(irec, ino_offset);
>  			add_inode_ref(current_irec, current_ino_offset);
> -			if (!is_inode_refchecked(
> -				INT_GET(dep->inumber, ARCH_CONVERT), irec,
> -					ino_offset))
> -				push_dir(stack,
> -					INT_GET(dep->inumber, ARCH_CONVERT));
> +			if (!is_inode_refchecked(inum, irec, ino_offset))
> +				push_dir(stack, inum);
>  		} else  {
>  			junkit = 1;
>  			do_warn(
>  _("entry \"%s\" in dir inode %llu inconsistent with .. value (%llu) in ino %llu,\n"),
> -				fname, ip->i_ino, parent,
> -				INT_GET(dep->inumber, ARCH_CONVERT));
> +				fname, ip->i_ino, parent, inum);
>  		}
>  		if (junkit)  {
>  			junkit = 0;
> @@ -2195,9 +2286,7 @@ _("entry \"%s\" in dir inode %llu incons
>  			if (!no_modify)  {
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(tp, bp, dep);
> -				if (verbose ||
> -				    INT_GET(dep->inumber, ARCH_CONVERT) !=
> -				    old_orphanage_ino)
> +				if (verbose || inum != old_orphanage_ino)
>  					do_warn(
>  					_("\twill clear entry \"%s\"\n"),
>  						fname);
> @@ -2212,8 +2301,6 @@ _("entry \"%s\" in dir inode %llu incons
>  		libxfs_dir2_data_freescan(mp, d, &needlog, NULL);
>  	if (needlog)
>  		libxfs_dir2_data_log_header(tp, bp);
> -	else if (!isblock && !nbad)
> -		libxfs_da_brelse(tp, bp);
>  	libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
>  	libxfs_trans_commit(tp, 0, 0);
>  	freetab->ents[db].v = INT_GET(d->hdr.bestfree[0].length, ARCH_CONVERT);
> @@ -2306,19 +2393,19 @@ longform_dir2_check_node(
>  	xfs_fileoff_t		next_da_bno;
>  	int			seeval = 0;
>  	int			used;
> -
> +	
>  	for (da_bno = mp->m_dirleafblk, next_da_bno = 0;
>  	     next_da_bno != NULLFILEOFF && da_bno < mp->m_dirfreeblk;
>  	     da_bno = (xfs_dablk_t)next_da_bno) {
>  		next_da_bno = da_bno + mp->m_dirblkfsbs - 1;
> -		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
> +		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK)) 
>  			break;
>  		if (libxfs_da_read_bufr(NULL, ip, da_bno, -1, &bp,
>  				XFS_DATA_FORK)) {
> -			do_error(
> -			_("can't read block %u for directory inode %llu\n"),
> +			do_warn(
> +			_("can't read leaf block %u for directory inode %llu\n"),
>  				da_bno, ip->i_ino);
> -			/* NOTREACHED */
> +			return 1;
>  		}
>  		leaf = bp->data;
>  		if (INT_GET(leaf->hdr.info.magic, ARCH_CONVERT) !=
> @@ -2348,23 +2435,24 @@ longform_dir2_check_node(
>  		seeval = dir_hash_see_all(hashtab, leaf->ents, INT_GET(leaf->hdr.count, ARCH_CONVERT),
>  			INT_GET(leaf->hdr.stale, ARCH_CONVERT));
>  		libxfs_da_brelse(NULL, bp);
> -		if (seeval != DIR_HASH_CK_OK)
> +		if (seeval != DIR_HASH_CK_OK) 
>  			return 1;
>  	}
> -	if (dir_hash_check(hashtab, ip, seeval))
> +	if (dir_hash_check(hashtab, ip, seeval)) 
>  		return 1;
> +	
>  	for (da_bno = mp->m_dirfreeblk, next_da_bno = 0;
>  	     next_da_bno != NULLFILEOFF;
>  	     da_bno = (xfs_dablk_t)next_da_bno) {
>  		next_da_bno = da_bno + mp->m_dirblkfsbs - 1;
> -		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
> +		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK)) 
>  			break;
>  		if (libxfs_da_read_bufr(NULL, ip, da_bno, -1, &bp,
>  				XFS_DATA_FORK)) {
> -			do_error(_("can't read block %u for directory inode "
> -				   "%llu\n"),
> +			do_warn(
> +		_("can't read freespace block %u for directory inode %llu\n"),
>  				da_bno, ip->i_ino);
> -			/* NOTREACHED */
> +			return 1;
>  		}
>  		free = bp->data;
>  		fdb = XFS_DIR2_DA_TO_DB(mp, da_bno);
> @@ -2418,388 +2506,9 @@ longform_dir2_check_node(
>  }
>  
>  /*
> - * Rebuild a directory: set up.
> - * Turn it into a node-format directory with no contents in the
> - * upper area.  Also has correct freespace blocks.
> - */
> -void
> -longform_dir2_rebuild_setup(
> -	xfs_mount_t		*mp,
> -	xfs_ino_t		ino,
> -	xfs_inode_t		*ip,
> -	freetab_t		*freetab)
> -{
> -	xfs_da_args_t		args;
> -	int			committed;
> -	xfs_dir2_data_t		*data = NULL;
> -	xfs_dabuf_t		*dbp;
> -	int			error;
> -	xfs_dir2_db_t		fbno;
> -	xfs_dabuf_t		*fbp;
> -	xfs_fsblock_t		firstblock;
> -	xfs_bmap_free_t		flist;
> -	xfs_dir2_free_t		*free;
> -	int			i;
> -	int			j;
> -	xfs_dablk_t		lblkno;
> -	xfs_dabuf_t		*lbp;
> -	xfs_dir2_leaf_t		*leaf;
> -	int			nres;
> -	xfs_trans_t		*tp;
> -
> -	/* read first directory block */
> -	tp = libxfs_trans_alloc(mp, 0);
> -	nres = XFS_DAENTER_SPACE_RES(mp, XFS_DATA_FORK);
> -	error = libxfs_trans_reserve(tp,
> -		nres, XFS_CREATE_LOG_RES(mp), 0, XFS_TRANS_PERM_LOG_RES,
> -		XFS_CREATE_LOG_COUNT);
> -	if (error)
> -		res_failed(error);
> -	libxfs_trans_ijoin(tp, ip, 0);
> -	libxfs_trans_ihold(tp, ip);
> -	XFS_BMAP_INIT(&flist, &firstblock);
> -	if (libxfs_da_read_buf(tp, ip, mp->m_dirdatablk, -2, &dbp,
> -			XFS_DATA_FORK)) {
> -		do_error(_("can't read block %u for directory inode %llu\n"),
> -			mp->m_dirdatablk, ino);
> -		/* NOTREACHED */
> -	}
> -
> -	if (dbp)
> -		data = dbp->data;
> -
> -	/* check for block format directory */
> -	if (data &&
> -	    INT_GET((data)->hdr.magic, ARCH_CONVERT) == XFS_DIR2_BLOCK_MAGIC) {
> -		xfs_dir2_block_t	*block;
> -		xfs_dir2_leaf_entry_t	*blp;
> -		xfs_dir2_block_tail_t	*btp;
> -		int			needlog;
> -		int			needscan;
> -
> -		/* convert directory block from block format to data format */
> -		INT_SET(data->hdr.magic, ARCH_CONVERT, XFS_DIR2_DATA_MAGIC);
> -
> -		/* construct freelist */
> -		block = (xfs_dir2_block_t *)data;
> -		btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
> -		blp = XFS_DIR2_BLOCK_LEAF_P(btp);
> -		needlog = needscan = 0;
> -		libxfs_dir2_data_make_free(tp, dbp, (char *)blp - (char *)block,
> -			(char *)block + mp->m_dirblksize - (char *)blp,
> -			&needlog, &needscan);
> -		if (needscan)
> -			libxfs_dir2_data_freescan(mp, data, &needlog, NULL);
> -		libxfs_da_log_buf(tp, dbp, 0, mp->m_dirblksize - 1);
> -	} else if (dbp) {
> -		libxfs_da_brelse(tp, dbp);
> -	}
> -
> -	/* allocate blocks for btree */
> -	bzero(&args, sizeof(args));
> -	args.trans = tp;
> -	args.dp = ip;
> -	args.whichfork = XFS_DATA_FORK;
> -	args.firstblock = &firstblock;
> -	args.flist = &flist;
> -	args.total = nres;
> -	if ((error = libxfs_da_grow_inode(&args, &lblkno)) ||
> -	    (error = libxfs_da_get_buf(tp, ip, lblkno, -1, &lbp, XFS_DATA_FORK))) {
> -		do_error(_("can't add btree block to directory inode %llu\n"),
> -			ino);
> -		/* NOTREACHED */
> -	}
> -	leaf = lbp->data;
> -	bzero(leaf, mp->m_dirblksize);
> -	INT_SET(leaf->hdr.info.magic, ARCH_CONVERT, XFS_DIR2_LEAFN_MAGIC);
> -	libxfs_da_log_buf(tp, lbp, 0, mp->m_dirblksize - 1);
> -	libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
> -	libxfs_trans_commit(tp, 0, 0);
> -
> -	for (i = 0; i < freetab->nents; i += XFS_DIR2_MAX_FREE_BESTS(mp)) {
> -		tp = libxfs_trans_alloc(mp, 0);
> -		nres = XFS_DAENTER_SPACE_RES(mp, XFS_DATA_FORK);
> -		error = libxfs_trans_reserve(tp,
> -			nres, XFS_CREATE_LOG_RES(mp), 0, XFS_TRANS_PERM_LOG_RES,
> -			XFS_CREATE_LOG_COUNT);
> -		if (error)
> -			res_failed(error);
> -		libxfs_trans_ijoin(tp, ip, 0);
> -		libxfs_trans_ihold(tp, ip);
> -		XFS_BMAP_INIT(&flist, &firstblock);
> -		bzero(&args, sizeof(args));
> -		args.trans = tp;
> -		args.dp = ip;
> -		args.whichfork = XFS_DATA_FORK;
> -		args.firstblock = &firstblock;
> -		args.flist = &flist;
> -		args.total = nres;
> -		if ((error = libxfs_dir2_grow_inode(&args, XFS_DIR2_FREE_SPACE,
> -						 &fbno)) ||
> -		    (error = libxfs_da_get_buf(tp, ip, XFS_DIR2_DB_TO_DA(mp, fbno),
> -					    -1, &fbp, XFS_DATA_FORK))) {
> -			do_error(_("can't add free block to directory inode "
> -				   "%llu\n"),
> -				ino);
> -			/* NOTREACHED */
> -		}
> -		free = fbp->data;
> -		bzero(free, mp->m_dirblksize);
> -		INT_SET(free->hdr.magic, ARCH_CONVERT, XFS_DIR2_FREE_MAGIC);
> -		INT_SET(free->hdr.firstdb, ARCH_CONVERT, i);
> -		INT_SET(free->hdr.nvalid, ARCH_CONVERT, XFS_DIR2_MAX_FREE_BESTS(mp));
> -		if (i + INT_GET(free->hdr.nvalid, ARCH_CONVERT) > freetab->nents)
> -			INT_SET(free->hdr.nvalid, ARCH_CONVERT, freetab->nents - i);
> -		for (j = 0; j < INT_GET(free->hdr.nvalid, ARCH_CONVERT); j++) {
> -			INT_SET(free->bests[j], ARCH_CONVERT, freetab->ents[i + j].v);
> -			if (INT_GET(free->bests[j], ARCH_CONVERT) != NULLDATAOFF)
> -				INT_MOD(free->hdr.nused, ARCH_CONVERT, +1);
> -		}
> -		libxfs_da_log_buf(tp, fbp, 0, mp->m_dirblksize - 1);
> -		libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
> -		libxfs_trans_commit(tp, 0, 0);
> -	}
> -}
> -
> -/*
> - * Rebuild the entries from a single data block.
> - */
> -void
> -longform_dir2_rebuild_data(
> -	xfs_mount_t		*mp,
> -	xfs_ino_t		ino,
> -	xfs_inode_t		*ip,
> -	xfs_dablk_t		da_bno)
> -{
> -	xfs_dabuf_t		*bp;
> -	xfs_dir2_block_tail_t	*btp;
> -	int			committed;
> -	xfs_dir2_data_t		*data;
> -	xfs_dir2_db_t		dbno;
> -	xfs_dir2_data_entry_t	*dep;
> -	xfs_dir2_data_unused_t	*dup;
> -	char			*endptr;
> -	int			error;
> -	xfs_dir2_free_t		*fblock;
> -	xfs_dabuf_t		*fbp;
> -	xfs_dir2_db_t		fdb;
> -	int			fi;
> -	xfs_fsblock_t		firstblock;
> -	xfs_bmap_free_t		flist;
> -	int			needlog;
> -	int			needscan;
> -	int			nres;
> -	char			*ptr;
> -	xfs_trans_t		*tp;
> -
> -	if (libxfs_da_read_buf(NULL, ip, da_bno, da_bno == 0 ? -2 : -1, &bp,
> -			XFS_DATA_FORK)) {
> -		do_error(_("can't read block %u for directory inode %llu\n"),
> -			da_bno, ino);
> -		/* NOTREACHED */
> -	}
> -	if (da_bno == 0 && bp == NULL)
> -		/*
> -		 * The block was punched out.
> -		 */
> -		return;
> -	ASSERT(bp);
> -	dbno = XFS_DIR2_DA_TO_DB(mp, da_bno);
> -	fdb = XFS_DIR2_DB_TO_FDB(mp, dbno);
> -	if (libxfs_da_read_buf(NULL, ip, XFS_DIR2_DB_TO_DA(mp, fdb), -1, &fbp,
> -			XFS_DATA_FORK)) {
> -		do_error(_("can't read block %u for directory inode %llu\n"),
> -			XFS_DIR2_DB_TO_DA(mp, fdb), ino);
> -		/* NOTREACHED */
> -	}
> -	data = malloc(mp->m_dirblksize);
> -	if (!data) {
> -		do_error(
> -		_("malloc failed in longform_dir2_rebuild_data (%u bytes)\n"),
> -			mp->m_dirblksize);
> -		exit(1);
> -	}
> -	bcopy(bp->data, data, mp->m_dirblksize);
> -	ptr = (char *)data->u;
> -	if (INT_GET(data->hdr.magic, ARCH_CONVERT) == XFS_DIR2_BLOCK_MAGIC) {
> -		btp = XFS_DIR2_BLOCK_TAIL_P(mp, (xfs_dir2_block_t *)data);
> -		endptr = (char *)XFS_DIR2_BLOCK_LEAF_P(btp);
> -	} else
> -		endptr = (char *)data + mp->m_dirblksize;
> -	fblock = fbp->data;
> -	fi = XFS_DIR2_DB_TO_FDINDEX(mp, dbno);
> -	tp = libxfs_trans_alloc(mp, 0);
> -	error = libxfs_trans_reserve(tp, 0, XFS_CREATE_LOG_RES(mp), 0,
> -		XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
> -	if (error)
> -		res_failed(error);
> -	libxfs_trans_ijoin(tp, ip, 0);
> -	libxfs_trans_ihold(tp, ip);
> -	libxfs_da_bjoin(tp, bp);
> -	libxfs_da_bhold(tp, bp);
> -	libxfs_da_bjoin(tp, fbp);
> -	libxfs_da_bhold(tp, fbp);
> -	XFS_BMAP_INIT(&flist, &firstblock);
> -	needlog = needscan = 0;
> -	bzero(((xfs_dir2_data_t *)(bp->data))->hdr.bestfree,
> -		sizeof(data->hdr.bestfree));
> -	libxfs_dir2_data_make_free(tp, bp, (xfs_dir2_data_aoff_t)sizeof(data->hdr),
> -		mp->m_dirblksize - sizeof(data->hdr), &needlog, &needscan);
> -	ASSERT(needscan == 0);
> -	libxfs_dir2_data_log_header(tp, bp);
> -	INT_SET(fblock->bests[fi], ARCH_CONVERT,
> -		INT_GET(((xfs_dir2_data_t *)(bp->data))->hdr.bestfree[0].length, ARCH_CONVERT));
> -	libxfs_dir2_free_log_bests(tp, fbp, fi, fi);
> -	libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
> -	libxfs_trans_commit(tp, 0, 0);
> -
> -	while (ptr < endptr) {
> -		dup = (xfs_dir2_data_unused_t *)ptr;
> -		if (INT_GET(dup->freetag, ARCH_CONVERT) == XFS_DIR2_DATA_FREE_TAG) {
> -			ptr += INT_GET(dup->length, ARCH_CONVERT);
> -			continue;
> -		}
> -		dep = (xfs_dir2_data_entry_t *)ptr;
> -		ptr += XFS_DIR2_DATA_ENTSIZE(dep->namelen);
> -		if (dep->name[0] == '/')
> -			continue;
> -		tp = libxfs_trans_alloc(mp, 0);
> -		nres = XFS_CREATE_SPACE_RES(mp, dep->namelen);
> -		error = libxfs_trans_reserve(tp, nres, XFS_CREATE_LOG_RES(mp), 0,
> -			XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
> -		if (error)
> -			res_failed(error);
> -		libxfs_trans_ijoin(tp, ip, 0);
> -		libxfs_trans_ihold(tp, ip);
> -		libxfs_da_bjoin(tp, bp);
> -		libxfs_da_bhold(tp, bp);
> -		libxfs_da_bjoin(tp, fbp);
> -		libxfs_da_bhold(tp, fbp);
> -		XFS_BMAP_INIT(&flist, &firstblock);
> -		error = dir_createname(mp, tp, ip, (char *)dep->name,
> -			dep->namelen, INT_GET(dep->inumber, ARCH_CONVERT),
> -			&firstblock, &flist, nres);
> -		ASSERT(error == 0);
> -		libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
> -		libxfs_trans_commit(tp, 0, 0);
> -	}
> -	libxfs_da_brelse(NULL, bp);
> -	libxfs_da_brelse(NULL, fbp);
> -	free(data);
> -}
> -
> -/*
> - * Finish the rebuild of a directory.
> - * Stuff / in and then remove it, this forces the directory to end
> - * up in the right format.
> - */
> -void
> -longform_dir2_rebuild_finish(
> -	xfs_mount_t		*mp,
> -	xfs_ino_t		ino,
> -	xfs_inode_t		*ip)
> -{
> -	int			committed;
> -	int			error;
> -	xfs_fsblock_t		firstblock;
> -	xfs_bmap_free_t		flist;
> -	int			nres;
> -	xfs_trans_t		*tp;
> -
> -	tp = libxfs_trans_alloc(mp, 0);
> -	nres = XFS_CREATE_SPACE_RES(mp, 1);
> -	error = libxfs_trans_reserve(tp, nres, XFS_CREATE_LOG_RES(mp), 0,
> -		XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
> -	if (error)
> -		res_failed(error);
> -	libxfs_trans_ijoin(tp, ip, 0);
> -	libxfs_trans_ihold(tp, ip);
> -	XFS_BMAP_INIT(&flist, &firstblock);
> -	error = dir_createname(mp, tp, ip, "/", 1, ino,
> -			&firstblock, &flist, nres);
> -	ASSERT(error == 0);
> -	libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
> -	libxfs_trans_commit(tp, 0, 0);
> -
> -	/* could kill trailing empty data blocks here */
> -
> -	tp = libxfs_trans_alloc(mp, 0);
> -	nres = XFS_REMOVE_SPACE_RES(mp);
> -	error = libxfs_trans_reserve(tp, nres, XFS_REMOVE_LOG_RES(mp), 0,
> -		XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
> -	if (error)
> -		res_failed(error);
> -	libxfs_trans_ijoin(tp, ip, 0);
> -	libxfs_trans_ihold(tp, ip);
> -	XFS_BMAP_INIT(&flist, &firstblock);
> -	error = dir_removename(mp, tp, ip, "/", 1, ino,
> -			&firstblock, &flist, nres);
> -	ASSERT(error == 0);
> -	libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
> -	libxfs_trans_commit(tp, 0, 0);
> -}
> -
> -/*
> - * Rebuild a directory.
> - * Remove all the non-data blocks.
> - * Re-initialize to (empty) node form.
> - * Loop over the data blocks reinserting each entry.
> - * Force the directory into the right format.
> - */
> -void
> -longform_dir2_rebuild(
> -	xfs_mount_t	*mp,
> -	xfs_ino_t	ino,
> -	xfs_inode_t	*ip,
> -	int		*num_illegal,
> -	freetab_t	*freetab,
> -	int		isblock)
> -{
> -	xfs_dabuf_t	*bp;
> -	xfs_dablk_t	da_bno;
> -	xfs_fileoff_t	next_da_bno;
> -
> -	do_warn(_("rebuilding directory inode %llu\n"), ino);
> -
> -	/* kill leaf blocks */
> -	for (da_bno = mp->m_dirleafblk, next_da_bno = isblock ? NULLFILEOFF : 0;
> -	     next_da_bno != NULLFILEOFF;
> -	     da_bno = (xfs_dablk_t)next_da_bno) {
> -		next_da_bno = da_bno + mp->m_dirblkfsbs - 1;
> -		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
> -			break;
> -		if (libxfs_da_get_buf(NULL, ip, da_bno, -1, &bp, XFS_DATA_FORK)) {
> -			do_error(_("can't get block %u for directory inode "
> -				   "%llu\n"),
> -				da_bno, ino);
> -			/* NOTREACHED */
> -		}
> -		dir2_kill_block(mp, ip, da_bno, bp);
> -	}
> -
> -	/* rebuild empty btree and freelist */
> -	longform_dir2_rebuild_setup(mp, ino, ip, freetab);
> -
> -	/* rebuild directory */
> -	for (da_bno = mp->m_dirdatablk, next_da_bno = 0;
> -	     da_bno < mp->m_dirleafblk && next_da_bno != NULLFILEOFF;
> -	     da_bno = (xfs_dablk_t)next_da_bno) {
> -		next_da_bno = da_bno + mp->m_dirblkfsbs - 1;
> -		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
> -			break;
> -		longform_dir2_rebuild_data(mp, ino, ip, da_bno);
> -	}
> -
> -	/* put the directory in the appropriate on-disk format */
> -	longform_dir2_rebuild_finish(mp, ino, ip);
> -	*num_illegal = 0;
> -}
> -
> -/*
> - * succeeds or dies, inode never gets dirtied since all changes
> - * happen in file blocks.  the inode size and other core info
> - * is already correct, it's just the leaf entries that get altered.
> - * XXX above comment is wrong for v2 - need to see why it matters
> + * If a directory is corrupt, we need to read in as many entries as possible,
> + * destroy the entry and create a new one with recovered name/inode pairs.
> + * (ie. get libxfs to do all the grunt work)
>   */
>  void
>  longform_dir2_entry_check(xfs_mount_t	*mp,
> @@ -2810,15 +2519,14 @@ longform_dir2_entry_check(xfs_mount_t	*m
>  			dir_stack_t	*stack,
>  			ino_tree_node_t	*irec,
>  			int		ino_offset,
> -			name_hash_tab_t	*nametab)
> +			dir_hash_tab_t	*hashtab)
>  {
>  	xfs_dir2_block_t	*block;
>  	xfs_dir2_leaf_entry_t	*blp;
> -	xfs_dabuf_t		*bp;
> +	xfs_dabuf_t		**bplist;
>  	xfs_dir2_block_tail_t	*btp;
>  	xfs_dablk_t		da_bno;
>  	freetab_t		*freetab;
> -	dir_hash_tab_t		*hashtab;
>  	int			i;
>  	int			isblock;
>  	int			isleaf;
> @@ -2840,6 +2548,7 @@ longform_dir2_entry_check(xfs_mount_t	*m
>  		freetab->ents[i].v = NULLDATAOFF;
>  		freetab->ents[i].s = 0;
>  	}
> +	bplist = calloc(freetab->naents, sizeof(xfs_dabuf_t*));
>  	/* is this a block, leaf, or node directory? */
>  	libxfs_dir2_isblock(NULL, ip, &isblock);
>  	libxfs_dir2_isleaf(NULL, ip, &isleaf);
> @@ -2847,50 +2556,58 @@ longform_dir2_entry_check(xfs_mount_t	*m
>  	if (do_prefetch && !isblock)
>  		prefetch_p6_dir2(mp, ip);
>  
> -	/* check directory data */
> -	hashtab = dir_hash_init(ip->i_d.di_size);
> +	/* check directory "data" blocks (ie. name/inode pairs) */
>  	for (da_bno = 0, next_da_bno = 0;
>  	     next_da_bno != NULLFILEOFF && da_bno < mp->m_dirleafblk;
>  	     da_bno = (xfs_dablk_t)next_da_bno) {
>  		next_da_bno = da_bno + mp->m_dirblkfsbs - 1;
> +		ASSERT(XFS_DIR2_DA_TO_DB(mp, da_bno) < freetab->naents);
>  		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
>  			break;
> -		if (libxfs_da_read_bufr(NULL, ip, da_bno,
> -				da_bno == 0 ? -2 : -1, &bp, XFS_DATA_FORK)) {
> -			do_error(_("can't read block %u for directory inode "
> -				   "%llu\n"),
> +		if (libxfs_da_read_bufr(NULL, ip, da_bno, -1, 
> +				&bplist[XFS_DIR2_DA_TO_DB(mp, da_bno)], 
> +				XFS_DATA_FORK)) {
> +			do_warn(_(
> +			"can't read data block %u for directory inode %llu\n"),
>  				da_bno, ino);
> -			/* NOTREACHED */
> +			*num_illegal++;
> +			continue;	/* try and read all "data" blocks */
>  		}
> -		/* is there a hole at the start? */
> -		if (da_bno == 0 && bp == NULL)
> -			continue;
>  		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
> -			stack, irec, ino_offset, &bp, hashtab, &freetab, 
> -			nametab, da_bno, isblock);
> -		/* it releases the buffer unless isblock is set */
> +				stack, irec, ino_offset, 
> +				&bplist[XFS_DIR2_DA_TO_DB(mp, da_bno)], hashtab,  
> +				&freetab, da_bno, isblock);
>  	}
>  	fixit = (*num_illegal != 0) || dir2_is_badino(ino);
>  
>  	/* check btree and freespace */
>  	if (isblock) {
> -		ASSERT(bp);
> -		block = bp->data;
> +		block = bplist[0]->data;
>  		btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
>  		blp = XFS_DIR2_BLOCK_LEAF_P(btp);
> -		seeval = dir_hash_see_all(hashtab, blp, INT_GET(btp->count, ARCH_CONVERT), INT_GET(btp->stale,
> ARCH_CONVERT));
> +		seeval = dir_hash_see_all(hashtab, blp, 
> +				INT_GET(btp->count, ARCH_CONVERT), 
> +				INT_GET(btp->stale, ARCH_CONVERT));
>  		if (dir_hash_check(hashtab, ip, seeval))
>  			fixit |= 1;
> -		libxfs_da_brelse(NULL, bp);
>  	} else if (isleaf) {
>  		fixit |= longform_dir2_check_leaf(mp, ip, hashtab, freetab);
>  	} else {
>  		fixit |= longform_dir2_check_node(mp, ip, hashtab, freetab);
>  	}
> -	dir_hash_done(hashtab);
> -	if (!no_modify && fixit)
> -		longform_dir2_rebuild(mp, ino, ip, num_illegal, freetab,
> -			isblock);
> +	if (!no_modify && fixit) {
> +		dir_hash_dup_names(hashtab);
> +		for (i = 0; i < freetab->naents; i++) 
> +			if (bplist[i])
> +				libxfs_da_brelse(NULL, bplist[i]);
> +		longform_dir2_rebuild(mp, ino, ip, hashtab);
> +		*num_illegal = 0;
> +	} else {
> +		for (i = 0; i < freetab->naents; i++) 
> +			if (bplist[i])
> +				libxfs_da_brelse(NULL, bplist[i]);
> +	}
> +	
>  	free(freetab);
>  }
>  
> @@ -2906,7 +2623,7 @@ shortform_dir_entry_check(xfs_mount_t	*m
>  			dir_stack_t	*stack,
>  			ino_tree_node_t	*current_irec,
>  			int		current_ino_offset,
> -			name_hash_tab_t	*nametab)
> +			dir_hash_tab_t	*hashtab)
>  {
>  	xfs_ino_t		lino;
>  	xfs_ino_t		parent;
> @@ -3044,7 +2761,7 @@ _("entry \"%s\" in shortform dir %llu re
>  		ASSERT(irec != NULL);
>  
>  		ino_offset = XFS_INO_TO_AGINO(mp, lino) - irec->ino_startnum;
> -
> +		
>  		/*
>  		 * if it's a free inode, blow out the entry.
>  		 * by now, any inode that we think is free
> @@ -3066,8 +2783,9 @@ _("entry \"%s\" in shortform dir inode %
>  				do_warn(_("would junk entry \"%s\"\n"),
>  					fname);
>  			}
> -		} else if (!name_hash_add(nametab, sf_entry->name, 
> -					sf_entry->namelen)) {
> +		} else if (!dir_hash_add(hashtab, 
> +				(xfs_dir2_dataptr_t)(sf_entry - &sf->list[0]),
> +				lino, sf_entry->namelen, sf_entry->name)) {
>  			/*
>  			 * check for duplicate names in directory.
>  			 */ 
> @@ -3311,7 +3029,7 @@ shortform_dir2_entry_check(xfs_mount_t	*
>  			dir_stack_t	*stack,
>  			ino_tree_node_t	*current_irec,
>  			int		current_ino_offset,
> -			name_hash_tab_t	*nametab)
> +			dir_hash_tab_t	*hashtab)
>  {
>  	xfs_ino_t		lino;
>  	xfs_ino_t		parent;
> @@ -3484,7 +3202,9 @@ shortform_dir2_entry_check(xfs_mount_t	*
>  				do_warn(_("would junk entry \"%s\"\n"),
>  					fname);
>  			}
> -		} else if (!name_hash_add(nametab, sfep->name, sfep->namelen)) {
> +		} else if (!dir_hash_add(hashtab, (xfs_dir2_dataptr_t)
> +					(sfep - XFS_DIR2_SF_FIRSTENTRY(sfp)),
> +				lino, sfep->namelen, sfep->name)) {
>  			/*
>  			 * check for duplicate names in directory.
>  			 */ 
> @@ -3650,7 +3370,7 @@ process_dirstack(xfs_mount_t *mp, dir_st
>  	xfs_trans_t		*tp;
>  	xfs_dahash_t		hashval;
>  	ino_tree_node_t		*irec;
> -	name_hash_tab_t		*nametab;
> +	dir_hash_tab_t		*hashtab;
>  	int			ino_offset, need_dot, committed;
>  	int			dirty, num_illegal, error, nres;
>  
> @@ -3731,7 +3451,7 @@ process_dirstack(xfs_mount_t *mp, dir_st
>  
>  		add_inode_refchecked(ino, irec, ino_offset);
>  
> -		nametab = name_hash_init(ip->i_d.di_size);
> +		hashtab = dir_hash_init(ip->i_d.di_size);
>  
>  		/*
>  		 * look for bogus entries
> @@ -3750,13 +3470,13 @@ process_dirstack(xfs_mount_t *mp, dir_st
>  							&num_illegal, &need_dot,
>  							stack, irec,
>  							ino_offset,
> -							nametab);
> +							hashtab);
>  			else
>  				longform_dir_entry_check(mp, ino, ip,
>  							&num_illegal, &need_dot,
>  							stack, irec,
>  							ino_offset,
> -							nametab);
> +							hashtab);
>  			break;
>  		case XFS_DINODE_FMT_LOCAL:
>  			tp = libxfs_trans_alloc(mp, 0);
> @@ -3781,12 +3501,12 @@ process_dirstack(xfs_mount_t *mp, dir_st
>  				shortform_dir2_entry_check(mp, ino, ip, &dirty,
>  							stack, irec,
>  							ino_offset,
> -							nametab);
> +							hashtab);
>  			else
>  				shortform_dir_entry_check(mp, ino, ip, &dirty,
>  							stack, irec,
>  							ino_offset,
> -							nametab);
> +							hashtab);
>  
>  			ASSERT(dirty == 0 || (dirty && !no_modify));
>  			if (dirty)  {
> @@ -3801,7 +3521,7 @@ process_dirstack(xfs_mount_t *mp, dir_st
>  		default:
>  			break;
>  		}
> -		name_hash_done(nametab);
> +		dir_hash_done(hashtab);
>  
>  		hashval = 0;
>  
> 
> 
> 

-- 
Nathan
