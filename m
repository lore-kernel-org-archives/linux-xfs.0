Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A145F7F51
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 16:43:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7824F8F8050
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 14:43:47 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	zCN6MVDo6qpCiJNZ for <xfs@oss.sgi.com>;
	Thu, 06 Feb 2014 14:43:42 -0800 (PST)
Date: Fri, 7 Feb 2014 09:43:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] Btrfs: add regression test for running snapshot and
	send concurrently
Message-ID: <20140206224337.GB13647@dastard>
References: <1391703008-2322-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391703008-2322-1-git-send-email-wangshilong1991@gmail.com>
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

On Fri, Feb 07, 2014 at 12:10:08AM +0800, Wang Shilong wrote:
> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1
> +
> +do_snapshots &
> +snapshots_pid=$!
> +
> +$BTRFS_UTIL_PROG send $SCRATCH_MNT/snap_1 > /dev/null 2>&1 || echo "btrfs send failed"

Let's stop this anti-pattern before it takes hold.

If there's output from the send command it should be
filtered and captured in the golden image. Hence any deviation
caused by errors is automatically flagged as an error.

That's the whole point of using golden images for capturing errors -
you don't need to capture return values from binaries and it
guarantees that users are informed about failures through error
messages. IOWs:

$BTRFS_UTIL_PROG send $SCRATCH_MNT/snap_1 | _btrfs_send_filter

is what you should be doing here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
