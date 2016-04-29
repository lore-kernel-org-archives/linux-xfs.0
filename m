Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 080727CF3
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2016 20:59:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 60CEBAC003
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2016 18:59:33 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2fIpEZ2BsR2JEQa1 for <xfs@oss.sgi.com>;
	Thu, 28 Apr 2016 18:59:29 -0700 (PDT)
Date: Fri, 29 Apr 2016 11:59:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfstests: Add mkfs input validation tests
Message-ID: <20160429015927.GN18496@dastard>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461832149-18276-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461832149-18276-1-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Thu, Apr 28, 2016 at 10:29:09AM +0200, Jan Tulak wrote:
> Test inputs for my mkfs-cleaning patchset. This test will fail with the old sphageti code mkfs, among others because the old code accepts incorrect values.
> 
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Please don't strip the commit messages from patches you've picked up
from other people - it loses valuable information, as well as the
original author of the code. i.e. The original commit message was:


From: Dave Chinner <dchinner@redhat.com>

mkfs.xfs does not do a very good job of input validation. This test
is designed to exercise the input validation and test good/bad
combinations of options being set. It will not pass on a current
mkfs.xfs binary - it is designed to be the test case for a input
validation cleanup.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

> ---
> 
> Hi guys,
> 
> I'm sending this patch although the mentioned patchset is not yet merged.
> It might help you a bit with checking if there are any issues with
> the patchset, as here it is clear, what options works and what not.

in which case, a "_require_xfs_mkfs_validation" rule should be
written to determine the version of mkfs being. e.g. by testing one
of the failure cases that the unfixed binary says is ok.
....
> +# basic "should fail" options
> +# logarithm based options are no longer valid
> +# NOTE: umm, when it got invalid? It seems to be still supported...
> +#do_mkfs_fail -s log=10 $SCRATCH_DEV
> +#do_mkfs_fail -b log=10 $SCRATCH_DEV
> +#do_mkfs_fail -n log=10 $SCRATCH_DEV
> +#do_mkfs_fail -i log=10 $SCRATCH_DEV
> +#do_mkfs_fail -d sectlog=10 $SCRATCH_DEV
> +#do_mkfs_fail -l sectlog=10 $SCRATCH_DEV

They were expected to fail because I was going to remove the log
options from mkfs as part of the cleanup series because they are
redundant and nobody uses them. i.e this test was written with what
I wanted as the end result of the mkfs input validation cleanup, not
an iteration of the current behaviour.

After all the data section tests, the new tests you've added all
seem to be pretty ad-hoc.  What I was fleshing out in this test was
a relatively complete set exercising each the different options mkfs
supports.

I'd only iterated data section options so far in this test. I'd just
started on the naming section tests, and had not added any but a
basic test. That needs to be iterated, as do the inode, log (both
internal and external), metadata and realtime options....


> +# invalid file section tests
> +rm -f $fsimg
> +$XFS_IO_PROG -f -c "truncate $fssize" $fsimg
> +do_mkfs_fail -d file $fsimg
> +do_mkfs_fail -d file,name=$fsimg

Why should these fail - size should not be required if the image
file already exists and is of sufficient size....

> +
> +# naming section tests
> +do_mkfs_pass -n size=65536 $SCRATCH_DEV
> +
> +# boolean options
> +$XFS_IO_PROG -f -c "truncate $fssize" $fsimg
> +do_mkfs_pass -d file=1,size=$fssize $fsimg
> +do_mkfs_pass -d file=0 $SCRATCH_DEV
> +do_mkfs_fail -d file=1 $SCRATCH_DEV

More image file tests, belong in the data section with the other
image file tests.

> +# Specific flag combinations where some bug appeared during development,
> +# to catch the same issue if it re-appears. If there are multiple similar
> +# checks, move them to a standalone block.
> +
> +
> +do_mkfs_pass -m crc=1,finobt=1 $SCRATCH_DEV

What about all the other invalid cases?

> +do_mkfs_pass -m crc=1 -n ftype=1 $SCRATCH_DEV
> +do_mkfs_pass -m crc=0 -n ftype=1 $SCRATCH_DEV
> +do_mkfs_fail -m crc=1 -n ftype=0 $SCRATCH_DEV
> +do_mkfs_pass -m crc=0 -n ftype=0 $SCRATCH_DEV
> +do_mkfs_pass -n ftype=1 -m crc=0 $SCRATCH_DEV

One of the cleanup requirements was that option parsing would not
be order sensitive, so I don't think you need to iterate parameters
in different orders. That would just blow out the test matrix
unnecessarily. Also, if you really need to repeat the same test but
with different orders, please place those tests sequentially in the
file so it's clear that they are duplicate/order swapped tests....

> +# if user states crc=0,finobt=1, fail instead of warning
> +do_mkfs_fail -m crc=0,finobt=1 $SCRATCH_DEV

Why is this separate to the other crc,finobt test? Please try to
keep the parameter checks in logical groupings....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
