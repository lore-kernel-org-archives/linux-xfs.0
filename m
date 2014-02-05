Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D2E907F54
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 17:15:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B317A304051
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 15:15:30 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	FKwm1ixqXcS5LA2P for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 15:15:28 -0800 (PST)
Date: Thu, 6 Feb 2014 10:15:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] btrfs/035: add new clone overwrite regression test
Message-ID: <20140205231526.GJ13997@dastard>
References: <1391599009-2402-1-git-send-email-ddiss@suse.de>
	<1391599009-2402-3-git-send-email-ddiss@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391599009-2402-3-git-send-email-ddiss@suse.de>
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
To: David Disseldorp <ddiss@suse.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Feb 05, 2014 at 12:16:49PM +0100, David Disseldorp wrote:
> This test uses the newly added cloner binary to dispatch full file and
> range specific clone (reflink) requests.

A couple of small nits:

> +CLONER_PROG=$here/src/cloner

Need to test that the binary was build and is present.

> +
> +src_str="aaaaaaaaaa"
> +
> +echo -n "$src_str" > $SCRATCH_MNT/src || _fail "failed to create src"

No need for the "|| _fail ..." in any part of this test. Failures
will be caught in the output and hence cause golden output
mismatches.

Letting the test run even after a failure exercises the filesystem
in interesting ways, so it's worthwhile ignoring failures in the
test and letting the harness pick up the failures through error
messages.

> +$CLONER_PROG $SCRATCH_MNT/src  $SCRATCH_MNT/src.clone1
> +
> +src_str="bbbbbbbbbbcccccccccc"
> +
> +echo -n "$src_str" > $SCRATCH_MNT/src || _fail "failed to create src"
> +
> +$CLONER_PROG $SCRATCH_MNT/src $SCRATCH_MNT/src.clone2
> +
> +snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone1 | awk '{print $5}'`
> +echo "attempting ioctl (src.clone1 src)"
> +$CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
> +	$SCRATCH_MNT/src.clone1 $SCRATCH_MNT/src || _fail "ioctl failed"

And to do that here, you probably need to add perror() output to
the cloner program when it detects an error. i.e. let it give you
the exact error that was detected, rather than lumping them all into
a catchall here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
