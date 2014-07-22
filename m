Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CCC487F3F
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 16:15:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ABE968F8033
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 14:15:14 -0700 (PDT)
Received: from mx0b-000cda01.pphosted.com (mx0b-00003501.pphosted.com
	[67.231.152.68]) by cuda.sgi.com with ESMTP id 3UJo3PKE94cFHNnM
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Jul 2014 14:15:12 -0700 (PDT)
Received: from pps.filterd (m0004030.ppops.net [127.0.0.1])
	by mx0b-000cda01.pphosted.com (8.14.5/8.14.5) with SMTP id
	s6MLB3a7017228 for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 17:15:10 -0400
Received: from mail-vc0-f171.google.com (mail-vc0-f171.google.com
	[209.85.220.171])
	by mx0b-000cda01.pphosted.com with ESMTP id 1n9we9s513-1
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 17:14:58 -0400
Received: by mail-vc0-f171.google.com with SMTP id hq11so503739vcb.30
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 14:14:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140722205605.GJ20518@dastard>
References: <20140722160641.GU17967@beardog.cce.hp.com>
	<20140722205605.GJ20518@dastard>
Date: Tue, 22 Jul 2014 15:14:42 -0600
Message-ID: <CAK2EqxR93J8441Ajj8no7_Pu1WSDLaVsKG=_FLMYvTnOUEzKGQ@mail.gmail.com>
Subject: Re: Problem building xfsprogs
From: Martin Furuhjelm <martin.furuhjelm@seagate.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5371660556334779223=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: scameron@beardog.cce.hp.com, fstests@vger.kernel.org, xfs@oss.sgi.com

--===============5371660556334779223==
Content-Type: multipart/alternative; boundary=001a11c3b4125bd36704feceb609

--001a11c3b4125bd36704feceb609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have just recently gone through the process of attempting to build and
run xfstests based on the current sources from oss.sgi.com.
Not having exactly the correct packages and kernel version creates
problems. The build on FEDORA fails complaining about too many symlinks, I
was successful on SUSE V 13 updated to kernel v3.15 and adding the
following packages before attempting git and the build:

git gcc libtool automake make gettext-tools libattr-devel libacl-devel
libuuid-devel ncurses-devel quota indent libcap-progs btrfsprogs

I then git and built xfsprogs followed by xfsdump and finally xfstests

After adding the fsgqa group and user the appropriate definitions of
TEST_DEV and SCRATCH_DEV the quick test (./check -g quick)
runs with 5 errors on xfs and one error on ext4.

If you just want xfstest to run - you may want to start with SUSE and the
procedure above.

Martin Furuhjlem

On Tue, Jul 22, 2014 at 2:56 PM, Dave Chinner <david@fromorbit.com> wrote:

> [cc xfs@oss.sgi.com - list for XFS issues]
>
> On Tue, Jul 22, 2014 at 11:06:41AM -0500, scameron@beardog.cce.hp.com
> wrote:
> >
> > I'm trying to build xfsprogs (in order to run xfstests), and I'm runnin=
g
> into this:
> >
> > [scameron@localhost xfsprogs]$ git log --oneline | head -1
> > ba24eb7 logprint: Fix printing of AGF and AGI buffers
> > [scameron@localhost xfsprogs]$ git pull
> > Already up-to-date.
> > [scameron@localhost xfsprogs]$ git diff
> > [scameron@localhost xfsprogs]$ ./configure
> > checking build system type... x86_64-unknown-linux-gnu
> > checking host system type... x86_64-unknown-linux-gnu
> > checking for gcc... gcc
> > checking for C compiler default output file name... a.out
> >
> > [...snip...]
> >
> > checking for library containing blkid_probe_all... -lblkid
> > checking for blkid_probe_get_topology... yes
> > checking for readdir... yes
> > checking size of long... 8
> > checking size of char *... 8
> > checking for __psint_t ... no
> > checking for __psunsigned_t ... no
> > checking for __u32 ... yes
> > checking for umode_t... yes
> > configure: creating ./config.status
> > config.status: creating include/builddefs
> > config.status: creating include/platform_defs.h
> > config.status: include/platform_defs.h is unchanged
> > config.status: executing libtool commands
> > [scameron@localhost xfsprogs]$ make
> > Building include
>
> Nothing built in the include directory - is this a clean build area?
>
> > Building libxfs
> > gmake[2]: *** No rule to make target `.ltdep', needed by `ltdepend'.
>  Stop.
> > gmake[1]: *** [libxfs] Error 2
> > make: *** [default] Error 2
> >
> > Any ideas what's wrong here?
>
> The automatic dependency generation failed to generate the .ltdep
> file. But it can't be a clean build area, because the libxfs build
> rule is:
>
> default: crc32selftest ltdepend $(LTLIBRARY)
>
> and I don't see the crc32selftest rule being executed before the
> dependencies are generated. It shoul dlook something like:
>
> $ make
> ....
> configure: creating ./config.status
> config.status: creating include/builddefs
> config.status: creating include/platform_defs.h
> config.status: executing libtool commands
> Building include
>     [LN]     xfs
>     [LN]     disk
> Building libxfs
>     [CC]     gen_crc32table
>     [GENERATE] crc32table.h
>     [TEST]    CRC32
> CRC_LE_BITS =3D 32
> crc32: tests passed, 225944 bytes in 131 usec
> crc32c: tests passed, 225944 bytes in 131 usec
>     [CC]     cache.lo
> ....
>
> So the first thing I'd do is run 'make realclean; make' to restart
> the build for a clean workarea first. If that doesn't fix the
> problem, then I'll need to know versions of libtool, gcc, etc that
> you are using and you'll need to post the output of "make realclean;
> make Q=3D" so we can see the command line that is actually failing.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at
> https://urldefense.proofpoint.com/v1/url?u=3Dhttp://vger.kernel.org/major=
domo-info.html&k=3D2a4Akkj3oY%2FOkjwft1MTMw%3D%3D%0A&r=3DjY8ozfSdJMiFQxJbqM=
IFvF4Q5MYg6nOaolSGt082e48%3D%0A&m=3DbI0%2F1zZckAg2ytRBSMleHvthTKGuNDtYaUYrC=
%2BGOuV4%3D%0A&s=3D7e28774591d3b095daa0b053b597ecb5e73203b4a403132664165f44=
ac3aaa49
>

