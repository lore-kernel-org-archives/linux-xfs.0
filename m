Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 133657F5F
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2015 23:39:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F04608F8033
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2015 21:39:25 -0800 (PST)
Received: from mail-gw1.its.unimelb.edu.au (mail-gw1.its.unimelb.edu.au
	[128.250.5.150]) by cuda.sgi.com with ESMTP id G3B88lWqGc2acCJr
	for <xfs@oss.sgi.com>; Mon, 05 Jan 2015 21:39:23 -0800 (PST)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com
	[209.85.213.182]) (Authenticated sender: draffelt)
	by mail-gw1.its.unimelb.edu.au (Postfix) with ESMTPSA id 9275215D6
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 16:39:21 +1100 (EST)
Received: by mail-ig0-f182.google.com with SMTP id hn15so3743779igb.3
	for <xfs@oss.sgi.com>; Mon, 05 Jan 2015 21:39:19 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 6 Jan 2015 16:39:19 +1100
Message-ID: <CAOFq7B6eqEpGN2gcON-D63ZRf7AEabe2V_4q7jECZHk0t4etJQ@mail.gmail.com>
Subject: XFS corrupt after RAID failure and resync
From: David Raffelt <david.raffelt@florey.edu.au>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3555320754692608365=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3555320754692608365==
Content-Type: multipart/alternative; boundary=001a113ed2747b32ed050bf53a72

--001a113ed2747b32ed050bf53a72
Content-Type: text/plain; charset=UTF-8

Hi All,

I have 7 drives in a RAID6 configuration with a XFS partition (running Arch
linux). Recently two drives dropped out simultaneously, and a hot spare
immediately synced successfully so that I now have 6/7 drives up in the
array.

After a reboot (to replace the faulty drives) the XFS file system would not
mount. Note that I had to perform a hard reboot since the server hung on
shutdown. When I try to mount I get the following error:
mount: mount /dev/md0 on /export/data failed: Structure needs cleaning

I have tried to perform: xfs_repair /dev/md0
And I get the following output:

Phase 1 - find and verify superblock...
couldn't verify primary superblock - bad magic number !!!
attempting to find secondary superblock...
..............................................................................
..............................................................................
                          [many lines like this]
..............................................................................
..............................................................................
found candidate secondary superblock...unable to verify superblock,
continuing
...
...........................................................................

Note that it has been scanning for many hours and has located several
secondary superblocks with the same error. It is till scanning however
based on other posts I'm guessing it will not be successful.

To investigate the superblock info I used xfs_db and the magic number looks
ok:
sudo xfs_db /dev/md0
xfs_db> sb
xfs_db> p

magicnum = 0x58465342
blocksize = 4096
dblocks = 3662666880
rblocks = 0
rextents = 0
uuid = e74e5814-3e0f-4cd1-9a68-65d9df8a373f
logstart = 2147483655
rootino = 1024
rbmino = 1025
rsumino = 1026
rextsize = 1
agblocks = 114458368
agcount = 32
rbmblocks = 0
logblocks = 521728
versionnum = 0xbdb4
sectsize = 4096
inodesize = 512
inopblock = 8
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 12
inodelog = 9
inopblog = 3
agblklog = 27
rextslog = 0
inprogress = 0
imax_pct = 5
icount = 4629568
ifree = 34177
fdblocks = 362013500
frextents = 0
uquotino = 0
gquotino = null
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 128
width = 640
dirblklog = 0
logsectlog = 12
logsectsize = 4096
logsunit = 4096
features2 = 0xa
bad_features2 = 0xa
features_compat = 0
features_ro_compat = 0
features_incompat = 0
features_log_incompat = 0
crc = 0 (unchecked)
pquotino = 0
lsn = 0


Any help or suggestions at this point would be much appreciated!  Is my
only option to try a repair -L?

Thanks in advance,
Dave

