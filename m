Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 784667F3F
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 14:55:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5847A304048
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 12:55:34 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id N4QIwEWz1HN6n2Ft for <xfs@oss.sgi.com>;
	Mon, 28 Oct 2013 12:55:33 -0700 (PDT)
Message-ID: <526EC12D.90600@suse.com>
Date: Mon, 28 Oct 2013 15:55:25 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
Subject: Re: [patch 1/3] [PATCH 1/3] xfstests: add test for global metadata
	reservation publishing
References: <20131025205246.269327744@suse.com>
	<20131025205559.519204526@suse.com>
	<20131028155948.GD4543@localhost.localdomain>
In-Reply-To: <20131028155948.GD4543@localhost.localdomain>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3290007477858137506=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============3290007477858137506==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="xC3Cgo0tcEhqUiVAqB3enagReaNxe0OD9"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xC3Cgo0tcEhqUiVAqB3enagReaNxe0OD9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/28/13, 11:59 AM, Josef Bacik wrote:
> On Fri, Oct 25, 2013 at 04:52:47PM -0400, Jeff Mahoney wrote:
>> My publishing patchset added the ability for the kernel to report
>> the size of the global metadata reservation via ioctl and sysfs.
>>
>> This test confirms that we get sane results on an empty file system.
>>
>> ENOTTY and missing /sys/fs/btrfs/<fsid>/allocation are not considered
>> failures.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  src/Makefile             |  3 +-
>>  src/btrfs_ioctl_helper.c | 90 +++++++++++++++++++++++++++++++++++++++=
+++++++
>>  tests/btrfs/100          | 92 +++++++++++++++++++++++++++++++++++++++=
+++++++++
>>  tests/btrfs/100.out      |  2 ++
>>  4 files changed, 186 insertions(+), 1 deletion(-)
>>  create mode 100644 src/btrfs_ioctl_helper.c
>>  create mode 100755 tests/btrfs/100
>>  create mode 100644 tests/btrfs/100.out
>>
>> diff --git a/src/Makefile b/src/Makefile
>> index 84c8297..299f675 100644
>> --- a/src/Makefile
>> +++ b/src/Makefile
>> @@ -18,7 +18,8 @@ LINUX_TARGETS =3D xfsctl bstat t_mtab getdevicesize =
preallo_rw_pattern_reader \
>>  	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
>>  	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
>>  	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
>> -	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec
>> +	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec \
>> +	btrfs_ioctl_helper
>> =20
>>  SUBDIRS =3D
>> =20
>> diff --git a/src/btrfs_ioctl_helper.c b/src/btrfs_ioctl_helper.c
>> new file mode 100644
>> index 0000000..a88b7b5
>> --- /dev/null
>> +++ b/src/btrfs_ioctl_helper.c
>> @@ -0,0 +1,90 @@
>> +#include <sys/ioctl.h>
>> +#include <stdio.h>
>> +#include <sys/fcntl.h>
>> +#include <errno.h>
>> +#include <string.h>
>> +#include <stdint.h>
>> +#include <unistd.h>
>> +
>> +#ifndef BTRFS_IOCTL_MAGIC
>> +#define BTRFS_IOCTL_MAGIC 0x94
>> +#endif
>> +
>> +#ifndef BTRFS_IOC_GLOBAL_RSV
>> +#define BTRFS_IOC_GLOBAL_RSV _IOR(BTRFS_IOCTL_MAGIC, 20, uint64_t)
>> +#endif
>> +
>> +static int global_rsv_ioctl(int fd, int argc, char *argv[])
>> +{
>> +	uint64_t reserved;
>> +	int ret =3D ioctl(fd, BTRFS_IOC_GLOBAL_RSV, &reserved);
>> +	if (ret)
>> +		return -errno;
>> +
>> +	printf("%llu\n", (unsigned long long)reserved);
>> +	return 0;
>> +}
>> +
>> +#define IOCTL_TABLE_ENTRY(_ioctl_name, _handler) \
>> +	{ .name =3D #_ioctl_name, .ioctl_cmd =3D BTRFS_IOC_##_ioctl_name, \
>> +	  .handler =3D _handler, }
>> +
>> +struct ioctl_table_entry {
>> +	const char *name;
>> +	unsigned ioctl_cmd;
>> +	int (*handler)(int fd, int argc, char *argv[]);
>> +};
>> +
>> +static struct ioctl_table_entry ioctls[] =3D {
>> +	IOCTL_TABLE_ENTRY(GLOBAL_RSV, global_rsv_ioctl),
>> +};
>> +
>> +int
>> +main(int argc, char *argv[])
>> +{
>> +	int fd;
>> +	int ret;
>> +	struct ioctl_table_entry *entry =3D NULL;
>> +	int i;
>> +
>> +	if (argc < 3) {
>> +		fprintf(stderr,
>> +			"usage: %s <fs mount point> <ioctl name> [args..]\n",
>> +			argv[0]);
>> +		return 1;
>> +	}
>> +
>> +	fd =3D open(argv[1], O_RDONLY|O_DIRECTORY);
>> +	if (fd < 0) {
>> +		perror(argv[1]);
>> +		return 1;
>> +	}
>> +
>> +	for (i =3D 0; i < (sizeof(ioctls)/sizeof(ioctls[0])); i++) {
>> +		if (strcmp(argv[2], ioctls[i].name) =3D=3D 0) {
>> +			entry =3D &ioctls[i];
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (!entry) {
>> +		fprintf(stderr, "ERROR: unknown ioctl %s\n", argv[2]);
>> +		close(fd);
>> +		return 1;
>> +	}
>> +
>> +	ret =3D entry->handler(fd, argc - 3, argv + 3);
>> +	if (ret =3D=3D -ENOTTY) {
>> +		printf("Not implemented.\n");
>> +		close(fd);
>> +		return 0;
>> +	} else if (ret) {
>> +		fprintf(stderr, "ERROR: %s failed: %s\n",
>> +			entry->name, strerror(-ret));
>> +		close(fd);
>> +		return 1;
>> +	}
>> +
>> +	close(fd);
>> +	return 0;
>> +}
>> diff --git a/tests/btrfs/100 b/tests/btrfs/100
>> new file mode 100755
>> index 0000000..d2a40b4
>> --- /dev/null
>> +++ b/tests/btrfs/100
>> @@ -0,0 +1,92 @@
>> +#!/bin/bash
>> +# FA QA Test No. 100
>> +#
>> +# Test global metadata reservation reporting
>> +#
>> +# 1) Create empty file system
>> +# 2) Call the BTRFS_IOC_GLOBAL_RSV ioctl and confirm it is 0 < x < 10=
MB
>> +# 3) Read the /sys/fs/btrfs/<fsid>/allocation/global_rsv_reserved fil=
e
>> +#    and confirm the value is 0 < x < 10 MB
>> +#
>> +#--------------------------------------------------------------------=
---
>> +# Copyright (c) 2013 SUSE, All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation=
,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#--------------------------------------------------------------------=
---
>> +
>> +seq=3D$(basename $0)
>> +seqres=3D$RESULT_DIR/$seq
>> +echo "=3D=3D QA output created by $seq"
>> +
>> +here=3D$(pwd)
>> +tmp=3D/tmp/$$
>> +status=3D1
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter.btrfs
>> +
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch
>> +
>> +_scratch_mkfs > /dev/null 2>&1
>> +_scratch_mount
>> +
>> +fsid() {
>> +	$BTRFS_UTIL_PROG filesystem show $1|awk '/uuid:/ {print $NF}'
>> +}
>=20
> This is the second place you use this, should go into common/rc or some=
 other
> common place.  Thanks,

Thanks for the review. I've posted an updated patchset that fixes these
and other issues.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--xC3Cgo0tcEhqUiVAqB3enagReaNxe0OD9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSbsEwAAoJEB57S2MheeWyFrwQAJopxC7SFiq0ZMVSSR+92sYm
3vz9HbiWKWgV41qFR1NtWkhSC9g1p9twVXwUn7yhYbBcwq4otp4v3sxkKxr5DZwa
fadakQa4hRgOxHZGUGFj2dbIcJx0c5qNNwv6UTGegeDW5fw+88hdI7ufIqncdZ4n
52Xpg6uO1WC7m2x44r4AC9eBRgpnTwsLt6HU2iXZNmhClHQ88c3HnDiYtFCZOv8v
kfM3+cMlZ0QbFrDYQ65NcBo6ABI4yU/arDCCFP9Vdx7WgK3wqSlJhW/dC/0yJx1n
NKs8nfHf7EED9ZcWwiwlNqKs6VxAqk9Y4mTjN51CtfrQObIFO7d930VpV0uaNwEJ
LXJYdng9zGHDAFuPA2AcOG9XRzd76mtC0WQre6Ifypf89O+Rxen2oyAkOC9Z2ABS
bqDI4SikRZxWnLi5e27854kStRAH0volJY7GKNZK6zQ2swrs2Q6bjGkSXSWclJPd
grmpIDNx3YM0dFmHSbbh19BRe7poM6ttdsjjEgx6LsICCg2bXPV5Quf68YVqGNUY
EeqtqZ60vw4KI0ElOOxlVgyrKsUuWuYls4SQK1wRnoZoqMzECcH9oPF91j6Evn7q
TJaM2yNE1ej27r882+ehjFR4b4lfKEdTAO2XZZgV+pbKXzupygW785goJMpVj9X/
8ZfZk/SpcQFr0wg8r7EX
=DXEw
-----END PGP SIGNATURE-----

--xC3Cgo0tcEhqUiVAqB3enagReaNxe0OD9--


--===============3290007477858137506==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3290007477858137506==--
