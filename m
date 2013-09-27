Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7295F7F53
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 10:52:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1941FAC002
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 08:52:40 -0700 (PDT)
Received: from mo-p00-ob.rzone.de (mo-p00-ob.rzone.de [81.169.146.160]) by
	cuda.sgi.com with ESMTP id AC6WmNbxaGO60FFX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 08:52:39 -0700 (PDT)
Message-ID: <5245A9C2.7030404@giantdisaster.de>
Date: Fri, 27 Sep 2013 17:52:34 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/014: add a regression test for snapshot
	creation
References: <1380290137-5484-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1380290137-5484-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

On Fri, 27 Sep 2013 09:55:37 -0400, Josef Bacik wrote:
> We had a regression where you couldn't snapshot a file system if you mounted it
> ro and then remounted it rw.  This is a test that does just that to make sure we
> don't have this problem again.  I ran the test without the fix and it blew up,
> and then applied the fix and verified that it passed.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  tests/btrfs/014     | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/014.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 64 insertions(+)
>  create mode 100644 tests/btrfs/014
>  create mode 100644 tests/btrfs/014.out
> 
> diff --git a/tests/btrfs/014 b/tests/btrfs/014
> new file mode 100644
> index 0000000..8302f5f
> --- /dev/null
> +++ b/tests/btrfs/014
> @@ -0,0 +1,61 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/014
> +#
> +# Regression test to make sure we can create a snapshot after mounting with
> +# readonly and remounting rw.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Fusion IO.  All Rights Reserved.
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
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +	rm -f $tmp.*
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount -o ro
> +_scratch_mount -o rw,remount
> +
> +$BTRFS_UTIL_PROG sub snap $SCRATCH_MNT $SCRATCH_MNT/snap >> $seqres.full 2>&1 \
> +	|| _fail "couldn't create snapshot"
> +
> +echo "Silence is golden"
> +status=0 ; exit
> diff --git a/tests/btrfs/014.out b/tests/btrfs/014.out
> new file mode 100644
> index 0000000..db5250b
> --- /dev/null
> +++ b/tests/btrfs/014.out
> @@ -0,0 +1,2 @@
> +QA output created by 014
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 8a168d5..3a5747f 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -16,3 +16,4 @@
>  011 auto
>  012 auto quick
>  013 auto quick
> +014 auto quick
> 

Nothing to complain about.

Reviewed-by: Stefan Behrens <sbehrens@giantdisaster.de>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
