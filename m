Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C05027CA1
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 13:48:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4845AAC005
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 11:48:37 -0700 (PDT)
Received: from SNT004-OMC1S28.hotmail.com (snt004-omc1s28.hotmail.com
	[65.55.90.39]) by cuda.sgi.com with ESMTP id RsQADCCmyEpEfgan
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2016 11:48:31 -0700 (PDT)
From: Anthony l <Martinezant2141@live.com>
Subject: Question: Old Irix tape backup. Recovery on Linux (xfsdump/xfsrestore)
Date: Wed, 29 Jun 2016 18:48:29 +0000
Message-ID: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
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
Content-Type: multipart/mixed; boundary="===============0134416426479067056=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0134416426479067056==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_SN1PR05MB231785E5196A5D31D0D833EACC230SN1PR05MB2317namp_"

--_000_SN1PR05MB231785E5196A5D31D0D833EACC230SN1PR05MB2317namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello Anthony here,

I'm not sure if this is the correct place to send a question, If I am wrong=
 I would appreciate if you could send me in the right direction.  I have co=
me across the oss.sgi forums a lot looking for a solution to my problem but=
 I could not find much.


Here's my situation.

I have a bunch a tapes that were created way back when using an IRIX system=
. Some kind of version 6, perhaps even the latest version. anyway I am able=
 to peak at the headers to determind the the file type on the drive is inde=
ed:

xFSdump0....   or when I make a sample using 'dd if=3D/dev/nst0 of=3D./test=
.img' '+ 'file test.img' I get XFSDUMP archive (version 2)

So, instinctively to get the data off the tapes I would think would be as s=
imple as:

sudo xfsrestore -f /dev/nst0 ./path to where I want it stored

Then I get:

using dump format 3

xfsrestore: searching media for dump

xfsrestore: preparing drive

xfsrestore: examining media file 1

...

xfsrestore examining media file xx

the following dump has been found on drive 0:

hostname: isp---------(stuff)

mount point: /isp-iga

volume: /dev/rdsk/sks0d2s7

session time: Mon Jan 10 11:47:42 2005

media label: "backup"

file system id: xxx....

session id: xxx...

media id:...

restore this dump?

1: skip

2: restore (default)

> 2 (enter)


=3D=3D=3D=3D=3D=3D

examining media file 0

reading directories

examining media file 1

reading directories

... and so on

no files selected for restoral



=3D=3D=3D=3D

1: media change declined (timeout 3600 seconds)

2: display media inventory status

3: list needed media objects

4: change media (default)


3 and 4 do nothing

I get no media needed. and If I press 4 same menu comes back.

2: media file xxx (xxx) where xxx is a number

used for directory restoral

first extent contained: ino xxxxxxxxxxxx off 0

next extent to restore: ino (same as above) off 0



and If I click 1:

restoral interrupted use -R

restore summery:

stream 0: /dev/nst0 quit media no longer usable

restore status: QUIT


Then if I got to the directory where I pointed all I have is:

orphanage/

xfsrestorehelperblahblah/

where orphangae is empty and the other contains like 5 files that are just =
something else.

What am I doing wrong here ?? any help would be great.

Thanks



--_000_SN1PR05MB231785E5196A5D31D0D833EACC230SN1PR05MB2317namp_
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
<p>Hello Anthony here,</p>
<p>I'm not sure if this is the correct place to send a question, If I am wr=
ong I would appreciate if you could send me in the right direction. &nbsp;I=
 have come across the oss.sgi forums a lot looking for a solution to my pro=
blem but I could not find much.&nbsp;</p>
<p><br>
</p>
<p>Here's my situation.</p>
<p>I have a bunch a tapes that were created way back when using an IRIX sys=
tem. Some kind of version 6, perhaps even the latest version. anyway I am a=
ble to peak at the headers to determind the the file type on the drive is i=
ndeed:</p>
<p>xFSdump0.... &nbsp; or when I make a sample using 'dd if=3D/dev/nst0 of=
=3D./test.img' '&#43; 'file test.img' I get XFSDUMP archive (version 2)</p>
<p>So, instinctively to get the data off the tapes I would think would be a=
s simple as:</p>
<p>sudo xfsrestore -f /dev/nst0 ./path to where I want it stored</p>
<p>Then I get:&nbsp;</p>
<p>using dump format 3</p>
<p>xfsrestore: searching media for dump</p>
<p>xfsrestore: preparing drive</p>
<p>xfsrestore: examining media file 1</p>
<p>...</p>
<p>xfsrestore examining media file xx</p>
<p>the following dump has been found on drive 0:</p>
<p>hostname: isp---------(stuff)</p>
<p>mount point: /isp-iga</p>
<p>volume: /dev/rdsk/sks0d2s7</p>
<p>session time: Mon Jan 10 11:47:42 2005</p>
<p>media label: &quot;backup&quot;</p>
<p>file system id: xxx....</p>
<p>session id: xxx...</p>
<p>media id:...</p>
<p>restore this dump?</p>
<p>1: skip</p>
<p>2:&nbsp;restore (default)</p>
<p>&gt; 2 (enter)</p>
<p><br>
</p>
<p>=3D=3D=3D=3D=3D=3D&nbsp;</p>
<p>examining media file 0</p>
<p>reading directories</p>
<p>examining media file 1</p>
<p>reading directories</p>
<p>... and so on</p>
<p>no files selected for restoral</p>
<p><br>
</p>
<p><br>
</p>
<p>=3D=3D=3D=3D</p>
<p>1: media change declined&nbsp;(timeout 3600 seconds)</p>
<p>2: display media inventory status</p>
<p>3: list needed media objects</p>
<p>4: change media (default)&nbsp;</p>
<p><br>
</p>
<p>3 and 4 do nothing</p>
<p>I get no media needed. and If I press 4 same menu comes back.&nbsp;</p>
<p>2: media file xxx (xxx) where xxx is a number</p>
<p>used for directory restoral&nbsp;</p>
<p>first extent contained: ino xxxxxxxxxxxx off 0</p>
<p>next extent to restore: ino (same as above) off 0</p>
<p><br>
</p>
<p><br>
</p>
<p>and If I click 1:</p>
<p>restoral interrupted use -R</p>
<p>restore summery:</p>
<p>stream 0: /dev/nst0 quit media no longer usable</p>
<p>restore status: QUIT</p>
<p><br>
</p>
<p>Then if I got to the directory where I pointed all I have is:</p>
<p>orphanage/&nbsp;</p>
<p>xfsrestorehelperblahblah/ &nbsp;&nbsp;</p>
<p>where orphangae is empty and the other contains like 5 files that are ju=
st something else.&nbsp;</p>
<p>What am I doing wrong here ?? any help would be great.</p>
<p>Thanks</p>
<p><br>
</p>
<p><br>
</p>
</div>
</body>
</html>

--_000_SN1PR05MB231785E5196A5D31D0D833EACC230SN1PR05MB2317namp_--


--===============0134416426479067056==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0134416426479067056==--
