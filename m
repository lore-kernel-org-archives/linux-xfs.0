Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B94F37F58
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 17:28:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E745AC009
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 15:28:23 -0700 (PDT)
Received: from mail-lb0-f179.google.com (mail-lb0-f179.google.com
	[209.85.217.179]) by cuda.sgi.com with ESMTP id
	0hM3vBrWDGRmKfH8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Apr 2014 15:28:21 -0700 (PDT)
Received: by mail-lb0-f179.google.com with SMTP id p9so7617647lbv.10
	for <xfs@oss.sgi.com>; Tue, 01 Apr 2014 15:28:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140401204215.GG17603@dastard>
References: <CABHf-sxmxmM0+WVzvGGJqKrrGngm0qrGTsYDnEmUEf+GJ_pK8A@mail.gmail.com>
	<20140401204215.GG17603@dastard>
Date: Tue, 1 Apr 2014 18:28:19 -0400
Message-ID: <CABHf-sxeACnsSoJszM8Xan-VcXLkLdrY7cBM9=FCAxdMBaQohA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============6412509678300432210=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6412509678300432210==
Content-Type: multipart/alternative; boundary=001a113802465eb67c04f602affb

--001a113802465eb67c04f602affb
Content-Type: text/plain; charset=ISO-8859-1

I have to say, thanks very much for the lightning fast response. Comments
are inline. I think the punchline is going to end up being that I probably
need to learn some more about the effects of O_DIRECT on the I/O path and
how it ends up in the request_queue. It's tempting now to regress back to a
bio-handling function, do my own merging, and see if I can avoid the
problem, but I am stubborn so I will probably stick it out for as long as I
can.

On Tue, Apr 1, 2014 at 4:42 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Apr 01, 2014 at 04:16:39PM -0400, Jamie Pocas wrote:
> > blk_queue_physical_block_size(q, 512) // should be no surprise
> > blk_queue_logical_block_size(q, 512) // should be no surprise
>
> 512 byte sectors.
>
> > blk_queue_max_segments(q, 128); /* 128 memory segments (page +
> > offset/length pairs) per request! */
> > blk_queue_max_hw_sectors(q, CA_MAX_REQUEST_SECTORS); /* Up to 1024
> sectors
> > (512k) per request hard limit in the kernel */
> > blk_queue_max_segment_size(q, CA_MAX_REQUEST_BYTES); /* 512k (1024
> sectors)
> > is the hard limit in the kernel */
>
> And up to 512KB per IO.
>
> > While iterating through segments in rq_for_each_segment(), for some
> > requests I am seeing some odd behavior.
> >
> > segment 0: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 903   // Ok,
> > this looks normal
> > segment 1: iter.bio->bi_sector = 1023, blk_rq_cur_sectors(rq) = 7 //
> > Whoah... this doesn't look right to me
>
> Seems fine to me. There's absolutely no reason two separate IOs
> can't be sub-page sector aligned or discontiguous given the above
> configuration. If that's what the getblocks callback returned to the
> DIO layer, then that's what you're going to see in the bios...
>
>
I guess my assumption that sectors would be adjacent was invalid, but this
is what I have read in ldd3 and other books and seen in some driver
examples. So I apologize for my folly and it's another lesson in not
believing everything you see on the net. The back half of my driver is
really optimized for transferring a single contiguous lba & transfer length
pair (ala SCSI WRITE 16 for example). However in desperation, I had changed
the driver to support requests like this (with disjoint sector ranges) but
it still seemed odd to me that occasionally some requests would even have
multiple segments that would *write* the same sectors/lengths. For example
I also see requests like the following.

Given: rq_data_dir(rq) == 1 (i.e. a write)
segment   0: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    // Ok
segment   1: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    //
Again?
segment   2: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    // Yet
again?
segment   3: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    //
Really?
...
segment 126: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 7    //
What's going on?
// Reminder: segment limit is 128
segment 127: iter.bio->bi_sector = 1023, blk_rq_cur_sectors(rq) = 1 //
Haha, bet you though I was going to say sector = 0!

This makes sense for reads, since maybe multiple user buffers wanted to
read the same sectors at [around] the same time so it batched them in one
request (temporal + spatial locality), but it doesn't make a lot of sense
to me for writes. That seems inefficient at best. Wouldn't the last write
win?

