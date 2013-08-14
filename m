Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 85A5B7F74
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 15:23:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 76D37304051
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 13:23:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fCpyeO67HsIA3QY7 for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 13:23:44 -0700 (PDT)
Message-ID: <520BE74E.4000607@sandeen.net>
Date: Wed, 14 Aug 2013 15:23:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/003: regression test for subvol delete V3
References: <1376510872-9951-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1376510872-9951-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 8/14/13 3:07 PM, Josef Bacik wrote:
> We were allowing users to delete their default subvolume, which is problematic.
> This test is a regression test to make sure we don't let that happen in the
> future.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V2->V3: remove comment and abstract out the subvolid logic as per Eric's
>   suggestions
> V1->V2: address the comments made by Eric Sandeen.

Thank you, sir.  :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> 
>  common/rc           |    8 ++++++
>  tests/btrfs/003     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/003.out |    2 +
>  tests/btrfs/group   |    1 +
>  4 files changed, 74 insertions(+), 0 deletions(-)
>  create mode 100755 tests/btrfs/003
>  create mode 100644 tests/btrfs/003.out
> 
> diff --git a/common/rc b/common/rc
> index 4de1329..9f4ea58 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -57,6 +57,14 @@ dd()
>     fi
>  }
>  
> +_btrfs_get_subvolid()
> +{
> +	mnt=$1
> +	name=$2
> +
> +	$BTRFS_UTIL_PROG sub list $mnt | grep $name | awk '{ print $2 }'
> +}
> +
>  # Prints the md5 checksum of a given file
>  _md5_checksum()
>  {
> diff --git a/tests/btrfs/003 b/tests/btrfs/003
> new file mode 100755
> index 0000000..5cd89e9
> --- /dev/null
> +++ b/tests/btrfs/003
> @@ -0,0 +1,63 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/003
> +#
> +# Regression test to make sure we can't delete the default subvol
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
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +$BTRFS_UTIL_PROG sub create $SCRATCH_MNT/newvol >> $seqres.full 2>&1 \
> +	|| _fail "couldn't create subvol"
> +subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT newvol)
> +$BTRFS_UTIL_PROG sub set-default $subvolid $SCRATCH_MNT >> $seqres.full 2>&1 \
> +	|| _fail "couldn't set default"
> +$BTRFS_UTIL_PROG sub delete $SCRATCH_MNT/newvol >> $seqres.full 2>&1
> +_scratch_unmount
> +_scratch_mount || _fail "mount should have succeeded"
> +
> +echo "Silence is golden"
> +status=0 ; exit
> diff --git a/tests/btrfs/003.out b/tests/btrfs/003.out
> new file mode 100644
> index 0000000..6895fc8
> --- /dev/null
> +++ b/tests/btrfs/003.out
> @@ -0,0 +1,2 @@
> +QA output created by 003
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 5b65068..86f5a5a 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -5,6 +5,7 @@
>  #
>  001 auto quick
>  002 auto quick
> +003 auto quick
>  254 auto quick
>  264 auto
>  265 auto
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
