Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D498B7F6A
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 11:48:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD5A28F8037
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 09:48:02 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id efbTcKtHOsdM66zo for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 09:47:57 -0800 (PST)
Message-ID: <513B75CD.2050400@sandeen.net>
Date: Sat, 09 Mar 2013 11:47:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: 299: moving and deleting sparse copies on btrfs
References: <50F9C324.5010502@oracle.com>
In-Reply-To: <50F9C324.5010502@oracle.com>
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
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: xfs@oss.sgi.com

On 1/18/13 3:48 PM, Koen De Wit wrote:
> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>

same comments as the others; looks good otherwise.

-Eric

> ---
> 299     |   69 
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   299.out |    4 +++
>   2 files changed, 73 insertions(+), 0 deletions(-)
>   create mode 100644 299
>   create mode 100644 299.out
> 
> diff --git a/299 b/299
> new file mode 100644
> index 0000000..0ddb022
> --- /dev/null
> +++ b/299
> @@ -0,0 +1,69 @@
> +#! /bin/bash
> +# FS QA Test No. 299
> +#
> +# Moving and deleting cloned ("reflinked") files on btrfs:
> +#   - Create a file and a reflink
> +#   - Move both to a directory
> +#   - Delete the original (moved) file, check that the copy still exists.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013, Oracle and/or its affiliates.  All Rights Reserved.
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
> +# creator
> +owner=koen.de.wit@oracle.com
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +
> +_require_cp_reflink
> +
> +TESTDIR1=$TEST_DIR/test-$seq.$$
> +mkdir $TESTDIR1
> +
> +$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original > /dev/null
> +cp --reflink $TESTDIR1/original $TESTDIR1/copy
> +mkdir $TESTDIR1/subdir
> +mv $TESTDIR1/original $TESTDIR1/subdir/original_moved
> +mv $TESTDIR1/copy $TESTDIR1/subdir/copy_moved
> +md5sum $TESTDIR1/subdir/original_moved | $AWK_PROG 'END {print $1}'
> +md5sum $TESTDIR1/subdir/copy_moved | $AWK_PROG 'END {print $1}'
> +rm $TESTDIR1/subdir/original_moved
> +md5sum $TESTDIR1/subdir/copy_moved | $AWK_PROG 'END {print $1}'
> +rm -rf $TESTDIR1/subdir
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/299.out b/299.out
> new file mode 100644
> index 0000000..f06eb2b
> --- /dev/null
> +++ b/299.out
> @@ -0,0 +1,4 @@
> +QA output created by 299
> +42d69d1a6d333a7ebdf64792a555e392
> +42d69d1a6d333a7ebdf64792a555e392
> +42d69d1a6d333a7ebdf64792a555e392
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
