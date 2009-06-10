Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5AF5n8G097380 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 10:05:50 -0500
Received: from bay0-omc1-s27.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83DD2126DE0A
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 08:13:20 -0700 (PDT)
Received: from bay0-omc1-s27.bay0.hotmail.com (bay0-omc1-s27.bay0.hotmail.com
	[65.54.246.99]) by cuda.sgi.com with ESMTP id DYmF7oEfNB8unyi9
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 08:13:20 -0700 (PDT)
Message-ID: <BAY108-W34738AFF57BDF4BD9B742AF3450@phx.gbl>
From: jack the ripper <evil_metalpeet@hotmail.com>
Subject: RE: xfs_growfs doesn't grow on 2TB raid
Date: Wed, 10 Jun 2009 17:06:09 +0200
In-Reply-To: <4A2FB71D.3030606@sandeen.net>
References: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
	<4A2FB71D.3030606@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0587707126457640055=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: sandeen@sandeen.net
Cc: xfs@oss.sgi.com

--===============0587707126457640055==
Content-Type: multipart/alternative;
	boundary="_abe00355-446f-4f0e-8cea-68547bfa33c0_"

--_abe00355-446f-4f0e-8cea-68547bfa33c0_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


> cat /proc/partitions
major minor  #blocks  name

   8        0  625131864 sda
   8        1      40131 sda1
   8        2     987997 sda2
   8        3   29302560 sda3
   8        4          1 sda4
   8        5      40131 sda5
   8        6     987966 sda6
   8        7   29302528 sda7
   8        8    9775521 sda8
   8        9    9775521 sda9
   8       10    9775521 sda10
   8       11    9775521 sda11
   8       12    9775521 sda12
   8       13    9775521 sda13
   8       14    9775521 sda14
   8       15    9775521 sda15
 259        0    9775521 sda16
 259        1    9775521 sda17
 259        2   58605088 sda18
   8       16  488386584 sdb
   8       17      40131 sdb1
   8       18     987997 sdb2
   8       19   29302560 sdb3
   8       20          1 sdb4
   8       21      40131 sdb5
   8       22     987966 sdb6
   8       23   29302528 sdb7
   8       24    9775521 sdb8
   8       25    9775521 sdb9
   8       26    9775521 sdb10
   8       27    9775521 sdb11
   8       28    9775521 sdb12
   8       29    9775521 sdb13
   8       30    9775521 sdb14
   8       31    9775521 sdb15
 259        3    9775521 sdb16
 259        4    9775521 sdb17
 259        5   58605088 sdb18
   8       32  488386584 sdc
   8       33  488386552 sdc1
   8       48  488386584 sdd
   8       49  488386552 sdd1
   9        1      40064 md1
   9        3   29302464 md3
 253        0   29301436 dm-0
   8       64  488386584 sde
   8       65  488384001 sde1
   8       80  488386584 sdf
   8       81  488386552 sdf1
   8       96  488386584 sdg
   8       97  488384001 sdg1
   8      112  488386584 sdh
   8      113  488384001 sdh1
   9        5 2441919680 md5
 253        1 1953534716 dm-1

And to make things a tad clearer=2C my mdstat output:

> cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]=20
md5 : active raid5 sdd1[0] sdg1[5] sdc1[4] sde1[3] sdh1[2] sdf1[1]
      2441919680 blocks level 5=2C 64k chunk=2C algorithm 2 [6/6] [UUUUUU]
     =20
md3 : active raid1 sda3[0] sdb3[1]
      29302464 blocks [2/2] [UU]
     =20
md1 : active raid1 sda1[0] sdb1[1]
      40064 blocks [2/2] [UU]
     =20
unused devices: <none>


> Date: Wed=2C 10 Jun 2009 08:37:33 -0500
> From: sandeen@sandeen.net
> To: evil_metalpeet@hotmail.com
> CC: xfs@oss.sgi.com
> Subject: Re: xfs_growfs doesn't grow on 2TB raid
>=20
> jack the ripper wrote:
> > Hey all=2C
>=20
> ...
>=20
> > Proof that there is more size available:
> >=20
> >=20
> > RoSe linux # mdadm -D /dev/mddata1
> > /dev/mddata1:
> >         Version : 0.90
> >   Creation Time : Sat May 30 19:25:26 2009
> >      Raid Level : raid5
> >      Array Size : 2441919680 (2328.80 GiB 2500.53 GB)
>=20
>=20
> Just to be sure=2C could you also send the contents of /proc/partitions?
>=20
> -Eric

_________________________________________________________________
Lentekriebels? Speel samen met je vrienden de spelletjes die Windows Live j=
e aanbiedt!
http://www.messengerbillboard.be/nl/play=