Even still, I occasionally see requests with more segments than the max
(perhaps I am counting segments wrong too). This was commented on by Jens
Axboe years ago here, but still seems to happen on my Ubuntu 12.04 w/ 3.2
kernel occasionally: https://lkml.org/lkml/2009/2/4/465

> You can see with segment 1, that the start sector is *NOT*
> > adjacent to the the previous segment's sectors (there's a gap from
> > sector 903 through 1022) and that the "sparse" request, for lack
> > of a better term, extends beyond the max I/O boundary of 512k.
> > Furthermore, this doesn't seem to jibe with what userspace is
> > doing, which is a simple 512k read all in one chunk with a single
> > userspace address.
>
> The read syscall is for a byte offset (from the fd, set by lseek)
> and a length, not a range of contiguous sectors on the device. That
> off/len tuple gets mapped by the underlying filesystem or device
> into an sector/len via a getblocks callback in the dio code and the
> bios are then built according to the mappings that are returned. So
> in many cases the IO that hits the block device looks nothing at all
> like the IO that came from userspace.
>
>
In general if I were reading a file I agree 100%, but this was the read
call issued by xfs_repair to read the superblock directly from a block
device. So I, perhaps wrongly, anticipated straightforward requests or
maybe even a single 512k request coming down to the request_fn. I should
have mentioned that this was observed while using xfs_repair earlier in the
email though, so no offense intended. There's more of the xfs_repair strace
in my response to your next comment below. It fails very early as you can
imagine when xfs_repair can't read the superblock.


> > But when you look at the strace of what xfs_repair is doing, it's just an
> > innocuous read of 512k from sector 0.
> >
> > write(2, "Phase 1 - find and verify superb"..., 40Phase 1 - find and
> verify
> > superblock...
> > ) = 40
> > mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> 0)
> > = 0x7f00e2f42000
> > mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> 0)
> > = 0x7f00e2ec1000
> > lseek(4, 0, SEEK_SET)                   = 0
> > read(4, 0x7f00e2ec1200, 524288)         = -1 EIO (Input/output error)
> > write(2, "superblock read failed, offset 0"..., 61superblock read failed,
> > offset 0, size 524288, ag 0, rval -1
> > ) = 61
>
> This is mostly meaningless without the command line you used for
> xfs_repair and the trace from the open() syscall parameters that
> returned fd 4 because we have no idea what the IO context actually
> is.
>
>
Yes, sorry about that I was trying to not bloat the thread with all the
localizations loading noise. I'm going to try to strip some of those out
and post more of the strace below. I *do* see the O_DIRECT flag as
expected. Here's the block device being opened. All I did was "xfs_repair
-n /dev/tsca0", hence the O_RDONLY flag.

open("/dev/tsca0", O_RDONLY|O_DIRECT)   = 4
fstat(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(251, 0), ...}) = 0
fstat(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(251, 0), ...}) = 0
ioctl(4, BLKGETSIZE64, 0x7fff8f759270)  = 0
ioctl(4, BLKSSZGET, 0x6732e0)           = 0
chdir("/home/jpocas/source/xfs/drivers") = 0
brk(0x23f9000)                          = 0x23f9000
close(3)                                = 0
getrlimit(RLIMIT_FSIZE, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) =
0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2570, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7f00e2fc2000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2570
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f00e2fc2000, 4096)            = 0
write(2, "Phase 1 - find and verify superb"..., 40Phase 1 - find and verify
superblock...
) = 40
mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
= 0x7f00e2f42000
mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
= 0x7f00e2ec1000
lseek(4, 0, SEEK_SET)                   = 0
read(4, 0x7f00e2ec1200, 524288)         = -1 EIO (Input/output error)
write(2, "superblock read failed, offset 0"..., 61superblock read failed,
offset 0, size 524288, ag 0, rval -1
) = 61
write(2, "\nfatal error -- ", 16
fatal error -- )       = 16
write(2, "Input/output error\n", 19Input/output error
)    = 19
exit_group(1)                           = ?



> > The reason you see the EIO is because I am failing a request in the
> driver
> > since it violates the restrictions I set earlier, is non-adjacent, and
> so I
> > am unable to satisfy it.
> >
> > *Point 1:* Shouldn't requests contain all segments that are adjacent on
> > disk
>
> Not necessarily, see above.
>
>
Got it. I need to look at the DIO code path in the kernel.


