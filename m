Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAI5TNtG126682 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 23:29:24 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74EB613D0F29
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 21:30:55 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	CCGSzzsD3SJJDjUD for <xfs@oss.sgi.com>;
	Wed, 17 Nov 2010 21:30:55 -0800 (PST)
Date: Thu, 18 Nov 2010 16:30:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add test for fallocate with hole punching
Message-ID: <20101118053052.GT13830@dastard>
References: <1289598949-19216-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289598949-19216-1-git-send-email-josef@redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 12, 2010 at 04:55:49PM -0500, Josef Bacik wrote:
> This test is based on 242, just modified to use fiemap, fallocate and fallocate
> -p.  I've looked at all of the output by hand and verified that it's working
> properly.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  245       |  189 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  245.out   |   47 +++++++++++++++
>  common.rc |   27 +++++++++
>  group     |    1 +
>  4 files changed, 264 insertions(+), 0 deletions(-)
>  create mode 100755 245
>  create mode 100644 245.out
> 
> diff --git a/245 b/245
> new file mode 100755
> index 0000000..6f7a502
> --- /dev/null
> +++ b/245
> @@ -0,0 +1,189 @@
> +#! /bin/bash
> +# FS QA Test No. 242

Not test 242 anymore...

> +#
> +# Test XFS_IOC_ZERO_RANGE

Nor that. ;)

> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2010 Red Hat.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=dchinner@redhat.com

Not me ;)

> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +    rm -f $tmp.*
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +
> +_require_xfs_io_falloc_punch
> +_require_xfs_io_fiemap
> +
> +_filter_bmap()
> +{
> +    awk --posix '$3 ~ /hole/ { print $1, $2, $3; next }
> +		 $5 ~ /0x[[:digit:]]*8[[:digit:]]{2}/ { print $1, $2, "unwritten"; next }
> +		 $5 ~ /0x[[:digit:]]+/ {print $1, $2, "data" }'
> +}
> +
> +# test the different corner cases for falloc -ping a range:

                                         punching

> +#
> +#	1. into a hole
> +#	2. into allocated space
> +#	3. into unwritten space
> +#	4. hole -> data
> +#	5. hole -> unwritten
> +#	6. data -> hole
> +#	7. data -> unwritten
> +#	8. unwritten -> hole
> +#	9. unwritten -> data
> +#	10. hole -> data -> hole
> +#	11. data -> hole -> data
> +#	12. unwritten -> data -> unwritten
> +#	13. data -> unwritten -> data
> +
> +testfile=$TEST_DIR/242.$$
                      ^^^

> +
> +echo "	1. into a hole"
> +rm -f $testfile
> +$XFS_IO_PROG -F -f -c "truncate 20k" \
> +	-c "falloc -p 4k 8k" \
> +	-c "fiemap -v" $testfile | _filter_bmap
> +[ $? -ne 0 ] && die_now

This looks almost almost exactly the same test as 242 just with the
alloc, map and punch commands changed.  I'd suggest making all these
cases into a function that takes three parameters - alloc_cmd
punch_cmd and map_cmd - and pulling it into common.punch.

e.g. we end up with a function full of commands like:

$XFS_IO_PROG -F -f -c "truncate 20k" \
	-c "$punch_cmd 4k 8k" \
	-c "$map_cmd" $testfile | _filter_bmap

Which means it can be used for 242, this test, and another test for
the xfs resvsp/unresvsp ioctls...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
