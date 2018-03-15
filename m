Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750731AbeCOMRX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 08:17:23 -0400
Date: Thu, 15 Mar 2018 08:17:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: always check for and process unlinked inodes on
 mount
Message-ID: <20180315121717.GA45325@bfoster.bfoster>
References: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
 <d35d1067-a6f6-09be-9c4c-3e08a3bec3be@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d35d1067-a6f6-09be-9c4c-3e08a3bec3be@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 07, 2018 at 05:32:29PM -0600, Eric Sandeen wrote:
> Process any unlinked inodes unconditionally; this allows us to
> skip dirtying the log on frozen filesystems and still have
> proper recovery on the next mount.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1937a93..2a645c0 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5854,8 +5854,6 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>  		 */
>  		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
>  
> -		xlog_recover_process_iunlinks(log);
> -
>  		xlog_recover_check_summary(log);
>  
>  		xfs_notice(log->l_mp, "Ending recovery (logdev: %s)",
> @@ -5865,6 +5863,14 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>  	} else {
>  		xfs_info(log->l_mp, "Ending clean mount");
>  	}
> +
> +	/*
> +	 * Process any unlinked inodes unconditionally, this allows us to
> +	 * skip dirtying the log on frozen filesystems and still have
> +	 * proper recovery on the next mount.
> +	 */
> +	xlog_recover_process_iunlinks(log);
> +

The code seems fine. The only nit I have is maybe we should pull down
the "Ending ..." messages until after the iunlinks call.

That aside, this does introduce the same kind of mount delay we've been
batting around wrt to the agfl padding fixup thing. We already have the
scan in some places (perag reservation init calculations, cow blocks
scan), some of which may be able to be removed/replaced going forward. I
think this one falls into the latter category as well, but I'd be fine
with this for the time being so long as the benefit is valuable enough.

Have we considered anything like conditionally dirtying the log on
freeze only when there are open+unlinked files? It seems like that may
be uncommon enough to address the problem for snapshot users
(particularly the read-only use case mentioned in the cover letter), but
that's just a guess.

Brian

>  	return 0;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
