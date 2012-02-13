Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DHmHJd028658 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 11:48:17 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	U9aDi7IdYndlSQ8C (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 09:48:13 -0800 (PST)
Date: Mon, 13 Feb 2012 12:48:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: concurrent direct IO write in xfs
Message-ID: <20120213174806.GA7630@infradead.org>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116232549.GC6922@dastard>
	<CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
	<20120123051155.GI15102@dastard>
	<CAFLer82QxfgXEx7ofzOHOK2YKiA+ab+_Aizd10SWHvnC-mVUHg@mail.gmail.com>
	<CAFLer81GWSCCCMppU=2dE+5KKqD-hYVKAA0hz9n-CBbxAs_xfw@mail.gmail.com>
	<20120124035431.GD6922@dastard> <20120209060920.GF7479@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120209060920.GF7479@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Zheng Da <zhengda1936@gmail.com>, xfs@oss.sgi.com

On Thu, Feb 09, 2012 at 05:09:20PM +1100, Dave Chinner wrote:
>  	if (create) {
> -		lockmode = XFS_ILOCK_EXCL;
> +		/*
> +		 * For direct IO, we lock in shared mode so that write
> +		 * operations that don't require allocation can occur
> +		 * concurrently. The ilock has to be dropped over the allocation
> +		 * transaction reservation, so the only thing the ilock is
> +		 * providing here is modification exclusion. i.e. there is no
> +		 * need to hold the lock exclusive.
> +		 *
> +		 * For buffered IO, if we need to do delayed allocation then
> +		 * hold the ilock exclusive so that the lookup and delalloc
> +		 * reservation is atomic.
> +		 */
> +		if (direct)
> +			lockmode = XFS_ILOCK_SHARED;
> +		else
> +			lockmode = XFS_ILOCK_EXCL;
>  		xfs_ilock(ip, lockmode);
>  	} else {
>  		lockmode = xfs_ilock_map_shared(ip);

We'll actually need to use xfs_ilock_map_shared for the the direct
create case too, to make sure we have the exclusive lock when we first
read the extent list in.

Also xfs_qm_dqattach_locked really wants the inode locked exclusively,
which your current code doesn't handle.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
