Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7LMeIJ076792 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 15:22:41 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 300F41488917
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 13:22:38 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tzMeZyMNP21Myb76 for <xfs@oss.sgi.com>;
	Mon, 07 Nov 2011 13:22:38 -0800 (PST)
Date: Tue, 8 Nov 2011 08:22:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/12] xfstests: add a new test that runs fsstress under
	ENOSPC conditions
Message-ID: <20111107212235.GH5534@dastard>
References: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
	<1320330301-2682-10-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320330301-2682-10-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, aelder@sgi.com, tytso@mit.edu, hch@lst.de, xfs@oss.sgi.com

On Thu, Nov 03, 2011 at 06:24:58PM +0400, Dmitry Monakhov wrote:
> During stress testing we want to cover as much code paths as possible
> fsstress is very good for this purpose. But it has expandable nature
> (disk usage almost continually grow). So once it goes in no ENOSPC
> condition it will be where till the end. But by running 'dd' writers
> in parallel we can regularly trigger ENOSPC but only for a limited
> periods of time because each time it opens the same file with O_TRUNC.

.....

So you have a 512MB filesystem, and you do:

> +# Disable all sync operations to get higher load
> +FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0"
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

run a bunch of fsstress processes

> +	pid=$!
> +	echo "Run dd writers in parallel"
> +	for ((i=0; i < num_iterations; i++))
> +	do
> +		# File will be opened with O_TRUNC each time
> +		dd if=/dev/zero of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M count=1 \
> +			> /dev/null 2>&1
> +		sleep $enospc_time
> +	done

Then write the same 1MB file 10 times, 2 seconds apart, giving a
total space usage of the dd processes of 1MB over 20s.

> +	kill $pid
> +	wait $pid
> +}

Then kill the fsstress.

AFAICT, fsstress won't always fill 511MB in 20s - on my test systems
the fill rate is typically around 5s per 100MB, which would result
in the filesystem not being filled with this test and hence not
exercising ENOSPC.  Perhaps this would be better done like test 083,
which uses a fixed number of write-only operations per fsstress
process that is known to end up at ENOSPC, rather than hoping it
gets there in 20s. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
