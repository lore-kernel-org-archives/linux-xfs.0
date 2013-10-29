Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 779887F4E
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 17:10:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EF034AC093
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 15:10:24 -0700 (PDT)
Received: from mail-la0-f42.google.com (mail-la0-f42.google.com
	[209.85.215.42]) by cuda.sgi.com with ESMTP id ktO9AKl1XJ85ca2Q
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Oct 2013 15:10:22 -0700 (PDT)
Received: by mail-la0-f42.google.com with SMTP id ea20so429495lab.29
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 15:10:21 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Oct 2013 18:10:20 -0400
Message-ID: <CALtWs4-q==CXVZ=jjRnrZGANP98y2Gyot_DV_hGTgxQoRF25UA@mail.gmail.com>
Subject: agsize and performance
From: K T <mailkarthikt@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2021421853625565338=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2021421853625565338==
Content-Type: multipart/alternative; boundary=001a11c34e6c885e9804e9e87bbd

--001a11c34e6c885e9804e9e87bbd
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I have a 1 TB SATA disk(WD1003FBYX) with XFS. In my tests, I preallocate a
bunch of 10GB files and write data to the files one at a time. I have
observed that the default mkfs setting(4 AGs) gives very low throughput.
When I reformat the disk with a agsize of 256mb(agcount=3726), I see better
throughput. I thought with a bigger agsize, the files will be made of fewer
extents and hence perform better(due to lesser entries in the extent map
getting updated). But, according to my tests, the opposite seems to be
true. Can you please explain why this the case? Am I missing something?

My test parameters:

mkfs.xfs -f /dev/sdbf1
mount  -o inode64 /dev/sdbf1 /mnt/test
fallocate -l 10G fname
dd if=/dev/zero of=fname bs=2M count=64 oflag=direct,sync conv=notrunc seek=0

# uname -a
Linux gold 3.0.82-0.7-default #1 SMP Thu Jun 27 13:19:18 UTC 2013
(6efde93) x86_64 x86_64 x86_64 GNU/Linux
# cat /etc/SuSE-release
SUSE Linux Enterprise Server 11 (x86_64)
VERSION = 11
PATCHLEVEL = 3
# Intel(R) Xeon(R) CPU E5-2603 0 @ 1.80GHz


------- Tests with agsize of 256MB -----------
# mkfs.xfs -f /dev/sdbf1 -d agsize=256m
meta-data=/dev/sdbf1             isize=256    agcount=3726, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=244187136, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=65532, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mount  -o inode64 /dev/sdbf1 /mnt/test
# cd test
# ls
# fallocate -l 10g file.1
# xfs_bmap -p -v file.1 | wc -l
43
# dd if=/dev/zero of=file.1 bs=2M count=64 oflag=direct,sync conv=notrunc seek=0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 3.56155 s, 37.7 MB/s
(the first file write seems to be slow)

# fallocate -l 10g file.2
# dd if=/dev/zero of=file.2 bs=2M count=64 oflag=direct,sync conv=notrunc seek=0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 1.57496 s, 85.2 MB/s
# fallocate -l 10g file.3
# dd if=/dev/zero of=file.3 bs=2M count=64 oflag=direct,sync conv=notrunc seek=0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 1.56151 s, 86.0 MB/s

------- Tests with default mkfs parameters -----------
# cd ..
# umount test
# mkfs.xfs -f /dev/sdbf1
meta-data=/dev/sdbf1             isize=256    agcount=4, agsize=61047598 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=244190390, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=119233, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# mount  -o inode64 /dev/sdbf1 /mnt/test
# cd test

# fallocate -l 10g fle.1

# xfs_bmap -p -v file.1 | wc -l
3
# xfs_bmap -p -v file.1
file.1:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET           TOTAL FLAGS
   0: [0..20971519]:   96..20971615      0 (96..20971615)   20971520 10000

# dd if=/dev/zero of=file.1 bs=2M count=64 oflag=direct,sync conv=notrunc seek=0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 3.55862 s, 37.7 MB/s
# xfs_bmap -p -v file.1
file.1:
 EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET             TOTAL FLAGS
   0: [0..262143]:        96..262239        0 (96..262239)         262144 00000
   1: [262144..20971519]: 262240..20971615  0 (262240..20971615) 20709376 10000