--001a11c3b4125bd36704feceb609
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I have just recently gone through the process of attemptin=
g to build and run xfstests based on the current sources from <a href=3D"ht=
tp://oss.sgi.com" target=3D"_blank">oss.sgi.com</a>.<div>Not having exactly=
 the correct packages and kernel version creates problems. The build on FED=
ORA fails complaining about too many symlinks, I was successful on SUSE V 1=
3 updated to kernel v3.15 and adding the following packages before attempti=
ng git and the build:
<div><br></div><div><span><span style=3D"font-size:15px;font-family:&#39;Co=
urier New&#39;;color:rgb(0,0,0);font-weight:bold;vertical-align:baseline;wh=
ite-space:pre-wrap;background-color:transparent">git gcc libtool automake m=
ake gettext-tools libattr-devel libacl-devel libuuid-devel ncurses-devel qu=
ota indent libcap-progs btrfsprogs</span></span><br>

</div><div><span><span style=3D"font-size:15px;font-family:&#39;Courier New=
&#39;;color:rgb(0,0,0);font-weight:bold;vertical-align:baseline;white-space=
:pre-wrap;background-color:transparent"><br></span></span></div><div>I then=
 git and built xfsprogs followed by xfsdump and finally xfstests</div>

<div><br></div><div>After adding the fsgqa group and user the appropriate d=
efinitions of TEST_DEV and SCRATCH_DEV the quick test (<span style=3D"color=
:rgb(0,0,0);font-family:&#39;Courier New&#39;;font-size:15px;font-weight:bo=
ld;white-space:pre-wrap;background-color:transparent">./check -g quick</spa=
n>)</div>

<div>runs with 5 errors on xfs and one error on ext4.</div><div><br></div><=
div>If you just want xfstest to run - you may want to start with SUSE and t=
he procedure above.</div><div><br></div><div>Martin Furuhjlem</div><div>
<br></div><div class=3D"gmail_extra"><div class=3D"gmail_quote">On Tue, Jul=
 22, 2014 at 2:56 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:=
david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> w=
rote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">[cc <a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">x=
fs@oss.sgi.com</a> - list for XFS issues]<br>


