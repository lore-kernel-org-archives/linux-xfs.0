Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6398929DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 10:12:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F32A3AC001
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 08:11:56 -0700 (PDT)
Received: from mail-lb0-f169.google.com (mail-lb0-f169.google.com
	[209.85.217.169]) by cuda.sgi.com with ESMTP id
	VK9A2Xb0WURPyHa1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 May 2013 08:11:55 -0700 (PDT)
Received: by mail-lb0-f169.google.com with SMTP id z5so3176590lbh.0
	for <xfs@oss.sgi.com>; Thu, 09 May 2013 08:11:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130508233910.GL24635@dastard>
References: <CADNx=KsT9DC=vveyTZx8EovddFx9mhRS-yzygaORHZ_4VyXfzQ@mail.gmail.com>
	<5187BF8A.2040303@sandeen.net>
	<CADNx=KvZPhbRn9Kc3+KdoAY7jZ3U0uyG6wgUB5vcxX85CkFdQg@mail.gmail.com>
	<CADNx=Kv0bt3fNGW8Y24GziW9MOO-+b7fBGub4AYP70b5gAegxw@mail.gmail.com>
	<5188FF88.6000508@sandeen.net>
	<CADNx=KvmA7jgqBUO0YvKddHvFaqxHNZKfF3eWajOW8GWKwNhbA@mail.gmail.com>
	<CADNx=Kv=7TFkJKom6_JM8B+A6YRckj175TbCcHrTWYL_N-qkYw@mail.gmail.com>
	<CADNx=KvxtCHEk9G07yS88-casVAXBxRTghV5nGKd_0LtcqpYpQ@mail.gmail.com>
	<20130508233910.GL24635@dastard>
From: Filippo Stenico <filippo.stenico@gmail.com>
Date: Thu, 9 May 2013 17:11:13 +0200
Message-ID: <CADNx=KuvQ1u+i+PgaCUqLbeGA0-8yfaCP=pez7ptGdm2pL_oGw@mail.gmail.com>
Subject: Re: Xfs_repair segfaults.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4594458395497388150=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============4594458395497388150==
Content-Type: multipart/alternative; boundary=001a11c36d9e78bc9304dc4a78cb

--001a11c36d9e78bc9304dc4a78cb
Content-Type: text/plain; charset=ISO-8859-1

On Thu, May 9, 2013 at 1:39 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, May 08, 2013 at 07:30:05PM +0200, Filippo Stenico wrote:
> > Hello,
> > -m option seems not to handle the excessive memory consumption I ran
> into.
> > I actually ran xfs_repair -vv -m1750 and  looking into kern.log it  seems
> > that xfs_repair invoked oom killer, but was killed itself ( !! )
>
> That's exactly what the oom killer is supposed to do.
>
> Yeah, some sacrifice needed.


> > This is last try to reproduce segfault:
> > xfs_repair -vv -P -m1750
>
> I know your filesystem is around 7TB in size, but how much RAM do
> you have? It's not unusual for xfs_repair to require many GB of
> memory to run succesfully on filesystems of this size...
>
> it is around 11 TB, 7.2 used.
I have 4 G ram, but xfs_repair -vv -m1 says I need 1558
root@ws1000:~# xfs_repair -vv -P -m 1 /dev/mapper/vg0-lv0
Phase 1 - find and verify superblock...
        - max_mem = 1024, icount = 29711040, imem = 116058, dblock =
2927886336, dmem = 1429632
Required memory for repair is greater that the maximum specified
with the -m option. Please increase it to at least 1558.

so I figured 1750 megs would be enough

Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



-- 
F

--001a11c36d9e78bc9304dc4a78cb
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Thu, May 9, 2013 at 1:39 AM, Dave Chi=
nner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D=
"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"=
gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-=
left:1ex">


<div>On Wed, May 08, 2013 at 07:30:05PM +0200, Filippo Stenico wrote:<br>
&gt; Hello,<br>
&gt; -m option seems not to handle the excessive memory consumption I ran i=
nto.<br>
&gt; I actually ran xfs_repair -vv -m1750 and =A0looking into kern.log it =
=A0seems<br>
&gt; that xfs_repair invoked oom killer, but was killed itself ( !! )<br>
<br>
</div>That&#39;s exactly what the oom killer is supposed to do.<br>
<div><br></div></blockquote><div>Yeah, some sacrifice needed.<br>=A0<br></d=
iv><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left=
:1px #ccc solid;padding-left:1ex"><div>
&gt; This is last try to reproduce segfault:<br>
&gt; xfs_repair -vv -P -m1750<br>
<br>
</div>I know your filesystem is around 7TB in size, but how much RAM do<br>
you have? It&#39;s not unusual for xfs_repair to require many GB of<br>
memory to run succesfully on filesystems of this size...<br>
<br></blockquote><div>it is around 11 TB, 7.2 used.<br>I have 4 G ram, but =
xfs_repair -vv -m1 says I need 1558<br>root@ws1000:~# xfs_repair -vv -P -m =
1 /dev/mapper/vg0-lv0 <br>Phase 1 - find and verify superblock...<br>=A0=A0=
=A0=A0=A0=A0=A0 - max_mem =3D 1024, icount =3D 29711040, imem =3D 116058, d=
block =3D 2927886336, dmem =3D 1429632<br>

Required memory for repair is greater that the maximum specified<br>with th=
e -m option. Please increase it to at least 1558.<br><br>so I figured 1750 =
megs would be enough<br><br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">


Cheers,<br>
<br>
Dave.<br>
<span><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
</font></span><div><div><br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a><br=
>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>F

--001a11c36d9e78bc9304dc4a78cb--


--===============4594458395497388150==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4594458395497388150==--
