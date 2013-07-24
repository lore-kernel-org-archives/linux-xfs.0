Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A5E4A7CBF
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 18:29:52 -0500 (CDT)
Date: Wed, 24 Jul 2013 18:29:49 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] Xfstests/btrfs/308: add snapshot-aware defrag for
	partial extents testcases
Message-ID: <20130724232949.GX3111@sgi.com>
References: <1372844780-31845-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372844780-31845-1-git-send-email-bo.li.liu@oracle.com>
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
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jul 03, 2013 at 05:46:20PM +0800, Liu Bo wrote:
> This is to test whether snapshot-aware defrag can work well on partial extents.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  tests/btrfs/308     |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/308.out |    2 +
>  tests/btrfs/group   |    1 +
>  3 files changed, 96 insertions(+), 0 deletions(-)
>  create mode 100755 tests/btrfs/308
>  create mode 100644 tests/btrfs/308.out
> 
> diff --git a/tests/btrfs/308 b/tests/btrfs/308
> new file mode 100755
> index 0000000..b3dd39c
> --- /dev/null
> +++ b/tests/btrfs/308
> @@ -0,0 +1,93 @@
> +#! /bin/bash
> +# BTRFS QA Test No. 308
> +#
> +# Test if snapshot-aware defrag can work well on partial extents, ie.
> +# extent_offset is not zero.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Oracle.  All Rights Reserved.
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
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic

_supported_fs btrfs

Since this is btrfs specific, I think _supported_fs should be btrfs.

I didn't see anything obviously wrong with the rest of this, but I'd rather see
a review from a btrfs expert.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
