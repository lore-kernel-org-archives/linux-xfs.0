Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q620JVeG140518 for <xfs@oss.sgi.com>; Sun, 1 Jul 2012 19:19:31 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	u2M7RXfIelkJ0NKt for <xfs@oss.sgi.com>;
	Sun, 01 Jul 2012 17:19:29 -0700 (PDT)
Date: Mon, 2 Jul 2012 10:19:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs user quota differs from filesystem data
Message-ID: <20120702001926.GO19223@dastard>
References: <4FED8C81.70703@uni-bonn.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FED8C81.70703@uni-bonn.de>
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
To: Marc Mertes <mertes@uni-bonn.de>
Cc: xfs@oss.sgi.com

On Fri, Jun 29, 2012 at 01:07:45PM +0200, Marc Mertes wrote:
> Hi everybody,
> I run into a problem and I don=B4t know how to solve that.
> =

> First my system infos:
> =

> xfs_repair version 2.9.8
> Kernel: 2.6.26-2-amd64 on debian lenny (5.0.9)

That's old (both kernel and userspace).

> CPU: 2x Quad-Core AMD Opteron(tm) Processor 2378
> RAM: 16GB
> Hardisk:
> Volume /dev/drbd0 /data xfs rw,noatime,attr2,nobarrier,usrquota 0 0
> DRBD Version 8.3.7 (api:88/proto:86-91)
> Hardware RAID 5 with 6 SAS2 Seagate Cheetah (450GB) disks (5+1xHS)
> on LSI 9260-8i SAS Controller
> =

> xfs_info /dev/drbd0
> meta-data=3D/dev/drbd0             isize=3D256    agcount=3D4,
> agsize=3D109744873 blks
>          =3D                       sectsz=3D512   attr=3D2
> data     =3D                       bsize=3D4096   blocks=3D438979490, ima=
xpct=3D5
>          =3D                       sunit=3D0      swidth=3D0 blks
> naming   =3Dversion 2              bsize=3D4096
> log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D2
>          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-co=
unt=3D0
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> =

> =

> Now my problem:
> I defined a userquota (for each, it=B4s our login server) with a
> soft-/hardlimit of 10/12GB
> Now I have a few users where the listet used quota is different from
> the real amount of data in ther folders.
> =

> Example1: xfs_quota -x -c "quota -uh bthoma" /data
> Disk quotas for User bthoma (343)
> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
> /dev/drbd0    10,1G    12G    15G  00 [------] /data
> =

> but:
> du -csh /data/user/bthoma
> 8,7G    /data/user/bthoma
> 8,7G    insgesamt

Does the user own files anywhere else on the filesystem? User quota
accounting is not limited to a single sub-tree, but if this is not
the case, then I'm not sure how this can occur.

> Example2:
> xfs_quota -x -c "quota -uh lindau" /data
> Disk quotas for User lindau (320)
> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
> /dev/drbd0    13,5G    20G    22G  00 [------] /data
> =

> but:
> du -csh /data/user/lindau
> 17G     /data/user/lindau
> 17G     insgesamt

And that is apparently under-reported. Which implies that there are
delayed allocation reservations - on kernels that old they are not
reported in quota, and depending on how long the quota sync took
before the report was issued and the user behaviour it is possible
to see this temporarily.

How widespread are these issues?

> I have no clue how to "refresh" the quota database,

Quota checks are done at mount time.  You need to unmount, mount
without the quota mount options, then unmount and mount again with
the quota options. Alternatively, you can unmount, run this:

# xfs_db -x -c 'sb 0' -c 'write qflags 0' $device

and then mount again.

> the quick n dirty solution was to set a higher quota for the
> affected users, that they are able to continue with working.
> Some reached their quota limit (like in Example one)

If it is affecting all users, then I'm wondering if, for some
reason, quotas have not been enabled at some time, and when
re-enabled a quotacheck was not executed.....

> at least:
> xfs_db frag -v:
> actual 3996075, ideal 3118453, fragmentation factor 21.96%

Totally irrelevant.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