# fallocate -l 10g file.2
# xfs_bmap -p -v file.2
file.2:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET               TOTAL FLAGS
   0: [0..20971519]:   20971616..41943135  0 (20971616..41943135) 20971520 10000
# dd if=/dev/zero of=file.2 bs=2M count=64 oflag=direct,sync conv=notrunc seek=0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 3.56464 s, 37.7 MB/s
# xfs_bmap -p -v file.2
file.2:
 EXT: FILE-OFFSET         BLOCK-RANGE        AG AG-OFFSET
 TOTAL FLAGS
   0: [0..262143]:        20971616..21233759  0 (20971616..21233759)
262144 00000
   1: [262144..20971519]: 21233760..41943135  0 (21233760..41943135)
20709376 10000

# fallocate -l 10g file.3
# xfs_bmap -p -v file.3
file.3:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET               TOTAL FLAGS
   0: [0..20971519]:   41943136..62914655  0 (41943136..62914655) 20971520 10000
# dd if=/dev/zero of=file.3 bs=2M count=64 oflag=direct,sync conv=notrunc seek=0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 3.55932 s, 37.7 MB/s
# xfs_bmap -p -v file.3
file.3:
 EXT: FILE-OFFSET         BLOCK-RANGE        AG AG-OFFSET
 TOTAL FLAGS
   0: [0..262143]:        41943136..42205279  0 (41943136..42205279)
262144 00000
   1: [262144..20971519]: 42205280..62914655  0 (42205280..62914655)
20709376 10000


Thanks,
Karthik

