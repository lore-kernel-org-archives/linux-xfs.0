Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D5127F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 14:05:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87327304048
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 12:05:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AFECuQUdiOh4sT7d (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 12:05:14 -0700 (PDT)
Date: Thu, 9 Jul 2015 15:05:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Issue with RHEL6 mkfs.xfs (3.1.1+), HP P420 RAID, and MySQL
	replication
Message-ID: <20150709190511.GH63282@bfoster.bfoster>
References: <110866563.1804043.1436463170539.JavaMail.yahoo@mail.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <110866563.1804043.1436463170539.JavaMail.yahoo@mail.yahoo.com>
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
To: Hogan Whittall <whittalh@yahoo-inc.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Jul 09, 2015 at 05:32:50PM +0000, Hogan Whittall wrote:
> Hello,
> Recently we encountered a previously-reported issue regarding write ampli=
fication with MySQL replication and XFS when used with certain RAID control=
lers (In our case, HP P420). =A0That issue exactly matches our issue and wa=
s documented by someone else here -=A0http://oss.sgi.com/archives/xfs/2013-=
03/msg00133.html=A0- but I don't see any resolution. =A0I will say that the=
 problem *does not* exist when mkfs.xfs 2.9.6 is used to format the filesys=
tem on RHEL6 as that sets sunit=3D0 and swidth=3D0 instead of setting based=
 on minimum_io_size and optimal_io_size.

I'm not very familiar with MySQL and thus not sure what your workload
is, but either version of mkfs.xfs should support setting options such
that the fs is formatted as with the defaults of another version...

> We have systems that are identical in how they are built and configured, =
we can take a RHEL6 box that has the MySQL partition formatted with mkfs.xf=
s v3.1.1 and reproduce the write amplification problem with MySQL replicati=
on every single time. =A0If we take the same box and format the MySQL parti=
tion with mkfs.xfs 2.9.6, then bring up MySQL with the exact same configura=
tion there is no problem. =A0I've included the working and broken settings =
below. =A0If it's not the sunit/swidth settings then what will cause 7-10MB=
/s worth of writes to the XFS partition to become over 200MB/s downstream? =
=A0The actual data change on the disks is not 200MB/s, but because the writ=
e ops are truly being amplified and not just being misreported our MySQL sl=
aves with the bad XFS settings cannot keep up and the lag steadily increase=
s with no hope of ever becoming current.

It would be nice to somehow see what requests are being made at the
application level. Perhaps via strace or something of that nature if you
can demonstrate a relatively isolated operation at the app. level
resulting in the same I/O requests to the kernel but different I/O out
of the filesystem..?

> I am happy to try some other settings/options with the RHEL6 mkfs.xfs to =
see if replication performance is able to match that of systems formatted w=
ith mkfs.xfs 2.9.6, but the values set by 3.1.1 with the P420 RAID do not w=
ork for MySQL replication. =A0We have ruled out everything else as a possib=
le cause, the absolute only difference on these systems is what values are =
set by mkfs.xfs.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=A0Working RHEL6 XFS partition:
> meta-data=3D/dev/mapper/sys-home =A0 isize=3D256 =A0 =A0agcount=3D4, agsi=
ze=3D71271680 blks=A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 sectsz=3D512 =A0 attr=3D2, projid32bit=3D0data =A0 =A0 =3D =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 blocks=3D285086720=
, imaxpct=3D5=A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sunit=3D0 =A0 =A0 =A0swidth=3D0 blksnaming =A0 =3Dversion 2 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0bsize=3D4096 =A0 ascii-ci=3D0log =A0 =A0 =A0=3Dinternal =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 blocks=3D32768, version=3D2=A0=
 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D51=
2 =A0 sunit=3D0 blks, lazy-count=3D0realtime =3Dnone =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 extsz=3D4096 =A0 blocks=3D0, rtextents=3D0
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=A0
> Broken RHEL6 XFS partition:
> meta-data=3D/dev/mapper/sys-home =A0 isize=3D256 =A0 =A0agcount=3D32, ags=
ize=3D8908992 blks=A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 sectsz=3D512 =A0 attr=3D2, projid32bit=3D0data =A0 =A0 =3D =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 blocks=3D285086720=
, imaxpct=3D5=A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sunit=3D64 =A0 =A0 swidth=3D128 blksnaming =A0 =3Dversion 2 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0bsize=3D4096 =A0 ascii-ci=3D0log =A0 =A0 =A0=3Dinternal =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 blocks=3D139264, version=3D2=
=A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=
=3D512 =A0 sunit=3D64 blks, lazy-count=3D1realtime =3Dnone =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 extsz=3D4096 =A0 blocks=3D0, rtextents=3D0
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=A0
> =


The differences I see for the second mkfs:

- agcount of 32 instead of 4
- sunit/swidth of 64/128 rather than 0/0
- log size of 139264 blocks rather than 32768
- lazy-count=3D1 rather than lazy-count=3D0

As mentioned above, I would take the "broken" mkfs.xfs and add options
one at a time that format the fs as the previous version did and try to
identify what leads to the behavior. E.g., maybe first use '-d
su=3D0,sw=3D0' to reset the stripe unit, then try adding '-l
size=3D<32768*blksize>' to set the log size, '-d agcount=3DN' to set the
allocation group count, etc.

Brian

> Thanks!
> -Hogan

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
