Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5IBORbX221198 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 06:24:27 -0500
Received: from deframx28.softcom.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CD1A10F5A18
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 04:30:53 -0700 (PDT)
Received: from deframx28.softcom.dk (deframx28.softcom.dk [87.230.83.86]) by
	cuda.sgi.com with ESMTP id jipqQj2rKRoRFmjB for
	<xfs@oss.sgi.com>; Fri, 18 Jun 2010 04:30:53 -0700 (PDT)
In-Reply-To: <20100618132108.790921cf@harpe.intellique.com>
References: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>
	<20100618132108.790921cf@harpe.intellique.com>
MIME-Version: 1.0
Subject: Re: Help with XFS
Message-ID: <OF450B8187.BD5256B0-ONC1257746.003E79FF-C1257746.003EE62C@bergenofs.no>
From: =?ISO-8859-1?Q?Thomas_F=F8rde?= <thomas.forde@bergenofs.no>
Date: Fri, 18 Jun 2010 13:27:01 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4991378558211781382=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

This is a multipart message in MIME format.
--===============4991378558211781382==
Content-Type: multipart/alternative; boundary="=_alternative 003EE62CC1257746_="

This is a multipart message in MIME format.
--=_alternative 003EE62CC1257746_=
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

both the xfs=5Fcheck and xfs=5FReapir was done from a unmounted system, the=
=20
system has not been mounted or used since.

its a IBM x3650 with stadnard 2x73GB disk.

[root@strmng04 ~]# cat /etc/issue
CentOS release 4.7 (Final)
Kernel \r on an \m

[root@strmng04 ~]# uname -a
Linux strmng04 2.6.9-78.0.5.ELsmp #1 SMP Wed Oct 8 07:06:30 EDT 2008=20
x86=5F64 x86=5F64 x86=5F64 GNU/Linux


there is no backup no, as how to backup 8 TB of data,very expensive tape=20
wise.

xfs=5Firecover ias been mentioned to me, so my fingers are crossed.


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
Date:   18.06.2010 13:21
Subject:        Re: Help with XFS



Le Thu, 17 Jun 2010 15:18:26 +0200
Thomas F=F8rde <thomas.forde@bergenofs.no> =E9crivait:

> i have run xfs=5Fcheck without any verbos information given
> i have run xfs=5Frepair without any information errors fixed.

That's unfortunate that you didn't post here before doing irreparable=20
damage. Any activity to the filesystem may delete permanently data, so
you should stop using it completely until done with the rescue
operations and unmount it.

>=20
> when i try to mount the XFS filesystem of 10TB, my 7.8 TB of data is
> now gone.
>=20
> before:         /dev/sdf1            10527858560 8801101708
> 1726756852 84% /D5
> after:          /dev/sdf1            10527858560       528
> 10527858032 1% /D5
>=20

Some old versions of xfs=5Frepair may fail on big FS. You didn't mention
which version you're using, which distribution and which kernel. The
hardware setup may be important, too.

> help, where did my data go, and how can i get it back.

Apparently xfs=5Frepair deleted it because it was corrupt (alas, happen
sometimes with xfs=5Frepair before 2.8). The best thing to do is to get it
back from backups. I suppose that you have no backup (people don't do
any backup until they lose important data, which always occurs).

If you have no backups, your last hope is to use a tool like photorec
to find your data on the raw device; however it won't reconstruct the
metadata (no names, no folders, no hierarchy, no user rights). BTW you
need some other place to store the newly discovered files with at least
as much space (7.8 TB).

My condolences. I once lost 13TB and see, I'm not dead. You'll get over
it somehow.
--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |            <eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------



--=_alternative 003EE62CC1257746_=
Content-Type: text/html; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

<font size=3D2 face=3D"sans-serif">both the xfs=5Fcheck and xfs=5FReapir wa=
s done
from a unmounted system, the system has not been mounted or used since.</fo=
nt>
<br>
<br><font size=3D2 face=3D"sans-serif">its a IBM x3650 with stadnard 2x73GB
disk.</font>
<br>
<br><font size=3D2 face=3D"sans-serif">[root@strmng04 ~]# cat /etc/issue</f=
ont>
<br><font size=3D2 face=3D"sans-serif">CentOS release 4.7 (Final)</font>
<br><font size=3D2 face=3D"sans-serif">Kernel \r on an \m</font>
<br>
<br><font size=3D2 face=3D"sans-serif">[root@strmng04 ~]# uname -a</font>
<br><font size=3D2 face=3D"sans-serif">Linux strmng04 2.6.9-78.0.5.ELsmp #1
SMP Wed Oct 8 07:06:30 EDT 2008 x86=5F64 x86=5F64 x86=5F64 GNU/Linux</font>
<br>
<br>
<br><font size=3D2 face=3D"sans-serif">there is no backup no, as how to bac=
kup
8 TB of data,very expensive tape wise.</font>
<br>
<br><font size=3D2 face=3D"sans-serif">xfs=5Firecover ias been mentioned to=
 me,
so my fingers are crossed.</font>
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
&nbsp;</font><font size=3D1 face=3D"sans-serif">18.06.2010 13:21</font>
<br><font size=3D1 color=3D#5f5f5f face=3D"sans-serif">Subject: &nbsp; &nbs=
p;
&nbsp; &nbsp;</font><font size=3D1 face=3D"sans-serif">Re: Help with
XFS</font>
<br>
<hr noshade>
<br>
<br>
<br><tt><font size=3D2>Le Thu, 17 Jun 2010 15:18:26 +0200<br>
Thomas F=F8rde &lt;thomas.forde@bergenofs.no&gt; =E9crivait:<br>
<br>
&gt; i have run xfs=5Fcheck without any verbos information given<br>
&gt; i have run xfs=5Frepair without any information errors fixed.<br>
<br>
That's unfortunate that you didn't post here before doing irreparable <br>
damage. Any activity to the filesystem may delete permanently data, so<br>
you should stop using it completely until done with the rescue<br>
operations and unmount it.<br>
<br>
&gt; <br>
&gt; when i try to mount the XFS filesystem of 10TB, my 7.8 TB of data
is<br>
&gt; now gone.<br>
&gt; <br>
&gt; before: &nbsp; &nbsp; &nbsp; &nbsp; /dev/sdf1 &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp;10527858560 8801101708<br>
&gt; 1726756852 84% /D5<br>
&gt; after: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;/dev/sdf1 &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp;10527858560 &nbsp; &nbsp; &nbsp; 528<br>
&gt; 10527858032 1% /D5<br>
&gt; <br>
<br>
Some old versions of xfs=5Frepair may fail on big FS. You didn't mention<br>
which version you're using, which distribution and which kernel. The<br>
hardware setup may be important, too.<br>
<br>
&gt; help, where did my data go, and how can i get it back.<br>
<br>
Apparently xfs=5Frepair deleted it because it was corrupt (alas, happen<br>
sometimes with xfs=5Frepair before 2.8). The best thing to do is to get it<=
br>
back from backups. I suppose that you have no backup (people don't do<br>
any backup until they lose important data, which always occurs).<br>
<br>
If you have no backups, your last hope is to use a tool like photorec<br>
to find your data on the raw device; however it won't reconstruct the<br>
metadata (no names, no folders, no hierarchy, no user rights). BTW you<br>
need some other place to store the newly discovered files with at least<br>
as much space (7.8 TB).<br>
<br>
My condolences. I once lost 13TB and see, I'm not dead. You'll get over<br>
it somehow.<br>
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
--=_alternative 003EE62CC1257746_=--


--===============4991378558211781382==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4991378558211781382==--
