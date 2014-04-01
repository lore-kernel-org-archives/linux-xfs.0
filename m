Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7CDBB7F56
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 15:16:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6467D304053
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 13:16:42 -0700 (PDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
	[209.85.217.172]) by cuda.sgi.com with ESMTP id
	8LW06qSHACH7sw6S (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Apr 2014 13:16:40 -0700 (PDT)
Received: by mail-lb0-f172.google.com with SMTP id c11so7509736lbj.3
	for <xfs@oss.sgi.com>; Tue, 01 Apr 2014 13:16:39 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 1 Apr 2014 16:16:39 -0400
Message-ID: <CABHf-sxmxmM0+WVzvGGJqKrrGngm0qrGTsYDnEmUEf+GJ_pK8A@mail.gmail.com>
Subject: xfs: invalid requests to request_fn from xfs_repair
From: Jamie Pocas <pocas.jamie@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1706465184946416719=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1706465184946416719==
Content-Type: multipart/alternative; boundary=001a1137e98679c1ed04f600d880

--001a1137e98679c1ed04f600d880
Content-Type: text/plain; charset=ISO-8859-1

Hi folks,

I have a very simple block device driver that uses the request_fn style of
processing instead of the older bio handling or newer multiqueue approach.
I have been using this with ext3 and ext4 for years with no issues, but
scalability requirements have dictated that I move to xfs to better support
larger devices.

I'm observing something weird in my request_fn. It seems like the block
layer is issuing invalid requests to my request function, and it really
manifests when I use xfs_repair. Here's some info:

blk_queue_physical_block_size(q, 512) // should be no surprise
blk_queue_logical_block_size(q, 512) // should be no surprise
blk_queue_max_segments(q, 128); /* 128 memory segments (page +
offset/length pairs) per request! */
blk_queue_max_hw_sectors(q, CA_MAX_REQUEST_SECTORS); /* Up to 1024 sectors
(512k) per request hard limit in the kernel */
blk_queue_max_segment_size(q, CA_MAX_REQUEST_BYTES); /* 512k (1024 sectors)
is the hard limit in the kernel */

While iterating through segments in rq_for_each_segment(), for some
requests I am seeing some odd behavior.

segment 0: iter.bio->bi_sector = 0, blk_rq_cur_sectors(rq) = 903   // Ok,
this looks normal
segment 1: iter.bio->bi_sector = 1023, blk_rq_cur_sectors(rq) = 7 //
Whoah... this doesn't look right to me
...

You can see with segment 1, that the start sector is *NOT* adjacent to the
the previous segment's sectors (there's a gap from sector 903 through 1022)
and that the "sparse" request, for lack of a better term, extends beyond
the max I/O boundary of 512k. Furthermore, this doesn't seem to jibe with
what userspace is doing, which is a simple 512k read all in one chunk with
a single userspace address.

But when you look at the strace of what xfs_repair is doing, it's just an
innocuous read of 512k from sector 0.

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

The reason you see the EIO is because I am failing a request in the driver
since it violates the restrictions I set earlier, is non-adjacent, and so I
am unable to satisfy it.

*Point 1:* Shouldn't requests contain all segments that are adjacent on
disk e.g. if initially before the rq_for_each_segment() loop blk_rq_pos(rq)
is 10, and blk_rq_cur_sectors is 10, then on the next iteration (if any)
iter.bio->bi_sector should be 10+10-1=20? Is my understanding correct? Are
these some kind of special requests that should be handled differently
(e.g. I know that DISCARD requests have to be handled differently and
shouldn't be run through rq_for_each_segment, and that FLUSH requests are
often empty). The cmd_flags say that they are normal REQ_TYPE_FS requests.

*Point 2:* If I ignore the incorrect iter.bio->bi_sector, and just
read/write the request out as if it were adjacent, I xfs_repair reports
corruption, and sure enough there are inodes which are zeroed out instead
of having the inode magic 0x494e ( "IN") as expected. So mkfs.xfs, while
not sending what appear to be illegal requests, is still resulting in
corruption.

*Point 3:* Interestingly this goes away when I set
blk_queue_max_segments(q, 1), but this obviously cuts down on clustering,
and this of course kills performance. Is this indicative of anything in
particular that I could be doing wrong?

