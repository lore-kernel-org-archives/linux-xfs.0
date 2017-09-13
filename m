Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:7857 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750950AbdIMG2j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2017 02:28:39 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1ds1A4-0006nI-6z
        for linux-xfs@vger.kernel.org; Wed, 13 Sep 2017 16:28:36 +1000
Date: Wed, 13 Sep 2017 16:28:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE, IMPORTANT] CVE-2017-14340: xfs: unprivileged user kernel
 oops
Message-ID: <20170913062836.GU17782@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

I just pushed this XFS vulnerability disclosure to
oss-security@lists.openwall.com, so it's out in public now though I
don't know how long it will take to get out through that list.

TL;DR:=20

Every XFS user needs to check if their kernel is compiled with
CONFIG_XFS_RT=3Dy and if they are you should plan to update your
kernels as soon as updated kernels filter through the
upstream/distro channels.

-Dave.
(Standing in for Darrick, who timed his holiday extremely well)


Summary
-------

XFS mishandles a user settable inode flag in kernels prior to
4.14-rc1 which can cause a local denial of service via a kernel
oops.


Description
-----------

Richard Wareing recently discovered that if the XFS kernel code is
compiled with CONFIG_XFS_RT=3Dy, the code mishandles
FS_XFLAG_RTINHERIT and FS_XFLAG_REALTIME flags when the filesystem
does not have a realtime device configured. When an fsync/fdatasync
operation is run on an inode configured this way, we attempt to
flush the cache of the non-existent realtime device and the kernel
will oops.

While a user cannot set the FS_XFLAG_REALTIME directly on such a
filesystem, we fail to prevent them from setting the
FS_XFLAG_RTINHERIT on directories.  Hence files can inherit the
problematic FS_XFLAG_REALTIME flag from their parent directory at
create time. Setting the FS_XFLAG_RTINHERIT flag does not require
special privileges, so any user with permission to write to a
directory can set it.

Details of the oops signature and the trivial reproducer can be
found in the commit message for the fix below.


Scope of vulnerable filesystems
-------------------------------

This vulnerability was introduced in late 2005 by commit
f538d4da8d52 ("[XFS] write barrier support"). Hence XFS filesystems
on all kernels since 2.6.16 are vulnerable except for:

	* Kernels that are compiled with CONFIG_XFS_RT=3Dn are
	  not vulnerable.

	* XFS filesystems with actual realtime devices are not
	  not vulnerable.


How to recognise a vulnerable system
------------------------------------

1. Search the boot log for the XFS initialisation message. If this
message contains the world "realtime" then the kernel is vulnerable
to the issue:

CONFIG_XFS_RT=3Dy (vulnerable):

# dmesg |grep "XFS with"
[    1.625711] SGI XFS with ACLs, security attributes, realtime, debug enab=
led

CONFIG_XFS_RT=3Dn (not vulnerable):

# dmesg |grep "XFS with"
[    1.625711] SGI XFS with ACLs, security attributes, debug enabled


2. If you have a vulnerable kernel, check each XFS filesystems to
see if they use a realtime device.

This filesystem is not vulnerable as it has a realtime device
configured:

# xfs_info /mnt |grep ^realtime
realtime =3D/dev/ram0              extsz=3D4096   blocks=3D2048000, rtexten=
ts=3D2048000

This filesystem is vulnerable if the kernel is vulnerable as it does
not have a realtime device:

# xfs_info /mnt |grep ^realtime
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0


Mitigation
----------

Fixed upstream in 4.14-rc1, commit below.

Backports to supported stable upstream kernels is already underway,
so fixes will roll out with the next stable kernel releases.

Recompile the kernel with CONFIG_XFS_RT=3Dn. This is recommended for
users who cannot wait for upstream or distro kernel updates, cannot
backport the fix themselves and do not use realtime devices.


Upstream commit
---------------

commit b31ff3cdf540110da4572e3e29bd172087af65cc
Author: Richard Wareing <rwareing@fb.com>
Date:   Wed Sep 13 09:09:35 2017 +1000

    xfs: XFS_IS_REALTIME_INODE() should be false if no rt device present
   =20
    If using a kernel with CONFIG_XFS_RT=3Dy and we set the RHINHERIT flag =
