Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 21E437CA2
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 00:39:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A42B0AC002
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 22:39:30 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Zhn4ks42uhgHCoNA for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 22:39:27 -0800 (PST)
Date: Thu, 11 Feb 2016 17:39:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/8] xfs: don't chain ioends during writepage submission
Message-ID: <20160211063910.GF19486@dastard>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
	<1455094043-9694-7-git-send-email-david@fromorbit.com>
	<20160210113609.GC15221@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210113609.GC15221@infradead.org>
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

On Wed, Feb 10, 2016 at 03:36:09AM -0800, Christoph Hellwig wrote:
> > +	LIST_HEAD(submit_list);
> > +	struct xfs_ioend	*ioend, *next;
> >  	struct buffer_head	*bh, *head;
> >  	ssize_t			len = 1 << inode->i_blkbits;
> >  	int			error = 0;
> >  	int			uptodate = 1;
> >  	int			count = 0;
> 
> The count variable is pointless now - we only check for it being
> non-zero, and we can do the same with a list_emptry on submit_list.

Actually, it's not pointless - we need it to determine what to
with the page. We have to start writeback on the page if there were
no errors, but the number of buffers we added to the ioend
determines if we need to end page writeback immediately (i.e. no
buffers added). This is spearate to whether we allocated a new ioend
on the page and hence have an ioend to submit on the submit_list.

That said, looking at this did point out a bug in this
version of the patch - if no buffers were added to the ioends, then
we didn't clear the dirty bit on the page and transition through the
writeback state, as the original code was doing. I did trip over
this in a test run, so it's a real problem that needed to be fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
