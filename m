Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D0C37F52
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 10:29:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E835E8F8033
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 08:29:00 -0700 (PDT)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id XOp8yikHp6z7bTod
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Sep 2013 08:28:59 -0700 (PDT)
Received: by mail-pa0-f43.google.com with SMTP id hz10so6959931pad.16
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 08:28:59 -0700 (PDT)
Date: Tue, 17 Sep 2013 23:28:52 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfstests: xfs directory unbalance assert test
Message-ID: <20130917152852.GA9550@dhcp-13-216.nay.redhat.com>
References: <20130917145946.124195107@sgi.com>
	<20130917145959.333796933@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130917145959.333796933@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 17, 2013 at 09:59:47AM -0500, Mark Tinguely wrote:
> This tests triggers an assert in the XFS directory unbalance code.
> This test originally written by Brian Foster and suggestions
> from Micheal Semon.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com> 
> ---
>  tests/generic/319     |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/319.out |    2 +
>  tests/generic/group   |    1 
>  3 files changed, 65 insertions(+)
> 
> Index: b/tests/generic/319
> ===================================================================
> --- /dev/null
> +++ b/tests/generic/319
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# FS QA Test No. 319
> +#
> +# Test directory code correctly handles fsstress filling the filesystem
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 SGI.  All Rights Reserved.
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
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +_require_scratch
> +
> +# real QA test starts here
> +
> +_supported_fs generic
> +_supported_os IRIX Linux
> +
> +_scratch_unmount > /dev/null 2>&1

This is not necessary, _require_scratch has done the unmount work.

> +_scratch_mkfs_sized 11g >> $seqres.full 2>&1

_scratch_mkfs_sized expects fssize in bytes, 11g is not a valid value
The comments in common/rc about _scratch_mkfs_sized say

# _scratch_mkfs_sized <size in bytes> [optional blocksize]

> +_scratch_mount > /dev/null 2>&1
> +
> +# Fill the filesystem.
> +FSSTRESS_ARGS="-z -s 1378390208 -fsymlink=1 -n7500000 -p4 -d $SCRATCH_MNT"
> +$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1
> +
> +cd $SCRATCH_MNT >> $seqres.full 2>&1
> +sync
> +# A debug XFS may assert in the remove due to a directory bug.
> +rm -rf *
> +echo "--- silence is golden ---"
> +status=0
> +exit
> Index: b/tests/generic/319.out
> ===================================================================
> --- /dev/null
> +++ b/tests/generic/319.out
> @@ -0,0 +1,2 @@
> +QA output created by 319
> +--- silence is golden ---
> Index: b/tests/generic/group
> ===================================================================
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -121,3 +121,4 @@
>  316 auto quick
>  317 auto metadata quick
>  318 acl attr auto quick
> +319 stress

Should be in auto group too I guess.

Thanks,
Eryu Guan
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
