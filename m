Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67F777F37
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 16:43:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE649AC003
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 14:43:24 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id 4pjUmNmOimdJsmZZ
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jan 2014 14:43:22 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: noob question
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <15F45A6CEAEFE340A264C3346D71EF04C4C339@DCEX01PRD.nvrinc.com>
Date: Mon, 6 Jan 2014 15:43:20 -0700
Message-Id: <E2D1B471-E8DB-4FEC-A5AF-39707D83A7F2@colorremedies.com>
References: <15F45A6CEAEFE340A264C3346D71EF04C4C339@DCEX01PRD.nvrinc.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7217172537015468153=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Fitzgerald, Dan" <dfitzger@nvrinc.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


--===============7217172537015468153==
Content-Type: multipart/alternative; boundary="Apple-Mail=_3B7D1D76-9736-4DE3-97ED-286813F1BD40"


--Apple-Mail=_3B7D1D76-9736-4DE3-97ED-286813F1BD40
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Jan 6, 2014, at 3:11 PM, "Fitzgerald, Dan" <dfitzger@nvrinc.com> =
wrote:
>=20
> data     =3D                       bsize=3D4096   blocks=3D19323392, =
imaxpct=3D25

It's a 73.7GiB file system.
>=20
> /space# df -k .
> Filesystem     1K-blocks     Used Available Use% Mounted on
> /dev/sda8       77255828 15375660  61880168  20% /space

On a 73.7GiB partition.=20

You need to make the partition bigger if you want the file system =
bigger.

>  I=92m told that the presented disk was extended by 150Gb in VMWare. =
How can I verify that?=20

Something's confused. Have you restarted the VM and then check with:

parted -l /dev/sda u s p
or
gdisk -l /dev/sda    #if gpt partitions, gdisk is friendlier than =
parted, same syntax as fdisk

Chris Murphy=

--Apple-Mail=_3B7D1D76-9736-4DE3-97ED-286813F1BD40
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=windows-1252

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dwindows-1252"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><br><div><div>On Jan 6, 2014, at 3:11 PM, "Fitzgerald, Dan" &lt;<a =
href=3D"mailto:dfitzger@nvrinc.com">dfitzger@nvrinc.com</a>&gt; =
wrote:</div><blockquote type=3D"cite"><div lang=3D"EN-US" link=3D"blue" =
vlink=3D"purple" style=3D"font-family: Verdana; font-size: medium; =
font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: 2; text-align: =
-webkit-auto; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px; "><div class=3D"WordSection1"><br><div =
style=3D"margin: 0in 0in 0.0001pt; font-size: 11pt; font-family: =
Calibri, sans-serif; "><span style=3D"font-family: 'Courier New'; =
">data&nbsp;&nbsp;&nbsp;&nbsp; =
=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
bsize=3D4096&nbsp;&nbsp; blocks=3D19323392, =
imaxpct=3D25</span></div></div></div></blockquote><div><br></div>It's a =
73.7GiB file system.<br><blockquote type=3D"cite"><div lang=3D"EN-US" =
link=3D"blue" vlink=3D"purple" style=3D"font-family: Verdana; font-size: =
medium; font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: 2; text-align: =
-webkit-auto; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px; "><div class=3D"WordSection1"><div =
style=3D"margin: 0in 0in 0.0001pt; font-size: 11pt; font-family: =
Calibri, sans-serif; "><br></div><div style=3D"margin: 0in 0in 0.0001pt; =
font-size: 11pt; font-family: Calibri, sans-serif; "><span =
style=3D"font-family: 'Courier New'; ">/space# df -k .</span></div><div =
style=3D"margin: 0in 0in 0.0001pt; font-size: 11pt; font-family: =
Calibri, sans-serif; "><span style=3D"font-family: 'Courier New'; =
">Filesystem&nbsp;&nbsp;&nbsp;&nbsp; 1K-blocks&nbsp;&nbsp;&nbsp;&nbsp; =
Used Available Use% Mounted on</span></div><div style=3D"margin: 0in 0in =
0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; "><span =
style=3D"font-family: 'Courier New'; =
">/dev/sda8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 77255828 15375660&nbsp; =
61880168&nbsp; 20% =
/space</span></div></div></div></blockquote><div><br></div><div>On a =
73.7GiB partition.&nbsp;</div><div><br></div><div>You need to make the =
partition bigger if you want the file system =
bigger.</div><br><blockquote type=3D"cite"><div lang=3D"EN-US" =
link=3D"blue" vlink=3D"purple" style=3D"font-family: Verdana; font-size: =
medium; font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: 2; text-align: =
-webkit-auto; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px; "><div class=3D"WordSection1"><p =
class=3D"MsoNormal" style=3D"margin: 0in 0in 0.0001pt; font-size: 11pt; =
font-family: Calibri, sans-serif; "><span style=3D"font-family: 'Courier =
New'; ">&nbsp;</span><span style=3D"font-family: 'Courier New'; =
font-size: 11pt; ">I=92m told that the presented disk was extended by =
150Gb in VMWare. How can I verify =
that?&nbsp;</span></p></div></div></blockquote><br></div><div>Something's =
confused. Have you restarted the VM and then check =
with:</div><div><br></div><div>parted -l /dev/sda u s =
p</div><div>or</div><div>gdisk -l /dev/sda &nbsp; &nbsp;#if gpt =
partitions, gdisk is friendlier than parted, same syntax as =
fdisk</div><div><br></div><div>Chris Murphy</div></body></html>=

--Apple-Mail=_3B7D1D76-9736-4DE3-97ED-286813F1BD40--


--===============7217172537015468153==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7217172537015468153==--
