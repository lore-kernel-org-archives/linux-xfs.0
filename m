Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 16:01:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m39N1jX5010763
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 16:01:48 -0700
Date: Thu, 10 Apr 2008 09:02:19 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Re: Does XFS prevent disk spindown?
Message-ID: <20080409230219.GM108924158@sgi.com>
References: <20080401003005.GJ103491721@sgi.com> <47F1CF6D.2040103@sandeen.net> <m2d4p9o2sc.fsf@getmail.no> <m2y77smmdj.fsf@getmail.no> <47F9735E.8020900@sgi.com> <m2wsn9qub4.fsf@getmail.no> <20080407215855.GE108924158@sgi.com> <m2skxwriye.fsf@getmail.no> <20080409041113.GC108924158@sgi.com> <m21w5eiuj1.fsf@getmail.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m21w5eiuj1.fsf@getmail.no>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thor Kristoffersen <thorkr@gmail.com>
Cc: David Chinner <dgc@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Wed, Apr 09, 2008 at 11:32:34PM +0200, Thor Kristoffersen wrote:
> David Chinner <dgc@sgi.com> writes:
> >>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> >> realtime =none                   extsz=4096   blocks=0, rtextents=0
> >> 
> >> Is that what's causing it?  I have never specified any lazy-count option
> >> when I created or mounted the filesystem.  I didn't even know it existed.
> >
> > Introduced in 2.6.22, and recently was made the default mkfs config.
> >
> > Try the patch below.
> 
> Thanks a lot, David!  Your patch worked perfectly.  Also thanks to the
> others who helped me track down this issue.

Cool. I'll get that patch reviewed and checked in, then.

> BTW, what are the consequences of setting lazy-count to 0?  Less safety?
> Reduced performance?

One a single disk? No difference to performance, but significantly
lower latency on metadata operations is seen when using lazy-count=1.

If you have lots of disks, or low-latency caches in front of your disks,
lazy-count=1 will prevent superblock updates from being the metadata
performance limiting factor.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
