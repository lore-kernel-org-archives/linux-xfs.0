Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E9A4C432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 14:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C99C2053B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 14:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfIXOii (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 10:38:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36042 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfIXOii (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 10:38:38 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DE2E9307D923;
        Tue, 24 Sep 2019 14:38:37 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 389BE5D721;
        Tue, 24 Sep 2019 14:38:37 +0000 (UTC)
Date:   Tue, 24 Sep 2019 10:38:35 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [REPOST PATCH v3 11/16] xfs: mount-api - add xfs_remount_ro()
 helper
Message-ID: <20190924143835.GE17688@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
 <156933137949.20933.11551905065222062958.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156933137949.20933.11551905065222062958.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 24 Sep 2019 14:38:37 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 24, 2019 at 09:22:59PM +0800, Ian Kent wrote:
> Factor the remount read only code into a helper to simplify the
> subsequent change from the super block method .remount_fs to the
> mount-api fs_context_operations method .reconfigure.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---

This (and the next patch) looks exactly like the previous version
(please retain review tags).

Brian

>  fs/xfs/xfs_super.c |   73 +++++++++++++++++++++++++++++++---------------------
>  1 file changed, 43 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index aaee32162950..de75891c5551 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1433,6 +1433,47 @@ xfs_remount_rw(
>  	return 0;
>  }
>  
> +STATIC int
> +xfs_remount_ro(
> +	struct xfs_mount	*mp)
> +{
> +	int error;
> +
> +	/*
> +	 * Cancel background eofb scanning so it cannot race with the
> +	 * final log force+buftarg wait and deadlock the remount.
> +	 */
> +	xfs_stop_block_reaping(mp);
> +
> +	/* Get rid of any leftover CoW reservations... */
> +	error = xfs_icache_free_cowblocks(mp, NULL);
> +	if (error) {
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return error;
> +	}
> +
> +	/* Free the per-AG metadata reservation pool. */
> +	error = xfs_fs_unreserve_ag_blocks(mp);
> +	if (error) {
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return error;
> +	}
> +
> +	/*
> +	 * Before we sync the metadata, we need to free up the reserve
> +	 * block pool so that the used block count in the superblock on
> +	 * disk is correct at the end of the remount. Stash the current
> +	 * reserve pool size so that if we get remounted rw, we can
> +	 * return it to the same size.
> +	 */
> +	xfs_save_resvblks(mp);
> +
> +	xfs_quiesce_attr(mp);
> +	mp->m_flags |= XFS_MOUNT_RDONLY;
> +
> +	return 0;
> +}
> +
>  STATIC int
>  xfs_fs_remount(
>  	struct super_block	*sb,
> @@ -1503,37 +1544,9 @@ xfs_fs_remount(
>  
>  	/* rw -> ro */
>  	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
> -		/*
> -		 * Cancel background eofb scanning so it cannot race with the
> -		 * final log force+buftarg wait and deadlock the remount.
> -		 */
> -		xfs_stop_block_reaping(mp);
> -
> -		/* Get rid of any leftover CoW reservations... */
> -		error = xfs_icache_free_cowblocks(mp, NULL);
> -		if (error) {
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -			return error;
> -		}
> -
> -		/* Free the per-AG metadata reservation pool. */
> -		error = xfs_fs_unreserve_ag_blocks(mp);
> -		if (error) {
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		error = xfs_remount_ro(mp);
> +		if (error)
>  			return error;
> -		}
> -
> -		/*
> -		 * Before we sync the metadata, we need to free up the reserve
> -		 * block pool so that the used block count in the superblock on
> -		 * disk is correct at the end of the remount. Stash the current
> -		 * reserve pool size so that if we get remounted rw, we can
> -		 * return it to the same size.
> -		 */
> -		xfs_save_resvblks(mp);
> -
> -		xfs_quiesce_attr(mp);
> -		mp->m_flags |= XFS_MOUNT_RDONLY;
>  	}
>  
>  	return 0;
> 
