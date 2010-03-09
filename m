Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o29Hv5X8160777 for <xfs@oss.sgi.com>; Tue, 9 Mar 2010 11:57:05 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E35C228D7D
	for <xfs@oss.sgi.com>; Tue,  9 Mar 2010 09:58:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RN8qckHXbd6wfdxH for
	<xfs@oss.sgi.com>; Tue, 09 Mar 2010 09:58:36 -0800 (PST)
Message-ID: <4B968C3E.9000402@sandeen.net>
Date: Tue, 09 Mar 2010 11:58:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix log filtering in 223's testcase
References: <876355pfrh.fsf@openvz.org>
In-Reply-To: <876355pfrh.fsf@openvz.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Dmitry Monakhov wrote:
> Msg filter was missed in one place, so test failed if
> $SCRATCH_MNT is different than /mnt/scratch.diff 
> 
> Signed-off-by: Dimitry Monakhov <dmonakhov@openvz.org>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Whoops, yep!  Sorry.

I'll commit this shortly.

Thanks,
-Eric

> ---
>  223     |    3 ++-
>  223.out |   10 +++++-----
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/223 b/223
> index 5c95f7d..7af026c 100755
> --- a/223
> +++ b/223
> @@ -86,7 +86,8 @@ for SUNIT_K in 8 16 32 64 128; do
>  
>  	echo "=== Testing size 1g falloc on ${SUNIT_K}k stripe ==="
>  	xfs_io -F -f -c "falloc 0 1g" $SCRATCH_MNT/file-1g-falloc &>> $seq.full
> -	src/t_stripealign $SCRATCH_MNT/file-1g-falloc $SUNIT_BLOCKS
> +	src/t_stripealign $SCRATCH_MNT/file-1g-falloc $SUNIT_BLOCKS \
> +	    | _filter_scratch
>  
>  	rm -f $SCRATCH_MNT/file-1g-falloc | _filter_scratch
>  
> diff --git a/223.out b/223.out
> index c9588ef..2fb3122 100644
> --- a/223.out
> +++ b/223.out
> @@ -46,7 +46,7 @@ SCRATCH_MNT/file-3-2097152-write: well-aligned
>  SCRATCH_MNT/file-4-2097152-falloc: well-aligned
>  SCRATCH_MNT/file-4-2097152-write: well-aligned
>  === Testing size 1g falloc on 8k stripe ===
> -/mnt/scratch/file-1g-falloc: well-aligned
> +SCRATCH_MNT/file-1g-falloc: well-aligned
>  === Testing size 1073745920 falloc on 8k stripe ===
>  SCRATCH_MNT/file-1073745920-falloc: well-aligned
>  === mkfs with su 4 blocks x 4 ===
> @@ -96,7 +96,7 @@ SCRATCH_MNT/file-3-4194304-write: well-aligned
>  SCRATCH_MNT/file-4-4194304-falloc: well-aligned
>  SCRATCH_MNT/file-4-4194304-write: well-aligned
>  === Testing size 1g falloc on 16k stripe ===
> -/mnt/scratch/file-1g-falloc: well-aligned
> +SCRATCH_MNT/file-1g-falloc: well-aligned
>  === Testing size 1073745920 falloc on 16k stripe ===
>  SCRATCH_MNT/file-1073745920-falloc: well-aligned
>  === mkfs with su 8 blocks x 4 ===
> @@ -146,7 +146,7 @@ SCRATCH_MNT/file-3-8388608-write: well-aligned
>  SCRATCH_MNT/file-4-8388608-falloc: well-aligned
>  SCRATCH_MNT/file-4-8388608-write: well-aligned
>  === Testing size 1g falloc on 32k stripe ===
> -/mnt/scratch/file-1g-falloc: well-aligned
> +SCRATCH_MNT/file-1g-falloc: well-aligned
>  === Testing size 1073745920 falloc on 32k stripe ===
>  SCRATCH_MNT/file-1073745920-falloc: well-aligned
>  === mkfs with su 16 blocks x 4 ===
> @@ -196,7 +196,7 @@ SCRATCH_MNT/file-3-16777216-write: well-aligned
>  SCRATCH_MNT/file-4-16777216-falloc: well-aligned
>  SCRATCH_MNT/file-4-16777216-write: well-aligned
>  === Testing size 1g falloc on 64k stripe ===
> -/mnt/scratch/file-1g-falloc: well-aligned
> +SCRATCH_MNT/file-1g-falloc: well-aligned
>  === Testing size 1073745920 falloc on 64k stripe ===
>  SCRATCH_MNT/file-1073745920-falloc: well-aligned
>  === mkfs with su 32 blocks x 4 ===
> @@ -246,6 +246,6 @@ SCRATCH_MNT/file-3-33554432-write: well-aligned
>  SCRATCH_MNT/file-4-33554432-falloc: well-aligned
>  SCRATCH_MNT/file-4-33554432-write: well-aligned
>  === Testing size 1g falloc on 128k stripe ===
> -/mnt/scratch/file-1g-falloc: well-aligned
> +SCRATCH_MNT/file-1g-falloc: well-aligned
>  === Testing size 1073745920 falloc on 128k stripe ===
>  SCRATCH_MNT/file-1073745920-falloc: well-aligned

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
