Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 917927CA3
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2016 13:23:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62252304051
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2016 11:23:26 -0700 (PDT)
Received: from COL004-OMC2S17.hotmail.com (col004-omc2s17.hotmail.com
	[65.55.34.91]) by cuda.sgi.com with ESMTP id eEukQUJwVTAnoAVf
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2016 11:23:24 -0700 (PDT)
From: Anthony l <Martinezant2141@live.com>
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
Date: Fri, 1 Jul 2016 18:23:21 +0000
Message-ID: <SN1PR05MB23179FAACBDA0B885FE11D06CC250@SN1PR05MB2317.namprd05.prod.outlook.com>
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
	<SN1PR05MB23175D5BF190CCC3F22E2EB0CC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<4d9d00ef-82d5-a658-e88c-ba75fb7a6023@sandeen.net>
	<SN1PR05MB2317E464B2CFB5A06CC4B66BCC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<dc20d8ae-d57f-53f1-72b8-d623529c695b@sandeen.net>
	<20160630220737.GS12670@dastard>,
	<BFF5CB1A-BA65-4212-9607-2F25F427433B@animezone.org>
In-Reply-To: <BFF5CB1A-BA65-4212-9607-2F25F427433B@animezone.org>
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
Content-Type: multipart/mixed; boundary="===============3580839966424512389=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andrew Ho <andrewho@animezone.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============3580839966424512389==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_SN1PR05MB23179FAACBDA0B885FE11D06CC250SN1PR05MB2317namp_"

--_000_SN1PR05MB23179FAACBDA0B885FE11D06CC250SN1PR05MB2317namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Thanks for the suggestions again.

Still banging my head against a wall.

So  I was trying a bunch of xfsrestore commands anything from -m -k -b to a=
ll three but still the same result every time.

xfsrestore -K -m -b 4096 -f /dev/nst0 ./

xfsrestore  -K -r -f /dev/nst0 ./


I don't think this is a corrupt tape or anything because I have around 7 -1=
0 tapes that are all made on the irix machine, but all behave the same. I h=
ave tried tar before but I get this is not a tar file or gzip file somethin=
g like that.

But I do have an observation. I had a tape (not made on the irix system) an=
d I was able to pull a direct transfer of files with the dd command. i.e dd=
 if=3D/dev/nst0 of=3D./somefile1 ibs =3D64k

And I would only have to do this 3 -4 times to get like 30+ GBs of data off=
 the tapes and a simple tar xvf command extracted these files just fine. Bu=
t my question is how come when I try to do these with the tapes made on the=
 Irix machine I only get about 200 mb at a time and there are like 190+ fil=
es on each tape. Is this normal for an xfs file system on a tape drive?


--_000_SN1PR05MB23179FAACBDA0B885FE11D06CC250SN1PR05MB2317namp_
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
<p>Thanks for the suggestions again.&nbsp;</p>
<p>Still banging my head against a wall.&nbsp;</p>
<p>So &nbsp;I was trying a bunch of xfsrestore commands anything from -m -k=
 -b to all three but still the same result every&nbsp;time.&nbsp;</p>
<p>xfsrestore -K -m -b 4096 -f /dev/nst0 ./</p>
<p>xfsrestore&nbsp;&nbsp;-K -r -f /dev/nst0 ./&nbsp;</p>
<p><br>
</p>
<p>I don't think this is a corrupt tape or anything because I have around 7=
 -10 tapes that are all made on the irix machine, but all behave the same. =
I have tried tar before but I get this is not a tar file or gzip file somet=
hing like that.&nbsp;</p>
<p>But I do have an observation. I had a tape (not made on the irix system)=
 and I was able to pull a direct transfer of files with the dd command. i.e=
 dd if=3D/dev/nst0 of=3D./somefile1 ibs =3D64k&nbsp;</p>
<p>And I would only have to do this 3 -4 times to get like 30&#43; GBs of d=
ata off the tapes and a simple tar xvf command extracted these files just f=
ine. But my question is how come when I try to do these with the tapes made=
 on the Irix machine I only get about
 200 mb at a time and there are like 190&#43; files on each tape. Is this n=
ormal for an xfs file system on a tape drive?</p>
<p><br>
</p>
<div style=3D"color: rgb(0, 0, 0);"></div>
</div>
</body>
</html>

--_000_SN1PR05MB23179FAACBDA0B885FE11D06CC250SN1PR05MB2317namp_--


--===============3580839966424512389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3580839966424512389==--
