Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2F70B7F73
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 07:05:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F9EC8F8059
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 05:05:29 -0800 (PST)
Received: from mail-pa0-f41.google.com (mail-pa0-f41.google.com
	[209.85.220.41]) by cuda.sgi.com with ESMTP id idwkh2Hpwz7K6mvR
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 28 Jan 2015 05:05:23 -0800 (PST)
Received: by mail-pa0-f41.google.com with SMTP id kq14so25488706pab.0
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 05:05:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150128015757.GT16552@dastard>
References: <54c1c12e.230a460a.4729.11fc@mx.google.com>
	<20150128015757.GT16552@dastard>
Date: Wed, 28 Jan 2015 18:35:22 +0530
Message-ID: <CALJmpHP=vjz_ZY9sFpW8k2Y7TL+sz-WyjPeMoy4sM6XDTt8MTQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs_spaceman: Accounting for AGFL blocks
From: ADRS PICT <adrscube@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1155304059439018944=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

--===============1155304059439018944==
Content-Type: multipart/alternative; boundary=001a11c35ed82f6031050db606e6

--001a11c35ed82f6031050db606e6
Content-Type: text/plain; charset=UTF-8

On Wed, Jan 28, 2015 at 7:27 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Jan 23, 2015 at 09:04:00AM +0530, Dhruvesh Rathore wrote:
>> Here is the original discussion that Dave wrote for xfs_spaceman:
>>
>> http://oss.sgi.com/archives/xfs/2012-10/msg00363.html
>>
>> These patches were not posted and were just forward ported to a current
>> 3.18-rc7+ for-next XFS tree and were pushed to the fiemapfs branch in
Dave's
>> kernel tree at:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
>>
>> The original xfs_spaceman tool that Dave wrote is here:
>>
>> http://oss.sgi.com/archives/xfs/2012-10/msg00366.html
>>
>> Dave just updated it to the 3.2.2 code base and pushed it to the
>> spaceman branch in this tree:
>>
>> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>
> As per last patch, this is series description so it doesn't need to
> be repeated in every patch ;)
>

We will keep that in mind, while sending the updated patches. :)

> From here:
>
>> This xfs_spaceman utility previously failed to account for AGFL blocks.
>> Old output (Before changes).
>>
>> $ sudo xfs_spaceman -c "freesp" /media/xfs
>>    from      to extents  blocks    pct
>>    1024    2047       1    1262   0.04
>>    4096    8191       1    5126   0.15
>>    8192   16383       3   35344   1.05
>>   32768   65535       1   43989   1.31
>>  262144  524287       3 1334894  39.78
>>  524288  967428       2 1934840  57.66
>>
>> As you can see the AGFL blocks were unaccounted (4 per AG, and there
>> were 4 AGs in this filesystem).
>>
>> This patch is concerned with adding a new function which will walk the
free
>> extents in AGFL and account for these AGFL blocks, while file system
scanning.
>>
>> New output (After implementing this patch).
>>
>> $ uname -a
>> Linux dhruv-MacBookAir 3.18.0-rc7+ #3 SMP Thu Dec 25 15:29:59 IST 2014
x86_64 x86_64 x86_64 GNU/Linux
>> $ sudo xfs_spaceman -V
>> xfs_spaceman version 3.2.2
>> $ sudo xfs_spaceman -c "freesp" /media/xfs
>>    from      to extents  blocks    pct
>>       1       1      16      16   0.00
>>    1024    2047       1    1262   0.04
>>    4096    8191       1    5126   0.15
>>    8192   16383       3   35344   1.05
>>   32768   65535       1   43989   1.31
>>  262144  524287       3 1334894  39.78
>>  524288  967428       2 1934840  57.66
>
> to here, this is a good patch description. :)
>
>> Please do comment.
>
> No need to ask in each patch description - the series description if
> the place for that....
>

We will make a not of this too.

