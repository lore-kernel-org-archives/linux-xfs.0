Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1329f7I204182 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 20:09:42 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E73881C9B823
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 18:10:49 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	sbNWRmucSSRvzwA7 for <xfs@oss.sgi.com>;
	Tue, 02 Feb 2010 18:10:49 -0800 (PST)
Date: Tue, 2 Feb 2010 09:59:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] xfs: Use delayed write for inodes rather than async
Message-ID: <20100201225911.GA26252@discord.disaster>
References: <1264400564-19704-1-git-send-email-david@fromorbit.com>
	<1264400564-19704-3-git-send-email-david@fromorbit.com>
	<20100125115308.GC8595@infradead.org>
	<20100125223140.GN25842@discord.disaster>
	<20100126161045.GB24152@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100126161045.GB24152@infradead.org>
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

On Tue, Jan 26, 2010 at 11:10:45AM -0500, Christoph Hellwig wrote:
> > > Also in this context
> > > the requeue label name doesn't fit too well, even if it's the same
> > > action as the requeue.
> > 
> > I'm open to suggestions for a better name ;)
> 
> What do you think about this version?

Yeah, that looks a lot better. I'll incorporate that into the
patch. Thanks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
