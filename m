Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 04:25:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBICOqsS025474
	for <linux-xfs@oss.sgi.com>; Tue, 18 Dec 2007 04:24:55 -0800
Date: Tue, 18 Dec 2007 23:24:45 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Important regression with XFS update for 2.6.24-rc6
Message-ID: <20071218122445.GJ4396912@sgi.com>
References: <20071218112804.GA3069@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218112804.GA3069@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Damien Wyart <damien.wyart@free.fr>
Cc: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, Peter Leckie <pleckie@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

On Tue, Dec 18, 2007 at 12:28:04PM +0100, Damien Wyart wrote:
> Hello,
> 
> As a follow-up to <http://marc.info/?l=linux-kernel&m=119796120524618&w=2>
> (LKML seems down right now so I am not linking to it), I have detected an
> important problem with these two patches: after applying them by hand
> (downloaded them raw from SGI's gitweb) on top of 2.6.24-rc5-git5 (they have
> not yet been pulled into mainline by Linux as of this morning) for testing
> purposes, I noticed upon reboot that "ls -l" on directories with many files
> and subdirectories (around 5000 entries) takes several hundreds of MB in RAM
> and then dies with "memory exhausted" error.

Ok. I haven't noticed anything wrong with directories up to about 250,000
files in the last few days. The ls -l I just did on a directory with
15000 entries (btree format) used about 5MB of RAM. extent format
directories appear to work fine as well (tested 500 entries).

Can you:

	a) isolate the problem to one patch or the other. My guess
	   would be the directory mod, but.....
	b) show your working ;)
		- what platform (i386, x86_64, etc)
		- what debug options
		- commands and output that shows the problem
		- strace of ls -l going bad
		- xfs_info from filesystem in question

> I also noticed that ldconfig takes a lot of time to complete, and firefox
> seems also to eat much more memory than usual. Reverting the two patches
> (going back to vanilla rc5-git5) makes these problems go away.  I am not
> able to test right now if only one of the patches is bogus or if both of
> them are concerned.

Well, there goes a).....

> As the symptoms are easy to reproduce, I guess this is some kind of brown
> paper bag bug and will be easy for XFS experts to spot.

Well, not reproducable on my test boxes. It may well be a brown paper
bag job, but it's not obvious.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
