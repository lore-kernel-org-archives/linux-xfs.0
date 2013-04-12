Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B287229DFA
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 09:48:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A4688F80AC
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 07:48:49 -0700 (PDT)
Received: from mail-ie0-f178.google.com (mail-ie0-f178.google.com
	[209.85.223.178]) by cuda.sgi.com with ESMTP id
	4EsPvN3fLsF8icV9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Apr 2013 07:48:48 -0700 (PDT)
Received: by mail-ie0-f178.google.com with SMTP id bn7so3373535ieb.37
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 07:48:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <516800F7.80502@redhat.com>
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
	<CADFMGuK67G85+J3LAjS=w_nkkSrj7At9HnPLSL-DBO6g0V=ThA@mail.gmail.com>
	<CADFMGuLNmSpA+e2Wo0qS5y2evQM=q_oVJJPf6kZkfAP4jfk=6w@mail.gmail.com>
	<CADFMGuJoar_uKB_Lrq0nKFsbdjyZWFaHXU-ni2ky3sToSQwUSQ@mail.gmail.com>
	<516800F7.80502@redhat.com>
Date: Fri, 12 Apr 2013 22:48:47 +0800
Message-ID: <CADFMGuKH_jYhuxzMQ_4mj_Zv4EgPfpuBYR=fpqBfJPWf=POJPQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============4279568830986343699=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4279568830986343699==
Content-Type: multipart/alternative; boundary=14dae93408652587d804da2b0054

--14dae93408652587d804da2b0054
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi Brian,

Your scripts works for me now after I installed all the rpm built out from
kernel srpm. I'll try it. Thank you.


2013/4/12 Brian Foster <bfoster@redhat.com>

