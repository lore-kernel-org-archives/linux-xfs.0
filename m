Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 68DC37F88
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 09:26:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5672E304032
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 07:26:30 -0700 (PDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
	[209.85.212.179]) by cuda.sgi.com with ESMTP id
	olcA5aJtkvkp3R3E (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 07:26:26 -0700 (PDT)
Received: by wicfx3 with SMTP id fx3so21897702wic.1
	for <xfs@oss.sgi.com>; Thu, 03 Sep 2015 07:26:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55E8498F.8090508@sandeen.net>
References: <CAC=x_0hAQR9Ynmnqohv1R8xv3TBot5wmn7DODx6GbKU7tYv2sA@mail.gmail.com>
	<55E8498F.8090508@sandeen.net>
Date: Thu, 3 Sep 2015 17:26:25 +0300
Message-ID: <CAC=x_0iUc2VEfW9qChuvUpDk5Kz=wvRGH-1w6sS0XP6CG_ERBQ@mail.gmail.com>
Subject: Re: xfs corruption
From: Danny Shavit <danny@zadarastorage.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2697614533167158595=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

--===============2697614533167158595==
Content-Type: multipart/alternative; boundary=f46d04388e0d773c3f051ed891fa

--f46d04388e0d773c3f051ed891fa
Content-Type: text/plain; charset=UTF-8

Hi Eric,

Thanks for the prompt response.
Sorry for the missing parts, I was wrongly assuming that everybody knows
our environment :-)

More information:
uname -a:  Linux vsa-00000142 3.8.13-030813-generic #201305111843 SMP Sat
May 11 22:44:40 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
xfs_repair version 3.1.7

We are using modified xfs. Mainly, added some reporting features and
changed discard operation to be aligned with chunk sizes used in our
systems.
The modified code resides at  https://github.com/zadarastora
<https://github.com/zadarastorage/zadara-xfs-pushback>ge/zadara-xfs-pushback
<https://github.com/zadarastorage/zadara-xfs-pushback>.

We were in a hurry at the time we run xfs_repair with -L. Was not so
smart...
Any way, the xfs_dump was taken before running xfs_repair.
We will use the original xfs meta data to run xfs_repair after mount and
get back with the results.

Regards,
Danny




