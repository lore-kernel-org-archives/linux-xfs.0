Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8654D29DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 20:06:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5955F30406A
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 18:06:44 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	xAgNJxGsQ81jS778 for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 18:06:39 -0800 (PST)
Date: Thu, 27 Feb 2014 13:06:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/10] repair: use a listhead for the dotdot list
Message-ID: <20140227020624.GE29907@dastard>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
	<1393223369-4696-7-git-send-email-david@fromorbit.com>
	<20140225200332.GB22351@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140225200332.GB22351@infradead.org>
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

On Tue, Feb 25, 2014 at 12:03:32PM -0800, Christoph Hellwig wrote:
> On Mon, Feb 24, 2014 at 05:29:25PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Cleanup suggested by Christoph Hellwig - removes another open coded
> > list implementation.
> 
> Looks good.  Question for both the old and new code:  any good reason to
> do the dotdot updates LIFO?  If yes it might be worth adding a comment
> about that fact.

No, it didn't even occur to me that it might matter. I'll change it
back to FIFO.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
