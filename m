Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9MGrj3h115316 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 11:53:46 -0500
Received: from mail-pz0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 212FD17B023C
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 09:55:19 -0700 (PDT)
Received: from mail-pz0-f174.google.com (mail-pz0-f174.google.com
	[209.85.222.174]) by cuda.sgi.com with ESMTP id
	EiHqeAgJ7YdA3y9o for <xfs@oss.sgi.com>;
	Thu, 22 Oct 2009 09:55:19 -0700 (PDT)
Received: by pzk4 with SMTP id 4so10299445pzk.32
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 09:55:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AE08AED.1020702@sandeen.net>
References: <c2dcdfa40910202307m77a9d7c5lf18e278a9ebae08e@mail.gmail.com>
	<4ADF2EE8.6010700@sandeen.net>
	<c2dcdfa40910211032y5b1d2cd8l418491327d24b87b@mail.gmail.com>
	<4ADF4882.70106@sandeen.net>
	<c2dcdfa40910220209v781f6a76u31e349ea461bc10a@mail.gmail.com>
	<4AE06BAE.8090706@sandeen.net>
	<c2dcdfa40910220930l19a8dab0y88e80630a2453b39@mail.gmail.com>
	<4AE08AED.1020702@sandeen.net>
Date: Thu, 22 Oct 2009 22:25:18 +0530
Message-ID: <c2dcdfa40910220955q586bdcabn268ddbc30d9b785d@mail.gmail.com>
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 1992 of file
	fs/xfs/xfs_da_btree.c
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6334495468483992416=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============6334495468483992416==
Content-Type: multipart/alternative; boundary=000e0cd29a60d59009047688f585

--000e0cd29a60d59009047688f585
Content-Type: text/plain; charset=ISO-8859-1

that means it highely unlikey to get a fix for this issue :(

Yes, backporting just doest not suits for me.

I am trying to dig into the code, but really dont know if that's going to be
that easy.

Thanks Eric for all the help.
W'll you know if I am able to fix this.

Thanks & Regards,
Amit Sahrawat

On Thu, Oct 22, 2009 at 10:10 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Amit Sahrawat wrote:
> > I am already using that patch.
> > Other than using higher XFS version, can I try any other thing?
> >
> > I cannot directly use higher XFS version, I will have to backport the
> > changes for higher to the kernel I am using  because of dependencies.
> >
>
> backporting xfs would be hard; I was hoping that perhaps you could just
> boot a newer kernel, though I know w/ vendor arm kernels that can be tough.
>
> There are drawbacks to not getting machine support upstream... :)
>
> I don't really have other things for you to try, and don't have a lot of
> time to debug 3 year old kernels either...  :(
>
> You could try your arm testcase in a qemu emulator on a new kernel; if
> that shows the same problem I'll be much more interested & motivated...
>
> -Eric
>

--000e0cd29a60d59009047688f585
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>that means it highely unlikey to get a fix for this issue :(</div>
<div>=A0</div>
<div>Yes, backporting just doest not suits for me.</div>
<div>=A0</div>
<div>I am trying to dig into the code, but really dont know if that&#39;s g=
oing to be that easy. </div>
<div>=A0</div>
<div>Thanks Eric for all the help.</div>
<div>W&#39;ll you know if I am able to fix this.</div>
<div>=A0</div>
<div>Thanks &amp; Regards,</div>
<div>Amit Sahrawat<br><br></div>
<div class=3D"gmail_quote">On Thu, Oct 22, 2009 at 10:10 PM, Eric Sandeen <=
span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen=
.net</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div class=3D"im">Amit Sahrawat wrote:<br>&gt; I am already using that patc=
h.<br>&gt; Other than using higher XFS version, can I try any other thing?<=
br>&gt;<br>&gt; I cannot directly use higher XFS version, I will have to ba=
ckport the<br>
&gt; changes for higher to the kernel I am using =A0because of dependencies=
.<br>&gt;<br><br></div>backporting xfs would be hard; I was hoping that per=
haps you could just<br>boot a newer kernel, though I know w/ vendor arm ker=
nels that can be tough.<br>
<br>There are drawbacks to not getting machine support upstream... :)<br><b=
r>I don&#39;t really have other things for you to try, and don&#39;t have a=
 lot of<br>time to debug 3 year old kernels either... =A0:(<br><br>You coul=
d try your arm testcase in a qemu emulator on a new kernel; if<br>
that shows the same problem I&#39;ll be much more interested &amp; motivate=
d...<br><font color=3D"#888888"><br>-Eric<br></font></blockquote></div><br>

--000e0cd29a60d59009047688f585--


--===============6334495468483992416==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6334495468483992416==--
