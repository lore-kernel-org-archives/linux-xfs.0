Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 467A57F91
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 17:10:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C97F0AC002
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 15:10:47 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WMU3xuokkZB2yJX4 for <xfs@oss.sgi.com>;
	Wed, 22 Jan 2014 15:10:46 -0800 (PST)
Date: Thu, 23 Jan 2014 10:08:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/291: fix spurious ENOSPC errors
Message-ID: <20140122230819.GE27606@dastard>
References: <1390373205-8698-1-git-send-email-david@fromorbit.com>
	<52E03DB0.4060503@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E03DB0.4060503@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Jan 22, 2014 at 03:52:48PM -0600, Eric Sandeen wrote:
> On 1/22/14, 12:46 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs/291 tries to fill the filesystem almost full, so if the log size
> > changes with mkfs defaults then it's free space calculations are not
> > longer valid and so it throws lots of ENOSPC errors during a run.
> > This is not fatal for this test, but it does increase the runtime of
> > it and fill the 291.full file with unnecessary errors.
> 
> Hm so you've set the log size to 5m (-l size=5m) but how does that
> interact with any "-l size=XXX" set in MKFS_OPTS ? 

see _scratch_mkfs_xfs:

        # a mkfs failure may be caused by conflicts between
        # $MKFS_OPTIONS and $extra_mkfs_options
        if [ $mkfs_status -ne 0 -a ! -z "$extra_mkfs_options" ]; then
                (
                echo -n "** mkfs failed with extra mkfs options "
                echo "added to \"$MKFS_OPTIONS\" by test $seq **"
                echo -n "** attempting to mkfs using only test $seq "
                echo "options: $extra_mkfs_options **"
                ) >> $seqres.full

                # running mkfs again. overwrite previous mkfs output files
                _scratch_mkfs_xfs_opts $extra_mkfs_options \
                        2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
                local mkfs_status=$?
        fi

So, it will drop the MKFS_OPTIONS and just use the test specific
options if there is a conflict/failure.

> (It's certainly no worse than what I had in my original test; I just
> wonder if we should ignore MKFS_OPTS altogether in this test, and
> completely manually specify all options?)

That's effectively what it already does automatically.... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
