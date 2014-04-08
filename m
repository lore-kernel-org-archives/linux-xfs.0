Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F6017FC2
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 22:56:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4AA6D304053
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 20:56:15 -0700 (PDT)
Received: from mail-la0-f43.google.com (mail-la0-f43.google.com
	[209.85.215.43]) by cuda.sgi.com with ESMTP id W3hR6ALqFlQpBFQH
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Apr 2014 20:56:12 -0700 (PDT)
Received: by mail-la0-f43.google.com with SMTP id e16so317936lan.30
	for <xfs@oss.sgi.com>; Mon, 07 Apr 2014 20:56:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABHf-sx3H2=R72gFZik3QhygiF4VhUMXGt1VPw2AaXoXMcz8OQ@mail.gmail.com>
References: <CABHf-sxmxmM0+WVzvGGJqKrrGngm0qrGTsYDnEmUEf+GJ_pK8A@mail.gmail.com>
	<20140401204215.GG17603@dastard>
	<CABHf-sxeACnsSoJszM8Xan-VcXLkLdrY7cBM9=FCAxdMBaQohA@mail.gmail.com>
	<20140402044749.GK17603@dastard>
	<CABHf-sx3H2=R72gFZik3QhygiF4VhUMXGt1VPw2AaXoXMcz8OQ@mail.gmail.com>
Date: Mon, 7 Apr 2014 23:56:10 -0400
Message-ID: <CABHf-szyeYUU=H30wM22v3cqyR08wvmQNRMWfu9ys5VLMtsELQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============7400522888777360554=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============7400522888777360554==
Content-Type: multipart/alternative; boundary=089e012292f8e3f9dd04f67ff6d5

--089e012292f8e3f9dd04f67ff6d5
Content-Type: text/plain; charset=ISO-8859-1

Hi Dave,

Okay, I think I've found a workaround but I don't have the root cause yet.
So just to recap there is a macro defined in include/linux/blkdev.h
called rq_for_each_segment(bvec, rq, iter). The arguments are of type
struct bio_vec*, struct request*, and struct req_iterator respectively. The
macro expands to several other macro invocations, which eventually expand
to approx. 40-50 lines of code.

(NOTE: in newer kernels the first argument is a bio_vec, and not a
bio_vec*. I think this is due to the immutable bio_vec changes, but I could
be wrong. For more on that, see http://lwn.net/Articles/544713/ , but I
digress.)

It seems like in some instances when using O_DIRECT and iterating through
the request using the above macro, I see that some fields of iter.bio are
not updated to the correct value and macros like blk_rq_cur_sectors(),
which ultimately rely on rq->bio, thus do not return the correct values. If
I assume (<--- dangerous word) that the sectors are all adjacent, as they
really are supposed to be in all my investigation, and use only the bio_vec
fields to track progress then the problems go away. I have been running all
sorts of data consistency tests since this discovery and I don't have any
further problems so far. Also, xfs_repair is returning cleanly as expected
now.

So basically I am only using blk_rq_pos(rq) once before the loop to get the
start sector, and then only relying on fields of bvec after that. For
example if I need to count the number of sectors, I can accumulate
(bvec->bv_len >> 9) through all the iterations. Summing up all of
blk_req_curr_sectors(rq) only worked sometimes, and so was unreliable.
Basically, the code to walk the request * looks something like this now,
where it used to make use of iter.bio->bi_sector and blk_rq_cur_sectors.

    sector_t curr_sector = blk_rq_pos(req);
    unsigned curr_num_sectors = 0;
    unsigned total_sectors = 0;

    // Should not do the memory mapping on a discard request, payload is
invalid
    BUG_ON(unlikely(req->cmd_flags & REQ_DISCARD));

    /* Iterate through the request */
    rq_for_each_segment(bvec, req, iter) {
        kern_buffer = kmap(bvec->bv_page) + bvec->bv_offset;
        curr_sector += curr_num_sectors;
        curr_num_sectors = (bvec->bv_len >> KERNEL_SECTOR_SHIFT);

        /* Do the transfer to the device. This part is not really relevant
to the discussion here
           but you can just imagine it as a memcpy because that's
effectively what's happening
           a failed copy would return -EFAULT and eventually the request
would be ended with
           blk_end_request_all with an error code*/

        kunmap(bvec->bv_page);

        /* FAIL */
        if (ret) {
            return ret;
        }

        total_sectors += curr_num_sectors; // Just for accounting
    }

I am going to run the compiler with -E and examine the
rq_for_each_segment() macro expansion to see where the suspected problem
happens. If it does look like a bug, I am going to write to LKML. Perhaps
it's something I am supposed to implicitly understand that is not well
documented (like the rest of O_DIRECT), and they can set me straight.

As it stands this doesn't seem to be an xfs issue so I'm going to drop this
discussion unless anyone else is interested in this issue or wants more
info.

Regards,
Jamie



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

