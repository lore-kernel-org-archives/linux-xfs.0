Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CM0OdD087709 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 16:00:24 -0600
Received: from web30204.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 566001924E21
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 13:59:48 -0800 (PST)
Received: from web30204.mail.mud.yahoo.com (web30204.mail.mud.yahoo.com
	[209.191.69.51]) by cuda.sgi.com with SMTP id r6H48dNBF27TDDL4
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 13:59:48 -0800 (PST)
Message-ID: <342331.71207.qm@web30204.mail.mud.yahoo.com>
Date: Thu, 12 Feb 2009 13:59:48 -0800 (PST)
From: <raksac@yahoo.com>
Subject: Re: BUG: soft lockup detected on CPU#1!
In-Reply-To: <20090212215508.GT8830@disturbed>
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com


Well the problem is the older kernel XFS driver is
buggy to such a large extent that there is data loss
even for data on rest should a power loss occur.

With a newer version back port I can preserve the
kernel version change since it becomes far more
reaching to the other kernel components and they have
to move, to which ..... there is strong reservation.

Hope this gives you the perspective.

Thanks,
Rakesh 
--- Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Feb 12, 2009 at 01:22:16AM -0800,
> raksac@yahoo.com wrote:
> > 
> > Hi Justin,
> > 
> > Yes it is a 2.6.18 rhel5 based custom kernel but
> the
> > XFS driver is a back port from the 2.6.28.4
> 
> Then you get to keep all the broken bits to
> yourself.  If you want
> to throw random versions of XFS at random versions
> of kernels then
> we can't help you - we don't have the time or
> resources to support
> random backports of XFS to older kernels (and
> non-vanilla kernels
> at that).
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 



      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
