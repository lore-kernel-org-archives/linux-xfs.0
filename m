Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Feb 2008 21:05:56 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1N55m0G023547
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 21:05:52 -0800
Date: Sat, 23 Feb 2008 16:06:03 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [REVIEW] Add lazy-counter conversion to xfs_repair
Message-ID: <20080223050603.GH155259@sgi.com>
References: <op.t6wyesz53jf8g2@pc-bnaujok.melbourne.sgi.com> <47BF0859.6020707@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BF0859.6020707@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Feb 22, 2008 at 11:37:29AM -0600, Eric Sandeen wrote:
> Barry Naujok wrote:
> > In response to the thread "Differences in mkfs.xfs and xfs_info output.",  
> > xfs_repair has been improved to allow version changes/conversion of  
> > filesystems.
> > 
> > So, this patch introduces the first in an ongoing series of in-place  
> > filesystem version changes with xfs_repair and the "-c" (convert) option.
> > 
> > To turn on/off the lazy-superblock feature, run the following xfs_repair  
> > commmand on your filesystem:
> > 
> > # xfs_repair -c lazycount=[0|1] <device>
> 
> How about adding this to xfs_admin as well, since some flag changes are
> already in there?
> 
> i.e. xfs_admin -<something... l and L are taken> could invoke xfs_repair
> -c lazycount ...?
> 
> It just strikes me as a tad confusing that to change v2 logs or
> unwritten extent support, you use xfs_admin, and to change lazy sb
> counters, you must run repair...

*nod*

> (I understand that repair must be run post-change, but a common tool to
> invoke all feature changes seems good to me)

I have to say I agree with Eric here - xfs_admin is the interface that
should be used for changing feature bits in the filesystem. The mechanism
it invokes to acheive the change can be anything, but we should have a
single tool that we direct ppl to use to to change how their filesystem
behaves.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
