Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752139AbdHBJNJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Aug 2017 05:13:09 -0400
Date: Wed, 2 Aug 2017 11:13:05 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/7] xfs: remove double-underscore integer types
Message-ID: <20170802091305.oyxfyhw4eagmatq3@hades.localdomain>
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <150153521484.26081.9491485993495513310.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150153521484.26081.9491485993495513310.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Hi,

On Mon, Jul 31, 2017 at 02:06:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This is a purely mechanical patch that removes the private
> __{u,}int{8,16,32,64}_t typedefs in favor of using the system
> {u,}int{8,16,32,64}_t typedefs.  This is the sed script used to perform
> the transformation and fix the resulting whitespace and indentation
> errors:
> 
> s/typedef\t__uint8_t/typedef __uint8_t\t/g
> s/typedef\t__uint/typedef __uint/g
> s/typedef\t__int\([0-9]*\)_t/typedef int\1_t\t/g
> s/__uint8_t\t/__uint8_t\t\t/g
> s/__uint/uint/g
> s/__int\([0-9]*\)_t\t/__int\1_t\t\t/g
> s/__int/int/g
> /^typedef.*int[0-9]*_t;$/d
> 

Loos fine, with a few space X tabs cosmetic changes maybe worth to change?


Anyway, just a suggestion, changing it or not:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  
> diff --git a/db/bit.h b/db/bit.h
> index 80ba24c..9fd71f4 100644
> --- a/db/bit.h
> +++ b/db/bit.h
> @@ -25,5 +25,5 @@
>  #define	BVUNSIGNED	0
>  #define	BVSIGNED	1
>  
> -extern __int64_t	getbitval(void *obj, int bitoff, int nbits, int flags);
> +extern int64_t		getbitval(void *obj, int bitoff, int nbits, int flags);
>  extern void             setbitval(void *obuf, int bitoff, int nbits, void *ibuf);

		^ Maybe worth to fix this space x tabs while in this code?

