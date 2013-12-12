Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1070D29E1B
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:59:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E448F8F8040
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:59:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UFBkNgwgcWyGFOXJ for
	<xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:59:01 -0800 (PST)
Message-ID: <52AA0773.1000506@redhat.com>
Date: Thu, 12 Dec 2013 13:58:59 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/5] repair: per AG locks contend for cachelines
References: <1386832945-19763-1-git-send-email-david@fromorbit.com>
	<1386832945-19763-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1386832945-19763-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 12/12/2013 02:22 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The per-ag locks used to protect per-ag block lists are located in a tightly
> packed array. That means that they share cachelines, so separate them out inot
> separate 64 byte regions in the array.
> 
> pahole confirms the padding is correctly applied:
> 
> struct aglock {
>         pthread_mutex_t            lock;                 /*     0    40 */
> 
>         /* size: 64, cachelines: 1, members: 1 */
>         /* padding: 24 */
> };
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Out of curiosity, any data on this one?

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/dino_chunks.c | 24 ++++++++++++------------
>  repair/dinode.c      |  6 +++---
>  repair/globals.h     |  5 ++++-
>  repair/incore.c      |  4 ++--
>  repair/scan.c        |  4 ++--
>  5 files changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index d3c2236..02d32d8 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -141,7 +141,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
>  		if (check_aginode_block(mp, agno, agino) == 0)
>  			return 0;
>  
> -		pthread_mutex_lock(&ag_locks[agno]);
> +		pthread_mutex_lock(&ag_locks[agno].lock);
>  
>  		state = get_bmap(agno, agbno);
>  		switch (state) {
> @@ -166,7 +166,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
>  		_("inode block %d/%d multiply claimed, (state %d)\n"),
>  				agno, agbno, state);
>  			set_bmap(agno, agbno, XR_E_MULT);
> -			pthread_mutex_unlock(&ag_locks[agno]);
> +			pthread_mutex_unlock(&ag_locks[agno].lock);
>  			return(0);
>  		default:
>  			do_warn(
> @@ -176,7 +176,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
>  			break;
>  		}
>  
> -		pthread_mutex_unlock(&ag_locks[agno]);
> +		pthread_mutex_unlock(&ag_locks[agno].lock);
>  
>  		start_agino = XFS_OFFBNO_TO_AGINO(mp, agbno, 0);
>  		*start_ino = XFS_AGINO_TO_INO(mp, agno, start_agino);
> @@ -424,7 +424,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
>  	 * user data -- we're probably here as a result of a directory
>  	 * entry or an iunlinked pointer
>  	 */
> -	pthread_mutex_lock(&ag_locks[agno]);
> +	pthread_mutex_lock(&ag_locks[agno].lock);
>  	for (cur_agbno = chunk_start_agbno;
>  	     cur_agbno < chunk_stop_agbno;
>  	     cur_agbno += blen)  {
> @@ -438,7 +438,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
>  	_("inode block %d/%d multiply claimed, (state %d)\n"),
>  				agno, cur_agbno, state);
>  			set_bmap_ext(agno, cur_agbno, blen, XR_E_MULT);
> -			pthread_mutex_unlock(&ag_locks[agno]);
> +			pthread_mutex_unlock(&ag_locks[agno].lock);
>  			return 0;
>  		case XR_E_INO:
>  			do_error(
> @@ -449,7 +449,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
>  			break;
>  		}
>  	}
> -	pthread_mutex_unlock(&ag_locks[agno]);
> +	pthread_mutex_unlock(&ag_locks[agno].lock);
>  
>  	/*
>  	 * ok, chunk is good.  put the record into the tree if required,
> @@ -472,7 +472,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
>  
>  	set_inode_used(irec_p, agino - start_agino);
>  
> -	pthread_mutex_lock(&ag_locks[agno]);
> +	pthread_mutex_lock(&ag_locks[agno].lock);
>  
>  	for (cur_agbno = chunk_start_agbno;
>  	     cur_agbno < chunk_stop_agbno;
> @@ -505,7 +505,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
>  			break;
>  		}
>  	}
> -	pthread_mutex_unlock(&ag_locks[agno]);
> +	pthread_mutex_unlock(&ag_locks[agno].lock);
>  
>  	return(ino_cnt);
>  }
> @@ -736,7 +736,7 @@ process_inode_chunk(
>  	/*
>  	 * mark block as an inode block in the incore bitmap
>  	 */
> -	pthread_mutex_lock(&ag_locks[agno]);
> +	pthread_mutex_lock(&ag_locks[agno].lock);
>  	state = get_bmap(agno, agbno);
>  	switch (state) {
>  	case XR_E_INO:	/* already marked */
> @@ -755,7 +755,7 @@ process_inode_chunk(
>  			XFS_AGB_TO_FSB(mp, agno, agbno), state);
>  		break;
>  	}
> -	pthread_mutex_unlock(&ag_locks[agno]);
> +	pthread_mutex_unlock(&ag_locks[agno].lock);
>  
>  	for (;;) {
>  		/*
> @@ -914,7 +914,7 @@ process_inode_chunk(
>  			ibuf_offset = 0;
>  			agbno++;
>  
> -			pthread_mutex_lock(&ag_locks[agno]);
> +			pthread_mutex_lock(&ag_locks[agno].lock);
>  			state = get_bmap(agno, agbno);
>  			switch (state) {
>  			case XR_E_INO:	/* already marked */
> @@ -935,7 +935,7 @@ process_inode_chunk(
>  					XFS_AGB_TO_FSB(mp, agno, agbno), state);
>  				break;
>  			}
> -			pthread_mutex_unlock(&ag_locks[agno]);
> +			pthread_mutex_unlock(&ag_locks[agno].lock);
>  
>  		} else if (irec_offset == XFS_INODES_PER_CHUNK)  {
>  			/*
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8f14a9e..77bbe40 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -700,8 +700,8 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
>  		ebno = agbno + irec.br_blockcount;
>  		if (agno != locked_agno) {
>  			if (locked_agno != -1)
> -				pthread_mutex_unlock(&ag_locks[locked_agno]);
> -			pthread_mutex_lock(&ag_locks[agno]);
> +				pthread_mutex_unlock(&ag_locks[locked_agno].lock);
> +			pthread_mutex_lock(&ag_locks[agno].lock);
>  			locked_agno = agno;
>  		}
>  
> @@ -770,7 +770,7 @@ _("illegal state %d in block map %" PRIu64 "\n"),
>  	error = 0;
>  done:
>  	if (locked_agno != -1)
> -		pthread_mutex_unlock(&ag_locks[locked_agno]);
> +		pthread_mutex_unlock(&ag_locks[locked_agno].lock);
>  
>  	if (i != *numrecs) {
>  		ASSERT(i < *numrecs);
> diff --git a/repair/globals.h b/repair/globals.h
> index aef8b79..cbb2ce7 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -186,7 +186,10 @@ EXTERN xfs_extlen_t	sb_inoalignmt;
>  EXTERN __uint32_t	sb_unit;
>  EXTERN __uint32_t	sb_width;
>  
> -EXTERN pthread_mutex_t	*ag_locks;
> +struct aglock {
> +	pthread_mutex_t	lock __attribute__((__aligned__(64)));
> +};
> +EXTERN struct aglock	*ag_locks;
>  
>  EXTERN int 		report_interval;
>  EXTERN __uint64_t 	*prog_rpt_done;
> diff --git a/repair/incore.c b/repair/incore.c
> index 3590464..a8d497e 100644
> --- a/repair/incore.c
> +++ b/repair/incore.c
> @@ -294,13 +294,13 @@ init_bmaps(xfs_mount_t *mp)
>  	if (!ag_bmap)
>  		do_error(_("couldn't allocate block map btree roots\n"));
>  
> -	ag_locks = calloc(mp->m_sb.sb_agcount, sizeof(pthread_mutex_t));
> +	ag_locks = calloc(mp->m_sb.sb_agcount, sizeof(struct aglock));
>  	if (!ag_locks)
>  		do_error(_("couldn't allocate block map locks\n"));
>  
>  	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
>  		btree_init(&ag_bmap[i]);
> -		pthread_mutex_init(&ag_locks[i], NULL);
> +		pthread_mutex_init(&ag_locks[i].lock, NULL);
>  	}
>  
>  	init_rt_bmap(mp);
> diff --git a/repair/scan.c b/repair/scan.c
> index 49ed194..f9afdb1 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -273,7 +273,7 @@ _("bad back (left) sibling pointer (saw %llu should be NULL (0))\n"
>  		agno = XFS_FSB_TO_AGNO(mp, bno);
>  		agbno = XFS_FSB_TO_AGBNO(mp, bno);
>  
> -		pthread_mutex_lock(&ag_locks[agno]);
> +		pthread_mutex_lock(&ag_locks[agno].lock);
>  		state = get_bmap(agno, agbno);
>  		switch (state) {
>  		case XR_E_UNKNOWN:
> @@ -319,7 +319,7 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
>  				state, ino, bno);
>  			break;
>  		}
> -		pthread_mutex_unlock(&ag_locks[agno]);
> +		pthread_mutex_unlock(&ag_locks[agno].lock);
>  	} else  {
>  		/*
>  		 * attribute fork for realtime files is in the regular
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
