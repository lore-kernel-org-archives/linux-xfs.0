Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8Q3p4r3151795 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 22:51:04 -0500
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	XnpMI232XkGfkyCC (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Sep 2012 20:52:21 -0700 (PDT)
Received: by vchn11 with SMTP id n11so165484vch.26
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 20:52:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120926024403.GH29154@dastard>
References: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
	<505BF45D.5050909@sandeen.net> <20120924075551.GF20960@dastard>
	<CAHt31_8rEc93vpnbbKngY4uS0kAct3Z5A+2G0LmBzv5rWKdSfA@mail.gmail.com>
	<CAHt31__s2TNhXPa9JfDLdWPqr60Te9VDPKb4ieORF8JAL07YmQ@mail.gmail.com>
	<20120926024403.GH29154@dastard>
Date: Tue, 25 Sep 2012 21:45:07 -0600
Message-ID: <CAHt31__FPLsDdVCVwwLO0Sh9v_KK2pzU577nywFPAmf_C-gRcQ@mail.gmail.com>
Subject: Re: xfs_repair deleting realtime files.
From: Anand Tiwari <tiwarikanand@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0664052266661761840=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============0664052266661761840==
Content-Type: multipart/alternative; boundary=20cf3079bab617f6bb04ca92a687

--20cf3079bab617f6bb04ca92a687
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Sep 25, 2012 at 8:44 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Sep 25, 2012 at 07:26:32PM -0600, Anand Tiwari wrote:
> > On Mon, Sep 24, 2012 at 6:51 AM, Anand Tiwari <tiwarikanand@gmail.com
> >wrote:
> >
> > >
> > >
> > > On Mon, Sep 24, 2012 at 1:55 AM, Dave Chinner <david@fromorbit.com>
> wrote:
> > >
> > >> On Fri, Sep 21, 2012 at 12:00:13AM -0500, Eric Sandeen wrote:
> > >> > On 9/20/12 7:40 PM, Anand Tiwari wrote:
> > >> > > Hi All,
> > >> > >
> > >> > > I have been looking into an issue with xfs_repair with realtime
> sub
> > >> volume. some times while running xfs_repair I see following errors
> > >> > >
> > >> > > ----------------------------
> > >> > > data fork in rt inode 134 claims used rt block 19607
> > >> > > bad data fork in inode 134
> > >> > > would have cleared inode 134
> > >> > > data fork in rt inode 135 claims used rt block 29607
> > >> > > bad data fork in inode 135
> > >> > > would have cleared inode 135
> > >> .....
> > >> > > xfs_db> inode 135
> > >> > > xfs_db> bmap
> > >> > > data offset 0 startblock 13062144 (12/479232) count 2097000 flag 0
> > >> > > data offset 2097000 startblock 15159144 (14/479080) count 2097000
> > >> flag 0
> > >> > > data offset 4194000 startblock 17256144 (16/478928) count 2097000
> > >> flag 0
> > >> > > data offset 6291000 startblock 19353144 (18/478776) count 2097000
> > >> flag 0
> > >> > > data offset 8388000 startblock 21450144 (20/478624) count 2097000
> > >> flag 0
> > >> > > data offset 10485000 startblock 23547144 (22/478472) count 2097000
> > >> flag 0
> > >> > > data offset 12582000 startblock 25644144 (24/478320) count 2097000
> > >> flag 0
> > >> > > data offset 14679000 startblock 27741144 (26/478168) count 2097000
> > >> flag 0
> > >> > > data offset 16776000 startblock 29838144 (28/478016) count 2097000
> > >> flag 0
> > >> > > data offset 18873000 startblock 31935144 (30/477864) count 1607000
> > >> flag 0
> > >> > > xfs_db> inode 134
> > >> > > xfs_db> bmap
> > >> > > data offset 0 startblock 7942144 (7/602112) count 2097000 flag 0
> > >> > > data offset 2097000 startblock 10039144 (9/601960) count 2097000
> flag
> > >> 0
> > >> > > data offset 4194000 startblock 12136144 (11/601808) count 926000
> flag
> > >> 0
> > >> >
> > >> > It's been a while since I thought about realtime, but -
> > >> >
> > >> > That all seems fine, I don't see anything overlapping there, they
> are
> > >> > all perfectly adjacent, though of interesting size.
> > >>
> > >> Yeah, the size is the problem.
> > >>
> > >> ....
> > >> > Every extent above is length 2097000 blocks, and they are adjacent.
> > >> > But you say your realtime extent size is 512 blocks ... which
> doesn't go
> > >> > into 2097000 evenly.   So that's odd, at least.
> > >>
> > >> Once you realise that the bmapbt is recording multiples of FSB (4k)
> > >> rather than rtextsz (2MB), it becomes more obvious what the problem
> > >> is: rounding of the extent size at MAXEXTLEN - 2097000 is only 152
> > >> blocks short of 2^21 (2097152).
> > >>
> > >> I haven't looked at the kernel code yet to work out why it is
> > >> rounding to a non-rtextsz multiple, but that is the source of the
> > >> problem.
> > >>
> > >> The repair code is detecting that extents are not of the
> > >> correct granularity, but the error message indicates that this was
> > >> only ever expected for duplicate blocks occurring rather than a
> > >> kernel bug. So "fixing repair" is not what is needd here - finding
> > >> and fixing the kernel bug is what you shoul be looking at.
> > >>
> > >> Cheers,
> > >>
> > >> Dave.
> > >> --
> > >> Dave Chinner
> > >> david@fromorbit.com
> > >>
> > >
> > >
> > > thanks, I started looking at allocator code and and will report if see
> > > something
> > >
> >
> >
> > I think this is what happening.  If we have following conditions,
> >   1) we have more than 8gb contiguous space available to allocate. ( i.e.
> > more than 2^21 4k blocks)
> >   2) only one file is open for writing in real-time volume.
> >
> > To satisfy first condition, I just took empty file-system.
> >
> > Now lets start allocating, lets say in chucks of 25000, realtime
> allocator
> > will have no problem allocating "exact" block while searching forward.
> > xfs_rtfind_forw(). It will allocate 49 "real-time extents", where the
> 49th
> > "real-time extent" is partially full.  (25000/512 = 48)
> >
> > everything is fine for first 83 allocations, as we were able to grow the
> > extent. Now we have 2075000 (25000*83) blocks in first extent ie 4053
> > "real-time extents" (where last "real-time extent" is partially full).
> >
> > for 84th allocation, real-time allocator will allocate another 49
> > "real-time extents" as it does not know about maximum extent size, but we
> > can not grow the extent in xfs_bmap_add_extent_unwritten_real().  so we
> > insert a new extent (case BMAP_LEFT_FILLING).  now the new extent starts
> > from 2075000, which is not aligned with rextsize (512 in this case).
>
> Ok, so it's a problem with using unwritten extents and converting
> them. That is, the issue probably has nothing to do with the
> realtime allocator at all.
>
> Basically, when the unwritten extent occurs, we end up with a map
> like this:
>
> ext 0:  offset 0, length 2075000 state written
> ext 1:  offset 2075000 length 25000 state unwritten
>
> This will occur because you can't mix written/unwritten state in a
> single extent.
>
> What xfs_bmap_add_extent_unwritten_real() is attempting to do is
> convert the unwritten extent to written state and merge it with it's
> siblings. In this case, 2075000 + 25000 > MAXEXTLEN, so it does not
> merge them because of this check:
>
>         if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
>             LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
>             LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock
> &&
>             LEFT.br_state == newext &&
> >>>>>>      LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
>                 state |= BMAP_LEFT_CONTIG;
>
> Which means that BMAP_LEFT_CONTIG is not set, indicating that the no
> merging with the an adjacent left extent should occur. Hence we end
> up wwith this:
>
> ext 0:  offset 0, length 2075000 state written
> ext 1:  offset 2075000 length 25000 state written
>
> That's fine for normal operation, but it means that large contiguous
> regions written via direct IO with non-rtextsz aligned/sized IO will
> have problem this problem.
>
> What technically should happen for these real time files is that the
> LEFT extent should be shortened to be aligned, and the new extent be
> lengthened and have it's startblock adjusted accordingly.
>
> i.e. we should end up with this:
>
> ext 0:  offset 0, length 2074624 state written
> ext 1:  offset 2074624 length 25376 state written
>
> > To fix this, I see two options,
> > 1) fix real-time allocator and teach it about maximum extent size.
> > 2) for real-time files, aligned new extent before inserting.
>
> 3) Fix the {BMAP_LEFT_CONTIG,MAXEXTLEN,rtextsz} handling in
> xfs_bmap_add_extent_unwritten_real().
>
> It's possible that the BMAP_RIGHT_CONTIG case also needs similar
> fixing...
>
> > In my opinion, we should not worry about either of above, as this looks
> > good method for allocation.  I can fix xfs_repair tool and make it aware
> of
> > these conditions ("real-time extents" shared by two or more extents).
>
> Personally, I'd prefer that 3) is done because RT extents should
> always be rtextsz aligned and sized, and the bmapbt should respect
> that requirement in all cases.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

