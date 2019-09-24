Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60269C432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 14:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DEE92053B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 14:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfIXOi1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 10:38:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20575 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfIXOi1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 10:38:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 722BD3C93D;
        Tue, 24 Sep 2019 14:38:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDED3166A0;
        Tue, 24 Sep 2019 14:38:24 +0000 (UTC)
Date:   Tue, 24 Sep 2019 10:38:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [REPOST PATCH v3 09/16] xfs: mount-api - add xfs_get_tree()
Message-ID: <20190924143823.GD17688@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
 <156933136908.20933.15050470634891698659.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156933136908.20933.15050470634891698659.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 24 Sep 2019 14:38:27 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 24, 2019 at 09:22:49PM +0800, Ian Kent wrote:
> Add the fs_context_operations method .get_tree that validates
> mount options and fills the super block as previously done
> by the file_system_type .mount method.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ea3640ffd8f5..6f9fe92b4e21 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1933,6 +1933,51 @@ xfs_fs_fill_super(
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
> +

I'm still not following the (intended) lifecycle of mp here. Looking
ahead in the series, we allocate mp in xfs_init_fs_context() and set
some state. It looks like at some point we grow an xfs_fc_free()
callback that frees mp, but that doesn't exist as of yet. So is that a
memory leak as of this patch?

We also call xfs_free_fsname() here (which doesn't reset pointers to
NULL) and open-code kfree()'s of a couple of the same fields in
xfs_fc_free(). Those look like double frees to me.

Hmm.. I guess I'm kind of wondering why we lift the mp alloc out of the
fill super call in the first place. At a glance, it doesn't look like we
do anything in that xfs_init_fs_context() call that we couldn't do a bit
later..

Brian

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
> @@ -2003,6 +2048,11 @@ static const struct super_operations xfs_super_operations = {
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
>  };
>  
> +static const struct fs_context_operations xfs_context_ops = {
> +	.parse_param = xfs_parse_param,
> +	.get_tree    = xfs_get_tree,
> +};
> +
>  static struct file_system_type xfs_fs_type = {
>  	.owner			= THIS_MODULE,
>  	.name			= "xfs",
> 
