Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 06:10:42 -0700 (PDT)
Received: from gepard.f-net.pl ([212.244.116.162])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6HDAcbm026411
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 06:10:39 -0700
Received: from qba by gepard.f-net.pl with local (Exim 4.20)
	id 1IAmp5-0000aA-2n
	for xfs@oss.sgi.com; Tue, 17 Jul 2007 15:10:39 +0200
Date: Tue, 17 Jul 2007 15:10:39 +0200
From: "Dawid 'Kuba' Chrzan" <qba@f-net.pl>
Subject: Re: XFS + RAID1 strange message
Message-ID: <20070717131039.GA16130@gepard>
References: <20070713151058.GA24153@gepard> <20070716022518.GH12413810@sgi.com> <20070717072944.GA27270@gepard> <20070717100529.GV12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
In-Reply-To: <20070717100529.GV12413810@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Tue, Jul 17, 2007 at 08:05:29PM +1000, David Chinner wrote:
> On Tue, Jul 17, 2007 at 09:29:44AM +0200, Dawid 'Kuba' Chrzan wrote:
> > On Mon, Jul 16, 2007 at 12:25:18PM +1000, David Chinner wrote:
> > > Yes, you'll see this message for any filesystem that wasn't cleanly
> > > unmounted and if it succeeds then you have nothing to worry about.
> > 
> > I know i know.... I was thinking rather about this if it is usual on
> > raid1 - or some bug with xfs on raid.
> 
> It's probably indicative of a process still running holding an open
> reference on the filesystem preventing it from being unmounted.
> i.e. the shutdown scripts aren't killing everything or some such
> problem...
> 
 I know.
 Have to go to see it myself.
 
 Thanks...
-- 
Pozdrawiam, Dawid 'Kuba' Chrzan
http://f-net.pl  qba_nospam_@f-net.pl
RLU#212729   net/sys administrator

"Computer games don't affect kids; I mean if Pac-Man affected us as
kids, we'd all be running around in darkened rooms, munching magic pills
and listening to repetitive electronic music." - Kristian Wilson,
Nintendo Inc., 1989.