--_abe00355-446f-4f0e-8cea-68547bfa33c0_
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
<pre><b>&gt=3B cat /proc/partitions</b><br>major minor  #blocks  name<br><b=
r>   8        0  625131864 sda<br>   8        1      40131 sda1<br>   8    =
    2     987997 sda2<br>   8        3   29302560 sda3<br>   8        4    =
      1 sda4<br>   8        5      40131 sda5<br>   8        6     987966 s=
da6<br>   8        7   29302528 sda7<br>   8        8    9775521 sda8<br>  =
 8        9    9775521 sda9<br>   8       10    9775521 sda10<br>   8      =
 11    9775521 sda11<br>   8       12    9775521 sda12<br>   8       13    =
9775521 sda13<br>   8       14    9775521 sda14<br>   8       15    9775521=
 sda15<br> 259        0    9775521 sda16<br> 259        1    9775521 sda17<=
br> 259        2   58605088 sda18<br>   8       16  488386584 sdb<br>   8  =
     17      40131 sdb1<br>   8       18     987997 sdb2<br>   8       19  =
 29302560 sdb3<br>   8       20          1 sdb4<br>   8       21      40131=
 sdb5<br>   8       22     987966 sdb6<br>   8       23   29302528 sdb7<br>=
   8       24    9775521 sdb8<br>   8       25    9775521 sdb9<br>   8     =
  26    9775521 sdb10<br>   8       27    9775521 sdb11<br>   8       28   =
 9775521 sdb12<br>   8       29    9775521 sdb13<br>   8       30    977552=
1 sdb14<br>   8       31    9775521 sdb15<br> 259        3    9775521 sdb16=
<br> 259        4    9775521 sdb17<br> 259        5   58605088 sdb18<br>   =
8       32  488386584 sdc<br>   8       33  488386552 sdc1<br>   8       48=
  488386584 sdd<br>   8       49  488386552 sdd1<br>   9        1      4006=
4 md1<br>   9        3   29302464 md3<br> 253        0   29301436 dm-0<br> =
  8       64  488386584 sde<br>   8       65  488384001 sde1<br>   8       =
80  488386584 sdf<br>   8       81  488386552 sdf1<br>   8       96  488386=
584 sdg<br>   8       97  488384001 sdg1<br>   8      112  488386584 sdh<br=
>   8      113  488384001 sdh1<br>   9        5 2441919680 md5<br> 253     =
   1 1953534716 dm-1<br></pre><br>And to make things a tad clearer=2C my md=
stat output:<br><br><pre><b>&gt=3B cat /proc/mdstat</b><br>Personalities : =
[raid0] [raid1] [raid6] [raid5] [raid4] <br>md5 : active raid5 sdd1[0] sdg1=
[5] sdc1[4] sde1[3] sdh1[2] sdf1[1]<br>      2441919680 blocks level 5=2C 6=
4k chunk=2C algorithm 2 [6/6] [UUUUUU]<br>      <br>md3 : active raid1 sda3=
[0] sdb3[1]<br>      29302464 blocks [2/2] [UU]<br>      <br>md1 : active r=
aid1 sda1[0] sdb1[1]<br>      40064 blocks [2/2] [UU]<br>      <br>unused d=
evices: &lt=3Bnone&gt=3B<br></pre><br><br>&gt=3B Date: Wed=2C 10 Jun 2009 0=
8:37:33 -0500<br>&gt=3B From: sandeen@sandeen.net<br>&gt=3B To: evil_metalp=
eet@hotmail.com<br>&gt=3B CC: xfs@oss.sgi.com<br>&gt=3B Subject: Re: xfs_gr=
owfs doesn't grow on 2TB raid<br>&gt=3B <br>&gt=3B jack the ripper wrote:<b=
r>&gt=3B &gt=3B Hey all=2C<br>&gt=3B <br>&gt=3B ...<br>&gt=3B <br>&gt=3B &g=
t=3B Proof that there is more size available:<br>&gt=3B &gt=3B <br>&gt=3B &=
gt=3B <br>&gt=3B &gt=3B RoSe linux # mdadm -D /dev/mddata1<br>&gt=3B &gt=3B=
 /dev/mddata1:<br>&gt=3B &gt=3B         Version : 0.90<br>&gt=3B &gt=3B   C=
reation Time : Sat May 30 19:25:26 2009<br>&gt=3B &gt=3B      Raid Level : =
raid5<br>&gt=3B &gt=3B      Array Size : 2441919680 (2328.80 GiB 2500.53 GB=
)<br>&gt=3B <br>&gt=3B <br>&gt=3B Just to be sure=2C could you also send th=
e contents of /proc/partitions?<br>&gt=3B <br>&gt=3B -Eric<br><br /><hr />L=
entekriebels?  <a href=3D'http://www.messengerbillboard.be/nl/play' target=
=3D'_new'>Speel samen met je vrienden de spelletjes die Windows Live je aan=
biedt!</a></body>
</html>=

--_abe00355-446f-4f0e-8cea-68547bfa33c0_--


--===============0587707126457640055==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0587707126457640055==--
