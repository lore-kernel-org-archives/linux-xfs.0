Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F34FD7F54
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 14:44:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E56C78F8035
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:44:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YPhj1fhMK0AMM9O4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:44:10 -0700 (PDT)
Date: Mon, 14 Sep 2015 15:44:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/13] xfs_repair: catch bad level/depth in da node
Message-ID: <20150914194407.GI34083@bfoster.bfoster>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
	<1441827251-13128-9-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441827251-13128-9-git-send-email-sandeen@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Sep 09, 2015 at 02:34:06PM -0500, Eric Sandeen wrote:
> Two tests added some time ago to dir2.c:
> 
> 44dae5e xfs_repair: test for bad level in dir2 node
> 28148f6 xfs_repair: catch bad depth in traverse_int_dir2block
> 
> never made it to the similar tree-walking code in attr_repair.c;
> fix that up here.  The error string details will be fixed up
> later.
> 
> Signed-off-by; Eric Sandeen <sandeen@redhat.com>
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/attr_repair.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 5ae2356..2aafdf6 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -212,9 +212,17 @@ traverse_int_dablock(xfs_mount_t	*mp,
>  		/*
>  		 * maintain level counter
>  		 */
> -		if (i == -1)
> +		if (i == -1) {
>  			i = da_cursor->active = nodehdr.level;
> -		else  {
> +			if (i < 1 || i >= XFS_DA_NODE_MAXDEPTH) {
> +				do_warn(
> +_("bad header depth for directory inode %" PRIu64 "\n"),
> +					da_cursor->ino);
> +				libxfs_putbuf(bp);
> +				i = -1;
> +				goto error_out;
> +			}
> +		} else  {
>  			if (nodehdr.level == i - 1)  {
>  				i--;
>  			} else  {
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