>> +
>> +/*
>> + * Walk the free extents in the AGFL (AG Free List) of each AG, and dump
>
> No need to explain what AGFL means - anyone reading the code already
> knows....
>
>> + * them all into the fieinfo.
>> + *
>> + * With a freshly made filesystem, 4 blocks are reserved immediately
after
>> + * the free space B+tree root blocks (blocks 4 to 7). As they are used
up
>
> The number of blocks is actually dependent on filesystem geometry,
> but again there isn't a need to describe the exact workings of the
> AGFL here.
>
>> + * additional blocks are reserved from the AG and added to the free list
>> + * array. A typical device will have space for 128 elements in the
array.
>> + * The actual size can be determined using XFS_AGFL_SIZE macro. The
array
>> + * is maintained as a circular list and active elements are pointed by
>> + * AGF's agf_flfirst, agf_fllast and agf_flcount values.
>
> Yup, you're describing the code, not /why/ the function exists.

Our bad, we will ensure that the comment, explains why the function is
needed.

>
> /*
>  * When we map free space we need to take into account the blocks
>  * that are indexed by the AGFL. There aren't found by walking the
>  * free space btrees, so we have to walk each AGFL to find them.
>  */
>
>> + */
>> +static int
>> +xfs_alloc_agfl_freespace_map(
>> +     struct xfs_buf          **agbp, /* buffer for a.g. freelist header
*/
>> +     struct xfs_btree_cur    *cur,
>> +     struct fiemap_extent_info *fieinfo,
>> +     xfs_agblock_t           sagbno,
>> +     xfs_agblock_t           eagbno)
>
> No need to pass the freespace btree cursor into this function,
> nor the agf buffer. What is required is the struct xfs_mount,
> the current agno and the agf structure. i.e.
> xfs_alloc_agfl_freespace_map(
>         struct xfs_mount        *mp,
>         struct xfs_agf          *agf,
>         struct fiemap_extent_info *fieinfo,
>         xfs_agnumber_t          agno,
>         xfs_agblock_t           sagbno,
>         xfs_agblock_t           eagbno)
>
>> +{
>> +     xfs_agf_t       *agf;           /* a.g. freespace structure */
>> +     xfs_buf_t       *agflbp;        /* buffer for a.g. freelist
structure */
>> +     __be32          *agfl_bno;      /* Reference to freelist block */
>> +     int             j;
>                 ^
>> +     int             index;
>            ^
>> +     int             error = 0;
>            ^
>
> Stray whitespace.
>
>> +
>> +     agf = XFS_BUF_TO_AGF(*agbp);
>> +     error = xfs_alloc_read_agfl(cur->bc_mp, NULL,
be32_to_cpu(agf->agf_seqno),
>> +                                 &agflbp);
>
>         error = xfs_alloc_read_agfl(mp, NULL, agno, &agflbp);
>
>> +     if (error)
>> +             return error;
>> +
>> +     agfl_bno = XFS_BUF_TO_AGFL_BNO(cur->bc_mp, agflbp);
>> +
>> +     index = be32_to_cpu(agf->agf_flfirst);
>> +
>> +     for(j=1 ; j<=be32_to_cpu(agf->agf_flcount); j++)
>> +        {
>
> formatting, and no need for j and index parameters.
>
>         for (i = be32_to_cpu(agf->agf_flfirst);
>              i < be32_to_cpu(agf->agf_fllast);) {
>         ....
>                 if (++i == XFS_AGFL_SIZE(mp))
>                         i = 0;
>         }
>
>> +      xfs_agblock_t  fbno;
>> +      xfs_extlen_t   flen;
>> +      xfs_daddr_t    dbno;
>> +      xfs_fileoff_t  dlen;
>> +      int            flags = 0;
>
> all the indenting in the function needs fixing.
>
>> +
>> +     /* Relative AG block number */
>> +      fbno = be32_to_cpu(agfl_bno[index]);
>> +     /* Each entry in the AGFL is a single entry i.e length is 1 block
*/
>> +      flen = 1;
>
> These can all be folded into the code below - no need for
> intermediate variables...
>
>> +
>> +     /*
>> +      * AGFL is maintained as a circular list. Following is needed
>> +      * to handle array wrapping correctly.
>> +      */
>> +         if( index == ( (XFS_AGFL_SIZE(cur->bc_mp))-1 ) )
>> +       index = 0;    /* First index of AGFL */
>> +         else
>> +          index++;   /* Next index in AGFL */
>
> This is handled by the above loop construct so can be ignored.
>> +
>> +     /*
>> +      * Use daddr format for all range/len calculations as that is
>> +      * the format the range/len variables are supplied in by
>> +      * userspace.
>> +      */
>> +      dbno = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno, fbno);
>> +      dlen = XFS_FSB_TO_BB(cur->bc_mp, flen);
>> +      error = -fiemap_fill_next_extent(fieinfo, BBTOB(dbno),
>> +                                       BBTOB(dbno), BBTOB(dlen), flags);
>
> This takes bytes as it's values, and we have AG block numbers and
> filesystem block lengths. so:
>
>
> and the entire loop becomes:
>
>         for (i = be32_to_cpu(agf->agf_flfirst);
>              i < be32_to_cpu(agf->agf_fllast);) {
>                 /*
>                  * Use daddr format for all range/len calculations as
that is
>                  * the format the range/len variables are supplied in by
>                  * userspace.
>                  */
>                 dbno = XFS_AGB_TO_DADDR(mp, agno,
be32_to_cpu(agfl_bno[i]));
>                 error = fiemap_fill_next_extent(fieinfo,
>                                                 BBTOB(dbno), BBTOB(dbno),
>                                                 XFS_FSB_TO_B(mp, 1),
flags);
>                 if (error)
>                         break;
>                 if (++i == XFS_AGFL_SIZE(mp))
>                         i = 0;
>         }
>         xfs_buf_relse(agflbp);
>         return error;
> }

