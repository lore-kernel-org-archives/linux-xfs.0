Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 May 2007 16:24:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4ONOKWt027777
	for <xfs@oss.sgi.com>; Thu, 24 May 2007 16:24:22 -0700
Date: Fri, 25 May 2007 09:24:05 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: PARTIAL TAKE 964999 - lazy superblock counters for XFS
Message-ID: <20070524232405.GE85884050@sgi.com>
References: <20070522075932.E665058CA531@chook.melbourne.sgi.com> <p73wsyxdhb3.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73wsyxdhb3.fsf@bingen.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

On Thu, May 24, 2007 at 11:48:16PM +0200, Andi Kleen wrote:
> dgc@sgi.com (David Chinner) writes:
> > 
> > The key to removing the contention is to not require the superblock
> > fields in question to be locked. We do that by not marking the
> > superblock dirty in the transaction. IOWs, we modify the incore
> > superblock but do not modify the cached superblock buffer. In short,
> > we do not log superblock modifications to critical fields in the
> > superblock on every transaction. In fact we only do it just before
> > we write the superblock to disk every sync period or just before
> > unmount.
> 
> Does this mean it will increases performance on small systems too
> due to less super block writes or is it purely for large
> system scalability?

If you are running 100 concurrent transactions to your small
filesystem, then yest, it will also help. But that sort of load
is usually seen on file servers  or large compute boxes doing lots
of file manipuations....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
