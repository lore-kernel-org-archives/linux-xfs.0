Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387941AbeGWVlf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 17:41:35 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 250B17DAC6
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 20:38:40 +0000 (UTC)
Date: Mon, 23 Jul 2018 15:38:38 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH v2 02/15] xfs: use ->t_dfops in log recovery intent
 processing
Message-ID: <20180723203838.GB18737@redhat.com>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:01AM -0400, Brian Foster wrote:
> xlog_finish_defer_ops() processes the deferred operations collected
> over the entire intent recovery sequence. We can't xfs_defer_init()
> here because the dfops is already populated. Attach it manually and
> eliminate the last caller of xfs_defer_finish() that doesn't pass
> ->t_dfops.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/xfs_log_recover.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index cbac943896f4..3289811eb076 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4854,6 +4854,8 @@ xlog_finish_defer_ops(
>  			0, XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;
> +	/* dfops is already populated so assign it manually */
> +	tp->t_dfops = dfops;
>  
>  	error = xfs_defer_finish(&tp, dfops);
>  	if (error)
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
