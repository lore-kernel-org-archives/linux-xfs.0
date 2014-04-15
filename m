Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8B877F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 17:02:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9A8DF30407A
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 15:02:39 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0hTkGODxdniGdsYc for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 15:02:33 -0700 (PDT)
Date: Wed, 16 Apr 2014 08:02:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3 v2] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append
	only file
Message-ID: <20140415220220.GR15995@dastard>
References: <1397580076-19826-1-git-send-email-lczerner@redhat.com>
	<1397580076-19826-2-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397580076-19826-2-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 15, 2014 at 06:41:15PM +0200, Lukas Czerner wrote:
> Currently punch hole and collapse range fallocate operation are not
> allowed on append only file. This should be case for zero range as well.
> Fix it by allowing only pure fallocate (possibly with keep size set).
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> v2: Change the condition to be future proof as suggested by hch
> 
>  fs/open.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 631aea81..fe48b2f 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -254,11 +254,9 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  		return -EBADF;
>  
>  	/*
> -	 * It's not possible to punch hole or perform collapse range
> -	 * on append only file
> +	 * We can only allow pure fallocate on append only files
>  	 */
> -	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
> -	    && IS_APPEND(inode))
> +	if (mode & ~FALLOC_FL_KEEP_SIZE && IS_APPEND(inode))

	if ((mode & ~FALLOC_FL_KEEP_SIZE) && IS_APPEND(inode))

gcc normally complains when you mix & and && in the same logic
statement without () to separate the logic. I agree with gcc here,
because the () indicate the intent of the logic and make it easy to
determine that the & and && haven't been mixed up or fat-fingered...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
