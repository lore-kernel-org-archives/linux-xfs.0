Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AFA0D7FA9
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2015 03:54:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83A78304048
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2015 01:54:17 -0700 (PDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
	[209.85.212.169]) by cuda.sgi.com with ESMTP id
	sOpxcrDXeDplqeIa (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jul 2015 01:54:12 -0700 (PDT)
Received: by wicgb10 with SMTP id gb10so88032128wic.1
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2015 01:54:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150720151256.GA17816@bfoster.bfoster>
References: <CA++_uhu=VNKtjax_JjsCZwDFT0Vk-CAjS5j=ba5+A5HL4nxpmA@mail.gmail.com>
	<20150709183255.GG63282@bfoster.bfoster>
	<CA++_uht5N6MtqUQfbB9A3R__UvR4aLN2q5-mFKiO__vU-Cxwpw@mail.gmail.com>
	<20150713125214.GA50787@bfoster.bfoster>
	<CA++_uhvrDBuP9nANTc0ZxZudDriYKrrtnaQUZzXPRLs0otD22w@mail.gmail.com>
	<20150713170158.GB50787@bfoster.bfoster>
	<CA++_uhvDrO2BmQ+q0bN=M_L-vUUaLZO9bHoKh0ntFveM5t-DNQ@mail.gmail.com>
	<CA++_uhuJNkO4MDyS_+veFpysGyqzhqLspB3g73DtUCQqK1F80Q@mail.gmail.com>
	<20150720114648.GB53450@bfoster.bfoster>
	<CA++_uhvwR1KucdHWnPzS5ysFuYyssFnUB95kS-piC_pRnq=dXw@mail.gmail.com>
	<20150720151256.GA17816@bfoster.bfoster>
Date: Wed, 22 Jul 2015 16:54:11 +0800
Message-ID: <CA++_uhu-2Eq02WAvzDo=TQBZzMmAmfAn4H1gPnDZGV+JsqAHWw@mail.gmail.com>
Subject: Re: Data can't be wrote to XFS RIP [<ffffffffa041a99a>]
	xfs_dir2_sf_get_parent_ino+0xa/0x20
From: Kuo Hugo <tonytkdk@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3561209290032458346=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Hugo Kuo <hugo@swiftstack.com>, Eric Sandeen <sandeen@sandeen.net>, Darrell Bishop <darrell@swiftstack.com>, xfs@oss.sgi.com

--===============3561209290032458346==
Content-Type: multipart/alternative; boundary=047d7b4724e21bc373051b72eab9

--047d7b4724e21bc373051b72eab9
Content-Type: text/plain; charset=UTF-8

Hi Brain,

>The original stacktrace shows the crash in a readdir request. I'm sure
>there are multiple things going on here (and there are a couple rename
>traces in the vmcore sitting on locks), of course, but where does the
>information about the rename come from?

I tracked source code of the application. It moves data to a quarantined
area(another folder on same disk) under some conditions. In the bug report,
it indicates a condition that DELETE(create empty file in a directory)
object + list the directory will cause data MOVE (os.rename) to quarantined
area(another folder). The os.rename function call is the only function of
the application to touch quarantined folder.

>I'm not quite following here because I don't have enough context about
>what the application server is doing. So far, it sounds like we somehow
>have multiple threads competing to rename the same file..? Is there
>anything else in this directory at the time this sequence executes
>(e.g., a file with object data that also gets quarantined)?

The previous behavior (a bug in the application) should not trigger Kernel
panic. Yes, there's multiple threads competing to DELETE(create a empty
file) in the same directory also move the existing one to the quarantined
area. I think this is the root cause of kernel panic. The scenario is 10
application workers raise 10 thread to do same thing in the same moment.

>Ideally, we'd ultimately like to translate this into a sequence of
>operations as seen by the fs that hopefully trigger the problem. We
>might have to start by reproducing through the application server.
>Looking back at that bug report, it sounds like a 'DELETE' is a
>high-level server operation that can consist of multiple sub-operations
>at the filesystem level (e.g., list, conditional rename if *.ts file
>exists, etc.). Do you have enough information through any of the above
>to try and run something against Swift that might explicitly reproduce
>the problem? For example, have one thread that creates and recreates the
>same object repeatedly and many more competing threads that try to
>remove (or whatever results in the quarantine) it? Note that I'm just
>grasping at straws here, you might be able to design a more accurate
>reproducer based on what it looks like is happening within Swift.

We observe this issue on production cluster. It's hard to have a free gear
with 100% same HW to test it currently.
I'll try to figure out an approach to reproduce it. I'll update this mail
thread if I can make it.

Thanks // Hugo

