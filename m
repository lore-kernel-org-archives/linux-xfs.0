Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4CCgp66163411 for <xfs@oss.sgi.com>; Wed, 12 May 2010 07:42:51 -0500
Received: from n3-vm0.bullet.mail.gq1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 3F196339096
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 05:45:04 -0700 (PDT)
Received: from n3-vm0.bullet.mail.gq1.yahoo.com
	(n3-vm0.bullet.mail.gq1.yahoo.com [67.195.23.156]) by
	cuda.sgi.com with SMTP id nEP9EZ2G1sMklVFC for
	<xfs@oss.sgi.com>; Wed, 12 May 2010 05:45:04 -0700 (PDT)
Message-ID: <14845.20130.qm@web112901.mail.gq1.yahoo.com>
References: <28512276.post@talk.nabble.com> <4BE82955.2080009@sandeen.net>
	<978493.86662.qm@web112902.mail.gq1.yahoo.com>
	<20100510222211.3e73cdeb@galadriel.home>
	<132290.52744.qm@web112902.mail.gq1.yahoo.com>
	<20100512142902.47d1022a@harpe.intellique.com>
Date: Wed, 12 May 2010 05:45:03 -0700 (PDT)
From: Leo Davis <leo1783@yahoo.com>
Subject: Re: bad primary superblock - bad magic number !!!
In-Reply-To: <20100512142902.47d1022a@harpe.intellique.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5191667099034534096=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

--===============5191667099034534096==
Content-Type: multipart/alternative; boundary="0-839393850-1273668303=:20130"

--0-839393850-1273668303=:20130
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

> So is I do a - dd if=3D/dev/random of=3Ddev/cciss/c0d2 , that should fail=
=0A> and therby confirm that the drive or array has issues...do i make any=
=0A> sense here?=0A=0A>Uh, you should try the other way around to avoid bre=
aking the=0A>filesystem :=0A=0A>dd if=3D/dev/cciss/c0d2 of=3D/dev/null bs=
=3D131072=0A=0A>If no error occurs it should be OK.=0A=0A# dd if=3D/dev/cci=
ss/c0d2 of=3D/dev/null bs=3D131072=0A796+1 records in=0A796+1 records out=
=0A#=0A=0Adoesn't show any errors here ......=0A=0A> havent had much succes=
s with testing the hard drives, tried mhdd &=0A> seatools with no luck yet.=
=0A=0A>What do you mean? Does the tools report any problem with the drives?=
=0A=0Amhdd doesnt detect the drives, probably an issue with chipset...still=
 looking for tools=0A=0Athanks=0A=0A=0A=0A=0A=0A=0A________________________=
________=0AFrom: Emmanuel Florac <eflorac@intellique.com>=0ATo: Leo Davis <=
leo1783@yahoo.com>=0ACc: xfs@oss.sgi.com=0ASent: Wed, May 12, 2010 1:29:02 =
PM=0ASubject: Re: bad primary superblock - bad magic number !!!=0A=0ALe Wed=
, 12 May 2010 02:19:16 -0700 (PDT)=0ALeo Davis <leo1783@yahoo.com> =E9criva=
it:=0A=0A> havent had much success with testing the hard drives, tried mhdd=
 &=0A> seatools with no luck yet.=0A=0AWhat do you mean? Does the tools rep=
ort any problem with the drives?=0A=0A> So is I do a - dd if=3D/dev/random =
of=3Ddev/cciss/c0d2 , that should fail=0A> and therby confirm that the driv=
e or array has issues...do i make any=0A> sense here?=0A=0AUh, you should t=
ry the other way around to avoid breaking the=0Afilesystem :=0A=0Add if=3D/=
dev/cciss/c0d2 of=3D/dev/null bs=3D131072=0A=0AIf no error occurs it should=
 be OK.=0A=0A-- =0A--------------------------------------------------------=
----------------=0AEmmanuel Florac     |   Direction technique=0A          =
          |   Intellique=0A                    |    <eflorac@intellique.com=