--001a11c34e6c885e9804e9e87bbd
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"color:rgb(0,0,0);white-space:pre-wrap">Hi,<=
/span><div><span style=3D"color:rgb(0,0,0);white-space:pre-wrap"><br></span=
></div><div><span style=3D"color:rgb(0,0,0);white-space:pre-wrap">I have a =
1 TB SATA disk(WD1003FBYX) with XFS. In my tests, I preallocate a bunch of =
10GB files and write data to the files one at a time. I have observed that =
the default mkfs setting(4 AGs) gives very low throughput. When I reformat =
the disk with a agsize of 256mb(</span><span style=3D"color:rgb(0,0,0);whit=
e-space:pre-wrap">agcount=3D3726)</span><span style=3D"color:rgb(0,0,0);whi=
te-space:pre-wrap">, I see better throughput. I thought with a bigger agsiz=
e, the files will be made of fewer extents and hence perform better(due to =
lesser entries in the extent map getting updated). But, according to my tes=
ts, the opposite seems to be true. Can you please explain why this the case=
? Am I missing something?</span></div>
<div><div><pre style=3D"color:rgb(0,0,0);word-wrap:break-word;white-space:p=
re-wrap">My test parameters:

mkfs.xfs -f /dev/sdbf1
mount  -o inode64 /dev/sdbf1 /mnt/test
fallocate -l 10G fname
dd if=3D/dev/zero of=3Dfname bs=3D2M count=3D64 oflag=3Ddirect,sync conv=3D=
notrunc seek=3D0

# uname -a
Linux gold 3.0.82-0.7-default #1 SMP Thu Jun 27 13:19:18 UTC 2013 (6efde93)=
 x86_64 x86_64 x86_64 GNU/Linux
# cat /etc/SuSE-release
SUSE Linux Enterprise Server 11 (x86_64)
VERSION =3D 11
PATCHLEVEL =3D 3
# Intel(R) Xeon(R) CPU E5-2603 0 @ 1.80GHz


------- Tests with agsize of 256MB -----------
# mkfs.xfs -f /dev/sdbf1 -d agsize=3D256m
meta-data=3D/dev/sdbf1             isize=3D256    agcount=3D3726, agsize=3D=
65536 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D0
data     =3D                       bsize=3D4096   blocks=3D244187136, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal log           bsize=3D4096   blocks=3D65532, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

# mount  -o inode64 /dev/sdbf1 /mnt/test
# cd test
# ls
# fallocate -l 10g file.1
# xfs_bmap -p -v file.1 | wc -l
43
# dd if=3D/dev/zero of=3Dfile.1 bs=3D2M count=3D64 oflag=3Ddirect,sync conv=
=3Dnotrunc seek=3D0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 3.56155 s, 37.7 MB/s
(the first file write seems to be slow)

# fallocate -l 10g file.2
# dd if=3D/dev/zero of=3Dfile.2 bs=3D2M count=3D64 oflag=3Ddirect,sync conv=
=3Dnotrunc seek=3D0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 1.57496 s, 85.2 MB/s
# fallocate -l 10g file.3
# dd if=3D/dev/zero of=3Dfile.3 bs=3D2M count=3D64 oflag=3Ddirect,sync conv=
=3Dnotrunc seek=3D0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 1.56151 s, 86.0 MB/s

------- Tests with default mkfs parameters -----------
# cd ..
# umount test
# mkfs.xfs -f /dev/sdbf1
meta-data=3D/dev/sdbf1             isize=3D256    agcount=3D4, agsize=3D610=
47598 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D0
data     =3D                       bsize=3D4096   blocks=3D244190390, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal log           bsize=3D4096   blocks=3D119233, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
# mount  -o inode64 /dev/sdbf1 /mnt/test
# cd test</pre><pre style=3D"color:rgb(0,0,0);word-wrap:break-word;white-sp=
ace:pre-wrap"># fallocate -l 10g fle.1</pre><pre style=3D"color:rgb(0,0,0);=
word-wrap:break-word;white-space:pre-wrap"># xfs_bmap -p -v file.1 | wc -l
3
# xfs_bmap -p -v file.1
file.1:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET           TOTAL FLAGS
   0: [0..20971519]:   96..20971615      0 (96..20971615)   20971520 10000

# dd if=3D/dev/zero of=3Dfile.1 bs=3D2M count=3D64 oflag=3Ddirect,sync conv=
=3Dnotrunc seek=3D0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 3.55862 s, 37.7 MB/s
# xfs_bmap -p -v file.1
file.1:
 EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET             TOTAL F=
LAGS
   0: [0..262143]:        96..262239        0 (96..262239)         262144 0=
0000
   1: [262144..20971519]: 262240..20971615  0 (262240..20971615) 20709376 1=
0000

# fallocate -l 10g file.2
# xfs_bmap -p -v file.2
file.2:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET               TOTAL =
FLAGS
   0: [0..20971519]:   20971616..41943135  0 (20971616..41943135) 20971520 =
10000
# dd if=3D/dev/zero of=3Dfile.2 bs=3D2M count=3D64 oflag=3Ddirect,sync conv=
=3Dnotrunc seek=3D0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 3.56464 s, 37.7 MB/s
# xfs_bmap -p -v file.2
file.2:
 EXT: FILE-OFFSET         BLOCK-RANGE        AG AG-OFFSET               TOT=
AL FLAGS
   0: [0..262143]:        20971616..21233759  0 (20971616..21233759)   2621=
44 00000
   1: [262144..20971519]: 21233760..41943135  0 (21233760..41943135) 207093=
76 10000

# fallocate -l 10g file.3
# xfs_bmap -p -v file.3
file.3:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET               TOTAL =
FLAGS
   0: [0..20971519]:   41943136..62914655  0 (41943136..62914655) 20971520 =
10000
# dd if=3D/dev/zero of=3Dfile.3 bs=3D2M count=3D64 oflag=3Ddirect,sync conv=
=3Dnotrunc seek=3D0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 3.55932 s, 37.7 MB/s
# xfs_bmap -p -v file.3
file.3:
 EXT: FILE-OFFSET         BLOCK-RANGE        AG AG-OFFSET               TOT=
AL FLAGS
   0: [0..262143]:        41943136..42205279  0 (41943136..42205279)   2621=
44 00000
   1: [262144..20971519]: 42205280..62914655  0 (42205280..62914655) 207093=
76 10000
</pre></div><div><br></div></div><div>Thanks,</div><div>Karthik</div></div>

--001a11c34e6c885e9804e9e87bbd--


--===============2021421853625565338==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2021421853625565338==--
