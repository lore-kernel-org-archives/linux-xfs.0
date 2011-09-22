Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MKqpuR258869 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 15:52:51 -0500
Subject: Re: [PATCH 1/2 v2][xfstests] Add test 257: Check proper FITRIM
	argument handling
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1315410523-23925-1-git-send-email-lczerner@redhat.com>
References: <1315410523-23925-1-git-send-email-lczerner@redhat.com>
Date: Thu, 22 Sep 2011 15:52:46 -0500
Message-ID: <1316724766.2009.78.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, 2011-09-07 at 17:48 +0200, Lukas Czerner wrote:
> This test suppose to validate that file systems are using the fitrim
> arguments right. It checks that the fstrim returns EINVAl in case that
> the start of the range is beyond the end of the file system, and also
> that the fstrim works without an error if the length of the range is
> bigger than the file system (it should be truncated to the file system
> length automatically within the fitrim implementation).
> 
> This test should also catch common problem with overflow of start+len.
> Some file systems (ext4,xfs) had overflow problems in the past so there
> is a specific test for it (for ext4 and xfs) as well as generic test for
> other file systems, but it would be nice if other fs can add their
> specific checks if this problem does apply to them as well.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

I point out the same thing I did earlier on a different
test script.  This assumes bash is able to handle >32
bit values in its arithmetic expressions (within $(( ))).
That could be legitimate, I just haven't found an
authoritative answer on it.

I do know that bc supports arbitrary precision,
so if necessary it could be used to do whatever
calculations might exceed 32 bits.  E.g.:

function mult64() {
        [ $# = 2 ]      || exit 1       # Not enough arguments
        echo "$1" '*' "$2" | bc
}

     ...
	agsize=65536
	bsize=4096
	agbytes=$(mult64 $agsize $bsize)
	start=$(mult64 $base $agbytes)

I also have some other questions and comments
below.  Sorry I didn't comment on your earlier
edition.

					-Alex

> ---
> v2: add check for fsblock to agno overflow
> 
>  257     |  183 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  257.out |   14 +++++
>  group   |    1 +
>  3 files changed, 198 insertions(+), 0 deletions(-)
>  create mode 100755 257
>  create mode 100644 257.out
> 
> diff --git a/257 b/257
> new file mode 100755
> index 0000000..53efa92
> --- /dev/null
> +++ b/257
> @@ -0,0 +1,183 @@

. . .

> +			start="1152921504875282432"
> +			len="1152921504875282432"
> +			;;
> +	esac
> +
> +	_scratch_unmount
> +	_scratch_mkfs >/dev/null 2>&1
> +	_scratch_mount
> +	$here/src/fstrim -s$start -l$(($fsize/2)) $SCRATCH_MNT &> /dev/null
> +	[ $? -eq 0 ] && status=1 && echo "It seems that fs logic handling start"\
> +				         "argument overflows"

Please put the status assignment and echo within a proper
if/then/fi block.  I also don't really get what's going
on here. $? equal to 0 means success--so if it's
successful you report "it seems that...overflows"?
If it is right, please add a comment to make sure it's
clear what you're doing.

> +
> +	_scratch_unmount
> +	_scratch_mkfs >/dev/null 2>&1
> +	_scratch_mount
> +
> +	# len should be big enough to cover the whole file system, however this
> +	# test suppose for the overflow, so if the number of discarded bytes is
> +	# smaller than fsize/2 than it most likely does overflow.
> +	out=$($here/src/fstrim -v -l$len $SCRATCH_MNT)
> +	bytes=${out%% *}
> +
> +	# Btrfs is special and this test does not apply to it

Do all the other tests apply though?  Why doesn't this test
apply to btrfs as well?

> +	if [ $bytes -le $(($fsize*512)) ] && [ $FSTYP != "btrfs" ]; then
> +		status=1
> +		echo "It seems that fs logic handling len argument overflows"
> +	fi
> +	export MKFS_OPTIONS=$backup_mkfs_options
> +}
> +
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +
> +$here/src/fstrim -l 10M $SCRATCH_MNT &> /dev/null || _notrun "FSTRIM is not supported"

You could define
    FSTRIM="${here}/src/fstrim"
since you use it so many times.

> +
> +fsize=$(df -k | grep "$SCRATCH_MNT" | grep "$SCRATCH_DEV"  | awk '{print $2}')

"fssize" would be a better name.

> +# All these tests should return EINVAL
> +# since the start is beyond the end of
> +# the file system

. . .

> +_scratch_unmount
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +# This is a bit fuzzy, but since the file system is fresh
> +# there should be at least (fsize/2) free space to trim.
> +# This is supposed to catch wrong range.len handling and overflows.

I don't really don't understand what "wrong range.len
handling and overflows" means.

> +out=$($here/src/fstrim -v -s10M $SCRATCH_MNT)
> +bytes=${out%% *}
> +
> +if [ $bytes -gt $(($fsize*1024)) ]; then
> +	status=1
> +	echo "After the full fs discard $bytes bytes were discarded"\
> +	     "however the file system is $(($fsize*1024)) bytes long."\
> +	     "This is suspicious."

Is it possible to do a meaningful test of this case
that is reliable?  I.e., one that (almost) always
passes so we don't have to be overly concerned about
"suspicious" (rather than pass/fail) test results?

> +fi
> +
> +# Btrfs is special and this test does not apply to it
> +if [ $bytes -le $(($fsize*512)) ] && [ $FSTYP != "btrfs" ]; then
> +	status=1
> +	echo "After the full fs discard $bytes bytes were discarded"\
> +	     "however the file system is $(($fsize*1024)) bytes long."\
> +	     "This is suspicious."
> +fi
> +
> +# Now to catch overflows due to fsblk->allocation group number conversion
> +# This is different for every file system and it also apply just to some of
> +# them. In order to add check specific for file system you're interested in
> +# compute the arguments as you need and make the file system with proper
> +# alignment in function _check_conversion_overflow()
> +_check_conversion_overflow

This is just a bit structurally odd.  That is, it seems like
you should call a function to encapsulate setting up the
filesystem for the tests, then just run the tests here
(at the same "scope" as the fstrim tests run just above).

> +echo "Test done"
> +exit
> diff --git a/257.out b/257.out
> new file mode 100644

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