> > *Point 2:* If I ignore the incorrect iter.bio->bi_sector, and just
> > read/write the request out as if it were adjacent, I xfs_repair reports
> > corruption,
>
> Of course, because you read data from different sectors than was
> asked for by the higher layers.
>
>
Sorry, this was just out of desperation and another data point, ridiculous
as it may sound. I have been looking at this for a couple weeks now so I am
taking wild shots in the dark.


> > and sure enough there are inodes which are zeroed out instead
> > of having the inode magic 0x494e ( "IN") as expected. So mkfs.xfs, while
> > not sending what appear to be illegal requests, is still resulting in
> > corruption.
> >
> > *Point 3:* Interestingly this goes away when I set
> > blk_queue_max_segments(q, 1), but this obviously cuts down on clustering,
> > and this of course kills performance. Is this indicative of anything in
> > particular that I could be doing wrong?
>
> Probably does, but I can't tell you what it may be...
>
> > Please cut me some slack when I say something like xfs_repair is
> "sending"
> > invalid requests. I know that there is the C library, system call
> > interface, block layer, etc.. in between, but I just mean to say simply
> > that using this tool results in this unexpected behavior. I don't mean to
> > point blame at xfs or xfsprogs. If this turns out to be a block layer
> > issue, and this posting needs to be sent elsewhere, I apologize and would
> > appreciate being pointed in the right direction.
> >
> > It almost feels like the block layer is splitting the bios up wrongly, is
> > corrupting the bvecs, or is introducing a race. What's strange again, is
> > that I have only seen this behavior with xfs tools, but not ext3, or ext4
> > and e2fsprogs which has been working for years. It really shouldn't
> matter
>
> Because the XFS tools use direct IO, and the ext tools don't.
> Therefore the IO that the different tools pass through are completely
> different code paths in the kernel that have different constraints.
> e.g. buffered IO will always be page aligned, direct IO can be
> sector aligned....
>
>
That makes sense and I do see that O_DIRECT is being used by both mkfs.xfs
and xfs_repair. I guess I am off to investigate the O_DIRECT code path.

--001a113802465eb67c04f602affb
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I have to say, thanks very much for the lightning fast res=
ponse. Comments are inline. I think the punchline is going to end up being =
that I probably need to learn some more about the effects of O_DIRECT on th=
e I/O path and how it ends up in the request_queue. It&#39;s tempting now t=
o regress back to a bio-handling function, do my own merging, and see if I =
can avoid the problem, but I am stubborn so I will probably stick it out fo=
r as long as I can.<div class=3D"gmail_extra">
<br><div class=3D"gmail_quote">On Tue, Apr 1, 2014 at 4:42 PM, Dave Chinner=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_bl=
ank">david@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmai=
l_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-lef=
t-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">
<div class=3D"">On Tue, Apr 01, 2014 at 04:16:39PM -0400, Jamie Pocas wrote=
:<br>&gt; blk_queue_physical_block_size(q, 512) // should be no surprise<br=
>
&gt; blk_queue_logical_block_size(q, 512) // should be no surprise<br>
<br>
</div>512 byte sectors.<br>
<div class=3D""><br>
&gt; blk_queue_max_segments(q, 128); /* 128 memory segments (page +<br>
&gt; offset/length pairs) per request! */<br>
&gt; blk_queue_max_hw_sectors(q, CA_MAX_REQUEST_SECTORS); /* Up to 1024 sec=
tors<br>
&gt; (512k) per request hard limit in the kernel */<br>
&gt; blk_queue_max_segment_size(q, CA_MAX_REQUEST_BYTES); /* 512k (1024 sec=
tors)<br>
&gt; is the hard limit in the kernel */<br>
<br>
</div>And up to 512KB per IO.<br>
<div class=3D""><br>
&gt; While iterating through segments in rq_for_each_segment(), for some<br=
>
&gt; requests I am seeing some odd behavior.<br>
&gt;<br>
&gt; segment 0: iter.bio-&gt;bi_sector =3D 0, blk_rq_cur_sectors(rq) =3D 90=
3 =A0 // Ok,<br>
&gt; this looks normal<br>
&gt; segment 1: iter.bio-&gt;bi_sector =3D 1023, blk_rq_cur_sectors(rq) =3D=
 7 //<br>
