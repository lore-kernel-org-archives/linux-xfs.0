Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NJYaSC133641 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 13:34:36 -0600
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id Bx99iqK1vj7ExKrk
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 11:34:34 -0800 (PST)
Received: by yhjj56 with SMTP id j56so1975087yhj.26
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 11:34:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120123051155.GI15102@dastard>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116232549.GC6922@dastard>
	<CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
	<20120123051155.GI15102@dastard>
Date: Mon, 23 Jan 2012 14:34:34 -0500
Message-ID: <CAFLer82QxfgXEx7ofzOHOK2YKiA+ab+_Aizd10SWHvnC-mVUHg@mail.gmail.com>
Subject: Re: concurrent direct IO write in xfs
From: Zheng Da <zhengda1936@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8946747126962339736=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============8946747126962339736==
Content-Type: multipart/alternative; boundary=20cf30563f4dcaec6304b7371edd

--20cf30563f4dcaec6304b7371edd
Content-Type: text/plain; charset=ISO-8859-1

Hello,

On Mon, Jan 23, 2012 at 12:11 AM, Dave Chinner <david@fromorbit.com> wrote:
>
> > >
> > This is weird. Yes, I'm sure. I use pwrite() to write data to a 4G file,
> > and I check the offset of each write and they are always smaller than 4G.
> > I instrument the code with systemtap and it shows me that ip->i_new_size
> > and new_size in xfs_aio_write_newsize_update are both 0.
> > Since in my case there is only overwrite, ip->i_new_size will always be 0
> > (the only place that updates ip->i_new_size is
> xfs_file_aio_write_checks).
> > Because of the same reason, new_size returned by
> xfs_file_aio_write_checks
> > is always 0.
> > Is it what you expected?
>
> No idea. I don't know what the problem you are seeing is yet, or if
> indeed there even is a problem as I don't really understand what you
> are trying to do or what results you are expecting to see...
>
Here I was just wondering if i_new_size is always 0 if there are only
overwrites. I think it has nothing to do with the pattern of my workloads
or the device I used for the test.

>
> Indeed, have you run the test on something other than a RAM disk and
> confirmed that the problem exists on a block device that has real IO
> latency? If your IO takes close to zero time, then there isn't any
> IO level concurrency you can extract from single file direct IO; it
> will all just serialise on the extent tree lookups.
>
It's difficult to test the scalability problem in the traditional disks.
They provide very low IOPS (IO per second). Even two SSDs can't provide
enough IOPS.
I don't think all direct IO will serialized on the extent tree lookups.
Direct IO reads can parallelized pretty well and they also need extent tree
lookups.

>
> > > >  0xffffffff812829f4 : __xfs_get_blocks+0x94/0x4a0 [kernel]
> > >
> > > And for direct IO writes, this will be the block mapping lookup so
> > > always hit.
> > >
> > >
> > > What this says to me is that you are probably doing is lots of very
> > > small concurrent write IOs, but I'm only guessing.  Can you provide
> > > your test case and a description of your test hardware so we can try
> > > to reproduce the problem?
> > >
> > I build XFS on the top of ramdisk. So yes, there is a lot of small
> > concurrent writes in a second.
> > I create a file of 4GB in XFS (the ramdisk has 5GB of space). My test
> > program overwrites 4G of data to the file and each time writes a page of
> > data randomly to the file. It's always overwriting, and no appending. The
> > offset of each write is always aligned to the page size. There is no
> > overlapping between writes.
>
> Why are you using XFS for this? tmpfs was designed to do this sort
> of stuff as efficiently as possible....
>
OK, I can try that.

>
> > So the test case is pretty simple and I think it's easy to reproduce it.
> > It'll be great if you can try the test case.
>
> Can you post your test code so I know what I test is exactly what
> you are running?
>
I can do that. My test code gets very complicated now. I need to simplify
it.

Thanks,
Da

