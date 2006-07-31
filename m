Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Jul 2006 02:36:36 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6V9ZoDW028643
	for <xfs@oss.sgi.com>; Mon, 31 Jul 2006 02:36:04 -0700
Received: from omx2.sgi.com ([198.149.32.25])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k6V7Esnx020208
	for <xfs@oss.sgi.com>; Mon, 31 Jul 2006 02:14:54 -0500
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with SMTP id k6V9hGf9021311
	for <xfs@oss.sgi.com>; Mon, 31 Jul 2006 02:43:18 -0700
Message-Id: <200607310714.RAA03415@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: Review: xfs_repair fixes for dir2 corruption
Date: Mon, 31 Jul 2006 17:18:56 +1000
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_00F7_01C6B4C5.684DBD40"
In-Reply-To: <44CA22F8.2040507@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Madan Valluri' <mvalluri@sgi.com>, 'Nathan Scott' <nathans@sgi.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_00F7_01C6B4C5.684DBD40
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Madan Valluri
> Sent: Saturday, 29 July 2006 12:45 AM
> To: Nathan Scott
> Cc: Barry Naujok; xfs@oss.sgi.com
> Subject: Re: Review: xfs_repair fixes for dir2 corruption
> 
> Nathan Scott wrote:
> > On Fri, Jul 28, 2006 at 11:58:52AM +1000, Barry Naujok wrote:
> >   
> >> This patch addresses the following xfs_repair issues:
> >>     
> >
> > The libxfs cache stuff looks good to me.  Maybe Madan can cast
> > an eye over the repair changes for ya?
> >
> > cheers.
> >
> >   
> >>  
> 1) Since dir_hash_add can be called for both V1 and V2 
> directories its 
> second parameter type xfs_dir2_dataptr_t should be neutral.

Ok, made it a __uint32_t.

> 2) In dir_hash_add when dup is set, do you still need to add to the 
> nextbyhash by list?

Good pickup. I set junk to 1 as well in the dup check.

> 3) The following statement in   longform_dir2_rebuild looks odd. 
> Besides, FWIW, you can match "/."
> 
>                 if (p->name[0] == '/' || (p->name[0] == '.' && 
> (p->namelen == 1
>                                 || (p->namelen == 2 && 
> p->name[1] == '.'))))
>                         continue;
> 
> Consider:
> 
>                if (((p->name[0] == '/' || p->name[0] == '.') && 
> p->namelen == 1) ||
>                         (p->name[0] == '.' && p->name[1] == '.' && 
> p->namelen == 2))
>                         continue;
> 
> 4) Related to items 2&3, shouldn't the code be skipping 
> duplicate entries?

That's exactly what the above is doing, it's skipping all entries starting with a "/" as they have been marked as bad,
and the "." and ".." entries which already exist after the libxfs_dir2_init() call.

> 5) Can we do anything to minimize the do_error calls in 
> longform_dir2_rebuild? Seems like on a full file system, while 
> rebuilding say the root directory, matters can get wacky - 
> The directory 
> is being rebuilt and we have no further room. Sounds like 
> that this how 
> it has been....

Done, now it will do what it can, and I do a flush before the lost+found creation which still has the do_error() calls.

Updated diff attached.

Thanks,
Barry

------=_NextPart_000_00F7_01C6B4C5.684DBD40
Content-Type: text/plain;
	name="diff.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="diff.txt"


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/include/cache.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/include/cache.h	2006-07-31 17:09:22.000000000 +1000
+++ b/xfsprogs/include/cache.h	2006-07-27 16:17:47.804986322 +1000
@@ -30,6 +30,7 @@ struct cache_node;
 typedef void *cache_key_t;
 typedef void (*cache_walk_t)(struct cache_node *);
 typedef struct cache_node * (*cache_node_alloc_t)(void);
+typedef void (*cache_node_flush_t)(struct cache_node *);
 typedef void (*cache_node_relse_t)(struct cache_node *);
 typedef unsigned int (*cache_node_hash_t)(cache_key_t, unsigned int);
 typedef int (*cache_node_compare_t)(struct cache_node *, cache_key_t);
