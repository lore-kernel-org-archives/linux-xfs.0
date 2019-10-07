Return-Path: <SRS0=GEoz=YA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB0AC47404
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 11:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47E2D2190F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 11:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfJGLv6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 07:51:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727490AbfJGLv6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Oct 2019 07:51:58 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3BEEF85541;
        Mon,  7 Oct 2019 11:51:58 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DC8785C290;
        Mon,  7 Oct 2019 11:51:56 +0000 (UTC)
Date:   Mon, 7 Oct 2019 07:51:55 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 14/17] xfs: mount-api - add xfs_fc_free()
Message-ID: <20191007115155.GB22140@bfoster>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
 <157009839296.13858.9863401564865806171.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157009839296.13858.9863401564865806171.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 07 Oct 2019 11:51:58 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 03, 2019 at 06:26:32PM +0800, Ian Kent wrote:
> Add the fs_context_operations method .free that performs fs
> context cleanup on context release.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 06f650fb3a8c..4f2963ff9e06 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2133,10 +2133,36 @@ static const struct super_operations xfs_super_operations = {
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
>  };
>  
> +static void xfs_fc_free(struct fs_context *fc)
> +{
> +	struct xfs_fs_context	*ctx = fc->fs_private;
> +	struct xfs_mount	*mp = fc->s_fs_info;
> +
> +	/*
> +	 * When the mount context is initialized the private
> +	 * struct xfs_mount info (mp) is allocated and stored in
> +	 * the fs context along with the struct xfs_fs_context
> +	 * (ctx) mount context working working storage.
> +	 *

"working working storage" ?

> +	 * On super block allocation the mount info struct, mp,
> +	 * is moved into private super block info field ->s_fs_info
> +	 * of the newly allocated super block. But if an error occurs
> +	 * before this happens it's the responsibility of the fs
> +	 * context to release the mount info struct.
> +	 */

I like the comment here, but it seems it could be simplified. E.g:

	/*
	 * mp and ctx are stored in the fs_context when it is initialized. mp is
	 * transferred to the superblock on a successful mount, but if an error
	 * occurs before the transfer we have to free it here.
	 */

> +	if (mp) {
> +		kfree(mp->m_logname);
> +		kfree(mp->m_rtname);

Also, can we just call xfs_free_fsname() here to be safe/consisent? With
those nits fixed up, this seems fine to me.

Brian

> +		kfree(mp);
> +	}
> +	kfree(ctx);
> +}
> +
>  static const struct fs_context_operations xfs_context_ops = {
>  	.parse_param = xfs_parse_param,
>  	.get_tree    = xfs_get_tree,
>  	.reconfigure = xfs_reconfigure,
> +	.free        = xfs_fc_free,
>  };
>  
>  static struct file_system_type xfs_fs_type = {
> 
