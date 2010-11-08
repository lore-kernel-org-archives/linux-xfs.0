Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8BZIkg096421 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 05:35:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 149771C22746
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 03:36:45 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id u492Ei4HpPKD53ke for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 03:36:45 -0800 (PST)
Date: Mon, 8 Nov 2010 06:36:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/16] xfs: don't truncate prealloc from frequently
	accessed inodes
Message-ID: <20101108113645.GA16418@infradead.org>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289206519-18377-6-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

I'd be much more happy about fixing this properly in nfsd.  But I guess
the fix is simple enough that we can put it into XFS for now.  Any
reason you use up a whole int in the inode instead of using a flag in
i_flags?

> -
> -		ASSERT(ip->i_delayed_blks == 0);
> +		/*
> +		 * even after flushing the inode, there can still be delalloc
> +		 * blocks on the inode beyond EOF due to speculative
> +		 * preallocation. These are not removed until the release
> +		 * function is called or the inode is inactivated. Hence we
> +		 * cannot assert here that ip->i_delayed_blks == 0.
> +		 */

Shouldn't this be in a separate patch given that we can fail the flush
due to iolock contention?  I think this and the swapext fix are .37
material in fact.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
