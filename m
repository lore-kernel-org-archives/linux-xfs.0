Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 00ED07F3F
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 12:37:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6951EAC023
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 10:37:46 -0800 (PST)
Received: from internal-smtp3.wesleyan.edu (internal-smtp3.wesleyan.edu
	[129.133.6.182]) by cuda.sgi.com with ESMTP id yiS9HrCVqQ45GCHV
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Dec 2014 10:37:44 -0800 (PST)
Received: from exchcas3.wesad.wesleyan.edu (exchcas3.wesleyan.edu
	[129.133.6.93])
	by msa.wesleyan.edu (8.14.4/8.14.4) with ESMTP id sBAIbg6k020255
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 13:37:42 -0500
From: "Meij, Henk" <hmeij@wesleyan.edu>
Subject: xfs_quota off/remove
Date: Wed, 10 Dec 2014 18:37:41 +0000
Message-ID: <8688BD11DAC0574AA90295127E9E9F4AC04DD4FF@exchangewes8.wesad.wesleyan.edu>
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
Content-Type: multipart/mixed; boundary="===============7022712079796782389=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============7022712079796782389==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_8688BD11DAC0574AA90295127E9E9F4AC04DD4FFexchangewes8wes_"

--_000_8688BD11DAC0574AA90295127E9E9F4AC04DD4FFexchangewes8wes_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Is off/remove working for xfs_quota? I seem to not be able to zero out the =
project quota metadata and move the project to another partition. I did not=
 remove the entries in the /etc/proj* files.



-Henk



 1308  xfs_quota -x -c 'project -s data_1_hmeij'
 1309  xfs_quota -x -c 'report -h -bi' /data/1



User quota on /data/1 (/dev/sdb1)
                        Blocks
User ID      Used   Soft   Hard Warn/Grace
---------- ---------------------------------
root            0      0      0  00 [------]
hmeij      854.4M      0      0  00 [------]

Project quota on /data/1 (/dev/sdb1)
                        Blocks
Project ID   Used   Soft   Hard Warn/Grace
---------- ---------------------------------
data_1_hmeij 854.4M      0      0  00 [------]



 1318  xfs_quota -x -c 'off' -c 'remove' /data/1

 1331  umount /data/1; mount /data1



 1333  xfs_quota -x -c 'report -h' /data/1



same report output, same metadata ...

--_000_8688BD11DAC0574AA90295127E9E9F4AC04DD4FFexchangewes8wes_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html dir=3D"ltr">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<meta name=3D"GENERATOR" content=3D"MSHTML 11.00.9600.17420">
<style id=3D"owaParaStyle">P {
	MARGIN-BOTTOM: 0px; MARGIN-TOP: 0px
}
</style>
</head>
<body fPStyle=3D"1" ocsi=3D"0">
<div style=3D"direction: ltr;font-family: Arial;color: #000000;font-size: 1=
0pt;">
<p>Is off/remove working for xfs_quota? I seem to not be able to zero out t=
he project quota metadata and move the project to another partition. I did =
not remove the entries in the /etc/proj* files.</p>
<p>&nbsp;</p>
<p>-Henk</p>
<p>&nbsp;</p>
<p>&nbsp;1308&nbsp; xfs_quota -x -c 'project -s data_1_hmeij'<br>
&nbsp;1309&nbsp; xfs_quota -x -c 'report -h -bi' /data/1</p>
<p>&nbsp;</p>
<p>User quota on /data/1 (/dev/sdb1)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>
User ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Used&nbsp;&nbsp; Soft&nbsp;&nbsp; Har=
d Warn/Grace&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; <br>
---------- ---------------------------------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>
root&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp; 00 [---=
---]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>
hmeij&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 854.4M&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp; 00 [------]&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </p>
<p>Project quota on /data/1 (/dev/sdb1)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <=
br>
Project ID&nbsp;&nbsp; Used&nbsp;&nbsp; Soft&nbsp;&nbsp; Hard Warn/Grace&nb=
sp;&nbsp; <br>
---------- --------------------------------- <br>
data_1_hmeij 854.4M&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; 0&nbsp; 00 [------]</p>
<p>&nbsp;</p>
<p>&nbsp;1318&nbsp; xfs_quota -x -c 'off' -c 'remove' /data/1</p>
<p><br>
&nbsp;1331&nbsp; umount /data/1; mount /data1</p>
<p>&nbsp;</p>
<p>&nbsp;1333&nbsp; xfs_quota -x -c 'report -h' /data/1</p>
<p>&nbsp;</p>
<p>same report output, same metadata&nbsp;...<br>
</p>
</div>
</body>
</html>

--_000_8688BD11DAC0574AA90295127E9E9F4AC04DD4FFexchangewes8wes_--


--===============7022712079796782389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7022712079796782389==--
