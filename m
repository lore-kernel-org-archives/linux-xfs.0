Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1OAhLSA019723 for <xfs@oss.sgi.com>; Wed, 24 Feb 2010 04:43:21 -0600
Received: from SBAPEXCH05.ad.corp.expertcity.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DAFB1CF4BE1
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2010 02:44:42 -0800 (PST)
Received: from SBAPEXCH05.ad.corp.expertcity.com
	(sbapexch05.ad.corp.expertcity.com [216.219.126.165]) by
	cuda.sgi.com with ESMTP id 60avyxrmpe2kmCbZ for
	<xfs@oss.sgi.com>; Wed, 24 Feb 2010 02:44:42 -0800 (PST)
From: Joe Allen <Joe.Allen@citrix.com>
Date: Wed, 24 Feb 2010 02:44:37 -0800
Subject: xfs_growfs failure....
Message-ID: <E51793F9F4FAD54A8C1774933D8E500006B64A2687@sbapexch05>
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
Content-Type: multipart/mixed; boundary="===============0178451418762739547=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0178451418762739547==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_E51793F9F4FAD54A8C1774933D8E500006B64A2687sbapexch05_"

--_000_E51793F9F4FAD54A8C1774933D8E500006B64A2687sbapexch05_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I am in some difficulty here over a 100TB filesystem that
Is now unusable after a xfs_growfs command.

Is there someone that might help assist?

#mount: /dev/logfs-sessions/sessions: can't read superblock

Filesystem "dm-61": Disabling barriers, not supported with external log dev=
ice
attempt to access beyond end of device
dm-61: rw=3D0, want=3D238995038208, limit=3D215943192576

I/O error in filesystem ("dm-61") meta-data dev dm-61 block 0x37a536dfff   =
    ("xfs_read_buf") error 5 buf count 512
XFS: size check 2 failed
Filesystem "dm-61": Disabling barriers, not supported with external log dev=
ice
attempt to access beyond end of device

xfs_repair -n <device> basically looks for superblocks (phase 1 I guess ) f=
or a long time. I'm letting it run, but not much hope.

I'm hesitant to run xfs_repair -L  or without the -n flag for fear of makin=
g it worse.

I've run the following command to try to inspect

please let me know if there's anything else that might help determine if th=
ere's anything I can do to recover...

-bash-3.1# xfs_check -l /dev/logfs-sessions/logdev /dev/logfs-sessions/sess=
ions
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_check.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

-bash-3.1# xfs_db -r -c 'sb 0' -c p /dev/logfs-sessions/sessions
magicnum =3D 0x58465342
blocksize =3D 4096
dblocks =3D 29874379776
rblocks =3D 0
rextents =3D 0
uuid =3D fc8bdf76-d962-43c1-ae60-b85f378978a6
logstart =3D 0
rootino =3D 2048
rbmino =3D 2049
rsumino =3D 2050
rextsize =3D 384
agblocks =3D 268435328
agcount =3D 112
rbmblocks =3D 0
logblocks =3D 32000
versionnum =3D 0x3184
sectsize =3D 512
inodesize =3D 256
inopblock =3D 16
fname =3D "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog =3D 12
sectlog =3D 9
inodelog =3D 8
inopblog =3D 4
agblklog =3D 28
rextslog =3D 0
inprogress =3D 0
imax_pct =3D 25
icount =3D 7291520
ifree =3D 8514
fdblocks =3D 6623185597
frextents =3D 0
uquotino =3D 0
gquotino =3D 0
qflags =3D 0
flags =3D 0
shared_vn =3D 0
inoalignmt =3D 2
unit =3D 128
width =3D 384
dirblklog =3D 0
logsectlog =3D 0
logsectsize =3D 0
logsunit =3D 0
features2 =3D 0

-bash-3.1# xfs_db -r -c 'sb 2' -c p /dev/logfs-sessions/sessions
magicnum =3D 0x58465342
blocksize =3D 4096
dblocks =3D 24111418368
rblocks =3D 0
rextents =3D 0
uuid =3D fc8bdf76-d962-43c1-ae60-b85f378978a6
logstart =3D 0
rootino =3D 2048
rbmino =3D 2049
rsumino =3D 2050
rextsize =3D 384
agblocks =3D 268435328
agcount =3D 90
rbmblocks =3D 0
logblocks =3D 32000
versionnum =3D 0x3184
sectsize =3D 512
inodesize =3D 256
inopblock =3D 16
fname =3D "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog =3D 12
sectlog =3D 9
inodelog =3D 8
inopblog =3D 4
agblklog =3D 28
rextslog =3D 0
inprogress =3D 0
imax_pct =3D 25
icount =3D 7291008
ifree =3D 8765
fdblocks =3D 862328436
frextents =3D 0
uquotino =3D 0
gquotino =3D 0
qflags =3D 0
flags =3D 0
shared_vn =3D 0
inoalignmt =3D 2
unit =3D 128
width =3D 384
dirblklog =3D 0
logsectlog =3D 0
logsectsize =3D 0
logsunit =3D 0
features2 =3D 0





