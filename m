Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 539567F54
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 10:59:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25D1A304032
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 08:59:56 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id zrUziCmprirSzWJ6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Oct 2013 08:59:50 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 93EC77C068C
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 09:59:50 -0600 (MDT)
Date: Mon, 28 Oct 2013 11:59:48 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [patch 1/3] [PATCH 1/3] xfstests: add test for global metadata
	reservation publishing
Message-ID: <20131028155948.GD4543@localhost.localdomain>
References: <20131025205246.269327744@suse.com>
	<20131025205559.519204526@suse.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131025205559.519204526@suse.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On Fri, Oct 25, 2013 at 04:52:47PM -0400, Jeff Mahoney wrote:
> My publishing patchset added the ability for the kernel to report
> the size of the global metadata reservation via ioctl and sysfs.
> 
> This test confirms that we get sane results on an empty file system.
> 
> ENOTTY and missing /sys/fs/btrfs/<fsid>/allocation are not considered
> failures.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  src/Makefile             |  3 +-
>  src/btrfs_ioctl_helper.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/100          | 92 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/100.out      |  2 ++
>  4 files changed, 186 insertions(+), 1 deletion(-)
>  create mode 100644 src/btrfs_ioctl_helper.c
>  create mode 100755 tests/btrfs/100
>  create mode 100644 tests/btrfs/100.out
> 
> diff --git a/src/Makefile b/src/Makefile
> index 84c8297..299f675 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -18,7 +18,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
>  	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
>  	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
> -	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec
> +	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec \
> +	btrfs_ioctl_helper
>  
>  SUBDIRS =
>  
> diff --git a/src/btrfs_ioctl_helper.c b/src/btrfs_ioctl_helper.c
> new file mode 100644
> index 0000000..a88b7b5
> --- /dev/null
> +++ b/src/btrfs_ioctl_helper.c
> @@ -0,0 +1,90 @@
> +#include <sys/ioctl.h>
> +#include <stdio.h>
> +#include <sys/fcntl.h>
> +#include <errno.h>
> +#include <string.h>
> +#include <stdint.h>
> +#include <unistd.h>
> +
> +#ifndef BTRFS_IOCTL_MAGIC
> +#define BTRFS_IOCTL_MAGIC 0x94
> +#endif
> +
> +#ifndef BTRFS_IOC_GLOBAL_RSV
> +#define BTRFS_IOC_GLOBAL_RSV _IOR(BTRFS_IOCTL_MAGIC, 20, uint64_t)
> +#endif
> +
> +static int global_rsv_ioctl(int fd, int argc, char *argv[])
> +{
> +	uint64_t reserved;
> +	int ret = ioctl(fd, BTRFS_IOC_GLOBAL_RSV, &reserved);
> +	if (ret)
> +		return -errno;
> +
> +	printf("%llu\n", (unsigned long long)reserved);
> +	return 0;
> +}
> +
> +#define IOCTL_TABLE_ENTRY(_ioctl_name, _handler) \
> +	{ .name = #_ioctl_name, .ioctl_cmd = BTRFS_IOC_##_ioctl_name, \
> +	  .handler = _handler, }
> +
> +struct ioctl_table_entry {
> +	const char *name;
> +	unsigned ioctl_cmd;
> +	int (*handler)(int fd, int argc, char *argv[]);
> +};
> +
> +static struct ioctl_table_entry ioctls[] = {
> +	IOCTL_TABLE_ENTRY(GLOBAL_RSV, global_rsv_ioctl),
> +};
> +
> +int
> +main(int argc, char *argv[])
> +{
> +	int fd;
> +	int ret;
> +	struct ioctl_table_entry *entry = NULL;
> +	int i;
> +
> +	if (argc < 3) {
> +		fprintf(stderr,
> +			"usage: %s <fs mount point> <ioctl name> [args..]\n",
> +			argv[0]);
> +		return 1;
> +	}
> +
> +	fd = open(argv[1], O_RDONLY|O_DIRECTORY);
> +	if (fd < 0) {
> +		perror(argv[1]);
> +		return 1;
> +	}
> +
> +	for (i = 0; i < (sizeof(ioctls)/sizeof(ioctls[0])); i++) {
> +		if (strcmp(argv[2], ioctls[i].name) == 0) {
> +			entry = &ioctls[i];
> +			break;
> +		}
> +	}
> +
> +	if (!entry) {
> +		fprintf(stderr, "ERROR: unknown ioctl %s\n", argv[2]);
> +		close(fd);
> +		return 1;
> +	}
> +
> +	ret = entry->handler(fd, argc - 3, argv + 3);
> +	if (ret == -ENOTTY) {
> +		printf("Not implemented.\n");
> +		close(fd);
> +		return 0;
> +	} else if (ret) {
> +		fprintf(stderr, "ERROR: %s failed: %s\n",
> +			entry->name, strerror(-ret));
> +		close(fd);
> +		return 1;
> +	}
> +
> +	close(fd);
> +	return 0;
> +}
> diff --git a/tests/btrfs/100 b/tests/btrfs/100
> new file mode 100755
> index 0000000..d2a40b4
> --- /dev/null
> +++ b/tests/btrfs/100
> @@ -0,0 +1,92 @@
> +#!/bin/bash
> +# FA QA Test No. 100
> +#
> +# Test global metadata reservation reporting
> +#
> +# 1) Create empty file system
> +# 2) Call the BTRFS_IOC_GLOBAL_RSV ioctl and confirm it is 0 < x < 10MB
> +# 3) Read the /sys/fs/btrfs/<fsid>/allocation/global_rsv_reserved file
> +#    and confirm the value is 0 < x < 10 MB
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 SUSE, All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +
> +seq=$(basename $0)
> +seqres=$RESULT_DIR/$seq
> +echo "== QA output created by $seq"
> +
> +here=$(pwd)
> +tmp=/tmp/$$
> +status=1
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter.btrfs
> +
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +fsid() {
> +	$BTRFS_UTIL_PROG filesystem show $1|awk '/uuid:/ {print $NF}'
> +}

This is the second place you use this, should go into common/rc or some other
common place.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
