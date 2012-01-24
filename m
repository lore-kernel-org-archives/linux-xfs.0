Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O1e6M8170840 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 19:40:06 -0600
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id Cf0ZM6jTaxLpHruu
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 Jan 2012 17:40:04 -0800 (PST)
Received: by yhjj56 with SMTP id j56so2191583yhj.26
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 17:40:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F1DFC80.1040204@hardwarefreak.com>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116232549.GC6922@dastard>
	<CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
	<20120123051155.GI15102@dastard>
	<CAFLer82QxfgXEx7ofzOHOK2YKiA+ab+_Aizd10SWHvnC-mVUHg@mail.gmail.com>
	<CAFLer81GWSCCCMppU=2dE+5KKqD-hYVKAA0hz9n-CBbxAs_xfw@mail.gmail.com>
	<4F1DFC80.1040204@hardwarefreak.com>
Date: Mon, 23 Jan 2012 20:40:03 -0500
Message-ID: <CAFLer831OqL7y65Sn_0zQJP+7Z5G1zz2T2gnnG8UGJCy-_UXyw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1297484722781215147=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

--===============1297484722781215147==
Content-Type: multipart/alternative; boundary=20cf303bfd22e48cd504b73c391b

--20cf303bfd22e48cd504b73c391b
Content-Type: text/plain; charset=ISO-8859-1

Hello,

On Mon, Jan 23, 2012 at 7:34 PM, Stan Hoeppner <stan@hardwarefreak.com>wrote:

> On 1/23/2012 2:51 PM, Zheng Da wrote:
>
> > tmpfs doesn't support direct IO.
>
> Of course not.  tmpfs resides entirely within the page cache (or some of
> it in swap).  The whole point of direct IO is to bypass the page cache,
> transferring data directly between user space memory and the storage
> device.  As tmpfs is built entirely within the page cache, direct IO is
> obviously impossible.  And it's also obviously unnecessary.
>
> Yes, you will need to rewrite your application to use tmpfs as direct IO
> calls won't work.  This is something you obviously would rather not do.
>  Which brings us back to Dave's question, which you have not answered:
>
> What exactly is the purpose of your program?  What does it aim to
> accomplish?  Is it for a database application?  A word processor?  Or
> simply a filesystem tester?  What do _you_ aim to accomplish with this
> programming effort?
>
> I'm trying to test the scalability of page cache in the random access
workload. And the cache hit rate is also relatively low.
The cache is now implemented in the user space. When cache misses, I need
to read data from the file system with direct IO.

Da

--20cf303bfd22e48cd504b73c391b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,<br><br><div class=3D"gmail_quote">On Mon, Jan 23, 2012 at 7:34 PM, S=
tan Hoeppner <span dir=3D"ltr">&lt;<a href=3D"mailto:stan@hardwarefreak.com=
">stan@hardwarefreak.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex">
<div class=3D"im">On 1/23/2012 2:51 PM, Zheng Da wrote:<br>
<br>
&gt; tmpfs doesn&#39;t support direct IO.<br>
<br>
</div>Of course not. =A0tmpfs resides entirely within the page cache (or so=
me of<br>
it in swap). =A0The whole point of direct IO is to bypass the page cache,<b=
r>
transferring data directly between user space memory and the storage<br>
device. =A0As tmpfs is built entirely within the page cache, direct IO is<b=
r>
obviously impossible. =A0And it&#39;s also obviously unnecessary.<br>
<br>
Yes, you will need to rewrite your application to use tmpfs as direct IO<br=
>
calls won&#39;t work. =A0This is something you obviously would rather not d=
o.<br>
=A0Which brings us back to Dave&#39;s question, which you have not answered=
:<br>
<br>
What exactly is the purpose of your program? =A0What does it aim to<br>
accomplish? =A0Is it for a database application? =A0A word processor? =A0Or=
<br>
simply a filesystem tester? =A0What do _you_ aim to accomplish with this<br=
>
programming effort?<br><br></blockquote><div>I&#39;m trying to test the sca=
lability of page cache in the random access workload. And the cache hit rat=
e is also relatively low.=A0</div><div>The cache is now implemented in the =
user space. When cache misses, I need to read data from the file system wit=
h direct IO.</div>
<div><br></div><div>Da=A0</div></div><br>

--20cf303bfd22e48cd504b73c391b--


--===============1297484722781215147==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1297484722781215147==--