thanks Dave for prompt reply, I meant to implement option 2 as you
explained (option 3).  I will start working on it tomorrow. In the mean
time, I also had  to put something in xfs_repair for the files which
already exists on the disk. Would you guys willing to review/comment on
that ?

anand

--20cf3079bab617f6bb04ca92a687
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Tue, Sep 25, 2012 at 8:44 PM, Dave Ch=
inner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"HOEnZb"><div class=3D"h5">On Tue, Sep 25, 2012 at 07:26:32PM =
-0600, Anand Tiwari wrote:<br>
&gt; On Mon, Sep 24, 2012 at 6:51 AM, Anand Tiwari &lt;<a href=3D"mailto:ti=
warikanand@gmail.com">tiwarikanand@gmail.com</a>&gt;wrote:<br>
&gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; On Mon, Sep 24, 2012 at 1:55 AM, Dave Chinner &lt;<a href=3D"mail=
to:david@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt; &gt;<br>
&gt; &gt;&gt; On Fri, Sep 21, 2012 at 12:00:13AM -0500, Eric Sandeen wrote:=
<br>
&gt; &gt;&gt; &gt; On 9/20/12 7:40 PM, Anand Tiwari wrote:<br>
&gt; &gt;&gt; &gt; &gt; Hi All,<br>
&gt; &gt;&gt; &gt; &gt;<br>
&gt; &gt;&gt; &gt; &gt; I have been looking into an issue with xfs_repair w=
ith realtime sub<br>
&gt; &gt;&gt; volume. some times while running xfs_repair I see following e=
rrors<br>
&gt; &gt;&gt; &gt; &gt;<br>
&gt; &gt;&gt; &gt; &gt; ----------------------------<br>
&gt; &gt;&gt; &gt; &gt; data fork in rt inode 134 claims used rt block 1960=
7<br>
&gt; &gt;&gt; &gt; &gt; bad data fork in inode 134<br>
&gt; &gt;&gt; &gt; &gt; would have cleared inode 134<br>
&gt; &gt;&gt; &gt; &gt; data fork in rt inode 135 claims used rt block 2960=
7<br>
&gt; &gt;&gt; &gt; &gt; bad data fork in inode 135<br>
&gt; &gt;&gt; &gt; &gt; would have cleared inode 135<br>
&gt; &gt;&gt; .....<br>
&gt; &gt;&gt; &gt; &gt; xfs_db&gt; inode 135<br>
&gt; &gt;&gt; &gt; &gt; xfs_db&gt; bmap<br>
&gt; &gt;&gt; &gt; &gt; data offset 0 startblock 13062144 (12/479232) count=
 2097000 flag 0<br>