@@ -38,6 +39,7 @@ typedef unsigned int (*cache_bulk_relse_
 struct cache_operations {
 	cache_node_hash_t	hash;
 	cache_node_alloc_t	alloc;
+	cache_node_flush_t	flush;
 	cache_node_relse_t	relse;
 	cache_node_compare_t	compare;
 	cache_bulk_relse_t	bulkrelse;	/* optional */
@@ -49,6 +51,7 @@ struct cache {
 	pthread_mutex_t		c_mutex;	/* node count mutex */
 	cache_node_hash_t	hash;		/* node hash function */
 	cache_node_alloc_t	alloc;		/* allocation function */
+	cache_node_flush_t	flush;		/* flush dirty data function */
 	cache_node_relse_t	relse;		/* memory free function */
 	cache_node_compare_t	compare;	/* comparison routine */
 	cache_bulk_relse_t	bulkrelse;	/* bulk release routine */
@@ -75,6 +78,7 @@ struct cache *cache_init(unsigned int, s
 void cache_destroy(struct cache *);
 void cache_walk(struct cache *, cache_walk_t);
 void cache_purge(struct cache *);
+void cache_flush(struct cache *);
=20
 int cache_node_get(struct cache *, cache_key_t, struct cache_node **);
 void cache_node_put(struct cache_node *);

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/include/libxfs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/include/libxfs.h	2006-07-31 17:09:22.000000000 +1000
+++ b/xfsprogs/include/libxfs.h	2006-07-31 16:42:58.384131150 +1000
@@ -257,6 +257,7 @@ extern int	libxfs_writebuf_int (xfs_buf_
 extern struct cache	*libxfs_bcache;
 extern struct cache_operations	libxfs_bcache_operations;
 extern void	libxfs_bcache_purge (void);
+extern void	libxfs_bcache_flush (void);
 extern xfs_buf_t	*libxfs_getbuf (dev_t, xfs_daddr_t, int);
 extern void	libxfs_putbuf (xfs_buf_t *);
 extern void	libxfs_purgebuf (xfs_buf_t *);
@@ -465,8 +466,11 @@ extern int	libxfs_bmapi_single(xfs_trans
 				xfs_fsblock_t *, xfs_fileoff_t);
 extern int	libxfs_bmap_finish (xfs_trans_t **, xfs_bmap_free_t *,
 				xfs_fsblock_t, int *);
+extern void	libxfs_bmap_cancel(xfs_bmap_free_t *);
 extern int	libxfs_bmap_next_offset (xfs_trans_t *, xfs_inode_t *,
 				xfs_fileoff_t *, int);
+extern int	libxfs_bmap_last_offset(xfs_trans_t *, xfs_inode_t *,=20
+				xfs_fileoff_t *, int);
 extern int	libxfs_bunmapi (xfs_trans_t *, xfs_inode_t *, xfs_fileoff_t,
 				xfs_filblks_t, int, xfs_extnum_t,
 				xfs_fsblock_t *, xfs_bmap_free_t *, int *);

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/libxfs/cache.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/libxfs/cache.c	2006-07-31 17:09:22.000000000 +1000
+++ b/xfsprogs/libxfs/cache.c	2006-07-27 17:42:43.812685388 +1000
@@ -60,6 +60,7 @@ cache_init(
 	cache->c_hashsize =3D hashsize;
 	cache->hash =3D cache_operations->hash;
 	cache->alloc =3D cache_operations->alloc;
+	cache->flush =3D cache_operations->flush;
 	cache->relse =3D cache_operations->relse;
 	cache->compare =3D cache_operations->compare;
 	cache->bulkrelse =3D cache_operations->bulkrelse ?
@@ -422,6 +423,39 @@ cache_purge(
 		cache_abort();
 	}
 #endif
+	/* flush any remaining nodes to disk */
+	cache_flush(cache);
+}
+
+/*
+ * Flush all nodes in the cache to disk.=20
+ */
+void
+cache_flush(
+	struct cache *		cache)
+{
+	struct cache_hash *	hash;
+	struct list_head *	head;
+	struct list_head *	pos;
+	struct cache_node *	node;
+	int			i;
+=09
+	if (!cache->flush)
+		return;
+=09
+	for (i =3D 0; i < cache->c_hashsize; i++) {
+		hash =3D &cache->c_hash[i];
+=09=09
+		pthread_mutex_lock(&hash->ch_mutex);
+		head =3D &hash->ch_list;
+		for (pos =3D head->next; pos !=3D head; pos =3D pos->next) {
+			node =3D (struct cache_node *)pos;
+			pthread_mutex_lock(&node->cn_mutex);
+			cache->flush(node);
+			pthread_mutex_unlock(&node->cn_mutex);
+		}
+		pthread_mutex_unlock(&hash->ch_mutex);
+	}
 }
=20
 #define	HASH_REPORT	(3*HASH_CACHE_RATIO)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/libxfs/rdwr.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/libxfs/rdwr.c	2006-07-31 17:09:22.000000000 +1000
+++ b/xfsprogs/libxfs/rdwr.c	2006-07-27 16:40:56.612373938 +1000
@@ -416,6 +416,15 @@ libxfs_iomove(xfs_buf_t *bp, uint boff,=20
 }
=20
 static void
+libxfs_bflush(struct cache_node *node)
+{
+	xfs_buf_t		*bp =3D (xfs_buf_t *)node;
+
+	if ((bp !=3D NULL) && (bp->b_flags & LIBXFS_B_DIRTY))
+		libxfs_writebufr(bp);
+}
+
+static void
 libxfs_brelse(struct cache_node *node)
 {
 	xfs_buf_t		*bp =3D (xfs_buf_t *)node;
@@ -442,9 +451,16 @@ libxfs_bcache_purge(void)
 	cache_purge(libxfs_bcache);
 }
=20
+void=20
+libxfs_bcache_flush(void)
+{
+	cache_flush(libxfs_bcache);
+}
+
 struct cache_operations libxfs_bcache_operations =3D {
 	/* .hash */	libxfs_bhash,
 	/* .alloc */	libxfs_balloc,
+	/* .flush */	libxfs_bflush,
 	/* .relse */	libxfs_brelse,
 	/* .compare */	libxfs_bcompare,
 	/* .bulkrelse */ NULL	/* TODO: lio_listio64 interface? */
@@ -649,6 +665,7 @@ libxfs_icache_purge(void)
 struct cache_operations libxfs_icache_operations =3D {
 	/* .hash */	libxfs_ihash,
 	/* .alloc */	libxfs_ialloc,
+	/* .flush */	NULL,
 	/* .relse */	libxfs_irelse,
 	/* .compare */	libxfs_icompare,
 	/* .bulkrelse */ NULL

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/libxfs/xfs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/libxfs/xfs.h	2006-07-31 17:09:22.000000000 +1000
+++ b/xfsprogs/libxfs/xfs.h	2006-07-31 16:26:28.040456032 +1000
@@ -97,7 +97,9 @@
 #define xfs_bmapi			libxfs_bmapi
 #define xfs_bmapi_single		libxfs_bmapi_single
 #define xfs_bmap_finish			libxfs_bmap_finish
+#define xfs_bmap_cancel			libxfs_bmap_cancel
 #define xfs_bmap_del_free		libxfs_bmap_del_free
+#define xfs_bmap_last_offset		libxfs_bmap_last_offset
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_free_extent			libxfs_free_extent
 #define xfs_rtfree_extent		libxfs_rtfree_extent

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/phase6.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/phase6.c	2006-07-31 17:09:22.000000000 +1000
+++ b/xfsprogs/repair/phase6.c	2006-07-31 16:37:03.134895653 +1000
@@ -36,43 +36,36 @@ static int orphanage_entered;
=20
 /*
  * Data structures and routines to keep track of directory entries
- * and whether their leaf entry has been seen
+ * and whether their leaf entry has been seen. Also used for name
+ * duplicate checking and rebuilding step if required.
  */
 typedef struct dir_hash_ent {
-	struct dir_hash_ent	*next;	/* pointer to next entry */
-	xfs_dir2_leaf_entry_t	ent;	/* address and hash value */
-	short			junkit;	/* name starts with / */
-	short			seen;	/* have seen leaf entry */
+	struct dir_hash_ent	*nextbyaddr;	/* next in addr bucket */
+	struct dir_hash_ent	*nextbyhash;	/* next in name bucket */
+	struct dir_hash_ent	*nextbyorder;	/* next in order added */
+	xfs_dahash_t		hashval;	/* hash value of name */
+	__uint32_t		address;	/* offset of data entry */
+	xfs_ino_t 		inum;		/* inode num of entry */
+	short			junkit;		/* name starts with / */
+	short			seen;		/* have seen leaf entry */
+	int	  	    	namelen;	/* length of name */
+	uchar_t    	    	*name;		/* pointer to name (no NULL) */
 } dir_hash_ent_t;
=20
 typedef struct dir_hash_tab {
-	int			size;	/* size of hash table */
-	dir_hash_ent_t		*tab[1];/* actual hash table, variable size */
+	int			size;		/* size of hash tables */
+	int			names_duped;	/* 1 =3D ent names malloced */
+	dir_hash_ent_t		*first;		/* ptr to first added entry */
+	dir_hash_ent_t		*last;		/* ptr to last added entry */
+	dir_hash_ent_t		**byhash;	/* ptr to name hash buckets */
+	dir_hash_ent_t		**byaddr;	/* ptr to addr hash buckets */
 } dir_hash_tab_t;
+
 #define	DIR_HASH_TAB_SIZE(n)	\
-	(offsetof(dir_hash_tab_t, tab) + (sizeof(dir_hash_ent_t *) * (n)))
+	(sizeof(dir_hash_tab_t) + (sizeof(dir_hash_ent_t *) * (n) * 2))
 #define	DIR_HASH_FUNC(t,a)	((a) % (t)->size)
=20
 /*
- * Track names to check for duplicates in a directory.
- */
-
-typedef struct name_hash_ent {
-	struct name_hash_ent	*next;	/* pointer to next entry */
-	xfs_dahash_t		hashval;/* hash value of name */
-	int	  	    	namelen;/* length of name */
-	uchar_t    	    	*name;	/* pointer to name (no NULL) */
-} name_hash_ent_t;=09=09
-
-typedef struct name_hash_tab {
-	int			size;	/* size of hash table */
-	name_hash_ent_t		*tab[1];/* actual hash table, variable size */
-} name_hash_tab_t;
-#define	NAME_HASH_TAB_SIZE(n)	\
-	(offsetof(name_hash_tab_t, tab) + (sizeof(name_hash_ent_t *) * (n)))
-#define	NAME_HASH_FUNC(t,a)	((a) % (t)->size)
-
-/*
  * Track the contents of the freespace table in a directory.
  */
 typedef struct freetab {
@@ -94,28 +87,78 @@ typedef struct freetab {
 #define	DIR_HASH_CK_BADSTALE	5
 #define	DIR_HASH_CK_TOTAL	6
=20
-static void
+/*
+ * Returns 0 if the name already exists (ie. a duplicate)
+ */
+static int
 dir_hash_add(
 	dir_hash_tab_t		*hashtab,
-	xfs_dahash_t		hash,
-	xfs_dir2_dataptr_t	addr,
-	int			junk)
-{
-	int			i;
+	__uint32_t		addr,=09
+	xfs_ino_t		inum,
+	int			namelen,
+	uchar_t			*name)
+{
+	xfs_dahash_t		hash =3D 0;
+	int			byaddr;
+	int			byhash =3D 0;
 	dir_hash_ent_t		*p;
-
-	i =3D DIR_HASH_FUNC(hashtab, addr);
+	int			dup;
+	short			junk;
+=09
+	ASSERT(!hashtab->names_duped);
+=09
+	junk =3D name[0] =3D=3D '/';
+	byaddr =3D DIR_HASH_FUNC(hashtab, addr);
+	dup =3D 0;
+
+	if (!junk) {
+		hash =3D libxfs_da_hashname(name, namelen);
+		byhash =3D DIR_HASH_FUNC(hashtab, hash);
+
+		/*=20
+		 * search hash bucket for existing name.
+		 */
+		for (p =3D hashtab->byhash[byhash]; p; p =3D p->nextbyhash) {
+			if (p->hashval =3D=3D hash && p->namelen =3D=3D namelen) {
+				if (memcmp(p->name, name, namelen) =3D=3D 0) {
+					dup =3D 1;
+					junk =3D 1;
+					break;
+				}
+			}
+		}
+	}
+=09
 	if ((p =3D malloc(sizeof(*p))) =3D=3D NULL)
 		do_error(_("malloc failed in dir_hash_add (%u bytes)\n"),
 			sizeof(*p));
-	p->next =3D hashtab->tab[i];
-	hashtab->tab[i] =3D p;
-	if (!(p->junkit =3D junk))
-		p->ent.hashval =3D hash;
-	p->ent.address =3D addr;
+=09
+	p->nextbyaddr =3D hashtab->byaddr[byaddr];
+	hashtab->byaddr[byaddr] =3D p;
+	if (hashtab->last)=20
+		hashtab->last->nextbyorder =3D p;
+	else
+		hashtab->first =3D p;
+	p->nextbyorder =3D NULL;
+	hashtab->last =3D p;
+=09
+	if (!(p->junkit =3D junk)) {
+		p->hashval =3D hash;
+		p->nextbyhash =3D hashtab->byhash[byhash];
+		hashtab->byhash[byhash] =3D p;
+	}
+	p->address =3D addr;
+	p->inum =3D inum;
 	p->seen =3D 0;
+	p->namelen =3D namelen;
+	p->name =3D name;
+=09
+	return !dup;
 }
=20
+/*
+ * checks to see if any data entries are not in the leaf blocks=20
+ */
 static int
 dir_hash_unseen(
 	dir_hash_tab_t	*hashtab)
@@ -124,7 +167,7 @@ dir_hash_unseen(
 	dir_hash_ent_t	*p;
=20
 	for (i =3D 0; i < hashtab->size; i++) {
-		for (p =3D hashtab->tab[i]; p; p =3D p->next) {
+		for (p =3D hashtab->byaddr[i]; p; p =3D p->nextbyaddr) {
 			if (p->seen =3D=3D 0)
 				return 1;
 		}
@@ -173,8 +216,10 @@ dir_hash_done(
 	dir_hash_ent_t	*p;
=20
 	for (i =3D 0; i < hashtab->size; i++) {
-		for (p =3D hashtab->tab[i]; p; p =3D n) {
-			n =3D p->next;
+		for (p =3D hashtab->byaddr[i]; p; p =3D n) {
+			n =3D p->nextbyaddr;
+			if (hashtab->names_duped)
+				free(p->name);
 			free(p);
 		}
 	}
@@ -196,6 +241,10 @@ dir_hash_init(
 	if ((hashtab =3D calloc(DIR_HASH_TAB_SIZE(hsize), 1)) =3D=3D NULL)
 		do_error(_("calloc failed in dir_hash_init\n"));
 	hashtab->size =3D hsize;
+	hashtab->byhash =3D (dir_hash_ent_t**)((char *)hashtab +=20
+		sizeof(dir_hash_tab_t));
+	hashtab->byaddr =3D (dir_hash_ent_t**)((char *)hashtab +=20
+		sizeof(dir_hash_tab_t) + sizeof(dir_hash_ent_t*) * hsize);
 	return hashtab;
 }
=20
@@ -209,12 +258,12 @@ dir_hash_see(
 	dir_hash_ent_t		*p;
=20
 	i =3D DIR_HASH_FUNC(hashtab, addr);
-	for (p =3D hashtab->tab[i]; p; p =3D p->next) {
-		if (p->ent.address !=3D addr)
+	for (p =3D hashtab->byaddr[i]; p; p =3D p->nextbyaddr) {
+		if (p->address !=3D addr)
 			continue;
 		if (p->seen)
 			return DIR_HASH_CK_DUPLEAF;
-		if (p->junkit =3D=3D 0 && p->ent.hashval !=3D hash)
+		if (p->junkit =3D=3D 0 && p->hashval !=3D hash)
 			return DIR_HASH_CK_BADHASH;
 		p->seen =3D 1;
 		return DIR_HASH_CK_OK;
@@ -222,6 +271,10 @@ dir_hash_see(
 	return DIR_HASH_CK_NODATA;
 }
=20
+/*
+ * checks to make sure leafs match a data entry, and that the stale
+ * count is valid.
+ */
 static int
 dir_hash_see_all(
 	dir_hash_tab_t		*hashtab,
@@ -246,81 +299,26 @@ dir_hash_see_all(
 }
=20
 /*
- * Returns 0 if the name already exists (ie. a duplicate)
+ * Convert name pointers into locally allocated memory.
+ * This must only be done after all the entries have been added.
  */
-static int
-name_hash_add(
-	name_hash_tab_t		*nametab,
-	uchar_t			*name,
-	int			namelen)
+static void
+dir_hash_dup_names(dir_hash_tab_t *hashtab)
 {
-	xfs_dahash_t		hash;
-	int			i;
-	name_hash_ent_t		*p;
-
-	hash =3D libxfs_da_hashname(name, namelen);
-=09=09=09
-	i =3D NAME_HASH_FUNC(nametab, hash);
-=09
-	/*=20
-	 * search hash bucket for existing name.
-	 */
-	for (p =3D nametab->tab[i]; p; p =3D p->next) {
-		if (p->hashval =3D=3D hash && p->namelen =3D=3D namelen) {
-			if (memcmp(p->name, name, namelen) =3D=3D 0)=20
-				return 0; /* exists */
-		}
-	}
-=09
-	if ((p =3D malloc(sizeof(*p))) =3D=3D NULL)
-		do_error(_("malloc failed in name_hash_add (%u bytes)\n"),
-			sizeof(*p));
+	uchar_t			*name;
+	dir_hash_ent_t		*p;
=20=09
-	p->next =3D nametab->tab[i];
-	p->hashval =3D hash;
-	p->name =3D name;
-	p->namelen =3D namelen;
-	nametab->tab[i] =3D p;
+	if (hashtab->names_duped)
+		return;
=20=09
-	return 1;	/* success, no duplicate */
-}
-
-static name_hash_tab_t *
-name_hash_init(
-	xfs_fsize_t	size)
-{
-	name_hash_tab_t	*nametab;
-	int		hsize;
-
-	hsize =3D size / (16 * 4);
-	if (hsize > 1024)
-		hsize =3D 1024;
-	else if (hsize < 16)
-		hsize =3D 16;
-	if ((nametab =3D calloc(NAME_HASH_TAB_SIZE(hsize), 1)) =3D=3D NULL)
-		do_error(_("calloc failed in name_hash_init\n"));
-	nametab->size =3D hsize;
-	return nametab;
-}
-
-static void
-name_hash_done(
-	name_hash_tab_t	*nametab)
-{
-	int		i;
-	name_hash_ent_t	*n;
-	name_hash_ent_t	*p;
-
-	for (i =3D 0; i < nametab->size; i++) {
-		for (p =3D nametab->tab[i]; p; p =3D n) {
-			n =3D p->next;
-			free(p);
-		}
+	for (p =3D hashtab->first; p; p =3D p->nextbyorder) {
+		name =3D malloc(p->namelen);
+		memcpy(name, p->name, p->namelen);
+		p->name =3D name;
 	}
-	free(nametab);
+	hashtab->names_duped =3D 1;
 }
=20
-
 /*
  * Version 1 or 2 directory routine wrappers
 */
@@ -1385,7 +1383,8 @@ lf_block_dir_entry_check(xfs_mount_t		*m
 			dir_stack_t		*stack,
 			ino_tree_node_t		*current_irec,
 			int			current_ino_offset,
-			name_hash_tab_t		*nametab)
+			dir_hash_tab_t		*hashtab,
+			xfs_dablk_t		da_bno)
 {
 	xfs_dir_leaf_entry_t	*entry;
 	ino_tree_node_t		*irec;
@@ -1545,7 +1544,9 @@ lf_block_dir_entry_check(xfs_mount_t		*m
 		/*
 		 * check for duplicate names in directory.
 		 */=20
-		if (!name_hash_add(nametab, namest->name, entry->namelen)) {
+		if (!dir_hash_add(hashtab, (da_bno << mp->m_sb.sb_blocklog) +=20
+						entry->nameidx,=20
+				lino, entry->namelen, namest->name)) {
 			do_warn(
 		_("entry \"%s\" (ino %llu) in dir %llu is a duplicate name"),
 				fname, lino, ino);
@@ -1635,7 +1636,7 @@ longform_dir_entry_check(xfs_mount_t	*mp
 			dir_stack_t	*stack,
 			ino_tree_node_t	*irec,
 			int		ino_offset,
-			name_hash_tab_t	*nametab)
+			dir_hash_tab_t	*hashtab)
 {
 	xfs_dir_leafblock_t	*leaf;
 	xfs_buf_t		*bp;
@@ -1677,8 +1678,6 @@ longform_dir_entry_check(xfs_mount_t	*mp
=20
 		leaf =3D (xfs_dir_leafblock_t *)XFS_BUF_PTR(bp);
=20
-		da_bno =3D INT_GET(leaf->hdr.info.forw, ARCH_CONVERT);
-
 		if (INT_GET(leaf->hdr.info.magic, ARCH_CONVERT) !=3D
 		    XFS_DIR_LEAF_MAGIC)  {
 			if (!no_modify)  {
@@ -1699,9 +1698,11 @@ _("bad magic # (0x%x) for dir ino %llu l
 		}
=20
 		if (!skipit)
-			lf_block_dir_entry_check(mp, ino, leaf, &dirty,
-						num_illegal, need_dot, stack,
-						irec, ino_offset, nametab);
+			lf_block_dir_entry_check(mp, ino, leaf, &dirty,=20
+					num_illegal, need_dot, stack, irec,=20
+					ino_offset, hashtab, da_bno);
+
+		da_bno =3D INT_GET(leaf->hdr.info.forw, ARCH_CONVERT);
=20
 		ASSERT(dirty =3D=3D 0 || (dirty && !no_modify));
=20
@@ -1745,6 +1746,152 @@ _("can't map leaf block %d in dir %llu,=20
 }
=20
 /*
+ * Unexpected failure during the rebuild will leave the entries in
+ * lost+found on the next run
+ */
+
+static void=20
+longform_dir2_rebuild(
+	xfs_mount_t	*mp,
+	xfs_ino_t	ino,
+	xfs_inode_t	*ip,
+	dir_hash_tab_t	*hashtab)
+{
+	int			error;
+	int			nres;
+	xfs_trans_t		*tp;
+	xfs_fileoff_t		lastblock;
+	xfs_fsblock_t		firstblock;
+	xfs_bmap_free_t		flist;
+	xfs_ino_t		parentino;
+	xfs_inode_t		*pip;
+	int			byhash;
+	dir_hash_ent_t		*p;
+	int			committed;
+	int			done;
+=09
+	/*=20
+	 * trash directory completely and rebuild from scratch using the
+	 * name/inode pairs in the hash table
+	 */
+=09=20
+	do_warn(_("rebuilding directory inode %llu\n"), ino);
+=09
+	/*=20
+	 * first attempt to locate the parent inode, if it can't be found,
+	 * we'll use the lost+found inode=20
+	 */
+	byhash =3D DIR_HASH_FUNC(hashtab, libxfs_da_hashname((uchar_t*)"..", 2));
+	parentino =3D orphanage_ino;
+	for (p =3D hashtab->byhash[byhash]; p; p =3D p->nextbyhash) {
+		if (p->namelen =3D=3D 2 && p->name[0] =3D=3D '.' && p->name[1] =3D=3D '.=
') {
+			parentino =3D p->inum;
+			break;
+		}
+	}
+
+	XFS_BMAP_INIT(&flist, &firstblock);
+=09=09
+	tp =3D libxfs_trans_alloc(mp, 0);
+	nres =3D XFS_REMOVE_SPACE_RES(mp);
+	error =3D libxfs_trans_reserve(tp, nres, XFS_REMOVE_LOG_RES(mp), 0,
+			XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
+	if (error)
+		res_failed(error);
+	libxfs_trans_ijoin(tp, ip, 0);
+	libxfs_trans_ihold(tp, ip);
+=09
+	if ((error =3D libxfs_bmap_last_offset(tp, ip, &lastblock,=20
+						XFS_DATA_FORK)))
+		do_error(_("xfs_bmap_last_offset failed -- error - %d\n"),=20
+			error);
+=09
+	/* re-init the directory to shortform */
+	if ((error =3D libxfs_trans_iget(mp, tp, parentino, 0, 0, &pip))) {
+		do_warn(
+		_("couldn't iget parent inode %llu -- error - %d\n"),
+			parentino, error);
+		/* we'll try to use the orphanage ino then */
+		parentino =3D orphanage_ino;
+		if ((error =3D libxfs_trans_iget(mp, tp, parentino, 0, 0, &pip)))
+			do_error(
+		_("couldn't iget lost+found inode %llu -- error - %d\n"),
+				parentino, error);
+	}
+
+	/* free all data, leaf, node and freespace blocks */
+=09
+	if ((error =3D libxfs_bunmapi(tp, ip, 0, lastblock,=20
+			XFS_BMAPI_METADATA, 0, &firstblock, &flist,
+			&done))) {
+		do_warn(_("xfs_bunmapi failed -- error - %d\n"), error);
+		libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
+					XFS_TRANS_ABORT);
+		return;
+	}
+=09=09
+	ASSERT(done);
+
+	libxfs_dir2_init(tp, ip, pip);
+=09
+	error =3D libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
+=09=09=09=09
+	libxfs_trans_commit(tp,=20
+			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC, 0);
+=09=09
+	/* go through the hash list and re-add the inodes */
+
+	for (p =3D hashtab->first; p; p =3D p->nextbyorder) {
+=09=09
+		if (p->name[0] =3D=3D '/' || (p->name[0] =3D=3D '.' && (p->namelen =3D=
=3D 1=20
+				|| (p->namelen =3D=3D 2 && p->name[1] =3D=3D '.'))))
+			continue;
+=09=09
+		tp =3D libxfs_trans_alloc(mp, 0);
+		nres =3D XFS_CREATE_SPACE_RES(mp, p->namelen);
+		if ((error =3D libxfs_trans_reserve(tp, nres,=20
+				XFS_CREATE_LOG_RES(mp), 0,
+				XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT))) {
+			do_warn(
+	_("space reservation failed (%d), filesystem may be out of space\n"),
+				error);
+			break;
+		}
+
+		libxfs_trans_ijoin(tp, ip, 0);
+		libxfs_trans_ihold(tp, ip);
+
+		XFS_BMAP_INIT(&flist, &firstblock);
+		if ((error =3D libxfs_dir2_createname(tp, ip, (char*)p->name,=20
+				p->namelen, p->inum, &firstblock, &flist,=20
+				nres))) {
+			do_warn(
+_("name create failed in ino %llu (%d), filesystem may be out of space\n"),
+				ino, error);
+			libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
+						XFS_TRANS_ABORT);
+			break;
+		}
+
+		if ((error =3D libxfs_bmap_finish(&tp, &flist, firstblock,=20
+				&committed))) {
+			do_warn(
+	_("bmap finish failed (%d), filesystem may be out of space\n"),
+				error);
+			libxfs_bmap_cancel(&flist);
+			libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
+						XFS_TRANS_ABORT);
+			break;
+		}
+=09=09=09
+
+		libxfs_trans_commit(tp,=20
+				XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC, 0);
+	}
+}
+
+
+/*
  * Kill a block in a version 2 inode.
  * Makes its own transaction.
  */
@@ -1807,7 +1954,6 @@ longform_dir2_entry_check_data(
 	xfs_dabuf_t		**bpp,
 	dir_hash_tab_t		*hashtab,
 	freetab_t		**freetabp,
-	name_hash_tab_t		*nametab,
 	xfs_dablk_t		da_bno,
 	int			isblock)
 {
@@ -1828,6 +1974,7 @@ longform_dir2_entry_check_data(
 	freetab_t		*freetab;
 	int			i;
 	int			ino_offset;
+	xfs_ino_t		inum;
 	ino_tree_node_t		*irec;
 	int			junkit;
 	int			lastfree;
@@ -1956,8 +2103,7 @@ longform_dir2_entry_check_data(
 	libxfs_trans_ijoin(tp, ip, 0);
 	libxfs_trans_ihold(tp, ip);
 	libxfs_da_bjoin(tp, bp);
-	if (isblock)
-		libxfs_da_bhold(tp, bp);
+	libxfs_da_bhold(tp, bp);
 	XFS_BMAP_INIT(&flist, &firstblock);
 	if (INT_GET(d->hdr.magic, ARCH_CONVERT) !=3D wantmagic) {
 		do_warn(_("bad directory block magic # %#x for directory inode "
@@ -1987,7 +2133,7 @@ longform_dir2_entry_check_data(
 	while (ptr < endptr) {
 		dup =3D (xfs_dir2_data_unused_t *)ptr;
 		if (INT_GET(dup->freetag, ARCH_CONVERT) =3D=3D
-		    XFS_DIR2_DATA_FREE_TAG) {
+		    				XFS_DIR2_DATA_FREE_TAG) {
 			if (lastfree) {
 				do_warn(_("directory inode %llu block %u has "
 					  "consecutive free entries: "),
@@ -2011,10 +2157,24 @@ longform_dir2_entry_check_data(
 		addr =3D XFS_DIR2_DB_OFF_TO_DATAPTR(mp, db, ptr - (char *)d);
 		dep =3D (xfs_dir2_data_entry_t *)ptr;
 		ptr +=3D XFS_DIR2_DATA_ENTSIZE(dep->namelen);
+		inum =3D INT_GET(dep->inumber, ARCH_CONVERT);
 		lastfree =3D 0;
-		dir_hash_add(hashtab,
-			libxfs_da_hashname((uchar_t *)dep->name, dep->namelen),
-			addr, dep->name[0] =3D=3D '/');
+		if (!dir_hash_add(hashtab, addr, inum, dep->namelen,=20
+				dep->name)) {
+			do_warn(
+		_("entry \"%s\" (ino %llu) in dir %llu is a duplicate name"),
+				fname, inum, ip->i_ino);
+			if (!no_modify) {
+				if (verbose)
+					do_warn(
+					_(", marking entry to be junked\n"));
+				else
+					do_warn("\n");
+			} else {
+				do_warn(_(", would junk entry\n"));
+			}
+			dep->name[0] =3D '/';
+		}
 		/*
 		 * skip bogus entries (leading '/').  they'll be deleted
 		 * later.  must still log it, else we leak references to
@@ -2029,7 +2189,7 @@ longform_dir2_entry_check_data(
 		junkit =3D 0;
 		bcopy(dep->name, fname, dep->namelen);
 		fname[dep->namelen] =3D '\0';
-		ASSERT(INT_GET(dep->inumber, ARCH_CONVERT) !=3D NULLFSINO);
+		ASSERT(inum !=3D NULLFSINO);
 		/*
 		 * skip the '..' entry since it's checked when the
 		 * directory is reached by something else.  if it never
@@ -2039,7 +2199,7 @@ longform_dir2_entry_check_data(
 		if (dep->namelen =3D=3D 2 && dep->name[0] =3D=3D '.' &&
 		    dep->name[1] =3D=3D '.')
 			continue;
-		ASSERT(no_modify || !verify_inum(mp, INT_GET(dep->inumber, ARCH_CONVERT)=
));
+		ASSERT(no_modify || !verify_inum(mp, inum));
 		/*
 		 * special case the . entry.  we know there's only one
 		 * '.' and only '.' points to itself because bogus entries
@@ -2049,7 +2209,7 @@ longform_dir2_entry_check_data(
 		 * '..' is already accounted for or will be taken care
 		 * of when directory is moved to orphanage.
 		 */
-		if (ip->i_ino =3D=3D INT_GET(dep->inumber, ARCH_CONVERT))  {
+		if (ip->i_ino =3D=3D inum)  {
 			ASSERT(dep->name[0] =3D=3D '.' && dep->namelen =3D=3D 1);
 			add_inode_ref(current_irec, current_ino_offset);
 			*need_dot =3D 0;
@@ -2062,23 +2222,18 @@ longform_dir2_entry_check_data(
 		 * just skip it.  no need to process it and it's ..
 		 * link is already accounted for.
 		 */
-		if (INT_GET(dep->inumber, ARCH_CONVERT) =3D=3D orphanage_ino &&
-		    strcmp(fname, ORPHANAGE) =3D=3D 0)
+		if (inum =3D=3D orphanage_ino && strcmp(fname, ORPHANAGE) =3D=3D 0)
 			continue;
 		/*
 		 * skip entries with bogus inumbers if we're in no modify mode
 		 */
-		if (no_modify &&
-		    verify_inum(mp, INT_GET(dep->inumber, ARCH_CONVERT)))
+		if (no_modify && verify_inum(mp, inum))
 			continue;
 		/*
 		 * ok, now handle the rest of the cases besides '.' and '..'
 		 */
-		irec =3D find_inode_rec(
-			XFS_INO_TO_AGNO(mp,
-				INT_GET(dep->inumber, ARCH_CONVERT)),
-			XFS_INO_TO_AGINO(mp,
-				INT_GET(dep->inumber, ARCH_CONVERT)));
+		irec =3D find_inode_rec(XFS_INO_TO_AGNO(mp, inum),
+					XFS_INO_TO_AGINO(mp, inum));
 		if (irec =3D=3D NULL)  {
 			nbad++;
 			do_warn(_("entry \"%s\" in directory inode %llu points "
@@ -2093,9 +2248,7 @@ longform_dir2_entry_check_data(
 			}
 			continue;
 		}
-		ino_offset =3D XFS_INO_TO_AGINO(mp,
-				INT_GET(dep->inumber, ARCH_CONVERT)) -
-					irec->ino_startnum;
+		ino_offset =3D XFS_INO_TO_AGINO(mp, inum) - irec->ino_startnum;
 		/*
 		 * if it's a free inode, blow out the entry.
 		 * by now, any inode that we think is free
@@ -2106,18 +2259,13 @@ longform_dir2_entry_check_data(
 			 * don't complain if this entry points to the old
 			 * and now-free lost+found inode
 			 */
-			if (verbose || no_modify ||
-			    INT_GET(dep->inumber, ARCH_CONVERT) !=3D
-			    old_orphanage_ino)
+			if (verbose || no_modify || inum !=3D old_orphanage_ino)
 				do_warn(
 	_("entry \"%s\" in directory inode %llu points to free inode %llu"),
-					fname, ip->i_ino,
-					INT_GET(dep->inumber, ARCH_CONVERT));
+					fname, ip->i_ino, inum);
 			nbad++;
 			if (!no_modify)  {
-				if (verbose ||
-				    INT_GET(dep->inumber, ARCH_CONVERT) !=3D
-				    old_orphanage_ino)
+				if (verbose || inum !=3D old_orphanage_ino)
 					do_warn(
 					_(", marking entry to be junked\n"));
 				else
@@ -2130,28 +2278,6 @@ longform_dir2_entry_check_data(
 			continue;
 		}
 		/*
-		 * check for duplicate names in directory.
-		 */=20
-		if (!name_hash_add(nametab, dep->name, dep->namelen)) {
-			do_warn(
-		_("entry \"%s\" (ino %llu) in dir %llu is a duplicate name"),
-				fname, INT_GET(dep->inumber, ARCH_CONVERT),
-				ip->i_ino);
-			nbad++;
-			if (!no_modify) {
-				if (verbose)
-					do_warn(
-					_(", marking entry to be junked\n"));
-				else
-					do_warn("\n");
-				dep->name[0] =3D '/';
-				libxfs_dir2_data_log_entry(tp, bp, dep);
-			} else {
-				do_warn(_(", would junk entry\n"));
-			}
-			continue;
-		}
-		/*
 		 * check easy case first, regular inode, just bump
 		 * the link count and continue
 		 */
@@ -2172,22 +2298,17 @@ longform_dir2_entry_check_data(
 			junkit =3D 1;
 			do_warn(
 _("entry \"%s\" in dir %llu points to an already connected directory inode=
 %llu,\n"),
-				fname, ip->i_ino,
-				INT_GET(dep->inumber, ARCH_CONVERT));
+				fname, ip->i_ino, inum);
 		} else if (parent =3D=3D ip->i_ino)  {
 			add_inode_reached(irec, ino_offset);
 			add_inode_ref(current_irec, current_ino_offset);
-			if (!is_inode_refchecked(
-				INT_GET(dep->inumber, ARCH_CONVERT), irec,
-					ino_offset))
-				push_dir(stack,
-					INT_GET(dep->inumber, ARCH_CONVERT));
+			if (!is_inode_refchecked(inum, irec, ino_offset))
+				push_dir(stack, inum);
 		} else  {
 			junkit =3D 1;
 			do_warn(
 _("entry \"%s\" in dir inode %llu inconsistent with .. value (%llu) in ino=
 %llu,\n"),
-				fname, ip->i_ino, parent,
-				INT_GET(dep->inumber, ARCH_CONVERT));
+				fname, ip->i_ino, parent, inum);
 		}
 		if (junkit)  {
 			junkit =3D 0;
@@ -2195,9 +2316,7 @@ _("entry \"%s\" in dir inode %llu incons
 			if (!no_modify)  {
 				dep->name[0] =3D '/';
 				libxfs_dir2_data_log_entry(tp, bp, dep);
-				if (verbose ||
-				    INT_GET(dep->inumber, ARCH_CONVERT) !=3D
-				    old_orphanage_ino)
+				if (verbose || inum !=3D old_orphanage_ino)
 					do_warn(
 					_("\twill clear entry \"%s\"\n"),
 						fname);
@@ -2212,8 +2331,6 @@ _("entry \"%s\" in dir inode %llu incons
 		libxfs_dir2_data_freescan(mp, d, &needlog, NULL);
 	if (needlog)
 		libxfs_dir2_data_log_header(tp, bp);
-	else if (!isblock && !nbad)
-		libxfs_da_brelse(tp, bp);
 	libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
 	libxfs_trans_commit(tp, 0, 0);
 	freetab->ents[db].v =3D INT_GET(d->hdr.bestfree[0].length, ARCH_CONVERT);
@@ -2306,19 +2423,19 @@ longform_dir2_check_node(
 	xfs_fileoff_t		next_da_bno;
 	int			seeval =3D 0;
 	int			used;
-
+=09
 	for (da_bno =3D mp->m_dirleafblk, next_da_bno =3D 0;
 	     next_da_bno !=3D NULLFILEOFF && da_bno < mp->m_dirfreeblk;
 	     da_bno =3D (xfs_dablk_t)next_da_bno) {
 		next_da_bno =3D da_bno + mp->m_dirblkfsbs - 1;
-		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
+		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))=20
 			break;
 		if (libxfs_da_read_bufr(NULL, ip, da_bno, -1, &bp,
 				XFS_DATA_FORK)) {
-			do_error(
-			_("can't read block %u for directory inode %llu\n"),
+			do_warn(
+			_("can't read leaf block %u for directory inode %llu\n"),
 				da_bno, ip->i_ino);
-			/* NOTREACHED */
+			return 1;
 		}
 		leaf =3D bp->data;
 		if (INT_GET(leaf->hdr.info.magic, ARCH_CONVERT) !=3D
@@ -2348,23 +2465,24 @@ longform_dir2_check_node(
 		seeval =3D dir_hash_see_all(hashtab, leaf->ents, INT_GET(leaf->hdr.count=
, ARCH_CONVERT),
 			INT_GET(leaf->hdr.stale, ARCH_CONVERT));
 		libxfs_da_brelse(NULL, bp);
-		if (seeval !=3D DIR_HASH_CK_OK)
+		if (seeval !=3D DIR_HASH_CK_OK)=20
 			return 1;
 	}
-	if (dir_hash_check(hashtab, ip, seeval))
+	if (dir_hash_check(hashtab, ip, seeval))=20
 		return 1;
+=09
 	for (da_bno =3D mp->m_dirfreeblk, next_da_bno =3D 0;
 	     next_da_bno !=3D NULLFILEOFF;
 	     da_bno =3D (xfs_dablk_t)next_da_bno) {
 		next_da_bno =3D da_bno + mp->m_dirblkfsbs - 1;
-		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
+		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))=20
 			break;
 		if (libxfs_da_read_bufr(NULL, ip, da_bno, -1, &bp,
 				XFS_DATA_FORK)) {
-			do_error(_("can't read block %u for directory inode "
-				   "%llu\n"),
+			do_warn(
+		_("can't read freespace block %u for directory inode %llu\n"),
 				da_bno, ip->i_ino);
-			/* NOTREACHED */
+			return 1;
 		}
 		free =3D bp->data;
 		fdb =3D XFS_DIR2_DA_TO_DB(mp, da_bno);
@@ -2418,388 +2536,9 @@ longform_dir2_check_node(
 }
=20
 /*
- * Rebuild a directory: set up.
- * Turn it into a node-format directory with no contents in the
- * upper area.  Also has correct freespace blocks.
- */
-void
-longform_dir2_rebuild_setup(
-	xfs_mount_t		*mp,
-	xfs_ino_t		ino,
-	xfs_inode_t		*ip,
-	freetab_t		*freetab)
-{
-	xfs_da_args_t		args;
-	int			committed;
-	xfs_dir2_data_t		*data =3D NULL;
-	xfs_dabuf_t		*dbp;
-	int			error;
-	xfs_dir2_db_t		fbno;
-	xfs_dabuf_t		*fbp;
-	xfs_fsblock_t		firstblock;
-	xfs_bmap_free_t		flist;
-	xfs_dir2_free_t		*free;
-	int			i;
-	int			j;
-	xfs_dablk_t		lblkno;
-	xfs_dabuf_t		*lbp;
-	xfs_dir2_leaf_t		*leaf;
-	int			nres;
-	xfs_trans_t		*tp;
-
-	/* read first directory block */
-	tp =3D libxfs_trans_alloc(mp, 0);
-	nres =3D XFS_DAENTER_SPACE_RES(mp, XFS_DATA_FORK);
-	error =3D libxfs_trans_reserve(tp,
-		nres, XFS_CREATE_LOG_RES(mp), 0, XFS_TRANS_PERM_LOG_RES,
-		XFS_CREATE_LOG_COUNT);
-	if (error)
-		res_failed(error);
-	libxfs_trans_ijoin(tp, ip, 0);
-	libxfs_trans_ihold(tp, ip);
-	XFS_BMAP_INIT(&flist, &firstblock);
-	if (libxfs_da_read_buf(tp, ip, mp->m_dirdatablk, -2, &dbp,
-			XFS_DATA_FORK)) {
-		do_error(_("can't read block %u for directory inode %llu\n"),
-			mp->m_dirdatablk, ino);
-		/* NOTREACHED */
-	}
-
-	if (dbp)
-		data =3D dbp->data;
-
-	/* check for block format directory */
-	if (data &&
-	    INT_GET((data)->hdr.magic, ARCH_CONVERT) =3D=3D XFS_DIR2_BLOCK_MAGIC)=
 {
-		xfs_dir2_block_t	*block;
-		xfs_dir2_leaf_entry_t	*blp;
-		xfs_dir2_block_tail_t	*btp;
-		int			needlog;
-		int			needscan;
-
-		/* convert directory block from block format to data format */
-		INT_SET(data->hdr.magic, ARCH_CONVERT, XFS_DIR2_DATA_MAGIC);
-
-		/* construct freelist */
-		block =3D (xfs_dir2_block_t *)data;
-		btp =3D XFS_DIR2_BLOCK_TAIL_P(mp, block);
-		blp =3D XFS_DIR2_BLOCK_LEAF_P(btp);
-		needlog =3D needscan =3D 0;
-		libxfs_dir2_data_make_free(tp, dbp, (char *)blp - (char *)block,
-			(char *)block + mp->m_dirblksize - (char *)blp,
-			&needlog, &needscan);
-		if (needscan)
-			libxfs_dir2_data_freescan(mp, data, &needlog, NULL);
-		libxfs_da_log_buf(tp, dbp, 0, mp->m_dirblksize - 1);
-	} else if (dbp) {
-		libxfs_da_brelse(tp, dbp);
-	}
-
-	/* allocate blocks for btree */
-	bzero(&args, sizeof(args));
-	args.trans =3D tp;
-	args.dp =3D ip;
-	args.whichfork =3D XFS_DATA_FORK;
-	args.firstblock =3D &firstblock;
-	args.flist =3D &flist;
-	args.total =3D nres;
-	if ((error =3D libxfs_da_grow_inode(&args, &lblkno)) ||
-	    (error =3D libxfs_da_get_buf(tp, ip, lblkno, -1, &lbp, XFS_DATA_FORK)=
)) {
-		do_error(_("can't add btree block to directory inode %llu\n"),
-			ino);
-		/* NOTREACHED */
-	}
-	leaf =3D lbp->data;
-	bzero(leaf, mp->m_dirblksize);
-	INT_SET(leaf->hdr.info.magic, ARCH_CONVERT, XFS_DIR2_LEAFN_MAGIC);
-	libxfs_da_log_buf(tp, lbp, 0, mp->m_dirblksize - 1);
-	libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
-	libxfs_trans_commit(tp, 0, 0);
-
-	for (i =3D 0; i < freetab->nents; i +=3D XFS_DIR2_MAX_FREE_BESTS(mp)) {
-		tp =3D libxfs_trans_alloc(mp, 0);
-		nres =3D XFS_DAENTER_SPACE_RES(mp, XFS_DATA_FORK);
-		error =3D libxfs_trans_reserve(tp,
-			nres, XFS_CREATE_LOG_RES(mp), 0, XFS_TRANS_PERM_LOG_RES,
-			XFS_CREATE_LOG_COUNT);
-		if (error)
-			res_failed(error);
-		libxfs_trans_ijoin(tp, ip, 0);
-		libxfs_trans_ihold(tp, ip);
-		XFS_BMAP_INIT(&flist, &firstblock);
-		bzero(&args, sizeof(args));
-		args.trans =3D tp;
-		args.dp =3D ip;
-		args.whichfork =3D XFS_DATA_FORK;
-		args.firstblock =3D &firstblock;
-		args.flist =3D &flist;
-		args.total =3D nres;
-		if ((error =3D libxfs_dir2_grow_inode(&args, XFS_DIR2_FREE_SPACE,
-						 &fbno)) ||
-		    (error =3D libxfs_da_get_buf(tp, ip, XFS_DIR2_DB_TO_DA(mp, fbno),
-					    -1, &fbp, XFS_DATA_FORK))) {
-			do_error(_("can't add free block to directory inode "
-				   "%llu\n"),
-				ino);
-			/* NOTREACHED */
-		}
-		free =3D fbp->data;
-		bzero(free, mp->m_dirblksize);
-		INT_SET(free->hdr.magic, ARCH_CONVERT, XFS_DIR2_FREE_MAGIC);
-		INT_SET(free->hdr.firstdb, ARCH_CONVERT, i);
-		INT_SET(free->hdr.nvalid, ARCH_CONVERT, XFS_DIR2_MAX_FREE_BESTS(mp));
-		if (i + INT_GET(free->hdr.nvalid, ARCH_CONVERT) > freetab->nents)
-			INT_SET(free->hdr.nvalid, ARCH_CONVERT, freetab->nents - i);
-		for (j =3D 0; j < INT_GET(free->hdr.nvalid, ARCH_CONVERT); j++) {
-			INT_SET(free->bests[j], ARCH_CONVERT, freetab->ents[i + j].v);
-			if (INT_GET(free->bests[j], ARCH_CONVERT) !=3D NULLDATAOFF)
-				INT_MOD(free->hdr.nused, ARCH_CONVERT, +1);
-		}
-		libxfs_da_log_buf(tp, fbp, 0, mp->m_dirblksize - 1);
-		libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
-		libxfs_trans_commit(tp, 0, 0);
-	}
-}
-
-/*
- * Rebuild the entries from a single data block.
- */
-void
-longform_dir2_rebuild_data(
-	xfs_mount_t		*mp,
-	xfs_ino_t		ino,
-	xfs_inode_t		*ip,
-	xfs_dablk_t		da_bno)
-{
-	xfs_dabuf_t		*bp;
-	xfs_dir2_block_tail_t	*btp;
-	int			committed;
-	xfs_dir2_data_t		*data;
-	xfs_dir2_db_t		dbno;
-	xfs_dir2_data_entry_t	*dep;
-	xfs_dir2_data_unused_t	*dup;
-	char			*endptr;
-	int			error;
-	xfs_dir2_free_t		*fblock;
-	xfs_dabuf_t		*fbp;
-	xfs_dir2_db_t		fdb;
-	int			fi;
-	xfs_fsblock_t		firstblock;
-	xfs_bmap_free_t		flist;
-	int			needlog;
-	int			needscan;
-	int			nres;
-	char			*ptr;
-	xfs_trans_t		*tp;
-
-	if (libxfs_da_read_buf(NULL, ip, da_bno, da_bno =3D=3D 0 ? -2 : -1, &bp,
-			XFS_DATA_FORK)) {
-		do_error(_("can't read block %u for directory inode %llu\n"),
-			da_bno, ino);
-		/* NOTREACHED */
-	}
-	if (da_bno =3D=3D 0 && bp =3D=3D NULL)
-		/*
-		 * The block was punched out.
-		 */
-		return;
-	ASSERT(bp);
-	dbno =3D XFS_DIR2_DA_TO_DB(mp, da_bno);
-	fdb =3D XFS_DIR2_DB_TO_FDB(mp, dbno);
-	if (libxfs_da_read_buf(NULL, ip, XFS_DIR2_DB_TO_DA(mp, fdb), -1, &fbp,
-			XFS_DATA_FORK)) {
-		do_error(_("can't read block %u for directory inode %llu\n"),
-			XFS_DIR2_DB_TO_DA(mp, fdb), ino);
-		/* NOTREACHED */
-	}
-	data =3D malloc(mp->m_dirblksize);
-	if (!data) {
-		do_error(
-		_("malloc failed in longform_dir2_rebuild_data (%u bytes)\n"),
-			mp->m_dirblksize);
-		exit(1);
-	}
-	bcopy(bp->data, data, mp->m_dirblksize);
-	ptr =3D (char *)data->u;
-	if (INT_GET(data->hdr.magic, ARCH_CONVERT) =3D=3D XFS_DIR2_BLOCK_MAGIC) {
-		btp =3D XFS_DIR2_BLOCK_TAIL_P(mp, (xfs_dir2_block_t *)data);
-		endptr =3D (char *)XFS_DIR2_BLOCK_LEAF_P(btp);
-	} else
-		endptr =3D (char *)data + mp->m_dirblksize;
-	fblock =3D fbp->data;
-	fi =3D XFS_DIR2_DB_TO_FDINDEX(mp, dbno);
-	tp =3D libxfs_trans_alloc(mp, 0);
-	error =3D libxfs_trans_reserve(tp, 0, XFS_CREATE_LOG_RES(mp), 0,
-		XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
-	if (error)
-		res_failed(error);
-	libxfs_trans_ijoin(tp, ip, 0);
-	libxfs_trans_ihold(tp, ip);
-	libxfs_da_bjoin(tp, bp);
-	libxfs_da_bhold(tp, bp);
-	libxfs_da_bjoin(tp, fbp);
-	libxfs_da_bhold(tp, fbp);
-	XFS_BMAP_INIT(&flist, &firstblock);
-	needlog =3D needscan =3D 0;
-	bzero(((xfs_dir2_data_t *)(bp->data))->hdr.bestfree,
-		sizeof(data->hdr.bestfree));
-	libxfs_dir2_data_make_free(tp, bp, (xfs_dir2_data_aoff_t)sizeof(data->hdr=
),
-		mp->m_dirblksize - sizeof(data->hdr), &needlog, &needscan);
-	ASSERT(needscan =3D=3D 0);
-	libxfs_dir2_data_log_header(tp, bp);
-	INT_SET(fblock->bests[fi], ARCH_CONVERT,
-		INT_GET(((xfs_dir2_data_t *)(bp->data))->hdr.bestfree[0].length, ARCH_CO=
NVERT));
-	libxfs_dir2_free_log_bests(tp, fbp, fi, fi);
-	libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
-	libxfs_trans_commit(tp, 0, 0);
-
-	while (ptr < endptr) {
-		dup =3D (xfs_dir2_data_unused_t *)ptr;
-		if (INT_GET(dup->freetag, ARCH_CONVERT) =3D=3D XFS_DIR2_DATA_FREE_TAG) {
-			ptr +=3D INT_GET(dup->length, ARCH_CONVERT);
-			continue;
-		}
-		dep =3D (xfs_dir2_data_entry_t *)ptr;
-		ptr +=3D XFS_DIR2_DATA_ENTSIZE(dep->namelen);
-		if (dep->name[0] =3D=3D '/')
-			continue;
-		tp =3D libxfs_trans_alloc(mp, 0);
-		nres =3D XFS_CREATE_SPACE_RES(mp, dep->namelen);
-		error =3D libxfs_trans_reserve(tp, nres, XFS_CREATE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
-		if (error)
-			res_failed(error);
-		libxfs_trans_ijoin(tp, ip, 0);
-		libxfs_trans_ihold(tp, ip);
-		libxfs_da_bjoin(tp, bp);
-		libxfs_da_bhold(tp, bp);
-		libxfs_da_bjoin(tp, fbp);
-		libxfs_da_bhold(tp, fbp);
-		XFS_BMAP_INIT(&flist, &firstblock);
-		error =3D dir_createname(mp, tp, ip, (char *)dep->name,
-			dep->namelen, INT_GET(dep->inumber, ARCH_CONVERT),
-			&firstblock, &flist, nres);
-		ASSERT(error =3D=3D 0);
-		libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
-		libxfs_trans_commit(tp, 0, 0);
-	}
-	libxfs_da_brelse(NULL, bp);
-	libxfs_da_brelse(NULL, fbp);
-	free(data);
-}
-
-/*
- * Finish the rebuild of a directory.
- * Stuff / in and then remove it, this forces the directory to end
- * up in the right format.
- */
-void
-longform_dir2_rebuild_finish(
-	xfs_mount_t		*mp,
-	xfs_ino_t		ino,
-	xfs_inode_t		*ip)
-{
-	int			committed;
-	int			error;
-	xfs_fsblock_t		firstblock;
-	xfs_bmap_free_t		flist;
-	int			nres;
-	xfs_trans_t		*tp;
-
-	tp =3D libxfs_trans_alloc(mp, 0);
-	nres =3D XFS_CREATE_SPACE_RES(mp, 1);
-	error =3D libxfs_trans_reserve(tp, nres, XFS_CREATE_LOG_RES(mp), 0,
-		XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
-	if (error)
-		res_failed(error);
-	libxfs_trans_ijoin(tp, ip, 0);
-	libxfs_trans_ihold(tp, ip);
-	XFS_BMAP_INIT(&flist, &firstblock);
-	error =3D dir_createname(mp, tp, ip, "/", 1, ino,
-			&firstblock, &flist, nres);
-	ASSERT(error =3D=3D 0);
-	libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
-	libxfs_trans_commit(tp, 0, 0);
-
-	/* could kill trailing empty data blocks here */
-
-	tp =3D libxfs_trans_alloc(mp, 0);
-	nres =3D XFS_REMOVE_SPACE_RES(mp);
-	error =3D libxfs_trans_reserve(tp, nres, XFS_REMOVE_LOG_RES(mp), 0,
-		XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
-	if (error)
-		res_failed(error);
-	libxfs_trans_ijoin(tp, ip, 0);
-	libxfs_trans_ihold(tp, ip);
-	XFS_BMAP_INIT(&flist, &firstblock);
-	error =3D dir_removename(mp, tp, ip, "/", 1, ino,
-			&firstblock, &flist, nres);
-	ASSERT(error =3D=3D 0);
-	libxfs_bmap_finish(&tp, &flist, firstblock, &committed);
-	libxfs_trans_commit(tp, 0, 0);
-}
-
-/*
- * Rebuild a directory.
- * Remove all the non-data blocks.
- * Re-initialize to (empty) node form.
- * Loop over the data blocks reinserting each entry.
- * Force the directory into the right format.
- */
-void
-longform_dir2_rebuild(
-	xfs_mount_t	*mp,
-	xfs_ino_t	ino,
-	xfs_inode_t	*ip,
-	int		*num_illegal,
-	freetab_t	*freetab,
-	int		isblock)
-{
-	xfs_dabuf_t	*bp;
-	xfs_dablk_t	da_bno;
-	xfs_fileoff_t	next_da_bno;
-
-	do_warn(_("rebuilding directory inode %llu\n"), ino);
-
-	/* kill leaf blocks */
-	for (da_bno =3D mp->m_dirleafblk, next_da_bno =3D isblock ? NULLFILEOFF :=
 0;
-	     next_da_bno !=3D NULLFILEOFF;
-	     da_bno =3D (xfs_dablk_t)next_da_bno) {
-		next_da_bno =3D da_bno + mp->m_dirblkfsbs - 1;
-		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
-			break;
-		if (libxfs_da_get_buf(NULL, ip, da_bno, -1, &bp, XFS_DATA_FORK)) {
-			do_error(_("can't get block %u for directory inode "
-				   "%llu\n"),
-				da_bno, ino);
-			/* NOTREACHED */
-		}
-		dir2_kill_block(mp, ip, da_bno, bp);
-	}
-
-	/* rebuild empty btree and freelist */
-	longform_dir2_rebuild_setup(mp, ino, ip, freetab);
-
-	/* rebuild directory */
-	for (da_bno =3D mp->m_dirdatablk, next_da_bno =3D 0;
-	     da_bno < mp->m_dirleafblk && next_da_bno !=3D NULLFILEOFF;
-	     da_bno =3D (xfs_dablk_t)next_da_bno) {
-		next_da_bno =3D da_bno + mp->m_dirblkfsbs - 1;
-		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
-			break;
-		longform_dir2_rebuild_data(mp, ino, ip, da_bno);
-	}
-
-	/* put the directory in the appropriate on-disk format */
-	longform_dir2_rebuild_finish(mp, ino, ip);
-	*num_illegal =3D 0;
-}
-
-/*
- * succeeds or dies, inode never gets dirtied since all changes
- * happen in file blocks.  the inode size and other core info
- * is already correct, it's just the leaf entries that get altered.
- * XXX above comment is wrong for v2 - need to see why it matters
+ * If a directory is corrupt, we need to read in as many entries as possib=
le,
+ * destroy the entry and create a new one with recovered name/inode pairs.
+ * (ie. get libxfs to do all the grunt work)
  */
 void
 longform_dir2_entry_check(xfs_mount_t	*mp,
@@ -2810,15 +2549,14 @@ longform_dir2_entry_check(xfs_mount_t	*m
 			dir_stack_t	*stack,
 			ino_tree_node_t	*irec,
 			int		ino_offset,
-			name_hash_tab_t	*nametab)
+			dir_hash_tab_t	*hashtab)
 {
 	xfs_dir2_block_t	*block;
 	xfs_dir2_leaf_entry_t	*blp;
-	xfs_dabuf_t		*bp;
+	xfs_dabuf_t		**bplist;
 	xfs_dir2_block_tail_t	*btp;
 	xfs_dablk_t		da_bno;
 	freetab_t		*freetab;
-	dir_hash_tab_t		*hashtab;
 	int			i;
 	int			isblock;
 	int			isleaf;
@@ -2840,6 +2578,7 @@ longform_dir2_entry_check(xfs_mount_t	*m
 		freetab->ents[i].v =3D NULLDATAOFF;
 		freetab->ents[i].s =3D 0;
 	}
+	bplist =3D calloc(freetab->naents, sizeof(xfs_dabuf_t*));
 	/* is this a block, leaf, or node directory? */
 	libxfs_dir2_isblock(NULL, ip, &isblock);
 	libxfs_dir2_isleaf(NULL, ip, &isleaf);
@@ -2847,50 +2586,58 @@ longform_dir2_entry_check(xfs_mount_t	*m
 	if (do_prefetch && !isblock)
 		prefetch_p6_dir2(mp, ip);
=20
-	/* check directory data */
-	hashtab =3D dir_hash_init(ip->i_d.di_size);
+	/* check directory "data" blocks (ie. name/inode pairs) */
 	for (da_bno =3D 0, next_da_bno =3D 0;
 	     next_da_bno !=3D NULLFILEOFF && da_bno < mp->m_dirleafblk;
 	     da_bno =3D (xfs_dablk_t)next_da_bno) {
 		next_da_bno =3D da_bno + mp->m_dirblkfsbs - 1;
+		ASSERT(XFS_DIR2_DA_TO_DB(mp, da_bno) < freetab->naents);
 		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
 			break;
-		if (libxfs_da_read_bufr(NULL, ip, da_bno,
-				da_bno =3D=3D 0 ? -2 : -1, &bp, XFS_DATA_FORK)) {
-			do_error(_("can't read block %u for directory inode "
-				   "%llu\n"),
+		if (libxfs_da_read_bufr(NULL, ip, da_bno, -1,=20
+				&bplist[XFS_DIR2_DA_TO_DB(mp, da_bno)],=20
+				XFS_DATA_FORK)) {
+			do_warn(_(
+			"can't read data block %u for directory inode %llu\n"),
 				da_bno, ino);
-			/* NOTREACHED */
+			*num_illegal++;
+			continue;	/* try and read all "data" blocks */
 		}
-		/* is there a hole at the start? */
-		if (da_bno =3D=3D 0 && bp =3D=3D NULL)
-			continue;
 		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
-			stack, irec, ino_offset, &bp, hashtab, &freetab,=20
-			nametab, da_bno, isblock);
-		/* it releases the buffer unless isblock is set */
+				stack, irec, ino_offset,=20
+				&bplist[XFS_DIR2_DA_TO_DB(mp, da_bno)], hashtab,=20=20
+				&freetab, da_bno, isblock);
 	}
 	fixit =3D (*num_illegal !=3D 0) || dir2_is_badino(ino);
=20
 	/* check btree and freespace */
 	if (isblock) {
-		ASSERT(bp);
-		block =3D bp->data;
+		block =3D bplist[0]->data;
 		btp =3D XFS_DIR2_BLOCK_TAIL_P(mp, block);
 		blp =3D XFS_DIR2_BLOCK_LEAF_P(btp);
-		seeval =3D dir_hash_see_all(hashtab, blp, INT_GET(btp->count, ARCH_CONVE=
RT), INT_GET(btp->stale, ARCH_CONVERT));
+		seeval =3D dir_hash_see_all(hashtab, blp,=20
+				INT_GET(btp->count, ARCH_CONVERT),=20
+				INT_GET(btp->stale, ARCH_CONVERT));
 		if (dir_hash_check(hashtab, ip, seeval))
 			fixit |=3D 1;
-		libxfs_da_brelse(NULL, bp);
 	} else if (isleaf) {
 		fixit |=3D longform_dir2_check_leaf(mp, ip, hashtab, freetab);
 	} else {
 		fixit |=3D longform_dir2_check_node(mp, ip, hashtab, freetab);
 	}
-	dir_hash_done(hashtab);
-	if (!no_modify && fixit)
-		longform_dir2_rebuild(mp, ino, ip, num_illegal, freetab,
-			isblock);
+	if (!no_modify && fixit) {
+		dir_hash_dup_names(hashtab);
+		for (i =3D 0; i < freetab->naents; i++)=20
+			if (bplist[i])
+				libxfs_da_brelse(NULL, bplist[i]);
+		longform_dir2_rebuild(mp, ino, ip, hashtab);
+		*num_illegal =3D 0;
+	} else {
+		for (i =3D 0; i < freetab->naents; i++)=20
+			if (bplist[i])
+				libxfs_da_brelse(NULL, bplist[i]);
+	}
+=09
 	free(freetab);
 }
=20
@@ -2906,7 +2653,7 @@ shortform_dir_entry_check(xfs_mount_t	*m
 			dir_stack_t	*stack,
 			ino_tree_node_t	*current_irec,
 			int		current_ino_offset,
-			name_hash_tab_t	*nametab)
+			dir_hash_tab_t	*hashtab)
 {
 	xfs_ino_t		lino;
 	xfs_ino_t		parent;
@@ -3044,7 +2791,7 @@ _("entry \"%s\" in shortform dir %llu re
 		ASSERT(irec !=3D NULL);
=20
 		ino_offset =3D XFS_INO_TO_AGINO(mp, lino) - irec->ino_startnum;
-
+=09=09
 		/*
 		 * if it's a free inode, blow out the entry.
 		 * by now, any inode that we think is free
@@ -3066,8 +2813,9 @@ _("entry \"%s\" in shortform dir inode %
 				do_warn(_("would junk entry \"%s\"\n"),
 					fname);
 			}
-		} else if (!name_hash_add(nametab, sf_entry->name,=20
-					sf_entry->namelen)) {
+		} else if (!dir_hash_add(hashtab,=20
+				(xfs_dir2_dataptr_t)(sf_entry - &sf->list[0]),
+				lino, sf_entry->namelen, sf_entry->name)) {
 			/*
 			 * check for duplicate names in directory.
 			 */=20
@@ -3311,7 +3059,7 @@ shortform_dir2_entry_check(xfs_mount_t	*
 			dir_stack_t	*stack,
 			ino_tree_node_t	*current_irec,
 			int		current_ino_offset,
-			name_hash_tab_t	*nametab)
+			dir_hash_tab_t	*hashtab)
 {
 	xfs_ino_t		lino;
 	xfs_ino_t		parent;
@@ -3484,7 +3232,9 @@ shortform_dir2_entry_check(xfs_mount_t	*
 				do_warn(_("would junk entry \"%s\"\n"),
 					fname);
 			}
-		} else if (!name_hash_add(nametab, sfep->name, sfep->namelen)) {
+		} else if (!dir_hash_add(hashtab, (xfs_dir2_dataptr_t)
+					(sfep - XFS_DIR2_SF_FIRSTENTRY(sfp)),
+				lino, sfep->namelen, sfep->name)) {
 			/*
 			 * check for duplicate names in directory.
 			 */=20
@@ -3650,7 +3400,7 @@ process_dirstack(xfs_mount_t *mp, dir_st
 	xfs_trans_t		*tp;
 	xfs_dahash_t		hashval;
 	ino_tree_node_t		*irec;
-	name_hash_tab_t		*nametab;
+	dir_hash_tab_t		*hashtab;
 	int			ino_offset, need_dot, committed;
 	int			dirty, num_illegal, error, nres;
=20
@@ -3731,7 +3481,7 @@ process_dirstack(xfs_mount_t *mp, dir_st
=20
 		add_inode_refchecked(ino, irec, ino_offset);
=20
-		nametab =3D name_hash_init(ip->i_d.di_size);
+		hashtab =3D dir_hash_init(ip->i_d.di_size);
=20
 		/*
 		 * look for bogus entries
@@ -3750,13 +3500,13 @@ process_dirstack(xfs_mount_t *mp, dir_st
 							&num_illegal, &need_dot,
 							stack, irec,
 							ino_offset,
-							nametab);
+							hashtab);
 			else
 				longform_dir_entry_check(mp, ino, ip,
 							&num_illegal, &need_dot,
 							stack, irec,
 							ino_offset,
-							nametab);
+							hashtab);
 			break;
 		case XFS_DINODE_FMT_LOCAL:
 			tp =3D libxfs_trans_alloc(mp, 0);
@@ -3781,12 +3531,12 @@ process_dirstack(xfs_mount_t *mp, dir_st
 				shortform_dir2_entry_check(mp, ino, ip, &dirty,
 							stack, irec,
 							ino_offset,
-							nametab);
+							hashtab);
 			else
 				shortform_dir_entry_check(mp, ino, ip, &dirty,
 							stack, irec,
 							ino_offset,
-							nametab);
+							hashtab);
=20
 			ASSERT(dirty =3D=3D 0 || (dirty && !no_modify));
 			if (dirty)  {
@@ -3801,7 +3551,7 @@ process_dirstack(xfs_mount_t *mp, dir_st
 		default:
 			break;
 		}
-		name_hash_done(nametab);
+		dir_hash_done(hashtab);
=20
 		hashval =3D 0;
=20
@@ -4223,6 +3973,10 @@ _("        - skipping filesystem travers
 	}
=20
 	do_log(_("        - traversals finished ... \n"));
+=09
+	/* flush all dirty data before doing lost+found search */
+	libxfs_bcache_flush();
+=09
 	do_log(_("        - moving disconnected inodes to lost+found ... \n"));
=20
 	/*

------=_NextPart_000_00F7_01C6B4C5.684DBD40--
