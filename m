Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932418AbcLGTJU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 14:09:20 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3538932B71F
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 19:02:03 +0000 (UTC)
Date: Wed, 7 Dec 2016 14:02:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_logprint: di_gen is unsigned
Message-ID: <20161207190201.GD23106@bfoster.bfoster>
References: <c453839b-61db-9500-b39d-e6580d1748b5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c453839b-61db-9500-b39d-e6580d1748b5@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Dec 05, 2016 at 04:48:01PM -0600, Eric Sandeen wrote:
> di_gen is unsigned:
> 
>         __uint32_t      di_gen;         /* generation number */
> 
> but we print it as a signed int in logprint, so see oddities like:
> 
>  forkoff:24  dmevmask:0x0  dmstate:0  flags:0x0  gen:-628807103
> 
> Fix this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index f49316e..3863ba9 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c
> @@ -269,7 +269,7 @@ xlog_recover_print_inode_core(
>  	       di->di_size, (unsigned long long)di->di_nblocks,
>  	       di->di_extsize, di->di_nextents, (int)di->di_anextents);
>  	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "
> -	     "gen:%d\n"),
> +	     "gen:%u\n"),
>  	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
>  	       (int)di->di_flags, di->di_gen);
>  	if (di->di_version == 3) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
