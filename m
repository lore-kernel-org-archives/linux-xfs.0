Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB0F77F6B
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 10:00:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C4B3430406A
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 08:00:25 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id LdD9fOGgFB0MHHRu (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 08:00:24 -0700 (PDT)
Date: Thu, 31 Oct 2013 08:00:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 25/30 V2] libxfs: fix root inode handling inconsistencies
Message-ID: <20131031150024.GP22359@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-26-git-send-email-david@fromorbit.com>
	<20131030102318.GA31519@infradead.org>
	<20131030215940.GH6188@dastard> <20131031041343.GK6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131031041343.GK6188@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Oct 31, 2013 at 03:13:43PM +1100, Dave Chinner wrote:
> -	if ((flags & LIBXFS_MOUNT_ROOTINOS) && rtmount_inodes(mp)) {
> -		if (mp->m_rootip)
> -			libxfs_iput(mp->m_rootip, 0);
> +	/* set up the realtime inodes if they exist */
> +	error = rtmount_inodes(mp);
> +	if (error)
>  		return NULL;
> -	}
>  
>  	/*
>  	 * mkfs calls mount before the AGF/AGI structures are written.
>  	 */
> -	if ((flags & LIBXFS_MOUNT_ROOTINOS) && sbp->sb_rootino != NULLFSINO &&
> +	if (sbp->sb_rootino != NULLFSINO &&
>  	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {

Oh, I hadn't noticed that LIBXFS_MOUNT_ROOTINOS does more than reading
the root inode.  Seems like mkfs might need the rt inodes if a file with
the rt flag is specified in the proto file.

I can't see how xfs_copy could need either the rt inodes nor the perag
data.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
