Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA5997F37
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 08:23:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 90127304062
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 06:23:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1QaPKy5cF3fDJRhD for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 06:23:38 -0700 (PDT)
Date: Wed, 16 Apr 2014 09:23:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/9] repair: remove more dirv1 leftovers
Message-ID: <20140416132332.GA4180@laptop.bfoster>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397550301-31883-8-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 15, 2014 at 06:24:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> get_bmapi() and it's children were only called by dirv1 code. There
> are no current callers, so remove them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/dinode.c | 239 --------------------------------------------------------
>  repair/dinode.h |   6 --
>  2 files changed, 245 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 48f17ac..b086bec 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
...
> -xfs_dfsbno_t
> -get_bmapi(xfs_mount_t *mp, xfs_dinode_t *dino_p,
> -		xfs_ino_t ino_num, xfs_dfiloff_t bno, int whichfork)
> -{
> -	xfs_dfsbno_t		fsbno;
> -
> -	switch (XFS_DFORK_FORMAT(dino_p, whichfork)) {
> -	case XFS_DINODE_FMT_EXTENTS:
> -		fsbno = getfunc_extlist(mp, ino_num, dino_p, bno, whichfork);
> -		break;
> -	case XFS_DINODE_FMT_BTREE:
> -		fsbno = getfunc_btree(mp, ino_num, dino_p, bno, whichfork);
> -		break;
> -	case XFS_DINODE_FMT_LOCAL:
> -		do_error(_("get_bmapi() called for local inode %" PRIu64 "\n"),
> -			ino_num);

I'm not quite familiar with how we manage the .po translation files, but
FYI this string appears in a couple of them. Not sure whether there is
value in keeping the translation around. The string does include the
specific function name.

Brian

> -		fsbno = NULLDFSBNO;
> -		break;
> -	default:
> -		/*
> -		 * shouldn't happen
> -		 */
> -		do_error(_("bad inode format for inode %" PRIu64 "\n"), ino_num);
> -		fsbno = NULLDFSBNO;
> -	}
> -
> -	return(fsbno);
> -}
> -
> -/*
>   * higher level inode processing stuff starts here:
>   * first, one utility routine for each type of inode
>   */
> diff --git a/repair/dinode.h b/repair/dinode.h
> index 5ee51ca..80f3e4e 100644
> --- a/repair/dinode.h
> +++ b/repair/dinode.h
> @@ -119,12 +119,6 @@ get_agino_buf(xfs_mount_t	*mp,
>  		xfs_agino_t	agino,
>  		xfs_dinode_t	**dipp);
>  
> -xfs_dfsbno_t
> -get_bmapi(xfs_mount_t		*mp,
> -		xfs_dinode_t	*dip,
> -		xfs_ino_t	ino_num,
> -		xfs_dfiloff_t	bno,
> -		int             whichfork );
>  
>  void dinode_bmbt_translation_init(void);
>  char * get_forkname(int whichfork);
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