--001a113ed2747b32ed050bf53a72
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi All,<div><br></div><div>I have 7 drives in a RAID6 conf=
iguration with a XFS partition (running Arch linux). Recently two drives dr=
opped out simultaneously, and a hot spare immediately synced successfully s=
o that I now have 6/7 drives up in the array.</div><div><br></div><div>Afte=
r a reboot (to replace the faulty drives) the XFS file system would not mou=
nt. Note that I had to perform a hard reboot since the server hung on shutd=
own. When I try to mount I get the following error:</div><div><div><font fa=
ce=3D"monospace, monospace">mount: mount /dev/md0 on /export/data failed: S=
tructure needs cleaning</font><br></div><div><font face=3D"monospace, monos=
pace"><br></font></div><div>I have tried to perform:=C2=A0<font face=3D"mon=
ospace, monospace">xfs_repair /dev/md0</font>=C2=A0<br></div></div><div>And=
 I get the following output:</div><div><div><br></div><div><font face=3D"mo=
nospace, monospace">Phase 1 - find and verify superblock...</font></div><di=
v><font face=3D"monospace, monospace">couldn&#39;t verify primary superbloc=
k - bad magic number !!!</font></div><div><font face=3D"monospace, monospac=
e">attempting to find secondary superblock...</font></div><div><font face=
=3D"monospace, monospace">.................................................=
.............................</font></div></div><div><span style=3D"font-fa=
mily:monospace,monospace">.................................................=
.............................</span><font face=3D"monospace, monospace"><br=
></font></div><div><span style=3D"font-family:monospace,monospace">=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [many lines like this]</span></div><div><span style=3D"font-fami=
ly:monospace,monospace">...................................................=
...........................</span><span style=3D"font-family:monospace,mono=
space"><br></span></div><div><span style=3D"font-family:monospace,monospace=
">.........................................................................=
.....</span><span style=3D"font-family:monospace,monospace"><br></span></di=
v><div><div><font face=3D"monospace, monospace">found candidate secondary s=
uperblock...</font><span style=3D"font-family:monospace,monospace">unable t=
o verify superblock, continuing</span></div><div><span style=3D"font-family=
:monospace,monospace">...</span><span style=3D"font-family:monospace,monosp=
ace">......................................................................=
.....</span></div></div><div><span style=3D"font-family:monospace,monospace=
"><br></span></div><div><font face=3D"arial, helvetica, sans-serif">Note th=
at it has been scanning for many hours and has=C2=A0located=C2=A0several se=
condary superblocks with the same error. It is till scanning however based =
on other posts I&#39;m guessing it will not be successful.=C2=A0</font></di=
v><div><br></div><div>To investigate the superblock info I used xfs_db and =
the magic number looks ok:=C2=A0</div><div><font face=3D"monospace, monospa=
ce">sudo xfs_db /dev/md0=C2=A0</font></div><div><font face=3D"monospace, mo=
nospace">xfs_db&gt; sb</font></div><div><font face=3D"monospace, monospace"=
>xfs_db&gt; p</font></div><div><font face=3D"monospace, monospace"><br></fo=
nt></div><div><span style=3D"font-family:monospace,monospace">magicnum =3D =
0x58465342</span><br></div><div><font face=3D"monospace, monospace">blocksi=
ze =3D 4096</font></div><div><font face=3D"monospace, monospace">dblocks =
=3D 3662666880</font></div><div><font face=3D"monospace, monospace">rblocks=
 =3D 0</font></div><div><font face=3D"monospace, monospace">rextents =3D 0<=
/font></div><div><font face=3D"monospace, monospace">uuid =3D e74e5814-3e0f=
-4cd1-9a68-65d9df8a373f</font></div><div><font face=3D"monospace, monospace=
">logstart =3D 2147483655</font></div><div><font face=3D"monospace, monospa=
ce">rootino =3D 1024</font></div><div><font face=3D"monospace, monospace">r=
bmino =3D 1025</font></div><div><font face=3D"monospace, monospace">rsumino=
 =3D 1026</font></div><div><font face=3D"monospace, monospace">rextsize =3D=
 1</font></div><div><font face=3D"monospace, monospace">agblocks =3D 114458=
