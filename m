Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6C0kxRT000650 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 19:47:00 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55443EA2AB8
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 17:46:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	c3YEVSAFezNBLLr1 for <xfs@oss.sgi.com>;
	Mon, 11 Jul 2011 17:46:58 -0700 (PDT)
Date: Tue, 12 Jul 2011 10:46:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [regression, 3.0-rc] xfs: freeze hang in 068
Message-ID: <20110712004655.GI23038@dastard>
References: <20110711010357.GD23038@dastard>
	<20110711095147.GA19354@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110711095147.GA19354@infradead.org>
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
Cc: hch@lst.de, xfs@oss.sgi.com

On Mon, Jul 11, 2011 at 05:51:47AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 11, 2011 at 11:03:57AM +1000, Dave Chinner wrote:
> > Christoph,
> > 
> > The recent changes to the active transaction accounting to close a
> > race on freeze can hang the freeze process and hence the filesystem.
> 
> That commit isn't in 3.0-rc, but I guess it's just the subject line
> that is incorrect.

Ah, yes. I'd merged everything into a common test tree based on
3.0-rc6, and then forgot I'd merged all the pending 3.1 stuff
when I'd tracked down the bug and wrote the email....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