&gt; &gt;&gt; &gt; &gt; data offset 2097000 startblock 15159144 (14/479080)=
 count 2097000<br>
&gt; &gt;&gt; flag 0<br>
&gt; &gt;&gt; &gt; &gt; data offset 4194000 startblock 17256144 (16/478928)=
 count 2097000<br>
&gt; &gt;&gt; flag 0<br>
&gt; &gt;&gt; &gt; &gt; data offset 6291000 startblock 19353144 (18/478776)=
 count 2097000<br>
&gt; &gt;&gt; flag 0<br>
&gt; &gt;&gt; &gt; &gt; data offset 8388000 startblock 21450144 (20/478624)=
 count 2097000<br>
&gt; &gt;&gt; flag 0<br>
&gt; &gt;&gt; &gt; &gt; data offset 10485000 startblock 23547144 (22/478472=
) count 2097000<br>
&gt; &gt;&gt; flag 0<br>
&gt; &gt;&gt; &gt; &gt; data offset 12582000 startblock 25644144 (24/478320=
) count 2097000<br>
&gt; &gt;&gt; flag 0<br>
&gt; &gt;&gt; &gt; &gt; data offset 14679000 startblock 27741144 (26/478168=
) count 2097000<br>
&gt; &gt;&gt; flag 0<br>
&gt; &gt;&gt; &gt; &gt; data offset 16776000 startblock 29838144 (28/478016=
) count 2097000<br>
&gt; &gt;&gt; flag 0<br>
&gt; &gt;&gt; &gt; &gt; data offset 18873000 startblock 31935144 (30/477864=
) count 1607000<br>
&gt; &gt;&gt; flag 0<br>
&gt; &gt;&gt; &gt; &gt; xfs_db&gt; inode 134<br>
&gt; &gt;&gt; &gt; &gt; xfs_db&gt; bmap<br>
&gt; &gt;&gt; &gt; &gt; data offset 0 startblock 7942144 (7/602112) count 2=
097000 flag 0<br>
&gt; &gt;&gt; &gt; &gt; data offset 2097000 startblock 10039144 (9/601960) =
count 2097000 flag<br>
&gt; &gt;&gt; 0<br>
&gt; &gt;&gt; &gt; &gt; data offset 4194000 startblock 12136144 (11/601808)=
 count 926000 flag<br>
