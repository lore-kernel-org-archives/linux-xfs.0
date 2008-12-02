Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2Crt1m017984 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 06:53:56 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35F23AC0AF
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 04:53:52 -0800 (PST)
Date: Tue, 2 Dec 2008 06:59:22 -0600
From: "Bill O'Donnell" <billodo@sgi.com>
Subject: Re: [PATCH 3/9] sanitize xlog_in_core_t definition
Message-ID: <20081202125922.GB27836@sgi.com>
References: <20080925225626.GD9822@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080925225626.GD9822@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@sgi.com

On Fri, Sep 26, 2008 at 12:56:26AM +0200, Christoph Hellwig wrote:
| Move all fields from xlog_iclog_fields_t into xlog_in_core_t instead of having
| them in a substructure and the using #defines to make it look like they were
| directly in xlog_in_core_t.  Also document that xlog_in_core_2_t is grossly
| misnamed, and make all references to it typesafe.

Umm, instead of pointing out the misnaming of xlog_in_core_2_t, why not properly
name it, or does that proliferate too much? 


| 
| 
| Signed-off-by: Christoph Hellwig <hch@lst.de>
| 
| Index: linux-2.6-xfs/fs/xfs/xfs_log.c
| ===================================================================
| --- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2008-09-25 13:58:24.000000000 +0200
| +++ linux-2.6-xfs/fs/xfs/xfs_log.c	2008-09-25 20:02:34.000000000 +0200
| @@ -1024,12 +1024,6 @@ xlog_iodone(xfs_buf_t *bp)
|  	ASSERT(XFS_BUF_FSPRIVATE2(bp, unsigned long) == (unsigned long) 2);
|  	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
|  	aborted = 0;
| -
| -	/*
| -	 * Some versions of cpp barf on the recursive definition of
| -	 * ic_log -> hic_fields.ic_log and expand ic_log twice when
| -	 * it is passed through two macros.  Workaround broken cpp.
| -	 */
|  	l = iclog->ic_log;
|  
|  	/*
| @@ -1287,7 +1281,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
|  		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
|  		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
|  		iclog->ic_bp = bp;
| -		iclog->hic_data = bp->b_addr;
| +		iclog->ic_data = bp->b_addr;
|  #ifdef DEBUG
|  		log->l_iclog_bak[i] = (xfs_caddr_t)&(iclog->ic_header);
|  #endif
| @@ -1307,7 +1301,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
|  		atomic_set(&iclog->ic_refcnt, 0);
|  		spin_lock_init(&iclog->ic_callback_lock);
|  		iclog->ic_callback_tail = &(iclog->ic_callback);
| -		iclog->ic_datap = (char *)iclog->hic_data + log->l_iclog_hsize;
| +		iclog->ic_datap = (char *)iclog->ic_data + log->l_iclog_hsize;
|  
|  		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
|  		ASSERT(XFS_BUF_VALUSEMA(iclog->ic_bp) <= 0);
| @@ -3418,7 +3412,7 @@ xlog_verify_iclog(xlog_t	 *log,
|  	ptr = iclog->ic_datap;
|  	base_ptr = ptr;
|  	ophead = (xlog_op_header_t *)ptr;
| -	xhdr = (xlog_in_core_2_t *)&iclog->ic_header;
| +	xhdr = iclog->ic_data;
|  	for (i = 0; i < len; i++) {
|  		ophead = (xlog_op_header_t *)ptr;
|  
| Index: linux-2.6-xfs/fs/xfs/xfs_log_priv.h
| ===================================================================
| --- linux-2.6-xfs.orig/fs/xfs/xfs_log_priv.h	2008-09-25 13:58:24.000000000 +0200
| +++ linux-2.6-xfs/fs/xfs/xfs_log_priv.h	2008-09-25 20:02:35.000000000 +0200
| @@ -309,6 +309,16 @@ typedef struct xlog_rec_ext_header {
|  } xlog_rec_ext_header_t;
|  
|  #ifdef __KERNEL__
| +
| +/*
| + * Quite misnamed, because this union lays out the actual on-disk log buffer.
| + */
| +typedef union xlog_in_core2 {
| +	xlog_rec_header_t	hic_header;
| +	xlog_rec_ext_header_t	hic_xheader;
| +	char			hic_sector[XLOG_HEADER_SIZE];
| +} xlog_in_core_2_t;
| +

See my above comment.




