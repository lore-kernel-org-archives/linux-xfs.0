Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE787C3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 13:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE0F22077B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 13:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfH1N12 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 09:27:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbfH1N12 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Aug 2019 09:27:28 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D6DDB3087958;
        Wed, 28 Aug 2019 13:27:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C33FF60C5D;
        Wed, 28 Aug 2019 13:27:25 +0000 (UTC)
Date:   Wed, 28 Aug 2019 09:27:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 08/15] xfs: mount-api - add xfs_get_tree()
Message-ID: <20190828132724.GA16389@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652199954.2607.8863934346265980917.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156652199954.2607.8863934346265980917.stgit@fedora-28>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 28 Aug 2019 13:27:27 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 08:59:59AM +0800, Ian Kent wrote:
> Add the fs_context_operations method .get_tree that validates
> mount options and fills the super block as previously done
> by the file_system_type .mount method.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d3fc9938987d..7de64808eb00 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1904,6 +1904,52 @@ xfs_fs_fill_super(
>  	return error;
>  }
>  
> +STATIC int
> +xfs_fill_super(
> +	struct super_block	*sb,
> +	struct fs_context	*fc)
> +{
> +	struct xfs_fs_context	*ctx = fc->fs_private;
> +	struct xfs_mount	*mp = sb->s_fs_info;
> +	int			silent = fc->sb_flags & SB_SILENT;
> +	int			error = -ENOMEM;
> +
> +	mp->m_super = sb;
> +
> +	/*
> +	 * set up the mount name first so all the errors will refer to the
> +	 * correct device.
> +	 */
> +	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
> +	if (!mp->m_fsname)
> +		return -ENOMEM;
> +	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
> +
> +	error = xfs_validate_params(mp, ctx, false);
> +	if (error)
> +		goto out_free_fsname;
> +
> +	error = __xfs_fs_fill_super(mp, silent);
> +	if (error)
> +		goto out_free_fsname;
> +
> +	return 0;
> +
> + out_free_fsname:
> +	sb->s_fs_info = NULL;
> +	xfs_free_fsname(mp);
> +	kfree(mp);

So where is mp allocated in the updated mount sequence? Has that code
been added yet or does this tie into the existing fill_super sequence?
It's hard to tell because xfs_context_ops is still unused. It looks a
little strange to free mp here when it's presumably been allocated
somewhere else. If that is separate code, perhaps some of the patches
should be combined (i.e. even if just setup/teardown bits) for easier
review.

Brian

> +
> +	return error;
> +}
> +
> +STATIC int
> +xfs_get_tree(
> +	struct fs_context	*fc)
> +{
> +	return vfs_get_block_super(fc, xfs_fill_super);
> +}
> +
>  STATIC void
>  xfs_fs_put_super(
>  	struct super_block	*sb)
> @@ -1976,6 +2022,7 @@ static const struct super_operations xfs_super_operations = {
>  
>  static const struct fs_context_operations xfs_context_ops = {
>  	.parse_param = xfs_parse_param,
> +	.get_tree    = xfs_get_tree,
>  };
>  
>  static struct file_system_type xfs_fs_type = {
> 