--089e012292f8e3f9dd04f67ff6d5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<p>Hi Dave,</p>
<p>Okay, I think I&#39;ve found a workaround but I don&#39;t have the root =
cause yet. So just to recap there is a macro defined in include/linux/blkde=
v.h called=A0rq_for_each_segment(bvec, rq, iter). The arguments are of type=
 struct bio_vec*, struct request*, and struct req_iterator respectively. Th=
e macro expands to several other macro invocations, which eventually expand=
 to approx. 40-50 lines of code.</p>

<p>(NOTE: in newer kernels the first argument is a bio_vec, and not a bio_v=
ec*. I think this is due to the immutable bio_vec changes, but I could be w=
rong. For more on that, see <a href=3D"http://lwn.net/Articles/544713/">htt=
p://lwn.net/Articles/544713/</a> , but I digress.)</p>

<p>It seems like in some instances when using O_DIRECT and iterating throug=
h the request using the above macro, I see that some fields of iter.bio are=
 not updated to the correct value and macros like blk_rq_cur_sectors(), whi=
ch ultimately rely on rq-&gt;bio, thus do not return the correct values. If=
 I assume (&lt;--- dangerous word) that the sectors are all adjacent, as th=
ey really are supposed to be in all my investigation, and use only the bio_=
vec fields to track progress then the problems go away. I have been running=
 all sorts of data consistency tests since this discovery and I don&#39;t h=
ave any further problems so far. Also, xfs_repair is returning cleanly as e=
xpected now.</p>

<p>So basically I am only using blk_rq_pos(rq) once before the loop to get =
the start sector, and then only relying on fields of bvec after that. For e=
xample if I need to count the number of sectors, I can accumulate (bvec-&gt=
;bv_len &gt;&gt; 9) through all the iterations. Summing up all of blk_req_c=
urr_sectors(rq) only worked sometimes, and so was unreliable. Basically, th=
e code to walk the request * looks something like this now, where it used t=
o make use of iter.bio-&gt;bi_sector and blk_rq_cur_sectors.</p>

<p>=A0 =A0 sector_t curr_sector =3D blk_rq_pos(req);<br>
=A0 =A0 unsigned curr_num_sectors =3D 0;<br>
=A0 =A0 unsigned total_sectors =3D 0;</p>
<p>=A0 =A0 // Should not do the memory mapping on a discard request, payloa=
d is invalid<br>
=A0 =A0 BUG_ON(unlikely(req-&gt;cmd_flags &amp; REQ_DISCARD));</p>
<p>=A0 =A0 /* Iterate through the request */<br>
=A0 =A0 rq_for_each_segment(bvec, req, iter) {<br>
=A0 =A0 =A0 =A0 kern_buffer =3D kmap(bvec-&gt;bv_page) + bvec-&gt;bv_offset=
;<br>
=A0 =A0 =A0 =A0 curr_sector +=3D curr_num_sectors;<br>
=A0 =A0 =A0 =A0 curr_num_sectors =3D (bvec-&gt;bv_len &gt;&gt; KERNEL_SECTO=
R_SHIFT);</p>
<p>=A0 =A0 =A0 =A0 /* Do the transfer to the device. This part is not reall=
y relevant to the discussion here<br>
=A0 =A0 =A0 =A0 =A0 =A0but you can just imagine it as a memcpy because that=
&#39;s effectively what&#39;s happening<br>
=A0 =A0 =A0 =A0 =A0 =A0a failed copy would return -EFAULT and eventually th=
e request would be ended with<br>
=A0 =A0 =A0 =A0 =A0 =A0blk_end_request_all with an error code*/</p>
<p>=A0 =A0 =A0 =A0 kunmap(bvec-&gt;bv_page);</p>
<p>=A0 =A0 =A0 =A0 /* FAIL */<br>
=A0 =A0 =A0 =A0 if (ret) {<br>
=A0 =A0 =A0 =A0 =A0 =A0 return ret;<br>
=A0 =A0 =A0 =A0 }</p>
<p>=A0 =A0 =A0 =A0 total_sectors +=3D curr_num_sectors; // Just for account=
ing<br>
=A0 =A0 }</p>
<p>I am going to run the compiler with -E and examine the rq_for_each_segme=
nt() macro expansion to see where the suspected problem happens. If it does=
 look like a bug, I am going to write to LKML. Perhaps it&#39;s something I=
 am supposed to implicitly understand that is not well documented (like the=
 rest of O_DIRECT), and they can set me straight.</p>

<p>As it stands this doesn&#39;t seem to be an xfs issue so I&#39;m going t=
o drop this discussion unless anyone else is interested in this issue or wa=
nts more info.</p>
<p>Regards,<br>
Jamie<br><br></p>
<div class=3D"gmail_quot&lt;blockquote class=3D" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div class=
=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Wed, Apr 2, 2014 at =
12:47 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromor=
bit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br>


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
</div>

--089e012292f8e3f9dd04f67ff6d5--


--===============7400522888777360554==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7400522888777360554==--
