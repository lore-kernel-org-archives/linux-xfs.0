Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 850727F52
	for <xfs@oss.sgi.com>; Sat, 14 Dec 2013 02:21:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5D590304043
	for <xfs@oss.sgi.com>; Sat, 14 Dec 2013 00:21:10 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	flrhtoRPsyvj0b86 for <xfs@oss.sgi.com>;
	Sat, 14 Dec 2013 00:21:04 -0800 (PST)
Date: Sat, 14 Dec 2013 19:20:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS / writeback invoking soft lockup.
Message-ID: <20131214082059.GS31386@dastard>
References: <20131213071407.GA6527@redhat.com> <20131213104853.GS10988@dastard>
	<20131213111639.GD23546@infradead.org>
	<20131213162228.GA29908@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213162228.GA29908@redhat.com>
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
To: Dave Jones <davej@redhat.com>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Dec 13, 2013 at 11:22:28AM -0500, Dave Jones wrote:
> On Fri, Dec 13, 2013 at 03:16:39AM -0800, Christoph Hellwig wrote:
>  > On Fri, Dec 13, 2013 at 09:48:53PM +1100, Dave Chinner wrote:
>  > > All I can say is that there doesn't look to be any obvious signs
>  > > that this is a XFS or writeback problem fom the stack trace, and
>  > > without more information or a reproducable test case I'm not going
>  > > to be able to understand the cause.
>  > > 
>  > > Is the problem reproducable, or is it just a one-off?
>  > 
>  > If it's reproducable it would be good to enable the xfs_writepage
>  > tracepoint and get a trace-cmd log of it.
> 
> I hit it pretty reliably last night.  I'll make a note to look into it 
> on monday with that enabled.

You might want to grab the writeback tracepoints as well. Note that
you'll probably have to filter by device so you don't get noise from
all the other block devices, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
