Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A99A7F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 03:05:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76E49AC002
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 01:05:20 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24]) by
	cuda.sgi.com with ESMTP id qkzWLYArlRpeIApy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 01:05:18 -0700 (PDT)
From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: xfs write performance issue
Date: Fri, 20 Mar 2015 09:05:14 +0100
Message-ID: <27980557.hGNkRfAxtu@xrated>
In-Reply-To: <20150319231854.GL10105@dastard>
References: <8976870.8vOdNBKrI1@xrated> <20150319231854.GL10105@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On Freitag, 20. M=E4rz 2015 10:18:54 Dave Chinner wrote:
> On Thu, Mar 19, 2015 at 06:01:50PM +0100, Hans-Peter Jansen wrote:
> > ~# LANG=3DC xfs_info /dev/sdc1
> > meta-data=3D/dev/sdc1              isize=3D256    agcount=3D17, agsize=
=3D183105406
> > blks
> > =

> >          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D0
> >          =3D                       crc=3D0        finobt=3D0
> > =

> > data     =3D                       bsize=3D4096   blocks=3D2929687287, =
imaxpct=3D5
> > =

> >          =3D                       sunit=3D0      swidth=3D0 blks
> > =

> > naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D0
> > log      =3DIntern                 bsize=3D4096   blocks=3D32768, versi=
on=3D2
> > =

> >          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-=
count=3D1
> > =

> > realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> =

> ....
> =

> > ~# LANG=3DC dd if=3DDjango_Unchained.mp4 of=3D/dev/null bs=3D1M
> > 1305+1 records in
> > 1305+1 records out
> > 1369162196 bytes (1.4 GB) copied, 3.32714 s, 412 MB/s
> > =

> > Write performance is disastrous: it's about 1.5 MB/s.
> > =

> > ~# LANG=3DC dd if=3DDjango_Unchained.mp4 of=3Dxxx bs=3D1M
> > 482+0 records in
> > 482+0 records out
> > 505413632 bytes (505 MB) copied, 368.816 s, 1.4 MB/s
> =

> Why did it stop half way through? ENOSPC?

Signaled with USR1 (impatient operator..)

> > 1083+0 records in
> > 1083+0 records out
> > 1135607808 bytes (1.1 GB) copied, 840.072 s, 1.4 MB/s
> =

> That's incomplete, too.

Still impatient.. Sorry for not omitting superfluous output.
 =

> > The question is, what could explain these numbers. Bad alignment? Bad
> > stripe size? And what can I do to resolve this - without loosing all my
> > data..
> More than likely you've fragmented free space, and so writes
> are small random write IO. Output of 'df -h' and:
> =

> $ xfs_db -r -c "freesp -s" <dev>
> =

> would be instructive.

With pleasure. In fact, I have two very similar sets:

Filesystem            Size  Used Avail Use% Mounted on
/dev/sdc1              11T  8.7T  2.3T  80% /work
/dev/sdd1              11T  4.4T  6.6T  40% /video

~# xfs_db -r -c "freesp -s" /dev/sdc1
   from      to extents  blocks    pct
      1       1   19465   19465   0.00
      2       3   27313   67348   0.01
      4       7   51150  280764   0.05
      8      15  210606 2722553   0.45
     16      31    2730   61134   0.01
     32      63    3396  152440   0.03
     64     127    3012  271804   0.04
    128     255    3083  570011   0.09
    256     511    3108 1134725   0.19
    512    1023    3257 2354022   0.39
   1024    2047    3449 4985593   0.82
   2048    4095    3427 9820314   1.61
   4096    8191    2624 15074450   2.47
   8192   16383    1546 17345180   2.85
  16384   32767     537 11970907   1.97
  32768   65535     216 10151639   1.67
  65536  131071      68 5782598   0.95
 131072  262143      25 4753893   0.78
 262144  524287      40 15117520   2.48
 524288 1048575      32 23913842   3.93
1048576 2097151       7 10855214   1.78
2097152 4194303       3 8824217   1.45
8388608 16777215       1 8572687   1.41
67108864 134217727       4 310678786  51.01
134217728 183105406       1 143607762  23.58
total free extents 339100
total free blocks 609088868
average free extent size 1796.19


~# xfs_db -r -c "freesp -s" /dev/sdd1
   from      to extents  blocks    pct
      1       1     933     933   0.00
      2       3     616    1400   0.00
      4       7     286    1503   0.00
      8      15     549    7084   0.00
     16      31     480   12151   0.00
     32      63     583   25882   0.00
     64     127     463   41568   0.00
    128     255     320   57243   0.00
    256     511     368  135099   0.01
    512    1023     258  180464   0.01
   1024    2047     512  800351   0.05
   2048    4095    1124 3455641   0.20
   4096    8191    1387 8176955   0.46
   8192   16383    1422 16262072   0.92
  16384   32767     920 21547937   1.22
  32768   65535     646 29770655   1.69
  65536  131071     971 108167644   6.13
 131072  262143       7 1378026   0.08
 262144  524287       3 1238114   0.07
 524288 1048575       1  655157   0.04
4194304 8388607       1 6882208   0.39
134217728 268435455       6 1566631060  88.74
total free extents 11856
total free blocks 1765429147
average free extent size 148906


Both suffer from the same abysmal write performance.

I took care of testing the idle one (sdd).

Thanks,
Pete

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
