Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 52A8E29DF8
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 02:07:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 322A9304051
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 00:07:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LFrabjeHBt7eMt5C for
	<xfs@oss.sgi.com>; Fri, 10 May 2013 00:07:54 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4A77rmn029770
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 03:07:54 -0400
Received: from localhost (dhcp12-135.nay.redhat.com [10.66.12.135] (may be
	forged))
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r4A77oIp016107
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 03:07:52 -0400
Date: Fri, 10 May 2013 15:07:49 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3] xfstests generic 312: test fallocate(2) ENOSPC when
	file size is greater than 4G
Message-ID: <20130510070749.GC2460@eguan-t400.nay.redhat.com>
References: <1367833355-14473-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1367833355-14473-1-git-send-email-eguan@redhat.com>
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
To: xfs@oss.sgi.com

On Mon, May 06, 2013 at 05:42:35PM +0800, Eryu Guan wrote:
> ENOSPC in fallocate(2) could corrupt ext4 when file size > 4G
> 
> Regression test for commit
> 29ae07b ext4: Fix overflow caused by missing cast in ext4_fallocate()
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> v3: rebase on top of master
> v2: Check for $SCRATCH_DEV size, _notrun if it's smaller than 5G

Any comments on this test case?

Thanks!

Eryu Guan
> 
>  tests/generic/312     | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/312.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 75 insertions(+)
>  create mode 100644 tests/generic/312
>  create mode 100644 tests/generic/312.out
> 
> diff --git a/tests/generic/312 b/tests/generic/312
> new file mode 100644
> index 0000000..eaec43c
> --- /dev/null
> +++ b/tests/generic/312
> @@ -0,0 +1,72 @@
> +#! /bin/bash
> +# FS QA Test No. 312
> +#
> +# ENOSPC in fallocate(2) could corrupt ext4 when file size > 4G
> +#
> +# Regression test for commit
> +# 29ae07b ext4: Fix overflow caused by missing cast in ext4_fallocate()
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
> +_supported_fs generic
> +_supported_os Linux
> +_require_xfs_io_falloc
> +_require_scratch
> +
> +# 5G in byte
> +fssize=$((2**30 * 5))
> +required_blocks=$(($fssize / 1024))
> +dev_blocks=$(grep $(basename $(readlink -f $SCRATCH_DEV)) /proc/partitions | $AWK_PROG '{print $3}')
> +if [ $required_blocks -gt $dev_blocks ];then
> +	_notrun "this test requires \$SCRATCH_DEV has ${fssize}B space"
> +fi
> +
> +rm -f $seqres.full
> +_scratch_mkfs_sized $fssize >>$seqres.full 2>&1
> +_scratch_mount >>$seqres.full 2>&1
> +
> +echo "Silence is golden"
> +
> +# fallocate(2) a 6G(> 4G) file on a 5G fs
> +$XFS_IO_PROG -f -c "falloc 0 6g" $SCRATCH_MNT/testfile.$seq >>$seqres.full 2>&1
> +
> +_scratch_unmount
> +_check_scratch_fs
> +status=0
> +exit
> diff --git a/tests/generic/312.out b/tests/generic/312.out
> new file mode 100644
> index 0000000..6e72aa9
> --- /dev/null
> +++ b/tests/generic/312.out
> @@ -0,0 +1,2 @@
> +QA output created by 312
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index eb52833..cb15afe 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -114,3 +114,4 @@
>  309 auto quick
>  310 auto
>  311 auto metadata log
> +312 auto quick prealloc enospc
> -- 
> 1.8.2.1
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
