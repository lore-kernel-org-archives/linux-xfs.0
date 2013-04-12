Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 690367F37
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 00:41:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 29B4B8F808F
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 22:41:02 -0700 (PDT)
Received: from mail-ia0-f174.google.com (mail-ia0-f174.google.com
	[209.85.210.174]) by cuda.sgi.com with ESMTP id
	0cPXBn5sw8yhUPRc (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 22:41:00 -0700 (PDT)
Received: by mail-ia0-f174.google.com with SMTP id r13so2053613iar.5
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 22:41:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <516798AE.9050908@sandeen.net>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
	<CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
	<CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
	<20130410121025.78a42b22@harpe.intellique.com>
	<CADFMGu+yCg4ux0n6S98bqm_cXc=VCcijVBTqwRxvxmtKt_JO-A@mail.gmail.com>
	<CADFMGuLxgBFU=FUK94tPsCh+qxRW0rEELxSXYoMQLFJ1u3=q0Q@mail.gmail.com>
	<516746AC.3090808@redhat.com>
	<CADFMGuK-tJQFQzN9wN0LiWWj6SY4tg_c0W9dJadctg=ytegB+w@mail.gmail.com>
	<516798AE.9050908@sandeen.net>
Date: Fri, 12 Apr 2013 13:40:59 +0800
Message-ID: <CADFMGuK67G85+J3LAjS=w_nkkSrj7At9HnPLSL-DBO6g0V=ThA@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6539749541867028272=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6539749541867028272==
Content-Type: multipart/alternative; boundary=047d7bd75dec1563e204da2359d0

--047d7bd75dec1563e204da2359d0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

ls -l
/usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.debug
-r--r--r-- 1 root root 21393024 Apr 12 12:08
/usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.debug

rpm -qa|grep  kernel
kernel-headers-2.6.32-279.el6.x86_64
kernel-devel-2.6.32-279.el6.x86_64
kernel-2.6.32-358.el6.x86_64
kernel-debuginfo-common-x86_64-2.6.32-279.el6.x86_64
abrt-addon-kerneloops-2.0.8-6.el6.x86_64
kernel-firmware-2.6.32-358.el6.noarch
kernel-debug-2.6.32-358.el6.x86_64
kernel-debuginfo-2.6.32-279.el6.x86_64
dracut-kernel-004-283.el6.noarch
libreport-plugin-kerneloops-2.0.9-5.el6.x86_64
kernel-devel-2.6.32-358.el6.x86_64
kernel-2.6.32-279.el6.x86_64

rpm -q kernel-debuginfo
kernel-debuginfo-2.6.32-279.el6.x86_64

rpm -q kernel
kernel-2.6.32-279.el6.x86_64
kernel-2.6.32-358.el6.x86_64

do I need to re probe it?


2013/4/12 Eric Sandeen <sandeen@sandeen.net>

> On 4/11/13 11:32 PM, =B7=FB=D3=C0=CC=CE wrote:
> > Hi Brian,
> > Sorry but when I execute the script it says:
> > WARNING: cannot find module xfs debuginfo: No DWARF information found
> > semantic error: no match while resolving probe point
> module("xfs").function("xfs_iunlink")
> >
> > uname -a
> > 2.6.32-279.el6.x86_64
> > kernel debuginfo has been installed.
> >
> > Where can I find the correct xfs debuginfo?
>
> it should be in the kernel-debuginfo rpm (of the same version/release as
> the kernel rpm you're running)
>
> You should have:
>
> /usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.deb=
ug
>
> If not, can you show:
>
> # uname -a
> # rpm -q kernel
> # rpm -q kernel-debuginfo
>
> -Eric
>
>
>


--=20
=B7=FB=D3=C0=CC=CE

--047d7bd75dec1563e204da2359d0
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>ls -l /usr/lib/debug/lib/modules/2.6.32-279.el6.x86_6=
4/kernel/fs/xfs/xfs.ko.debug<br>-r--r--r-- 1 root root 21393024 Apr 12 12:0=
8 /usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.deb=
ug<br>
<br>rpm -qa|grep&nbsp; kernel<br>kernel-headers-2.6.32-279.el6.x86_64<br>ke=
rnel-devel-2.6.32-279.el6.x86_64<br>kernel-2.6.32-358.el6.x86_64<br>kernel-=
debuginfo-common-x86_64-2.6.32-279.el6.x86_64<br>abrt-addon-kerneloops-2.0.=
8-6.el6.x86_64<br>
kernel-firmware-2.6.32-358.el6.noarch<br>kernel-debug-2.6.32-358.el6.x86_64=
<br>kernel-debuginfo-2.6.32-279.el6.x86_64<br>dracut-kernel-004-283.el6.noa=
rch<br>libreport-plugin-kerneloops-2.0.9-5.el6.x86_64<br>kernel-devel-2.6.3=
2-358.el6.x86_64<br>
kernel-2.6.32-279.el6.x86_64<br><br>rpm -q kernel-debuginfo<br>kernel-debug=
info-2.6.32-279.el6.x86_64<br><br>rpm -q kernel<br>kernel-2.6.32-279.el6.x8=
6_64<br>kernel-2.6.32-358.el6.x86_64<br><br></div>do I need to re probe it?=
<br>
</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/4/=
12 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net=
" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span><br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"im">On 4/11/13 11:32 PM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; Hi Brian,<br>
&gt; Sorry but when I execute the script it says:<br>
&gt; WARNING: cannot find module xfs debuginfo: No DWARF information found<=
br>
&gt; semantic error: no match while resolving probe point module(&quot;xfs&=
quot;).function(&quot;xfs_iunlink&quot;)<br>
&gt;<br>
&gt; uname -a<br>
&gt; 2.6.32-279.el6.x86_64<br>
&gt; kernel debuginfo has been installed.<br>
&gt;<br>
&gt; Where can I find the correct xfs debuginfo?<br>
<br>
</div>it should be in the kernel-debuginfo rpm (of the same version/release=
 as the kernel rpm you&#39;re running)<br>
<br>
You should have:<br>
<br>
/usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.debug=
<br>
<br>
If not, can you show:<br>
<br>
# uname -a<br>
# rpm -q kernel<br>
# rpm -q kernel-debuginfo<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Eric<br>
<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=
=C0=CC=CE
</div>

--047d7bd75dec1563e204da2359d0--


--===============6539749541867028272==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6539749541867028272==--
