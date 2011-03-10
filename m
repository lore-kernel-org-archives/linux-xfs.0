Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2AMEFMT125004 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 16:14:20 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA76D8F8074
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 14:17:00 -0800 (PST)
Subject: Re: [PATCH] xfstests: fix a few build warnings
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110310172418.GA13390@infradead.org>
References: <201103041937.p24JbVtP004804@stout.americas.sgi.com>
	<20110310172418.GA13390@infradead.org>
Date: Thu, 10 Mar 2011 16:16:53 -0600
Message-ID: <1299795413.2573.80.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Thu, 2011-03-10 at 12:24 -0500, Christoph Hellwig wrote:
> >  lio_random_methods(long curr_mask)
> >  {
> >      int mask=0;
> > -    long random_bit();
> > +    long random_bit(long);
> 
> This should use the prototype from include/random_range.h instead.
> 
> Otherwise looks good to me,
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I should have done that.  Already committed though.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
