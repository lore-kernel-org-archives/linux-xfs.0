Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 134597F50
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 17:15:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 025AD8F8040
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 15:15:07 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ENg4DxssyGwUa4VE for <xfs@oss.sgi.com>;
	Thu, 15 Jan 2015 15:15:04 -0800 (PST)
Message-ID: <54B849F7.70400@sandeen.net>
Date: Thu, 15 Jan 2015 17:15:03 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] repair: remove unused strided secondary sb scan logic
References: <1421179693-17227-1-git-send-email-bfoster@redhat.com>
	<1421179693-17227-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1421179693-17227-3-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 1/13/15 2:08 PM, Brian Foster wrote:
> verify_set_primary_sb() scans and verifies secondary superblocks based
> on the primary sb. It currently defines a maximum number of 8
> superblocks to scan per iteration. It also implements a strided
> algorithm that appears intended to ultimately scan every secondary,
> albeit in a strided order.
> 
> Given that the algorithm is written to hit every sb and the stride value
> is initialized as follows:
> 
> 	num_sbs = MIN(NUM_SBS, rsb->sb_agcount);
> 	skip = howmany(num_sbs, rsb->sb_agcount);
> 
> ... which is guaranteed to be 1 since the howmany() parameters are
> backwards, the strided algorithm doesn't appear to accomplish anything
> that can't be done with a simple for loop. In other words, despite the
> max value and strided algorithm, repair always scans all of the
> secondary superblocks in incremental order.
> 
> Therefore, remove the strided algorithm bits and replace with a simple
> for loop. As a result of this cleanup, also remove the 'checked' buffer
> used to track repeated ag visits and the now unused NUM_SBS definition.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

This looks fine too.  I can't see any reason to do the strided check,
even if it works...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/globals.h |  2 --
>  repair/sb.c      | 63 ++++++++++++++++++--------------------------------------
>  2 files changed, 20 insertions(+), 45 deletions(-)
> 
> diff --git a/repair/globals.h b/repair/globals.h
> index 6207ca1..f386686 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -57,7 +57,6 @@
>  #define XR_LOG2BSIZE_MIN	9	/* min/max fs blocksize (log2) */
>  #define XR_LOG2BSIZE_MAX	16	/* 2^XR_* == blocksize */
>  
> -#define	NUM_SBS			8	/* max # of sbs to verify */
>  #define NUM_AGH_SECTS		4	/* # of components in an ag header */
>  
>  /*
> @@ -88,7 +87,6 @@ EXTERN char	*iobuf;			/* large buffer */
>  EXTERN int	iobuf_size;
>  EXTERN char	*smallbuf;		/* small (1-4 page) buffer */
>  EXTERN int	smallbuf_size;
> -EXTERN char	*sb_bufs[NUM_SBS];	/* superblock buffers */
>  EXTERN int	sbbuf_size;
>  
>  /* direct I/O info */
> diff --git a/repair/sb.c b/repair/sb.c
> index dc154f7..a663728 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -702,20 +702,11 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
>  	xfs_sb_t	*sb;
>  	fs_geo_list_t	*list;
>  	fs_geo_list_t	*current;
> -	char		*checked;
>  	xfs_agnumber_t	agno;
>  	int		num_sbs;
> -	int		skip;
>  	int		size;
>  	int		num_ok;
>  	int		retval;
> -	int		round;
> -
> -	/*
> -	 * select the number of secondaries to try for
> -	 */
> -	num_sbs = MIN(NUM_SBS, rsb->sb_agcount);
> -	skip = howmany(num_sbs, rsb->sb_agcount);
>  
>  	/*
>  	 * We haven't been able to validate the sector size yet properly
> @@ -727,51 +718,38 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
>  	list = NULL;
>  	num_ok = 0;
>  	*sb_modified = 0;
> +	num_sbs = rsb->sb_agcount;
>  
>  	sb = (xfs_sb_t *) alloc_ag_buf(size);
> -	checked = calloc(rsb->sb_agcount, sizeof(char));
> -	if (!checked) {
> -		do_error(_("calloc failed in verify_set_primary_sb\n"));
> -		exit(1);
> -	}
>  
>  	/*
>  	 * put the primary sb geometry info onto the geometry list
>  	 */
> -	checked[sb_index] = 1;
>  	get_sb_geometry(&geo, rsb);
>  	list = add_geo(list, &geo, sb_index);
>  
>  	/*
> -	 * grab N secondaries.  check them off as we get them
> -	 * so we only process each one once
> +	 * scan the secondaries and check them off as we get them so we only
> +	 * process each one once
>  	 */
> -	for (round = 0; round < skip; round++)  {
> -		for (agno = round; agno < rsb->sb_agcount; agno += skip)  {
> -			if (checked[agno])
> -				continue;
> +	for (agno = 1; agno < rsb->sb_agcount; agno++) {
> +		off = (xfs_off_t)agno * rsb->sb_agblocks << rsb->sb_blocklog;
>  
> -			off = (xfs_off_t)agno * rsb->sb_agblocks << rsb->sb_blocklog;
> -
> -			checked[agno] = 1;
> -			retval = get_sb(sb, off, size, agno);
> -			if (retval == XR_EOF)
> -				goto out_free_list;
> -
> -			if (retval == XR_OK) {
> -				/*
> -				 * save away geometry info.
> -				 * don't bother checking the sb
> -				 * against the agi/agf as the odds
> -				 * of the sb being corrupted in a way
> -				 * that it is internally consistent
> -				 * but not consistent with the rest
> -				 * of the filesystem is really really low.
> -				 */
> -				get_sb_geometry(&geo, sb);
> -				list = add_geo(list, &geo, agno);
> -				num_ok++;
> -			}
> +		retval = get_sb(sb, off, size, agno);
> +		if (retval == XR_EOF)
> +			goto out_free_list;
> +
> +		if (retval == XR_OK) {
> +			/*
> +			 * save away geometry info. don't bother checking the
> +			 * sb against the agi/agf as the odds of the sb being
> +			 * corrupted in a way that it is internally consistent
> +			 * but not consistent with the rest of the filesystem is
> +			 * really really low.
> +			 */
> +			get_sb_geometry(&geo, sb);
> +			list = add_geo(list, &geo, agno);
> +			num_ok++;
>  		}
>  	}
>  
> @@ -867,6 +845,5 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
>  out_free_list:
>  	free_geo(list);
>  	free(sb);
> -	free(checked);
>  	return retval;
>  }
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
