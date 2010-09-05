Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o85NZvkO139978 for <xfs@oss.sgi.com>; Sun, 5 Sep 2010 18:35:57 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 995ED4E3E7
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 16:36:38 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	S13uAcCGQEDSbpa4 for <xfs@oss.sgi.com>;
	Sun, 05 Sep 2010 16:36:38 -0700 (PDT)
Date: Mon, 6 Sep 2010 09:36:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS status update for August 2010
Message-ID: <20100905233635.GW7362@dastard>
References: <20100902145959.GA27887@infradead.org>
	<20100905074457.GC16004@1wt.eu> <201009051137.07678@zmi.at>
	<20100905104739.GC27623@1wt.eu> <20100905130809.GI705@dastard>
	<20100905185600.GD27623@1wt.eu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100905185600.GD27623@1wt.eu>
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
To: Willy Tarreau <w@1wt.eu>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Sun, Sep 05, 2010 at 08:56:00PM +0200, Willy Tarreau wrote:
> On Sun, Sep 05, 2010 at 11:08:09PM +1000, Dave Chinner wrote:
> > That being said, I've been running
> > my laptop and my production machines (except for the backup target)
> > for a couple of months now with it and haven't had any problems...
> 
> Fine, this is typically the type of info I need. Thus I'll be using
> it with an eye on any potential FS-related problem.

Thanks.

> Are there any plans to use that option by default once it gets enough
> testing ? I'm asking because I had to convert from XFS to reseirfs at
> least twice due to slow metadata, but I tend to trust XFS a lot more
> (especially due to dirty failures I experienced a few years ago with
> reiserfs - corrupted file tails upon power cut).

>From Documentation/filesystems/xfs-delayed-logging-design.txt:

2.6.37 Remove experimental tag from mount option
        => should be roughly 6 months after initial merge
        => enough time to:
                => gain confidence and fix problems reported by early
                   adopters (a.k.a. guinea pigs)
                => address worst performance regressions and undesired
                   behaviours
                => start tuning/optimising code for parallelism
                => start tuning/optimising algorithms consuming
                   excessive CPU time

2.6.39 Switch default mount option to use delayed logging
        => should be roughly 12 months after initial merge
        => enough time to shake out remaining problems before next round of
           enterprise distro kernel rebases

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
