Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD4DF7CA1
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 00:29:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 62EFB8F8094
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2016 22:29:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Lz4u6NUmmhSraQLY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 14 Aug 2016 22:29:35 -0700 (PDT)
Date: Mon, 15 Aug 2016 13:29:33 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] tests/xfs: test log recovery metadata LSN ordering
Message-ID: <20160815052933.GE27776@eguan.usersys.redhat.com>
References: <1471004010-52985-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471004010-52985-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 12, 2016 at 08:13:30AM -0400, Brian Foster wrote:
> XFS had a bug that lead to a possible out-of-order log recovery
> situation (e.g., replay a stale modification from the log over more
> recent metadata in destination buffer). This resulted in false
> corruption reports during log recovery and thus mount failure.
> 
> This condition is caused by system crash or filesystem shutdown shortly
> after a successful log recovery. Add a test to run a combined workload,
> fs shutdown and log recovery loop known to reproduce the problem on
> affected kernels.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This test reproduces the problem described and addressed in the
> following patchset:
> 
>   http://oss.sgi.com/pipermail/xfs/2016-August/050840.html
> 
> It runs anywhere from 50-100s in the couple of environments I've tested
> on so far and reproduces the problem for me with 100% reliability. Note
> that the bug only affects crc=1 kernels.

Looks good overall, and tested with the above patchset applied and test
passed without problems. Some minor issues inline

> 
> Brian
> 
>  tests/xfs/999     | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |  2 ++
>  tests/xfs/group   |  1 +
>  3 files changed, 90 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 0000000..f9dd7f7
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,87 @@
> +#! /bin/bash
> +# FS QA Test No. 999
> +#
> +# Test XFS log recovery ordering on v5 superblock filesystems. XFS had a problem
> +# where it would incorrectly replay older modifications from the log over more
> +# recent versions of metadata due to failure to update metadata LSNs during log
> +# recovery. This could result in false positive reports of corruption during log
> +# recovery and permanent mount failure.
> +#
> +# To test this situation, run frequent shutdowns immediately after log recovery.
> +# Ensure that log recovery does not recover stale modifications and cause
> +# spurious corruption reports and/or mount failures.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Red Hat, Inc.  All Rights Reserved.
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
> +	cd /
> +	rm -f $tmp.*
> +	killall -9 fsstress > /dev/null 2>&1

We need a '_require_command "$KILLALL_PROGA" killall' and use
$KILLALL_PROG in the test.

> +	_scratch_unmount > /dev/null 2>&1
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# Modify as appropriate.
> +_supported_fs xfs

I'm wondering if this test can be made generic by adding a
"_require_scratch_shutdown"? Like generic/042 to generic/051

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
