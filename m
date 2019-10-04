Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8ECC47404
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 15:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8AEE21D81
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 15:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390092AbfJDPx0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:53:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389936AbfJDPx0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Oct 2019 11:53:26 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AFE8E308A968;
        Fri,  4 Oct 2019 15:53:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 010654250;
        Fri,  4 Oct 2019 15:53:22 +0000 (UTC)
Date:   Fri, 4 Oct 2019 11:53:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 13/17] xfs: mount api - add xfs_reconfigure()
Message-ID: <20191004155321.GE7208@bfoster>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
 <157009838772.13858.3951542955676751036.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157009838772.13858.3951542955676751036.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 04 Oct 2019 15:53:25 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 03, 2019 at 06:26:27PM +0800, Ian Kent wrote:
> Add the fs_context_operations method .reconfigure that performs
> remount validation as previously done by the super_operations
> .remount_fs method.
> 
> An attempt has also been made to update the comment about options
> handling problems with mount(8) to reflect the current situation.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ddcf030cca7c..06f650fb3a8c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1544,6 +1544,73 @@ xfs_fs_remount(
>  	return 0;
>  }
>  
> +/*
> + * There can be problems with options passed from mount(8) when
> + * only the mount point path is given. The options are a merge
> + * of options from the fstab, mtab of the current mount and options
> + * given on the command line.
> + *
> + * But this can't be relied upon to accurately reflect the current
> + * mount options. Consequently rejecting options that can't be
> + * changed on reconfigure could erronously cause a mount failure.
> + *
> + * Nowadays it should be possible to compare incoming options
> + * and return an error for options that differ from the current
> + * mount and can't be changed on reconfigure.
> + *
> + * But this still might not always be the case so for now continue
> + * to return success for every reconfigure request, and silently
> + * ignore all options that can't actually be changed.
> + *
> + * See the commit log entry of this change for a more detailed
> + * desription of the problem.
> + */

But the commit log entry doesn't include any new info..?

How about this.. we already have a similar comment in xfs_fs_remount()
that I happen to find a bit more clear. It also obviously has precedent.
How about we copy that one to the top of this function verbatim, and
whatever extra you want to get across can be added to the commit log
description. Hm?

Brian

> +STATIC int
> +xfs_reconfigure(
> +	struct fs_context *fc)
> +{
> +	struct xfs_fs_context	*ctx = fc->fs_private;
> +	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
> +	struct xfs_mount        *new_mp = fc->s_fs_info;
> +	xfs_sb_t		*sbp = &mp->m_sb;
> +	int			flags = fc->sb_flags;
> +	int			error;
> +
> +	error = xfs_validate_params(new_mp, ctx, false);
> +	if (error)
> +		return error;
> +
> +	/* inode32 -> inode64 */
> +	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> +	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> +	}
> +
> +	/* inode64 -> inode32 */
> +	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> +	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> +	}
> +
> +	/* ro -> rw */
> +	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
> +		error = xfs_remount_rw(mp);
> +		if (error)
> +			return error;
> +	}
> +
> +	/* rw -> ro */
> +	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
> +		error = xfs_remount_ro(mp);
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Second stage of a freeze. The data is already frozen so we only
>   * need to take care of the metadata. Once that's done sync the superblock
> @@ -2069,6 +2136,7 @@ static const struct super_operations xfs_super_operations = {
>  static const struct fs_context_operations xfs_context_ops = {
>  	.parse_param = xfs_parse_param,
>  	.get_tree    = xfs_get_tree,
> +	.reconfigure = xfs_reconfigure,
>  };
>  
>  static struct file_system_type xfs_fs_type = {
> 
