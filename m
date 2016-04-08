Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 50FDE7CA1
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 04:09:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 24C128F8039
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 02:09:11 -0700 (PDT)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com
	[209.85.223.182]) by cuda.sgi.com with ESMTP id
	F3YKNhHdfWAA9tnx (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Apr 2016 02:09:09 -0700 (PDT)
Received: by mail-io0-f182.google.com with SMTP id q128so124735041iof.3
	for <xfs@oss.sgi.com>; Fri, 08 Apr 2016 02:09:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160408010318.GA567@dastard>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-19-git-send-email-jtulak@redhat.com>
	<57057B2A.3000100@sandeen.net>
	<CACj3i736w-nnDzBDOiBf39cJ3AUHqeVL9_Y8EbUgaMa9S7PToA@mail.gmail.com>
	<5706FE56.7060308@sandeen.net> <20160408010318.GA567@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 8 Apr 2016 11:08:49 +0200
Message-ID: <CACj3i70EaLeECkmPUCUtpOeiMxWhgPPahs69yzWd0b_5Fy4sPQ@mail.gmail.com>
Subject: Re: [PATCH 18/19] mkfs: unit conversions are case insensitive
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4007934412430431712=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--===============4007934412430431712==
Content-Type: multipart/alternative; boundary=001a11427d742950a9052ff58cc1

--001a11427d742950a9052ff58cc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 8, 2016 at 3:03 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Apr 07, 2016 at 07:41:58PM -0500, Eric Sandeen wrote:
> > On 4/7/16 5:50 AM, Jan Tulak wrote:
> > > On Wed, Apr 6, 2016 at 11:10 PM, Eric Sandeen <sandeen@sandeen.net
> <mailto:sandeen@sandeen.net>>wrote:
> > >     (hm, why do we have 3 copies of cvtnum?)
> > >
> > >
> > > =E2=80=8BWhere? =E2=80=8B
> > >  =E2=80=8B
> > >
> > > =E2=80=8B$ pwd
> > > =E2=80=8B/some/path/xfsprogs-dev
> > >
> > > $ grep -r "cvtnum(size_t" . |grep -v "^Binary"
> > > =E2=80=8B./include/input.h:extern long long cvtnum(size_t blocksize, =
size_t
> sectorsize, char *s);
> > > ./io/init.h:extern void init_cvtnum(size_t *blocksize, size_t
> *sectsize);
> >
> >   File                Line
> > 0 estimate/xfs_estimate.c   29 cvtnum(char *s)
> > 1 libxcmd/input.c          147 cvtnum(
> > 2 mkfs/xfs_mkfs.c         3618 cvtnum(
>
> FWIW, here's why we put the function name at the start of the line,
> rather than the way that it is typically done in the kernel code
> (i.e. after the return type specification):
>
> $ git grep ^cvtnum
> estimate/xfs_estimate.c:cvtnum(char *s)
> libxcmd/input.c:cvtnum(
> mkfs/xfs_mkfs.c:cvtnum(
>
>
=E2=80=8BAh, I see. A nice trick. :-)

It might be good to merge the three functions, but I think it can wait for
when this patchset is done - or there is always going to be something more
to add...

Thanks,
Jan =E2=80=8B

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a11427d742950a9052ff58cc1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Fri, Ap=
r 8, 2016 at 3:03 AM, Dave Chinner </span><span dir=3D"ltr" style=3D"font-f=
amily:arial,sans-serif">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Thu, =
Apr 07, 2016 at 07:41:58PM -0500, Eric Sandeen wrote:<br>
&gt; On 4/7/16 5:50 AM, Jan Tulak wrote:<br>
&gt; &gt; On Wed, Apr 6, 2016 at 11:10 PM, Eric Sandeen &lt;<a href=3D"mail=
to:sandeen@sandeen.net">sandeen@sandeen.net</a> &lt;mailto:<a href=3D"mailt=
o:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt;&gt;wrote:<br>
</span><span class=3D"">&gt; &gt;=C2=A0 =C2=A0 =C2=A0(hm, why do we have 3 =
copies of cvtnum?)<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; =E2=80=8BWhere? =E2=80=8B<br>
&gt; &gt;=C2=A0 =E2=80=8B<br>
&gt; &gt;<br>
&gt; &gt; =E2=80=8B$ pwd<br>
&gt; &gt; =E2=80=8B/some/path/xfsprogs-dev<br>
&gt; &gt;<br>
&gt; &gt; $ grep -r &quot;cvtnum(size_t&quot; . |grep -v &quot;^Binary&quot=
;<br>
&gt; &gt; =E2=80=8B./include/input.h:extern long long cvtnum(size_t blocksi=
ze, size_t sectorsize, char *s);<br>
&gt; &gt; ./io/init.h:extern void init_cvtnum(size_t *blocksize, size_t *se=
ctsize);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0File=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 Line<br>
&gt; 0 estimate/xfs_estimate.c=C2=A0 =C2=A029 cvtnum(char *s)<br>
&gt; 1 libxcmd/input.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 147 cvtnum(<br>
&gt; 2 mkfs/xfs_mkfs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03618 cvtnum(<br>
<br>
</span>FWIW, here&#39;s why we put the function name at the start of the li=
ne,<br>
rather than the way that it is typically done in the kernel code<br>
(i.e. after the return type specification):<br>
<br>
$ git grep ^cvtnum<br>
estimate/xfs_estimate.c:cvtnum(char *s)<br>
libxcmd/input.c:cvtnum(<br>
mkfs/xfs_mkfs.c:cvtnum(<br>
<br></blockquote><div><br></div><div><div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BAh, I see. =
A nice trick. :-)</div></div><div><div class=3D"gmail_default" style=3D"fon=
t-family:arial,helvetica,sans-serif;display:inline"><br></div></div><div><d=
iv class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;=
display:inline">It might be good to merge the three functions, but I think =
it can wait for when this patchset is done - or there is always going to be=
 something more to add...=C2=A0</div></div><div><div class=3D"gmail_default=
" style=3D"font-family:arial,helvetica,sans-serif;display:inline"><br></div=
></div><div><div class=3D"gmail_default" style=3D"font-family:arial,helveti=
ca,sans-serif;display:inline">Thanks,</div></div><div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif;display:inline">Jan=
 =E2=80=8B</div>=C2=A0</div></div>-- <br><div class=3D"gmail_signature"><di=
v dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mail=
to:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a hre=
f=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></d=
iv></div>
</div></div>

--001a11427d742950a9052ff58cc1--


--===============4007934412430431712==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4007934412430431712==--