Please cut me some slack when I say something like xfs_repair is "sending"
invalid requests. I know that there is the C library, system call
interface, block layer, etc.. in between, but I just mean to say simply
that using this tool results in this unexpected behavior. I don't mean to
point blame at xfs or xfsprogs. If this turns out to be a block layer
issue, and this posting needs to be sent elsewhere, I apologize and would
appreciate being pointed in the right direction.

It almost feels like the block layer is splitting the bios up wrongly, is
corrupting the bvecs, or is introducing a race. What's strange again, is
that I have only seen this behavior with xfs tools, but not ext3, or ext4
and e2fsprogs which has been working for years. It really shouldn't matter
though, because mkfs.xfs and xfs_repair are user space tools, so this
shouldn't cause the block layer in the kernel to send down invalid
requests. I have been grappling with this for a few weeks, and I am tempted
to go to the old bio handling function instead just to see if that would
work out for me better, but that would be a big rewrite of the LLD. I am
using an older Ubuntu 12.04 kernel 3.2.x so I am not able to go to the
newer multiqueue implementation.


Any ideas/suggestions?
Need more information?


Thanks and Regards,
Jamie Pocas

--001a1137e98679c1ed04f600d880
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hi folks,</div><div><br></div><div>I have a very=
 simple block device driver that uses the request_fn style of processing in=
stead of the older bio handling or newer multiqueue approach. I have been u=
sing this with ext3 and ext4 for years with no issues, but scalability requ=
irements have dictated that I move to xfs to better support larger devices.=
</div>
</div><div><br></div><div>I&#39;m observing something weird in my request_f=
n. It seems like the block layer is issuing invalid requests to my request =
function, and it really manifests when I use xfs_repair. Here&#39;s some in=
fo:</div>
<div><br></div><div>blk_queue_physical_block_size(q, 512) // should be no s=
urprise<br></div><div><div>blk_queue_logical_block_size(q, 512) // should b=
e no surprise</div></div><div><div>blk_queue_max_segments(q, 128); /* 128 m=
emory segments (page + offset/length pairs) per request! */</div>
<div>blk_queue_max_hw_sectors(q, CA_MAX_REQUEST_SECTORS); /* Up to 1024 sec=
tors (512k) per request hard limit in the kernel */<br></div><div>blk_queue=
_max_segment_size(q, CA_MAX_REQUEST_BYTES); /* 512k (1024 sectors) is the h=
ard limit in the kernel */</div>
</div><div><br></div><div>While iterating through segments in rq_for_each_s=
egment(), for some requests I am seeing some odd behavior.</div><div><br></=
div><div><span style=3D"font-family:arial,sans-serif;font-size:13px">segmen=
t 0: iter.bio-&gt;bi_sector =3D 0, blk_rq_cur_sectors(rq) =3D 903 =A0 // Ok=
, this looks normal</span><br>
</div><div><span style=3D"font-family:arial,sans-serif;font-size:13px">segm=
ent 1: iter.bio-&gt;bi_sector =3D 1023, blk_rq_cur_sectors(rq) =3D 7 // Who=
ah... this doesn&#39;t look right to me</span><br style=3D"font-family:aria=
l,sans-serif;font-size:13px">
<span style=3D"font-family:arial,sans-serif;font-size:13px">...=A0</span><b=
r></div><div><br></div><div>You can see with segment 1, that the start sect=
or is *NOT* adjacent to the the previous segment&#39;s sectors (there&#39;s=
 a gap from sector 903 through 1022) and that the &quot;sparse&quot; reques=