368</font></div><div><font face=3D"monospace, monospace">agcount =3D 32</fo=
nt></div><div><font face=3D"monospace, monospace">rbmblocks =3D 0</font></d=
iv><div><font face=3D"monospace, monospace">logblocks =3D 521728</font></di=
v><div><font face=3D"monospace, monospace">versionnum =3D 0xbdb4</font></di=
v><div><font face=3D"monospace, monospace">sectsize =3D 4096</font></div><d=
iv><font face=3D"monospace, monospace">inodesize =3D 512</font></div><div><=
font face=3D"monospace, monospace">inopblock =3D 8</font></div><div><font f=
ace=3D"monospace, monospace">fname =3D &quot;\000\000\000\000\000\000\000\0=
00\000\000\000\000&quot;</font></div><div><font face=3D"monospace, monospac=
e">blocklog =3D 12</font></div><div><font face=3D"monospace, monospace">sec=
tlog =3D 12</font></div><div><font face=3D"monospace, monospace">inodelog =
=3D 9</font></div><div><font face=3D"monospace, monospace">inopblog =3D 3</=
font></div><div><font face=3D"monospace, monospace">agblklog =3D 27</font><=
/div><div><font face=3D"monospace, monospace">rextslog =3D 0</font></div><d=
iv><font face=3D"monospace, monospace">inprogress =3D 0</font></div><div><f=
ont face=3D"monospace, monospace">imax_pct =3D 5</font></div><div><font fac=
e=3D"monospace, monospace">icount =3D 4629568</font></div><div><font face=
=3D"monospace, monospace">ifree =3D 34177</font></div><div><font face=3D"mo=
nospace, monospace">fdblocks =3D 362013500</font></div><div><font face=3D"m=
onospace, monospace">frextents =3D 0</font></div><div><font face=3D"monospa=
ce, monospace">uquotino =3D 0</font></div><div><font face=3D"monospace, mon=
ospace">gquotino =3D null</font></div><div><font face=3D"monospace, monospa=
ce">qflags =3D 0</font></div><div><font face=3D"monospace, monospace">flags=
 =3D 0</font></div><div><font face=3D"monospace, monospace">shared_vn =3D 0=
</font></div><div><font face=3D"monospace, monospace">inoalignmt =3D 2</fon=
t></div><div><font face=3D"monospace, monospace">unit =3D 128</font></div><=
div><font face=3D"monospace, monospace">width =3D 640</font></div><div><fon=
t face=3D"monospace, monospace">dirblklog =3D 0</font></div><div><font face=
=3D"monospace, monospace">logsectlog =3D 12</font></div><div><font face=3D"=
monospace, monospace">logsectsize =3D 4096</font></div><div><font face=3D"m=
onospace, monospace">logsunit =3D 4096</font></div><div><font face=3D"monos=
pace, monospace">features2 =3D 0xa</font></div><div><font face=3D"monospace=
, monospace">bad_features2 =3D 0xa</font></div><div><font face=3D"monospace=
, monospace">features_compat =3D 0</font></div><div><font face=3D"monospace=
, monospace">features_ro_compat =3D 0</font></div><div><font face=3D"monosp=
ace, monospace">features_incompat =3D 0</font></div><div><font face=3D"mono=
space, monospace">features_log_incompat =3D 0</font></div><div><font face=
=3D"monospace, monospace">crc =3D 0 (unchecked)</font></div><div><font face=
=3D"monospace, monospace">pquotino =3D 0</font></div><div><font face=3D"mon=
ospace, monospace">lsn =3D 0</font></div><div><br></div><div><br></div><div=
>Any help or suggestions at this point would be much appreciated!=C2=A0 Is =
my only option to try a repair -L?=C2=A0</div><div><br></div><div>Thanks in=
 advance,</div><div>Dave</div><div><br></div></div>

--001a113ed2747b32ed050bf53a72--


--===============3555320754692608365==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3555320754692608365==--
