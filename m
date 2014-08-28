Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA30E7F3F
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 05:16:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C82728F8054
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 03:16:34 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8HGckVHsqhAZWEqC for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 03:16:32 -0700 (PDT)
Date: Thu, 28 Aug 2014 20:16:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH xfstests] xfs: add tests for XFS_IOC_FSSETXATTR behaviour
Message-ID: <20140828101628.GS20518@dastard>
References: <20140718191314.GB27801@teal.hq.k1024.org>
	<1409199840-16907-1-git-send-email-iusty@k1024.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409199840-16907-1-git-send-email-iusty@k1024.org>
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
To: Iustin Pop <iusty@k1024.org>
Cc: hch@infradead.org, fstests@vger.kernel.org, xfs@oss.sgi.com

[cc fstests@vger.kernel.org]

On Wed, Aug 27, 2014 at 09:24:00PM -0700, Iustin Pop wrote:
> Add two tests that check for correct behaviour of XFS_IOC_FSSETXATTR:
> 
> - 307: check that extent size can always be set on a directory
> - 308: check that setting a non-zero extent size directly via the ioctl
>   sets the expected flags (EXTSIZE and EXTSZINHERIT)
> 
> Signed-off-by: Iustin Pop <iusty@k1024.org>

Minor stuff first:

- xfstests patches should be sent to fstests@vger.kernel.org now.
- can you pick the first unused numbers in the sequence for new
  tests (xfs/032, xfs/051) so I don't have to renumber them before
  applying them?
- a patch per new test - it makes it easier to review and apply as i
  don't have to split patches into multiple commits...

> diff --git a/tests/xfs/307 b/tests/xfs/307
> new file mode 100755
> index 0000000..e8f3576
> --- /dev/null
> +++ b/tests/xfs/307
> @@ -0,0 +1,87 @@
> +#! /bin/bash
> +# FS QA Test No. 307
> +#
> +# Test that setting extent size on directories work even for large
> +# directories.

What is a "large directory"? Wouldn't it be better to describe the
test as "Determine whether the extent size hint can be set on
directories with allocated extents correctly"?

> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Google Inc.  All Rights Reserved.

Is that correct? It doesn't match the email address you sent this
from and I've never seen you post from a @google.com address.  I
always like to check that the copyright assignment is correct in
situations like this...

> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_test

Not needed, doesn't use the test device.

> +_require_scratch
> +
> +_scratch_mkfs_xfs >/dev/null 2>&1
> +_scratch_mount
> +
> +small=$SCRATCH_MNT/small
> +big=$SCRATCH_MNT/big
> +
> +# sanity check on a small directory
> +mkdir $small
> +# expect that an empty directory has no extents
> +xfs_bmap $small | grep -q "no extents"

Better to use xfs_io directly and filter out $SCRATCH_MNT into the
golden output file like so:

$XFS_IO_PROG -c "bmap" $small | _filter_scratch

which will give:

SCRATCH_MNT/small: no extents

> +# and that we can set an extent size on it
> +xfs_io -c 'extsize 8m' $small

$XFS_IO_PROG

> +# and finally check that the extent size update has taken place
> +(cd $SCRATCH_MNT; xfs_io -c 'extsize' small)

$XFS_IO_PROG -c 'extsize' $small | _filter_scratch

> +# now create a 'big' (with extents) directory
> +mkdir $big
> +idx=1
> +while xfs_bmap $big | grep -q "no extents"; do
> +	touch $big/$idx
> +	idx=$((idx+1))
> +	if [ "$idx" -gt 1048576 ]; then
> +		# still no extents? giving up
> +		echo "Can't make a directory to have extents even after 1M files" 1>&2
> +		exit
> +	fi
> +done

urk. largest inode size is 2kb, which means at most it can fit less
than 100 dirents in the inode before spilling to extent form. So
just do a loop that creates 1000 files - there's no need to
overengineer the test code.

> +# expect that we can set the extent size on $big as well
> +xfs_io -c 'extsize 8m' $big

$XFS_IO_PROG

> +# and that it took effect
> +(cd $SCRATCH_MNT; xfs_io -c 'extsize' big)

$XFS_IO_PROG -c 'extsize' $big | _filter_scratch

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/307.out b/tests/xfs/307.out
> new file mode 100644
> index 0000000..f825525
> --- /dev/null
> +++ b/tests/xfs/307.out
> @@ -0,0 +1,3 @@
> +QA output created by 307
> +[8388608] small
> +[8388608] big
> diff --git a/tests/xfs/308 b/tests/xfs/308
> new file mode 100755
> index 0000000..7b43836
> --- /dev/null
> +++ b/tests/xfs/308
> @@ -0,0 +1,98 @@
> +#! /bin/bash
> +# FS QA Test No. 308
> +#
> +# Test that setting extent size on files and directories (directly via
> +# ioctl and not via xfs_io) sets the correct flags.

xfs_io uses the ioctl directly - there's no need to write a special
c program to do this, especially as....

> +touch $file
> +mkdir $dir
> +
> +cat > $cprog << EOF
> +#include <stdio.h>
> +#include <xfs/xfs.h>
> +
> +int main(int argc, char **argv) {
> +	struct fsxattr fa;
> +	int fd = open(argv[1], O_RDONLY);
> +	if (fd < 0) {
> +		perror("open");
> +		return 1;
> +	}
> +	fa.fsx_xflags = 0;
> +	fa.fsx_extsize = 1048576 * 8;
> +	int r = xfsctl(argv[1], fd, XFS_IOC_FSSETXATTR, &fa);

.... that code is quite broken. Yes, it would work to set the
appropriate extent size flags with the kernel
changes you made, but that's not how this ioctl works.

i.e. it will cause any flag bits that are set on the inode to be
cleared and it's likely to fail on old kernels beacuse they have
very different behaviour to what your patch does.

IOWs, setting fsx_extsize without setting either XFS_XFLAG_EXTSIZE
or XFS_XFLAG_EXTSZINHERIT is bad practice. The kernel is left to
guess what you actually wanted to be done - the flags are supposed
to tell the kernel that the fsx_extsize value is meaningful, not the
other way around.

FWIW, the xfs_io code is *exactly* what applications should be
doing to set the extent size or any other inode flag. i.e:

1. stat the fd to determine the type.
2. populate the fsxattr structure with the existing inode flags
3. change the flags/fields of the fsxattr structure appropriately
4. set the new values to the inode.

i.e, from io/open.c:

static int
set_extsize(const char *path, int fd, long extsz)
{
        struct fsxattr  fsx;
        struct stat64   stat;

        if (fstat64(fd, &stat) < 0) {
                perror("fstat64");
                return 0;
        }
        if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
                printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
                        progname, path, strerror(errno));
                return 0;
        }

        if (S_ISREG(stat.st_mode)) {
                fsx.fsx_xflags |= XFS_XFLAG_EXTSIZE;
        } else if (S_ISDIR(stat.st_mode)) {
                fsx.fsx_xflags |= XFS_XFLAG_EXTSZINHERIT;
        } else {
                printf(_("invalid target file type - file %s\n"), path);
                return 0;
        }
        fsx.fsx_extsize = extsz;

        if ((xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx)) < 0) {
                printf("%s: XFS_IOC_FSSETXATTR %s: %s\n",
                        progname, path, strerror(errno));
                return 0;
        }

        return 0;
}

We have xfs_io precisely so that we don't have to maintain random
test code like this throughout xfstests - do it once, do it right,
use it everywhere.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
