Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JC5bTT084918 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 07:05:39 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	tbqNNAbJsfWsIevn (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 05:05:35 -0700 (PDT)
Received: by obbup19 with SMTP id up19so4963334obb.26
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 05:05:35 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Jun 2012 14:05:34 +0200
Message-ID: <CA+UH363THQXhT8bH8Mb8Hpz9kvMnWxhq4ToVg6uiwDFLN91VmA@mail.gmail.com>
Subject: No space left on device
From: =?UTF-8?B?QW5kcsOpIMOYaWVuIExhbmd2YW5k?=
	<andre.oien.langvand@wimpmusic.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1628017409843831900=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1628017409843831900==
Content-Type: multipart/alternative; boundary=e89a8f647bcf9546a704c2d2197e

--e89a8f647bcf9546a704c2d2197e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I know there are quite a few posts regarding similar issues around, but I
can't seem to find a solution or at least an answer to why this is
happening in my case, so I thought I'd try the mailing list and I hope
that's okay.

We have 2 file servers with identical hardware and identical configuration
(Dell R610's, H800 controllers, MD1200 DAS, RAID-5) set up with rsync to
mirror the contents. The content is music in several formats (from PCM WAV
to 64kbit AAC previews), which means file sizes of about 1 - 40mb. Both
systems running SLES 11 SP1. Same kernel (2.6.32.59-0.3-default), same
xfsprogs version (xfsprogs-3.1.1-0.1.36).

My example partition on the source now has 9.9G (of 9.1T) available space
and still doesn't report the drive as full. On the destination, however, it
wont allow me to use any of the remaining 51G. This is obviously a problem
when trying to do mirroring.

Both file systems have been mounted with inode64 option since first mount,
there are plenty of inodes available and I've also verified that there are
noe sparse files (find -type f -printf "%S\t%p\n" 2>/dev/null | gawk '{if
($1 < 1.0) print $1 $2}'), just in case.

I have tried repairing (xfs_repair), defragmenting (xfs_fsr) and alter
imaxpct without any luck. Rsync is run like this: # ionice -c3 rsync -rv
--size-only --progress --delete-before --inplace.


More detailed information on source file system:

# df -k | grep sdg1
/dev/sdg1            9762777052 9752457156  10319896 100% /content/raid31

# df -i | grep sdg1
/dev/sdg1            7471884 2311914 5159970   31% /content/raid31

# xfs_info /dev/sdg1
meta-data=3D/dev/sdg1              isize=3D2048   agcount=3D10, agsize=3D26=
8435424
blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D2441215991, imax=
pct=3D5
         =3D                       sunit=3D16     swidth=3D80 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D16 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

# xfs_db -r "-c freesp -s" /dev/sdg1
   from      to extents  blocks    pct
      1       1   69981   69981   2.99
      2       3  246574  559149  23.86
      4       7  315038 1707929  72.88
      8      15     561    6374   0.27
total free extents 632154
total free blocks 2343433
average free extent size 3.70706



More detailed information on destination file system:

# df -k | grep sdj1
/dev/sdj1            9762777052 9710148076  52628976 100% /content/sg08/vd0=
8

# df -i | grep sdj1
/dev/sdj1            28622264 2307776 26314488    9% /content/sg08/vd08

# xfs_info /dev/sdj1
meta-data=3D/dev/sdj1              isize=3D2048   agcount=3D10, agsize=3D26=
8435424
blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D2441215991, imax=
pct=3D5
         =3D                       sunit=3D16     swidth=3D80 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D16 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

# xfs_db -r "-c freesp -s" /dev/sdj1
   from      to extents  blocks    pct
      1       1   81761   81761   0.62
      2       3  530258 1147719   8.73
      4       7  675864 3551039  27.01
      8      15  743089 8363043  63.62
     16      31     102    1972   0.02
total free extents 2031074
total free blocks 13145534
average free extent size 6.47221


I would be grateful if anyone could shed some light on why this is
happening or maybe even provide a solution.


Thank you,

Andr=C3=A9

--e89a8f647bcf9546a704c2d2197e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,<div><br></div><div>I know there are quite a few posts regarding similar=
 issues around, but I can&#39;t seem to find a solution or at least an answ=
er to why this is happening in my case, so I thought I&#39;d try the mailin=
g list and I hope that&#39;s okay.</div>
<div><br></div><div>We have 2 file servers with identical hardware and iden=
tical configuration (Dell R610&#39;s, H800 controllers, MD1200 DAS, RAID-5)=
 set up with rsync to mirror the contents. The content is music in several =
formats (from PCM WAV to 64kbit AAC previews), which means file sizes of ab=
out 1 - 40mb. Both systems running SLES 11 SP1. Same kernel (2.6.32.59-0.3-=
default), same xfsprogs version (xfsprogs-3.1.1-0.1.36).</div>
<div><br></div><div>My example partition on the source now has 9.9G (of 9.1=
T) available space and still doesn&#39;t report the drive as full. On the d=
estination, however, it wont allow me to use any of the remaining=C2=A051G.=
 This is obviously a problem when trying to do mirroring.</div>
<div><br></div><div>Both file systems have been mounted with inode64 option=
 since first mount, there are plenty of inodes available and I&#39;ve also =
verified that there are noe sparse files (find -type f -printf &quot;%S\t%p=
\n&quot; 2&gt;/dev/null | gawk &#39;{if ($1 &lt; 1.0) print $1 $2}&#39;), j=
ust in case.</div>
<div><br></div><div>I have tried=C2=A0repairing (xfs_repair),=C2=A0defragme=
nting (xfs_fsr) and alter imaxpct without any luck. Rsync is run like this:=
 # ionice -c3 rsync -rv --size-only --progress --delete-before --inplace.=
=C2=A0</div><div>
<br></div><div><br></div><div>More detailed information on source file syst=
em:</div><div><br></div><div><div># df -k | grep sdg1</div><div>/dev/sdg1 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A09762777052 9752457156 =C2=A0103198=
96 100% /content/raid31</div></div>
<div><br></div><div><div># df -i | grep sdg1</div><div>/dev/sdg1 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A07471884 2311914 5159970 =C2=A0 31% /content/=
raid31</div></div><div><br></div><div><div># xfs_info /dev/sdg1</div><div>m=
eta-data=3D/dev/sdg1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0isize=
=3D2048 =C2=A0 agcount=3D10, agsize=3D268435424 blks</div>
<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=3D2<=
/div><div>data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D2441215991,=
 imaxpct=3D5</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D16 =
=C2=A0 =C2=A0 swidth=3D80 blks</div><div>
naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
bsize=3D4096 =C2=A0 ascii-ci=3D0</div><div>log =C2=A0 =C2=A0 =C2=A0=3Dinter=
nal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 bl=
ocks=3D521728, version=3D2</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 sectsz=3D512 =C2=A0 sunit=3D16 blks, lazy-count=3D1</div>
<div>realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0</div></div><div><b=
r></div><div><div># xfs_db -r &quot;-c freesp -s&quot; /dev/sdg1</div><div>=
=C2=A0 =C2=A0from =C2=A0 =C2=A0 =C2=A0to extents =C2=A0blocks =C2=A0 =C2=A0=
pct</div><div>=C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 69981 =
=C2=A0 69981 =C2=A0 2.99</div>
<div>=C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 3 =C2=A0246574 =C2=A055914=
9 =C2=A023.86</div><div>=C2=A0 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 7 =C2=
=A0315038 1707929 =C2=A072.88</div><div>=C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=
=A0 =C2=A015 =C2=A0 =C2=A0 561 =C2=A0 =C2=A06374 =C2=A0 0.27</div><div>tota=
l free extents 632154</div><div>total free blocks 2343433</div><div>
average free extent size 3.70706</div></div><div><br></div><div><br></div><=
div><br></div><div>More detailed information on destination file system:</d=
iv><div><br></div><div><div># df -k | grep sdj1</div><div>/dev/sdj1 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A09762777052 9710148076 =C2=A052628976 100%=
 /content/sg08/vd08</div>
</div><div><br></div><div><div># df -i | grep sdj1</div><div>/dev/sdj1 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A028622264 2307776 26314488 =C2=A0 =C2=
=A09% /content/sg08/vd08</div></div><div><br></div><div><div># xfs_info /de=
v/sdj1=C2=A0</div><div>meta-data=3D/dev/sdj1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0isize=3D2048 =C2=A0 agcount=3D10, agsize=3D268435424 bl=
ks</div>
<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=3D2<=
/div><div>data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D2441215991,=
 imaxpct=3D5</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D16 =
=C2=A0 =C2=A0 swidth=3D80 blks</div><div>
naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
bsize=3D4096 =C2=A0 ascii-ci=3D0</div><div>log =C2=A0 =C2=A0 =C2=A0=3Dinter=
nal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 bl=
ocks=3D521728, version=3D2</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 sectsz=3D512 =C2=A0 sunit=3D16 blks, lazy-count=3D1</div>
<div>realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0</div></div><div><b=
r></div><div><div># xfs_db -r &quot;-c freesp -s&quot; /dev/sdj1</div><div>=
=C2=A0 =C2=A0from =C2=A0 =C2=A0 =C2=A0to extents =C2=A0blocks =C2=A0 =C2=A0=
pct</div><div>=C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 81761 =
=C2=A0 81761 =C2=A0 0.62</div>
<div>=C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 3 =C2=A0530258 1147719 =C2=
=A0 8.73</div><div>=C2=A0 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 7 =C2=A06758=
64 3551039 =C2=A027.01</div><div>=C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A015 =C2=A0743089 8363043 =C2=A063.62</div><div>=C2=A0 =C2=A0 =C2=A016 =C2=
=A0 =C2=A0 =C2=A031 =C2=A0 =C2=A0 102 =C2=A0 =C2=A01972 =C2=A0 0.02</div><d=
iv>total free extents 2031074</div>
<div>total free blocks 13145534</div><div>average free extent size 6.47221<=
/div></div><div><br></div><div><br></div><div>I would be grateful if anyone=
 could shed some light on why this is happening or maybe even provide a sol=
ution.</div>
<div><br></div><div><br></div><div>Thank you,</div><div><br></div><div>Andr=
=C3=A9</div><div><br></div><div><br></div><div><br></div><div><br></div><di=
v><br></div><div><br></div>

--e89a8f647bcf9546a704c2d2197e--


--===============1628017409843831900==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1628017409843831900==--
