Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:50240 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751036AbdILGqf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2017 02:46:35 -0400
Date: Tue, 12 Sep 2017 16:44:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Message-ID: <20170912064411.GR10621@dastard>
References: <20170908152805.GA16646@linux.intel.com>
 <20170908212153.14880-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908212153.14880-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Sep 08, 2017 at 03:21:53PM -0600, Ross Zwisler wrote:
> This adds a regression test for the following kernel patch:
> 
>   xfs: always use DAX if mount option is used
> 
> This test will also pass with kernel v4.14-rc1 and beyond because the XFS
> DAX I/O mount option has been disabled (but not removed), so the
> "chattr -x" to turn off DAX doesn't actually do anything.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
.....
> +pgsize=`$here/src/feature -s`
> +
> +# disable tracing, clear the existing trace buffer and turn on dax tracepoints
> +echo 0 > /sys/kernel/debug/tracing/tracing_on
> +echo > /sys/kernel/debug/tracing/trace
> +echo 1 > /sys/kernel/debug/tracing/events/fs_dax/enable
> +
> +# enable tracing for our one mmap I/O, then see if dax was used
> +echo 1 > /sys/kernel/debug/tracing/tracing_on
> +xfs_io  -t -c "truncate $pgsize" \
> +	-c "chattr -x" \
> +	-c "mmap -r 0 $pgsize" -c "mread 0 $pgsize" -c "munmap" \
> +	-f $SCRATCH_MNT/testfile >> $seqres.full
> +echo 0 > /sys/kernel/debug/tracing/tracing_on

So what happens when the user is already tracing the test to
find a bug and the test turns all their tracing off?

Regardless of this screwing up developer bug triage, do we really
want to add a dependency on kernel tracing into the test harness?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
