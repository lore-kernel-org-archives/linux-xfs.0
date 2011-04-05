Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3507SfJ206208 for <xfs@oss.sgi.com>; Mon, 4 Apr 2011 19:07:28 -0500
Received: from twin.jikos.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A30812B4E34
	for <xfs@oss.sgi.com>; Mon,  4 Apr 2011 17:10:42 -0700 (PDT)
Received: from twin.jikos.cz (twin.jikos.cz [89.185.236.188]) by cuda.sgi.com
	with ESMTP id FrpMmxOX09d9ajsC for <xfs@oss.sgi.com>;
	Mon, 04 Apr 2011 17:10:42 -0700 (PDT)
Received: from twin.jikos.cz (dave@localhost [127.0.0.1])
	by twin.jikos.cz (8.13.6/8.13.6) with ESMTP id p350AfC3023907
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 5 Apr 2011 02:10:41 +0200
Received: (from dave@localhost)
	by twin.jikos.cz (8.13.6/8.13.6/Submit) id p350AfAL023906
	for xfs@oss.sgi.com; Tue, 5 Apr 2011 02:10:41 +0200
Date: Tue, 5 Apr 2011 02:10:40 +0200
From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] xfs: fix variable set but not used warnings
Message-ID: <20110405001040.GD31675@twin.jikos.cz>
References: <20110404125544.GA726@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110404125544.GA726@infradead.org>
Reply-To: dave@jikos.cz
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

besides the accflags commented in another mail, the rest is ok, but I'll
flush my finding anyway, JFYI.

dave

On Mon, Apr 04, 2011 at 08:55:44AM -0400, Christoph Hellwig wrote:
> GCC 4.6 now warnings about variables set but not used.  Fix the trivially
> fixable warnings of this sort.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-04-03 06:47:59.406434458 -0700
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2011-04-03 06:48:16.276433605 -0700
> @@ -293,7 +293,6 @@ xfs_buf_allocate_memory(
>  	size_t			nbytes, offset;
>  	gfp_t			gfp_mask = xb_to_gfp(flags);
>  	unsigned short		page_count, i;
> -	pgoff_t			first;
>  	xfs_off_t		end;
>  	int			error;
>  
> @@ -333,7 +332,6 @@ use_alloc_page:
>  		return error;
>  
>  	offset = bp->b_offset;
> -	first = bp->b_file_offset >> PAGE_SHIFT;

leftover from

commit 0e6e847ffe37436e331c132639f9f872febce82e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Sat Mar 26 09:16:45 2011 +1100
    xfs: stop using the page cache to back the buffer cache

originally used by find_or_create_page()

>  	bp->b_flags |= _XBF_PAGES;
>  
>  	for (i = 0; i < bp->b_page_count; i++) {
> Index: linux-2.6/fs/xfs/quota/xfs_qm.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/quota/xfs_qm.c	2011-04-03 06:43:03.563116104 -0700
> +++ linux-2.6/fs/xfs/quota/xfs_qm.c	2011-04-03 06:44:26.459778573 -0700
> @@ -461,12 +461,10 @@ xfs_qm_dqflush_all(
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	int			recl;
>  	struct xfs_dquot	*dqp;
> -	int			niters;
>  	int			error;
>  
>  	if (!q)
>  		return 0;
> -	niters = 0;
>  again:
>  	mutex_lock(&q->qi_dqlist_lock);
>  	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
> @@ -1314,14 +1312,9 @@ xfs_qm_dqiter_bufs(
>  {
>  	xfs_buf_t	*bp;
>  	int		error;
> -	int		notcommitted;
> -	int		incr;
>  	int		type;
>  
>  	ASSERT(blkcnt > 0);
> -	notcommitted = 0;
> -	incr = (blkcnt > XFS_QM_MAX_DQCLUSTER_LOGSZ) ?
> -		XFS_QM_MAX_DQCLUSTER_LOGSZ : blkcnt;

dead variables since the original git commit

>  	type = flags & XFS_QMOPT_UQUOTA ? XFS_DQ_USER :
>  		(flags & XFS_QMOPT_PQUOTA ? XFS_DQ_PROJ : XFS_DQ_GROUP);
>  	error = 0;
> Index: linux-2.6/fs/xfs/quota/xfs_qm.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/quota/xfs_qm.h	2011-04-03 06:43:34.569781201 -0700
> +++ linux-2.6/fs/xfs/quota/xfs_qm.h	2011-04-03 06:43:41.396447521 -0700
> @@ -65,11 +65,6 @@ extern kmem_zone_t	*qm_dqtrxzone;
>   * block in the dquot/xqm code.
>   */
>  #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
> -/*
> - * When doing a quotacheck, we log dquot clusters of this many FSBs at most
> - * in a single transaction. We don't want to ask for too huge a log reservation.
> - */
> -#define XFS_QM_MAX_DQCLUSTER_LOGSZ	3
>  
>  typedef xfs_dqhash_t	xfs_dqlist_t;
>  
> Index: linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/quota/xfs_qm_syscalls.c	2011-04-03 06:40:45.399789765 -0700
> +++ linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c	2011-04-03 06:43:00.219782939 -0700
> @@ -313,14 +313,12 @@ xfs_qm_scall_quotaon(
>  {
>  	int		error;
>  	uint		qf;
> -	uint		accflags;
>  	__int64_t	sbflags;
>  
>  	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
>  	/*
>  	 * Switching on quota accounting must be done at mount time.
>  	 */
> -	accflags = flags & XFS_ALL_QUOTA_ACCT;

(commented in another mail)

>  	flags &= ~(XFS_ALL_QUOTA_ACCT);
>  
>  	sbflags = 0;
> Index: linux-2.6/fs/xfs/xfs_itable.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_itable.c	2011-04-03 06:47:24.483102893 -0700
> +++ linux-2.6/fs/xfs/xfs_itable.c	2011-04-03 06:47:47.356435070 -0700
> @@ -204,7 +204,6 @@ xfs_bulkstat(
>  	xfs_agi_t		*agi;	/* agi header data */
>  	xfs_agino_t		agino;	/* inode # in allocation group */
>  	xfs_agnumber_t		agno;	/* allocation group number */
> -	xfs_daddr_t		bno;	/* inode cluster start daddr */
>  	int			chunkidx; /* current index into inode chunk */
>  	int			clustidx; /* current index into inode cluster */
>  	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
> @@ -463,7 +462,6 @@ xfs_bulkstat(
>  						 mp->m_sb.sb_inopblog);
>  				}
>  				ino = XFS_AGINO_TO_INO(mp, agno, agino);
> -				bno = XFS_AGB_TO_DADDR(mp, agno, agbno);

a leftover from

commit 7b6259e7a83647948fa33a736cc832310c8d85aa
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Jun 24 11:35:17 2010 +1000
    xfs: remove block number from inode lookup code

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
