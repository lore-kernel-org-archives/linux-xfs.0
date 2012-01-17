Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0HJmdjZ173825 for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 13:48:40 -0600
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id BiQKDeJ95yiwFkyh
	for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 11:48:37 -0800 (PST)
Received: by yhjj56 with SMTP id j56so2659007yhj.26
	for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 11:48:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120116232549.GC6922@dastard>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116232549.GC6922@dastard>
Date: Tue, 17 Jan 2012 14:19:52 -0500
Message-ID: <CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============4651939458241650302=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============4651939458241650302==
Content-Type: multipart/alternative; boundary=20cf300513cc27a98704b6be37e1

--20cf300513cc27a98704b6be37e1
Content-Type: text/plain; charset=ISO-8859-1

Hello,

On Mon, Jan 16, 2012 at 6:25 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> >  0xffffffff81288b6a : xfs_aio_write_newsize_update+0x3a/0x90 [kernel]
>
> Only ever taken when doing appending writes. Are you -sure- you are
> not doing appending writes?
>
This is weird. Yes, I'm sure. I use pwrite() to write data to a 4G file,
and I check the offset of each write and they are always smaller than 4G.
I instrument the code with systemtap and it shows me that ip->i_new_size
and new_size in xfs_aio_write_newsize_update are both 0.
Since in my case there is only overwrite, ip->i_new_size will always be 0
(the only place that updates ip->i_new_size is xfs_file_aio_write_checks).
Because of the same reason, new_size returned by xfs_file_aio_write_checks
is always 0.
Is it what you expected?

>
> >  0xffffffff812829f4 : __xfs_get_blocks+0x94/0x4a0 [kernel]
>
> And for direct IO writes, this will be the block mapping lookup so
> always hit.
>
>
> What this says to me is that you are probably doing is lots of very
> small concurrent write IOs, but I'm only guessing.  Can you provide
> your test case and a description of your test hardware so we can try
> to reproduce the problem?
>
I build XFS on the top of ramdisk. So yes, there is a lot of small
concurrent writes in a second.
I create a file of 4GB in XFS (the ramdisk has 5GB of space). My test
program overwrites 4G of data to the file and each time writes a page of
data randomly to the file. It's always overwriting, and no appending. The
offset of each write is always aligned to the page size. There is no
overlapping between writes.
So the test case is pretty simple and I think it's easy to reproduce it.
It'll be great if you can try the test case.

Thanks,
Da

--20cf300513cc27a98704b6be37e1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,<br><br><div class=3D"gmail_quote">On Mon, Jan 16, 2012 at 6:25 PM, D=
ave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">da=
vid@fromorbit.com</a>&gt;</span> wrote:<blockquote class=3D"gmail_quote" st=
yle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

&gt; =A00xffffffff81288b6a : xfs_aio_write_newsize_update+0x3a/0x90 [kernel=
]<br>
<br>
Only ever taken when doing appending writes. Are you -sure- you are<br>
not doing appending writes?<br></blockquote><div>This is weird. Yes, I&#39;=
m sure. I use pwrite() to write data to a 4G file, and I check the offset o=
f each write and they are always smaller than 4G.</div><div>I instrument th=
e code with systemtap and it shows me that ip-&gt;i_new_size and new_size i=
n=A0xfs_aio_write_newsize_update=A0are both 0.=A0</div>
<div>Since in my case there is only overwrite, ip-&gt;i_new_size will alway=
s be 0 (the only place that updates ip-&gt;i_new_size is xfs_file_aio_write=
_checks). Because of the same reason, new_size returned by xfs_file_aio_wri=
te_checks is always 0.</div>
<div>Is it what you expected?</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
&gt; =A00xffffffff812829f4 : __xfs_get_blocks+0x94/0x4a0 [kernel]<br>
<br>
And for direct IO writes, this will be the block mapping lookup so<br>
always hit.<br>
<br>
<br>
What this says to me is that you are probably doing is lots of very<br>
small concurrent write IOs, but I&#39;m only guessing. =A0Can you provide<b=
r>
your test case and a description of your test hardware so we can try<br>
to reproduce the problem?<br></blockquote><div><span class=3D"Apple-style-s=
pan" style>I build XFS on the top of ramdisk.=A0</span><span class=3D"Apple=
-style-span" style>So yes, there is a lot of small concurrent writes in a s=
econd.</span></div>
<div><span class=3D"Apple-style-span" style>I create a file of 4GB in XFS (=
the ramdisk has 5GB of space). My test program overwrites 4G of data to the=
 file and each time writes a page of data randomly to the file. It&#39;s al=
ways overwriting, and no appending. The offset of each write is always alig=
ned to the page size. There is no overlapping between writes.=A0</span></di=
v>
<div><span class=3D"Apple-style-span" style>So the test case is pretty simp=
le and I think it&#39;s easy to reproduce it. It&#39;ll be great if you can=
 try the test case.</span></div><div><span class=3D"Apple-style-span" style=
><br>
</span></div></div>Thanks,<div>Da</div>

--20cf300513cc27a98704b6be37e1--


--===============4651939458241650302==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4651939458241650302==--