<div><div><br>
On Tue, Jul 22, 2014 at 11:06:41AM -0500, <a href=3D"mailto:scameron@beardo=
g.cce.hp.com" target=3D"_blank">scameron@beardog.cce.hp.com</a> wrote:<br>
&gt;<br>
&gt; I&#39;m trying to build xfsprogs (in order to run xfstests), and I&#39=
;m running into this:<br>
&gt;<br>
&gt; [scameron@localhost xfsprogs]$ git log --oneline | head -1<br>
&gt; ba24eb7 logprint: Fix printing of AGF and AGI buffers<br>
&gt; [scameron@localhost xfsprogs]$ git pull<br>
&gt; Already up-to-date.<br>
&gt; [scameron@localhost xfsprogs]$ git diff<br>
&gt; [scameron@localhost xfsprogs]$ ./configure<br>
&gt; checking build system type... x86_64-unknown-linux-gnu<br>
&gt; checking host system type... x86_64-unknown-linux-gnu<br>
&gt; checking for gcc... gcc<br>
&gt; checking for C compiler default output file name... a.out<br>
&gt;<br>
&gt; [...snip...]<br>
&gt;<br>
&gt; checking for library containing blkid_probe_all... -lblkid<br>
&gt; checking for blkid_probe_get_topology... yes<br>
&gt; checking for readdir... yes<br>
&gt; checking size of long... 8<br>
&gt; checking size of char *... 8<br>
&gt; checking for __psint_t ... no<br>
&gt; checking for __psunsigned_t ... no<br>
&gt; checking for __u32 ... yes<br>
&gt; checking for umode_t... yes<br>
&gt; configure: creating ./config.status<br>
&gt; config.status: creating include/builddefs<br>
&gt; config.status: creating include/platform_defs.h<br>
&gt; config.status: include/platform_defs.h is unchanged<br>
&gt; config.status: executing libtool commands<br>
&gt; [scameron@localhost xfsprogs]$ make<br>
&gt; Building include<br>
<br>
</div></div>Nothing built in the include directory - is this a clean build =
area?<br>
<div><br>
&gt; Building libxfs<br>
&gt; gmake[2]: *** No rule to make target `.ltdep&#39;, needed by `ltdepend=
&#39;. =A0Stop.<br>
&gt; gmake[1]: *** [libxfs] Error 2<br>
&gt; make: *** [default] Error 2<br>
&gt;<br>
&gt; Any ideas what&#39;s wrong here?<br>
<br>
</div>The automatic dependency generation failed to generate the .ltdep<br>
file. But it can&#39;t be a clean build area, because the libxfs build<br>
rule is:<br>
<br>
default: crc32selftest ltdepend $(LTLIBRARY)<br>
<br>
and I don&#39;t see the crc32selftest rule being executed before the<br>
dependencies are generated. It shoul dlook something like:<br>
<br>
$ make<br>
....<br>
<div>configure: creating ./config.status<br>
config.status: creating include/builddefs<br>
config.status: creating include/platform_defs.h<br>
</div>config.status: executing libtool commands<br>
Building include<br>
=A0 =A0 [LN] =A0 =A0 xfs<br>
=A0 =A0 [LN] =A0 =A0 disk<br>
Building libxfs<br>
=A0 =A0 [CC] =A0 =A0 gen_crc32table<br>
=A0 =A0 [GENERATE] crc32table.h<br>
=A0 =A0 [TEST] =A0 =A0CRC32<br>
CRC_LE_BITS =3D 32<br>
crc32: tests passed, 225944 bytes in 131 usec<br>
crc32c: tests passed, 225944 bytes in 131 usec<br>
=A0 =A0 [CC] =A0 =A0 cache.lo<br>
....<br>
<br>
So the first thing I&#39;d do is run &#39;make realclean; make&#39; to rest=
art<br>
the build for a clean workarea first. If that doesn&#39;t fix the<br>
problem, then I&#39;ll need to know versions of libtool, gcc, etc that<br>
you are using and you&#39;ll need to post the output of &quot;make realclea=
n;<br>
make Q=3D&quot; so we can see the command line that is actually failing.<br=
>
<br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
<div>--<br>
To unsubscribe from this list: send the line &quot;unsubscribe fstests&quot=
; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org" targe=
t=3D"_blank">majordomo@vger.kernel.org</a><br>
</div>More majordomo info at =A0<a href=3D"https://urldefense.proofpoint.co=
m/v1/url?u=3Dhttp://vger.kernel.org/majordomo-info.html&amp;k=3D2a4Akkj3oY%=
2FOkjwft1MTMw%3D%3D%0A&amp;r=3DjY8ozfSdJMiFQxJbqMIFvF4Q5MYg6nOaolSGt082e48%=
3D%0A&amp;m=3DbI0%2F1zZckAg2ytRBSMleHvthTKGuNDtYaUYrC%2BGOuV4%3D%0A&amp;s=
=3D7e28774591d3b095daa0b053b597ecb5e73203b4a403132664165f44ac3aaa49" target=
=3D"_blank">https://urldefense.proofpoint.com/v1/url?u=3Dhttp://vger.kernel=
.org/majordomo-info.html&amp;k=3D2a4Akkj3oY%2FOkjwft1MTMw%3D%3D%0A&amp;r=3D=
jY8ozfSdJMiFQxJbqMIFvF4Q5MYg6nOaolSGt082e48%3D%0A&amp;m=3DbI0%2F1zZckAg2ytR=
BSMleHvthTKGuNDtYaUYrC%2BGOuV4%3D%0A&amp;s=3D7e28774591d3b095daa0b053b597ec=
b5e73203b4a403132664165f44ac3aaa49</a><br>


</blockquote></div><br></div></div></div>

--001a11c3b4125bd36704feceb609--


--===============5371660556334779223==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5371660556334779223==--
