Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41244 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725744AbeKYFMg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Nov 2018 00:12:36 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 05/12] fsx: use an enum to define the operation commands
References: <154290950237.1218.9937108728673485814.stgit@magnolia>
 <154290953980.1218.7605730679708903723.stgit@magnolia>
Message-ID: <2e0fba51-4fdf-4f17-1373-d305f7a01c4e@oracle.com>
Date: Sat, 24 Nov 2018 11:23:27 -0700
MIME-Version: 1.0
In-Reply-To: <154290953980.1218.7605730679708903723.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Looks ok to me

Reviewed-By: Allison Henderson <allison.henderson@oracle.com>

On 11/22/18 10:58 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use an enum to define operation codes and the boundaries between
> operation classes so that we can add new commands without having to
> change a bunch of unrelated #defines.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   ltp/fsx.c |   40 +++++++++++++++++++++-------------------
>   1 file changed, 21 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 7fb8b3ab..dabad302 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -88,25 +88,27 @@ int			logcount = 0;	/* total ops */
>    * mode being run.
>    */
>   
> -/* common operations */
> -#define	OP_READ		0
> -#define OP_WRITE	1
> -#define OP_MAPREAD	2
> -#define OP_MAPWRITE	3
> -#define OP_MAX_LITE	4
> -
> -/* !lite operations */
> -#define OP_TRUNCATE		4
> -#define OP_FALLOCATE		5
> -#define OP_PUNCH_HOLE		6
> -#define OP_ZERO_RANGE		7
> -#define OP_COLLAPSE_RANGE	8
> -#define OP_INSERT_RANGE	9
> -#define OP_MAX_FULL		10
> -
> -/* integrity operations */
> -#define OP_FSYNC		10
> -#define OP_MAX_INTEGRITY	11
> +enum {
> +	/* common operations */
> +	OP_READ = 0,
> +	OP_WRITE,
> +	OP_MAPREAD,
> +	OP_MAPWRITE,
> +	OP_MAX_LITE,
> +
> +	/* !lite operations */
> +	OP_TRUNCATE = OP_MAX_LITE,
> +	OP_FALLOCATE,
> +	OP_PUNCH_HOLE,
> +	OP_ZERO_RANGE,
> +	OP_COLLAPSE_RANGE,
> +	OP_INSERT_RANGE,
> +	OP_MAX_FULL,
> +
> +	/* integrity operations */
> +	OP_FSYNC = OP_MAX_FULL,
> +	OP_MAX_INTEGRITY,
> +};
>   
>   #undef PAGE_SIZE
>   #define PAGE_SIZE       getpagesize()
> 
