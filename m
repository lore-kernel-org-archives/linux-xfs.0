Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F1877F37
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 00:02:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1077C8F8074
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 22:02:13 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Ie0xyMscP4w8XzbH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 22:02:08 -0700 (PDT)
Date: Tue, 5 May 2015 22:02:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: xfs_attr_inactive leaves inconsistent attr fork
	state behind
Message-ID: <20150506050208.GA4278@infradead.org>
References: <1430780408-12539-1-git-send-email-david@fromorbit.com>
	<1430780408-12539-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1430780408-12539-3-git-send-email-david@fromorbit.com>
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

> -STATIC void
> +void
>  xfs_attr_fork_reset(

Maybe rename it to xfs_attr_fork_remove while you're at it?

> +	xfs_ilock(dp, lock_mode);
> +	if (!XFS_IFORK_Q(dp))
> +		goto out_destroy_fork;
> +	xfs_iunlock(dp, lock_mode);

The use of a goto here seems confsing as it moves the code to just
free the attribute code out of line like some error handling.

It could also use a comment on when we have an in-memory attribute
fork but XFS_IFORK_Q is false.  I don't really know when that
would be true given that xfs_attr_shortform_remove either removes
the attribute fork, or asserts that the forkoff is non-zero when
it is left as-is.

>  	/*
> -	 * Decide on what work routines to call based on the inode size.
> +	 * It's unlikely we've raced with an attribute fork creation, but check
> +	 * anyway just in case.
>  	 */

We always need to check for races if they are possible, no matter how
unlikely they are.  So that just in case comment seems confusing.

> +	if (XFS_IFORK_Q(ip)) {
>  		error = xfs_attr_inactive(ip);
>  		if (error)
>  			return;
>  	}

Given that we don't even call xfs_attr_inactive when XFS_IFORK_Q is
false the check above doesn't seem to be reachable anyway.  At least
I can't think of a way how we could add an attr fork in a way that
races with inode teardown.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
