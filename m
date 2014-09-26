Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E852F802E
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 18:22:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 83E3CAC008
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 16:22:04 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fkMQBN9DODy0Rmkp for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 16:22:02 -0700 (PDT)
Date: Sat, 27 Sep 2014 09:22:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: refactor xlog_recover_process_data()
Message-ID: <20140926232201.GR4945@dastard>
References: <1411697952-24741-1-git-send-email-david@fromorbit.com>
	<1411697952-24741-2-git-send-email-david@fromorbit.com>
	<20140926114238.GA16576@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140926114238.GA16576@infradead.org>
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

On Fri, Sep 26, 2014 at 04:42:38AM -0700, Christoph Hellwig wrote:
> On Fri, Sep 26, 2014 at 12:19:08PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Clean up xlog_recover_process_data() structure in preparation for
> > fixing the allocation and freeing context of the transaction being
> > recovered.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks good.  The only behavior change I could spot was that we now
> validate the length of an ophdr even when starting a new transaction,
> which seems sensible.
> 
> Nipick: maybe the lp argument to xlog_recover_process_ophdr should
> be called end to make it more obvious?

Yes, I had that thought too. I'll change it.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
