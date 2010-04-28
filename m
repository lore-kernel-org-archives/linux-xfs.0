Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SDd5RQ237660 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 08:39:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BBF81270F06
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 06:41:09 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	eaNZ9InMwo6Ci8sC for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 06:41:09 -0700 (PDT)
Date: Wed, 28 Apr 2010 23:41:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT, RFC] Delayed logging V2
Message-ID: <20100428134105.GH9783@dastard>
References: <20100428083716.GG9783@dastard>
	<20100428112405.GA24762@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100428112405.GA24762@infradead.org>
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

On Wed, Apr 28, 2010 at 07:24:05AM -0400, Christoph Hellwig wrote:
> On Wed, Apr 28, 2010 at 06:37:16PM +1000, Dave Chinner wrote:
> > Hi flks,
> > 
> > This is version 2 of the delayed logging series.
> > 
> > I won't repeat everything about what it is, just point you
> > here:
> > 
> > http://marc.info/?l=linux-xfs&m=126862777118946&w=2
> > 
> > for the description, and here:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git delayed-logging
> 
> I don't think the updated version has made it out to kernel.org yet.

It's there. Most of the updates were done in the couple of days
after posting it last - I just didn't get a chance to test it
effectively before other things took precedence. e.g. the busy
extent tracking commit in the branch is only 7 hours old.

I've finally got back to doing some stress testing on it in the last
week and haven't been seeing any new problems, so that's why I
pushed it again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