--047d7b4724e21bc373051b72eab9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><span style=3D"font-size:14px">=
Hi Brain,</span></div><div class=3D"gmail_extra"><span style=3D"font-size:1=
4px"><br></span></div><div class=3D"gmail_extra"><span style=3D"font-size:1=
4px">&gt;The original stacktrace shows the crash in a readdir request. I&#3=
9;m sure</span><br style=3D"font-size:14px"><span style=3D"font-size:14px">=
&gt;there are multiple things going on here (and there are a couple rename<=
/span><br style=3D"font-size:14px"><span style=3D"font-size:14px">&gt;trace=
s in the vmcore sitting on locks), of course, but where does the</span><br =
style=3D"font-size:14px"><span style=3D"font-size:14px">&gt;information abo=
ut the rename come from?</span><br></div><div class=3D"gmail_extra"><span s=
tyle=3D"font-size:14px"><br></span></div><div class=3D"gmail_extra"><span s=
tyle=3D"font-size:14px">I tracked source code of the application. It moves =
data to a quarantined area(another folder on same disk) under some conditio=
ns. In the bug report, it indicates a condition that DELETE(create empty fi=
le in a directory) object + list the directory will cause data MOVE (os.ren=
ame) to quarantined area(another folder). The os.rename function call is th=
e only function of the application to touch quarantined folder.=C2=A0</span=
></div><div class=3D"gmail_extra"><span style=3D"font-size:14px"><br></span=
></div><div class=3D"gmail_extra"><span style=3D"font-size:14px">&gt;I&#39;=
m not quite following here because I don&#39;t have enough context about</s=
pan><br style=3D"font-size:14px"><span style=3D"font-size:14px">&gt;what th=
e application server is doing. So far, it sounds like we somehow</span><br =
style=3D"font-size:14px"><span style=3D"font-size:14px">&gt;have multiple t=
hreads competing to rename the same file..? Is there</span><br style=3D"fon=
t-size:14px"><span style=3D"font-size:14px">&gt;anything else in this direc=
tory at the time this sequence executes</span><br style=3D"font-size:14px">=
<span style=3D"font-size:14px">&gt;(e.g., a file with object data that also=
 gets quarantined)?</span><br style=3D"font-size:14px"><br>The previous beh=
avior (a bug in the application) should not trigger Kernel panic. Yes, ther=
e&#39;s multiple threads competing to DELETE(create a empty file) in the sa=
me directory also move the existing one to the quarantined area. I think th=
is is the root cause of kernel panic. The scenario is 10 application worker=
s raise 10 thread to do same thing in the same moment.=C2=A0<br><br style=
=3D"font-size:14px"><span style=3D"font-size:14px">&gt;Ideally, we&#39;d ul=
timately like to translate this into a sequence of</span><br style=3D"font-=
size:14px"><span style=3D"font-size:14px">&gt;operations as seen by the fs =
that hopefully trigger the problem. We</span><br style=3D"font-size:14px"><=
span style=3D"font-size:14px">&gt;might have to start by reproducing throug=
h the application server.</span><br style=3D"font-size:14px"><span style=3D=
"font-size:14px">&gt;Looking back at that bug report, it sounds like a &#39=
;DELETE&#39; is a</span><br style=3D"font-size:14px"><span style=3D"font-si=
ze:14px">&gt;high-level server operation that can consist of multiple sub-o=
perations</span><br style=3D"font-size:14px"><span style=3D"font-size:14px"=
>&gt;at the filesystem level (e.g., list, conditional rename if *.ts file</=
span><br style=3D"font-size:14px"><span style=3D"font-size:14px">&gt;exists=
, etc.). Do you have enough information through any of the above</span><br =
style=3D"font-size:14px"><span style=3D"font-size:14px">&gt;to try and run =
something against Swift that might explicitly reproduce</span><br style=3D"=
font-size:14px"><span style=3D"font-size:14px">&gt;the problem? For example=
, have one thread that creates and recreates the</span><br style=3D"font-si=
ze:14px"><span style=3D"font-size:14px">&gt;same object repeatedly and many=
 more competing threads that try to</span><br style=3D"font-size:14px"><spa=
n style=3D"font-size:14px">&gt;remove (or whatever results in the quarantin=
e) it? Note that I&#39;m just</span><br style=3D"font-size:14px"><span styl=
e=3D"font-size:14px">&gt;grasping at straws here, you might be able to desi=
gn a more accurate</span><br style=3D"font-size:14px"><span style=3D"font-s=
ize:14px">&gt;reproducer based on what it looks like is happening within Sw=
ift.</span><span style=3D"font-size:14px"><br></span></div><div class=3D"gm=
ail_extra"><span style=3D"font-size:14px"><br></span></div><div class=3D"gm=
ail_extra"><span style=3D"font-size:14px">We observe this issue on producti=
on cluster. It&#39;s hard to have a free gear with 100% same HW to test it =
currently.=C2=A0</span></div><div class=3D"gmail_extra"><span style=3D"font=
-size:14px">I&#39;ll try to figure out an approach to reproduce it. I&#39;l=
l update this mail thread if I can make it.=C2=A0</span></div><div class=3D=
"gmail_extra"><span style=3D"font-size:14px"><br></span></div><div class=3D=
"gmail_extra"><span style=3D"font-size:14px">Thanks // Hugo</span></div><di=
v class=3D"gmail_extra"><span style=3D"font-size:14px"><br></span></div></d=
iv>

--047d7b4724e21bc373051b72eab9--


--===============3561209290032458346==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3561209290032458346==--