|  /*
|   * - A log record header is 512 bytes.  There is plenty of room to grow the
|   *	xlog_rec_header_t into the reserved space.
| @@ -338,7 +348,7 @@ typedef struct xlog_rec_ext_header {
|   * We'll put all the read-only and l_icloglock fields in the first cacheline,
|   * and move everything else out to subsequent cachelines.
|   */
| -typedef struct xlog_iclog_fields {
| +typedef struct xlog_in_core {
|  	sv_t			ic_force_wait;
|  	sv_t			ic_write_wait;
|  	struct xlog_in_core	*ic_next;
| @@ -361,41 +371,11 @@ typedef struct xlog_iclog_fields {
|  
|  	/* reference counts need their own cacheline */
|  	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
| -} xlog_iclog_fields_t;
| -
| -typedef union xlog_in_core2 {
| -	xlog_rec_header_t	hic_header;
| -	xlog_rec_ext_header_t	hic_xheader;
| -	char			hic_sector[XLOG_HEADER_SIZE];
| -} xlog_in_core_2_t;
| -
| -typedef struct xlog_in_core {
| -	xlog_iclog_fields_t	hic_fields;
| -	xlog_in_core_2_t	*hic_data;
| +	xlog_in_core_2_t	*ic_data;
| +#define ic_header	ic_data->hic_header
|  } xlog_in_core_t;
|  
|  /*
| - * Defines to save our code from this glop.
| - */
| -#define	ic_force_wait	hic_fields.ic_force_wait
| -#define ic_write_wait	hic_fields.ic_write_wait
| -#define	ic_next		hic_fields.ic_next
| -#define	ic_prev		hic_fields.ic_prev
| -#define	ic_bp		hic_fields.ic_bp
| -#define	ic_log		hic_fields.ic_log
| -#define	ic_callback	hic_fields.ic_callback
| -#define	ic_callback_lock hic_fields.ic_callback_lock
| -#define	ic_callback_tail hic_fields.ic_callback_tail
| -#define	ic_trace	hic_fields.ic_trace
| -#define	ic_size		hic_fields.ic_size
| -#define	ic_offset	hic_fields.ic_offset
| -#define	ic_refcnt	hic_fields.ic_refcnt
| -#define	ic_bwritecnt	hic_fields.ic_bwritecnt
| -#define	ic_state	hic_fields.ic_state
| -#define ic_datap	hic_fields.ic_datap
| -#define ic_header	hic_data->hic_header
| -
| -/*
|   * The reservation head lsn is not made up of a cycle number and block number.
|   * Instead, it uses a cycle number and byte number.  Logs don't expect to
|   * overflow 31 bits worth of byte offset, so using a byte number will mean
| Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
| ===================================================================
| --- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-09-25 13:58:24.000000000 +0200
| +++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-09-25 20:02:39.000000000 +0200
| @@ -3359,7 +3359,6 @@ xlog_pack_data(
|  	int			size = iclog->ic_offset + roundoff;
|  	__be32			cycle_lsn;
|  	xfs_caddr_t		dp;
| -	xlog_in_core_2_t	*xhdr;
|  
|  	xlog_pack_data_checksum(log, iclog, size);
|  
| @@ -3374,7 +3373,8 @@ xlog_pack_data(
|  	}
|  
|  	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
| -		xhdr = (xlog_in_core_2_t *)&iclog->ic_header;
| +		xlog_in_core_2_t *xhdr = iclog->ic_data;
| +
|  		for ( ; i < BTOBB(size); i++) {
|  			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
|  			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
| @@ -3432,7 +3432,6 @@ xlog_unpack_data(
|  	xlog_t			*log)
|  {
|  	int			i, j, k;
| -	xlog_in_core_2_t	*xhdr;
|  
|  	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
|  		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
| @@ -3441,7 +3440,7 @@ xlog_unpack_data(
|  	}
|  
|  	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
| -		xhdr = (xlog_in_core_2_t *)rhead;
| +		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
|  		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
|  			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
|  			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
| Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
| ===================================================================
| --- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-09-25 13:58:24.000000000 +0200
| +++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-09-25 20:02:39.000000000 +0200
| @@ -5763,7 +5763,7 @@ xfsidbg_xiclog(xlog_in_core_t *iclog)
|  	};
|  
|  	kdb_printf("xlog_in_core/header at 0x%p/0x%p\n",
| -		iclog, iclog->hic_data);
| +		iclog, iclog->ic_data);
|  	kdb_printf("magicno: %x  cycle: %d  version: %d  lsn: 0x%Lx\n",
|  		be32_to_cpu(iclog->ic_header.h_magicno),
|  		be32_to_cpu(iclog->ic_header.h_cycle),
| 
| -- 
| 
| 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
