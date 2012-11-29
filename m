Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAT0WMfn231775 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 18:32:23 -0600
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id CsW1rJGC4sUhxUBk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 16:34:39 -0800 (PST)
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id DD6163EE0B5
	for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 09:34:37 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id C3C8745DE4E
	for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 09:34:37 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id A520845DE4D
	for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 09:34:37 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 98BDA1DB8040
	for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 09:34:37 +0900 (JST)
Received: from g01jpexchkw02.g01.fujitsu.local
	(g01jpexchkw02.g01.fujitsu.local [10.0.194.41])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 54B7B1DB803B
	for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 09:34:37 +0900 (JST)
Message-ID: <50B6AD80.4090900@jp.fujitsu.com>
Date: Thu, 29 Nov 2012 09:34:08 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [BUG] xfs_quota: can't handle the users managed by LDAP
References: <50ADB27F.8070806@jp.fujitsu.com> <20121122233757.GY2591@dastard>
	<50B32CC1.3020907@jp.fujitsu.com> <50B4198E.7080408@jp.fujitsu.com>
	<20121127025728.GU32450@dastard> <50B46B66.2040908@jp.fujitsu.com>
	<20121127210518.GN6434@dastard>
In-Reply-To: <20121127210518.GN6434@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs ML <xfs@oss.sgi.com>

(2012/11/28 6:05), Dave Chinner wrote:
> On Tue, Nov 27, 2012 at 04:27:34PM +0900, Satoru Takeuchi wrote:
>>>>>>> Current xfs_quota (I pulled xfsprogs today) seems not be able to th=
e users
>>>>>>> managed by LDAP. There is no patch since I'm not good at LDAP and d=
on't know
>>>>>>> the root cause yet ;-(
>>>>>>>
>>>>>>> Step to reproduce(in this case, "sat" is the user managed by LDAP):
>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>>>>>>> # uname -r
>>>>>>> 3.7.0-rc5
>>>>>>> # mount -o loop,usrquota xfs.img mnt
>>>>>>> # xfsprogs/quota/xfs_quota -xc "limit bsoft=3D10M bhard=3D10M sat" =
/dev/loop0
>>>>>>> xfs_quota: invalid user name: sat                                  =
        # denied
>>>>>>> # su sat
>>>>>>> $                                                                  =
        # But this user acutally exists.
>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> .....
> =

>> So there is a problem in "report" subcommand. Refer to report_without_U.=
log,
>> I found "quotactl(Q_XGETQUOTA|GRPQUOTA, ...) is only called for local us=
ers
>> and it's because that getpwent() only returned only local users.
> =

> Yes, it appears from the strace that glibc is only reading
> /etc/passwd and not querying the ldap server.
> =

>> open("/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) =3D 3
>> fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D1724, ...}) =3D 0
>> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)=
 =3D 0x7f851afee000
>> read(3, "#=A5n# /etc/nsswitch.conf=A5n#=A5n# An ex"..., 4096) =3D 1724
>> read(3, "", 4096)                       =3D 0
>> close(3)                                =3D 0
> ...
>> open("/lib64/libnss_files.so.2", O_RDONLY|O_CLOEXEC) =3D 3
> ...
>> open("/etc/passwd", O_RDONLY|O_CLOEXEC) =3D 3
>> fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D2005, ...}) =3D 0
>> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)=
 =3D 0x7f851afee000
>> lseek(3, 0, SEEK_CUR)                   =3D 0
>> read(3, "root:x:0:0:root:/root:/bin/bash=A5n"..., 4096) =3D 2005
>> quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 0, {version=3D1, flags=3DXF=
S_USER_QUOTA, fieldmask=3D0, id=3D0, blk_hardlimit=3D0, blk_softlimit=3D0, =
ino_hardlimit=3D0, ino_softlimit=3D0, bcount=3D0, icount=3D3, ...}) =3D 0
> =

> As you can see, it only dynamically loads the local files name
> service library, not the ones that do ldap lookups.
> =

> Can you run ldd on the test binary you had and on xfs_quota to see
> if they are linked against the same libraries?

I ran ldd on the test binary and found that I built it on i686
machine and the test machine is x86_64. So the test binary
couldn't find the suitable 32 bit nss library on the test machine.
I found the test binary built on the test machine works the same
as xfs_quota.

             | build machine | getpwnam  | getpwent
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
test binary  | 32 bit        | NG        | NG
             | 64 bit        | OK        | NG
-------------+---------------+-----------+----------
xfs_quota    | 64 bit        | OK        | NG
-------------+---------------+-----------+----------

Since the test binary(64bit) and xfs_quota load the same
nss library and have the same behavior, it's apparently
not the xfs_quota problem but the LDAP/libnss related problem.

I will dig this problem more as the LDAP/libnss perspective.

Thank you very much for helping me, Dave.

Satoru

> =

> Other than that, I've go no idea why glibc would be behaving
> differently for the same library call from different binaries.
> it tends to imply a problem outside of xfs_quota, but I know close
> to nothing about LDAP and the glibc name services, so I don't know
> what more I can do to help here....
> =

> Cheers,
> =

> Dave.
> =



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
