Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57523 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752490AbdIATaB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 15:30:01 -0400
Date: Fri, 1 Sep 2017 12:29:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: don't set v3 xflags for v2 inodes
Message-ID: <20170901192958.GA30923@infradead.org>
References: <20170830155517.GI4757@magnolia>
 <20170830163825.GQ4757@magnolia>
 <20170831131723.GD19544@infradead.org>
 <20170831133420.GB21939@bfoster.bfoster>
 <20170831140932.GB26555@infradead.org>
 <20170831195729.GM3775@magnolia>
 <20170901072149.GA7443@infradead.org>
 <20170901175223.GH3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901175223.GH3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>

On Fri, Sep 01, 2017 at 10:52:23AM -0700, Darrick J. Wong wrote:
> >  {
> > -	unsigned int		di_flags;
> > -	uint64_t		di_flags2;
> > -
> >  	/* can't set PREALLOC this way, just preserve it */
> > -	di_flags = (ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
> > +	unsigned int		di_flags =
> > +		(ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
> 
> ip->i_d.di_flags is uint16_t, so di_flags ought to match, right?

The existing code uses unsigned int as seen above.  But yes, it
could be fixed to be a uint16_t.

> Otherwise, I guess this looks ok, want to send it as a real patch?

Sure.  Doing some quick QA runs and it will be out.

Note that I'll assume it'll be for a tree without the previous
patch, unlike current for-next..
