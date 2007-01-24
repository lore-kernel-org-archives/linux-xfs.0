Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 14:40:16 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0OMe6qw001285
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 14:40:10 -0800
Subject: Re: [DISCUSS] xfs allocation bitmap method over linux raid
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <5d96567b0701232234y2ff15762sbd1aaada5c3a0a0@mail.gmail.com>
References: <5d96567b0701232234y2ff15762sbd1aaada5c3a0a0@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 25 Jan 2007 09:38:13 +1100
Message-Id: <1169678294.18017.200.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: xfs@oss.sgi.com

Hi Raz,

On Wed, 2007-01-24 at 08:34 +0200, Raz Ben-Jehuda(caro) wrote:
> David Hello.
> I have looked up in LKML and hopefully you are the one to ask in
> regard to xfs file system in Linux.
> My name is Raz and I work for a video servers company.

OOC, which one?  (would be nice to put an entry for your company
on the http://oss.sgi.com/projects/xfs/users.html page).

> These servers demand high throughput from the storage.
> We applied XFS file system on our machines.
> 
> A video server reads a file in a sequential manner. So, if a

Do you write the file sequentially?  Buffered or direct writes?

> file extent size is not a factor of the stripe unit size a sequential
> read over a raid would break into several small pieces which
> is undesirable for performance.
> 
> I have been examining the bitmap of a file over Linux raid5.

I've found that, in combination with Jens Axboe's blktrace toolkit
to be very useful - if you have a sufficiently recent kernel, I'd
highly recommend you check out blktrace, it should help you alot.

(bmap == block map, theres no bitmap involved)

> According to the documentation XFS tries to align a file on
> stripe unit size.
> 
> What I have done is to fix the bitmap allocation method during
> the writing to be aligned by the stripe unit size.

Thats not quite what the patch does, FWIW - it does two things:
- forces allocations to be stripe unit sized (not aligned)
- and, er, removes some of the per-inode extsize hint code :)

> /d1/rt/kernels/linux-2.6.17-UNI/fs/xfs/xfs_iomap.c
> linux-2.6.17-UNI/fs/xfs/xfs_iomap.c
> --- /d1/rt/kernels/linux-2.6.17-UNI/fs/xfs/xfs_iomap.c  2006-06-18
> 01:49:35.000000000 +0000
> +++ linux-2.6.17-UNI/fs/xfs/xfs_iomap.c 2006-12-26 14:11:02.000000000 +0000
> @@ -441,8 +441,8 @@
>     if (unlikely(rt)) {
>         if (!(extsz = ip->i_d.di_extsize))
>             extsz = mp->m_sb.sb_rextsize;
> -   } else {
> -       extsz = ip->i_d.di_extsize;
> +   } else {
> +        extsz =  mp->m_dalign; // raz fix alignment to raid stripe unit
>     }

The real question is, why are your initial writes not being affected by
the code in xfs_iomap_eof_align_last_fsb which rounds requests to a
stripe unit boundary?  Provided you are writing sequentially, you should
be seeing xfs_iomap_eof_want_preallocate return true, then later doing
stripe unit alignment in xfs_iomap_eof_align_last_fsb (because prealloc
got set earlier) ... can you trace your requests through the routines
you've modified and find why this is _not_ happening?

cheers.

-- 
Nathan
