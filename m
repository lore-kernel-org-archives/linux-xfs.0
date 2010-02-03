Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13N1V8U250597 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 17:01:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A78B41376E6E
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 15:02:38 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	MdAZr5DEwMxju6Dm for <xfs@oss.sgi.com>;
	Wed, 03 Feb 2010 15:02:38 -0800 (PST)
Date: Thu, 4 Feb 2010 10:02:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/10] xfs: xfs_fs_write_inode() can fail to write
	inodes synchronously V2
Message-ID: <20100203230235.GB5332@discord.disaster>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-10-git-send-email-david@fromorbit.com>
	<20100203112753.GA19996@infradead.org>
	<20100203205648.GA23116@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100203205648.GA23116@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Wed, Feb 03, 2010 at 03:56:48PM -0500, Christoph Hellwig wrote:
> On Wed, Feb 03, 2010 at 06:27:53AM -0500, Christoph Hellwig wrote:
> > Still not entirely happy with this one.  The first one is that I think
> > the barriers in fsync are still too heavy for the normal sync use
> > case.  I'd be more happy with exporting the body of xfs_fsync without
> > the cache flushes (and a ebtter name than xfs_fsync) and use that
> > for write_inode.
> > 
> > That leaves open the NFSD case thought.  I'd prefer to have that fixed
> > if possibly.  Ben, any chance you could send your patch to use fsync
> > to the nfs list ASAP?  I think we'd be even better off to just force
> > -o wsync and disable ->write_inode entirely for NFS, any chance you
> > could test such a patch on your setup?
> 
> Thinking about it, we usually do cause a log buffer write from ->fsync
> which means we submit the barrier anyway.  That might be the reason
> why you're not seeing the performance hit in your testing.  With that
> I'm okay with the patch as-is for now, we can micro-optimize it later.

OK. I was thinking that a "inode cluster fsync" function might be
appropriate here. i.e. a transaction that takes all the dirty inodes
in the inode cluster and logs/forces them all in one transaction.
That would substanitally reduce the number of log writes needed,
I think. I'll look into this over the next few days.

Thanks for the reviews, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
