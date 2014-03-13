Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 126147F54
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 06:16:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 92A56AC002
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 04:16:34 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	kyBchUHm9Js3Dy2r for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 04:16:32 -0700 (PDT)
Date: Thu, 13 Mar 2014 22:16:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] generic: add a basic O_TMPFILE test
Message-ID: <20140313111630.GI4263@dastard>
References: <20140313101302.996355155@bombadil.infradead.org>
	<20140313101433.445012299@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140313101433.445012299@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Mar 13, 2014 at 03:13:04AM -0700, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/generic/004     |   70 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/004.out |    6 +++++
>  tests/generic/group   |    1 +
>  3 files changed, 77 insertions(+)
>  create mode 100755 tests/generic/004
>  create mode 100644 tests/generic/004.out
> 
> diff --git a/tests/generic/004 b/tests/generic/004
> new file mode 100755
> index 0000000..c653530
> --- /dev/null
> +++ b/tests/generic/004
> @@ -0,0 +1,70 @@
> +#! /bin/bash
> +# FS QA Test No. 004
> +#
> +# Test O_TMPFILE opens

it also tests linking a tmpfile...

> +testfile="${TEST_DIR}/tst-tmpfile-flink"
> +
> +# test creating a r/w tmpfile, do I/O and link it into the namespace
> +$XFS_IO_PROG -T \
> +	-c "pwrite 0 4096" \
> +	-c "pread 0 4096" \
> +	-c "flink ${testfile}" \
> +	${TEST_DIR} | _filter_xfs_io
> +
> +if [ ! -f "${testfile}" ]; then
> +    echo "failed to link testfile into place"
> +    exit 1
> +fi
> +
> +rm -f ${tmpfile}

You could just replace the  check for the $testfile existing and
then the removal with:

rm $testfile

because if it doesn't exist that will thrown an ENOENT error like:

rm: cannot remove "foo": No such file or directory

And that will fail the test. There's also no reason to exit if there
is an error, because the rest of the test does not depend on
$testfile being removed. The golden output comparison will then
cause the test to fail...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
