Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8F84E7F4E
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 09:55:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0BD10AC002
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 07:55:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AnhNAz5FHXOXVVCZ for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 07:55:06 -0700 (PDT)
Message-ID: <55672C4C.2010805@sandeen.net>
Date: Thu, 28 May 2015 09:55:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: merge the duplicated condition in
	xfs_mkfs.c/validate_ag_geometry
References: <1432796808-862-1-git-send-email-shhuiw@foxmail.com>
In-Reply-To: <1432796808-862-1-git-send-email-shhuiw@foxmail.com>
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
To: Wang Sheng-Hui <shhuiw@foxmail.com>, xfs@oss.sgi.com, dchinner@redhat.com, david@fromorbit.com, bfoster@redhat.com

On 5/28/15 2:06 AM, Wang Sheng-Hui wrote:
> Some conditions are duplicated. Merge them.

While you are correct that they are duplicated, simply combining
them doesn't mkae a lot of sense; now we'll get this sort of
error message:

> agsize (%lld blocks) too small, need at least %lld blocks
> too many allocation groups for size = %lld
> need at most %lld allocation groups

and what should a user do with that information?  It's somewhat
nonsensical.

The code as it is today, and as it has been since commit
1f1b8be7926480046ead7b98c9850ace7bcd82a3, doesn't make much sense,
because we can never hit the second conditional.  But simply
combining them doesn't look like the right answer to me.

If you look at the above commit, what it used to do was something
like:

-               /*
-                * If the specified agsize is too small, or too large,
-                * complain.
-                */
-               if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
-                       fprintf(stderr,
-               _("agsize (%lldb) too small, need at least %lld blocks\n"),
-                               (long long)agsize,
-                               (long long)XFS_AG_MIN_BLOCKS(blocklog));
-                       usage();
-               }

<snip>

-       /*
-        * If the ag size is too small, complain if agcount/agsize was
-        * specified, and fix it otherwise.
-        */
-       if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
-               if (daflag || dasize) {
-                       fprintf(stderr,
-                       _("too many allocation groups for size = %lld\n"),
-                               (long long)agsize);
-                       fprintf(stderr,
-                               _("need at most %lld allocation groups\n"),
-                               (long long)
-                               (dblocks / XFS_AG_MIN_BLOCKS(blocklog) +
-                               (dblocks % XFS_AG_MIN_BLOCKS(blocklog) != 0)));

...

I *think* the intent was to use different messages based on what
was specified by the user; i.e. if agsize was specified, and is too
small, then say:

> agsize (%lld blocks) too small, need at least %lld blocks

but if agcount was specified, and was too large, then say:

> too many allocation groups for size = %lld
> need at most %lld allocation groups

but combining those two messages doesn't make sense to me.

-Eric


> Signed-off-by: Wang Sheng-Hui <shhuiw@foxmail.com>
> ---
>  mkfs/xfs_mkfs.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index e2a052d..7ec2556 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -740,22 +740,6 @@ validate_ag_geometry(
>  	__uint64_t	agsize,
>  	__uint64_t	agcount)
>  {
> -	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
> -		fprintf(stderr,
> -	_("agsize (%lld blocks) too small, need at least %lld blocks\n"),
> -			(long long)agsize,
> -			(long long)XFS_AG_MIN_BLOCKS(blocklog));
> -		usage();
> -	}
> -
> -	if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
> -		fprintf(stderr,
> -	_("agsize (%lld blocks) too big, maximum is %lld blocks\n"),
> -			(long long)agsize,
> -			(long long)XFS_AG_MAX_BLOCKS(blocklog));
> -		usage();
> -	}
> -
>  	if (agsize > dblocks) {
>  		fprintf(stderr,
>  	_("agsize (%lld blocks) too big, data area is %lld blocks\n"),
> @@ -765,6 +749,10 @@ validate_ag_geometry(
>  
>  	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
>  		fprintf(stderr,
> +	_("agsize (%lld blocks) too small, need at least %lld blocks\n"),
> +			(long long)agsize,
> +			(long long)XFS_AG_MIN_BLOCKS(blocklog));
> +		fprintf(stderr,
>  	_("too many allocation groups for size = %lld\n"),
>  				(long long)agsize);
>  		fprintf(stderr, _("need at most %lld allocation groups\n"),
> @@ -775,6 +763,10 @@ validate_ag_geometry(
>  
>  	if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
>  		fprintf(stderr,
> +	_("agsize (%lld blocks) too big, maximum is %lld blocks\n"),
> +			(long long)agsize,
> +			(long long)XFS_AG_MAX_BLOCKS(blocklog));
> +		fprintf(stderr,
>  	_("too few allocation groups for size = %lld\n"), (long long)agsize);
>  		fprintf(stderr,
>  	_("need at least %lld allocation groups\n"),
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
