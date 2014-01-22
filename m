Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DBEB47F96
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 15:52:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72B7FAC002
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 13:52:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id w5nPpyHFGrVab6cp for <xfs@oss.sgi.com>;
	Wed, 22 Jan 2014 13:52:48 -0800 (PST)
Message-ID: <52E03DB0.4060503@sandeen.net>
Date: Wed, 22 Jan 2014 15:52:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs/291: fix spurious ENOSPC errors
References: <1390373205-8698-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1390373205-8698-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 1/22/14, 12:46 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs/291 tries to fill the filesystem almost full, so if the log size
> changes with mkfs defaults then it's free space calculations are not
> longer valid and so it throws lots of ENOSPC errors during a run.
> This is not fatal for this test, but it does increase the runtime of
> it and fill the 291.full file with unnecessary errors.

Hm so you've set the log size to 5m (-l size=5m) but how does that
interact with any "-l size=XXX" set in MKFS_OPTS ? 

(It's certainly no worse than what I had in my original test; I just
wonder if we should ignore MKFS_OPTS altogether in this test, and
completely manually specify all options?)

((but I guess that would restrict this test too much, wouldn't it))

Fine for now, I suppose:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

-Eric

> The number of frag files it creates is also too many for a 512 byte
> inode filesystem (by about 900) so reduce the number of inodes
> initially created so the test works ofr 512 byte inodes. With 512
> byte inodes, the free space histogram looks like this after the frag
> phase:
> 
>    from      to extents  blocks    pct
>       1       1   10730   10730 100.00
> 
> And for 256 byte inodes:
> 
>    from      to extents  blocks    pct
>       1       1   12388   12388 100.00
> 
> So these changes do not affect the intended operation of the test.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  tests/xfs/291 | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/291 b/tests/xfs/291
> index d5a9b08..0f3f051 100755
> --- a/tests/xfs/291
> +++ b/tests/xfs/291
> @@ -46,7 +46,7 @@ _supported_os IRIX Linux
>  # real QA test starts here
>  rm -f $seqres.full
>  _require_scratch
> -_scratch_mkfs_xfs -n size=16k -d size=128m >> $seqres.full 2>&1
> +_scratch_mkfs_xfs -n size=16k -l size=5m -d size=128m >> $seqres.full 2>&1
>  _scratch_mount
>  
>  # First we cause very badly fragmented freespace, then
> @@ -54,13 +54,16 @@ _scratch_mount
>  # should come out very fragmented as a result
>  
>  # Step 1: Cause badly fragmented free space
> +# 
> +# XXX: this needs to be factored to match what generic/204 does to support
> +# different inode sizes without ENOSPC
>  mkdir $SCRATCH_MNT/fragdir
> -for I in `seq 0 27200`; do
> +for I in `seq 0 26200`; do
>          (echo data > $SCRATCH_MNT/fragdir/f$I) >> $seqres.full 2>&1
>  done
>  sync
>  
> -for I in `seq 0 2 27200`; do
> +for I in `seq 0 2 26200`; do
>          rm -f $SCRATCH_MNT/fragdir/f$I >> $seqres.full 2>&1
>  done
>  sync
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
