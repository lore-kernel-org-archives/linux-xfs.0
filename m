Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 298B97F67
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 17:40:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F642304053
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 15:40:06 -0700 (PDT)
Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	by cuda.sgi.com with ESMTP id ycI0PGw02UMDOnT7 (version=TLSv1
	cipher=IDEA-CBC-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Oct 2015 15:40:02 -0700 (PDT)
Received: from XCH-RCD-006.cisco.com (xch-rcd-006.cisco.com [173.37.102.16])
	by rcdn-core-6.cisco.com (8.14.5/8.14.5) with ESMTP id t99Me1Mu006185
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 9 Oct 2015 22:40:01 GMT
From: "Al Lau (alau2)" <alau2@cisco.com>
Subject: mkfs.xfs -n size=65536
Date: Fri, 9 Oct 2015 22:40:00 +0000
Message-ID: <0F279340237AA148AD7E3C6A70561A5E01266BE7@xmb-rcd-x14.cisco.com>
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
Content-Type: multipart/mixed; boundary="===============7477619968978792952=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============7477619968978792952==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_0F279340237AA148AD7E3C6A70561A5E01266BE7xmbrcdx14ciscoc_"

--_000_0F279340237AA148AD7E3C6A70561A5E01266BE7xmbrcdx14ciscoc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I am looking for more details on the "-n size=3D65536" option in mkfs.xfs. =
 The question is the memory allocation this option generates.  The system i=
s Redhat EL 7.0 (3.10.0-229.1.2.el7.x86_64).

We have been getting this memory allocation deadlock message in the /var/lo=
g/messages file.  The file system is used for ceph OSD and it has about 531=
894 files.

Oct  6 07:11:09 abc-ceph1-xyz kernel: XFS: possible memory allocation deadl=
ock in kmem_alloc (mode:0x8250)

Reading this post, https://access.redhat.com/solutions/532663 it discussed =
the "memory allocation deadlock" message.  It looks like the root cause is =
a very fragmented file.  Is setting the "-n size=3D65536" option on the fil=
e system causes (directly or indirectly) the "memory allocation deadlock" e=
rror?

Here is a note on the "-n size=3D65536".  The FAQ note is more on the CPU a=
nd IO performance.

http://xfs.org/index.php/XFS_FAQ
"
Q: Performance: mkfs.xfs -n size=3D64k option

Asking the implications of that mkfs option on the XFS mailing list,
Dave Chinner explained it this way:

Inodes are not stored in the directory structure, only the directory entry =
name
and the inode number.  Hence the amount of space used by a directory entry =
is
determined by the length of the name.

There is extra overhead to allocate large directory blocks (16 pages instea=
d of
one, to begin with, then there's the vmap overhead, etc), so for small
directories smaller block sizes are faster for create and unlink operations=
.

For empty directories, operations on 4k block sized directories consume rou=
ghly
50% less CPU that 64k block size directories. The 4k block size directories
consume less CPU out to roughly 1.5 million entries where the two are rough=
ly
equal. At directory sizes of 10 million entries, 64k directory block operat=
ions
are consuming about 15% of the CPU that 4k directory block operations consu=
me.

In terms of lookups, the 64k block directory will take less IO but consume =
more
CPU for a given lookup.  Hence it depends on your IO latency and whether
directory readahead can hide that latency as to which will be faster. e.g. =
For
SSDs, CPU usage might be the limiting factor, not the IO.  Right now I don'=
t
have any numbers on what the difference might be - I'm getting 1 billion in=
ode
population issues worked out first before I start on measuring cold cache
lookup times on 1 billion files....
"

Thanks,
Al Lau

--_000_0F279340237AA148AD7E3C6A70561A5E01266BE7xmbrcdx14ciscoc_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">I am looking for more details on the &#8220;-n size=
=3D65536&#8221; option in mkfs.xfs.&nbsp; The question is the memory alloca=
tion this option generates.&nbsp; The system is Redhat EL 7.0 (3.10.0-229.1=
.2.el7.x86_64).<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">We have been getting this memory allocation deadlock=
 message in the /var/log/messages file.&nbsp; The file system is used for c=
eph OSD and it has about 531894 files.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Oct&nbsp; 6 07:11:09 abc-ceph1-xyz kernel: XFS: possible memory allocation =
deadlock in kmem_alloc (mode:0x8250)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Reading this post, <a href=3D"https://access.redhat.=
com/solutions/532663">
https://access.redhat.com/solutions/532663</a> it discussed the &#8220;memo=
ry allocation deadlock&#8221; message.&nbsp; It looks like the root cause i=
s a very fragmented file.&nbsp; Is setting the &#8220;-n size=3D65536&#8221=
; option on the file system causes (directly or indirectly) the &#8220;memo=
ry
 allocation deadlock&#8221; error?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Here is a note on the &#8220;-n size=3D65536&#8221;.=
&nbsp; The FAQ note is more on the CPU and IO performance.&nbsp;
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><a href=3D"http://xfs.org/index.php/XFS_FAQ">http://=
xfs.org/index.php/XFS_FAQ</a><o:p></o:p></p>
<p class=3D"MsoNormal">&#8220;<o:p></o:p></p>
<p class=3D"MsoNormal">Q: Performance: mkfs.xfs -n size=3D64k option<o:p></=
o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Asking the implications of that mkfs option on the XFS mailing list,<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Dave Chinner explained it this way:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Inodes are not stored in the directory structure, only the directory entry =
name<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
and the inode number.&nbsp; Hence the amount of space used by a directory e=
ntry is<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
determined by the length of the name.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
There is extra overhead to allocate large directory blocks (16 pages instea=
d of<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
one, to begin with, then there's the vmap overhead, etc), so for small<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
directories smaller block sizes are faster for create and unlink operations=
.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
For empty directories, operations on 4k block sized directories consume rou=
ghly<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
50% less CPU that 64k block size directories. The 4k block size directories=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
consume less CPU out to roughly 1.5 million entries where the two are rough=
ly<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
equal. At directory sizes of 10 million entries, 64k directory block operat=
ions<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
are consuming about 15% of the CPU that 4k directory block operations consu=
me.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
In terms of lookups, the 64k block directory will take less IO but consume =
more<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
CPU for a given lookup.&nbsp; Hence it depends on your IO latency and wheth=
er<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
directory readahead can hide that latency as to which will be faster. e.g. =
For<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
SSDs, CPU usage might be the limiting factor, not the IO.&nbsp; Right now I=
 don't<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
have any numbers on what the difference might be - I'm getting 1 billion in=
ode<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
population issues worked out first before I start on measuring cold cache<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
lookup times on 1 billion files....</span><o:p></o:p></p>
<p class=3D"MsoNormal">&#8220;<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks,<o:p></o:p></p>
<p class=3D"MsoNormal">Al Lau<o:p></o:p></p>
</div>
</body>
</html>

--_000_0F279340237AA148AD7E3C6A70561A5E01266BE7xmbrcdx14ciscoc_--


--===============7477619968978792952==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7477619968978792952==--
