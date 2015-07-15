Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4ECEE7F6C
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 06:16:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8B81AC001
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 04:16:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 79lT2TqpVv4SvlF9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jul 2015 04:16:52 -0700 (PDT)
Date: Wed, 15 Jul 2015 07:16:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Fix uninitialized return value in
	xfs_alloc_fix_freelist()
Message-ID: <20150715111649.GA60463@bfoster.bfoster>
References: <1436948168-25051-1-git-send-email-jack@suse.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1436948168-25051-1-git-send-email-jack@suse.com>
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
To: Jan Kara <jack@suse.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 15, 2015 at 10:16:08AM +0200, Jan Kara wrote:
> xfs_alloc_fix_freelist() can sometimes jump to out_agbp_relse without
> ever setting value of 'error' variable which is then returned. This can
> happen e.g. when pag->pagf_init is set but AG is for metadata and we
> want to allocate user data.
> 
> Fix the problem by initializing 'error' to 0, which is the desired
> return value when we decide to skip this group.
> 
> CC: xfs@oss.sgi.com
> Coverity-id: 1309714
> Signed-off-by: Jan Kara <jack@suse.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index f9e9ffe6fb46..7f8f2a0d4567 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1937,7 +1937,7 @@ xfs_alloc_fix_freelist(
>  	struct xfs_alloc_arg	targs;	/* local allocation arguments */
>  	xfs_agblock_t		bno;	/* freelist block */
>  	xfs_extlen_t		need;	/* total blocks needed in freelist */
> -	int			error;
> +	int			error = 0;
>  
>  	if (!pag->pagf_init) {
>  		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