--_000_E51793F9F4FAD54A8C1774933D8E500006B64A2687sbapexch05_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
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
	{mso-style-type:export-only;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal>I am in some difficulty here over a 100TB filesystem t=
hat <o:p></o:p></p>

<p class=3DMsoNormal>Is now unusable after a xfs_growfs command. <o:p></o:p=
></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Is there someone that might help assist?<o:p></o:p></p=
>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>#mount: /dev/logfs-sessions/sessions: can't read super=
block<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Filesystem &quot;dm-61&quot;: Disabling barriers, not
supported with external log device<o:p></o:p></p>

<p class=3DMsoNormal>attempt to access beyond end of device<o:p></o:p></p>

<p class=3DMsoNormal>dm-61: rw=3D0, want=3D238995038208, limit=3D2159431925=
76<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>I/O error in filesystem (&quot;dm-61&quot;) meta-data =
dev
dm-61 block 0x37a536dfff&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
(&quot;xfs_read_buf&quot;) error 5 buf count 512<o:p></o:p></p>

<p class=3DMsoNormal>XFS: size check 2 failed<o:p></o:p></p>

<p class=3DMsoNormal>Filesystem &quot;dm-61&quot;: Disabling barriers, not
supported with external log device<o:p></o:p></p>

<p class=3DMsoNormal>attempt to access beyond end of device<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>xfs_repair &#8211;n &lt;device&gt; basically looks for
superblocks (phase 1 I guess ) for a long time. I&#8217;m letting it run, b=
ut
not much hope.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>I&#8217;m hesitant to run xfs_repair &#8211;L &nbsp;or=
 without
the &#8211;n flag for fear of making it worse. <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>I&#8217;ve run the following command to try to inspect=
<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>please let me know if there&#8217;s anything else that=
 might
help determine if there&#8217;s anything I can do to recover&#8230; <o:p></=
o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>-bash-3.1# xfs_check -l /dev/logfs-sessions/logdev
/dev/logfs-sessions/sessions<o:p></o:p></p>

<p class=3DMsoNormal>ERROR: The filesystem has valuable metadata changes in=
 a log
which needs to<o:p></o:p></p>

<p class=3DMsoNormal>be replayed.&nbsp; Mount the filesystem to replay the =
log,
and unmount it before<o:p></o:p></p>

<p class=3DMsoNormal>re-running xfs_check.&nbsp; If you are unable to mount=
 the
filesystem, then use<o:p></o:p></p>

<p class=3DMsoNormal>the xfs_repair -L option to destroy the log and attemp=
t a
repair.<o:p></o:p></p>

<p class=3DMsoNormal>Note that destroying the log may cause corruption -- p=
lease
attempt a mount<o:p></o:p></p>

<p class=3DMsoNormal>of the filesystem before doing this.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>-bash-3.1# xfs_db -r -c 'sb 0' -c p
/dev/logfs-sessions/sessions<o:p></o:p></p>

<p class=3DMsoNormal>magicnum =3D 0x58465342<o:p></o:p></p>

<p class=3DMsoNormal>blocksize =3D 4096<o:p></o:p></p>

<p class=3DMsoNormal>dblocks =3D 29874379776<o:p></o:p></p>

<p class=3DMsoNormal>rblocks =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>rextents =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>uuid =3D fc8bdf76-d962-43c1-ae60-b85f378978a6<o:p></o:=
p></p>

<p class=3DMsoNormal>logstart =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>rootino =3D 2048<o:p></o:p></p>

<p class=3DMsoNormal>rbmino =3D 2049<o:p></o:p></p>

<p class=3DMsoNormal>rsumino =3D 2050<o:p></o:p></p>

<p class=3DMsoNormal>rextsize =3D 384<o:p></o:p></p>

<p class=3DMsoNormal>agblocks =3D 268435328<o:p></o:p></p>

<p class=3DMsoNormal>agcount =3D 112<o:p></o:p></p>

<p class=3DMsoNormal>rbmblocks =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>logblocks =3D 32000<o:p></o:p></p>

<p class=3DMsoNormal>versionnum =3D 0x3184<o:p></o:p></p>

<p class=3DMsoNormal>sectsize =3D 512<o:p></o:p></p>

<p class=3DMsoNormal>inodesize =3D 256<o:p></o:p></p>

<p class=3DMsoNormal>inopblock =3D 16<o:p></o:p></p>

<p class=3DMsoNormal>fname =3D
&quot;\000\000\000\000\000\000\000\000\000\000\000\000&quot;<o:p></o:p></p>

<p class=3DMsoNormal>blocklog =3D 12<o:p></o:p></p>

<p class=3DMsoNormal>sectlog =3D 9<o:p></o:p></p>

<p class=3DMsoNormal>inodelog =3D 8<o:p></o:p></p>

<p class=3DMsoNormal>inopblog =3D 4<o:p></o:p></p>

<p class=3DMsoNormal>agblklog =3D 28<o:p></o:p></p>

<p class=3DMsoNormal>rextslog =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>inprogress =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>imax_pct =3D 25<o:p></o:p></p>

<p class=3DMsoNormal>icount =3D 7291520<o:p></o:p></p>

<p class=3DMsoNormal>ifree =3D 8514<o:p></o:p></p>

<p class=3DMsoNormal>fdblocks =3D 6623185597<o:p></o:p></p>

<p class=3DMsoNormal>frextents =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>uquotino =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>gquotino =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>qflags =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>flags =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>shared_vn =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>inoalignmt =3D 2<o:p></o:p></p>

<p class=3DMsoNormal>unit =3D 128<o:p></o:p></p>

<p class=3DMsoNormal>width =3D 384<o:p></o:p></p>

<p class=3DMsoNormal>dirblklog =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>logsectlog =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>logsectsize =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>logsunit =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>features2 =3D 0<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>-bash-3.1# xfs_db -r -c 'sb 2' -c p
/dev/logfs-sessions/sessions<o:p></o:p></p>

<p class=3DMsoNormal>magicnum =3D 0x58465342<o:p></o:p></p>

<p class=3DMsoNormal>blocksize =3D 4096<o:p></o:p></p>

<p class=3DMsoNormal>dblocks =3D 24111418368<o:p></o:p></p>

<p class=3DMsoNormal>rblocks =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>rextents =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>uuid =3D fc8bdf76-d962-43c1-ae60-b85f378978a6<o:p></o:=
p></p>

<p class=3DMsoNormal>logstart =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>rootino =3D 2048<o:p></o:p></p>

<p class=3DMsoNormal>rbmino =3D 2049<o:p></o:p></p>

<p class=3DMsoNormal>rsumino =3D 2050<o:p></o:p></p>

<p class=3DMsoNormal>rextsize =3D 384<o:p></o:p></p>

<p class=3DMsoNormal>agblocks =3D 268435328<o:p></o:p></p>

<p class=3DMsoNormal>agcount =3D 90<o:p></o:p></p>

<p class=3DMsoNormal>rbmblocks =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>logblocks =3D 32000<o:p></o:p></p>

<p class=3DMsoNormal>versionnum =3D 0x3184<o:p></o:p></p>

<p class=3DMsoNormal>sectsize =3D 512<o:p></o:p></p>

<p class=3DMsoNormal>inodesize =3D 256<o:p></o:p></p>

<p class=3DMsoNormal>inopblock =3D 16<o:p></o:p></p>

<p class=3DMsoNormal>fname =3D
&quot;\000\000\000\000\000\000\000\000\000\000\000\000&quot;<o:p></o:p></p>

<p class=3DMsoNormal>blocklog =3D 12<o:p></o:p></p>

<p class=3DMsoNormal>sectlog =3D 9<o:p></o:p></p>

<p class=3DMsoNormal>inodelog =3D 8<o:p></o:p></p>

<p class=3DMsoNormal>inopblog =3D 4<o:p></o:p></p>

<p class=3DMsoNormal>agblklog =3D 28<o:p></o:p></p>

<p class=3DMsoNormal>rextslog =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>inprogress =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>imax_pct =3D 25<o:p></o:p></p>

<p class=3DMsoNormal>icount =3D 7291008<o:p></o:p></p>

<p class=3DMsoNormal>ifree =3D 8765<o:p></o:p></p>

<p class=3DMsoNormal>fdblocks =3D 862328436<o:p></o:p></p>

<p class=3DMsoNormal>frextents =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>uquotino =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>gquotino =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>qflags =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>flags =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>shared_vn =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>inoalignmt =3D 2<o:p></o:p></p>

<p class=3DMsoNormal>unit =3D 128<o:p></o:p></p>

<p class=3DMsoNormal>width =3D 384<o:p></o:p></p>

<p class=3DMsoNormal>dirblklog =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>logsectlog =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>logsectsize =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>logsunit =3D 0<o:p></o:p></p>

<p class=3DMsoNormal>features2 =3D 0<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

--_000_E51793F9F4FAD54A8C1774933D8E500006B64A2687sbapexch05_--


--===============0178451418762739547==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0178451418762739547==--