We will incorporate the above mentioned changes, and send the updated
patch at the earliest.

> Hmmm - I think something is still missing - what are the sagbno and
> eagbno parameters supposed to do?

Actually the parameters sagbno and eagbno are not needed in this
function and can be excluded.

> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

Thank you for the detailed feedback. We will be sending the updated
patches at the earliest.

Regards,
A-DRS

--001a11c35ed82f6031050db606e6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br><br>On Wed, Jan 28, 2015 at=
 7:27 AM, Dave Chinner &lt;<a href=3D"mailto:david@fromorbit.com">david@fro=
morbit.com</a>&gt; wrote:<br>&gt; On Fri, Jan 23, 2015 at 09:04:00AM +0530,=
 Dhruvesh Rathore wrote:<br>&gt;&gt; Here is the original discussion that D=
ave wrote for xfs_spaceman:<br>&gt;&gt;<br>&gt;&gt; <a href=3D"http://oss.s=
gi.com/archives/xfs/2012-10/msg00363.html">http://oss.sgi.com/archives/xfs/=
2012-10/msg00363.html</a><br>&gt;&gt;<br>&gt;&gt; These patches were not po=
sted and were just forward ported to a current<br>&gt;&gt; 3.18-rc7+ for-ne=
xt XFS tree and were pushed to the fiemapfs branch in Dave&#39;s<br>&gt;&gt=
; kernel tree at:<br>&gt;&gt;<br>&gt;&gt; git://<a href=3D"http://git.kerne=
l.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git">git.kernel.org/pub/scm/li=
nux/kernel/git/dgc/linux-xfs.git</a><br>&gt;&gt;<br>&gt;&gt; The original x=
fs_spaceman tool that Dave wrote is here:<br>&gt;&gt;<br>&gt;&gt; <a href=
=3D"http://oss.sgi.com/archives/xfs/2012-10/msg00366.html">http://oss.sgi.c=
om/archives/xfs/2012-10/msg00366.html</a><br>&gt;&gt;<br>&gt;&gt; Dave just=
 updated it to the 3.2.2 code base and pushed it to the<br>&gt;&gt; spacema=