&gt; &gt;&gt; 0<br>
&gt; &gt;&gt; &gt;<br>
&gt; &gt;&gt; &gt; It&#39;s been a while since I thought about realtime, bu=
t -<br>
&gt; &gt;&gt; &gt;<br>
&gt; &gt;&gt; &gt; That all seems fine, I don&#39;t see anything overlappin=
g there, they are<br>
&gt; &gt;&gt; &gt; all perfectly adjacent, though of interesting size.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Yeah, the size is the problem.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; ....<br>
&gt; &gt;&gt; &gt; Every extent above is length 2097000 blocks, and they ar=
e adjacent.<br>
&gt; &gt;&gt; &gt; But you say your realtime extent size is 512 blocks ... =
which doesn&#39;t go<br>
&gt; &gt;&gt; &gt; into 2097000 evenly. =A0 So that&#39;s odd, at least.<br=
>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Once you realise that the bmapbt is recording multiples of FS=
B (4k)<br>
&gt; &gt;&gt; rather than rtextsz (2MB), it becomes more obvious what the p=
roblem<br>
&gt; &gt;&gt; is: rounding of the extent size at MAXEXTLEN - 2097000 is onl=
y 152<br>
&gt; &gt;&gt; blocks short of 2^21 (2097152).<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; I haven&#39;t looked at the kernel code yet to work out why i=
t is<br>
&gt; &gt;&gt; rounding to a non-rtextsz multiple, but that is the source of=
 the<br>
&gt; &gt;&gt; problem.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; The repair code is detecting that extents are not of the<br>
&gt; &gt;&gt; correct granularity, but the error message indicates that thi=
s was<br>
&gt; &gt;&gt; only ever expected for duplicate blocks occurring rather than=
 a<br>
&gt; &gt;&gt; kernel bug. So &quot;fixing repair&quot; is not what is needd=
 here - finding<br>
&gt; &gt;&gt; and fixing the kernel bug is what you shoul be looking at.<br=
>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Cheers,<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Dave.<br>
&gt; &gt;&gt; --<br>
&gt; &gt;&gt; Dave Chinner<br>
&gt; &gt;&gt; <a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a=
><br>
&gt; &gt;&gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; thanks, I started looking at allocator code and and will report i=
f see<br>
&gt; &gt; something<br>
&gt; &gt;<br>
&gt;<br>
&gt;<br>
&gt; I think this is what happening. =A0If we have following conditions,<br=
>
&gt; =A0 1) we have more than 8gb contiguous space available to allocate. (=
 i.e.<br>
&gt; more than 2^21 4k blocks)<br>
&gt; =A0 2) only one file is open for writing in real-time volume.<br>
&gt;<br>
&gt; To satisfy first condition, I just took empty file-system.<br>
&gt;<br>
&gt; Now lets start allocating, lets say in chucks of 25000, realtime alloc=
ator<br>
&gt; will have no problem allocating &quot;exact&quot; block while searchin=
g forward.<br>
&gt; xfs_rtfind_forw(). It will allocate 49 &quot;real-time extents&quot;, =
where the 49th<br>
&gt; &quot;real-time extent&quot; is partially full. =A0(25000/512 =3D 48)<=
br>
&gt;<br>
&gt; everything is fine for first 83 allocations, as we were able to grow t=
he<br>
&gt; extent. Now we have 2075000 (25000*83) blocks in first extent ie 4053<=
br>
&gt; &quot;real-time extents&quot; (where last &quot;real-time extent&quot;=
 is partially full).<br>
&gt;<br>
&gt; for 84th allocation, real-time allocator will allocate another 49<br>
&gt; &quot;real-time extents&quot; as it does not know about maximum extent=
 size, but we<br>
