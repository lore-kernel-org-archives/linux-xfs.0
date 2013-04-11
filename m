Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 02EC67FE2
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 01:34:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E28E7304032
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 23:34:35 -0700 (PDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	PNuQHkpA7hQU4V7W (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Apr 2013 23:34:34 -0700 (PDT)
Received: by mail-wi0-f173.google.com with SMTP id ez12so191547wid.12
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 23:34:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130411062515.GH10481@dastard>
References: <CAPaMSRCGSyhmnjrXpFFkEpmKrjsHqLn0kJ1xLGyf-WZosV7mmQ@mail.gmail.com>
	<20130411062515.GH10481@dastard>
Date: Thu, 11 Apr 2013 14:34:32 +0800
Message-ID: <CAPaMSRCq0f+GqTbRRCXBFUDdtmpBx=VjBaOLpdDytXunL9dfmQ@mail.gmail.com>
Subject: Re: xfs_repair breaks with assertion
From: Victor K <kvic45@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7751519393382206433=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============7751519393382206433==
Content-Type: multipart/alternative; boundary=f46d043c094ebe8cca04da0ffa16

--f46d043c094ebe8cca04da0ffa16
Content-Type: text/plain; charset=UTF-8

> Running xfs_repair /dev/md1 the first time resulted in suggestion to

> > mount/unmount to replay log, but mounting would not work. After running
> > xfs_repair -v -L -P /dev/md1 this happens:
> > (lots of output on stderr, moving to Phase 3, then more output - not sure
> > if it is relevant, the log file is ~170Mb in size), then stops and prints
> > the only line on stdout:
>
> Oh dear. A log file that big indicates that something *bad* has
> happened to the array. i.e that it has most likely been put back
> together wrong.
>
> Before going any further with xfs_repair, please verify that the
> array has been put back together correctly....
>
>
The raid array did not suffer, at least, not according to mdadm; it is now
happily recovering the one disk that officially failed, but the whole thing
assembled without a problem
There was a similar crash several weeks ago on this same array, but had
ext4 system back then.
I was able to save some of the latest stuff, and decided to move to xfs as
something more reliable.
I suspect now I should also had replaced the disk controller then.


> > xfs_repair: dinode.c:768: process_bmbt_reclist_int: Assertion `i <
> > *numrecs' failed.
> > Aborted
> >
> > After inserting a printf before the assert, I get the following:
> >
> > i = 0, *numrecs = -570425343  for printf( "%d, %d")
> > or
> > i= 0, *numrecs = 3724541953  for printf("%ld, %ld) - makes me wonder if
> > it's signed/unsigned int related
>
> numrecs is way out of the normal range, so that's probably what is
> triggering it.
>
> i.e this in process_exinode():
>
>         numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
>
> is where the bad number is coming from, and that implies a corrupted
> inode. it's a __be32 on disk, the kernel considers it a xfs_extnum_t
> in memory which is a int32_t because:
>
> #define NULLEXTNUM      ((xfs_extnum_t)-1)
>
> So, negative numbers on disk are invalid.
> ....
>
> The patch below should fix the assert failure.
>
>
I'll try it - don't really have other options at the moment


> > If I try now (after running xfs_repair -L) to mount the fs read-only, it
> > mounts but says some directories have structures that need cleaning, so
> the
> > dirs are inaccessible.
> >
> > Any suggestion on how to possibly fix this?
>
> I suspect you've damaged it beyond repair now.
>
> If the array was put back together incorrectly in the first place
> (which is likely given the damage being reported), then
> you've made the problem a whole lot worse by writing to it in an
> attempt to repair it.
>
> I'd suggest that you make sure the array is correctly
> repaired/ordered/reocvered before doing anything else, then
> running xfs_repair on what is left and hoping for the best. Even after
> repair is finished, you'll need to go through all the data with a
> fine toothed comb to work out what has been lost, corrupted or
> overwritten with zeros or other stuff.
>
> I suspect you'll be reaching for the backup tapes long before you
> get that far, though...
>


Well, we'll see how it goes.

Thanks for the patch and the quick reply!

Sincerely,
Victor


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
>
> xfs_repair: validate on-disk extent count better
>
> From: Dave Chinner <dchinner@redhat.com>
>
> When scanning a btree format inode, we trust the extent count to be
> in range.  However, values of the range 2^31 <= cnt < 2^32 are
> invalid and can cause problems with signed range checks. This
> results in assert failures which validating the extent count such
> as:
>
> xfs_repair: dinode.c:768: process_bmbt_reclist_int: Assertion `i <
> *numrecs' failed.
>
> Validate the extent count is at least within the positive range of a
> singed 32 bit integer before using it.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/dinode.c |   25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 5a2da39..239bb7b 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1293,7 +1293,7 @@ process_exinode(
>         xfs_bmbt_rec_t          *rp;
>         xfs_dfiloff_t           first_key;
>         xfs_dfiloff_t           last_key;
> -       int                     numrecs;
> +       int32_t                 numrecs;
>         int                     ret;
>
>         lino = XFS_AGINO_TO_INO(mp, agno, ino);
> @@ -1302,6 +1302,15 @@ process_exinode(
>         numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
>
>         /*
> +        * We've already decided on the maximum number of extents on the
> inode,
> +        * and numrecs may be corrupt. Hence make sure we only allow
> numrecs to
> +        * be in the range of valid on-disk numbers, which is:
> +        *      0 < numrecs < 2^31 - 1
> +        */
> +       if (numrecs < 0)
> +               numrecs = *nex;
> +
> +       /*
>          * XXX - if we were going to fix up the btree record,
>          * we'd do it right here.  For now, if there's a problem,
>          * we'll bail out and presumably clear the inode.
> @@ -2038,11 +2047,23 @@ process_inode_data_fork(
>  {
>         xfs_ino_t       lino = XFS_AGINO_TO_INO(mp, agno, ino);
>         int             err = 0;
> +       int             nex;
> +
> +       /*
> +        * extent count on disk is only valid for positive values. The
> kernel
> +        * uses negative values in memory. hence if we see negative numbers
> +        * here, trash it!
> +        */
> +       nex = be32_to_cpu(dino->di_nextents);
> +       if (nex < 0)
> +               *nextents = 1;
> +       else
> +               *nextents = nex;
>
> -       *nextents = be32_to_cpu(dino->di_nextents);
>         if (*nextents > be64_to_cpu(dino->di_nblocks))
>                 *nextents = 1;
>
> +
>         if (dino->di_format != XFS_DINODE_FMT_LOCAL && type !=
> XR_INO_RTDATA)
>                 *dblkmap = blkmap_alloc(*nextents, XFS_DATA_FORK);
>         *nextents = 0;
>

--f46d043c094ebe8cca04da0ffa16
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"color:rgb(80,0,80)">&gt; Running xfs_repair=
 /dev/md1 the first time resulted in suggestion to</span><br><div class=3D"=
gmail_extra"><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im">
&gt; mount/unmount to replay log, but mounting would not work. After runnin=
g<br>
&gt; xfs_repair -v -L -P /dev/md1 this happens:<br>
&gt; (lots of output on stderr, moving to Phase 3, then more output - not s=
ure<br>
&gt; if it is relevant, the log file is ~170Mb in size), then stops and pri=
nts<br>
&gt; the only line on stdout:<br>
<br>
</div>Oh dear. A log file that big indicates that something *bad* has<br>
happened to the array. i.e that it has most likely been put back<br>
together wrong.<br>
<br>
Before going any further with xfs_repair, please verify that the<br>
array has been put back together correctly....<br>
<div class=3D"im"><br></div></blockquote><div><br></div><div style>The raid=
 array did not suffer, at least, not according to mdadm; it is now happily =
recovering the one disk that officially failed, but the whole thing assembl=
ed without a problem</div>
<div style>There was a similar crash several weeks ago on this same array, =
but had ext4 system back then.</div><div style>I was able to save some of t=
he latest stuff, and decided to move to xfs as something more reliable.</di=
v>
<div style>I suspect now I should also had replaced the disk controller the=
n.</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"im">
&gt; xfs_repair: dinode.c:768: process_bmbt_reclist_int: Assertion `i &lt;<=
br>
&gt; *numrecs&#39; failed.<br>
&gt; Aborted<br>
&gt;<br>
&gt; After inserting a printf before the assert, I get the following:<br>
&gt;<br>
&gt; i =3D 0, *numrecs =3D -570425343 =C2=A0for printf( &quot;%d, %d&quot;)=
<br>
&gt; or<br>
&gt; i=3D 0, *numrecs =3D 3724541953 =C2=A0for printf(&quot;%ld, %ld) - mak=
es me wonder if<br>
&gt; it&#39;s signed/unsigned int related<br>
<br>
</div>numrecs is way out of the normal range, so that&#39;s probably what i=
s<br>
triggering it.<br>
<br>
i.e this in process_exinode():<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 numrecs =3D XFS_DFORK_NEXTENTS(dip, whichfork);=
<br>
<br>
is where the bad number is coming from, and that implies a corrupted<br>
inode. it&#39;s a __be32 on disk, the kernel considers it a xfs_extnum_t<br=
>
in memory which is a int32_t because:<br>
<br>
#define NULLEXTNUM =C2=A0 =C2=A0 =C2=A0((xfs_extnum_t)-1)<br>
<br>
So, negative numbers on disk are invalid.<br>
....<br>
<br>
The patch below should fix the assert failure.<br>
<div class=3D"im"><br></div></blockquote><div><br></div><div style>I&#39;ll=
 try it - don&#39;t really have other options at the moment</div><div style=
>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;b=
order-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im">
&gt; If I try now (after running xfs_repair -L) to mount the fs read-only, =
it<br>
&gt; mounts but says some directories have structures that need cleaning, s=
o the<br>
&gt; dirs are inaccessible.<br>
&gt;<br>
&gt; Any suggestion on how to possibly fix this?<br>
<br>
</div>I suspect you&#39;ve damaged it beyond repair now.<br>
<br>
If the array was put back together incorrectly in the first place<br>
(which is likely given the damage being reported), then<br>
you&#39;ve made the problem a whole lot worse by writing to it in an<br>
attempt to repair it.<br>
<br>
I&#39;d suggest that you make sure the array is correctly<br>
repaired/ordered/reocvered before doing anything else, then<br>
running xfs_repair on what is left and hoping for the best. Even after<br>
repair is finished, you&#39;ll need to go through all the data with a<br>
fine toothed comb to work out what has been lost, corrupted or<br>
overwritten with zeros or other stuff.<br>
<br>
I suspect you&#39;ll be reaching for the backup tapes long before you<br>
get that far, though...<br></blockquote><div><br></div><div><br></div><div =
style>Well, we&#39;ll see how it goes.</div><div style><br></div><div style=
>Thanks for the patch and the quick reply!</div><div style><br></div><div s=
tyle>
Sincerely,</div><div style>Victor</div><div style>=C2=A0</div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">
<br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
<br>
<br>
xfs_repair: validate on-disk extent count better<br>
<br>
From: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchinner@redh=
at.com</a>&gt;<br>
<br>
When scanning a btree format inode, we trust the extent count to be<br>
in range. =C2=A0However, values of the range 2^31 &lt;=3D cnt &lt; 2^32 are=
<br>
invalid and can cause problems with signed range checks. This<br>
results in assert failures which validating the extent count such<br>
as:<br>
<div class=3D"im"><br>
xfs_repair: dinode.c:768: process_bmbt_reclist_int: Assertion `i &lt; *numr=
ecs&#39; failed.<br>
<br>
</div>Validate the extent count is at least within the positive range of a<=
br>
singed 32 bit integer before using it.<br>
<br>
Signed-off-by: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchi=
nner@redhat.com</a>&gt;<br>
---<br>
=C2=A0repair/dinode.c | =C2=A0 25 +++++++++++++++++++++++--<br>
=C2=A01 file changed, 23 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/repair/dinode.c b/repair/dinode.c<br>
index 5a2da39..239bb7b 100644<br>
--- a/repair/dinode.c<br>
+++ b/repair/dinode.c<br>
@@ -1293,7 +1293,7 @@ process_exinode(<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 xfs_bmbt_rec_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0*rp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 xfs_dfiloff_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 first_key;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 xfs_dfiloff_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 last_key;<br>
- =C2=A0 =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 numrecs;<br>
+ =C2=A0 =C2=A0 =C2=A0 int32_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 numrecs;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ret;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 lino =3D XFS_AGINO_TO_INO(mp, agno, ino);<br>
@@ -1302,6 +1302,15 @@ process_exinode(<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 numrecs =3D XFS_DFORK_NEXTENTS(dip, whichfork);=
<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* We&#39;ve already decided on the maximum num=
ber of extents on the inode,<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* and numrecs may be corrupt. Hence make sure =
we only allow numrecs to<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* be in the range of valid on-disk numbers, wh=
ich is:<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0 =C2=A0 =C2=A00 &lt; numrecs &lt; 2^31=
 - 1<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
+ =C2=A0 =C2=A0 =C2=A0 if (numrecs &lt; 0)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 numrecs =3D *nex;<br>
+<br>
+ =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* XXX - if we were going to fix up the bt=
ree record,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* we&#39;d do it right here. =C2=A0For no=
w, if there&#39;s a problem,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* we&#39;ll bail out and presumably clear=
 the inode.<br>
@@ -2038,11 +2047,23 @@ process_inode_data_fork(<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 xfs_ino_t =C2=A0 =C2=A0 =C2=A0 lino =3D XFS_AGI=
NO_TO_INO(mp, agno, ino);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 e=
rr =3D 0;<br>
+ =C2=A0 =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nex;<b=
r>
+<br>
+ =C2=A0 =C2=A0 =C2=A0 /*<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* extent count on disk is only valid for posit=
ive values. The kernel<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* uses negative values in memory. hence if we =
see negative numbers<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0* here, trash it!<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
+ =C2=A0 =C2=A0 =C2=A0 nex =3D be32_to_cpu(dino-&gt;di_nextents);<br>
+ =C2=A0 =C2=A0 =C2=A0 if (nex &lt; 0)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *nextents =3D 1;<br>
+ =C2=A0 =C2=A0 =C2=A0 else<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *nextents =3D nex;<br>
<br>
- =C2=A0 =C2=A0 =C2=A0 *nextents =3D be32_to_cpu(dino-&gt;di_nextents);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (*nextents &gt; be64_to_cpu(dino-&gt;di_nblo=
cks))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *nextents =3D 1;<br=
>
<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dino-&gt;di_format !=3D XFS_DINODE_FMT_LOCA=
L &amp;&amp; type !=3D XR_INO_RTDATA)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *dblkmap =3D blkmap=
_alloc(*nextents, XFS_DATA_FORK);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *nextents =3D 0;<br>
</blockquote></div><br></div></div>

--f46d043c094ebe8cca04da0ffa16--


--===============7751519393382206433==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7751519393382206433==--
