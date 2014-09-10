Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 39F4A7F4E
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 20:00:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AE4D4AC003
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 18:00:22 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id DmsLs4GQghQDK0CG for
	<xfs@oss.sgi.com>; Tue, 09 Sep 2014 18:00:20 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Corrupted files
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <CAA43vkX8Ve3g7=w16742b4vT3=yRdCMR7m66g2M7fYPmEMmctA@mail.gmail.com>
Date: Wed, 10 Sep 2014 02:00:18 +0100
Message-Id: <62B15E94-1944-457F-B298-89EDEE3EC70D@filmlight.ltd.uk>
References: <540F1B01.3020700@mygrande.net>
	<CAA43vkXwHF9RHW-cbTZ91_vF6wiQ6o_+TQDL3=7kD9P4tErCNQ@mail.gmail.com>
	<CAA43vkWgh8-EjDXjkySUn+y18W1O+v_W5j+fQankRTgDCmc8tw@mail.gmail.com>
	<540F7E37.7020500@sandeen.net>
	<CAA43vkX8Ve3g7=w16742b4vT3=yRdCMR7m66g2M7fYPmEMmctA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5915772082589621485=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sean Caron <scaron@umich.edu>
Cc: Roger Willcocks <roger@filmlight.ltd.uk>, Eric Sandeen <sandeen@sandeen.net>, Leslie Rhorer <lrhorer@mygrande.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


--===============5915772082589621485==
Content-Type: multipart/alternative; boundary="Apple-Mail=_883806B7-225F-4F7A-8C28-339A49FE81DA"


--Apple-Mail=_883806B7-225F-4F7A-8C28-339A49FE81DA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

I normally watch quietly from the sidelines but I think it's important =
to get some balance here; our customers between them run many hundreds =
of multi-terabyte arrays and when something goes badly awry it generally =
falls to me to sort it out. In my experience xfs_repair does exactly =
what it says on the tin.

I can recall only a couple of instances where we elected to reformat and =
reload from backups and they were both due to human error: somebody =
deleted the wrong raid unit when doing routine maintenance, and then =
tried to fix it up hemselves.

In theory of course xfs_repair shouldn't be needed if the write barriers =
work properly (it's a journalled filesystem), but low-level corruption =
does creep in due to power failures / kernel crashes and it's this which =
xfs_repair is intended to address; not massive data corruption due to =
failed hardware or careless users.

--
Roger


On 9 Sep 2014, at 23:57, Sean Caron <scaron@umich.edu> wrote:

> Hey, just sharing some hard-won (believe me) professional experience. =
I have seen xfs_repair take a bad situation and make it worse many =
times. I don't know that a filesystem fuzzer or any other simulation can =
ever provide true simulation of users absolutely pounding the tar out of =
a system. There seems to be a real disconnect between what developers =
are able to test and observe directly, and what happens in the =
production environment in a very high-throughput environment.
>=20
> Best,
>=20
> Sean
>=20
>=20
> On Tue, Sep 9, 2014 at 6:24 PM, Eric Sandeen <sandeen@sandeen.net> =
wrote:
> On 9/9/14 11:03 AM, Sean Caron wrote:
>=20
> Barring rare cases, xfs_repair is bad juju.
>=20
> No, it's not.  It is the appropriate tool to use for filesystem =
repair.
>=20
> But it is not the appropriate tool for recovery from mangled storage.
>=20
> I've actually been running a filesystem fuzzer over xfs images, =
randomly
> corrupting data and testing repair, 1000s of times over.  It does
> remarkably well.
>=20
> If you scramble your raid, which means your block device is no longer
> an xfs filesystem, but is instead a random tangle of bits and pieces =
of
> other things, of course xfs_repair won't do well, but it's not the =
right
> tool for the job at that stage.
>=20
> -Eric
>=20
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


--Apple-Mail=_883806B7-225F-4F7A-8C28-339A49FE81DA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><div>I normally watch quietly from the sidelines but I think it's =
important to get some balance here; our customers between them run many =
hundreds of multi-terabyte arrays and when something goes badly awry it =
generally falls to me to sort it out. In my experience xfs_repair does =
exactly what it says on the tin.</div><div><br></div><div>I can recall =
only a couple of instances where we elected to reformat and reload from =
backups and they were both due to human error: somebody deleted the =
wrong raid unit when doing routine maintenance, and then tried to fix it =
up hemselves.</div><div><br></div><div>In theory of course xfs_repair =
shouldn't be needed if the write barriers work properly (it's a =
journalled filesystem), but low-level corruption does creep in due to =
power failures / kernel crashes and it's this which xfs_repair is =
intended to address; not massive data corruption due to failed hardware =
or careless =
users.</div><div><br></div><div>--</div><div>Roger</div><div><br><div><br>=
<div><div>On 9 Sep 2014, at 23:57, Sean Caron &lt;<a =
href=3D"mailto:scaron@umich.edu">scaron@umich.edu</a>&gt; =
wrote:</div><br class=3D"Apple-interchange-newline"><blockquote =
type=3D"cite"><div dir=3D"ltr">Hey, just sharing some hard-won (believe =
me) professional experience. I have seen xfs_repair take a bad situation =
and make it worse many times. I don't know that a filesystem fuzzer or =
any other simulation can ever provide true simulation of users =
absolutely pounding the tar out of a system. There seems to be a real =
disconnect between what developers are able to test and observe =
directly, and what happens in the production environment in a very =
high-throughput =
environment.<div><br></div><div><div>Best,</div><div><br></div><div>Sean</=
div><div><br></div></div></div><div class=3D"gmail_extra"><br><div =
class=3D"gmail_quote">On Tue, Sep 9, 2014 at 6:24 PM, Eric Sandeen <span =
dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" =
target=3D"_blank">sandeen@sandeen.net</a>&gt;</span> =
wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On =
9/9/14 11:03 AM, Sean Caron wrote:<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex">
Barring rare cases, xfs_repair is bad juju.<br>
</blockquote>
<br></span>
No, it's not.&nbsp; It is the appropriate tool to use for filesystem =
repair.<br>
<br>
But it is not the appropriate tool for recovery from mangled =
storage.<br>
<br>
I've actually been running a filesystem fuzzer over xfs images, =
randomly<br>
corrupting data and testing repair, 1000s of times over.&nbsp; It =
does<br>
remarkably well.<br>
<br>
If you scramble your raid, which means your block device is no =
longer<br>
an xfs filesystem, but is instead a random tangle of bits and pieces =
of<br>
other things, of course xfs_repair won't do well, but it's not the =
right<br>
tool for the job at that stage.<span class=3D"HOEnZb"><font =
color=3D"#888888"><br>
<br>
-Eric<br>
</font></span></blockquote></div><br></div>
_______________________________________________<br>xfs mailing =
list<br><a =
href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>http://oss.sgi.com/=
mailman/listinfo/xfs<br></blockquote></div><br></div></div></body></html>=

--Apple-Mail=_883806B7-225F-4F7A-8C28-339A49FE81DA--


--===============5915772082589621485==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5915772082589621485==--
