Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B6CC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jun 2022 23:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbiFTXlc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jun 2022 19:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiFTXlc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jun 2022 19:41:32 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 636CD19C19
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 16:41:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7971E5ECB46;
        Tue, 21 Jun 2022 09:41:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o3R1N-00962j-Eo; Tue, 21 Jun 2022 09:41:29 +1000
Date:   Tue, 21 Jun 2022 09:41:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: add selinux labels to whiteout inodes
Message-ID: <20220620234129.GN227878@dread.disaster.area>
References: <1655765731-21078-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655765731-21078-1-git-send-email-sandeen@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62b105aa
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=9jJOX3a-DkoEnuY7A-cA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 20, 2022 at 05:55:31PM -0500, Eric Sandeen wrote:
> We got a report that "renameat2() with flags=RENAME_WHITEOUT doesn't
> apply an SELinux label on xfs" as it does on other filesystems
> (for example, ext4 and tmpfs.)  While I'm not quite sure how labels
> may interact w/ whiteout files, leaving them as unlabeled seems
> inconsistent at best.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 14 +++++++++++++-
>  fs/xfs/xfs_iops.c  |  2 +-
>  fs/xfs/xfs_iops.h  |  3 +++
>  3 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 52d6f2c..9a43060 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3046,10 +3046,12 @@ struct xfs_iunlink {
>  static int
>  xfs_rename_alloc_whiteout(
>  	struct user_namespace	*mnt_userns,
> +	struct xfs_name		*src_name,
>  	struct xfs_inode	*dp,
>  	struct xfs_inode	**wip)
>  {
>  	struct xfs_inode	*tmpfile;
> +	struct qstr		name;
>  	int			error;
>  
>  	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
> @@ -3057,6 +3059,15 @@ struct xfs_iunlink {
>  	if (error)
>  		return error;
>  
> +	name.name = src_name->name;
> +	name.len = src_name->len;
> +	error = xfs_init_security(VFS_I(tmpfile), VFS_I(dp), &name);
> +	if (error) {
> +		xfs_finish_inode_setup(tmpfile);
> +		xfs_irele(tmpfile);
> +		return error;
> +	}
> +

I was worried that this would be inside an existing transaction,
but the tmpfile create is outside the rename transaction so this
will be fine.

>  	/*
>  	 * Prepare the tmpfile inode as if it were created through the VFS.
>  	 * Complete the inode setup and flag it as linkable.  nlink is already
> @@ -3107,7 +3118,8 @@ struct xfs_iunlink {
>  	 * appropriately.
>  	 */
>  	if (flags & RENAME_WHITEOUT) {
> -		error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
> +		error = xfs_rename_alloc_whiteout(mnt_userns, src_name,
> +						  target_dp, &wip);
>  		if (error)
>  			return error;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 29f5b8b8..c7775b7 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -76,7 +76,7 @@
>   * inode, of course, such that log replay can't cause these to be lost).
>   */
>  
> -STATIC int
> +int
>  xfs_init_security(

This function needs renaming, though. As a static function it can
get away with not having a namespace, but as a globally visible
function it needs to have an "xfs_inode_" prefix....

Otherwise OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
