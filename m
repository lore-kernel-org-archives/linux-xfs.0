Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ABLwLi088775 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 06:21:58 -0500
Received: from bay0-omc2-s25.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 118C12E57DF
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 04:22:18 -0700 (PDT)
Received: from bay0-omc2-s25.bay0.hotmail.com (bay0-omc2-s25.bay0.hotmail.com
	[65.54.246.161]) by cuda.sgi.com with ESMTP id 8mJxcd1VXzO3yRtN
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 04:22:18 -0700 (PDT)
Message-ID: <BAY108-W15E9D46A3841C023FEBE4DF3450@phx.gbl>
From: jack the ripper <evil_metalpeet@hotmail.com>
Subject: RE: xfs_growfs doesn't grow on 2TB raid
Date: Wed, 10 Jun 2009 13:22:17 +0200
In-Reply-To: <20090610110902.GA19633@infradead.org>
References: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
	<20090610110902.GA19633@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4655957871993723579=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org
Cc: xfs@oss.sgi.com

--===============4655957871993723579==
Content-Type: multipart/alternative;
	boundary="_50a9c2ca-a38e-45c5-b4ca-b0d18d1ce0bf_"

--_50a9c2ca-a38e-45c5-b4ca-b0d18d1ce0bf_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


When I do:

zgrep LBD /proc/config.gz

I get no output=2C I also can't find anything about LBD in my /usr/src/linu=
x/.config.

This is the kernel I'm running:=20
Linux RoSe 2.6.29-gentoo-r5 #3 SMP Sun Jun 7 19:24:08 CEST 2009 x86_64 Inte=
l(R) Core(TM)2 CPU 6400 @ 2.13GHz GenuineIntel GNU/Linux
Does this indicate a problem or is it normal behaviour?

> Date: Wed=2C 10 Jun 2009 07:09:02 -0400
> From: hch@infradead.org
> To: evil_metalpeet@hotmail.com
> CC: xfs@oss.sgi.com
> Subject: Re: xfs_growfs doesn't grow on 2TB raid
>=20
> On Wed=2C Jun 10=2C 2009 at 12:52:01PM +0200=2C jack the ripper wrote:
> > 		  RoSe linux # zgrep -i efi /proc/config.gz
> >=20
> >=20
> > CONFIG_EFI=3Dy
> > CONFIG_FB_EFI=3Dy
> > CONFIG_EFI_VARS=3Dy
> > CONFIG_EFI_PARTITION=3Dy=09
>=20
> Do you have CONFIG_LBD set?
>=20

_________________________________________________________________
Lentekriebels? Speel samen met je vrienden de spelletjes die Windows Live j=
e aanbiedt!
http://www.messengerbillboard.be/nl/play=

--_50a9c2ca-a38e-45c5-b4ca-b0d18d1ce0bf_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Verdana
}
</style>
</head>
<body class=3D'hmmessage'>
When I do:<br><br><pre><b><b>zgrep LBD /proc/config.gz<br><br>I get no outp=
ut=2C I also can't find anything about LBD in my /usr/src/linux/.config.<br=
><br>This is the kernel I'm running: </b></b><br>Linux RoSe 2.6.29-gentoo-r=
5 #3 SMP Sun Jun 7 19:24:08 CEST 2009 x86_64 Intel(R) Core(TM)2 CPU 6400 @ =
2.13GHz GenuineIntel GNU/Linux<br></pre>Does this indicate a problem or is =
it normal behaviour?<br><br>&gt=3B Date: Wed=2C 10 Jun 2009 07:09:02 -0400<=
br>&gt=3B From: hch@infradead.org<br>&gt=3B To: evil_metalpeet@hotmail.com<=
br>&gt=3B CC: xfs@oss.sgi.com<br>&gt=3B Subject: Re: xfs_growfs doesn't gro=
w on 2TB raid<br>&gt=3B <br>&gt=3B On Wed=2C Jun 10=2C 2009 at 12:52:01PM +=
0200=2C jack the ripper wrote:<br>&gt=3B &gt=3B 		  RoSe linux # zgrep -i e=
fi /proc/config.gz<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B <br>&gt=3B &gt=3B CON=
FIG_EFI=3Dy<br>&gt=3B &gt=3B CONFIG_FB_EFI=3Dy<br>&gt=3B &gt=3B CONFIG_EFI_=
VARS=3Dy<br>&gt=3B &gt=3B CONFIG_EFI_PARTITION=3Dy	<br>&gt=3B <br>&gt=3B Do=
 you have CONFIG_LBD set?<br>&gt=3B <br><br /><hr />Lentekriebels?  <a href=
=3D'http://www.messengerbillboard.be/nl/play' target=3D'_new'>Speel samen m=
et je vrienden de spelletjes die Windows Live je aanbiedt!</a></body>
</html>=

--_50a9c2ca-a38e-45c5-b4ca-b0d18d1ce0bf_--


--===============4655957871993723579==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4655957871993723579==--
