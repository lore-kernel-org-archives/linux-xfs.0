Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 728087F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 18:34:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 526D9304064
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 16:34:18 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Jq7gJzw2wzBNHkrC for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 16:34:16 -0800 (PST)
Date: Tue, 11 Feb 2014 11:34:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: test setting XFS BMBT fields
Message-ID: <20140211003407.GZ13647@dastard>
References: <20140210231046.910977175@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140210231046.910977175@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 10, 2014 at 05:10:43PM -0600, Mark Tinguely wrote:
> Test the setting of the XFS BMBT fields. Runs through the valid
> bit values for each field. Also test the value past the last legal
> value.
> 
> Additionally, ensures setting a core entry (core.gen is used) is
> still correct. Test that the hex (#HH) input on a BMBT field and a
> core entry are also correct.

A couple of comments below.

...
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
> +}
> +
> +_do_bit_test()
> +{
> +	_field="$1"
> +	_bits="$2"

The leading "_" is reserved for library functions and variables, not
local test variables.

> +
> +	echo "testing ${_field} ${_bits} bits" | sed 's/u3/u/'
> +	$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write ${_field} 0" \
> +			  $SCRATCH_DEV | sed 's/u3/u/'
> +	num=1
> +	for n in `seq 0 1 ${_bits}`; do
> +		$XFS_DB_PROG -x -c "inode $FILE_INO"  \
> +			  -c "write ${_field} ${num}" \
> +			  $SCRATCH_DEV | sed 's/u3/u/'

On the third time, a local filter_xfs_db function is appropriate. ;)

....

> +_scratch_unmount
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +# create the test file
> +echo "test file" > $SCRATCH_MNT/testfile
> +
> +# find the inode for the test file
> +FILE_INO=`ls -i $SCRATCH_MNT |awk '{print $1}'`

$SCRATCH_MNT/testfile?

> +
> +_scratch_unmount
> +
> +# test bit length constants
> +BMBT_EXNTFLAG_BITLEN=1
> +BMBT_STARTOFF_BITLEN=54
> +BMBT_STARTBLOCK_BITLEN=52
> +BMBT_BLOCKCOUNT_BITLEN=21
> +
> +# Which version of the filesystem?
> +echo $XFS_MKFS_OPTIONS | grep "crc=1" > /dev/null
> +if [ $? == 1 ]; then
> + prefix="u"
> +else
> + prefix="u3"
> +fi

Urk. That's messy. And it points out that xfs/278 has this same
problem. There's no reason that we need to test CRC enabled
filesystems here, and testing XFS_MKFS_OPTIONS is not reliable,
either as it will break if we change mkfs default behaviour.
Perhaps we'd do best simply to change the xfs_db prefix here to be
consistent for both v4 and v5 filesystesms ("u")? i.e. do this
before we release 3.2.0 and we can just ignore the problem....

.....
> Index: b/tests/xfs/group
> ===================================================================
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -186,3 +186,4 @@
>  304 auto quick quota
>  305 auto quota
>  306 auto stress log metadata repair
> +307 auto db

Definitely a quick test, too. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
