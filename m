Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jan 2008 15:17:51 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0ENHfb2000685
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 15:17:44 -0800
Date: Tue, 15 Jan 2008 10:17:51 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: binary NULL errors
Message-ID: <20080114231751.GV155259@sgi.com>
References: <1200333949.3145.33.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200333949.3145.33.camel@fermat.scientia.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: xfs@oss.sgi.com

On Mon, Jan 14, 2008 at 07:05:49PM +0100, Christoph Anton Mitterer wrote:
> In the FAQ at http://oss.sgi.com/projects/xfs/faq.html it says:
> Update: This issue has been addressed with a CVS fix on the 29th March
> 2007 and merged into mainline on 8th May 2007 for 2.6.22-rc1.
> 
> What does this exactly mean and what has been fixed/addressed?

It means exactly what it says - that the problem has been fixed if
you use 2.6.22 or more recent.  If you want details, start looking
here:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ba87ea699ebd9dd577bf055ebc4a98200e337542

> Is XFS now similar to ext3 and I won't see those binary NULLs stuff
> again?

Yes, It will behave the same as ext3 - either you'll have a good
file or you'll see a zero length file (because the application
doesn't overwrite safely).

> What happens now in case of a powerloss?

Same thing as always happens on power loss - you lose whatever
is in memory. We're just more careful about how we update stuff
on disk now.

> Does XFS still make heavy use
> of caching techniques?

Yes, just like every other linux filesystem ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
