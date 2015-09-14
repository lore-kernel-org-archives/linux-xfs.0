Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E3D37F61
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 14:18:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1DC02304048
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:18:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kCQ7lsEBtX05UsxS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:18:24 -0700 (PDT)
Date: Mon, 14 Sep 2015 15:18:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/13] xfs_repair: fix use-after-free in
	verify_final_dir2_path
Message-ID: <20150914191821.GE34083@bfoster.bfoster>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
	<1441827251-13128-6-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441827251-13128-6-git-send-email-sandeen@sandeen.net>
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

On Wed, Sep 09, 2015 at 02:34:03PM -0500, Eric Sandeen wrote:
> Way back in 2002, commit 948ce18 fixed a potential use-after-free
> in verify_final_da_path, but the same fix was not applied to
> verify_final_dir2_path; apply it now.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/dir2.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 44367c6..898b27e 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -330,6 +330,7 @@ verify_final_dir2_path(xfs_mount_t	*mp,
>  		const int		p_level)
>  {
>  	xfs_da_intnode_t	*node;
> +	xfs_dahash_t		hashval;
>  	int			bad = 0;
>  	int			entry;
>  	int			this_level = p_level + 1;
> @@ -409,6 +410,12 @@ _("would correct bad hashval in non-leaf dir block\n"
>  	}
>  
>  	/*
> +	 * Note: squirrel hashval away _before_ releasing the
> +	 * buffer, preventing a use-after-free problem.
> +	 */
> +	hashval = be32_to_cpu(btree[entry].hashval);
> +
> +	/*
>  	 * release/write buffer
>  	 */
>  	ASSERT(cursor->level[this_level].dirty == 0 ||
> @@ -430,7 +437,7 @@ _("would correct bad hashval in non-leaf dir block\n"
>  	 * set hashvalue to correctl reflect the now-validated
>  	 * last entry in this block and continue upwards validation
>  	 */
> -	cursor->level[this_level].hashval = be32_to_cpu(btree[entry].hashval);
> +	cursor->level[this_level].hashval = hashval;
>  
>  	return(verify_final_dir2_path(mp, cursor, this_level));
>  }
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
