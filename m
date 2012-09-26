Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8Q2gpDX138796 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 21:42:51 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kbb5bmRQRmJqeeDc for <xfs@oss.sgi.com>;
	Tue, 25 Sep 2012 19:44:07 -0700 (PDT)
Date: Wed, 26 Sep 2012 12:44:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair deleting realtime files.
Message-ID: <20120926024403.GH29154@dastard>
References: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
	<505BF45D.5050909@sandeen.net> <20120924075551.GF20960@dastard>
	<CAHt31_8rEc93vpnbbKngY4uS0kAct3Z5A+2G0LmBzv5rWKdSfA@mail.gmail.com>
	<CAHt31__s2TNhXPa9JfDLdWPqr60Te9VDPKb4ieORF8JAL07YmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHt31__s2TNhXPa9JfDLdWPqr60Te9VDPKb4ieORF8JAL07YmQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Anand Tiwari <tiwarikanand@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Sep 25, 2012 at 07:26:32PM -0600, Anand Tiwari wrote:
> On Mon, Sep 24, 2012 at 6:51 AM, Anand Tiwari <tiwarikanand@gmail.com>wrote:
> 
> >
> >
> > On Mon, Sep 24, 2012 at 1:55 AM, Dave Chinner <david@fromorbit.com> wrote:
> >
> >> On Fri, Sep 21, 2012 at 12:00:13AM -0500, Eric Sandeen wrote:
> >> > On 9/20/12 7:40 PM, Anand Tiwari wrote:
> >> > > Hi All,
> >> > >
> >> > > I have been looking into an issue with xfs_repair with realtime sub
> >> volume. some times while running xfs_repair I see following errors
> >> > >
> >> > > ----------------------------
> >> > > data fork in rt inode 134 claims used rt block 19607
> >> > > bad data fork in inode 134
> >> > > would have cleared inode 134
> >> > > data fork in rt inode 135 claims used rt block 29607
> >> > > bad data fork in inode 135
> >> > > would have cleared inode 135
> >> .....
> >> > > xfs_db> inode 135
> >> > > xfs_db> bmap
> >> > > data offset 0 startblock 13062144 (12/479232) count 2097000 flag 0
> >> > > data offset 2097000 startblock 15159144 (14/479080) count 2097000
> >> flag 0
> >> > > data offset 4194000 startblock 17256144 (16/478928) count 2097000
> >> flag 0
> >> > > data offset 6291000 startblock 19353144 (18/478776) count 2097000
> >> flag 0
> >> > > data offset 8388000 startblock 21450144 (20/478624) count 2097000
> >> flag 0
> >> > > data offset 10485000 startblock 23547144 (22/478472) count 2097000
> >> flag 0
> >> > > data offset 12582000 startblock 25644144 (24/478320) count 2097000
> >> flag 0
> >> > > data offset 14679000 startblock 27741144 (26/478168) count 2097000
> >> flag 0
> >> > > data offset 16776000 startblock 29838144 (28/478016) count 2097000
> >> flag 0
> >> > > data offset 18873000 startblock 31935144 (30/477864) count 1607000
> >> flag 0
> >> > > xfs_db> inode 134
> >> > > xfs_db> bmap
> >> > > data offset 0 startblock 7942144 (7/602112) count 2097000 flag 0
> >> > > data offset 2097000 startblock 10039144 (9/601960) count 2097000 flag
> >> 0
> >> > > data offset 4194000 startblock 12136144 (11/601808) count 926000 flag
> >> 0
> >> >
> >> > It's been a while since I thought about realtime, but -
> >> >
> >> > That all seems fine, I don't see anything overlapping there, they are
> >> > all perfectly adjacent, though of interesting size.
> >>
> >> Yeah, the size is the problem.
> >>
> >> ....
> >> > Every extent above is length 2097000 blocks, and they are adjacent.
> >> > But you say your realtime extent size is 512 blocks ... which doesn't go
> >> > into 2097000 evenly.   So that's odd, at least.
> >>
> >> Once you realise that the bmapbt is recording multiples of FSB (4k)
> >> rather than rtextsz (2MB), it becomes more obvious what the problem
> >> is: rounding of the extent size at MAXEXTLEN - 2097000 is only 152
> >> blocks short of 2^21 (2097152).
> >>
> >> I haven't looked at the kernel code yet to work out why it is
> >> rounding to a non-rtextsz multiple, but that is the source of the
> >> problem.
> >>
> >> The repair code is detecting that extents are not of the
> >> correct granularity, but the error message indicates that this was
> >> only ever expected for duplicate blocks occurring rather than a
> >> kernel bug. So "fixing repair" is not what is needd here - finding
> >> and fixing the kernel bug is what you shoul be looking at.
> >>
> >> Cheers,
> >>
> >> Dave.
> >> --
> >> Dave Chinner
> >> david@fromorbit.com
> >>
> >
> >
> > thanks, I started looking at allocator code and and will report if see
> > something
> >
> 
> 
> I think this is what happening.  If we have following conditions,
>   1) we have more than 8gb contiguous space available to allocate. ( i.e.
> more than 2^21 4k blocks)
>   2) only one file is open for writing in real-time volume.
> 
> To satisfy first condition, I just took empty file-system.
> 
> Now lets start allocating, lets say in chucks of 25000, realtime allocator
> will have no problem allocating "exact" block while searching forward.
> xfs_rtfind_forw(). It will allocate 49 "real-time extents", where the 49th
> "real-time extent" is partially full.  (25000/512 = 48)
>
> everything is fine for first 83 allocations, as we were able to grow the
> extent. Now we have 2075000 (25000*83) blocks in first extent ie 4053
> "real-time extents" (where last "real-time extent" is partially full).
>
> for 84th allocation, real-time allocator will allocate another 49
> "real-time extents" as it does not know about maximum extent size, but we
> can not grow the extent in xfs_bmap_add_extent_unwritten_real().  so we
> insert a new extent (case BMAP_LEFT_FILLING).  now the new extent starts
> from 2075000, which is not aligned with rextsize (512 in this case).