&gt; Whoah... this doesn&#39;t look right to me<br>
<br>
</div>Seems fine to me. There&#39;s absolutely no reason two separate IOs<b=
r>
can&#39;t be sub-page sector aligned or discontiguous given the above<br>
configuration. If that&#39;s what the getblocks callback returned to the<br=
>
DIO layer, then that&#39;s what you&#39;re going to see in the bios...<br>
<div class=3D""><br></div></blockquote><div><br></div><div>I guess my assum=
ption that sectors would be adjacent was invalid, but this is what I have r=
ead in ldd3 and other books and seen in some driver examples. So I apologiz=
e for my folly and it&#39;s another lesson in not believing everything you =
see on the net. The back half of my driver is really optimized for transfer=
ring a single contiguous lba &amp; transfer length pair (ala SCSI WRITE 16 =
for example). However in desperation, I had changed the driver to support r=
equests like this (with disjoint sector ranges) but it still seemed odd to =
me that occasionally some requests would even have multiple segments that w=
ould *write* the same sectors/lengths. For example I also see requests like=
 the following.</div>
<div><br></div><div><div>Given: rq_data_dir(rq) =3D=3D 1 (i.e. a write)</di=
v><div>segment =A0 0: iter.bio-&gt;bi_sector =3D 0, blk_rq_cur_sectors(rq) =
=3D 7 =A0 =A0// Ok</div><div>segment =A0 1: iter.bio-&gt;bi_sector =3D 0, b=
lk_rq_cur_sectors(rq) =3D 7 =A0 =A0// Again?</div>
<div>segment =A0 2: iter.bio-&gt;bi_sector =3D 0, blk_rq_cur_sectors(rq) =
=3D 7 =A0 =A0// Yet again?</div><div>segment =A0 3: iter.bio-&gt;bi_sector =
=3D 0, blk_rq_cur_sectors(rq) =3D 7 =A0 =A0// Really?</div><div>...</div><d=
iv>segment 126: iter.bio-&gt;bi_sector =3D 0, blk_rq_cur_sectors(rq) =3D 7 =
=A0 =A0// What&#39;s going on?</div>
<div>// Reminder: segment limit is 128</div><div>segment 127: iter.bio-&gt;=
bi_sector =3D 1023, blk_rq_cur_sectors(rq) =3D 1 // Haha, bet you though I =
was going to say sector =3D 0!</div></div><div><br></div><div>This makes se=
nse for reads, since maybe multiple user buffers wanted to read the same se=
ctors at [around] the same time so it batched them in one request (temporal=
 + spatial locality), but it doesn&#39;t make a lot of sense to me for writ=
