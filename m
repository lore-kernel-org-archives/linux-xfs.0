Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62956C3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 13:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 419962077B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 13:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfH1N1h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 09:27:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbfH1N1h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Aug 2019 09:27:37 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E615779705;
        Wed, 28 Aug 2019 13:27:36 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FBBC196AE;
        Wed, 28 Aug 2019 13:27:36 +0000 (UTC)
Date:   Wed, 28 Aug 2019 09:27:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 09/15] xfs: mount-api - add xfs_remount_rw() helper
Message-ID: <20190828132734.GB16389@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652200638.2607.17067626550015292418.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156652200638.2607.17067626550015292418.stgit@fedora-28>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 28 Aug 2019 13:27:37 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 09:00:06AM +0800, Ian Kent wrote:
> Factor the remount read write code into a helper to simplify the
> subsequent change from the super block method .remount_fs to the
> mount-api fs_context_operations method .reconfigure.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---

Seems fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_super.c |  115 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 64 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 7de64808eb00..9f7300958a38 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1341,6 +1341,68 @@ xfs_test_remount_options(
>  	return error;
>  }
>  
> +STATIC int
> +xfs_remount_rw(
> +	struct xfs_mount	*mp)
> +{
> +	xfs_sb_t		*sbp = &mp->m_sb;
> +	int error;
> +
> +	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> +		xfs_warn(mp,
> +			"ro->rw transition prohibited on norecovery mount");
> +		return -EINVAL;
> +	}
> +
> +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> +		xfs_warn(mp,
> +	"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
> +			(sbp->sb_features_ro_compat &
> +				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> +		return -EINVAL;
> +	}
> +
> +	mp->m_flags &= ~XFS_MOUNT_RDONLY;
> +
> +	/*
> +	 * If this is the first remount to writeable state we
> +	 * might have some superblock changes to update.
> +	 */
> +	if (mp->m_update_sb) {
> +		error = xfs_sync_sb(mp, false);
> +		if (error) {
> +			xfs_warn(mp, "failed to write sb changes");
> +			return error;
> +		}
> +		mp->m_update_sb = false;
> +	}
> +
> +	/*
> +	 * Fill out the reserve pool if it is empty. Use the stashed
> +	 * value if it is non-zero, otherwise go with the default.
> +	 */
> +	xfs_restore_resvblks(mp);
> +	xfs_log_work_queue(mp);
> +
> +	/* Recover any CoW blocks that never got remapped. */
> +	error = xfs_reflink_recover_cow(mp);
> +	if (error) {
> +		xfs_err(mp,
> +			"Error %d recovering leftover CoW allocations.", error);
> +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return error;
> +	}
> +	xfs_start_block_reaping(mp);
> +
> +	/* Create the per-AG metadata reservation pool .*/
> +	error = xfs_fs_reserve_ag_blocks(mp);
> +	if (error && error != -ENOSPC)
> +		return error;
> +
> +	return 0;
> +}
> +
>  STATIC int
>  xfs_fs_remount(
>  	struct super_block	*sb,
> @@ -1404,57 +1466,8 @@ xfs_fs_remount(
>  
>  	/* ro -> rw */
>  	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY)) {
> -		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> -			xfs_warn(mp,
> -		"ro->rw transition prohibited on norecovery mount");
> -			return -EINVAL;
> -		}
> -
> -		if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> -		    xfs_sb_has_ro_compat_feature(sbp,
> -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> -			xfs_warn(mp,
> -"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
> -				(sbp->sb_features_ro_compat &
> -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> -			return -EINVAL;
> -		}
> -
> -		mp->m_flags &= ~XFS_MOUNT_RDONLY;
> -
> -		/*
> -		 * If this is the first remount to writeable state we
> -		 * might have some superblock changes to update.
> -		 */
> -		if (mp->m_update_sb) {
> -			error = xfs_sync_sb(mp, false);
> -			if (error) {
> -				xfs_warn(mp, "failed to write sb changes");
> -				return error;
> -			}
> -			mp->m_update_sb = false;
> -		}
> -
> -		/*
> -		 * Fill out the reserve pool if it is empty. Use the stashed
> -		 * value if it is non-zero, otherwise go with the default.
> -		 */
> -		xfs_restore_resvblks(mp);
> -		xfs_log_work_queue(mp);
> -
> -		/* Recover any CoW blocks that never got remapped. */
> -		error = xfs_reflink_recover_cow(mp);
> -		if (error) {
> -			xfs_err(mp,
> -	"Error %d recovering leftover CoW allocations.", error);
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -			return error;
> -		}
> -		xfs_start_block_reaping(mp);
> -
> -		/* Create the per-AG metadata reservation pool .*/
> -		error = xfs_fs_reserve_ag_blocks(mp);
> -		if (error && error != -ENOSPC)
> +		error = xfs_remount_rw(mp);
> +		if (error)
>  			return error;
>  	}
>  
> 
