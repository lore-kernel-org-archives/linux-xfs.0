Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DF9B27F5D
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 14:18:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57D44AC001
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:18:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mMwAgGEHyzo78NfM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:18:28 -0700 (PDT)
Date: Mon, 14 Sep 2015 15:18:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/13] xfs_repair: add XR_DIR_TRACE to dir2.c
Message-ID: <20150914191825.GF34083@bfoster.bfoster>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
	<1441827251-13128-7-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441827251-13128-7-git-send-email-sandeen@sandeen.net>
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

On Wed, Sep 09, 2015 at 02:34:04PM -0500, Eric Sandeen wrote:
> attr_repair.c has many printf-tracepoints under
> #ifdef XR_DIR_TRACE, but the similar code in dir2.c does not.
> 
> Add these same tracepoints to remove more differences between
> these two pieces of code.
> 
> Not all messages are quite correct; those will be fixed up last.
> For now we just make the code more obviously similar.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/dir2.c |   39 ++++++++++++++++++++++++++++++++++++---
>  1 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 898b27e..d9bd5fc 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -337,6 +337,11 @@ verify_final_dir2_path(xfs_mount_t	*mp,
>  	struct xfs_da_node_entry *btree;
>  	struct xfs_da3_icnode_hdr nodehdr;
>  
> +#ifdef XR_DIR_TRACE
> +	fprintf(stderr, "in verify_final_dir2_path, this_level = %d\n",
> +		this_level);
> +#endif
> +
>  	/*
>  	 * the index should point to the next "unprocessed" entry
>  	 * in the block which should be the final (rightmost) entry
> @@ -388,8 +393,17 @@ verify_final_dir2_path(xfs_mount_t	*mp,
>  	/*
>  	 * ok, now check descendant block number against this level
>  	 */
> -	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before))
> +	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before)) {
> +#ifdef XR_DIR_TRACE
> +		fprintf(stderr, "bad directory btree pointer, child bno should "
> +				"be %d, block bno is %d, hashval is %u\n",
> +			be16_to_cpu(btree[entry].before),
> +			cursor->level[p_level].bno,
> +			cursor->level[p_level].hashval);
> +		fprintf(stderr, "verify_final_dir2_path returns 1 (bad) #1a\n");
> +#endif
>  		return(1);
> +	}
>  
>  	if (cursor->level[p_level].hashval !=
>  				be32_to_cpu(btree[entry].hashval))  {
> @@ -431,8 +445,12 @@ _("would correct bad hashval in non-leaf dir block\n"
>  	/*
>  	 * bail out if this is the root block (top of tree)
>  	 */
> -	if (this_level >= cursor->active)
> +	if (this_level >= cursor->active) {
> +#ifdef XR_DIR_TRACE
> +		fprintf(stderr, "verify_final_dir2_path returns 0 (ok)\n");
> +#endif
>  		return(0);
> +	}
>  	/*
>  	 * set hashvalue to correctl reflect the now-validated
>  	 * last entry in this block and continue upwards validation
> @@ -600,6 +618,9 @@ _("bad level %d in block %u for directory inode %" PRIu64 "\n"),
>  			bad++;
>  		}
>  		if (bad)  {
> +#ifdef XR_DIR_TRACE
> +			fprintf(stderr, "verify_dir2_path returns 1 (bad) #4\n");
> +#endif
>  			libxfs_putbuf(bp);
>  			return(1);
>  		}
> @@ -631,8 +652,17 @@ _("bad level %d in block %u for directory inode %" PRIu64 "\n"),
>  	/*
>  	 * ditto for block numbers
>  	 */
> -	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before))
> +	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before)) {
> +#ifdef XR_DIR_TRACE
> +		fprintf(stderr, "bad directory btree pointer, child bno "
> +			"should be %d, block bno is %d, hashval is %u\n",
> +			be32_to_cpu(btree[entry].before),
> +			cursor->level[p_level].bno,
> +			cursor->level[p_level].hashval);
> +		fprintf(stderr, "verify_dir2_path returns 1 (bad) #1a\n");
> +#endif
>  		return(1);
> +	}
>  	/*
>  	 * ok, now validate last hashvalue in the descendant
>  	 * block against the hashval in the current entry
> @@ -659,6 +689,9 @@ _("would correct bad hashval in interior dir block\n"
>  	 * (which should point to the next descendant block)
>  	 */
>  	cursor->level[this_level].index++;
> +#ifdef XR_DIR_TRACE
> +       fprintf(stderr, "verify_dir2_path returns 0 (ok)\n");
> +#endif
>  	return(0);
>  }
>  
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
