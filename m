Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01NsqAs006599 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 17:54:55 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A49471BF85CE
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 15:54:50 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	XlLdQ6iFPR6Uh5iI for <xfs@oss.sgi.com>;
	Thu, 01 Jan 2009 15:54:50 -0800 (PST)
Date: Fri, 2 Jan 2009 10:54:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsaild wakeups
Message-ID: <20090101235447.GH10725@disturbed>
References: <20081229232915.GA6724@memak.tu-darmstadt.de>
	<20081230233522.GB10725@disturbed>
	<20081231153050.GA18736@memak.tu-darmstadt.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081231153050.GA18736@memak.tu-darmstadt.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Elrond <elrond+xfs.oss.sgi.com@samba-tng.org>, xfs@oss.sgi.com

On Wed, Dec 31, 2008 at 04:30:50PM +0100, Elrond wrote:
> On Wed, Dec 31, 2008 at 10:35:22AM +1100, Dave Chinner wrote:
> > On Tue, Dec 30, 2008 at 12:29:15AM +0100, Elrond wrote:
> > > 
> > > Hi,
> > > 
> > > The major issue of xfsaild wakeups was analyzed in
> > > February. (see
> > > http://oss.sgi.com/archives/xfs/2008-02/msg00169.html ).
> > > 
> > > A small issue persists. We're now at 1 wakeup per second
> > > and mounted filesystem. I have three xfs on my box and the
> > > number wants to grow. xfsaild is on place two of my
> > > powertop wakeup list. Sometimes place one.
> > > 
> > > Is anyone working on reducing this to zero for an idle fs?
> > 
> > It's on the list of things to do given that 2.6.29 will have
> > the fix for the bug that the periodic wakeup is catching.
> 
> So the xfs part is mostly prepared and when 2.6.29 has the
> base fix, xfs will follow soon?

It's all XFS stuff ;)

What I mean is that the underlying XFS problem that required
the AIL watchdog (the 1s wakeup) is now fixed so we can remove the
periodic wakeup. That removal will probably be in 2.6.30....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