On Thu, Sep 3, 2015 at 4:22 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 9/3/15 6:09 AM, Danny Shavit wrote:
> > Hi Dave,
> >
> > We couple of more xfs corruption that we would like to share:
>
> On the same box as the one that seemed to be experiencing some
> bit-flips in your earlier email?
>
> As a general note: You are not providing enough information for
> us to effectively help you.
>
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> Kernel version?  xfsprogs version?  At a bare minimum...
>
> Your dmesg snippets are edited.  You've provided what you feel is
> important, omitting the parts that may actually be important or
> informational.
>
> You haven't described the sequence of events that led to these issues.
>
> You haven't made clear what these attachments are; which repair log goes
> with which kernel event?
>
> Etc...
>
> > 1. This is an interesting one, since xfs reported corruption but when
> > running xfs_repair, no error was found. Attached is the kernel log
> > section regarding the corruption (6458). Does xfs_repair explicitly
> > read data from the disk? In such case it might be a memory
> > corruption. Are you familiar with such cases?
>
> Yes, xfs_repair opens the block device O_DIRECT.
>
> your 6485-kernel.log shows a failure in xfs_allocbt_verify(), right
> after the allocation btree is read from disk.  i.e. this is an in-kernel
> metadata consistency check that is failing.
>
> It also shows:
>
> kworker/0:1H Tainted: GF       W
>
> So it's tainted:
>
>   2: 'F' if any module was force loaded by "insmod -f", ' ' if all
>      modules were loaded normally.
>
>  10: 'W' if a warning has previously been issued by the kernel.
>      (Though some warnings may set more specific taint flags.)
>
> You force-loaded a module?  And previous warnings were emitted (though we
> can't see them in your edited dmesg).
> All bets are off.  If you had included the full dmesg, we might know
> more about what's going on, at least.
>
> > 2. xfs corruption occurred suddenly with no apparent external event.
> >  Attached are xfs_repair and kernel logs are. Xfs dump can be found
> > in: https://zadarastorage-public.s3.amazonaws.com/xfs/82.metadump.gz
>
> Your 6442-82-xfs_repair.log is from an xfs_repair -L, so of course it
> is finding corruption, and the output is more or less meaningless
> from a triage POV.  Repair said:
>
> > Note that destroying the log may cause corruption -- please attempt a
> mount
> > of the filesystem before doing this.
>
> Why did you run it with -L? Did mount fail? If so how?
>
> dm-82-kernel.log also shows a failing verifier, this time xfs_bmbt_verify,
> when reading metadata from disk.
>
> You've truncated other parts, though:
>
> Aug 22 23:24:48 vsa-00000110-vc-0 kernel: [4194599.685353]
> ffff88010ec36000: ea bb 12 3a 5f 44 01 a8 b9 2a 80 10 b3 a7 d5 af
> ...:_D...*
> ......
>
> so there's not a ton to go on, just hints that there is more information
> that's not provided.
>
>
> -Eric
>



-- 
Regards,
Danny

--f46d04388e0d773c3f051ed891fa
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Eric,<div><br></div><div>Thanks for the prompt response=
.</div><div>Sorry for the missing parts, I was wrongly assuming that everyb=
ody knows our environment :-)</div><div><br></div><div>More information:<br=
></div><div><div>uname -a: =C2=A0Linux vsa-00000142 3.8.13-030813-generic #=
201305111843 SMP Sat May 11 22:44:40 UTC 2013 x86_64 x86_64 x86_64 GNU/Linu=
x</div></div><div>xfs_repair version 3.1.7<br></div><div><div><br></div><di=
v>We are using modified xfs. Mainly, added some reporting features and chan=
ged discard operation to be aligned with chunk sizes used in our systems.</=
div><div>The modified code resides at=C2=A0<span style=3D"font-size:12.8000=
001907349px">=C2=A0<a href=3D"https://github.com/zadarastorage/zadara-xfs-p=
ushback" rel=3D"noreferrer" target=3D"_blank" style=3D"font-size:12.8000001=
907349px">https://github.com/zadarastora</a></span><a href=3D"https://githu=
b.com/zadarastorage/zadara-xfs-pushback" rel=3D"noreferrer" target=3D"_blan=
k" style=3D"font-size:12.8000001907349px"><span style=3D"font-size:12.80000=
01907349px">ge/zadara-xfs-</span><span class=3D"" style=3D"font-size:12.800=
0001907349px">pushback</span></a>.</div></div><div><br></div><div>We were i=
n a hurry at the time we run xfs_repair with -L. Was not so smart...</div><=
div>Any way, the xfs_dump was taken before running xfs_repair.</div><div>We=
 will use the original xfs meta data to run xfs_repair after mount and get =
