Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5IBfQM8221872 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 06:41:26 -0500
Received: from deframx28.softcom.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACB633E474B
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 04:44:02 -0700 (PDT)
Received: from deframx28.softcom.dk (deframx28.softcom.dk [87.230.83.86]) by
	cuda.sgi.com with ESMTP id 3j8q0d2avxvAWb10 for
	<xfs@oss.sgi.com>; Fri, 18 Jun 2010 04:44:02 -0700 (PDT)
In-Reply-To: <20100618133458.6640ce96@harpe.intellique.com>
References: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>	<20100618132108.790921cf@harpe.intellique.com>
	<OF450B8187.BD5256B0-ONC1257746.003E79FF-C1257746.003EE62C@bergenofs.no>
	<20100618133458.6640ce96@harpe.intellique.com>
MIME-Version: 1.0
Subject: Re: Help with XFS
Message-ID: <OF0E234D8E.F048FF4D-ONC1257746.003FC10E-C1257746.00407333@bergenofs.no>
From: =?ISO-8859-1?Q?Thomas_F=F8rde?= <thomas.forde@bergenofs.no>
Date: Fri, 18 Jun 2010 13:43:57 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2888961536843724563=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

This is a multipart message in MIME format.
--===============2888961536843724563==
Content-Type: multipart/alternative; boundary="=_alternative 00407332C1257746_="

This is a multipart message in MIME format.
--=_alternative 00407332C1257746_=
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

the raid array is a FC SAN array consisting of DS4700 unit with EXP810=20
expansion system

xfs=5Fcheck first, xfs=5Frepair -n, and xfs=5Frepair

xfs=5FRepair -L has not been used.

its seismisc processed data, large text files.



Sincerely
-------------------------------------------------------------------
Thomas F=F8rde    IT-Manager=20
Mobile +47 90 41 41 90   Fax +47 55 31 67 66
thomas.forde@bergenofs.no     www.bergenofs.no
-------------------------------------------------------------------
Bergen Oilfield Services AS
Address: Nedre Aastveit 12    NO-5106 Ovre Ervik
-------------------------------------------------------------------

Please consider the environment before printing



From:   Emmanuel Florac <eflorac@intellique.com>
To:     Thomas F=F8rde <thomas.forde@bergenofs.no>
Cc:     xfs@oss.sgi.com
Date:   18.06.2010 13:35
Subject:        Re: Help with XFS



Le Fri, 18 Jun 2010 13:27:01 +0200
Thomas F=F8rde <thomas.forde@bergenofs.no> =E9crivait:

> both the xfs=5Fcheck and xfs=5FReapir was done from a unmounted system,
> the system has not been mounted or used since.

That's good. Did you run xfs=5Frepair -n first ? Did you run=20
xfs=5Frepair -L afterwards?

> its a IBM x3650 with stadnard 2x73GB disk.

But what about the RAID array?=20
=20
> [root@strmng04 ~]# cat /etc/issue
> CentOS release 4.7 (Final)
> Kernel \r on an \m
>=20
> [root@strmng04 ~]# uname -a
> Linux strmng04 2.6.9-78.0.5.ELsmp #1 SMP Wed Oct 8 07:06:30 EDT 2008=20
> x86=5F64 x86=5F64 x86=5F64 GNU/Linux
>=20
>=20
> there is no backup no, as how to backup 8 TB of data,very expensive
> tape wise.

You could have a disk backup on cheaper drives. And current tapes are
800 GB (LTO-3) or 1.5 TB (LTO-4), and libraries are cheaper nowadays.

> xfs=5Firecover ias been mentioned to me, so my fingers are crossed.
>=20

If your data is a huge bunch of media files or similar, photorec really
can help you as a very last resort, though you'll have to manually sort
through all this data...

good luck,
--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |            <eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------



--=_alternative 00407332C1257746_=
Content-Type: text/html; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

<font size=3D2 face=3D"sans-serif">the raid array is a FC SAN array consist=
ing
of DS4700 unit with EXP810 expansion system</font>
<br>
<br><font size=3D2 face=3D"sans-serif">xfs=5Fcheck first, xfs=5Frepair -n, =
and
xfs=5Frepair</font>
<br>
<br><font size=3D2 face=3D"sans-serif">xfs=5FRepair -L has not been used.</=
font>
<br>
<br><font size=3D2 face=3D"sans-serif">its seismisc processed data, large t=
ext
files.</font>
<br>
<br><font size=3D2 face=3D"sans-serif"><br>
<br>
Sincerely<br>
-------------------------------------------------------------------<br>
Thomas F=F8rde &nbsp; &nbsp;IT-Manager <br>
Mobile +47 90 41 41 90 &nbsp; Fax +47 55 31 67 66<br>
thomas.forde@bergenofs.no &nbsp; &nbsp; </font><a href=3Dwww.bergenofs.no><=
font size=3D2 face=3D"sans-serif">www.bergenofs.no</font></a><font size=3D2=
 face=3D"sans-serif"><br>
