Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34838 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbeKZUZP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Nov 2018 15:25:15 -0500
Received: by mail-wr1-f65.google.com with SMTP id 96so18102414wrb.2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Nov 2018 01:31:43 -0800 (PST)
Date: Mon, 26 Nov 2018 10:31:39 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: libxfs: move xfs_perag_put late
Message-ID: <20181126093139.cgojlmtubzuzdb23@hades.usersys.redhat.com>
References: <1543052660-58625-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1543052660-58625-1-git-send-email-bianpan2016@163.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pan Bian <bianpan2016@163.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org

On Sat, Nov 24, 2018 at 05:44:20PM +0800, Pan Bian wrote:
> The function xfs_alloc_get_freelist calls xfs_perag_put to drop the
> reference. In this case, pag may be released. However,
> pag->pagf_btreeblks is read and write after the put operation. This may
> result in a use-after-free bug. This patch moves the put operation late.
> 

The patch looks reasonable, can you detail more how did you find it? Via code
inspection of you hit this user-after-free in some way?

Cheers

> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index e1c0c0d..4be387d 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2435,7 +2435,6 @@ xfs_alloc_get_freelist(
>  	be32_add_cpu(&agf->agf_flcount, -1);
>  	xfs_trans_agflist_delta(tp, -1);
>  	pag->pagf_flcount--;
> -	xfs_perag_put(pag);
>  
>  	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
>  	if (btreeblk) {
> @@ -2443,6 +2442,7 @@ xfs_alloc_get_freelist(
>  		pag->pagf_btreeblks++;
>  		logflags |= XFS_AGF_BTREEBLKS;
>  	}
> +	xfs_perag_put(pag);
>  
>  	xfs_alloc_log_agf(tp, agbp, logflags);
>  	*bnop = bno;
> -- 
> 2.7.4
> 
> 

-- 
Carlos
