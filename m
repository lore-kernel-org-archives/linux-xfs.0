Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A3437CA0
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 08:48:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D28F48F8040
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 06:48:02 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id VKz7xR3OuAhYvxJ0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2016 06:48:00 -0800 (PST)
Date: Fri, 11 Mar 2016 15:47:58 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: don't release bios on completion immediately
Message-ID: <20160311144758.GA2551@lst.de>
References: <1456302011-18915-1-git-send-email-hch@lst.de>
	<1456302011-18915-3-git-send-email-hch@lst.de>
	<20160303151722.GB57990@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160303151722.GB57990@bfoster.bfoster>
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
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Mar 03, 2016 at 10:17:22AM -0500, Brian Foster wrote:
> > +xfs_finish_page_writeback(
> > +	struct page	*page,
> > +	unsigned int	start,
> > +	unsigned int	end,
> > +	int		error)
> > +{
> > +	struct buffer_head	*head, *bh;
> > +	unsigned int		off = 0;
> > +
> > +	bh = head = page_buffers(page);
> > +
> > +	do {
> > +		if (start > off)
> > +			goto next_bh;
> 
> Probably not an issue for current usage, which appears to be on buffer
> size granularity, but shouldn't this check whether start is beyond the
> end of the current buffer (e.g., start >= off + bh->b_size)?

I don't understand that question.  We get called for a given page,
and a start and end offset inside that page.  These offsets by design
need to be aligned to the filesystem blocksize.  So what we basically
want is to skip a few buffers at the beginning and/or end of the page,
and the code seems to handle that fine.

> >  	mempool_free(ioend, xfs_ioend_pool);
> >  }
> >  
> > +
> 
> Unnecessary whitespace here.

Fixed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
