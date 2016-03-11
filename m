Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D57557CA6
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 11:52:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A82418F8035
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 09:52:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QTCyZSEHqpUqJVVU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2016 09:52:32 -0800 (PST)
Date: Fri, 11 Mar 2016 12:52:30 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: don't release bios on completion immediately
Message-ID: <20160311175229.GA45351@bfoster.bfoster>
References: <1456302011-18915-1-git-send-email-hch@lst.de>
	<1456302011-18915-3-git-send-email-hch@lst.de>
	<20160303151722.GB57990@bfoster.bfoster>
	<20160311144758.GA2551@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160311144758.GA2551@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Fri, Mar 11, 2016 at 03:47:58PM +0100, Christoph Hellwig wrote:
> On Thu, Mar 03, 2016 at 10:17:22AM -0500, Brian Foster wrote:
> > > +xfs_finish_page_writeback(
> > > +	struct page	*page,
> > > +	unsigned int	start,
> > > +	unsigned int	end,
> > > +	int		error)
> > > +{
> > > +	struct buffer_head	*head, *bh;
> > > +	unsigned int		off = 0;
> > > +
> > > +	bh = head = page_buffers(page);
> > > +
> > > +	do {
> > > +		if (start > off)
> > > +			goto next_bh;
> > 
> > Probably not an issue for current usage, which appears to be on buffer
> > size granularity, but shouldn't this check whether start is beyond the
> > end of the current buffer (e.g., start >= off + bh->b_size)?
> 
> I don't understand that question.  We get called for a given page,
> and a start and end offset inside that page.  These offsets by design
> need to be aligned to the filesystem blocksize.  So what we basically
> want is to skip a few buffers at the beginning and/or end of the page,
> and the code seems to handle that fine.
> 

Yes, that's what I meant by it not being an issue for current usage.

My point was that when looking at the new helper, nothing explicitly
indicates the offsets must be block aligned. This page buffer_head
walking loop is rewritten all over the fs/ code in a manner that is
correct for arbitrary offsets, so this instance looked wrong at first
glance. Then I realized it probably works fine once looking at the
callers.

I'm fine with it as is if we add an assert for the alignment of the
offsets.

Brian

> > >  	mempool_free(ioend, xfs_ioend_pool);
> > >  }
> > >  
> > > +
> > 
> > Unnecessary whitespace here.
> 
> Fixed.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
