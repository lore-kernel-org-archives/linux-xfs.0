Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37428 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753282AbdKNOgm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Nov 2017 09:36:42 -0500
Subject: Re: [PATCH v3 2/2] xfs: initial fiemap range query test
References: <1510588073-5665-1-git-send-email-nborisov@suse.com>
 <1510588229-6079-1-git-send-email-nborisov@suse.com>
 <1510588229-6079-2-git-send-email-nborisov@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5b67930f-a734-84c7-b71d-820fa8873a64@sandeen.net>
Date: Tue, 14 Nov 2017 08:36:40 -0600
MIME-Version: 1.0
In-Reply-To: <1510588229-6079-2-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>, linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, eguan@redhat.com, david@fromorbit.com, darrick.wong@oracle.com



On 11/13/17 9:50 AM, Nikolay Borisov wrote:
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> V3: 
>  * Added tests for -r parameter error handling
>  tests/xfs/900     |  98 ++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/900.out | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 222 insertions(+)
>  create mode 100755 tests/xfs/900
>  create mode 100644 tests/xfs/900.out
> 
> diff --git a/tests/xfs/900 b/tests/xfs/900
> new file mode 100755
> index 0000000..570f7d6
> --- /dev/null
> +++ b/tests/xfs/900
> @@ -0,0 +1,98 @@
> +#! /bin/bash
> +# FS QA Test No. 900
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 SUSE Linux Products GmbH. All Rights Reserved.
> +# Author: Nikolay Borisov <nborisov@suse.com>
> +#
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
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/punch
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic

This says generic but you have it under xfs/ tests, is that intentional?

> +_supported_os Linux
> +_require_scratch
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_command "fiemap" "-r 0 4k"


> +
> +_scratch_mkfs > $seqres.full 2>&1

Do you need to explicitly mkfs w/ a 4k block size so all the
below tests on 4k boundaries will pass?

(IOWs does this work on 2k or 8k fs block size?)

-Eric
