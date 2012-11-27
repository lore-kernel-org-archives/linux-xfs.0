Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qARL34WP089084 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 15:03:04 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	leWgm2kr6mlfLzXO for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 13:05:20 -0800 (PST)
Date: Wed, 28 Nov 2012 08:05:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG] xfs_quota: can't handle the users managed by LDAP
Message-ID: <20121127210518.GN6434@dastard>
References: <50ADB27F.8070806@jp.fujitsu.com> <20121122233757.GY2591@dastard>
	<50B32CC1.3020907@jp.fujitsu.com> <50B4198E.7080408@jp.fujitsu.com>
	<20121127025728.GU32450@dastard> <50B46B66.2040908@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50B46B66.2040908@jp.fujitsu.com>
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
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: xfs ML <xfs@oss.sgi.com>

On Tue, Nov 27, 2012 at 04:27:34PM +0900, Satoru Takeuchi wrote:
> >>>>> Current xfs_quota (I pulled xfsprogs today) seems not be able to th=
e users
> >>>>> managed by LDAP. There is no patch since I'm not good at LDAP and d=
on't know
> >>>>> the root cause yet ;-(
> >>>>>
> >>>>> Step to reproduce(in this case, "sat" is the user managed by LDAP):
> >>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> >>>>> # uname -r
> >>>>> 3.7.0-rc5
> >>>>> # mount -o loop,usrquota xfs.img mnt
> >>>>> # xfsprogs/quota/xfs_quota -xc "limit bsoft=3D10M bhard=3D10M sat" =
/dev/loop0
> >>>>> xfs_quota: invalid user name: sat                                  =
        # denied
> >>>>> # su sat
> >>>>> $                                                                  =
        # But this user acutally exists.
> >>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
.....

> So there is a problem in "report" subcommand. Refer to report_without_U.l=
og,
> I found "quotactl(Q_XGETQUOTA|GRPQUOTA, ...) is only called for local use=
rs
> and it's because that getpwent() only returned only local users.

Yes, it appears from the strace that glibc is only reading
/etc/passwd and not querying the ldap server.

> open("/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) =3D 3
> fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D1724, ...}) =3D 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f851afee000
> read(3, "#=A5n# /etc/nsswitch.conf=A5n#=A5n# An ex"..., 4096) =3D 1724
> read(3, "", 4096)                       =3D 0
> close(3)                                =3D 0
...
> open("/lib64/libnss_files.so.2", O_RDONLY|O_CLOEXEC) =3D 3
...
> open("/etc/passwd", O_RDONLY|O_CLOEXEC) =3D 3
> fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D2005, ...}) =3D 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f851afee000
> lseek(3, 0, SEEK_CUR)                   =3D 0
> read(3, "root:x:0:0:root:/root:/bin/bash=A5n"..., 4096) =3D 2005
> quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 0, {version=3D1, flags=3DXFS=
_USER_QUOTA, fieldmask=3D0, id=3D0, blk_hardlimit=3D0, blk_softlimit=3D0, i=
no_hardlimit=3D0, ino_softlimit=3D0, bcount=3D0, icount=3D3, ...}) =3D 0

As you can see, it only dynamically loads the local files name
service library, not the ones that do ldap lookups.

Can you run ldd on the test binary you had and on xfs_quota to see
if they are linked against the same libraries?

Other than that, I've go no idea why glibc would be behaving
differently for the same library call from different binaries.
it tends to imply a problem outside of xfs_quota, but I know close
to nothing about LDAP and the glibc name services, so I don't know
what more I can do to help here....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
