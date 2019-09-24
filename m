Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D504DC432C2
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 14:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B22132053B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 14:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbfIXOir (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 10:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfIXOir (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 10:38:47 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A848B30607E5;
        Tue, 24 Sep 2019 14:38:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F05D160461;
        Tue, 24 Sep 2019 14:38:45 +0000 (UTC)
Date:   Tue, 24 Sep 2019 10:38:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [REPOST PATCH v3 12/16] xfs: mount api - add xfs_reconfigure()
Message-ID: <20190924143844.GF17688@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
 <156933138468.20933.1616184640263037904.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156933138468.20933.1616184640263037904.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 24 Sep 2019 14:38:46 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 24, 2019 at 09:23:04PM +0800, Ian Kent wrote:
> Add the fs_context_operations method .reconfigure that performs
> remount validation as previously done by the super_operations
> .remount_fs method.
> 
> An attempt has also been made to update the comment about options
> handling problems with mount(8) to reflect the current situation.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---

It doesn't look like this incorporated feedback from v2..

Brian

>  fs/xfs/xfs_super.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 84 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index de75891c5551..e7627f7ca7f2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1552,6 +1552,89 @@ xfs_fs_remount(
>  	return 0;
>  }
>  
> +/*
> + * There have been problems in the past with options passed from mount(8).
> + *
> + * The problem being that options passed by mount(8) in the case where only
> + * the the mount point path is given would consist of the existing fstab
> + * options with the options from mtab for the current mount merged in and
> + * the options given on the command line last. But the result couldn't be
> + * relied upon to accurately reflect the current mount options so that
> + * rejecting options that can't be changed on reconfigure could erronously
> + * cause mount failure.
> + *
> + * The mount-api uses a legacy mount options handler in the VFS to handle
> + * mount(8) so these options will continue to be passed. Even if mount(8)
> + * is updated to use fsopen()/fsconfig()/fsmount() it's likely to continue
> + * to set the existing options so options problems with reconfigure could
> + * continue.
> + *
> + * For the longest time mtab locking was a problem and this could have been
> + * one possible cause. It's also possible there could have been options
> + * order problems.
> + *
> + * That has changed now as mtab is a link to the proc file system mount
> + * table so mtab options should be always accurate.
> + *
> + * Consulting the util-linux maintainer (Karel Zak) he is confident that,
> + * in this case, the options passed by mount(8) will be those of the current
> + * mount and the options order should be a correct merge of fstab and mtab
> + * options, and new options given on the command line.
> + *
> + * So, in theory, it should be possible to compare incoming options and
> + * return an error for options that differ from the current mount and can't
> + * be changed on reconfigure to prevent users from believing they might have
> + * changed mount options using remount which can't be changed.
> + *
> + * But for now continue to return success for every reconfigure request, and
> + * silently ignore all options that can't actually be changed.
> + */
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
> @@ -2077,6 +2160,7 @@ static const struct super_operations xfs_super_operations = {
>  static const struct fs_context_operations xfs_context_ops = {
>  	.parse_param = xfs_parse_param,
>  	.get_tree    = xfs_get_tree,
> +	.reconfigure = xfs_reconfigure,
>  };
>  
>  static struct file_system_type xfs_fs_type = {
> 
