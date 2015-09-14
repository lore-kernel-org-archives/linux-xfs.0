Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 61F8A7F37
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 14:18:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3FFB28F8035
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:18:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YUmat5cBNB911nZP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:18:01 -0700 (PDT)
Date: Mon, 14 Sep 2015 15:17:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/13] xfs_repair: remove trace-only 'n' member from
	da_level_state
Message-ID: <20150914191757.GA34083@bfoster.bfoster>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
	<1441827251-13128-2-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441827251-13128-2-git-send-email-sandeen@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Sep 09, 2015 at 02:33:59PM -0500, Eric Sandeen wrote:
> The da_level_state structure contains an 'n' member
> when XR_DIR_TRACE is enabled, which is a) write only, and
> b) set by a macro which doesn't exist (XFS_BUF_TO_DA_INTNODE)
> 
> Removing this structure member fixes compilation with
> XR_DIR_TRACE enabled, and also makes da_level_state identical
> to dir2_level_state, so the two can be combined later.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/attr_repair.c |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index debe9e8..d63bc87 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -59,9 +59,6 @@ typedef unsigned char	da_freemap_t;
>   */
>  typedef struct da_level_state  {
>  	xfs_buf_t	*bp;		/* block bp */
> -#ifdef XR_DIR_TRACE
> -	xfs_da_intnode_t *n;		/* bp data */
> -#endif
>  	xfs_dablk_t	bno;		/* file block number */
>  	xfs_dahash_t	hashval;	/* last verified hashval */
>  	int		index;		/* current index in block */
> @@ -232,9 +229,6 @@ traverse_int_dablock(xfs_mount_t	*mp,
>  		da_cursor->level[i].bp = bp;
>  		da_cursor->level[i].bno = bno;
>  		da_cursor->level[i].index = 0;
> -#ifdef XR_DIR_TRACE
> -		da_cursor->level[i].n = XFS_BUF_TO_DA_INTNODE(bp);
> -#endif
>  
>  		/*
>  		 * set up new bno for next level down
> @@ -624,9 +618,6 @@ verify_da_path(xfs_mount_t	*mp,
>  		cursor->level[this_level].bno = dabno;
>  		cursor->level[this_level].hashval =
>  					be32_to_cpu(btree[0].hashval);
> -#ifdef XR_DIR_TRACE
> -		cursor->level[this_level].n = newnode;
> -#endif
>  		entry = cursor->level[this_level].index = 0;
>  
>  		/*
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
