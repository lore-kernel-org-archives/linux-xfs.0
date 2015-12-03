Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B9DA27F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 23:54:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A51E8F8052
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 21:54:26 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JkMlwvDroEUafJ83 for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 21:54:24 -0800 (PST)
Date: Thu, 3 Dec 2015 16:54:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/11] xfsprogs: mkfs: fix unintentional integer overflow
Message-ID: <20151203055410.GT26718@dastard>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-4-git-send-email-t.vivek@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1449055167-19936-4-git-send-email-t.vivek@samsung.com>
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
To: Vivek Trivedi <t.vivek@samsung.com>
Cc: a.sahrawat@samsung.com, pankaj.m@samsung.com, xfs@oss.sgi.com

On Wed, Dec 02, 2015 at 04:49:19PM +0530, Vivek Trivedi wrote:
> Fix unintentional integer overflow  in mkfs.
> Reported by coverity.
> 
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> ---
>  mkfs/xfs_mkfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 7cba41a..e540c48 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2033,7 +2033,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
>  		/* check that rswidth is a multiple of fs blocksize */
>  		if (!norsflag && rswidth && !(BBTOB(rswidth) % blocksize)) {
>  			rswidth = DTOBT(rswidth);
> -			rtextbytes = rswidth << blocklog;
> +			rtextbytes = (__uint64_t)rswidth << blocklog;
>  			if (XFS_MIN_RTEXTSIZE <= rtextbytes &&
>  			    (rtextbytes <= XFS_MAX_RTEXTSIZE)) {
>  				rtextblocks = rswidth;

I dislike unexplained casts in code like this. Nobody knows exactly
why it is there. A better fix is to change the definition of
rswidth to a 64 bit type so casts are not ever necessary...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
