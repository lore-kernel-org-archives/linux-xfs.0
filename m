Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9705A7F9A
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:29:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 872EB304043
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 03:29:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id a9KLwX6FAEM0Bebz (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 03:29:02 -0700 (PDT)
Date: Thu, 10 Apr 2014 03:29:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/2] xfs: fold xfs_create_tmpfile() into xfs_create()
Message-ID: <20140410102901.GB17641@infradead.org>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
	<1397071311-28371-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397071311-28371-3-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

> -	struct xfs_trans_res	tres;
> +	struct xfs_trans_res	*tres;
>  	uint			resblks;
>  
>  	trace_xfs_create(dp, name);
> @@ -1181,14 +1181,21 @@ xfs_create(
>  	if (is_dir) {
>  		rdev = 0;
>  		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
> -		tres.tr_logres = M_RES(mp)->tr_mkdir.tr_logres;
> -		tres.tr_logcount = XFS_MKDIR_LOG_COUNT;
> +		tres = &M_RES(mp)->tr_mkdir;

The (nice) reservation cleanup should be a patch of it's own. 

> +	} else {
> +		/*
> +		 * If we don't have a name, we're in the ->tmpfile() path. We
> +		 * have a unique transaction here since we modify the unlinked
> +		 * list rather than create a directory entry.
> +		 */

How is that transaction more "uniqueue" than the others?  Seems like
this comment generally doesn't add a whole lot of value.

> +	if (name) {
> +		xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> +		unlock_dp_on_error = true;
> +
> +		error = xfs_dir_canenter(tp, dp, name, resblks);
> +		if (error)
> +			goto out_trans_cancel;
> +	}

So we get another special case in this function.  Can't say I like that
too much, on the other hand I don't really like the duplicate code
either.  So I'm not excited about this, but also not strongly against it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
