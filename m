Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3631F29DFA
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 10:20:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22693304053
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 08:20:42 -0700 (PDT)
Received: from mail-ve0-f181.google.com (mail-ve0-f181.google.com
	[209.85.128.181]) by cuda.sgi.com with ESMTP id
	tqjnrjvLCrEegv7D (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Apr 2013 08:20:41 -0700 (PDT)
Received: by mail-ve0-f181.google.com with SMTP id pa12so2472686veb.26
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 08:20:40 -0700 (PDT)
Message-ID: <5168263E.40208@gmail.com>
Date: Fri, 12 Apr 2013 11:20:30 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix s_max_bytes to MAX_LFS_FILESIZE if needed
References: <5167E160.3020800@oracle.com>
In-Reply-To: <5167E160.3020800@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

I'll try this patch tonight.  Thanks!

BTW, after failures with CONFIG_LBDAF=n in previous xfstests, my kernels 
should have CONFIG_LBDAF=y, but I could be wrong.  I'll check this when 
I get back to my test PC and test your patch with both settings.

Michael

On 04/12/2013 06:26 AM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
>
> This patch fix the s_max_bytes to MAX_LFS_FILESIZE if the pre-calculated value is greater
> than it.
>
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>
> ---
>   fs/xfs/xfs_super.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ea341ce..0644d61 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -585,6 +585,7 @@ xfs_max_file_offset(
>   {
>   	unsigned int		pagefactor = 1;
>   	unsigned int		bitshift = BITS_PER_LONG - 1;
> +	__uint64_t		offset;
>
>   	/* Figure out maximum filesize, on Linux this can depend on
>   	 * the filesystem blocksize (on 32 bit platforms).
> @@ -610,7 +611,10 @@ xfs_max_file_offset(
>   # endif
>   #endif
>
> -	return (((__uint64_t)pagefactor) << bitshift) - 1;
> +	offset = (((__uint64_t)pagefactor) << bitshift) - 1;
> +
> +	/* Check against VM & VFS exposed limits */
> +	return (offset > MAX_LFS_FILESIZE) ? MAX_LFS_FILESIZE : offset;
>   }
>
>   xfs_agnumber_t
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
