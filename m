Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB220gOL245517 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 20:00:42 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D67C1C851E5
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 18:02:24 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	E5oDqiFFROQkHuEk for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 18:02:24 -0800 (PST)
Date: Thu, 2 Dec 2010 13:02:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/14] xfs: use wait queues directly for log grant queues
Message-ID: <20101202020212.GQ16922@dastard>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-5-git-send-email-david@fromorbit.com>
	<20101201123454.GA612@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101201123454.GA612@infradead.org>
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

On Wed, Dec 01, 2010 at 07:34:54AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 29, 2010 at 12:38:22PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The log grant queues are one of the few places left using sv_t
> > constructs for waiting. Convert them to use wait queues directly
> > while we are cleaning up the code to move one step closer to remove
> > the sv_t type from the XFS codebase.
> 
> Doing this one separately from the other sv_t removal seems a bit
> pointless.

Ok, as you suggest later Iii'll just fold the other sv_t patches
into this one.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