--20cf30563f4dcaec6304b7371edd
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,<br><br><div class=3D"gmail_quote">On Mon, Jan 23, 2012 at 12:11 AM, =
Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">d=
avid@fromorbit.com</a>&gt;</span> wrote:<blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im">
&gt; &gt;<br>
&gt; This is weird. Yes, I&#39;m sure. I use pwrite() to write data to a 4G=
 file,<br>
&gt; and I check the offset of each write and they are always smaller than =
4G.<br>
&gt; I instrument the code with systemtap and it shows me that ip-&gt;i_new=
_size<br>
&gt; and new_size in xfs_aio_write_newsize_update are both 0.<br>
&gt; Since in my case there is only overwrite, ip-&gt;i_new_size will alway=
s be 0<br>
&gt; (the only place that updates ip-&gt;i_new_size is xfs_file_aio_write_c=
hecks).<br>
&gt; Because of the same reason, new_size returned by xfs_file_aio_write_ch=
ecks<br>
&gt; is always 0.<br>
&gt; Is it what you expected?<br>
<br>
</div>No idea. I don&#39;t know what the problem you are seeing is yet, or =
if<br>
indeed there even is a problem as I don&#39;t really understand what you<br=
>
are trying to do or what results you are expecting to see...<br></blockquot=
e><div>Here I was just wondering if=A0i_new_size is always 0 if there are o=
nly overwrites. I think it has nothing to do with the pattern of my workloa=
ds or the device I used for the test.</div>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
Indeed, have you run the test on something other than a RAM disk and<br>
confirmed that the problem exists on a block device that has real IO<br>
latency? If your IO takes close to zero time, then there isn&#39;t any<br>
IO level concurrency you can extract from single file direct IO; it<br>
will all just serialise on the extent tree lookups.<br></blockquote><div>It=
&#39;s difficult to test the scalability problem in the traditional disks. =
They provide very low IOPS (IO per second). Even two SSDs can&#39;t provide=
 enough IOPS.=A0</div>
<div>I don&#39;t think all direct IO will serialized on the extent tree loo=
kups. Direct IO reads can parallelized pretty well and they also need exten=
t tree lookups.</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div class=3D"im"><br>
&gt; &gt; &gt; =A00xffffffff812829f4 : __xfs_get_blocks+0x94/0x4a0 [kernel]=
<br>
&gt; &gt;<br>
&gt; &gt; And for direct IO writes, this will be the block mapping lookup s=
o<br>
&gt; &gt; always hit.<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; What this says to me is that you are probably doing is lots of ve=
ry<br>
&gt; &gt; small concurrent write IOs, but I&#39;m only guessing. =A0Can you=
 provide<br>
&gt; &gt; your test case and a description of your test hardware so we can =
try<br>
&gt; &gt; to reproduce the problem?<br>
&gt; &gt;<br>
&gt; I build XFS on the top of ramdisk. So yes, there is a lot of small<br>
&gt; concurrent writes in a second.<br>
&gt; I create a file of 4GB in XFS (the ramdisk has 5GB of space). My test<=
br>
&gt; program overwrites 4G of data to the file and each time writes a page =
of<br>
&gt; data randomly to the file. It&#39;s always overwriting, and no appendi=
ng. The<br>
&gt; offset of each write is always aligned to the page size. There is no<b=
r>
&gt; overlapping between writes.<br>
<br>
</div>Why are you using XFS for this? tmpfs was designed to do this sort<br=
>
of stuff as efficiently as possible....<br></blockquote><div>OK, I can try =
that.=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im"><br>
&gt; So the test case is pretty simple and I think it&#39;s easy to reprodu=
ce it.<br>
&gt; It&#39;ll be great if you can try the test case.<br>
<br>
</div>Can you post your test code so I know what I test is exactly what<br>
you are running?<br></blockquote><div>I can do that. My test code gets very=
 complicated now. I need to simplify it.</div><div><br></div><div>Thanks,</=
div><div>Da</div></div><br>

--20cf30563f4dcaec6304b7371edd--


--===============8946747126962339736==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8946747126962339736==--
