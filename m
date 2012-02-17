Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HI0OAQ100470 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 12:00:24 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	huHhfVplAVL45dPf (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 10:00:23 -0800 (PST)
Date: Fri, 17 Feb 2012 13:00:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/12] log grant code cleanups
Message-ID: <20120217180022.GA18748@infradead.org>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20120216061637.GY14132@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120216061637.GY14132@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Feb 16, 2012 at 05:16:37PM +1100, Dave Chinner wrote:
> On Mon, Dec 12, 2011 at 09:13:47AM -0500, Christoph Hellwig wrote:
> > This series removes the opportunistic log space wakeups which had no
> > use but hiding real races for far too long, and applies various bits
> > of refactoring to the log grant code to make it smaller and more readable.
> 
> Christoph, I was just going over this series again so I could add a
> reviewed-by tag to it to get it moving for 3.3. Everything looks
> just fine except for one thing - the issue raised and potential
> solution described here:
> 
> http://oss.sgi.com/archives/xfs/2011-12/msg00056.html
> 
> You said you were going to look at adding this fix to the series,
> but I don't see it in this patch set.

I've dropped the ball on that.  I'll try to get back to it ontop of the
series.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
