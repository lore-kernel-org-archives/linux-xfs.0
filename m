Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EA9067FB4
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:44:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DBB5C304039
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 03:44:19 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id FOKQPgylcO13zeKp (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 03:44:19 -0700 (PDT)
Date: Thu, 10 Apr 2014 03:44:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: collapse range is delalloc challenged.
Message-ID: <20140410104418.GI17641@infradead.org>
References: <1397106053-7489-1-git-send-email-david@fromorbit.com>
	<1397106053-7489-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397106053-7489-7-git-send-email-david@fromorbit.com>
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

> -	       *current_ext <  XFS_IFORK_NEXTENTS(ip, whichfork)) {
> +	/*
> +	 * There may be delalloc extents in the data fork before the range we
> +	 * are collapsing out, so we cannot
> +	 * use the count of real extents here. Instead we have to calculate it
> +	 * from the incore fork.
> +	 */
> +	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);

Between the amount of times we have this calculation opencoded, and the
confusing nature of XFS_IFORK_NEXTENTS it might be time to introduce
a macro to get the proper number of incore extents.

But no need to do this now, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
