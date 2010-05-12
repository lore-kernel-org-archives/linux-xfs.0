Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4C9H61u152386 for <xfs@oss.sgi.com>; Wed, 12 May 2010 04:17:06 -0500
Received: from n17.bullet.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 868F1156356B
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 02:19:47 -0700 (PDT)
Received: from n17.bullet.mail.mud.yahoo.com (n17.bullet.mail.mud.yahoo.com
	[68.142.206.144]) by cuda.sgi.com with SMTP id ap039eLMLR1PiO4v
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 02:19:47 -0700 (PDT)
Message-ID: <132290.52744.qm@web112902.mail.gq1.yahoo.com>
References: <28512276.post@talk.nabble.com> <4BE82955.2080009@sandeen.net>
	<978493.86662.qm@web112902.mail.gq1.yahoo.com>
	<20100510222211.3e73cdeb@galadriel.home>
Date: Wed, 12 May 2010 02:19:16 -0700 (PDT)
From: Leo Davis <leo1783@yahoo.com>
Subject: Re: bad primary superblock - bad magic number !!!
In-Reply-To: <20100510222211.3e73cdeb@galadriel.home>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0306992186399382877=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

--===============0306992186399382877==
Content-Type: multipart/alternative; boundary="0-1468979099-1273655956=:52744"

--0-1468979099-1273655956=:52744
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

havent had much success with testing the hard drives, tried mhdd & seatools=
 with no luck yet.=0A=0AMeanwhile i recreated RAID, all shows up OK for now=
.=0A=0APreviously the msgs shown were:=0A=0Aend_request: I/O error, dev cci=
ss/c0d2, sector 0=0Aend_request: I/O error, dev cciss/c0d2, sector 0=0Aend_=
request: I/O error, dev cciss/c0d2, sector 1 =0A=0AThat seems to indicate t=
hat the problem is with the disc or array. It=0Ais unable to read the begin=
ning of the device.=0ASo is I do a - dd if=3D/dev/random of=3Ddev/cciss/c0d=
2 , that should fail=0Aand therby confirm that the drive or array has issue=
s...do i make any=0Asense here?=0A=0Athanks=0A=0A=0A=0A=0A=0A=0A___________=
_____________________=0AFrom: Emmanuel Florac <eflorac@intellique.com>=0ATo=
: Leo Davis <leo1783@yahoo.com>=0ACc: xfs@oss.sgi.com=0ASent: Mon, May 10, =
2010 9:22:11 PM=0ASubject: Re: bad primary superblock - bad magic number !!=
!=0A=0ALe Mon, 10 May 2010 11:11:45 -0700 (PDT) vous =E9criviez:=0A=0A> I a=
gree. I destroy and re-create raid and everything would show up=0A> GOOD, o=
nly for it to break again. So was wondering whether those=0A> traces would =
point to anything.... my prime suspect is hard drives,=0A> but those xfs ms=
gs confused me. =0A=0ACheck the hard drives separately with the maker utili=
ty (Seatools,=0Aetc). One of them at the very least must be seriously ill.=
=0A=0A-- =0A---------------------------------------------------------------=
---------=0AEmmanuel Florac     |   Direction technique=0A                 =
   |   Intellique=0A                    |    <eflorac@intellique.com>=0A   =
                 |   +33 1 78 94 84 02=0A----------------------------------=
--------------------------------------=0A=0A=0A=0A      
--0-1468979099-1273655956=:52744
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D"text/css"><!-- DIV {margin:0px;} --></style></he=
ad><body><div style=3D"font-family:times new roman,new york,times,serif;fon=
t-size:12pt">havent had much success with testing the hard drives, tried mh=
dd &amp; seatools with no luck yet.<br>=0A<br>=0AMeanwhile i recreated RAID=
, all shows up OK for now.<br>=0A<br>=0APreviously the msgs shown were:<br>=
=0A<br>=0Aend_request: I/O error, dev cciss/c0d2, sector 0<br>=0A=0Aend_req=
uest: I/O error, dev cciss/c0d2, sector 0<br>=0A=0Aend_request: I/O error, =
dev cciss/c0d2, sector 1 =0A=09=09=09=0A=09=09<br>=0A<br>=0AThat seems to i=
ndicate that the problem is with the disc or array. It=0Ais unable to read =
the beginning of the device.<br>=0ASo is I do a - dd if=3D/dev/random of=3D=
dev/cciss/c0d2 , that should fail=0Aand therby confirm that the drive or ar=
ray has issues...do i make any=0Asense here?<br>=0A<br>=0Athanks<br>=0A<br>=
=0A <br>=0A<div style=3D"font-family: times new roman,new york,times,serif;=
 font-size: 12pt;"><br><div style=3D"font-family: arial,helvetica,sans-seri=
f; font-size: 13px;"><font face=3D"Tahoma" size=3D"2"><hr size=3D"1"><b><sp=
an style=3D"font-weight: bold;">From:</span></b> Emmanuel Florac &lt;eflora=
c@intellique.com&gt;<br><b><span style=3D"font-weight: bold;">To:</span></b=
> Leo Davis &lt;leo1783@yahoo.com&gt;<br><b><span style=3D"font-weight: bol=
d;">Cc:</span></b> xfs@oss.sgi.com<br><b><span style=3D"font-weight: bold;"=
>Sent:</span></b> Mon, May 10, 2010 9:22:11 PM<br><b><span style=3D"font-we=
ight: bold;">Subject:</span></b> Re: bad primary superblock - bad magic num=
ber !!!<br></font><br>=0ALe Mon, 10 May 2010 11:11:45 -0700 (PDT) vous =E9c=
riviez:<br><br>&gt; I agree. I destroy and re-create raid and everything wo=
uld show up<br>&gt; GOOD, only for it to break again. So was wondering whet=
her those<br>&gt; traces would point to anything.... my prime suspect is ha=
rd drives,<br>&gt; but those xfs msgs confused me. <br><br>Check the hard d=
rives separately with the maker utility (Seatools,<br>etc). One of them at =
the very least must be seriously ill.<br><br>-- <br>-----------------------=
-------------------------------------------------<br>Emmanuel Florac&nbsp; =
&nbsp;  |&nbsp;  Direction technique<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |&nbsp;  Intellique<br>&nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |&nbsp;&nbsp;&nbsp; &l=
t;<a ymailto=3D"mailto:eflorac@intellique.com" href=3D"mailto:eflorac@intel=
lique.com">eflorac@intellique.com</a>&gt;<br>&nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp;
 &nbsp; &nbsp; &nbsp; |&nbsp;  +33 1 78 94 84 02<br>-----------------------=
-------------------------------------------------<br></div></div>=0A</div><=
br>=0A=0A      </body></html>
--0-1468979099-1273655956=:52744--


--===============0306992186399382877==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0306992186399382877==--