es. That seems inefficient at best. Wouldn&#39;t the last write win?</div>
<div><br></div><div>Even still, I occasionally see requests with more segme=
nts than the max (perhaps I am counting segments wrong too). This was comme=
nted on by Jens Axboe years ago here, but still seems to happen on my Ubunt=
u 12.04 w/ 3.2 kernel occasionally:=A0<a href=3D"https://lkml.org/lkml/2009=
/2/4/465">https://lkml.org/lkml/2009/2/4/465</a></div>
<div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-lef=
t-style:solid;padding-left:1ex"><div class=3D"">
&gt; You can see with segment 1, that the start sector is *NOT*<br>
&gt; adjacent to the the previous segment&#39;s sectors (there&#39;s a gap =
from<br>
&gt; sector 903 through 1022) and that the &quot;sparse&quot; request, for =
lack<br>
&gt; of a better term, extends beyond the max I/O boundary of 512k.<br>
&gt; Furthermore, this doesn&#39;t seem to jibe with what userspace is<br>
&gt; doing, which is a simple 512k read all in one chunk with a single<br>
&gt; userspace address.<br>
<br>
</div>The read syscall is for a byte offset (from the fd, set by lseek)<br>
and a length, not a range of contiguous sectors on the device. That<br>
off/len tuple gets mapped by the underlying filesystem or device<br>
into an sector/len via a getblocks callback in the dio code and the<br>
bios are then built according to the mappings that are returned. So<br>
in many cases the IO that hits the block device looks nothing at all<br>
like the IO that came from userspace.<br>
<div class=3D""><br></div></blockquote><div><br></div><div>In general if I =
were reading a file I agree 100%, but this was the read call issued by xfs_=
repair to read the superblock directly from a block device. So I, perhaps w=
rongly, anticipated straightforward requests or maybe even a single 512k re=
quest coming down to the request_fn. I should have mentioned that this was =
observed while using xfs_repair earlier in the email though, so no offense =
intended. There&#39;s more of the xfs_repair strace in my response to your =
next comment below. It fails very early as you can imagine when xfs_repair =
can&#39;t read the superblock.</div>
<div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-lef=
t-style:solid;padding-left:1ex"><div class=3D"">
<br>
&gt; But when you look at the strace of what xfs_repair is doing, it&#39;s =
just an<br>
&gt; innocuous read of 512k from sector 0.<br>
&gt;<br>
&gt; write(2, &quot;Phase 1 - find and verify superb&quot;..., 40Phase 1 - =
find and verify<br>
&gt; superblock...<br>
&gt; ) =3D 40<br>
&gt; mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1=
, 0)<br>
&gt; =3D 0x7f00e2f42000<br>
&gt; mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1=
, 0)<br>
&gt; =3D 0x7f00e2ec1000<br>
&gt; lseek(4, 0, SEEK_SET) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 0<br>
&gt; read(4, 0x7f00e2ec1200, 524288) =A0 =A0 =A0 =A0 =3D -1 EIO (Input/outp=
ut error)<br>
&gt; write(2, &quot;superblock read failed, offset 0&quot;..., 61superblock=
 read failed,<br>
&gt; offset 0, size 524288, ag 0, rval -1<br>
&gt; ) =3D 61<br>
<br>
</div>This is mostly meaningless without the command line you used for<br>
xfs_repair and the trace from the open() syscall parameters that<br>
returned fd 4 because we have no idea what the IO context actually<br>
is.<br>
<div class=3D""><br></div></blockquote><div><br></div><div>Yes, sorry about=
 that I was trying to not bloat the thread with all the localizations loadi=
