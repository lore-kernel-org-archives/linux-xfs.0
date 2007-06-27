Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 15:20:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5RMKjtL020259
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 15:20:47 -0700
Date: Thu, 28 Jun 2007 08:20:40 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: After reboot fs with barrier faster deletes then fs with nobarrier
Message-ID: <20070627222040.GR989688@sgi.com>
References: <op.tuldjrzef7nho5@sunset.cpc.wmin.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.tuldjrzef7nho5@sunset.cpc.wmin.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Szabolcs Illes <S.Illes@westminster.ac.uk>
Cc: xfs@oss.sgi.com

On Wed, Jun 27, 2007 at 06:58:29PM +0100, Szabolcs Illes wrote:
> Hi,
> 
> I am using XFS on my laptop, I have realized that nobarrier mount options  
> sometimes slows down deleting large number of small files, like the kernel  
> source tree. I made four tests, deleting the kernel source right after  
> unpack and after reboot, with both barrier and nobarrier options:
> 
> mount opts: rw,noatime,nodiratime,logbsize=256k,logbufs=2
> 
> illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync &&  
> reboot
> 
> After reboot:
> illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/
> 
> real    0m28.127s
> user    0m0.044s
> sys     0m2.924s
> 
> illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync
> illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/
> 
> real    0m14.872s
> user    0m0.044s
> sys     0m2.872s

Of course the second run will be faster here - the inodes are already in
cache and so there's no reading from disk needed to find the files
to delete....

That's because run time after reboot is determined by how fast you
can traverse the directory structure (i.e. how many seeks are
involved). Barriers will have little impact on the uncached rm -rf
results, but as the cached rm time will be log-I/O bound, nobarrier
will be far faster (as you've found out).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
