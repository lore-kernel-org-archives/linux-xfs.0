Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:12077 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750957AbdCRHTF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Mar 2017 03:19:05 -0400
Date: Sat, 18 Mar 2017 17:55:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH][PROGS] xfs_io: Allow setting multiple mode flags for
 fallocate()
Message-ID: <20170318065554.GX17542@dastard>
References: <c2fdfcbb1f4ac9a71633dfbe192ed1145b12b8ac.1489799604.git.calvinowens@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2fdfcbb1f4ac9a71633dfbe192ed1145b12b8ac.1489799604.git.calvinowens@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Calvin Owens <calvinowens@fb.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com

On Fri, Mar 17, 2017 at 06:26:09PM -0700, Calvin Owens wrote:
> This allows testing FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE.

Which is normally done through the "fpunch" command, which explains
why nobody has noticed this.

> Signed-off-by: Calvin Owens <calvinowens@fb.com>
> ---
>  io/prealloc.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/io/prealloc.c b/io/prealloc.c
> index a9d66cc..2a4bcdc 100644
> --- a/io/prealloc.c
> +++ b/io/prealloc.c
> @@ -201,19 +201,19 @@ fallocate_f(
>  	while ((c = getopt(argc, argv, "cikpu")) != EOF) {
>  		switch (c) {
>  		case 'c':
> -			mode = FALLOC_FL_COLLAPSE_RANGE;
> +			mode |= FALLOC_FL_COLLAPSE_RANGE;
>  			break;
>  		case 'i':
> -			mode = FALLOC_FL_INSERT_RANGE;
> +			mode |= FALLOC_FL_INSERT_RANGE;
>  			break;
>  		case 'k':
> -			mode = FALLOC_FL_KEEP_SIZE;
> +			mode |= FALLOC_FL_KEEP_SIZE;
>  			break;
>  		case 'p':
> -			mode = FALLOC_FL_PUNCH_HOLE;
> +			mode |= FALLOC_FL_PUNCH_HOLE;
>  			break;
>  		case 'u':
> -			mode = FALLOC_FL_UNSHARE_RANGE;
> +			mode |= FALLOC_FL_UNSHARE_RANGE;
>  			break;

NACK. We should not allow users to set invalid combinations
of commands such as 'falloc -cipu ...' - this would set the flags
(FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE |
FALLOC_FL_PUNCH_HOLE | FALLOC_FL_UNSHARE_RANGE) and will always
error out.

The use of FALLOC_FL_KEEP_SIZE for the FALLOC_FL_PUNCH_HOLE command
is essentially for documentation purposes - it does not do
truncation, hence the FALLOC_FL_KEEP_SIZE flag was added to it to
ensure developers understand that it does not truncate the file and
change EOF.

IOWs, the fix needed to make the 'falloc -p' command work is really
just this:

-			mode = FALLOC_FL_PUNCH_HOLE;
+			mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
