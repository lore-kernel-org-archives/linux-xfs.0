Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5NNjH1V146498 for <xfs@oss.sgi.com>; Sat, 23 Jun 2012 18:45:17 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MMSceSHWZYTF2rVA for <xfs@oss.sgi.com>;
	Sat, 23 Jun 2012 16:45:14 -0700 (PDT)
Date: Sun, 24 Jun 2012 09:44:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs states log stripe unit is too large
Message-ID: <20120623234445.GZ19223@dastard>
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ingo =?iso-8859-1?Q?J=FCrgensmann?= <ij@2012.bluespice.org>
Cc: xfs@oss.sgi.com

On Sat, Jun 23, 2012 at 02:50:49PM +0200, Ingo J=FCrgensmann wrote:
> muaddib:~# cat /proc/mdstat =

> Personalities : [raid1] [raid6] [raid5] [raid4] =

> md7 : active raid5 sdf4[3] sdd4[1] sde4[0]
>       7811261440 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] =
[UUU]
.....

> The RAID devices /dev/md0 to /dev/md4 are on my old 3x 1 TB
> Seagate disks. Anyway, to finally come to the problem, when I try
> to create a filesystem on the new RAID5 I get the following:  =

> =

> muaddib:~# mkfs.xfs /dev/lv/usr
> log stripe unit (524288 bytes) is too large (maximum is 256KiB)
> log stripe unit adjusted to 32KiB
> meta-data=3D/dev/lv/usr            isize=3D256    agcount=3D16, agsize=3D=
327552 blks
>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D0
> data     =3D                       bsize=3D4096   blocks=3D5240832, imaxp=
ct=3D25
>          =3D                       sunit=3D128    swidth=3D256 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> log      =3Dinternal log           bsize=3D4096   blocks=3D2560, version=
=3D2
>          =3D                       sectsz=3D512   sunit=3D8 blks, lazy-co=
unt=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> =

> =

> As you can see I follow the "mkfs.xfs knows best, don't fiddle
> around with options unless you know what you're doing!"-advice.
> But apparently mkfs.xfs wanted to create a log stripe unit of 512
> kiB, most likely because it's the same chunk size as the
> underlying RAID device. =


Exactly. Best thing in general is to align all log writes to the
underlying stripe unit of the array. That way as multiple frequent
log writes occur, it is guaranteed to form full stripe writes and
basically have no RMW overhead. 32k is chosen by default because
that's the default log buffer size and hence the typical size of
log writes.

If you increase the log stripe unit, you also increase the minimum
log buffer size that the filesystem supports. The filesystem can
support up to 256k log buffers, and hence the limit on maximum log
stripe alignment.

> The problem seems to be related to RAID5, because when I try to
> make a filesystem on /dev/md6 (RAID1), there's no error message:

They don't have a stripe unit/stripe width, so no alignment is
needed or configured.

> So, the question is: =

> - is this a bug somewhere in XFS, LVM or Linux's software RAID
> implementation?

Not a bug at all.

> - will performance suffer from log stripe size adjusted to just 32
> kiB? Some of my logical volumes will just store data, but one or
> the other will have some workload acting as storage for BackupPC.

For data volumes, no. For backupPC, it depends on whether the MD
RAID stripe cache can turn all the sequential log writes into a full
stripe write. In general, this is not a problem, and is almost never
a problem for HW RAID with BBWC....

> - would it be worth the effort to raise log stripe to at least 256
> kiB?

Depends on your workload. If it is fsync heavy, I'd advise against
it, as every log write will be padded out to 256k, even if you only
write 500 bytes worth of transaction data....

> - or would it be better to run with external log on the old 1 TB
> RAID?

External logs provide muchless benefit with delayed logging than hey
use to. As it is, your external log needs to have the same
reliability characteristics as the main volume - lose the log,
corrupt the filesystem. Hence for RAID5 volumes, you need a RAID1
log, and for RAID6 you either need RAID6 or a 3-way mirror to
provide the same reliability....

> End note: the 4 TB disks are not yet "in production", so I can run
> tests with both RAID setup as well as mkfs.xfs. Reshaping the RAID
> will take up to 10 hours, though... =


IMO, RAID reshaping is just a bad idea - it changes the alignment
characteristic of the volume, hence everything that the
filesystemlaid down in an aligned fashion is now unaligned, and you
have to tell the filesytemteh new alignment before new files will be
correctly aligned. Also, it's usually faster to back up, recreate
and restore than reshape and that puts a lot less load on your
disks, too...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
