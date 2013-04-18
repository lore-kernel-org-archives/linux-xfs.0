Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E50E29DFA
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 07:25:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1CEF78F8050
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 05:25:09 -0700 (PDT)
Received: from mail-ie0-f177.google.com (mail-ie0-f177.google.com
	[209.85.223.177]) by cuda.sgi.com with ESMTP id
	j2XFviXmQzBJ20ta (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Apr 2013 05:25:05 -0700 (PDT)
Received: by mail-ie0-f177.google.com with SMTP id 9so3113911iec.8
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 05:25:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <516EB6E3.9040903@sgi.com>
References: <20120828172605.607853317@sgi.com>
	<20120828172928.999971219@sgi.com>
	<CAFZPdfgFjRS2rFUekfSr4dT+-sfuji-0uUo1i7VE6=9GZOnzfg@mail.gmail.com>
	<516EB6E3.9040903@sgi.com>
Date: Thu, 18 Apr 2013 14:25:04 +0200
Message-ID: <CAFZPdfguUWWPXcH_NJ30134N=39-KD422LL+k=edOWhjO2GTeA@mail.gmail.com>
Subject: Re: [PATCH 2/5] xfstests: Use libtool to install applications
From: Boris Ranto <ranto.boris@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8175862685767180855=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

--===============8175862685767180855==
Content-Type: multipart/alternative; boundary=14dae9340be937b74504daa1b146

--14dae9340be937b74504daa1b146
Content-Type: text/plain; charset=ISO-8859-1

Rich,

just as Eric guessed, I package the xfstests test suite (and that is also
why I need the DIST_ROOT variable functioning properly). Although I can
currently work around the problem  by doing something like

./configure
make
mkdir -p /var/lib/xfstets/{ltp,src}
make DIST_ROOT=$RPM_BUILD_ROOT install

it certainly is not the best solution to the problem. If the test suite is
completely independent from its location then also maybe this could work (I
did not try it, yet and I'm still not sure it is the best solution)

./configure --prefix=$RPM_BUILD_ROOT
make
make install

but if that is the case then it'd probably make sense to drop the whole
DIST_ROOT support from install-sh script to avoid confusion and update the
spec file in bulld/rpm/.

Regards,
Boris

(Rich, sorry for the duplicate message, I forgot to cc mailing list the
first time.)


On Wed, Apr 17, 2013 at 4:51 PM, Rich Johnston <rjohnston@sgi.com> wrote:

> Boris,
>
> Most people do not install xfstests, as it is not required to run the
> tests.  Is there a reason you need to install xfstests? It is designed to
> be run from the directory you did the git clone from.  Path is not critical
> so you could move it anywhere you wish.
>
> i.e.
> git clone git://oss.sgi.com/xfs/cmds/**xfstests<http://oss.sgi.com/xfs/cmds/xfstests>
> mv xfstests /new/path/new_xfsdirname
> cd /new/path/new_xfsdirname
> ./check -g auto
>
>
> --Rich
>

--14dae9340be937b74504daa1b146
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D""><table class=3D"" cellpadding=3D"0"><tbody=
><tr class=3D""><td colspan=3D"3"><table class=3D"" cellpadding=3D"0"><tbod=
y><tr><td class=3D""><div dir=3D"ltr"><img class=3D"" id=3D":11k" tabindex=
=3D"0" src=3D"https://mail.google.com/mail/images/cleardot.gif" alt=3D"">Ri=
ch,<br>
<br>just
 as Eric guessed, I package the xfstests test suite (and that is also=20
why I need the DIST_ROOT variable functioning properly). Although I can=20
currently work around the problem=A0 by doing something like<br>
<br>./configure<br>make<br>mkdir -p /var/lib/xfstets/{ltp,src}<br>make DIST=
_ROOT=3D$RPM_BUILD_ROOT install<br><br>it
 certainly is not the best solution to the problem. If the test suite is
 completely independent from its location then also maybe this could=20
work (I did not try it, yet and I&#39;m still not sure it is the best=20
solution)<br>
<br>./configure --prefix=3D$RPM_BUILD_ROOT<br>make<br>make install<br><br>b=
ut
 if that is the case then it&#39;d probably make sense to drop the whole=20
DIST_ROOT support from install-sh script to avoid confusion and update=20
the spec file in bulld/rpm/.<br>
<br>Regards,<br>Boris<br><br>(Rich, sorry for the duplicate message, I forg=
ot to cc mailing list the first time.)<br></div></td></tr></tbody></table><=
/td></tr></tbody></table></div></div><div class=3D"gmail_extra"><br><br>
<div class=3D"gmail_quote">On Wed, Apr 17, 2013 at 4:51 PM, Rich Johnston <=
span dir=3D"ltr">&lt;<a href=3D"mailto:rjohnston@sgi.com" target=3D"_blank"=
>rjohnston@sgi.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
Boris,<br>
<br>
Most people do not install xfstests, as it is not required to run the tests=
. =A0Is there a reason you need to install xfstests? It is designed to be r=
un from the directory you did the git clone from. =A0Path is not critical s=
o you could move it anywhere you wish.<br>

<br>
i.e.<br>
git clone git://<a href=3D"http://oss.sgi.com/xfs/cmds/xfstests" target=3D"=
_blank">oss.sgi.com/xfs/cmds/<u></u>xfstests</a><br>
mv xfstests /new/path/new_xfsdirname<br>
cd /new/path/new_xfsdirname<br>
./check -g auto<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
<br>
--Rich<br>
</font></span></blockquote></div><br></div>

--14dae9340be937b74504daa1b146--


--===============8175862685767180855==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8175862685767180855==--
