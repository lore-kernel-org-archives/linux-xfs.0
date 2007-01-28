Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Jan 2007 13:51:26 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0SLpJqw015508
	for <xfs@oss.sgi.com>; Sun, 28 Jan 2007 13:51:21 -0800
Subject: Re: [DISCUSS] xfs allocation bitmap method over linux raid
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <5d96567b0701280232w17e1a187r95d2c59711799b1a@mail.gmail.com>
References: <5d96567b0701232234y2ff15762sbd1aaada5c3a0a0@mail.gmail.com>
	 <1169678294.18017.200.camel@edge>
	 <5d96567b0701280232w17e1a187r95d2c59711799b1a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 08:49:56 +1100
Message-Id: <1170020997.18017.236.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, 2007-01-28 at 12:32 +0200, Raz Ben-Jehuda(caro) wrote:
> > OOC, which one?  (would be nice to put an entry for your company
> > on the http://oss.sgi.com/projects/xfs/users.html page).
> >
> dd if=/dev/zero of=/d1/xxx bs=1M count=1000
> will reveil extents of size modulo(stripe unit ) !=  0

Does using direct IO change things (oflag=direct to dd iirc).

> > - and, er, removes some of the per-inode extsize hint code :)
> what is it?

See the "extsize" command within xfs_io(8).

> could my fix make any damage  ?
> what sort of a damage ?

Not really "damage" (as in filesystem integrity), its more that it
accidentally breaks existing functionality.

> > The real question is, why are your initial writes not being affected by
> > the code in xfs_iomap_eof_align_last_fsb which rounds requests to a
> > stripe unit boundary?
> 
> I debugged  xfs_iomap_write_delay:
> ip->i_d.di_extsize is zero and prealloc is zero. is it correct ?

prealloc shouldn't be zero for writes that will extend the file size;
but now that I think about it, I'm not sure how it could ever get set
for a buffered write (delalloc), since by the time we come to do the
actual allocation and writes to disk, the inode size will be beyond
the allocation offset.  Hmm, maybe the logic in there needs a rethink
(any thoughts there, Dave/Lachlan?)

> isn't it suppose stripe unit size in pages ?

No, extsize is not and should not be set unless its explicitly been
asked for (see the man page I refered to above).

> Also , xfs_iomap_eof_align_last_fsb has this line :
>    if (io->io_flags & XFS_IOCORE_RT)

Are you using the realtime subvolume?  You didn't mention that before,
so I guess you're not - in which case, the above line is not relevent
in your case.

> >  Provided you are writing sequentially, you should
> > be seeing xfs_iomap_eof_want_preallocate return true, then later doing
> > stripe unit alignment in xfs_iomap_eof_align_last_fsb (because prealloc
> > got set earlier) ... can you trace your requests through the routines
> > you've modified and find why this is _not_ happening?

cheers.

-- 
Nathan
