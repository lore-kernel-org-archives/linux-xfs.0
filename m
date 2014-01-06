Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F1117F37
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 16:11:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A794304043
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 14:11:37 -0800 (PST)
Received: from mail.nvrinc.com (mail.nvrinc.com [204.96.165.75]) by
	cuda.sgi.com with ESMTP id mLBe5oSrcCDVOjaO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Jan 2014 14:11:32 -0800 (PST)
Received: from pps.filterd (vmdcdmzgw03prd.dmz.net [127.0.0.1])
	by vmdcdmzgw03prd.dmz.net (8.14.5/8.14.5) with SMTP id s06MATp8008543
	for <xfs@oss.sgi.com>; Mon, 6 Jan 2014 17:11:31 -0500
Received: from dcex02prd.nvrinc.com (dcex02prd.nvrinc.com [10.6.1.11])
	by vmdcdmzgw03prd.dmz.net with ESMTP id 1h82st8hgy-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Mon, 06 Jan 2014 17:11:31 -0500
From: "Fitzgerald, Dan" <dfitzger@nvrinc.com>
Subject: noob question
Date: Mon, 6 Jan 2014 22:11:30 +0000
Message-ID: <15F45A6CEAEFE340A264C3346D71EF04C4C339@DCEX01PRD.nvrinc.com>
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
Content-Type: multipart/mixed; boundary="===============3715721733700710197=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============3715721733700710197==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_15F45A6CEAEFE340A264C3346D71EF04C4C339DCEX01PRDnvrincco_"

--_000_15F45A6CEAEFE340A264C3346D71EF04C4C339DCEX01PRDnvrincco_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I had our VMWare admin extend the file system on which /space is mounted (/=
dev/sda8). I'm trying to expand the file system. In the short time I've bee=
n researching, it appears that I want to use xfs_growfs.

I'm both a debian and xfs noob, used to AIX. This is the first day of my se=
cond week here, and as I'm the closest thing here to a linux admin, I get t=
he opportunity to learn. This is a box that is not yet in production, and t=
he anticipation is that the /space directory will need to be twice its' cur=
rent size once the real data starts showing up.

System specifics:

root@thisbox:/# xfs_repair -V
xfs_repair version 3.1.7

root@thisbox:/# uname -a
Linux vmdamims01apl 3.10-0.bpo.2-amd64 #1 SMP Debian 3.10.5-1~bpo70+1+ims1 =
(2013-08-19) x86_64 GNU/Linux

Here's what I get when I try to use xfs_growfs, both the -d and the -D opti=
on (the 25000000 size is an arbitrary number above 19323392):

root@vmdamims01apl:/# xfs_growfs -d /space
meta-data=3D/dev/sda8              isize=3D256    agcount=3D4, agsize=3D483=
0848 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D19323392, imaxpc=
t=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D9435, version=3D=
2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data size 19323391 too small, old size is 19323392

root@vmdamims01apl:/# xfs_growfs -D 25000000 /space
meta-data=3D/dev/sda8              isize=3D256    agcount=3D4, agsize=3D483=
0848 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D19323392, imaxpc=
t=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D9435, version=3D=
2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data size 25000000 too large, maximum is 19323391

df -k . says this:

/space# df -k .
Filesystem     1K-blocks     Used Available Use% Mounted on
/dev/sda8       77255828 15375660  61880168  20% /space

Any help in getting me on track appreciated: don't mind doing the work & th=
e reading, quite willing to be self-sufficient, but a shove in the right di=
rection would be a great help. One thing I'd like to do is see what space i=
s actually available: I'm told that the presented disk was extended by 150G=
b in VMWare. How can I verify that? Thanks!

Regards,

Dan




_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _=
 _ _ _ _ _ _ _ _ _ _ _ _ This email is confidential and intended solely for=
 the use of the individual to whom it is addressed. If you have received th=
is email in error please contact the sender and be advised that any use, di=
ssemination, forwarding, printing, or copying of this email is strictly pro=
hibited. The terms for the purchase and sale of any property referenced in =
this email shall be solely determined by a ratified Purchase Agreement. Any=
 information provided in this email, including but not limited to, pricing,=
 financing, features of a property and/or community, is not to be construed=
 as the basis of the bargain for the purchase and sale of any such property=
.

--_000_15F45A6CEAEFE340A264C3346D71EF04C4C339DCEX01PRDnvrincco_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<style>
<!--
@font-face
	{font-family:Calibri}
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif"}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline}
span.EmailStyle17
	{font-family:"Calibri","sans-serif";
	color:windowtext}
.MsoChpDefault
	{font-family:"Calibri","sans-serif"}
@page WordSection1
	{margin:1.0in 1.0in 1.0in 1.0in}
div.WordSection1
	{}
-->
</style>
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">I had our VMWare admin extend the file system on whi=
ch /space is mounted (/dev/sda8). I&#8217;m trying to expand the file syste=
m. In the short time I&#8217;ve been researching, it appears that I want to=
 use xfs_growfs.</p>
<p class=3D"MsoNormal">&nbsp;</p>
<p class=3D"MsoNormal">I&#8217;m both a debian and xfs noob, used to AIX. T=
his is the first day of my second week here, and as I&#8217;m the closest t=
hing here to a linux admin, I get the opportunity to learn. This is a box t=
hat is not yet in production, and the anticipation
 is that the /space directory will need to be twice its&#8217; current size=
 once the real data starts showing up.</p>
