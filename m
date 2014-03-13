Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F13B07F84
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 06:29:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D82668F808F
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 04:29:11 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	yx34eiLQrrlUzqPi for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 04:29:09 -0700 (PDT)
Date: Thu, 13 Mar 2014 22:29:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: add a test for unlinked inodes due to O_TMPFILE
Message-ID: <20140313112907.GJ4263@dastard>
References: <20140313101302.996355155@bombadil.infradead.org>
	<20140313101433.608283621@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140313101433.608283621@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Mar 13, 2014 at 03:13:05AM -0700, Christoph Hellwig wrote:
> Make sure that we see unlinked inodes when shutting a filesystem
> down that has an open O_TMPFILE descriptor, and make sure that it
> has been deleted after a mount/umount cycle.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/006     |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/006.out |   43 ++++++++++++++++++++++++++
>  tests/xfs/group   |    1 +
>  3 files changed, 133 insertions(+)
>  create mode 100755 tests/xfs/006
>  create mode 100644 tests/xfs/006.out
> 
> diff --git a/tests/xfs/006 b/tests/xfs/006
> new file mode 100755
> index 0000000..7dae43d
> --- /dev/null
> +++ b/tests/xfs/006
> @@ -0,0 +1,89 @@
> +#! /bin/bash
> +# XFS QA Test No. 006
> +#
> +# Test O_TMPFILE interaction with log recovery and repair.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Christoph Hellwig.  All Rights Reserved.
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
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +    rm -f ${testfile}

No need to remove the testfile on a scratch device here.

...

> +testfile="${SCRATCH_MNT}/tst-tmpfile-flink"

isn't used.

> +
> +_scratch_mount
> +
> +#
> +# Test creating a r/w tmpfile, make sure it goes out to disk while still
> +# open using a freeze/thaw, and then shut down the filesystem.
> +#
> +$XFS_IO_PROG -x -T \
> +	-c "pwrite 0 4096" \
> +	-c "pread 0 4096" \
> +	-c "freeze" \
> +	-c "thaw" \
> +	-c "shutdown" \
> +	${SCRATCH_MNT} | _filter_xfs_io

So that's an inode on the unlinked list with a link count of zero.

> +_scratch_unmount
> +
> +# repair should find an unlinked inode now
> +_scratch_xfs_repair -n 2>&1 | \
> +	_filter_repair > $tmp.repair

The filter removes the AGI unlinked bucket inode listings, which is
what we really want to see here. The checking for disconnected
inodes is a side effect of using no-modify mode - if it was a real
repair that inode would be trashed, not seen as a disconnected
inode.

Hence I think this is really checking for the wrong thing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
