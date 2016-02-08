Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 85F287CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 13:47:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F0C9304032
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 11:47:37 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	v7GRPIEDzFXGWhI6 for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 11:47:35 -0800 (PST)
Date: Tue, 9 Feb 2016 06:47:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/9] xfs: use vfs inode nlink field everywhere
Message-ID: <20160208194733.GG27429@dastard>
References: <1454905461-2773-1-git-send-email-david@fromorbit.com>
	<1454905461-2773-7-git-send-email-david@fromorbit.com>
	<20160208094021.GA4487@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208094021.GA4487@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 01:40:21AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 08, 2016 at 03:24:18PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The Vfs tracks the inodenlink just like the xfs_icdinode. We can
> 
> s/Vfs/VFS/
> 
> > +STATIC int
> >  xfs_iunlink(
> > -	xfs_trans_t	*tp,
> > -	xfs_inode_t	*ip)
> > +	struct xfs_trans *tp,
> > +	struct xfs_inode *ip,
> > +	bool		ignore_linkcount)
> 
> I'd say kill the ignore_linkcount parameter and the assert depending on it.
> There are just two callers: xfs_droplink checks for i_nlink just before
> the call, and xfs_create_tmpfile has to set the override flag.

Will do, I think I added that when trying to track down a busy inodes
after unmount bug in this patch, and then never removed it again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
