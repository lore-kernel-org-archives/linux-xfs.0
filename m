Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 17:01:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4A01OfB019947
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 17:01:26 -0700
Date: Thu, 10 May 2007 10:01:19 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070510000119.GO85884050@sgi.com>
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4642598E.3000607@goop.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

On Wed, May 09, 2007 at 04:30:22PM -0700, Jeremy Fitzhardinge wrote:
> David Chinner wrote:
> > On Wed, May 09, 2007 at 02:09:50PM -0700, Jeremy Fitzhardinge wrote:
> >   
> >> I've had a couple of instances of a linux-2.6 mercurial repo getting
> >> corrupted in some odd way this morning.  It looks like files are being
> >> truncated; not to size 0, but losing something off the end.
> >>
> >> This is on an xfs filesystem.  I haven't had any crashes/oops, and I
> >> don't think its the normal files getting filled with 0 problem.  I saw
> >> this before the most recent set of xfs updates, but it happened again
> >> afterwards too.
> >>     
> >
> > It looks like the latest XFS changes haven't been pulled yet, so
> > it's not new code that is triggering this....
> >   
> 
> A bunch of xfs changes appeared in git this morning, I thought.  But all
> this first happened from a kernel compiled yesterday.

Ah, yes so it did - damn browser caching....

> >> Mercurial uses a strictly append-only model for updating its repo files,
> >> but it looks like maybe an append operation didn't stick.
> >>
> >> I'm repulling a fresh copy of the repo; I'll be able to compare
> >> before/after.  Update: yep, definitely truncated:
> >>
> >> $ ls -l .hg-new/store/data/_documentation/pi-futex.txt.i .hg-broken/store/data/_documentation/pi-futex.txt.i
> >> 4 -rw-rw-r-- 1 jeremy jeremy 3309 May  9 09:43 .hg-broken/store/data/_documentation/pi-futex.txt.i
> >> 4 -rw-rw-r-- 1 jeremy jeremy 3797 May  9 13:38 .hg-new/store/data/_documentation/pi-futex.txt.i
> >>
> >> also
> >>   3476 -rw-rw-r--  1 jeremy jeremy   3558208 May  9 13:55 00manifest.i
> >>   3476 -rw-rw-r--  1 jeremy jeremy   3555200 May  9 09:41 00manifest.i~
> >>
> >>
> >> where 00manifest.i~ is the broken one. The files are identical up to the
> >> truncation point.
> >>     
> >
> > Hmmm - that is bizarre. What is the output of xfs_bmap -vvp <filename>
> > on each of those files?
> >   
> 00manifest.i~ is linux-2.6-broken/.hg/store/00manifest.i
> 
> $ xfs_bmap -vvp linux-2.6/.hg/store/00manifest.i linux-2.6-broken/.hg/store/00manifest.i
> linux-2.6/.hg/store/00manifest.i:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
......
>    6: [6144..6951]:    7930840..7931647  1 (66520..67327)     808
> linux-2.6-broken/.hg/store/00manifest.i:
>  EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET          TOTAL
.....
>   16: [6912..6943]:    27174568..27174599  3 (3581608..3581639)    32

Yeah, there's one extra filesystem block in the good case compared
to the broken case. If that was once good, then something has had to
truncate the file to remove that block....

> > what happens to these files after then are downloaded? Does it only
> > happen to append-only files or are other files affected as well?
> >   
> 
> I saw similar damage in another repo, but I was using the "mq" extension
> on that, which means the files are no longer append-only. 
> 
> I explicitly checked that repo was OK after I downloaded it.  It became
> broken again after a while. 
> 
> It was as if the dirty inode data was dropped without being written to
> disk, so once it had to read back it got a stale file length.  Or
> something like that - I'm just guessing.

Seems very unlikely. Have you unmounted and mounted the filesystem
(or rebooted or suspended) between the files being seen good and
the files being seen bad?

> > BTW, what's the 'xfs_info <mntpt>' output for this filesystem?
> >   
> 
> meta-data=/dev/vg00/homexfs      isize=256    agcount=19, agsize=983040 blks
>          =                       sectsz=512   attr=1
> data     =                       bsize=4096   blocks=18350080, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096  
> log      =internal               bsize=4096   blocks=7680, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=65536  blocks=0, rtextents=0

Ok, nothing unusual there.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
