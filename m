Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o23MU0G8115248 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 16:30:00 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D596621615D
	for <xfs@oss.sgi.com>; Wed,  3 Mar 2010 14:31:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	BvFhiIZOk0RlIOia for <xfs@oss.sgi.com>;
	Wed, 03 Mar 2010 14:31:26 -0800 (PST)
Date: Thu, 4 Mar 2010 09:31:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfsqa: add delayed allocation @ ENOSPC exerciser
Message-ID: <20100303223122.GA14317@discord.disaster>
References: <1267597162-12092-1-git-send-email-david@fromorbit.com>
	<1267597162-12092-2-git-send-email-david@fromorbit.com>
	<20100303125619.GA26672@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100303125619.GA26672@infradead.org>
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

On Wed, Mar 03, 2010 at 07:56:19AM -0500, Christoph Hellwig wrote:
> On Wed, Mar 03, 2010 at 05:19:20PM +1100, Dave Chinner wrote:
> > +	killall -9 dd > /dev/null 2>&1
> 
> This seems a bit dangerous.  I have at least one old system that
> uses dd to continously read the kernel message buffer in the
> background, and there's tons of other potential dd uses.

I only put it there to make sure they all died when I ^C'd out of a
test run while testing the test. I forgot to remove it - I'll drop
it from the patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