back with the results.</div><div><br></div><div>Regards,</div><div>Danny</d=
iv><div><br></div><div><br></div><div><br></div></div><div class=3D"gmail_e=
xtra"><br><div class=3D"gmail_quote">On Thu, Sep 3, 2015 at 4:22 PM, Eric S=
andeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex"><span class=3D"">On 9/3/15 6:09 AM, Danny Shavit wrote:<br>
&gt; Hi Dave,<br>
&gt;<br>
&gt; We couple of more xfs corruption that we would like to share:<br>
<br>
</span>On the same box as the one that seemed to be experiencing some<br>
bit-flips in your earlier email?<br>
<br>
As a general note: You are not providing enough information for<br>
us to effectively help you.<br>
<br>
<a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_in=
clude_when_reporting_a_problem.3F" rel=3D"noreferrer" target=3D"_blank">htt=
p://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_rep=
orting_a_problem.3F</a><br>
<br>
Kernel version?=C2=A0 xfsprogs version?=C2=A0 At a bare minimum...<br>
<br>
Your dmesg snippets are edited.=C2=A0 You&#39;ve provided what you feel is<=
br>
important, omitting the parts that may actually be important or<br>
informational.<br>
<br>
You haven&#39;t described the sequence of events that led to these issues.<=
br>
<br>
You haven&#39;t made clear what these attachments are; which repair log goe=
s<br>
with which kernel event?<br>
<br>
Etc...<br>
<span class=3D""><br>
&gt; 1. This is an interesting one, since xfs reported corruption but when<=
br>
&gt; running xfs_repair, no error was found. Attached is the kernel log<br>
&gt; section regarding the corruption (6458). Does xfs_repair explicitly<br=
>
&gt; read data from the disk? In such case it might be a memory<br>
&gt; corruption. Are you familiar with such cases?<br>
<br>
</span>Yes, xfs_repair opens the block device O_DIRECT.<br>
<br>
your 6485-kernel.log shows a failure in xfs_allocbt_verify(), right<br>
after the allocation btree is read from disk.=C2=A0 i.e. this is an in-kern=
el<br>
metadata consistency check that is failing.<br>
<br>
It also shows:<br>
<br>
kworker/0:1H Tainted: GF=C2=A0 =C2=A0 =C2=A0 =C2=A0W<br>
<br>
So it&#39;s tainted:<br>
<br>
=C2=A0 2: &#39;F&#39; if any module was force loaded by &quot;insmod -f&quo=
t;, &#39; &#39; if all<br>
=C2=A0 =C2=A0 =C2=A0modules were loaded normally.<br>
<br>
=C2=A010: &#39;W&#39; if a warning has previously been issued by the kernel=
.<br>
=C2=A0 =C2=A0 =C2=A0(Though some warnings may set more specific taint flags=
.)<br>
<br>
You force-loaded a module?=C2=A0 And previous warnings were emitted (though=
 we<br>
can&#39;t see them in your edited dmesg).<br>
All bets are off.=C2=A0 If you had included the full dmesg, we might know<b=
r>
more about what&#39;s going on, at least.<br>
<span class=3D""><br>
&gt; 2. xfs corruption occurred suddenly with no apparent external event.<b=
r>
&gt;=C2=A0 Attached are xfs_repair and kernel logs are. Xfs dump can be fou=
nd<br>
&gt; in: <a href=3D"https://zadarastorage-public.s3.amazonaws.com/xfs/82.me=
tadump.gz" rel=3D"noreferrer" target=3D"_blank">https://zadarastorage-publi=
c.s3.amazonaws.com/xfs/82.metadump.gz</a><br>
<br>
</span>Your 6442-82-xfs_repair.log is from an xfs_repair -L, so of course i=
t<br>
is finding corruption, and the output is more or less meaningless<br>
from a triage POV.=C2=A0 Repair said:<br>
<br>
&gt; Note that destroying the log may cause corruption -- please attempt a =
mount<br>
&gt; of the filesystem before doing this.<br>
<br>
Why did you run it with -L? Did mount fail? If so how?<br>
<br>
dm-82-kernel.log also shows a failing verifier, this time xfs_bmbt_verify,<=
br>
when reading metadata from disk.<br>
<br>
You&#39;ve truncated other parts, though:<br>
<br>
Aug 22 23:24:48 vsa-00000110-vc-0 kernel: [4194599.685353] ffff88010ec36000=
: ea bb 12 3a 5f 44 01 a8 b9 2a 80 10 b3 a7 d5 af=C2=A0 ...:_D...*<br>
......<br>
<br>
so there&#39;s not a ton to go on, just hints that there is more informatio=
n<br>
that&#39;s not provided.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
-Eric<br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div class=3D"gmail_signature"><div dir=3D"ltr"><div>Regards,<br></div>Da=
nny<br></div></div>
</div>

--f46d04388e0d773c3f051ed891fa--


--===============2697614533167158595==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2697614533167158595==--
