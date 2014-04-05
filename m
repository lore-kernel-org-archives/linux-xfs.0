Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BBC867F87
	for <xfs@oss.sgi.com>; Sat,  5 Apr 2014 13:20:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7CE758F804C
	for <xfs@oss.sgi.com>; Sat,  5 Apr 2014 11:19:57 -0700 (PDT)
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	LnSDGo0S4hBtjKUw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 05 Apr 2014 11:19:54 -0700 (PDT)
Received: by mail-lb0-f181.google.com with SMTP id c11so3400599lbj.26
	for <xfs@oss.sgi.com>; Sat, 05 Apr 2014 11:19:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140402044749.GK17603@dastard>
References: <CABHf-sxmxmM0+WVzvGGJqKrrGngm0qrGTsYDnEmUEf+GJ_pK8A@mail.gmail.com>
	<20140401204215.GG17603@dastard>
	<CABHf-sxeACnsSoJszM8Xan-VcXLkLdrY7cBM9=FCAxdMBaQohA@mail.gmail.com>
	<20140402044749.GK17603@dastard>
Date: Sat, 5 Apr 2014 14:19:53 -0400
Message-ID: <CABHf-sx3H2=R72gFZik3QhygiF4VhUMXGt1VPw2AaXoXMcz8OQ@mail.gmail.com>
Subject: Re: xfs: invalid requests to request_fn from xfs_repair
From: Jamie Pocas <pocas.jamie@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6135353133968266277=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6135353133968266277==
Content-Type: multipart/alternative; boundary=001a113437fc42962b04f64fae87

--001a113437fc42962b04f64fae87
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Apr 2, 2014 at 12:47 AM, Dave Chinner <david@fromorbit.com> wrote:

> > > > While iterating through segments in rq_for_each_segment(), for some
> > > > requests I am seeing some odd behavior.
> > > >
> > > > segment 0: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 903
> // Ok,
> > > > this looks normal
> > > > segment 1: iter.bio->bi_sector = 1023, blk_rq_cur_sectors(rq) = 7 //
> > > > Whoah... this doesn't look right to me
> > >
> > > Seems fine to me. There's absolutely no reason two separate IOs
> > > can't be sub-page sector aligned or discontiguous given the above
> > > configuration. If that's what the getblocks callback returned to the
> > > DIO layer, then that's what you're going to see in the bios...
> > >
> > >
> > I guess my assumption that sectors would be adjacent was invalid, but
> this
> > is what I have read in ldd3 and other books and seen in some driver
> > examples. So I apologize for my folly and it's another lesson in not
> > believing everything you see on the net. The back half of my driver is
> > really optimized for transferring a single contiguous lba & transfer
> length
> > pair (ala SCSI WRITE 16 for example). However in desperation, I had
> changed
> > the driver to support requests like this (with disjoint sector ranges)
> but
> > it still seemed odd to me that occasionally some requests would even have
> > multiple segments that would *write* the same sectors/lengths. For
> example
> > I also see requests like the following.
> >
> > Given: rq_data_dir(rq) == 1 (i.e. a write)
> > segment   0: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    // Ok
> > segment   1: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    //
> > Again?
> > segment   2: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    //
> Yet
> > again?
> > segment   3: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    //
> > Really?
> > ...
> > segment 126: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    //
> > What's going on?
> > // Reminder: segment limit is 128
> > segment 127: iter.bio->bi_sector = 1023, blk_rq_cur_sectors(rq) = 1 //
> > Haha, bet you though I was going to say sector = 0!
>
> That really looks to me like a bug in whatever is building that iter
> structure. It looks like there's an off-by-one on each page (should
> be 8 sectors not 7) and the bi_sector is not being set correctly to
> the sector offset of the bio within the IO. i.e. for a contiguous
> IO it should look something like:
>
> segment   0: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 8
> segment   1: iter.bio->bi_sector = 8, blk_rq_cur_sectors(rq) = 8
> segment   2: iter.bio->bi_sector = 16, blk_rq_cur_sectors(rq) = 8
> ....
> segment 127: iter.bio->bi_sector = 1016, blk_rq_cur_sectors(rq) = 8
>
> I highly doubt the direct IO code is doing something wrong, because
> a mapping bug like that would show up everywhere and not just in your
> special driver....
>
>
I agree that the iterator *looks* wrong, Like I said earlier, I am just
using the rq_for_each_segment() macro (defined in include/linux/blkdev.h
and expands to a few dozen lines of code). This is the recommended way of
iterating requests instead of using the lower level bio iterating functions
or going it yourself which is why it's recommended to use that instead of
going deeper and breaking compatibility when the kernel changes. I suspect
it's the request itself which was constructed incorrectly, or contains bios
that should not have been grouped into the same request, or contains bios
that have their bi_sector set incorrectly.


