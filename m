Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A1847F3F
	for <xfs@oss.sgi.com>; Tue, 10 Sep 2013 16:20:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37C8EAC002
	for <xfs@oss.sgi.com>; Tue, 10 Sep 2013 14:20:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	xVivFQZPm199GAql for <xfs@oss.sgi.com>;
	Tue, 10 Sep 2013 14:20:06 -0700 (PDT)
Date: Wed, 11 Sep 2013 07:20:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: change the immutable in xfs_open_by_handle
Message-ID: <20130910212002.GB19103@dastard>
References: <20130910184724.726933044@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130910184724.726933044@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Greg Banks <gbanks@sgi.com>, xfs@oss.sgi.com

On Tue, Sep 10, 2013 at 01:47:20PM -0500, Mark Tinguely wrote:
> This patch allows clients like DMF to modify an immutable file
> without changing the immutable capability on the file, which
> would expose the file to change.
> 
> This patch is restricted to holders of the CAP_LINUX_IMMUTABLE,
> so no addition security risk has been introduced.
> 
> Signed-off-by: Greg Banks <gbanks@sgi.com>
> Singed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  fs/xfs/xfs_ioctl.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: b/fs/xfs/xfs_ioctl.c
> ===================================================================
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -237,7 +237,9 @@ xfs_open_by_handle(
>  		goto out_dput;
>  	}
>  
> -	if ((fmode & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
> +	if ((permflag & FMODE_WRITE) &&

Why the conversion from fmode to permflag? At minimum, this will
probably throw sparse warnings for comparing a FMODE_* flag against
a variable that is not a fmode_t....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
