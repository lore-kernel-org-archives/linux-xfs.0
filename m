Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 041067CA2
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 18:36:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6EC09AC003
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 16:36:20 -0700 (PDT)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
	(mail-sn1nam02on0075.outbound.protection.outlook.com
	[104.47.36.75]) by cuda.sgi.com with ESMTP id Wbz5EYZVXi2QJTRc
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 16:36:17 -0700 (PDT)
From: Jeff Gibson <jgibson@spscommerce.com>
Subject: XFS on top of LVM span in AWS.  Stripe or are AG's good enough?
Date: Mon, 15 Aug 2016 23:36:14 +0000
Message-ID: <CY1PR04MB20100FE6C3039717BD27825AAC120@CY1PR04MB2010.namprd04.prod.outlook.com>
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
Content-Type: multipart/mixed; boundary="===============8125086661027895980=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============8125086661027895980==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_CY1PR04MB20100FE6C3039717BD27825AAC120CY1PR04MB2010namp_"

--_000_CY1PR04MB20100FE6C3039717BD27825AAC120CY1PR04MB2010namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

So I'm creating an LVM volume with 8 AWS EBS disks that are spanned (linear=
) per Redhat's documentation for Gluster (https://access.redhat.com/documen=
tation/en-US/Red_Hat_Storage/3.1/html/Deployment_Guide_for_Public_Cloud/ch0=
2s03.html#Provisioning_Storage_for_Three-way_Replication_Volumes).

2 questions-

1.  Will XFS's Allocation Groups essentially stripe the data for me or shou=
ld I stripe the underlying volumes with LVM?  I'm not worried as much about=
 data integrity with a stripe/span since Gluster is doing the redundancy wo=
rk.

2.  AWS volumes sometimes have inconsistent performance.  If I understand t=
hings correctly, AG's run in parallel.  In a non-striped volume, if some of=
 the AGs are temporarily slower to respond than others due to one of the un=
derlying volumes being slow, will XFS prefer the quicker responding AGs or =
is I/O always evenly distributed?  If XFS prefers the more responsive AG's =
it seems to me that it would be better NOT to stripe the underlying disk si=
nce all AG's that are distributed in a stripe will continuously hit all com=
ponent volumes, including the slow volume (unless if XFS compensates for th=
is?)

Thank you

--_000_CY1PR04MB20100FE6C3039717BD27825AAC120CY1PR04MB2010namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;back=
ground-color:#FFFFFF;font-family:Calibri,Arial,Helvetica,sans-serif;">
So I'm creating an&nbsp;LVM volume with 8 AWS EBS disks that are spanned (l=
inear) per Redhat's documentation for Gluster&nbsp;(<a href=3D"https://acce=
ss.redhat.com/documentation/en-US/Red_Hat_Storage/3.1/html/Deployment_Guide=
_for_Public_Cloud/ch02s03.html#Provisioning_Storage_for_Three-way_Replicati=
on_Volumes" class=3D"OWAAutoLink" id=3D"LPlnk254608">https://access.redhat.=
com/documentation/en-US/Red_Hat_Storage/3.1/html/Deployment_Guide_for_Publi=
c_Cloud/ch02s03.html#Provisioning_Storage_for_Three-way_Replication_Volumes=
</a>).
 &nbsp;
<div><br>
</div>
<div>2 questions-</div>
<div><br>
</div>
<div>1. &nbsp;<span style=3D"font-family: Calibri, Arial, Helvetica, sans-s=
erif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, NotoColorE=
moji, &quot;Segoe UI Symbol&quot;, &quot;Android Emoji&quot;, EmojiSymbols;=
 font-size: 16px;">Will XFS's Allocation Groups essentially stripe the data=
</span><span style=3D"font-family: Calibri, Arial, Helvetica, sans-serif, &=
quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, NotoColorEmoji, &=
quot;Segoe UI Symbol&quot;, &quot;Android Emoji&quot;, EmojiSymbols; font-s=
ize: 16px;">&nbsp;for
 me or s</span>hould I stripe the underlying volumes with LVM?&nbsp; I'm no=
t worried as much about data integrity with a stripe/span since Gluster is =
doing the redundancy work.</div>
<div><br>
</div>
<div>2. &nbsp;AWS volumes sometimes have inconsistent performance. &nbsp;If=
 I understand things correctly, AG's run in parallel. &nbsp;In a non-stripe=
d volume, if some of the AGs are temporarily slower to respond than others =
due to one of the underlying volumes being slow,
 will XFS prefer the quicker responding AGs or is I/O always evenly distrib=
uted? &nbsp;If XFS prefers the more responsive AG's it seems to me that it =
would be better NOT to stripe the underlying disk since all&nbsp;AG's that =
are&nbsp;distributed&nbsp;in a stripe will continuously&nbsp;hit
 all component volumes, including the slow volume&nbsp;(unless if XFS compe=
nsates for this?<span>)</span></div>
<div><br>
</div>
<div>Thank you</div>
</div>
</body>
</html>

--_000_CY1PR04MB20100FE6C3039717BD27825AAC120CY1PR04MB2010namp_--


--===============8125086661027895980==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8125086661027895980==--
