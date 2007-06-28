Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 15:02:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5SM2TtL025603
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 15:02:31 -0700
Date: Fri, 29 Jun 2007 08:02:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: After reboot fs with barrier faster deletes then fs with nobarrier
Message-ID: <20070628220225.GB31489@sgi.com>
References: <op.tuldjrzef7nho5@sunset.cpc.wmin.ac.uk> <20070627222040.GR989688@sgi.com> <4683407E.9080707@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4683407E.9080707@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Szabolcs Illes <S.Illes@westminster.ac.uk>, xfs@oss.sgi.com

On Thu, Jun 28, 2007 at 03:00:46PM +1000, Timothy Shimmin wrote:
> David Chinner wrote:
> >On Wed, Jun 27, 2007 at 06:58:29PM +0100, Szabolcs Illes wrote:
> >>Hi,
> >>
> >>I am using XFS on my laptop, I have realized that nobarrier mount options 
> >>sometimes slows down deleting large number of small files, like the 
> >>kernel  source tree. I made four tests, deleting the kernel source right 
> >>after  unpack and after reboot, with both barrier and nobarrier options:
> >>
> >> mount opts: rw,noatime,nodiratime,logbsize=256k,logbufs=2
> >> illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync && 
> reboot
> >> After reboot:
> >> illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/
> >> real    0m28.127s
> >> user    0m0.044s
> >> sys     0m2.924s
> >> mount opts: rw,noatime,nodiratime,logbsize=256k,logbufs=2,nobarrier
> >> illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync && 
> reboot
> >> After reboot:
> >> illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/
> >> real    1m12.738s
> >> user    0m0.032s
> >> sys     0m2.548s
> >> It looks like with barrier it's faster deleting files after reboot.
> >> ( 28 sec vs 72 sec !!! ).
> >
> >Of course the second run will be faster here - the inodes are already in
> >cache and so there's no reading from disk needed to find the files
> >to delete....
> >
> >That's because run time after reboot is determined by how fast you
> >can traverse the directory structure (i.e. how many seeks are
> >involved). 
> >Barriers will have little impact on the uncached rm -rf
> >results, 
> 
> But it looks like barriers _are_ having impact on the uncached rm -rf
> results.

Tim, please be care with what you quote - you've quoted a different
set of results wot what I did and commented on and that takes my
comments way out of context.

In hindsight, I should have phrased it as "barriers _should_ have
little impact on uncached rm -rf results."

We've seen little impact in the past, and it's always been a
decrease in performance, so what we need to find out is how they are
having an impact. I suspect that it's to do with drive cache control
algorithms and barriers substantially reducing the amount of dirty
data being cached and hence read caching is working efficiently as a
side effect.

I guess the only way to confirm this is blktrace output to see what
I/Os are taking longer to execute when barriers are disabled.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
