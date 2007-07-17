Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 03:05:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6HA5bbm016454
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 03:05:39 -0700
Date: Tue, 17 Jul 2007 20:05:29 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS + RAID1 strange message
Message-ID: <20070717100529.GV12413810@sgi.com>
References: <20070713151058.GA24153@gepard> <20070716022518.GH12413810@sgi.com> <20070717072944.GA27270@gepard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717072944.GA27270@gepard>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dawid 'Kuba' Chrzan <qba@f-net.pl>
Cc: xfs@oss.sgi.com

On Tue, Jul 17, 2007 at 09:29:44AM +0200, Dawid 'Kuba' Chrzan wrote:
> On Mon, Jul 16, 2007 at 12:25:18PM +1000, David Chinner wrote:
> > Yes, you'll see this message for any filesystem that wasn't cleanly
> > unmounted and if it succeeds then you have nothing to worry about.
> 
> I know i know.... I was thinking rather about this if it is usual on
> raid1 - or some bug with xfs on raid.

It's probably indicative of a process still running holding an open
reference on the filesystem preventing it from being unmounted.
i.e. the shutdown scripts aren't killing everything or some such
problem...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
