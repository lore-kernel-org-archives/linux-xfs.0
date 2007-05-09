Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 16:16:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l49NGqfB008827
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 16:16:54 -0700
Date: Thu, 10 May 2007 09:16:43 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070509231643.GM85884050@sgi.com>
References: <4642389E.4080804@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4642389E.4080804@goop.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

On Wed, May 09, 2007 at 02:09:50PM -0700, Jeremy Fitzhardinge wrote:
> I've had a couple of instances of a linux-2.6 mercurial repo getting
> corrupted in some odd way this morning.  It looks like files are being
> truncated; not to size 0, but losing something off the end.
> 
> This is on an xfs filesystem.  I haven't had any crashes/oops, and I
> don't think its the normal files getting filled with 0 problem.  I saw
> this before the most recent set of xfs updates, but it happened again
> afterwards too.

It looks like the latest XFS changes haven't been pulled yet, so
it's not new code that is triggering this....

> Mercurial uses a strictly append-only model for updating its repo files,
> but it looks like maybe an append operation didn't stick.
> 
> I'm repulling a fresh copy of the repo; I'll be able to compare
> before/after.  Update: yep, definitely truncated:
> 
> $ ls -l .hg-new/store/data/_documentation/pi-futex.txt.i .hg-broken/store/data/_documentation/pi-futex.txt.i
> 4 -rw-rw-r-- 1 jeremy jeremy 3309 May  9 09:43 .hg-broken/store/data/_documentation/pi-futex.txt.i
> 4 -rw-rw-r-- 1 jeremy jeremy 3797 May  9 13:38 .hg-new/store/data/_documentation/pi-futex.txt.i
> 
> also
>   3476 -rw-rw-r--  1 jeremy jeremy   3558208 May  9 13:55 00manifest.i
>   3476 -rw-rw-r--  1 jeremy jeremy   3555200 May  9 09:41 00manifest.i~
> 
> 
> where 00manifest.i~ is the broken one. The files are identical up to the
> truncation point.

Hmmm - that is bizarre. What is the output of xfs_bmap -vvp <filename>
on each of those files?

what happens to these files after then are downloaded? Does it only
happen to append-only files or are other files affected as well?

BTW, what's the 'xfs_info <mntpt>' output for this filesystem?

> The repo passed "hg verify" just after I pulled it, so this corruption
> came about after a while.
> 
> Hm, the other possibility is that nlinks is being misreported.  When
> cloning a repo, mercurial will generally hard-link files where possible,
> and then break the link if it sees nlink > 1.  If xfs is mis-reporting
> the link count, then this will cause havok.  Is that possible?  Seems
> unlikely, but it would also explain the symptoms.  I just did a linking
> clone with an older kernel, and the link count is as expected.

I'd be surprised if it was a link count problem - that would cause
all sorts of other problems as well....

> xfs_check passes without any output, which I presume is good.

Yes, it means everythign is ok. You only have to worry when xfs_check
says something - it only brings bad news ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
