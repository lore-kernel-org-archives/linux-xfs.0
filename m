Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8L0dkeN151324 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 19:39:46 -0500
Received: from mail-vb0-f53.google.com (mail-vb0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id vxPMHxojC1DnYc3D
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 20 Sep 2012 17:40:59 -0700 (PDT)
Received: by vbbfc21 with SMTP id fc21so3299675vbb.26
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 17:40:58 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 20 Sep 2012 18:40:58 -0600
Message-ID: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
Subject: xfs_repair deleting realtime files.
From: Anand Tiwari <tiwarikanand@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0999267451964543093=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0999267451964543093==
Content-Type: multipart/alternative; boundary=20cf307ca01c50e6ce04ca2b7e4b

--20cf307ca01c50e6ce04ca2b7e4b
Content-Type: text/plain; charset=ISO-8859-1

Hi All,

I have been looking into an issue with xfs_repair with realtime sub volume.
some times while running xfs_repair I see following errors

----------------------------
data fork in rt inode 134 claims used rt block 19607
bad data fork in inode 134
would have cleared inode 134
data fork in rt inode 135 claims used rt block 29607
bad data fork in inode 135
would have cleared inode 135
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
entry "test-011" in shortform directory 128 references free inode 134
would have junked entry "test-011" in directory inode 128
entry "test-0" in shortform directory 128 references free inode 135
would have junked entry "test-0" in directory inode 128
data fork in rt ino 134 claims dup rt extent,off - 0, start - 7942144,
count 2097000
bad data fork in inode 134
would have cleared inode 134
data fork in rt ino 135 claims dup rt extent,off - 0, start - 13062144,
count 2097000
bad data fork in inode 135
would have cleared inode 135
No modify flag set, skipping phase 5
------------------------

Here is the bmap for both inodes.

xfs_db> inode 135
xfs_db> bmap
data offset 0 startblock 13062144 (12/479232) count 2097000 flag 0
data offset 2097000 startblock 15159144 (14/479080) count 2097000 flag 0
data offset 4194000 startblock 17256144 (16/478928) count 2097000 flag 0
data offset 6291000 startblock 19353144 (18/478776) count 2097000 flag 0
data offset 8388000 startblock 21450144 (20/478624) count 2097000 flag 0
data offset 10485000 startblock 23547144 (22/478472) count 2097000 flag 0
data offset 12582000 startblock 25644144 (24/478320) count 2097000 flag 0
data offset 14679000 startblock 27741144 (26/478168) count 2097000 flag 0
data offset 16776000 startblock 29838144 (28/478016) count 2097000 flag 0
data offset 18873000 startblock 31935144 (30/477864) count 1607000 flag 0
xfs_db> inode 134
xfs_db> bmap
data offset 0 startblock 7942144 (7/602112) count 2097000 flag 0
data offset 2097000 startblock 10039144 (9/601960) count 2097000 flag 0
data offset 4194000 startblock 12136144 (11/601808) count 926000 flag 0


by looking into xfs_repair code, it looks like repair does not handle a
case where we have more than one extent in a real-time extent.
following is code from repair/dinode.c: process_rt_rec

-----
     for (b = irec->br_startblock; b < irec->br_startblock
+

                        irec->br_blockcount; b += mp->m_sb.sb_rextsize)
{

                ext = (xfs_drtbno_t) b /
mp->m_sb.sb_rextsize;

                pwe = xfs_sb_version_hasextflgbit(&mp->m_sb)
&&

                                irec->br_state == XFS_EXT_UNWRITTEN
&&

                                (b % mp->m_sb.sb_rextsize !=
0);
-----

In my case rextsize is 512 (512 * 4096 = 2mb). So we have multiple extents
(written extents to be precise, thanks dchinner for that), value of "ext"
will be same for all of them and xfs_repair does not like it. thus the
error message ""data fork in rt inode XX claims used rt block XX".

If I ignore this failure condition, xfs_repairs seems to be happy. (FYI:
this file-system is cleanly umounted)
But in my opinion, its not good as these multiple extents can overlap too.

Should we be using XR_E_MULT to flag and keep track of duplicated real-time
extents. (maybe use the present API for adding/detecting duplicate extents)

I am open of suggestion or comments on how to fix this.

xfs_repair version is 3.1.8 and kernel 2.6.37.

thanks,
Anand

--20cf307ca01c50e6ce04ca2b7e4b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi All,<br><br>I have been looking into an issue with xfs_repair with realt=
ime sub volume. some times while running xfs_repair I see following errors =
<br><br>----------------------------<br>data fork in rt inode 134 claims us=
ed rt block 19607<br>

bad data fork in inode 134<br>would have cleared inode 134<br>data fork in =
rt inode 135 claims used rt block 29607<br>bad data fork in inode 135<br>wo=
uld have cleared inode 135<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 1<br>=A0=A0=
=A0=A0=A0=A0=A0 - agno =3D 2<br>

=A0=A0=A0=A0=A0=A0=A0 - agno =3D 3<br>=A0=A0=A0=A0=A0=A0=A0 - process newly=
 discovered inodes...<br>Phase 4 - check for duplicate blocks...<br>=A0=A0=
=A0=A0=A0=A0=A0 - setting up duplicate extent list...<br>=A0=A0=A0=A0=A0=A0=
=A0 - check for inodes claiming duplicate blocks...<br>

=A0=A0=A0=A0=A0=A0=A0 - agno =3D 0<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 1<br=
>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 2<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 3<b=
r>entry &quot;test-011&quot; in shortform directory 128 references free ino=
de 134<br>would have junked entry &quot;test-011&quot; in directory inode 1=
28<br>

entry &quot;test-0&quot; in shortform directory 128 references free inode 1=
35<br>would have junked entry &quot;test-0&quot; in directory inode 128<br>=
data fork in rt ino 134 claims dup rt extent,off - 0, start - 7942144, coun=
t 2097000<br>

bad data fork in inode 134<br>would have cleared inode 134<br>data fork in =
rt ino 135 claims dup rt extent,off - 0, start - 13062144, count 2097000<br=
>bad data fork in inode 135<br>would have cleared inode 135<br>No modify fl=
ag set, skipping phase 5<br>

------------------------<br><br>Here is the bmap for both inodes. <br><br>x=
fs_db&gt; inode 135<br>xfs_db&gt; bmap<br>data offset 0 startblock 13062144=
 (12/479232) count 2097000 flag 0<br>data offset 2097000 startblock 1515914=
4 (14/479080) count 2097000 flag 0<br>

data offset 4194000 startblock 17256144 (16/478928) count 2097000 flag 0<br=
>data offset 6291000 startblock 19353144 (18/478776) count 2097000 flag 0<b=
r>data offset 8388000 startblock 21450144 (20/478624) count 2097000 flag 0<=
br>

data offset 10485000 startblock 23547144 (22/478472) count 2097000 flag 0<b=
r>data offset 12582000 startblock 25644144 (24/478320) count 2097000 flag 0=
<br>data offset 14679000 startblock 27741144 (26/478168) count 2097000 flag=
 0<br>

data offset 16776000 startblock 29838144 (28/478016) count 2097000 flag 0<b=
r>data offset 18873000 startblock 31935144 (30/477864) count 1607000 flag 0=
<br>xfs_db&gt; inode 134<br>xfs_db&gt; bmap<br>data offset 0 startblock 794=
2144 (7/602112) count 2097000 flag 0<br>

data offset 2097000 startblock 10039144 (9/601960) count 2097000 flag 0<br>=
data offset 4194000 startblock 12136144 (11/601808) count 926000 flag 0<br>=
<br><br>by looking into xfs_repair code, it looks like repair does not hand=
le a case where we have more than one extent in a real-time extent. <br>

following is code from repair/dinode.c: process_rt_rec<br><br>-----<br>=A0=
=A0=A0=A0 for (b =3D irec-&gt;br_startblock; b &lt; irec-&gt;br_startblock =
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <br>

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 irec-=
&gt;br_blockcount; b +=3D mp-&gt;m_sb.sb_rextsize)=A0 {=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <br>=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ext =3D (xfs_drtbno_t) b / mp-&gt;m_sb=
.sb_rextsize;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <br>

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pwe =3D xfs_sb_version_hasext=
flgbit(&amp;mp-&gt;m_sb) &amp;&amp;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <b=
r>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 irec-&gt;br_state =3D=3D XFS_EXT_UNWRITTEN &amp;&amp;=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 <br>

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 (b % mp-&gt;m_sb.sb_rextsize !=3D 0);=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 <br>-----<br><br>In my case rextsize is 512 (51=
2 * 4096 =3D 2mb). So we have multiple extents (written extents to be preci=
se, thanks dchinner for that), value of &quot;ext&quot; will be same for al=
l of them and xfs_repair does not like it. thus the error message &quot;&qu=
ot;data fork in rt inode XX claims used rt block XX&quot;. <br>

<br>If I ignore this failure condition, xfs_repairs seems to be happy. (FYI=
: this file-system is cleanly umounted)<br>But in my opinion, its not good =
as these multiple extents can overlap too. <br><br>Should we be using XR_E_=
MULT to flag and keep track of duplicated real-time extents. (maybe use the=
 present API for adding/detecting duplicate extents) <br>

<br>I am open of suggestion or comments on how to fix this. <br><br>xfs_rep=
air version is 3.1.8 and kernel 2.6.37. <br><br>thanks,<br>Anand<br><br>

--20cf307ca01c50e6ce04ca2b7e4b--


--===============0999267451964543093==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0999267451964543093==--
