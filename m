Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 43B327F37
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 21:41:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 331298F8033
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 19:41:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	uoYARQ2SvSRHDbYi for <xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 19:41:24 -0700 (PDT)
Date: Mon, 29 Jul 2013 12:41:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
Message-ID: <20130729024105.GC13468@dastard>
References: <20130729000247.GA13468@dastard>
	<32553786.2492.1375056392388.JavaMail.root@benjamin.baylink.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <32553786.2492.1375056392388.JavaMail.root@benjamin.baylink.com>
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
To: Jay Ashworth <jra@baylink.com>
Cc: xfs@oss.sgi.com

On Sun, Jul 28, 2013 at 08:06:32PM -0400, Jay Ashworth wrote:
> ----- Original Message -----
> > From: "Dave Chinner" <david@fromorbit.com>
> 
> > Sure, they have diverged signficant;y as we've backported various
> > bits of XFs fetaures and bug fixes back into RHEL6. As have every
> > other distro that doesn't track mainline directly. That's why you
> > need to look at the kernel source package to know what code the
> > distro is running.
> 
> And... all the way back to Jason's original question:
> 
> The way that you get the information out of a kernel/kernel RPM to 
> determine which XFS version it's running... is?  Cause it's clearly
> not obvious to either him or me.

The "version" of XFS that you are running is that of the
kernel you are running. i.e. 2.6.32-279.x.y or 2.6.32-358.x.y.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