-------------------------------------------------------------------<br>
Bergen Oilfield Services AS<br>
Address: Nedre Aastveit 12 &nbsp; &nbsp;NO-5106 Ovre Ervik<br>
-------------------------------------------------------------------<br>
<br>
Please consider the environment before printing</font>
<br>
<br>
<br>
<br><font size=3D1 color=3D#5f5f5f face=3D"sans-serif">From: &nbsp; &nbsp; =
&nbsp;
&nbsp;</font><font size=3D1 face=3D"sans-serif">Emmanuel Florac &lt;eflorac=
@intellique.com&gt;</font>
<br><font size=3D1 color=3D#5f5f5f face=3D"sans-serif">To: &nbsp; &nbsp; &n=
bsp;
&nbsp;</font><font size=3D1 face=3D"sans-serif">Thomas F=F8rde &lt;thomas.f=
orde@bergenofs.no&gt;</font>
<br><font size=3D1 color=3D#5f5f5f face=3D"sans-serif">Cc: &nbsp; &nbsp; &n=
bsp;
&nbsp;</font><font size=3D1 face=3D"sans-serif">xfs@oss.sgi.com</font>
<br><font size=3D1 color=3D#5f5f5f face=3D"sans-serif">Date: &nbsp; &nbsp; =
&nbsp;
&nbsp;</font><font size=3D1 face=3D"sans-serif">18.06.2010 13:35</font>
<br><font size=3D1 color=3D#5f5f5f face=3D"sans-serif">Subject: &nbsp; &nbs=
p;
&nbsp; &nbsp;</font><font size=3D1 face=3D"sans-serif">Re: Help with
XFS</font>
<br>
<hr noshade>
<br>
<br>
<br><tt><font size=3D2>Le Fri, 18 Jun 2010 13:27:01 +0200<br>
Thomas F=F8rde &lt;thomas.forde@bergenofs.no&gt; =E9crivait:<br>
<br>
&gt; both the xfs=5Fcheck and xfs=5FReapir was done from a unmounted system=
,<br>
&gt; the system has not been mounted or used since.<br>
<br>
That's good. Did you run xfs=5Frepair -n first ? Did you run <br>
xfs=5Frepair -L afterwards?<br>
<br>
&gt; its a IBM x3650 with stadnard 2x73GB disk.<br>
<br>
But what about the RAID array? <br>
 <br>
&gt; [root@strmng04 ~]# cat /etc/issue<br>
&gt; CentOS release 4.7 (Final)<br>
&gt; Kernel \r on an \m<br>
&gt; <br>
&gt; [root@strmng04 ~]# uname -a<br>
&gt; Linux strmng04 2.6.9-78.0.5.ELsmp #1 SMP Wed Oct 8 07:06:30 EDT 2008
<br>
&gt; x86=5F64 x86=5F64 x86=5F64 GNU/Linux<br>
&gt; <br>
&gt; <br>
&gt; there is no backup no, as how to backup 8 TB of data,very expensive<br>
&gt; tape wise.<br>
<br>
You could have a disk backup on cheaper drives. And current tapes are<br>
800 GB (LTO-3) or 1.5 TB (LTO-4), and libraries are cheaper nowadays.<br>
<br>
&gt; xfs=5Firecover ias been mentioned to me, so my fingers are crossed.<br>
&gt; <br>
<br>
If your data is a huge bunch of media files or similar, photorec really<br>
can help you as a very last resort, though you'll have to manually sort<br>
through all this data...<br>
<br>
good luck,<br>
-- <br>
------------------------------------------------------------------------<br>
Emmanuel Florac &nbsp; &nbsp; | &nbsp; Direction technique<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;|
&nbsp; Intellique<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;|
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&lt;eflorac@intellique.com&gt;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;|
&nbsp; +33 1 78 94 84 02<br>
------------------------------------------------------------------------<br>
<br>
</font></tt>
<br>
--=_alternative 00407332C1257746_=--


--===============2888961536843724563==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2888961536843724563==--
