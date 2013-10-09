Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 44DB37F3F
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 18:58:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0FC87304032
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 16:58:37 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	6oJAJqgUSSrzg4ru for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 16:58:35 -0700 (PDT)
Date: Thu, 10 Oct 2013 10:58:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 6/7] xfstest: Add test case to test multiple
	collapse range call
Message-ID: <20131009235828.GR4446@dastard>
References: <1381090446-2897-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381090446-2897-1-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: elder@kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

On Mon, Oct 07, 2013 at 05:14:06AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> We execute collapse range multiple times on same file.
> Each collapse range call collapses a single alternate block.
> After the test execution, file will be left with 80 blocks and
> as much number of extents.
> We also check for file system consistency after the completion.
.....
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs ext4
> +_supported_os Linux
> +
> +_require_scratch
> +_require_xfs_io_fiemap
> +_require_xfs_io_falloc_collapse
> +_do_die_on_error=y
> +test=$SCRATCH_MNT/test

Not used.

> +testfile=$SCRATCH_MNT/317.$$
> +BSIZE=4096
> +BLOCKS=10240
> +
> +# Filters fiemap output
> +_filter_fiemap()
> +{
> +	awk --posix '
> +		$3 ~ /hole/ {
> +			print $1, $2, $3;
> +			next;
> +		}
> +		$5 ~ /0x[[:xdigit:]]+/ {
> +			print $1, $2, "extent";
> +		}'
> +}

There's already a function in common/punch of this name, and it does
pretty much the same thing. Why not use that?

> +
> +case $FSTYP in
> +	ext4)
> +		export MKFS_OPTIONS="-F -b $BSIZE"
> +		;;
> +	xfs)
> +		export MKFS_OPTIONS="-f -b size=$BSIZE"
> +		;;
> +esac

_scratch_mkfs takes options on the command line - there is no need
to do this.

In fact, this test needs to run on all block sizes that filesystems
are capable of using, not just 4k and different architectures
exercise different code paths and so we must be able to test the
case where block size is smaller than page size on x86-64 so when
the code is run on an ia64 or ppc64 box with a 64k page size we know
that it's not completely broken...

Anyway, if you really need to make a 4k block size filesystem, then
_scratch_mkfs_sized() is the generic way of doing this.

> +# make filesystem on scratch with 4KB blocksize
> +_do 'make filesystem on $SCRATCH_DEV' '_scratch_mkfs'
> +_do 'mount filesytem' '_scratch_mount'

I really dislike this "_do" wrapper. The text does not add anything
to the test, and it makes it hard to see the command being run and
harder to modify it when necessary. It is used only by a couple of
old tests, and we'd do better to remove it than to propagate it
further.  This:

_scratch_mkfs >> $seqres.full 2>&1 || _fail "scratch_mkfs failed."
_scratch_mount >> $seqres.full 2>&1 || _fail "scratch_mount failed."

does everything that the _do wrapper does.

> +
> +# Write file
> +length=$(($BLOCKS*$BSIZE))
> +$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $testfile > /dev/null
> +
> +# Collapse alternate blocks
> +for (( i = 1; i <= 7; i++ )); do
> +	for(( j=0 ; j < $(($BLOCKS/(2**$i))) ; j++ )); do
> +		offset=$(($j*$BSIZE))
> +		$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $testfile > /dev/null
> +	done
> +done
> +
> +# Check if 80 extents are present
> +$XFS_IO_PROG -c "fiemap -v" $testfile | _filter_fiemap

If all you care about is that there are 80 extents, then why not
just something like:

$XFS_IO_PROG -c "fiemap -v" $testfile |grep "^ *[0-9]*:" |wc -l

> +
> +_do 'unmount $SCRATCH_DEV' 'umount $SCRATCH_DEV'
> +_do 'repair filesystem' '_check_scratch_fs'

_check_scratch_fs is all you need to call here.

> index 3a69294..80ff7ec 100644
> --- a/tests/shared/group
> +++ b/tests/shared/group
> @@ -12,3 +12,4 @@
>  298 auto trim
>  305 aio dangerous enospc rw stress
>  316 auto quick collapse
> +317 auto collapse

Again, I think the prealloc group is better for this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