n branch in this tree:<br>&gt;&gt;<br>&gt;&gt; git://<a href=3D"http://git.=
kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git">git.kernel.org/pub/scm/fs/xfs/x=
fsprogs-dev.git</a><br>&gt;<br>&gt; As per last patch, this is series descr=
iption so it doesn&#39;t need to<br>&gt; be repeated in every patch ;)<br>&=
gt;<br><br>We will keep that in mind, while sending the updated patches. :)=
<br><div><br></div><div>&gt; From here:<br>&gt;<br>&gt;&gt; This xfs_spacem=
an utility previously failed to account for AGFL blocks.<br>&gt;&gt; Old ou=
tput (Before changes).<br>&gt;&gt;<br>&gt;&gt; $ sudo xfs_spaceman -c &quot=
;freesp&quot; /media/xfs<br>&gt;&gt; =C2=A0 =C2=A0from =C2=A0 =C2=A0 =C2=A0=
to extents =C2=A0blocks =C2=A0 =C2=A0pct<br>&gt;&gt; =C2=A0 =C2=A01024 =C2=
=A0 =C2=A02047 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A01262 =C2=A0 0.04<br>&gt;=
&gt; =C2=A0 =C2=A04096 =C2=A0 =C2=A08191 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=
=A05126 =C2=A0 0.15<br>&gt;&gt; =C2=A0 =C2=A08192 =C2=A0 16383 =C2=A0 =C2=
=A0 =C2=A0 3 =C2=A0 35344 =C2=A0 1.05<br>&gt;&gt; =C2=A0 32768 =C2=A0 65535=
 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 43989 =C2=A0 1.31<br>&gt;&gt; =C2=A0262144 =
=C2=A0524287 =C2=A0 =C2=A0 =C2=A0 3 1334894 =C2=A039.78<br>&gt;&gt; =C2=A05=
24288 =C2=A0967428 =C2=A0 =C2=A0 =C2=A0 2 1934840 =C2=A057.66<br>&gt;&gt;<b=
r>&gt;&gt; As you can see the AGFL blocks were unaccounted (4 per AG, and t=
here<br>&gt;&gt; were 4 AGs in this filesystem).<br>&gt;&gt;<br>&gt;&gt; Th=
is patch is concerned with adding a new function which will walk the free<b=
r>&gt;&gt; extents in AGFL and account for these AGFL blocks, while file sy=
stem scanning.<br>&gt;&gt;<br>&gt;&gt; New output (After implementing this =
patch).<br>&gt;&gt;<br>&gt;&gt; $ uname -a<br>&gt;&gt; Linux dhruv-MacBookA=
ir 3.18.0-rc7+ #3 SMP Thu Dec 25 15:29:59 IST 2014 x86_64 x86_64 x86_64 GNU=
/Linux<br>&gt;&gt; $ sudo xfs_spaceman -V<br>&gt;&gt; xfs_spaceman version =
3.2.2<br>&gt;&gt; $ sudo xfs_spaceman -c &quot;freesp&quot; /media/xfs<br>&=
gt;&gt; =C2=A0 =C2=A0from =C2=A0 =C2=A0 =C2=A0to extents =C2=A0blocks =C2=
=A0 =C2=A0pct<br>&gt;&gt; =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 1 =C2=
=A0 =C2=A0 =C2=A016 =C2=A0 =C2=A0 =C2=A016 =C2=A0 0.00<br>&gt;&gt; =C2=A0 =
=C2=A01024 =C2=A0 =C2=A02047 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A01262 =C2=
=A0 0.04<br>&gt;&gt; =C2=A0 =C2=A04096 =C2=A0 =C2=A08191 =C2=A0 =C2=A0 =C2=
=A0 1 =C2=A0 =C2=A05126 =C2=A0 0.15<br>&gt;&gt; =C2=A0 =C2=A08192 =C2=A0 16=
383 =C2=A0 =C2=A0 =C2=A0 3 =C2=A0 35344 =C2=A0 1.05<br>&gt;&gt; =C2=A0 3276=
8 =C2=A0 65535 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 43989 =C2=A0 1.31<br>&gt;&gt; =
=C2=A0262144 =C2=A0524287 =C2=A0 =C2=A0 =C2=A0 3 1334894 =C2=A039.78<br>&gt=
;&gt; =C2=A0524288 =C2=A0967428 =C2=A0 =C2=A0 =C2=A0 2 1934840 =C2=A057.66<=
br>&gt;<br>&gt; to here, this is a good patch description. :)<br>&gt;<br>&g=
t;&gt; Please do comment.<br>&gt;<br>&gt; No need to ask in each patch desc=
ription - the series description if<br>&gt; the place for that....<br>&gt;<=
/div><div><br></div><div>We will make a not of this too.</div><div><br>&gt;=
&gt; +<br>&gt;&gt; +/*<br>&gt;&gt; + * Walk the free extents in the AGFL (A=
G Free List) of each AG, and dump<br>&gt;<br>&gt; No need to explain what A=
GFL means - anyone reading the code already<br>&gt; knows....<br>&gt;<br>&g=
t;&gt; + * them all into the fieinfo.<br>&gt;&gt; + *<br>&gt;&gt; + * With =
a freshly made filesystem, 4 blocks are reserved immediately after<br>&gt;&=
gt; + * the free space B+tree root blocks (blocks 4 to 7). As they are used=
 up<br>&gt;<br>&gt; The number of blocks is actually dependent on filesyste=
m geometry,<br>&gt; but again there isn&#39;t a need to describe the exact =
workings of the<br>&gt; AGFL here.<br>&gt;<br>&gt;&gt; + * additional block=
s are reserved from the AG and added to the free list<br>&gt;&gt; + * array=
. A typical device will have space for 128 elements in the array.<br>&gt;&g=
t; + * The actual size can be determined using XFS_AGFL_SIZE macro. The arr=
ay<br>&gt;&gt; + * is maintained as a circular list and active elements are=
 pointed by<br>&gt;&gt; + * AGF&#39;s agf_flfirst, agf_fllast and agf_flcou=
nt values.<br>&gt;<br>&gt; Yup, you&#39;re describing the code, not /why/ t=
he function exists.</div><div><br></div><div>Our bad, we will ensure that t=
he comment, explains why the function is needed.</div><div><br>&gt;<br>&gt;=
 /*<br>&gt; =C2=A0* When we map free space we need to take into account the=
 blocks<br>&gt; =C2=A0* that are indexed by the AGFL. There aren&#39;t foun=
d by walking the<br>&gt; =C2=A0* free space btrees, so we have to walk each=
 AGFL to find them.<br>&gt; =C2=A0*/<br>&gt;<br>&gt;&gt; + */<br>&gt;&gt; +=
