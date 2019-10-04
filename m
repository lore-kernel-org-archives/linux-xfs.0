Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D24C4CED1
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 15:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEEB2207FF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 15:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390133AbfJDPwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:52:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390089AbfJDPwp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Oct 2019 11:52:45 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2AA4B3098435;
        Fri,  4 Oct 2019 15:52:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A22719C77;
        Fri,  4 Oct 2019 15:52:44 +0000 (UTC)
Date:   Fri, 4 Oct 2019 11:52:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 10/17] xfs: mount-api - add xfs_get_tree()
Message-ID: <20191004155242.GD7208@bfoster>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
 <157009837210.13858.11725663486459207040.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157009837210.13858.11725663486459207040.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 04 Oct 2019 15:52:45 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 03, 2019 at 06:26:12PM +0800, Ian Kent wrote:
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
> index cc2da9093e34..b984120667da 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1925,6 +1925,51 @@ xfs_fs_fill_super(
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
> +		goto out_free_fsname;
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
> +	return error;

Ok, I think I have a better understanding of how this is supposed to
work with the background context. mp starts off in fc->s_fs_info, ends
up transferred to sb->s_fs_info and passed into here. We allocate
->m_fsname and carry on from here with ownership of mp.

The only thing I'll note is that the out_free_fsname label is misnamed
and probably could be out_free or out_free_mp or something. With that
nit addressed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +}
> +
> +STATIC int
> +xfs_get_tree(
> +	struct fs_context	*fc)
> +{
> +	return get_tree_bdev(fc, xfs_fill_super);
> +}
> +
>  STATIC void
>  xfs_fs_put_super(
>  	struct super_block	*sb)
> @@ -1995,6 +2040,11 @@ static const struct super_operations xfs_super_operations = {
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