t, for lack of a better term, extends beyond the max I/O boundary of 512k. =
Furthermore, this doesn&#39;t seem to jibe with what userspace is doing, wh=
ich is a simple 512k read all in one chunk with a single userspace address.=
</div>
<div><br></div><div>But when you look at the strace of what xfs_repair is d=
oing, it&#39;s just an innocuous read of 512k from sector 0.</div><div><br>=
</div><div>write(2, &quot;Phase 1 - find and verify superb&quot;..., 40Phas=
e 1 - find and verify superblock...</div>
<div>) =3D 40</div><div>mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVAT=
E|MAP_ANONYMOUS, -1, 0) =3D 0x7f00e2f42000</div><div>mmap(NULL, 528384, PRO=
T_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =3D 0x7f00e2ec1000</di=
v>
<div>lseek(4, 0, SEEK_SET) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 0</div><=
div>read(4, 0x7f00e2ec1200, 524288) =A0 =A0 =A0 =A0 =3D -1 EIO (Input/outpu=
t error)</div><div>write(2, &quot;superblock read failed, offset 0&quot;...=
, 61superblock read failed, offset 0, size 524288, ag 0, rval -1</div>
<div>) =3D 61</div><div><br></div><div>The reason you see the EIO is becaus=
e I am failing a request in the driver since it violates the restrictions I=
 set earlier, is non-adjacent, and so I am unable to satisfy it.</div><div>
<br></div><div><b>Point 1:</b> Shouldn&#39;t requests contain all segments =
that are adjacent on disk e.g. if initially before the rq_for_each_segment(=
) loop blk_rq_pos(rq) is 10, and blk_rq_cur_sectors is 10, then on the next=
 iteration (if any) iter.bio-&gt;bi_sector should be 10+10-1=3D20? Is my un=
derstanding correct? Are these some kind of special requests that should be=
 handled differently (e.g. I know that DISCARD requests have to be handled =
differently and shouldn&#39;t be run through rq_for_each_segment, and that =
FLUSH requests are often empty). The cmd_flags say that they are normal REQ=
_TYPE_FS requests.</div>
<div><br></div><div><b>Point 2:</b>=A0If I ignore the incorrect=A0<span sty=
le=3D"font-family:arial,sans-serif;font-size:13px">iter.bio-&gt;bi_sector, =
and just read/write the request out as if it were adjacent, I xfs_repair re=
ports corruption, and sure enough there are inodes which are zeroed out ins=
tead of having the inode magic=A0</span><font face=3D"arial, sans-serif">0x=
494e (</font><span style=3D"font-family:arial,sans-serif;font-size:13px">=
=A0&quot;IN&quot;) as expected. So mkfs.xfs, while not sending what appear =
to be illegal requests, is still resulting in corruption.</span></div>
<div><br></div><div><div><b>Point 3:</b>=A0Interestingly this goes away whe=
n I set blk_queue_max_segments(q, 1), but this obviously cuts down on clust=
ering, and this of course kills performance. Is this indicative of anything=
 in particular that I could be doing wrong?</div>
</div><div><br></div><div>Please cut me some slack when I say something lik=
e xfs_repair is &quot;sending&quot; invalid requests. I know that there is =
the C library, system call interface, block layer, etc.. in between, but I =
just mean to say simply that using this tool results in this unexpected beh=
avior. I don&#39;t mean to point blame at xfs or xfsprogs. If this turns ou=
t to be a block layer issue, and this posting needs to be sent elsewhere, I=
 apologize and would appreciate being pointed in the right direction.</div>
<div><br></div><div>It almost feels like the block layer is splitting the b=
ios up wrongly, is corrupting the bvecs, or is introducing a race. What&#39=
;s strange again, is that I have only seen this behavior with xfs tools, bu=
t not ext3, or ext4 and e2fsprogs which has been working for years. It real=
ly shouldn&#39;t matter though, because mkfs.xfs and xfs_repair are user sp=
ace tools, so this shouldn&#39;t cause the block layer in the kernel to sen=
d down invalid requests. I have been grappling with this for a few weeks, a=
nd I am tempted to go to the old bio handling function instead just to see =
if that would work out for me better, but that would be a big rewrite of th=
e LLD. I am using an older Ubuntu 12.04 kernel 3.2.x so I am not able to go=
 to the newer multiqueue implementation.</div>
<div><br></div><div><br></div><div>Any ideas/suggestions?</div><div>Need mo=
re information?</div><div><br></div><div><br></div><div>Thanks and Regards,=
<br></div><div>Jamie Pocas<br></div><div><br></div></div>

--001a1137e98679c1ed04f600d880--


--===============1706465184946416719==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1706465184946416719==--
