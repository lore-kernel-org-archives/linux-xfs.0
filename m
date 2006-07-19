Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 07:12:19 -0700 (PDT)
Received: from orca.ele.uri.edu (orca.ele.uri.edu [131.128.51.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6JEBwDW009644
	for <xfs@oss.sgi.com>; Wed, 19 Jul 2006 07:11:58 -0700
Subject: Re: stable xfs
From: Ming Zhang <mingz@ele.uri.edu>
Reply-To: mingz@ele.uri.edu
In-Reply-To: <200607190940.05596.ms@teamix.de>
References: <1153150223.4532.24.camel@localhost.localdomain>
	 <20060719095400.A1936041@wobbly.melbourne.sgi.com>
	 <200607190940.05596.ms@teamix.de>
Content-Type: text/plain
Date: Wed, 19 Jul 2006 10:11:30 -0400
Message-Id: <1153318290.2691.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <ms@teamix.de>
Cc: Nathan Scott <nathans@sgi.com>, xfs@oss.sgi.com

yes. thx for reminding.

Ming

On Wed, 2006-07-19 at 09:40 +0200, Martin Steigerwald wrote:
> Am Mittwoch, 19. Juli 2006 01:54 schrieb Nathan Scott:
> > On Mon, Jul 17, 2006 at 11:30:23AM -0400, Ming Zhang wrote:
> > > Hi All
> > >
> > > We want to use XFS in all of our production servers but feel a little
> > > scary about the corruption problems seen in this list. I wonder which
> > > 2.6.16+ kernel we can use in order to get a stable XFS? Thanks!
> >
> > Use the latest 2.6.17 -stable release, or a vendor kernel (SLES is
> > particularly good with XFS, as SGI works closely with SUSE).
> 
> Hello Nathan,
> 
> as far as I can see the fix for kernel bug #6757 has not yet made it in a 
> stable kernel release upto 2.6.17.6 and thus should manually be applied:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=6757
> 
> It probably doesn't happen for lots of people but I would still apply that 
> patch unless it is finally put into a stable point release.
> 
> Regards,