> On 04/12/2013 04:32 AM, =B7=FB=D3=C0=CC=CE wrote:
> > Dear xfs experts,
> > Can I just call xfs_stack_trace(); in the second line of
> > xfs_do_force_shutdown() to print stack and rebuild kernel to check
> > what's the error?
> >
>
> I suppose that's a start. If you're willing/able to create and run a
> modified kernel for the purpose of collecting more debug info, perhaps
> we can get a bit more creative in collecting more data on the problem
> (but a stack trace there is a good start).
>
> BTW- you might want to place the call after the XFS_FORCED_SHUTDOWN(mp)
> check almost halfway into the function to avoid duplicate messages.
>
> Brian
>
> >
> > 2013/4/12 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtaofu@gma=
il.com>>
> >
> >     Hi Brian,
> >     What else I'm missing? Thank you.
> >     stap -e 'probe module("xfs").function("xfs_iunlink"){}'
> >
> >     WARNING: cannot find module xfs debuginfo: No DWARF information fou=
nd
> >     semantic error: no match while resolving probe point
> >     module("xfs").function("xfs_iunlink")
> >     Pass 2: analysis failed.  Try again with another '--vp 01' option.
> >
> >
> >     2013/4/12 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtaofu=
@gmail.com>>
> >
> >         ls -l
> >
> /usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.deb=
ug
> >         -r--r--r-- 1 root root 21393024 Apr 12 12:08
> >
> /usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.deb=
ug
> >
> >         rpm -qa|grep  kernel
> >         kernel-headers-2.6.32-279.el6.x86_64
> >         kernel-devel-2.6.32-279.el6.x86_64
> >         kernel-2.6.32-358.el6.x86_64
> >         kernel-debuginfo-common-x86_64-2.6.32-279.el6.x86_64
> >         abrt-addon-kerneloops-2.0.8-6.el6.x86_64
> >         kernel-firmware-2.6.32-358.el6.noarch
> >         kernel-debug-2.6.32-358.el6.x86_64
> >         kernel-debuginfo-2.6.32-279.el6.x86_64
> >         dracut-kernel-004-283.el6.noarch
> >         libreport-plugin-kerneloops-2.0.9-5.el6.x86_64
> >         kernel-devel-2.6.32-358.el6.x86_64
> >         kernel-2.6.32-279.el6.x86_64
> >
> >         rpm -q kernel-debuginfo
> >         kernel-debuginfo-2.6.32-279.el6.x86_64
> >
> >         rpm -q kernel
> >         kernel-2.6.32-279.el6.x86_64
> >         kernel-2.6.32-358.el6.x86_64
> >
> >         do I need to re probe it?
> >
> >
> >         2013/4/12 Eric Sandeen <sandeen@sandeen.net
> >         <mailto:sandeen@sandeen.net>>
> >
> >             On 4/11/13 11:32 PM, =B7=FB=D3=C0=CC=CE wrote:
> >             > Hi Brian,
> >             > Sorry but when I execute the script it says:
> >             > WARNING: cannot find module xfs debuginfo: No DWARF
> >             information found
> >             > semantic error: no match while resolving probe point
> >             module("xfs").function("xfs_iunlink")
> >             >
> >             > uname -a
> >             > 2.6.32-279.el6.x86_64
> >             > kernel debuginfo has been installed.
> >             >
> >             > Where can I find the correct xfs debuginfo?
> >
> >             it should be in the kernel-debuginfo rpm (of the same
> >             version/release as the kernel rpm you're running)
> >
> >             You should have:
> >
> >
> /usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.deb=
ug
> >
> >             If not, can you show:
> >
> >             # uname -a
> >             # rpm -q kernel
> >             # rpm -q kernel-debuginfo
> >
> >             -Eric
> >
> >
> >
> >
> >
> >         --
> >         =B7=FB=D3=C0=CC=CE
> >
> >
> >
> >
> >     --
> >     =B7=FB=D3=C0=CC=CE
> >
> >
> >
> >
> > --
> > =B7=FB=D3=C0=CC=CE
> >
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> >
>
>


--=20
=B7=FB=D3=C0=CC=CE

--14dae93408652587d804da2b0054
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Brian,<br><br></div>Your scripts works for me now =
after I installed all the rpm built out from kernel srpm. I&#39;ll try it. =
Thank you.<br></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_=
quote">
2013/4/12 Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redh=
at.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</span><br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">
<div class=3D"im">On 04/12/2013 04:32 AM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; Dear xfs experts,<br>
&gt; Can I just call xfs_stack_trace(); in the second line of<br>
&gt; xfs_do_force_shutdown() to print stack and rebuild kernel to check<br>
&gt; what&#39;s the error?<br>
&gt;<br>
<br>
</div>I suppose that&#39;s a start. If you&#39;re willing/able to create an=
d run a<br>
modified kernel for the purpose of collecting more debug info, perhaps<br>
we can get a bit more creative in collecting more data on the problem<br>
(but a stack trace there is a good start).<br>
<br>
BTW- you might want to place the call after the XFS_FORCED_SHUTDOWN(mp)<br>
check almost halfway into the function to avoid duplicate messages.<br>
<br>
Brian<br>
<br>
&gt;<br>
&gt; 2013/4/12 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com=
">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com"=
>yongtaofu@gmail.com</a>&gt;&gt;<br>
<div class=3D"im">&gt;<br>
&gt; &nbsp; &nbsp; Hi Brian,<br>
&gt; &nbsp; &nbsp; What else I&#39;m missing? Thank you.<br>
&gt; &nbsp; &nbsp; stap -e &#39;probe module(&quot;xfs&quot;).function(&quo=
t;xfs_iunlink&quot;){}&#39;<br>
&gt;<br>
&gt; &nbsp; &nbsp; WARNING: cannot find module xfs debuginfo: No DWARF info=
rmation found<br>
&gt; &nbsp; &nbsp; semantic error: no match while resolving probe point<br>
&gt; &nbsp; &nbsp; module(&quot;xfs&quot;).function(&quot;xfs_iunlink&quot;=
)<br>
&gt; &nbsp; &nbsp; Pass 2: analysis failed. &nbsp;Try again with another &#=
39;--vp 01&#39; option.<br>
&gt;<br>
&gt;<br>
</div>&gt; &nbsp; &nbsp; 2013/4/12 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto=
:yongtaofu@gmail.com">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailto:=
yongtaofu@gmail.com">yongtaofu@gmail.com</a>&gt;&gt;<br>
<div class=3D"im">&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; ls -l<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; /usr/lib/debug/lib/modules/2.6.32-279.el6.=
x86_64/kernel/fs/xfs/xfs.ko.debug<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; -r--r--r-- 1 root root 21393024 Apr 12 12:=
08<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; /usr/lib/debug/lib/modules/2.6.32-279.el6.=
x86_64/kernel/fs/xfs/xfs.ko.debug<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; rpm -qa|grep &nbsp;kernel<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-headers-2.6.32-279.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-devel-2.6.32-279.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-2.6.32-358.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-debuginfo-common-x86_64-2.6.32-279.=
el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; abrt-addon-kerneloops-2.0.8-6.el6.x86_64<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-firmware-2.6.32-358.el6.noarch<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-debug-2.6.32-358.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-debuginfo-2.6.32-279.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; dracut-kernel-004-283.el6.noarch<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; libreport-plugin-kerneloops-2.0.9-5.el6.x8=
6_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-devel-2.6.32-358.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-2.6.32-279.el6.x86_64<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; rpm -q kernel-debuginfo<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-debuginfo-2.6.32-279.el6.x86_64<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; rpm -q kernel<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-2.6.32-279.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-2.6.32-358.el6.x86_64<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; do I need to re probe it?<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; 2013/4/12 Eric Sandeen &lt;<a href=3D"mail=
to:sandeen@sandeen.net">sandeen@sandeen.net</a><br>
</div>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:sandeen=
@sandeen.net">sandeen@sandeen.net</a>&gt;&gt;<br>
<div class=3D"HOEnZb"><div class=3D"h5">&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; On 4/11/13 11:32 PM, =B7=FB=
=D3=C0=CC=CE wrote:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Hi Brian,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Sorry but when I execut=
e the script it says:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; WARNING: cannot find mo=
dule xfs debuginfo: No DWARF<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; information found<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; semantic error: no matc=
h while resolving probe point<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; module(&quot;xfs&quot;).func=
tion(&quot;xfs_iunlink&quot;)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; uname -a<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; 2.6.32-279.el6.x86_64<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; kernel debuginfo has be=
en installed.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Where can I find the co=
rrect xfs debuginfo?<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; it should be in the kernel-d=
ebuginfo rpm (of the same<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; version/release as the kerne=
l rpm you&#39;re running)<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; You should have:<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /usr/lib/debug/lib/modules/2=
.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.debug<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; If not, can you show:<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # uname -a<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # rpm -q kernel<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # rpm -q kernel-debuginfo<br=
>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; -Eric<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
</div></div><div class=3D"HOEnZb"><div class=3D"h5">&gt; __________________=
_____________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt;<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=
=C0=CC=CE
</div>

--14dae93408652587d804da2b0054--


--===============4279568830986343699==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4279568830986343699==--
