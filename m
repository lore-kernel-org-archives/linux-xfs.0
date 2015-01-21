Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C680C7F4E
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 22:13:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54024AC005
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 20:13:12 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7AuizEyQrSJxHgF0 for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 20:13:07 -0800 (PST)
Date: Wed, 21 Jan 2015 15:12:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests/xfs: xfs_repair secondary sb verification
	regression test
Message-ID: <20150121041230.GD16510@dastard>
References: <1421677821-30752-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421677821-30752-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jan 19, 2015 at 09:30:21AM -0500, Brian Foster wrote:
> The secondary superblock verification in xfs_repair was subject to a bug
> that unnecessarily leads to a brute force superblock scan if the last
> superblock in the fs happens to be corrupt. Normally, xfs_repair handles
> one-off superblock corruption gracefully using a heuristic that finds
> the most consistent superblock content across the set of secondary
> superblocks.
> 
> Create a regression test for xfs_repair that corrupts the last
> superblock in the fs. Verify the superblock is updated from the
> previously verified sb content and a brute force scan is not initiated.
> In the event of failure, detect that a brute force scan has started and
> abort the repair in order to fail the test quickly.
> 
> To support the test, extend the xfs_repair filter to handle corrupted
> superblock repair output and provide generic test output for arbitrary
> AG counts.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> This is an xfs_repair regression test to trigger the problem fixed by
> the following previously posted fix:
> 
> http://oss.sgi.com/archives/xfs/2015-01/msg00244.html
> 
> Thoughts appreciated, thanks.
...
> +# Start and monitor an xfs_repair of the scratch device. This test can induce a
> +# time consuming brute force superblock scan. Since a brute force scan means
> +# test failure, detect it and end the repair.
> +_xfs_repair_noscan()
> +{
> +	# invoke repair directly so we can kill the process if need be
> +	$XFS_REPAIR_PROG $SCRATCH_DEV 2>&1 | tee -a $seqres.full > $tmp.repair &
> +	repair_pid=$!
> +
> +	# monitor progress for as long as it is running
> +	while [ `ps -q $repair_pid > /dev/null; echo $?` == 0 ]; do

	while [ `pgrep xfs_repair` -eq 0 ]; do

> +		grep "couldn't verify primary superblock" $tmp.repair \
> +			> /dev/null 2>&1
> +		if [ $? == 0 ]; then
> +			# we've started a brute force scan. kill repair and
> +			# fail the test
> +			kill -9 $repair_pid >> $seqres.full 2>&1
> +			wait >> $seqres.full 2>&1
> +
> +			_fail "xfs_repair resorted to brute force scan"
> +		fi
> +
> +		sleep 1
> +	done
> +
> +	wait
> +
> +	cat $tmp.repair | _filter_repair
> +}
> +
> +rm -f $seqres.full
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/repair
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch_nocheck
> +
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> +
> +# corrupt the last secondary sb in the fs
> +agcount=`$XFS_DB_PROG -c "sb" -c "p agcount" $SCRATCH_DEV | awk '{ print $3 }'`

scratch_mkfs | _filter_mkfs 2> $tmp.mkfs
. $tmp.mkfs

And now you have the agcount variable already set up (and most other
fs geometry variables that mkfs outputs).

> +last_secondary=$((agcount - 1))
> +$XFS_DB_PROG -x -c "sb $last_secondary" -c "type data" \

you can just use  "sb $((agcount - 1))" directly. The comment above
tells us that it's the last secondary sb we are corrupting....

Otherwise look sok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
