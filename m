Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7DPgWX059962 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 07:25:42 -0600
Date: Mon, 7 Nov 2011 14:25:33 +0100
From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 6/9] xfstests: add a new test that runs fsstress under
	ENOSPC conditions
Message-ID: <20111107132533.GP12759@twin.jikos.cz>
References: <1320342953-7973-1-git-send-email-dmonakhov@openvz.org>
	<1320342953-7973-6-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320342953-7973-6-git-send-email-dmonakhov@openvz.org>
Reply-To: dave@jikos.cz
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu, hch@lst.de, aelder@sgi.com

Hi,

I saw this while running the newly added tests on btrfs:

On Thu, Nov 03, 2011 at 09:55:50PM +0400, Dmitry Monakhov wrote:
> --- /dev/null
> +++ b/269
> +_workout()
> +{
> +	echo ""
> +	echo "Run fsstress"
> +	echo ""
> +	num_iterations=10
> +	enospc_time=2
> +	out=$SCRATCH_MNT/fsstress.$$
> +	args="-p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
> +	echo "fsstress $args" >> $here/$seq.full
> +	$FSSTRESS_PROG $args > /dev/null 2>&1 &
> +	pid=$!
> +	echo "Run dd writers in parallel"
> +	for ((i=0; i < num_iterations; i++))
> +	do
> +		# File will be opened with O_TRUNC each time
> +		dd if=/dev/zero of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M count=1 \
> +			> /dev/null 2>&1
> +		sleep $enospc_time
> +	done
> +	kill $pid

269      [failed, exit status 1] - output mismatch (see 269.out.bad)
--- 269.out     2011-11-07 13:26:23.000000000 +0100
+++ 269.out.bad 2011-11-07 14:07:44.000000000 +0100
@@ -3,3 +3,4 @@
 Run fsstress

 Run dd writers in parallel
+./269: line 60: kill: (9754) - No such process

> +	wait $pid
> +}

and the test is reported to fail. Seems that the dd commands finish in less 2
seconds.


david

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