static int<br>&gt;&gt; +xfs_alloc_agfl_freespace_map(<br>&gt;&gt; + =C2=A0 =
=C2=A0 struct xfs_buf =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0**agbp, /* buffer f=
or a.g. freelist header */<br>&gt;&gt; + =C2=A0 =C2=A0 struct xfs_btree_cur=
 =C2=A0 =C2=A0*cur,<br>&gt;&gt; + =C2=A0 =C2=A0 struct fiemap_extent_info *=
fieinfo,<br>&gt;&gt; + =C2=A0 =C2=A0 xfs_agblock_t =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 sagbno,<br>&gt;&gt; + =C2=A0 =C2=A0 xfs_agblock_t =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 eagbno)<br>&gt;<br>&gt; No need to pass the freespace =
btree cursor into this function,<br>&gt; nor the agf buffer. What is requir=
ed is the struct xfs_mount,<br>&gt; the current agno and the agf structure.=
 i.e.<br>&gt; xfs_alloc_agfl_freespace_map(<br>&gt; =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 struct xfs_mount =C2=A0 =C2=A0 =C2=A0 =C2=A0*mp,<br>&gt; =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 struct xfs_agf =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*agf,<br=
>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct fiemap_extent_info *fieinfo,<br>&g=
t; =C2=A0 =C2=A0 =C2=A0 =C2=A0 xfs_agnumber_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0agno,<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 xfs_agblock_t =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 sagbno,<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 xfs_agblo=
ck_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 eagbno)<br>&gt;<br>&gt;&gt; +{<br>&=
gt;&gt; + =C2=A0 =C2=A0 xfs_agf_t =C2=A0 =C2=A0 =C2=A0 *agf; =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 /* a.g. freespace structure */<br>&gt;&gt; + =C2=A0 =
=C2=A0 xfs_buf_t =C2=A0 =C2=A0 =C2=A0 *agflbp; =C2=A0 =C2=A0 =C2=A0 =C2=A0/=
* buffer for a.g. freelist structure */<br>&gt;&gt; + =C2=A0 =C2=A0 __be32 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*agfl_bno; =C2=A0 =C2=A0 =C2=A0/* Referen=
ce to freelist block */<br>&gt;&gt; + =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 j;<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 ^<br>&gt;&gt; + =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 index;<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0^<br>&gt;&gt; + =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 error =3D 0;<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^<br>&gt;=
<br>&gt; Stray whitespace.<br>&gt;<br>&gt;&gt; +<br>&gt;&gt; + =C2=A0 =C2=
=A0 agf =3D XFS_BUF_TO_AGF(*agbp);<br>&gt;&gt; + =C2=A0 =C2=A0 error =3D xf=
s_alloc_read_agfl(cur-&gt;bc_mp, NULL, be32_to_cpu(agf-&gt;agf_seqno),<br>&=
gt;&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;agflbp);<br>&gt;<br>&=
gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 error =3D xfs_alloc_read_agfl(mp, NULL, agn=
o, &amp;agflbp);<br>&gt;<br>&gt;&gt; + =C2=A0 =C2=A0 if (error)<br>&gt;&gt;=
 + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return error;<br>&gt;&gt; +<br=
>&gt;&gt; + =C2=A0 =C2=A0 agfl_bno =3D XFS_BUF_TO_AGFL_BNO(cur-&gt;bc_mp, a=
gflbp);<br>&gt;&gt; +<br>&gt;&gt; + =C2=A0 =C2=A0 index =3D be32_to_cpu(agf=
-&gt;agf_flfirst);<br>&gt;&gt; +<br>&gt;&gt; + =C2=A0 =C2=A0 for(j=3D1 ; j&=
lt;=3Dbe32_to_cpu(agf-&gt;agf_flcount); j++)<br>&gt;&gt; + =C2=A0 =C2=A0 =
=C2=A0 =C2=A0{<br>&gt;<br>&gt; formatting, and no need for j and index para=
meters.<br>&gt;<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D be32_to_cpu(=
agf-&gt;agf_flfirst);<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0i &lt; be32_to_cpu(agf-&gt;agf_fllast);) {<br>&gt; =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 ....<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 if (++i =3D=3D XFS_AGFL_SIZE(mp))<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i =3D 0;<br>&gt; =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 }<br>&gt;<br>&gt;&gt; + =C2=A0 =C2=A0 =C2=A0xfs_ag=
block_t =C2=A0fbno;<br>&gt;&gt; + =C2=A0 =C2=A0 =C2=A0xfs_extlen_t =C2=A0 f=
len;<br>&gt;&gt; + =C2=A0 =C2=A0 =C2=A0xfs_daddr_t =C2=A0 =C2=A0dbno;<br>&g=
t;&gt; + =C2=A0 =C2=A0 =C2=A0xfs_fileoff_t =C2=A0dlen;<br>&gt;&gt; + =C2=A0=
 =C2=A0 =C2=A0int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0flags =3D 0;<br>=
&gt;<br>&gt; all the indenting in the function needs fixing.<br>&gt;<br>&gt=
;&gt; +<br>&gt;&gt; + =C2=A0 =C2=A0 /* Relative AG block number */<br>&gt;&=
gt; + =C2=A0 =C2=A0 =C2=A0fbno =3D be32_to_cpu(agfl_bno[index]);<br>&gt;&gt=
; + =C2=A0 =C2=A0 /* Each entry in the AGFL is a single entry i.e length is=
 1 block */<br>&gt;&gt; + =C2=A0 =C2=A0 =C2=A0flen =3D 1;<br>&gt;<br>&gt; T=
hese can all be folded into the code below - no need for<br>&gt; intermedia=
te variables...<br>&gt;<br>&gt;&gt; +<br>&gt;&gt; + =C2=A0 =C2=A0 /*<br>&gt=
;&gt; + =C2=A0 =C2=A0 =C2=A0* AGFL is maintained as a circular list. Follow=
ing is needed<br>&gt;&gt; + =C2=A0 =C2=A0 =C2=A0* to handle array wrapping =
correctly.<br>&gt;&gt; + =C2=A0 =C2=A0 =C2=A0*/<br>&gt;&gt; + =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 if( index =3D=3D ( (XFS_AGFL_SIZE(cur-&gt;bc_mp))-1 ) )<br>&=
gt;&gt; + =C2=A0 =C2=A0 =C2=A0 index =3D 0; =C2=A0 =C2=A0/* First index of =
AGFL */<br>&gt;&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 else<br>&gt;&gt; + =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0index++; =C2=A0 /* Next index in AGFL */<br>&gt=
;<br>&gt; This is handled by the above loop construct so can be ignored.<br=
>&gt;&gt; +<br>&gt;&gt; + =C2=A0 =C2=A0 /*<br>&gt;&gt; + =C2=A0 =C2=A0 =C2=
=A0* Use daddr format for all range/len calculations as that is<br>&gt;&gt;=
 + =C2=A0 =C2=A0 =C2=A0* the format the range/len variables are supplied in=
 by<br>&gt;&gt; + =C2=A0 =C2=A0 =C2=A0* userspace.<br>&gt;&gt; + =C2=A0 =C2=
=A0 =C2=A0*/<br>&gt;&gt; + =C2=A0 =C2=A0 =C2=A0dbno =3D XFS_AGB_TO_DADDR(cu=
r-&gt;bc_mp, cur-&gt;bc_private.a.agno, fbno);<br>&gt;&gt; + =C2=A0 =C2=A0 =
=C2=A0dlen =3D XFS_FSB_TO_BB(cur-&gt;bc_mp, flen);<br>&gt;&gt; + =C2=A0 =C2=
=A0 =C2=A0error =3D -fiemap_fill_next_extent(fieinfo, BBTOB(dbno),<br>&gt;&=
gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BBTOB(dbno)=
, BBTOB(dlen), flags);<br>&gt;<br>&gt; This takes bytes as it&#39;s values,=
 and we have AG block numbers and<br>&gt; filesystem block lengths. so:<br>=
&gt;<br>&gt;<br>&gt; and the entire loop becomes:<br>&gt;<br>&gt; =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 for (i =3D be32_to_cpu(agf-&gt;agf_flfirst);<br>&gt; =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i &lt; be32_to_cpu(agf-&gt;=
agf_fllast);) {<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 /*<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0* Use daddr format for all range/len calculations as that is<br>&gt; =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* the format =
the range/len variables are supplied in by<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* userspace.<br>&gt; =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>&gt; =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dbno =3D XFS_AGB_TO_DADDR(mp, agn=
o, be32_to_cpu(agfl_bno[i]));<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 error =3D fiemap_fill_next_extent(fieinfo,<br>&gt; =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 BBTOB(dbno), BBTOB(dbno),<br>&gt; =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 X=
FS_FSB_TO_B(mp, 1), flags);<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 if (error)<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>&gt; =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (++i =3D=3D XFS_AGFL_SIZE(mp))=
<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 i =3D 0;<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>&gt; =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 xfs_buf_relse(agflbp);<br>&gt; =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 return error;<br>&gt; }<br><br>We will incorporate the above =
mentioned changes, and send the updated</div><div>patch at the earliest.<br=
><br>&gt; Hmmm - I think something is still missing - what are the sagbno a=
nd<br>&gt; eagbno parameters supposed to do?<br><br>Actually the parameters=
 sagbno and eagbno are not needed in this=C2=A0</div><div>function and can =
be excluded.<br><br>&gt; Cheers,<br>&gt;<br>&gt; Dave.<br>&gt; --<br>&gt; D=
ave Chinner<br>&gt; <a href=3D"mailto:david@fromorbit.com">david@fromorbit.=
com</a><br><br></div><div>Thank you for the detailed feedback. We will be s=
ending the updated</div><div>patches at the earliest.</div><div><br></div><=
div>Regards,</div><div>A-DRS</div><div><br></div></div></div>

--001a11c35ed82f6031050db606e6--


--===============1155304059439018944==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1155304059439018944==--
