Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 694E07F56
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 14:37:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2777D304059
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 12:37:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IX9fTMZ9GFWVM9fR for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 12:37:26 -0700 (PDT)
Message-ID: <5238AF75.2020905@sandeen.net>
Date: Tue, 17 Sep 2013 14:37:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: v2 xfs directory unbalance assert test
References: <20130917192538.230164044@sgi.com>
In-Reply-To: <20130917192538.230164044@sgi.com>
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

On 9/17/13 2:25 PM, Mark Tinguely wrote:
> This tests triggers an assert in the XFS directory unbalance code.
> This test originally written by Brian Foster and suggestions
> from Micheal Semon.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com> 
> ---
> v1->v2:
>  remove clean up.
>  remove $seqres.full before test.
>  remove scratch mount.
>  11g -> calculate 11g bytes.
>  check for failing mkfs and mount.
>  add a safer removal of the scratch files.
> 
>  put into auto group and "long" group so people can opt out:
>   this test almost an hour on my test box.

Is there any way to do a more targeted test than 1hr of fsstress?  :(

(TBH I didn't follow the bug, so not sure what it takes to repro)

Otherwise seems fine.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  tests/generic/319     |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/319.out |    2 +
>  tests/generic/group   |    1 
>  3 files changed, 59 insertions(+)
> 
> Index: b/tests/generic/319
> ===================================================================
> --- /dev/null
> +++ b/tests/generic/319
> @@ -0,0 +1,56 @@
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
> +rm -f $seqres.full
> +_scratch_mkfs_sized $((11 * 1024 * 1024 * 1024)) >> $seqres.full 2>&1 \
> +	|| _fail "mkfs failed"
> +run_check _scratch_mount >> $seqres.full
> +
> +# Fill the filesystem.
> +FSSTRESS_ARGS="-z -s 1378390208 -fsymlink=1 -n7500000 -p4 -d $SCRATCH_MNT"
> +$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1
> +
> +# A debug XFS may assert in the remove due to a directory bug.
> +rm -rf $SCRATCH_MNT/p?
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
> +319 auto stress long
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