on
    a directory in a filesystem that does not have a realtime device and
    create a new file in that directory, it gets marked as a real time file.
    When data is written and a fsync is issued, the filesystem attempts to
    flush a non-existent rt device during the fsync process.
   =20
    This results in a crash dereferencing a null buftarg pointer in
    xfs_blkdev_issue_flush():
   =20
      BUG: unable to handle kernel NULL pointer dereference at 000000000000=
0008
      IP: xfs_blkdev_issue_flush+0xd/0x20
      .....
      Call Trace:
        xfs_file_fsync+0x188/0x1c0
        vfs_fsync_range+0x3b/0xa0
        do_fsync+0x3d/0x70
        SyS_fsync+0x10/0x20
        do_syscall_64+0x4d/0xb0
        entry_SYSCALL64_slow_path+0x25/0x25
   =20
    Setting RT inode flags does not require special privileges so any
    unprivileged user can cause this oops to occur.  To reproduce, confirm
    kernel is compiled with CONFIG_XFS_RT=3Dy and run:
   =20
      # mkfs.xfs -f /dev/pmem0
      # mount /dev/pmem0 /mnt/test
      # mkdir /mnt/test/foo
      # xfs_io -c 'chattr +t' /mnt/test/foo
      # xfs_io -f -c 'pwrite 0 5m' -c fsync /mnt/test/foo/bar
   =20
    Or just run xfstests with MKFS_OPTIONS=3D"-d rtinherit=3D1" and wait.
   =20
    Kernels built with CONFIG_XFS_RT=3Dn are not exposed to this bug.
   =20
    Fixes: f538d4da8d52 ("[XFS] write barrier support")
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Richard Wareing <rwareing@fb.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


Timeline:

2017.09.04 - Discussion on xfs@vger.kernel.org (public list) hinted
	     at crash bug in realtime device support
2017.09.09 - Bug found and reported to XFS maintainers
2017.09.12 - Bug reported to security@kernel.org
2017.09.13 - Fix committed to kernel
2017.09.13 - Announcement to oss-security

--=20
Dave Chinner
david@fromorbit.com

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJZuNATAAoJEK3oKUf0dfodRqkP/3MudPrQZHLNggNG4YYOrMm1
/frn6R66VWKP9L6QxsvRAm0pk83XSz1Y9syKKYpE68cVCCnywP3YbQT3rp7oKL4B
+KMNBYLgVX9/E/MRlw8VXBND3C7V4i8Bmy3b6Ly84FMaZUylNQfFR3tP/l1xB5a/
QD6zES/pURgnPMcBqS3Vq+ZiFg0McSd3bhx7+aP+KszThXGUxzXXTkU2xqKlVxXz
cQs049nTXEkJ+uMpXKvf9ZtO4fU1XOabYjd5iiOZ+oQ/I7gz8H6WJzbjdSrYdDBr
TZgCaQTDDUgWbYAjIKGKnodq35QF4E9buoxYxU0EqDbEpHR0mefayHg1s1XzLlUE
LLI15B1oEDhyqvW+apkUr0BFmARYfE9TXjENnwnLs8e11YEygai4ohJfoR+GYpEy
WPUF/clTAy6iJ0D65RucIz9/0+lK9OJH4B/dzrjr1yoyOz7+bIKXdYJiQiYn6Bk3
G7T1SSgvqtIV/gnZ1vNLGf+d/jYvLcTJkfZpV0KgYeFvAErlbjRuf7ciSE9dMYd9
5Ug04IMyCkDT85b8l+bCJC6tVSxU1wTTC6Y9lhWIPf7vEyWlU9+AZCZkXW6x6QFA
niXCPEJCtDaXr4Sp+euyF42xKSIcybhjdB1eIDl0+hEMeMPI1aOf1ejm8ZyF5bRe
eR9eGd3u7NeQF0GsMYuM
=dHIp
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