>=0A                    |   +33 1 78 94 84 02=0A---------------------------=
---------------------------------------------=0A=0A=0A=0A      
--0-839393850-1273668303=:20130
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D"text/css"><!-- DIV {margin:0px;} --></style></he=
ad><body><div style=3D"font-family:times new roman,new york,times,serif;fon=
t-size:12pt"><div>&gt; So is I do a - dd if=3D/dev/random of=3Ddev/cciss/c0=
d2 , that should fail<br>&gt; and therby confirm that the drive or array ha=
s issues...do i make any<br>&gt; sense here?<br><br>&gt;Uh, you should try =
the other way around to avoid breaking the<br>&gt;filesystem :<br><br>&gt;d=
d if=3D/dev/cciss/c0d2 of=3D/dev/null bs=3D131072<br><br>&gt;If no error oc=
curs it should be OK.<br><br># dd if=3D/dev/cciss/c0d2 of=3D/dev/null bs=3D=
131072<br>796+1 records in<br>796+1 records out<br>#<br><br>doesn't show an=
y errors here ......<br><br>&gt; havent had much success with testing the h=
ard drives, tried mhdd &amp;<br>&gt; seatools with no luck yet.<br><br>&gt;=
What do you mean? Does the tools report any problem with the drives?<br><br=
>mhdd doesnt detect the drives, probably an issue with chipset...still look=
ing for
 tools<br><br>thanks<br><br><br></div><div style=3D"font-family: times new =
roman,new york,times,serif; font-size: 12pt;"><br><div style=3D"font-family=
: arial,helvetica,sans-serif; font-size: 13px;"><font face=3D"Tahoma" size=
=3D"2"><hr size=3D"1"><b><span style=3D"font-weight: bold;">From:</span></b=
> Emmanuel Florac &lt;eflorac@intellique.com&gt;<br><b><span style=3D"font-=
weight: bold;">To:</span></b> Leo Davis &lt;leo1783@yahoo.com&gt;<br><b><sp=
an style=3D"font-weight: bold;">Cc:</span></b> xfs@oss.sgi.com<br><b><span =
style=3D"font-weight: bold;">Sent:</span></b> Wed, May 12, 2010 1:29:02 PM<=
br><b><span style=3D"font-weight: bold;">Subject:</span></b> Re: bad primar=
y superblock - bad magic number !!!<br></font><br>=0ALe Wed, 12 May 2010 02=
:19:16 -0700 (PDT)<br>Leo Davis &lt;<a ymailto=3D"mailto:leo1783@yahoo.com"=
 href=3D"mailto:leo1783@yahoo.com">leo1783@yahoo.com</a>&gt; =E9crivait:<br=
><br>&gt; havent had much success with testing the hard drives, tried mhdd =
&amp;<br>&gt; seatools with no luck yet.<br><br>What do you mean? Does the =
tools report any problem with the drives?<br><br>&gt; So is I do a - dd if=
=3D/dev/random of=3Ddev/cciss/c0d2 , that should fail<br>&gt; and therby co=
nfirm that the drive or array has issues...do i make any<br>&gt; sense here=
?<br><br>Uh, you should try the other way around to avoid breaking the<br>f=
ilesystem :<br><br>dd if=3D/dev/cciss/c0d2 of=3D/dev/null bs=3D131072<br><b=
r>If no error occurs it should be OK.<br><br>-- <br>-----------------------=
-------------------------------------------------<br>Emmanuel Florac&nbsp; =
&nbsp;  |&nbsp;  Direction technique<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |&nbsp;=20
 Intellique<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; |&nbsp;&nbsp;&nbsp; &lt;<a ymailto=3D"mailto:eflorac@intellique.c=
om" href=3D"mailto:eflorac@intellique.com">eflorac@intellique.com</a>&gt;<b=
r>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |&n=
bsp;  +33 1 78 94 84 02<br>------------------------------------------------=
------------------------<br></div></div>=0A</div><br>=0A=0A=0A=0A=0A=0A=0A=
=0A      </body></html>
--0-839393850-1273668303=:20130--


--===============5191667099034534096==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5191667099034534096==--
