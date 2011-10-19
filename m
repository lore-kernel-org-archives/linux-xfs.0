Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9J9vkA5175319 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 04:57:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8023BF7E39E
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:05:44 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tjnR6UacFZUYHmlp for <xfs@oss.sgi.com>;
	Wed, 19 Oct 2011 03:05:44 -0700 (PDT)
Date: Wed, 19 Oct 2011 05:57:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 2/3] Add pquota fields where gquota is used
Message-ID: <20111019095742.GA20622@infradead.org>
References: <20111018000932.14942.11597.sendpatchset@chandra-lucid.austin.ibm.com>
	<20111018000943.14942.24899.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111018000943.14942.24899.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -841,8 +841,10 @@ xfs_qm_dqget(
>  		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  		if (type == XFS_DQ_USER)
>  			ASSERT(ip->i_udquot == NULL);
> -		else
> +		else if (type == XFS_DQ_GROUP)
>  			ASSERT(ip->i_gdquot == NULL);
> +		else
> +			ASSERT(ip->i_pdquot == NULL);

An xfs_inode_dquot(ip, type) macro that gets you the right quota for
a given type would be highly useful.  I'd love to see that as the
first patch in the series, as it would a) clean up a lot of code like
this and b) would also help with my TODO list of overlaying the
user/group dquots with the existing fields in the VFS inode and thus
shrinking the XFS inode.

> @@ -933,8 +935,8 @@ xfs_qm_dqget(
>  				xfs_dqlock(dqp);
>  				goto dqret;
>  			}
> -		} else {
> -			if (!XFS_IS_OQUOTA_ON(mp)) {
> +		} else if (type == XFS_DQ_GROUP) {
> +			if (!XFS_IS_GQUOTA_ON(mp)) {
>  				/* inode stays locked on return */
>  				xfs_qm_dqdestroy(dqp);
>  				return XFS_ERROR(ESRCH);

Together with a

	XFS_IS_TYPE_QUOTA_ON(mp, type)

that should also really greatly simplify this error path in
xfs_qm_dqget.

> +#define XFS_IS_THIS_QUOTA_OFF(d) (! ((XFS_QM_ISUDQ(d) && \
> +				     XFS_IS_UQUOTA_ON((d)->q_mount)) || \
> +				     (XFS_QM_ISGDQ(d) && \
> +				     XFS_IS_GQUOTA_ON((d)->q_mount)) || \
> +				     (XFS_QM_ISPDQ(d) && \
> +				     XFS_IS_PQUOTA_ON((d)->q_mount))))

And the two callers of this could easily be converted to
!XFS_IS_TYPE_QUOTA_ON.

> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 760140d..26f95a6 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -231,6 +231,7 @@ typedef struct xfs_inode {
>  	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
>  	struct xfs_dquot	*i_udquot;	/* user dquot */
>  	struct xfs_dquot	*i_gdquot;	/* group dquot */
> +	struct xfs_dquot	*i_pdquot;	/* project dquot */

I'd really prefer to leave growing the inode until we are fully done
adding it.  So move this part to the back, just add the macro and quota
on check in the first patch, but always redirect it to i_gdquot for now.

> +++ b/fs/xfs/xfs_mount.c
> @@ -628,6 +628,7 @@ xfs_sb_to_disk(
>  	xfs_sb_field_t	f;
>  	int		first;
>  	int		size;
> +	__be16		saved_qflags = from->sb_qflags;
>  
>  	ASSERT(fields);
>  	if (!fields)
> @@ -669,6 +670,7 @@ xfs_sb_to_disk(
>  
>  		fields &= ~(1LL << f);
>  	}
> +	from->sb_qflags = saved_qflags;
>  }

What is this for?  It will need some better documentation.

> -		ASSERT(ip->i_udquot == NULL);
> +		ASSERT_ALWAYS(ip->i_udquot == NULL);

Why the change to ASSERT_ALWAYS here?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