<p class=3D"MsoNormal">&nbsp;</p>
<p class=3D"MsoNormal">System specifics:</p>
<p class=3D"MsoNormal">&nbsp;</p>
<p class=3D"MsoNormal">root@thisbox:/# xfs_repair -V</p>
<p class=3D"MsoNormal">xfs_repair version 3.1.7</p>
<p class=3D"MsoNormal">&nbsp;</p>
<p class=3D"MsoNormal">root@thisbox:/# uname -a</p>
<p class=3D"MsoNormal">Linux vmdamims01apl 3.10-0.bpo.2-amd64 #1 SMP Debian=
 3.10.5-1~bpo70&#43;1&#43;ims1 (2013-08-19) x86_64 GNU/Linux</p>
<p class=3D"MsoNormal">&nbsp;</p>
<p class=3D"MsoNormal">Here&#8217;s what I get when I try to use xfs_growfs=
, both the &#8211;d and the &#8211;D option (the 25000000 size is an arbitr=
ary number above 19323392):</p>
<p class=3D"MsoNormal">&nbsp;</p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
root@vmdamims01apl:/# xfs_growfs -d /space</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
meta-data=3D/dev/sda8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; isize=3D256&nbsp;&nbsp;&nbsp; agcount=3D4, agsize=
=3D4830848 blks</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=3D512&nbsp;&nbsp; attr=3D2</span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
data&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; bsize=3D4096&nbsp;&nbsp; blocks=3D19323392, imaxpct=3D25</sp=
an></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sunit=3D0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
swidth=3D0 blks</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
naming&nbsp;&nbsp; =3Dversion 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=3D4096&nbsp;&nbsp; ascii-ci=3D0</s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3Dinternal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=3D4096&nbsp; &=
nbsp;blocks=3D9435, version=3D2</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=3D512&nbsp;&nbsp; sunit=3D0 blks,=
 lazy-count=3D1</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
realtime =3Dnone&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; extsz=3D4096&nbsp;&nbsp; =
blocks=3D0, rtextents=3D0</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
data size 19323391 too small, old size is 19323392</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
&nbsp;</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
root@vmdamims01apl:/# xfs_growfs -D 25000000 /space</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
meta-data=3D/dev/sda8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; isize=3D256&nbsp;&nbsp;&nbsp; agcount=3D4, agsize=
=3D4830848 blks</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=3D512&nbsp;&nbsp; attr=3D2</span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
data&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; bsize=3D4096&nbsp;&nbsp; blocks=3D19323392, imaxpct=3D25</sp=
an></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sunit=3D0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
swidth=3D0 blks</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
naming&nbsp;&nbsp; =3Dversion 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=3D4096&nbsp;&nbsp; ascii-ci=3D0</s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3Dinternal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=3D4096&nbsp;&n=
bsp; blocks=3D9435, version=3D2</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=3D512&nbsp;&nbsp; sunit=3D0 blks,=
 lazy-count=3D1</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
realtime =3Dnone&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; extsz=3D4096&nbsp;&nbsp; =
blocks=3D0, rtextents=3D0</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
data size 25000000 too large, maximum is 19323391</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
&nbsp;</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
df &#8211;k . says this:</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
&nbsp;</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
/space# df -k .</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Filesystem&nbsp;&nbsp;&nbsp;&nbsp; 1K-blocks&nbsp;&nbsp;&nbsp;&nbsp; Used A=
vailable Use% Mounted on</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
/dev/sda8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 77255828 15375660&nbsp; 61880=
168&nbsp; 20% /space</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
&nbsp;</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Any help in getting me on track appreciated: don&#8217;t mind doing the wor=
k &amp; the reading, quite willing to be self-sufficient, but a shove in th=
e right direction would be a great help. One thing I&#8217;d like
 to do is see what space is actually available: I&#8217;m told that the pre=
sented disk was extended by 150Gb in VMWare. How can I verify that? Thanks!=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
&nbsp;</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Regards,</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
&nbsp;</span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Dan</span></p>
<p class=3D"MsoNormal">&nbsp;</p>
<p class=3D"MsoNormal">&nbsp;</p>
<p class=3D"MsoNormal">&nbsp;</p>
<p class=3D"MsoNormal">&nbsp;</p>
</div>
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _=
 _ _ _ _ _ _ _ _ _ _ _ _ This email is confidential and intended solely for=
 the use of the individual to whom it is addressed. If you have received th=
is email in error please contact
 the sender and be advised that any use, dissemination, forwarding, printin=
g, or copying of this email is strictly prohibited. The terms for the purch=
ase and sale of any property referenced in this email shall be solely deter=
mined by a ratified Purchase Agreement.
 Any information provided in this email, including but not limited to, pric=
ing, financing, features of a property and/or community, is not to be const=
rued as the basis of the bargain for the purchase and sale of any such prop=
erty.
</body>
</html>

--_000_15F45A6CEAEFE340A264C3346D71EF04C4C339DCEX01PRDnvrincco_--


--===============3715721733700710197==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3715721733700710197==--