&gt; can not grow the extent in xfs_bmap_add_extent_unwritten_real(). =A0so=
 we<br>
&gt; insert a new extent (case BMAP_LEFT_FILLING). =A0now the new extent st=
arts<br>
&gt; from 2075000, which is not aligned with rextsize (512 in this case).<b=
r>
<br>
</div></div>Ok, so it&#39;s a problem with using unwritten extents and conv=
erting<br>
them. That is, the issue probably has nothing to do with the<br>
realtime allocator at all.<br>
<br>
Basically, when the unwritten extent occurs, we end up with a map<br>
like this:<br>
<br>
ext 0: =A0offset 0, length 2075000 state written<br>
ext 1: =A0offset 2075000 length 25000 state unwritten<br>
<br>
This will occur because you can&#39;t mix written/unwritten state in a<br>
single extent.<br>
<br>
What xfs_bmap_add_extent_unwritten_real() is attempting to do is<br>
convert the unwritten extent to written state and merge it with it&#39;s<br=
>
siblings. In this case, 2075000 + 25000 &gt; MAXEXTLEN, so it does not<br>
merge them because of this check:<br>
<br>
=A0 =A0 =A0 =A0 if ((state &amp; BMAP_LEFT_VALID) &amp;&amp; !(state &amp; =
BMAP_LEFT_DELAY) &amp;&amp;<br>
=A0 =A0 =A0 =A0 =A0 =A0 LEFT.br_startoff + LEFT.br_blockcount =3D=3D new-&g=
t;br_startoff &amp;&amp;<br>
=A0 =A0 =A0 =A0 =A0 =A0 LEFT.br_startblock + LEFT.br_blockcount =3D=3D new-=
&gt;br_startblock &amp;&amp;<br>
=A0 =A0 =A0 =A0 =A0 =A0 LEFT.br_state =3D=3D newext &amp;&amp;<br>
&gt;&gt;&gt;&gt;&gt;&gt; =A0 =A0 =A0LEFT.br_blockcount + new-&gt;br_blockco=
unt &lt;=3D MAXEXTLEN)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 state |=3D BMAP_LEFT_CONTIG;<br>
<br>
Which means that BMAP_LEFT_CONTIG is not set, indicating that the no<br>
merging with the an adjacent left extent should occur. Hence we end<br>
up wwith this:<br>
<br>
ext 0: =A0offset 0, length 2075000 state written<br>
ext 1: =A0offset 2075000 length 25000 state written<br>
<br>
That&#39;s fine for normal operation, but it means that large contiguous<br=
>
regions written via direct IO with non-rtextsz aligned/sized IO will<br>
have problem this problem.<br>
<br>
What technically should happen for these real time files is that the<br>
LEFT extent should be shortened to be aligned, and the new extent be<br>
lengthened and have it&#39;s startblock adjusted accordingly.<br>
<br>
i.e. we should end up with this:<br>
<br>
ext 0: =A0offset 0, length 2074624 state written<br>
ext 1: =A0offset 2074624 length 25376 state written<br>
<div class=3D"im"><br>
&gt; To fix this, I see two options,<br>
&gt; 1) fix real-time allocator and teach it about maximum extent size.<br>
&gt; 2) for real-time files, aligned new extent before inserting.<br>
<br>
</div>3) Fix the {BMAP_LEFT_CONTIG,MAXEXTLEN,rtextsz} handling in<br>
xfs_bmap_add_extent_unwritten_real().<br>
<br>
It&#39;s possible that the BMAP_RIGHT_CONTIG case also needs similar<br>
fixing...<br>
<div class=3D"im"><br>
&gt; In my opinion, we should not worry about either of above, as this look=
s<br>
&gt; good method for allocation. =A0I can fix xfs_repair tool and make it a=
ware of<br>
&gt; these conditions (&quot;real-time extents&quot; shared by two or more =
extents).<br>
<br>
</div>Personally, I&#39;d prefer that 3) is done because RT extents should<=
br>
always be rtextsz aligned and sized, and the bmapbt should respect<br>
that requirement in all cases.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br><div>thanks Dave for prompt reply, I mea=
nt to implement option 2 as you explained (option 3). =A0I will start worki=
ng on it tomorrow. In the mean time, I also had =A0to put something in xfs_=
repair for the files which already exists on the disk. Would you guys willi=
ng to review/comment on that ?=A0</div>
<div><br></div><div>anand</div>

--20cf3079bab617f6bb04ca92a687--


--===============0664052266661761840==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0664052266661761840==--
