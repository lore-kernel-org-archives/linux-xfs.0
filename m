Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Jan 2007 03:00:57 -0800 (PST)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.176])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0SB0oqw015036
	for <linux-xfs@oss.sgi.com>; Sun, 28 Jan 2007 03:00:51 -0800
Received: by py-out-1112.google.com with SMTP id p76so600489pyb
        for <linux-xfs@oss.sgi.com>; Sun, 28 Jan 2007 02:59:56 -0800 (PST)
Message-ID: <5d96567b0701280232w17e1a187r95d2c59711799b1a@mail.gmail.com>
Date: Sun, 28 Jan 2007 12:32:23 +0200
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: [DISCUSS] xfs allocation bitmap method over linux raid
In-Reply-To: <1169678294.18017.200.camel@edge>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d96567b0701232234y2ff15762sbd1aaada5c3a0a0@mail.gmail.com>
	 <1169678294.18017.200.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: linux-xfs@oss.sgi.com

first many thanks to your reply.
see bellow.

On 1/25/07, Nathan Scott <nscott@aconex.com> wrote:
> Hi Raz,
>
> On Wed, 2007-01-24 at 08:34 +0200, Raz Ben-Jehuda(caro) wrote:
> > David Hello.
> > I have looked up in LKML and hopefully you are the one to ask in
> > regard to xfs file system in Linux.

>
> OOC, which one?  (would be nice to put an entry for your company
> on the http://oss.sgi.com/projects/xfs/users.html page).
>
> > These servers demand high throughput from the storage.
> > We applied XFS file system on our machines.
> >
> > A video server reads a file in a sequential manner. So, if a
>
> Do you write the file sequentially?  Buffered or direct writes?
does not matter. even command like:
dd if=/dev/zero of=/d1/xxx bs=1M count=1000
will reveil extents of size modulo(stripe unit ) !=  0


> > file extent size is not a factor of the stripe unit size a sequential
> > read over a raid would break into several small pieces which
> > is undesirable for performance.
> >
> > I have been examining the bitmap of a file over Linux raid5.
>
> I've found that, in combination with Jens Axboe's blktrace toolkit
> to be very useful - if you have a sufficiently recent kernel, I'd
> highly recommend you check out blktrace, it should help you alot.
>
> (bmap == block map, theres no bitmap involved)
>
> > According to the documentation XFS tries to align a file on
> > stripe unit size.
> >
> > What I have done is to fix the bitmap allocation method during
> > the writing to be aligned by the stripe unit size.
>
> Thats not quite what the patch does, FWIW - it does two things:
> - forces allocations to be stripe unit sized (not aligned)
which is what i meant.
> - and, er, removes some of the per-inode extsize hint code :)
what is it?
could my fix make any damage  ?
what sort of a damage ?

> > /d1/rt/kernels/linux-2.6.17-UNI/fs/xfs/xfs_iomap.c
> > linux-2.6.17-UNI/fs/xfs/xfs_iomap.c
> > --- /d1/rt/kernels/linux-2.6.17-UNI/fs/xfs/xfs_iomap.c  2006-06-18
> > 01:49:35.000000000 +0000
> > +++ linux-2.6.17-UNI/fs/xfs/xfs_iomap.c 2006-12-26 14:11:02.000000000 +0000
> > @@ -441,8 +441,8 @@
> >     if (unlikely(rt)) {
> >         if (!(extsz = ip->i_d.di_extsize))
> >             extsz = mp->m_sb.sb_rextsize;
> > -   } else {
> > -       extsz = ip->i_d.di_extsize;
> > +   } else {
> > +        extsz =  mp->m_dalign; // raz fix alignment to raid stripe unit
> >     }
>
> The real question is, why are your initial writes not being affected by
> the code in xfs_iomap_eof_align_last_fsb which rounds requests to a
> stripe unit boundary?

I debugged  xfs_iomap_write_delay:
ip->i_d.di_extsize is zero and prealloc is zero. is it correct ?
isn't it suppose stripe unit size in pages ?

Also , xfs_iomap_eof_align_last_fsb has this line :
   if (io->io_flags & XFS_IOCORE_RT)
     ;

>  Provided you are writing sequentially, you should
> be seeing xfs_iomap_eof_want_preallocate return true, then later doing
> stripe unit alignment in xfs_iomap_eof_align_last_fsb (because prealloc
> got set earlier) ... can you trace your requests through the routines
> you've modified and find why this is _not_ happening?
>
> cheers.
>
> --
> Nathan
>
>


-- 
Raz