> diff --git a/db/io.h b/db/io.h
> index 9973004..df0fdd7 100644
> --- a/db/io.h
> +++ b/db/io.h
> @@ -25,7 +25,7 @@ typedef struct bbmap {
>  } bbmap_t;
>  
>  typedef struct iocur {
> -	__int64_t		bb;	/* BB number in filesystem of buf */
> +	int64_t			bb;	/* BB number in filesystem of buf */
>  	int			blen;	/* length of "buf", bb's */
>  	int			boff;	/* data - buf */
>  	void			*buf;	/* base address of buffer */
> @@ -33,7 +33,7 @@ typedef struct iocur {
>  	xfs_ino_t		dirino;	/* current directory inode number */
>  	xfs_ino_t		ino;	/* current inode number */
>  	int			len;	/* length of "data", bytes */
> -	__uint16_t		mode;	/* current inode's mode */
> +	uint16_t		mode;	/* current inode's mode */
>  	xfs_off_t		off;	/* fs offset of "data" in bytes */
>  	const struct typ	*typ;	/* type of "data" */
>  	bbmap_t			*bbmap;	/* map daddr if fragmented */
> @@ -57,7 +57,7 @@ extern void	off_cur(int off, int len);
>  extern void	pop_cur(void);
>  extern void	print_iocur(char *tag, iocur_t *ioc);
>  extern void	push_cur(void);
> -extern int	read_buf(__int64_t daddr, int count, void *bufp);
> +extern int	read_buf(int64_t daddr, int count, void *bufp);
>  extern void     write_cur(void);

		^^

>  
> diff --git a/db/sb.c b/db/sb.c
> index 8e7722c..f19248d 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -606,7 +606,7 @@ version_help(void)
>  }
>  
>  static int
> -do_version(xfs_agnumber_t agno, __uint16_t version, __uint32_t features)
> +do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
>  {
>  	xfs_sb_t	tsb;
>  
> @@ -710,8 +710,8 @@ version_f(
>  	int		argc,
>  	char		**argv)
>  {
> -	__uint16_t	version = 0;
> -	__uint32_t	features = 0;
> +	uint16_t	version = 0;
> +	uint32_t	features = 0;
>  	xfs_agnumber_t	ag;
>  
>  	if (argc == 2) {	/* WRITE VERSION */
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 517b75f..d4846a3 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -54,7 +54,7 @@ struct getbmap  *outmap = NULL;
>  int             outmap_size = 0;

	^^^

>  int		RealUid;
>  int		tmp_agi;
> -static __int64_t	minimumfree = 2048;
> +static int64_t		minimumfree = 2048;
>  
>  #define MNTTYPE_XFS             "xfs"
>  
			^^^

> diff --git a/include/xfs_arch.h b/include/xfs_arch.h
> index 12cd43e..186cadb 100644
> --- a/include/xfs_arch.h
> +++ b/include/xfs_arch.h
> @@ -244,39 +244,39 @@ static inline void be64_add_cpu(__be64 *a, __s64 b)
>  	*a = cpu_to_be64(be64_to_cpu(*a) + b);
>  }
>  
> -static inline __uint16_t get_unaligned_be16(void *p)
> +static inline uint16_t get_unaligned_be16(void *p)
>  {
> -	__uint8_t *__p = p;
> +	uint8_t *__p = p;
>  	return __p[0] << 8 | __p[1];
>  }
>  
> -static inline __uint32_t get_unaligned_be32(void *p)
> +static inline uint32_t get_unaligned_be32(void *p)
>  {
> -	__uint8_t *__p = p;
> +	uint8_t *__p = p;
>          return __p[0] << 24 | __p[1] << 16 | __p[2] << 8 | __p[3];

 ^^^

>  /*
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 6c8a192..43b4f1d 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -118,9 +118,9 @@ static void unmount_record(void *p)
>  	xlog_op_header_t	*op = (xlog_op_header_t *)p;
>  	/* the data section must be 32 bit size aligned */
>  	struct {
> -	    __uint16_t magic;
> -	    __uint16_t pad1;
> -	    __uint32_t pad2; /* may as well make it 64 bits */
> +	    uint16_t magic;
> +	    uint16_t pad1;
> +	    uint32_t pad2; /* may as well make it 64 bits */
>  	} magic = { XLOG_UNMOUNT_TYPE, 0, 0 };

	^^^
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 0dfcfd1..fe27f15 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -166,12 +166,12 @@ xlog_print_trans_header(char **ptr, int len)
>  {
>      xfs_trans_header_t  *h;
>      char		*cptr = *ptr;
> -    __uint32_t          magic;
> +    uint32_t          magic;
>      char                *magic_c = (char *)&magic;
>  

	^^^^


>      *ptr += len;
>  
> -    magic=*(__uint32_t*)cptr; /* XXX be32_to_cpu soon */
> +    magic=*(uint32_t*)cptr; /* XXX be32_to_cpu soon */
>  
>      if (len >= 4) {
>  #if __BYTE_ORDER == __LITTLE_ENDIAN
> @@ -201,7 +201,7 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>      int			 num, skip;
>      int			 super_block = 0;
>      int			 bucket, col, buckets;
> -    __int64_t		 blkno;
> +    int64_t			 blkno;
>      xfs_buf_log_format_t lbuf;
>      int			 size, blen, map_size, struct_size;
>      __be64		 x, y;

	^^^

> --- a/repair/attr_repair.h
> +++ b/repair/attr_repair.h
> @@ -32,10 +32,10 @@
>  #define ACL_WRITE	02
>  #define ACL_EXECUTE	01
>  
>   */
>  #define XFS_MAC_MAX_SETS	250
>  typedef struct xfs_mac_label {
> -	__uint8_t       ml_msen_type;	/* MSEN label type */
> -	__uint8_t       ml_mint_type;	/* MINT label type */
> -	__uint8_t       ml_level;	/* Hierarchical level */
> -	__uint8_t       ml_grade;	/* Hierarchical grade */
> -	__uint16_t      ml_catcount;	/* Category count */
> -	__uint16_t      ml_divcount;	/* Division count */
> +	uint8_t       ml_msen_type;	/* MSEN label type */
> +	uint8_t       ml_mint_type;	/* MINT label type */
> +	uint8_t       ml_level;	/* Hierarchical level */
> +	uint8_t       ml_grade;	/* Hierarchical grade */
> +	uint16_t      ml_catcount;	/* Category count */
> +	uint16_t      ml_divcount;	/* Division count */
>  					/* Category set, then Division set */
> -	__uint16_t      ml_list[XFS_MAC_MAX_SETS];
> +	uint16_t      ml_list[XFS_MAC_MAX_SETS];

		^^^
>  } xfs_mac_label_t;

> diff --git a/repair/avl64.c b/repair/avl64.c
> index 51cd624..8f4a121 100644
> --- a/repair/avl64.c
> +++ b/repair/avl64.c
> @@ -70,8 +70,8 @@ avl64_checktree(
>  	avl64node_t *root)
>  {
>  	avl64node_t *nlast, *nnext, *np;
> -	__uint64_t offset = 0;
> -	__uint64_t end;
> +	uint64_t offset = 0;
> +	uint64_t end;
>  
>  	nlast = nnext = root;
>  
>  avl64node_t *
>  avl64_insert_find_growth(
>  		avl64tree_desc_t *tree,
> -		__uint64_t start,	/* range start at start, */
> -		__uint64_t end,	/* exclusive */
> +		uint64_t start,	/* range start at start, */
> +		uint64_t end,	/* exclusive */
>  		int   *growthp)	/* OUT */
		   ^^^
>  {
>  	avl64node_t *np = tree->avl_root;
> @@ -1378,8 +1378,8 @@ avl64_findadjacent(
>  void
>  avl64_findranges(
>  	avl64tree_desc_t *tree,
> -	__uint64_t start,
> -	__uint64_t end,
> +	uint64_t start,
> +	uint64_t end,
>  	avl64node_t	        **startp,

			^^^

>  	avl64node_t		**endp)
>  {
> diff --git a/repair/avl64.h b/repair/avl64.h
> index fd19321..cd079a0 100644
> --- a/repair/avl64.h
> +++ b/repair/avl64.h
> @@ -32,8 +32,8 @@ typedef struct	avl64node {
>   * avl-tree operations
>   */
>  
>  avl64node_t *
>  avl64_findanyrange(
>  	avl64tree_desc_t *tree,
> -	__uint64_t	start,
> -	__uint64_t	end,
> +	uint64_t	start,
> +	uint64_t	end,
>  	int     checklen);

	^^^
>  
>  
>  avl64node_t *
>  avl64_findadjacent(
>  	avl64tree_desc_t *tree,
> -	__uint64_t	value,
> +	uint64_t	value,
>  	int		dir);
>  
>  void
>  avl64_findranges(
>  	avl64tree_desc_t *tree,
> -	__uint64_t	start,
> -	__uint64_t	end,
> +	uint64_t	start,
> +	uint64_t	end,
>  	avl64node_t	        **startp,

			^^^

>  	avl64node_t		**endp);
>  

-- 
Carlos
