Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A6277FA1
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 17:42:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B0F58F8037
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 15:42:24 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	S7EYFzpMHGYvChQo for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 15:42:18 -0800 (PST)
Date: Tue, 4 Feb 2014 10:42:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Btrfs: add regression test for running snapshot and send
	concurrently
Message-ID: <20140203234212.GW13997@dastard>
References: <1391440956-31924-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391440956-31924-1-git-send-email-wangshilong1991@gmail.com>
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
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 03, 2014 at 11:22:36PM +0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> 
> Btrfs would fail to send if snapshot run concurrently, this test is to make
> sure we have fixed the bug.
> 
Couple of comments below.

> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +
> +touch $SCRATCH_MNT/foo
> +
> +# get file with fragments by using backwards writes.
> +for i in `seq 10240 -1 1`; do
> +	$XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
> +	$SCRATCH_MNT/foo > /dev/null | _filter_xfs_io

Indentation.

> +done
> +
> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1
> +
> +$BTRFS_UTIL_PROG send -f $SCRATCH_MNT/send_file \
> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1 &
> +
> +pid=$!
> +
> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT/snap_1 \
> +	$SCRATCH_MNT/snap_2 >> $seqres.full 2>&1
> +
> +wait $pid || echo "Failed to send, see dmesg"

This seems kind of racy. It assumes that the send command
doesn't complete before the wait $pid call is made. If $pid doesn't
exist at this time because it has completed, wait will return 127
and the test will fail....

Also, why would a failure to send result in meaingful information in
dmesg? Shouldn't the userspace command output information to tell
you why there was a failure into $seqres.full?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
