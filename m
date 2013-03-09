Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EBFD97F6A
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 12:08:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8A18AAC001
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 10:08:07 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fM3rNYCRg2T4nDKM for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 10:08:06 -0800 (PST)
Message-ID: <513B7A85.6070606@sandeen.net>
Date: Sat, 09 Mar 2013 12:08:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: 300: diskspace consumption of cloned files on btrfs
References: <50F9C32A.6000600@oracle.com>
In-Reply-To: <50F9C32A.6000600@oracle.com>
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
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On 1/18/13 3:48 PM, Koen De Wit wrote:
> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
> 
> ---
> 300     |   84 
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   300.out |    4 +++
>   2 files changed, 88 insertions(+), 0 deletions(-)
>   create mode 100644 300
>   create mode 100644 300.out
> 
> diff --git a/300 b/300
> new file mode 100644
> index 0000000..a6f706c
> --- /dev/null
> +++ b/300
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# FS QA Test No. 300
> +#
> +# Diskspace consumption of sparse file clones ("reflinks") on btrfs
> +#    - Check that a reflink does not consume space
> +#    - Check that a reflink starts to consume space when the original file
> +#      is modified
> +#    - Check that diskspace is freed up after deleting all files
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

need def'n

> +TESTDIR1=$TEST_DIR/test-$seq.$$
> +mkdir $TESTDIR1

possible clash if pids cycle?

> +_free() {
> +    _df_dir $TEST_DIR | $AWK_PROG '{ print $5 }'
> +}
> +
> +free_before=`_free`
> +$XFS_IO_PROG -f -c "pwrite -S 0x61 0 10m" -c "fsync" $TESTDIR1/original 
>  > /dev/null

patch wrapped.  FWIW sometimes redirecting to $seq.full rather than
/dev/null makes it easier to see what's happened if anything goes wrong.

> +cp --reflink=always $TESTDIR1/original $TESTDIR1/copy1
> +cp --reflink=auto $TESTDIR1/copy1 $TESTDIR1/copy2
> +btrfs filesystem sync $TEST_DIR > /dev/null
> +free_after_creating_reflinks=`_free`
> +_within_tolerance "free space after creating 1 file and 2 reflinks" \
> +    `expr $free_before - $free_after_creating_reflinks` 10252 512 -v
> +

A comment about what's being checked here might help, unfortunately
the _within_tolerance helper is a little cryptic.

why should the difference be 10252, out of curiosity?  Does that depend
on block size or anything?

> +$XFS_IO_PROG -c "pwrite -S 0x62 3m 5m" -c "fsync" $TESTDIR1/original > 
> /dev/null

patch wrapped :)

> +btrfs filesystem sync $TEST_DIR > /dev/null
> +free_after_overwriting=`_free`


> +_within_tolerance "free space after overwriting original file" \
> +    `expr $free_before - $free_after_overwriting` 15376 512 -v

Ok, so you overwrote 5 megs of the original 10 meg file now.

So this is checking that the difference is within 512 bytes
newly-consumed space against . . . 15376 what?  It'd just be nice
to have a comment for future readers.

I wonder if comparing to $free_after_creating_reflinks would
be clearer, so the space used is just that space used for
the new data?

> +rm $TESTDIR1/original $TESTDIR1/copy1 $TESTDIR1/copy2
> +btrfs filesystem sync $TEST_DIR > /dev/null
> +free_after_removing=`_free`
> +_within_tolerance "free space after removing all files" \
> +    `expr $free_before - $free_after_removing` 0 128 -v

This makes sense, make sure we're back to the original.

Is the 128 slop even necessary?

Need to add this test to groups as well.

Thanks,
-Eric

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/300.out b/300.out
> new file mode 100644
> index 0000000..bbb94f4
> --- /dev/null
> +++ b/300.out
> @@ -0,0 +1,4 @@
> +QA output created by 300
> +free space after creating 1 file and 2 reflinks is in range
> +free space after overwriting original file is in range
> +free space after removing all files is in range
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
