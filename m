Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 01:51:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m388pln3016448
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 01:51:48 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C06675ECA7
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2008 01:52:25 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id FcwGf2XfMWhEwhIn for <xfs@oss.sgi.com>; Tue, 08 Apr 2008 01:52:25 -0700 (PDT)
Date: Tue, 8 Apr 2008 04:51:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW #2] cleanup - remove bhv_vname_t
Message-ID: <20080408085153.GA19699@infradead.org>
References: <op.t897ipuu3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t897ipuu3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

> --- kern_ci.orig/fs/xfs/xfs_dir2.h
> +++ kern_ci/fs/xfs/xfs_dir2.h
> @@ -60,6 +60,16 @@ typedef	__uint32_t	xfs_dir2_db_t;
>  typedef	xfs_off_t	xfs_dir2_off_t;
>
>  /*
> + * Counted string for file names.
> + */
> +struct xfs_name {
> +	const char	*name;
> +	int		len;
> +};
> +
> +extern struct xfs_name	xfs_name_dotdot;

I think these should be in a different header as they are used a lot
outside the low-level directory code.

> +static inline int
> +xfs_dir_check_canenter(uint resblks, struct xfs_trans *tp,
> +				struct xfs_inode *dp, struct xfs_name *name)
> +{
> +	if (resblks)
> +		return 0;
> +	return xfs_dir_canenter(tp, dp, name);;
> +}

Probably makes sense to have this out of line.


>  STATIC int
>  xfs_lock_for_rename(
> -	xfs_inode_t	*dp1,	/* old (source) directory inode */
> -	xfs_inode_t	*dp2,	/* new (target) directory inode */
> -	bhv_vname_t	*vname1,/* old entry name */
> -	bhv_vname_t	*vname2,/* new entry name */
> -	xfs_inode_t	**ipp1,	/* inode of old entry */
> -	xfs_inode_t	**ipp2,	/* inode of new entry, if it
> +	xfs_inode_t	*dp1,	/* in: old (source) directory inode */
> +	xfs_inode_t	*dp2,	/* in: new (target) directory inode */
> +	struct xfs_name	*name2,	/* in: new entry name */
> +	xfs_inode_t	**ipp1,	/* in/out: inode of old entry */
> +	xfs_inode_t	**ipp2,	/* out: inode of new entry, if it
>  				   already exists, NULL otherwise. */
> -	xfs_inode_t	**i_tab,/* array of inode returned, sorted */
> -	int		*num_inodes)  /* number of inodes in array */
> +	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
> +	int		*num_inodes)  /* out: number of inodes in array */

This function needs some more love :)

If you follow the flow *ipp1 can never be zeroed out so just pass a
normal *ip1 pointer.  Similarly the loop to find *ipp2 to again
can be killed because we know it's there. New prototype should be
something like:

 STATIC int
 xfs_lock_for_rename(
+	xfs_inode_t	*dp1,	/* in: old (source) directory inode */
+	xfs_inode_t	*dp2,	/* in: new (target) directory inode */
+	xfs_inode_t	*ip1,	/* in: inode of old entry */
+	struct xfs_name	*name2,	/* in: new entry name */
+	xfs_inode_t	**ipp2,	/* out: inode of new entry, if it
  				   already exists, NULL otherwise. */
+	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
+	int		*num_inodes)  /* out: number of inodes in array */
