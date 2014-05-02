Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 74A817F55
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 01:47:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58D7B304053
	for <xfs@oss.sgi.com>; Thu,  1 May 2014 23:47:06 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dhbTvTrwTN5PAzXk for <xfs@oss.sgi.com>;
	Thu, 01 May 2014 23:47:04 -0700 (PDT)
Date: Fri, 2 May 2014 16:47:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: truncate_setsize should be outside transactions
Message-ID: <20140502064700.GB26353@dastard>
References: <1398983979-23696-1-git-send-email-david@fromorbit.com>
	<20140502045443.GA8867@infradead.org>
	<20140502050053.GA17578@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140502050053.GA17578@infradead.org>
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

On Thu, May 01, 2014 at 10:00:53PM -0700, Christoph Hellwig wrote:
> On Thu, May 01, 2014 at 09:54:43PM -0700, Christoph Hellwig wrote:
> > On Fri, May 02, 2014 at 08:39:39AM +1000, Dave Chinner wrote:
> > > This issue with xfs_setattr_size() was introduced back in 2010 by
> > > commit fa9b227 ("xfs: new truncate sequence") which moved the page
> > > cache truncate from outside the transaction context (what was
> > > xfs_itruncate_data()) to inside the transaction context as a call to
> > > truncate_setsize().
> > 
> > And it was moved because we should only call truncate_setsize once
> > the truncate can't fail any more.  So to move it out of transaction
> > context it needs to move after the commit of the transaction(s).
> 
> Actually that's only true for the i_size update.  So I guess
> we need to call truncate_pagecache were you put the truncate_setsize
> now, and then update i_size later, together with the updates of the
> XFS di_size.

OK, that seems reasonable. I'll add a comment to ensure that we
don't break it in future ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
