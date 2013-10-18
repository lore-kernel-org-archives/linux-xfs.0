Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 308297F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:53:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A13C2AC005
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 11:53:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8Hxdf0jGFeB3wuP4 for <xfs@oss.sgi.com>;
	Fri, 18 Oct 2013 11:53:55 -0700 (PDT)
Message-ID: <526183C2.4040503@sandeen.net>
Date: Fri, 18 Oct 2013 13:53:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfstests: xfsdump/restore test for partial_reg: Out
	of records. Extend attrs applied early
References: <20131011041911.238407600@sgi.com>
	<20131011042008.042241192@sgi.com>
In-Reply-To: <20131011042008.042241192@sgi.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On 10/10/13 11:19 PM, rjohnston@sgi.com wrote:
> Multi-stream xfsdump/xfsrestore of more than partialmax wholly-sparse
> files segfaults with the following warning:
> 
>   "partial_reg: Out of records. Extend attrs applied early."
> 
> Add a test that dumps and restores partialmax + 1 wholly-sparse files.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> 
> diff --git a/tests/xfs/351 b/tests/xfs/351
> new file mode 100755
> index 0000000..43b14c2
> --- /dev/null
> +++ b/tests/xfs/351
> @@ -0,0 +1,71 @@
> +#! /bin/bash
> +# FS QA Test No. 351
> +#
> +# Dump and restore partialmax + 1 wholly-sparse files
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
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dump
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +#dump_dir=/mnt/test/$dump_sdir

remove the commented-out line?

> +
> +rm -f $seqres.full
> +rm -rf $restore_dir/*

eek, who sets $restore_dir?  Oh, sourcing common/dump does.
But nothing mounts $SCRATCH_DEV yet, right?  So this seems
like a combination of incorrect, unnecessary & dangerous.
(_wipe_fs will re-mkfs anyway).  I'd just remove it.

> +rm -f $tmp.stream? 

$tmp is /tmp/<our pid>

so /tmp/<our pid>.stream *really* shouldn't exist, and cleanup
should have removed it from the last run (with a different pid).

But I suppose it doesn't hurt to be sure...

> +
> +echo "Silence is golden."
> +_wipe_fs

Ok, wipe_fs does mkfs & mount.  Could you add a comment?

> +mkdir $dump_dir 2>&1 >> $seqres.full || _fail "mkdir \"$dump_dir\" failed"

same deal w/ the order of the redirects.  More below too.

Otherwise looks ok.

-Eric

> +for i in `seq 1 4`; do
> +	$XFS_IO_PROG -f -c "truncate 1t" $dump_dir/sparsefile$i \
> +		2>&1 >> $seqres.full || _fail "failed to create sparsefile\"$i\""
> +done
> +# Dump and restore the files
> +_prepare_restore_dir
> +$XFSDUMP_PROG -L session -M label1 -M label2 -f $tmp.stream1 \
> +	-f $tmp.stream2 $SCRATCH_MNT -s $dump_sdir \
> +	2>&1 >> $seqres.full || _fail "dump failed"
> +$XFSRESTORE_PROG -F -f $tmp.stream1 -f $tmp.stream2 $restore_dir \
> +	2>&1 >> $seqres.full || _fail "restore failed"
> +status=0
> +exit 
> diff --git a/tests/xfs/351.out b/tests/xfs/351.out
> new file mode 100644
> index 0000000..42cf52e
> --- /dev/null
> +++ b/tests/xfs/351.out
> @@ -0,0 +1,2 @@
> +QA output created by 351
> +Silence is golden.
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 352a4c5..3e73f1d 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -179,3 +179,4 @@
>  297 auto freeze
>  298 auto attr symlink quick
>  299 auto quota
> +351 auto dump
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
