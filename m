Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KC3wMf019108 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 07:03:58 -0500
Received: from mail.sotech1.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AB1F45B225
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 05:06:57 -0700 (PDT)
Received: from mail.sotech1.com (sl-speci32-137461-0.sprintlink.net
	[144.232.190.126]) by cuda.sgi.com with ESMTP id
	DbWoFMlIZCEyUkAh for <xfs@oss.sgi.com>;
	Tue, 20 Jul 2010 05:06:57 -0700 (PDT)
From: Andrew Debenham <adebenham@sotech1.com>
Date: Tue, 20 Jul 2010 08:06:57 -0400
Subject: Calculating swidth On A RAID6 Volume
Message-ID: <3C5E029826A0704DB5998577FCFF46F0094DA1AD69@dagobah>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5641772758040046949=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5641772758040046949==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_3C5E029826A0704DB5998577FCFF46F0094DA1AD69dagobah_"

--_000_3C5E029826A0704DB5998577FCFF46F0094DA1AD69dagobah_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello -

I'm am new to XFS and am in the process of trying to tune an XFS file syste=
m.  I spent some time searching through this mailing list's archives but wa=
sn't able to find anything that matched the question that I have (I apologi=
ze in advance if this issue has already been addressed).

I have a 3ware 9650SE-12M installed and have a RAID6 unit with 11 x 1.82 TB=
 SATA drives and stripe size of 256KB.  I found an earlier thread that disc=
ussed calculating the values for sunit and swidth for RAID5, which stated t=
hat the swidth would be "sunit x (# disks in stripe - 1)".  So, finally the=
 question - would the swidth for a RAID6 volume be "sunit x (# disks in str=
ipe -2)?

If that is the case, then here is what I would expect my values to be:
sunit =3D 512
swidth =3D 4608

Would that be correct?  Thanks in advance for your help in this matter!

- Andrew

________________________________
This email and any attachments may be confidential and are intended solely =
for the use of the individual to whom it is addressed.

If you are not the intended recipient of this email, the following stipulat=
ions govern the use of this information: You may not take any action based =
upon its contents. You may not copy or show this message or attachments to =
anyone. You should contact the sender and subsequently delete this message =
and all attachments.

Any views or opinions expressed are solely those of the author and do not n=
ecessarily represent those of Special Operations Technology, Incorporated.

While antivirus software has been applied, you should perform due diligence=
 to check this email and attachments for the presence of viruses. No warran=
ties or assurances are made in relation to the safety and content of this e=
mail and attachments. Special Operations Technology, Incorporated accepts n=
o liability for any damages caused by any virus transmitted by or contained=
 in this email and attachments.

No liability is accepted for any consequences arising from this email trans=
mission whatsoever.

Special Operations Technology, Incorporated is a premier IT professional se=
rvices firm focused in the government and law enforcement space.

--_000_3C5E029826A0704DB5998577FCFF46F0094DA1AD69dagobah_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html dir=3D"ltr">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style id=3D"owaTempEditStyle"></style><style title=3D"owaParaStyle"><!--P =
{
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px
}
--></style>
</head>
<body ocsi=3D"x">
<div style=3D"FONT-FAMILY: Tahoma; DIRECTION: ltr; COLOR: #000000; FONT-SIZ=
E: 13px">
<div></div>
<div dir=3D"ltr"><font color=3D"#000000" size=3D"2" face=3D"Tahoma">Hello -=
</font></div>
<div dir=3D"ltr"><font size=3D"2" face=3D"tahoma"></font>&nbsp;</div>
<div dir=3D"ltr"><font size=3D"2" face=3D"tahoma">I'm am new to&nbsp;XFS<a>=
</a> and am in the process of trying to tune an&nbsp;XFS<a></a> file system=
.&nbsp; I spent some time searching through this mailing list's archives bu=
t wasn't able to find anything that matched the question
 that I have (I apologize in advance if this issue has already been address=
ed).</font></div>
<div dir=3D"ltr"><font size=3D"2" face=3D"tahoma"></font>&nbsp;</div>
<div dir=3D"ltr"><font size=3D"2" face=3D"tahoma">I have a&nbsp;3ware<a></a=
>&nbsp;9650SE-12M<a></a> installed and have a&nbsp;RAID6<a></a> unit with 1=
1 x 1.82 TB&nbsp;SATA<a></a> drives and stripe size of 256KB<a></a>.&nbsp; =
I found an earlier thread that discussed calculating the values
 for&nbsp;sunit<a></a> and&nbsp;swidth<a></a> for RAID5<a></a>, which state=
d that the&nbsp;swidth<a></a> would be &quot;sunit<a></a> x (# disks in str=
ipe - 1)&quot;.&nbsp;&nbsp;So, finally the question - would&nbsp;the&nbsp;s=
width<a></a> for a&nbsp;RAID6<a></a> volume be &quot;sunit<a></a> x (# disk=
s in stripe
 -2)?</font></div>
<div dir=3D"ltr">&nbsp;</div>
<div dir=3D"ltr"><font size=3D"2" face=3D"tahoma">If that is the case, then=
 here is what I would expect my values to be:</font></div>
<div dir=3D"ltr"><font size=3D"2"><a></a><font size=3D"2">sunit</font>&nbsp=
;=3D 512</font></div>
<div dir=3D"ltr"><font size=3D"2" face=3D"tahoma"><a></a><font size=3D"2" f=
ace=3D"tahoma">swidth</font>&nbsp;=3D 4608</font></div>
<div dir=3D"ltr">&nbsp;</div>
<div dir=3D"ltr"><font size=3D"2" face=3D"tahoma">Would that be correct?&nb=
sp; Thanks in advance for your help in this matter!</font></div>
<div dir=3D"ltr">&nbsp;</div>
<div dir=3D"ltr"><font size=3D"2" face=3D"tahoma">- Andrew</font>&nbsp;</di=
v>
</div>
<br>
<hr>
<font face=3D"Courier New" color=3D"Gray" size=3D"1">This email and any att=
achments may be confidential and are intended solely for the use of the ind=
ividual to whom it is addressed.<br>
<br>
If you are not the intended recipient of this email, the following stipulat=
ions govern the use of this information: You may not take any action based =
upon its contents. You may not copy or show this message or attachments to =
anyone. You should contact the sender
 and subsequently delete this message and all attachments.<br>
<br>
Any views or opinions expressed are solely those of the author and do not n=
ecessarily represent those of Special Operations Technology, Incorporated.<=
br>
<br>
While antivirus software has been applied, you should perform due diligence=
 to check this email and attachments for the presence of viruses. No warran=
ties or assurances are made in relation to the safety and content of this e=
mail and attachments. Special Operations
 Technology, Incorporated accepts no liability for any damages caused by an=
y virus transmitted by or contained in this email and attachments.<br>
<br>
No liability is accepted for any consequences arising from this email trans=
mission whatsoever.<br>
<br>
Special Operations Technology, Incorporated is a premier IT professional se=
rvices firm focused in the government and law enforcement space.<br>
</font>
</body>
</html>

--_000_3C5E029826A0704DB5998577FCFF46F0094DA1AD69dagobah_--


--===============5641772758040046949==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5641772758040046949==--
