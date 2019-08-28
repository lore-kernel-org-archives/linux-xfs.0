Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6634BC3A5A4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 13:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D9BF20828
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 13:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfH1N21 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 09:28:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44724 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbfH1N2Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Aug 2019 09:28:24 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6535E308219F;
        Wed, 28 Aug 2019 13:28:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B24831001B05;
        Wed, 28 Aug 2019 13:28:23 +0000 (UTC)
Date:   Wed, 28 Aug 2019 09:28:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 12/15] xfs: mount-api - add xfs_fc_free()
Message-ID: <20190828132822.GE16389@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652202212.2607.8621137631843273531.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156652202212.2607.8621137631843273531.stgit@fedora-28>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 28 Aug 2019 13:28:24 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 09:00:22AM +0800, Ian Kent wrote:
> Add the fs_context_operations method .free that performs fs
> context cleanup on context release.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |   22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index aae0098fecab..9976163dc537 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2129,10 +2129,32 @@ static const struct super_operations xfs_super_operations = {
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
>  };
>  
> +static void xfs_fc_free(struct fs_context *fc)
> +{
> +	struct xfs_fs_context	*ctx = fc->fs_private;
> +	struct xfs_mount	*mp = fc->s_fs_info;
> +
> +	if (mp) {
> +		/*
> +		 * If an error occurs before ownership the xfs_mount
> +		 * info struct is passed to xfs by the VFS (by assigning
> +		 * it to sb->s_fs_info and clearing the corresponding
> +		 * fs_context field, which is done before calling fill
> +		 * super via .get_tree()) there may be some strings to
> +		 * cleanup.
> +		 */

The code looks straightforward but I find the comment confusing. How can
the VFS pass ownership of the xfs_mount if it's an XFS private data
structure?

> +		kfree(mp->m_logname);
> +		kfree(mp->m_rtname);
> +		kfree(mp);
> +	}
> +	kfree(ctx);

Also, should we at least reassign associated fc pointers to NULL if we
have multiple places to free things like ctx or mp?

Brian

> +}
> +
>  static const struct fs_context_operations xfs_context_ops = {
>  	.parse_param = xfs_parse_param,
>  	.get_tree    = xfs_get_tree,
>  	.reconfigure = xfs_reconfigure,
> +	.free	     = xfs_fc_free,
>  };
>  
>  static struct file_system_type xfs_fs_type = {
> 
