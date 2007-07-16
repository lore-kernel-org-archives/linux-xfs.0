Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 10:41:17 -0700 (PDT)
Received: from smtp101.plus.mail.re1.yahoo.com (smtp101.plus.mail.re1.yahoo.com [69.147.102.64])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6GHfCbm030175
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 10:41:13 -0700
Subject: [Advocacy] Re: 3ware 9650 tips
From: "Bryan J. Smith" <b.j.smith@ieee.org>
In-Reply-To: <alpine.LRH.0.999.0707161142440.25773@chaos.egr.duke.edu>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu>
	 <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan>
	 <4697CA4D.6020304@etelos.com>
	 <Pine.LNX.4.64.0707131535270.2064@p34.internal.lan>
	 <20070716024115.GJ12413810@sgi.com>
	 <alpine.LRH.0.999.0707161142440.25773@chaos.egr.duke.edu>
Content-Type: text/plain
Date: Mon, 16 Jul 2007 13:15:32 -0400
Message-Id: <1184606132.4551.11.camel@portatux64.mobile.smithconcepts.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: David Chinner <dgc@sgi.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Off-topic, advocacy-level response ...  

On Mon, 2007-07-16 at 11:43 -0400, Joshua Baker-LePain wrote:
> I do so wish that RedHat shared this view...

I've been trying to convince them since Red Hat Linux 7 (and, later, 9)
that they need to realize the limits of Ext3 at the enterprise end of
the scalability spectrum -- you know, that whole market they are
seemingly saying they are the king of and a replacement for Sun?  ;->

The problem with Red Hat is that when anyone brings up an alternative to
Ext3, Red Hat falls back to arguments against other filesystems, which
is rather easy given the various compatibility issues with JFS (ported
from OS/2, requiring a lot of inode compatibility hacks -- don't get me
started with my experiences) and ReiserFS (utter lack of inode
compatibility in structures, requiring kernel-level emulation, etc...
that never seems to work, regardless of what the advocates say, let
alone the almsota always "out-of-sync" off-line repair tools).

But when you bring up XFS and its history of a stable, but advanced
inode structure, quota support from day 1, POSIX ACLs from nearly day 1,
and all the SGI team put into 2.5.3+ that is now stock kernel, they
still try to dance.  One thing I always get is "oh, its extents don't
perform well for /tmp or /var" or countless other arguments, of which I
merely respond, "all the more reason to use Ext3 for those few
filesystems, and XFS when Ext3 doesn't scale -- like for
large /home, /export, etc... filesystems."  No matter how many times I
put forth the argument that XFS complements Ext3, they seem to treat it
as yet another JFS/ReiserFS argument.

Hopeless?

-- Bryan "one of the reasons I still deploy Solaris instead of RHEL for
fileservers, even though RHL7+XFS and RHL9+XFS rocked (and are still
rocking!)" Smith


-- 
Bryan J. Smith         Professional, Technical Annoyance
mailto:b.j.smith@ieee.org   http://thebs413.blogspot.com
--------------------------------------------------------
        Fission Power:  An Inconvenient Solution