ng noise. I&#39;m going to try to strip some of those out and post more of =
the strace below. I *do* see the O_DIRECT flag as expected. Here&#39;s the =
block device being opened. All I did was &quot;xfs_repair -n /dev/tsca0&quo=
t;, hence the O_RDONLY flag.</div>
<div><div><br></div><div>open(&quot;/dev/tsca0&quot;, O_RDONLY|O_DIRECT) =
=A0 =3D 4</div><div>fstat(4, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(251=
, 0), ...}) =3D 0</div><div>fstat(4, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmak=
edev(251, 0), ...}) =3D 0</div>
<div>ioctl(4, BLKGETSIZE64, 0x7fff8f759270) =A0=3D 0</div><div>ioctl(4, BLK=
SSZGET, 0x6732e0) =A0 =A0 =A0 =A0 =A0 =3D 0</div><div>chdir(&quot;/home/jpo=
cas/source/xfs/drivers&quot;) =3D 0</div><div>brk(0x23f9000) =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 0x23f9000</div>
<div>close(3) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0=3D 0</div><div>getrlimit(RLIMIT_FSIZE, {rlim_cur=3DRLIM_INFINITY, rlim_=
max=3DRLIM_INFINITY}) =3D 0</div><div>open(&quot;/usr/share/locale/locale.a=
lias&quot;, O_RDONLY|O_CLOEXEC) =3D 3</div>
<div>fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D2570, ...}) =3D 0</div><di=
v>mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f00e2fc2000</div><div>read(3, &quot;# Locale name alias data base.\n=
#&quot;..., 4096) =3D 2570</div>
<div>read(3, &quot;&quot;, 4096) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =3D 0</div><div>close(3) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0=3D 0</div><div>munmap(0x7f00e2fc2000, 4096) =A0 =A0 =A0=
 =A0 =A0 =A0=3D 0</div><div>write(2, &quot;Phase 1 - find and verify superb=
&quot;..., 40Phase 1 - find and verify superblock...<br>
</div><div>) =3D 40</div><div>mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_=
PRIVATE|MAP_ANONYMOUS, -1, 0) =3D 0x7f00e2f42000</div><div>mmap(NULL, 52838=
4, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =3D 0x7f00e2ec10=
00</div>
<div>lseek(4, 0, SEEK_SET) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 0</div><=
div>read(4, 0x7f00e2ec1200, 524288) =A0 =A0 =A0 =A0 =3D -1 EIO (Input/outpu=
t error)</div><div>write(2, &quot;superblock read failed, offset 0&quot;...=
, 61superblock read failed, offset 0, size 524288, ag 0, rval -1</div>
<div>) =3D 61</div><div>write(2, &quot;\nfatal error -- &quot;, 16<br></div=
><div>fatal error -- ) =A0 =A0 =A0 =3D 16</div><div>write(2, &quot;Input/ou=
tput error\n&quot;, 19Input/output error</div><div>) =A0 =A0=3D 19</div><di=
v>exit_group(1) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D ?</=
div>
</div><div><br></div><div>=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(20=
4,204,204);border-left-style:solid;padding-left:1ex"><div class=3D"">
&gt; The reason you see the EIO is because I am failing a request in the dr=
iver<br>
&gt; since it violates the restrictions I set earlier, is non-adjacent, and=
 so I<br>
&gt; am unable to satisfy it.<br>
&gt;<br>
</div>&gt; *Point 1:* Shouldn&#39;t requests contain all segments that are =
adjacent on<br>
&gt; disk<br>
<br>
Not necessarily, see above.<br>
<br></blockquote><div><br></div><div>Got it. I need to look at the DIO code=
 path in the kernel.</div><div>=A0</div><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rg=
b(204,204,204);border-left-style:solid;padding-left:1ex">

&gt; *Point 2:* If I ignore the incorrect iter.bio-&gt;bi_sector, and just<=
br>
<div class=3D"">&gt; read/write the request out as if it were adjacent, I x=
fs_repair reports<br>
&gt; corruption,<br>
<br>
</div>Of course, because you read data from different sectors than was<br>
asked for by the higher layers.<br>
<div class=3D""><br></div></blockquote><div><br></div><div>Sorry, this was =
just out of desperation and another data point, ridiculous as it may sound.=
 I have been looking at this for a couple weeks now so I am taking wild sho=
ts in the dark.</div>
<div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px=
 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left=
-style:solid;padding-left:1ex"><div class=3D"">
&gt; and sure enough there are inodes which are zeroed out instead<br>
&gt; of having the inode magic 0x494e ( &quot;IN&quot;) as expected. So mkf=
s.xfs, while<br>
&gt; not sending what appear to be illegal requests, is still resulting in<=
br>
&gt; corruption.<br>
&gt;<br>
</div>&gt; *Point 3:* Interestingly this goes away when I set<br>
<div class=3D"">&gt; blk_queue_max_segments(q, 1), but this obviously cuts =
down on clustering,<br>
&gt; and this of course kills performance. Is this indicative of anything i=
n<br>
&gt; particular that I could be doing wrong?<br>
<br>
</div>Probably does, but I can&#39;t tell you what it may be...<br>
<div class=3D""><br>
&gt; Please cut me some slack when I say something like xfs_repair is &quot=
;sending&quot;<br>
&gt; invalid requests. I know that there is the C library, system call<br>
&gt; interface, block layer, etc.. in between, but I just mean to say simpl=
y<br>
&gt; that using this tool results in this unexpected behavior. I don&#39;t =
mean to<br>
&gt; point blame at xfs or xfsprogs. If this turns out to be a block layer<=
br>
&gt; issue, and this posting needs to be sent elsewhere, I apologize and wo=
uld<br>
&gt; appreciate being pointed in the right direction.<br>
&gt;<br>
&gt; It almost feels like the block layer is splitting the bios up wrongly,=
 is<br>
&gt; corrupting the bvecs, or is introducing a race. What&#39;s strange aga=
in, is<br>
&gt; that I have only seen this behavior with xfs tools, but not ext3, or e=
xt4<br>
&gt; and e2fsprogs which has been working for years. It really shouldn&#39;=
t matter<br>
<br>
</div>Because the XFS tools use direct IO, and the ext tools don&#39;t.<br>
Therefore the IO that the different tools pass through are completely<br>
different code paths in the kernel that have different constraints.<br>
e.g. buffered IO will always be page aligned, direct IO can be<br>
sector aligned....<br>
<br></blockquote><div><br></div><div>That makes sense and I do see that O_D=
IRECT is being used by both mkfs.xfs and xfs_repair. I guess I am off to in=
vestigate the O_DIRECT code path.</div></div></div></div>

--001a113802465eb67c04f602affb--


--===============6412509678300432210==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6412509678300432210==--
