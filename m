Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL0rlT4200401 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 18:53:48 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39C40146F538
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 16:55:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	ilux53v4aZNdFPPj for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 16:55:44 -0800 (PST)
Date: Tue, 21 Dec 2010 11:55:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/12] xfs: convert log grant ticket queues to list heads
Message-ID: <20101221005541.GO5193@dastard>
References: <1292215483-18224-1-git-send-email-david@fromorbit.com>
	<1292215483-18224-2-git-send-email-david@fromorbit.com>
	<20101220113458.GA12806@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101220113458.GA12806@infradead.org>
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

On Mon, Dec 20, 2010 at 06:34:58AM -0500, Christoph Hellwig wrote:
> On Mon, Dec 13, 2010 at 03:44:32PM +1100, Dave Chinner wrote:
> > -		__field(void *, reserve_headq)
> > -		__field(void *, write_headq)
> > +		__field(void *, reserveq)
> > +		__field(void *, writeq)
> 
> To repeat my question from the last review:  what's the point in logging
> this at all?  There's not much we can do with it from trace-cmd / perf
> output.  What might be more useful is a list_empty() boolean flag.

Oh, I missed that when running through all the comments. Thanks for
pointing it out again - I'll fix it this time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
