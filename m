Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB5CA7CA0
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 10:45:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 893D4304062
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 08:45:50 -0700 (PDT)
Received: from nm15-vm4.bullet.mail.sg3.yahoo.com
	(nm15-vm4.bullet.mail.sg3.yahoo.com [106.10.149.51]) by
	cuda.sgi.com with ESMTP id RJ6nhR0pfrFBEbEf (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 08:45:48 -0700 (PDT)
Date: Tue, 9 Aug 2016 15:43:03 +0000 (UTC)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Message-ID: <291675510.10842010.1470757383533.JavaMail.yahoo@mail.yahoo.com>
In-Reply-To: <7faf941c-2188-589d-b624-9fedb22dee40@telefonica.net>
References: <5787852A.7030900@st-andrews.ac.uk>
	<20160808161132.1d76eb5c@harpe.intellique.com>
	<1470670691.8958.11.camel@filmlight.ltd.uk>
	<20160808174427.24d8272c@harpe.intellique.com>
	<592673683.10446004.1470715375850.JavaMail.yahoo@mail.yahoo.com>
	<7faf941c-2188-589d-b624-9fedb22dee40@telefonica.net>
Subject: Re: Advice needed with file system corruption
MIME-Version: 1.0
Reply-To: Gim Leong Chin <chingimleong@yahoo.com.sg>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8451113948269555530=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Carlos E. R." <robin.listas@telefonica.net>, XFS mail list <xfs@oss.sgi.com>

--===============8451113948269555530==
Content-Type: multipart/alternative;
	boundary="----=_Part_10842009_715577767.1470757383530"

------=_Part_10842009_715577767.1470757383530
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2016-08-09 06:02, Gim Leong Chin wrote:



>> Drives connected to RAID controllers with battery backed cache should
>> have their caches "disabled" (they are really set to write through mode
>> instead).=C2=A0 By the way, I found out in lab testing that 7200 RPM SAT=
A
>> drives suffer a big performance loss when doing sequential writes in
>> cache write through mode.<
> If you disable the disk internal cache, as a consequence you also
> disable the disk internal write optimizations. It has to be much slower
> at writing. It seems to me obvious.

> --=20
> Cheers / Saludos,

=C2=A0> =C2=A0 =C2=A0=C2=A0=C2=A0 Carlos E. R.
=C2=A0> =C2=A0 =C2=A0=C2=A0=C2=A0 (from 13.1 x86_64 "Bottle" at Telcontar)

The drop in sequential write data rate for 3.5" 7200 RPM SATA drives was ar=
ound 50%, I cannot remember the exact numbers, that is not obvious to me.

As a reminder, the drive cache is really set to write through mode, it is n=
ot possible to disable the cache, as an application engineer from HGST told=
 me, so the drive internal write optimizations are still there, just that t=
he IO command is reported to be completed only when the data has been write=
n to the drive platter.

10k and 15k RPM SAS drives connected to LSI Internal RAID controllers have =
their drive cache "disabled" automatically, I wonder how much is the data r=
ate drop compared to drive cache "enabled", considering that LSI IR control=
lers do not have cache.

GL
  
------=_Part_10842009_715577767.1470757383530
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div style=3D"color:#000; background-color:#fff; f=
ont-family:Helvetica Neue-Light, Helvetica Neue Light, Helvetica Neue, Helv=
etica, Arial, Lucida Grande, Sans-Serif;font-size:13px">On 2016-08-09 06:02=
, Gim Leong Chin wrote:<div class=3D"qtdSeparateBR"><br><br></div><div styl=
e=3D"display: block;" id=3D"yui_3_16_0_ym19_1_1470711140752_131353" class=
=3D"yahoo_quoted"><div id=3D"yui_3_16_0_ym19_1_1470711140752_131352" style=
=3D"font-family: Helvetica Neue-Light, Helvetica Neue Light, Helvetica Neue=
, Helvetica, Arial, Lucida Grande, Sans-Serif; font-size: 13px;"><div id=3D=
"yui_3_16_0_ym19_1_1470711140752_131351" style=3D"font-family: HelveticaNeu=
e, Helvetica Neue, Helvetica, Arial, Lucida Grande, Sans-Serif; font-size: =
16px;"><div id=3D"yui_3_16_0_ym19_1_1470711140752_131356" class=3D"y_msg_co=
ntainer"><div class=3D"yqt2590360911" id=3D"yqtfd69442"><br clear=3D"none">=
<br clear=3D"none">&gt;&gt; Drives connected to RAID controllers with batte=
ry backed cache should<br clear=3D"none">&gt;&gt; have their caches "disabl=
ed" (they are really set to write through mode<br clear=3D"none">&gt;&gt; i=
nstead).&nbsp; By the way, I found out in lab testing that 7200 RPM SATA<br=
 clear=3D"none">&gt;&gt; drives suffer a big performance loss when doing se=
quential writes in<br clear=3D"none">&gt;&gt; cache write through mode.&lt;=
</div><br clear=3D"none">&gt; If you disable the disk internal cache, as a =
consequence you also<br clear=3D"none">&gt; disable the disk internal write=
 optimizations. It has to be much slower<br clear=3D"none">&gt; at writing.=
 It seems to me obvious.<br clear=3D"none"><br clear=3D"none">&gt; -- <br c=
lear=3D"none">&gt; Cheers / Saludos,<br clear=3D"none"><br clear=3D"none">&=
nbsp;&gt; &nbsp; &nbsp;&nbsp;&nbsp; Carlos E. R.<br clear=3D"none"><div id=
=3D"yui_3_16_0_ym19_1_1470711140752_132013">&nbsp;&gt; &nbsp; &nbsp;&nbsp;&=
nbsp; (from 13.1 x86_64 "Bottle" at Telcontar)</div><div id=3D"yui_3_16_0_y=
m19_1_1470711140752_132113"><br></div><div id=3D"yui_3_16_0_ym19_1_14707111=
40752_132119"><br></div><div id=3D"yui_3_16_0_ym19_1_1470711140752_132111" =
dir=3D"ltr">The drop in sequential write data rate for 3.5" 7200 RPM SATA d=
rives was around 50%, I cannot remember the exact numbers, that is not obvi=
ous to me.<br id=3D"yui_3_16_0_ym19_1_1470711140752_132101"><br id=3D"yui_3=
_16_0_ym19_1_1470711140752_132103">As a reminder, the drive cache is really=
 set to write through mode, it is not possible to disable the cache, as an =
application engineer from HGST told me, so the drive internal write optimiz=
ations are still there, just that the IO command is reported to be complete=
d only when the data has been writen to the drive platter.<br id=3D"yui_3_1=
6_0_ym19_1_1470711140752_132104"><br id=3D"yui_3_16_0_ym19_1_1470711140752_=
132106">10k and 15k RPM SAS drives connected to LSI Internal RAID controlle=
rs have their drive cache "disabled" automatically, I wonder how much is th=
e data rate drop compared to drive cache "enabled", considering that LSI IR=
 controllers do not have cache.<br id=3D"yui_3_16_0_ym19_1_1470711140752_13=
2107"><br id=3D"yui_3_16_0_ym19_1_1470711140752_132110">GL<br></div></div> =
</div> </div>  </div></div></body></html>
------=_Part_10842009_715577767.1470757383530--


--===============8451113948269555530==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8451113948269555530==--