Ok, so it's a problem with using unwritten extents and converting
them. That is, the issue probably has nothing to do with the
realtime allocator at all.

Basically, when the unwritten extent occurs, we end up with a map
like this:

ext 0:	offset 0, length 2075000 state written
ext 1:	offset 2075000 length 25000 state unwritten

This will occur because you can't mix written/unwritten state in a
single extent.

What xfs_bmap_add_extent_unwritten_real() is attempting to do is
convert the unwritten extent to written state and merge it with it's
siblings. In this case, 2075000 + 25000 > MAXEXTLEN, so it does not
merge them because of this check:

        if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) && 
            LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff && 
            LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock && 
            LEFT.br_state == newext && 
>>>>>>      LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN) 
                state |= BMAP_LEFT_CONTIG; 

Which means that BMAP_LEFT_CONTIG is not set, indicating that the no
merging with the an adjacent left extent should occur. Hence we end
up wwith this:

ext 0:	offset 0, length 2075000 state written
ext 1:	offset 2075000 length 25000 state written

That's fine for normal operation, but it means that large contiguous
regions written via direct IO with non-rtextsz aligned/sized IO will
have problem this problem.

What technically should happen for these real time files is that the
LEFT extent should be shortened to be aligned, and the new extent be
lengthened and have it's startblock adjusted accordingly.

i.e. we should end up with this:

ext 0:	offset 0, length 2074624 state written
ext 1:	offset 2074624 length 25376 state written

> To fix this, I see two options,
> 1) fix real-time allocator and teach it about maximum extent size.
> 2) for real-time files, aligned new extent before inserting.

3) Fix the {BMAP_LEFT_CONTIG,MAXEXTLEN,rtextsz} handling in
xfs_bmap_add_extent_unwritten_real().

It's possible that the BMAP_RIGHT_CONTIG case also needs similar
fixing...

> In my opinion, we should not worry about either of above, as this looks
> good method for allocation.  I can fix xfs_repair tool and make it aware of
> these conditions ("real-time extents" shared by two or more extents).

Personally, I'd prefer that 3) is done because RT extents should
always be rtextsz aligned and sized, and the bmapbt should respect
that requirement in all cases.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