> > > The read syscall is for a byte offset (from the fd, set by lseek)
> > > and a length, not a range of contiguous sectors on the device. That
> > > off/len tuple gets mapped by the underlying filesystem or device
> > > into an sector/len via a getblocks callback in the dio code and the
> > > bios are then built according to the mappings that are returned. So
> > > in many cases the IO that hits the block device looks nothing at all
> > > like the IO that came from userspace.
> > >
> > >
> > In general if I were reading a file I agree 100%, but this was the read
> > call issued by xfs_repair to read the superblock directly from a block
> > device. So I, perhaps wrongly, anticipated straightforward requests or
> > maybe even a single 512k request coming down to the request_fn. I should
> > have mentioned that this was observed while using xfs_repair earlier in
> the
> > email though, so no offense intended. There's more of the xfs_repair
> strace
> > in my response to your next comment below. It fails very early as you can
> > imagine when xfs_repair can't read the superblock.
>
> I figured that this is what you were talking about, but remember
> that the block device also does it's own offset->sector mapping in
> the direct IO layer. So it's entirely possible that the mapping
> function (i.e the getblocks callback) is broken and that is why you
> are seeing weird mappings in the bios being built by the direct Io
> code.
>
>
This is the xfs_repair tool being run directly against a block device, so
if I am reading the fs/direct-io.c code correctly this means that the
mapping function (get_block_t) is using fs/block_dev.c:blkdev_get_block().
Is that correct? That function is very short and simple, so I can't imagine
how there would be a bug in there. If it were a file on an xfs filesystem,
the get_block_t callback would be xfs_get_blocks or xfs_get_blocks_direct
(which both internally call __xfs_get_blocks). Is my understanding correct?

--001a113437fc42962b04f64fae87
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quo=
te">On Wed, Apr 2, 2014 at 12:47 AM, Dave Chinner <span dir=3D"ltr">&lt;<a =
href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</=
a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div><div>&gt; &gt; &gt; While iterating through segments =
in rq_for_each_segment(), for some<br>

&gt; &gt; &gt; requests I am seeing some odd behavior.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; segment 0: iter.bio-&gt;bi_sector =3D 0, blk_rq_cur_sectors(=
rq) =3D 903 =A0 // Ok,<br>
&gt; &gt; &gt; this looks normal<br>
&gt; &gt; &gt; segment 1: iter.bio-&gt;bi_sector =3D 1023, blk_rq_cur_secto=
rs(rq) =3D 7 //<br>
&gt; &gt; &gt; Whoah... this doesn&#39;t look right to me<br>
&gt; &gt;<br>
&gt; &gt; Seems fine to me. There&#39;s absolutely no reason two separate I=
Os<br>
&gt; &gt; can&#39;t be sub-page sector aligned or discontiguous given the a=
bove<br>
&gt; &gt; configuration. If that&#39;s what the getblocks callback returned=
 to the<br>
&gt; &gt; DIO layer, then that&#39;s what you&#39;re going to see in the bi=
os...<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; I guess my assumption that sectors would be adjacent was invalid, but =
this<br>
&gt; is what I have read in ldd3 and other books and seen in some driver<br=
>
&gt; examples. So I apologize for my folly and it&#39;s another lesson in n=
ot<br>
&gt; believing everything you see on the net. The back half of my driver is=
<br>
&gt; really optimized for transferring a single contiguous lba &amp; transf=
er length<br>
&gt; pair (ala SCSI WRITE 16 for example). However in desperation, I had ch=
anged<br>
&gt; the driver to support requests like this (with disjoint sector ranges)=
 but<br>
&gt; it still seemed odd to me that occasionally some requests would even h=
ave<br>
&gt; multiple segments that would *write* the same sectors/lengths. For exa=
mple<br>
&gt; I also see requests like the following.<br>
&gt;<br>
&gt; Given: rq_data_dir(rq) =3D=3D 1 (i.e. a write)<br>
&gt; segment =A0 0: iter.bio-&gt;bi_sector =3D 0, blk_rq_cur_sectors(rq) =
=3D 7 =A0 =A0// Ok<br>
&gt; segment =A0 1: iter.bio-&gt;bi_sector =3D 0, blk_rq_cur_sectors(rq) =
=3D 7 =A0 =A0//<br>
&gt; Again?<br>
&gt; segment =A0 2: iter.bio-&gt;bi_sector =3D 0, blk_rq_cur_sectors(rq) =
=3D 7 =A0 =A0// Yet<br>
&gt; again?<br>
&gt; segment =A0 3: iter.bio-&gt;bi_sector =3D 0, blk_rq_cur_sectors(rq) =
=3D 7 =A0 =A0//<br>
&gt; Really?<br>
&gt; ...<br>
&gt; segment 126: iter.bio-&gt;bi_sector =3D 0, blk_rq_cur_sectors(rq) =3D =
7 =A0 =A0//<br>
&gt; What&#39;s going on?<br>
&gt; // Reminder: segment limit is 128<br>
&gt; segment 127: iter.bio-&gt;bi_sector =3D 1023, blk_rq_cur_sectors(rq) =
=3D 1 //<br>
&gt; Haha, bet you though I was going to say sector =3D 0!<br>
<br>
</div></div>That really looks to me like a bug in whatever is building that=
 iter<br>
