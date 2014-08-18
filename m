Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F20CF7F5E
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 04:30:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C29948F8033
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 02:30:32 -0700 (PDT)
Received: from BLU004-OMC3S18.hotmail.com (blu004-omc3s18.hotmail.com
	[65.55.116.93]) by cuda.sgi.com with ESMTP id rlATVfdjVxrTuGhz
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Aug 2014 02:30:31 -0700 (PDT)
Message-ID: <BLU181-W782ECB29BAB77090E0292A9CD40@phx.gbl>
From: Prithvi Rathore <prithvi_rathore@outlook.com>
Subject: RE: [RFD]: Help in setting up XFS
Date: Mon, 18 Aug 2014 15:00:31 +0530
In-Reply-To: <20140818070312.GM20518@dastard>
References: <BLU181-W3698AB216D54D0CCE5A9739CD40@phx.gbl>,
	<20140818070312.GM20518@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8760922306743276436=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============8760922306743276436==
Content-Type: multipart/alternative;
	boundary="_09d2918f-baef-4603-8baa-c49e0b391deb_"

--_09d2918f-baef-4603-8baa-c49e0b391deb_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Dave=2C
   I really appreciate you help in this matter.

> Date: Mon=2C 18 Aug 2014 17:03:12 +1000
> From: david@fromorbit.com
> To: prithvi_rathore@outlook.com
> CC: xfs@oss.sgi.com
> Subject: Re: [RFD]: Help in setting up XFS
>=20
> On Mon=2C Aug 18=2C 2014 at 10:22:37AM +0530=2C Prithvi Rathore wrote:
> > Hi=2C
> > As the subject states=2C I would like to setup and use XFS on an extern=
al USB drive. I am currently using Ubuntu 14.04 on MacBook Air 2013.
> > My understanding is:
> >=20
> > 1) I will have to install the packages
> > $ sudo apt-get install xfsprogs
> > $ sudo apt-get install xfsdump
> >=20
> > 2) I will have to create the filesystem for the USB drive
> > $ mkfs.xfs -f dev/sdab1
> > -f option needed to overwrite any existing filesytem
=20
> And then mount it appropriately and it will be ready to use.
> Nothing more.

About the part where you say mount it properly=2C I just wanted to check if=
 this is correct.

1)Create a mount point.
    $ mkdir /mnt/dat1

2)Mount the drive.
   $ mount -t xfs /dev/sdc1 /mnt/dat1

And i will have to do this every time I want to use the pendrive

Warm Regards=2C
Prithvi
 		 	   		  =

--_09d2918f-baef-4603-8baa-c49e0b391deb_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 12pt=3B
font-family:Calibri
}
--></style></head>
<body class=3D'hmmessage'><div dir=3D'ltr'>Hi Dave=2C<br>&nbsp=3B&nbsp=3B I=
 really appreciate you help in this matter.<br><br><div>&gt=3B Date: Mon=2C=
 18 Aug 2014 17:03:12 +1000<br>&gt=3B From: david@fromorbit.com<br>&gt=3B T=
o: prithvi_rathore@outlook.com<br>&gt=3B CC: xfs@oss.sgi.com<br>&gt=3B Subj=
ect: Re: [RFD]: Help in setting up XFS<br>&gt=3B <br>&gt=3B On Mon=2C Aug 1=
8=2C 2014 at 10:22:37AM +0530=2C Prithvi Rathore wrote:<br>&gt=3B &gt=3B Hi=
=2C<br>&gt=3B &gt=3B As the subject states=2C I would like to setup and use=
 XFS on an external USB drive. I am currently using Ubuntu 14.04 on MacBook=
 Air 2013.<br>&gt=3B &gt=3B My understanding is:<br>&gt=3B &gt=3B <br>&gt=
=3B &gt=3B 1) I will have to install the packages<br>&gt=3B &gt=3B $ sudo a=
pt-get install xfsprogs<br>&gt=3B &gt=3B $ sudo apt-get install xfsdump<br>=
&gt=3B &gt=3B <br>&gt=3B &gt=3B 2) I will have to create the filesystem for=
 the USB drive<br>&gt=3B &gt=3B $ mkfs.xfs -f dev/sdab1<br>&gt=3B &gt=3B -f=
 option needed to overwrite any existing filesytem<br>&nbsp=3B<br>&gt=3B An=
d then mount it appropriately and it will be ready to use.<br>&gt=3B Nothin=
g more.<br><br>About the part where you say mount it properly=2C I just wan=
ted to check if this is correct.<br><br>1)Create a mount point.<br>&nbsp=3B=
 &nbsp=3B $ mkdir /mnt/dat1<br><br>2)Mount the drive.<br>&nbsp=3B&nbsp=3B $=
 mount -t xfs /dev/sdc1 /mnt/dat1<br><br>And i will have to do this every t=
ime I want to use the pendrive<br><br>Warm Regards=2C<br>Prithvi<br></div> =
		 	   		  </div></body>
</html>=

--_09d2918f-baef-4603-8baa-c49e0b391deb_--


--===============8760922306743276436==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8760922306743276436==--