structure. It looks like there&#39;s an off-by-one on each page (should<br>
be 8 sectors not 7) and the bi_sector is not being set correctly to<br>
the sector offset of the bio within the IO. i.e. for a contiguous<br>
IO it should look something like:<br>
<br>
segment =A0 0: iter.bio-&gt;bi_sector =3D 0, blk_rq_cur_sectors(rq) =3D 8<b=
r>
segment =A0 1: iter.bio-&gt;bi_sector =3D 8, blk_rq_cur_sectors(rq) =3D 8<b=
r>
segment =A0 2: iter.bio-&gt;bi_sector =3D 16, blk_rq_cur_sectors(rq) =3D 8<=
br>
....<br>
segment 127: iter.bio-&gt;bi_sector =3D 1016, blk_rq_cur_sectors(rq) =3D 8<=
br>
<br>
I highly doubt the direct IO code is doing something wrong, because<br>
a mapping bug like that would show up everywhere and not just in your<br>
special driver....<br>
<div><br></div></blockquote><div><br></div><div>I agree that the iterator *=
looks* wrong, Like I said earlier, I am just using the rq_for_each_segment(=
) macro (defined in include/linux/blkdev.h and expands to a few dozen lines=
 of code). This is the recommended way of iterating requests instead of usi=
ng the lower level bio iterating functions or going it yourself which is wh=
y it&#39;s recommended to use that instead of going deeper and breaking com=
patibility when the kernel changes. I suspect it&#39;s the request itself w=
hich was constructed incorrectly, or contains bios that should not have bee=
n grouped into the same request, or contains bios that have their bi_sector=
 set incorrectly.</div>
<div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px=
 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left=
-style:solid;padding-left:1ex"><div>
&gt; &gt; The read syscall is for a byte offset (from the fd, set by lseek)=
<br>
&gt; &gt; and a length, not a range of contiguous sectors on the device. Th=
at<br>
&gt; &gt; off/len tuple gets mapped by the underlying filesystem or device<=
br>
&gt; &gt; into an sector/len via a getblocks callback in the dio code and t=
he<br>
&gt; &gt; bios are then built according to the mappings that are returned. =
So<br>
&gt; &gt; in many cases the IO that hits the block device looks nothing at =
all<br>
&gt; &gt; like the IO that came from userspace.<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; In general if I were reading a file I agree 100%, but this was the rea=
d<br>
&gt; call issued by xfs_repair to read the superblock directly from a block=
<br>
&gt; device. So I, perhaps wrongly, anticipated straightforward requests or=
<br>
&gt; maybe even a single 512k request coming down to the request_fn. I shou=
ld<br>
&gt; have mentioned that this was observed while using xfs_repair earlier i=
n the<br>
&gt; email though, so no offense intended. There&#39;s more of the xfs_repa=
ir strace<br>
&gt; in my response to your next comment below. It fails very early as you =
can<br>
&gt; imagine when xfs_repair can&#39;t read the superblock.<br>
<br>
</div>I figured that this is what you were talking about, but remember<br>
that the block device also does it&#39;s own offset-&gt;sector mapping in<b=
r>
the direct IO layer. So it&#39;s entirely possible that the mapping<br>
function (i.e the getblocks callback) is broken and that is why you<br>
are seeing weird mappings in the bios being built by the direct Io<br>
code.<br>
<div><br></div></blockquote><div><br></div><div>This is the xfs_repair tool=
 being run directly against a block device, so if I am reading the fs/direc=
t-io.c code correctly this means that the mapping function (get_block_t) is=
 using fs/block_dev.c:blkdev_get_block(). Is that correct? That function is=
 very short and simple, so I can&#39;t imagine how there would be a bug in =
there. If it were a file on an xfs filesystem, the get_block_t callback wou=
ld be xfs_get_blocks or xfs_get_blocks_direct (which both internally call _=
_xfs_get_blocks). Is my understanding correct?</div>
<div><br></div></div></div></div>

--001a113437fc42962b04f64fae87--


--===============6135353133968266277==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6135353133968266277==--
