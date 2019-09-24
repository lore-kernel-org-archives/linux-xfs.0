Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F05C432C2
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 14:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D1D12053B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 14:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfIXOiO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 10:38:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbfIXOiO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 10:38:14 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 57E2A10C0947;
        Tue, 24 Sep 2019 14:38:14 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A78925D9E2;
        Tue, 24 Sep 2019 14:38:13 +0000 (UTC)
Date:   Tue, 24 Sep 2019 10:38:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [REPOST PATCH v3 08/16] xfs: mount-api - refactor
 xfs_fs_fill_super()
Message-ID: <20190924143811.GC17688@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
 <156933136376.20933.15291550203661966809.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156933136376.20933.15291550203661966809.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 24 Sep 2019 14:38:14 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 24, 2019 at 09:22:43PM +0800, Ian Kent wrote:
> Much of the code in xfs_fs_fill_super() will be used by the fill super
> function of the new mount-api.
> 
> So refactor the common code into a helper in an attempt to show what's
> actually changed.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |   64 +++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 41 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index cfda58dd3822..ea3640ffd8f5 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
...
> @@ -1915,6 +1898,41 @@ xfs_fs_fill_super(
>  	goto out_free_sb;
>  }
>  
> +STATIC int
> +xfs_fs_fill_super(
> +	struct super_block	*sb,
> +	void			*data,
> +	int			silent)
> +{
> +	struct xfs_mount	*mp = NULL;
> +	int			error = -ENOMEM;

Both variable initializations are unnecessary. With those fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +	/*
> +	 * allocate mp and do all low-level struct initializations before we
> +	 * attach it to the super
> +	 */
> +	mp = xfs_mount_alloc(sb);
> +	if (!mp)
> +		return -ENOMEM;
> +	sb->s_fs_info = mp;
> +
> +	error = xfs_parseargs(mp, (char *)data);
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
> +}
> +
>  STATIC void
>  xfs_fs_put_super(
>  	struct super_block	*sb)
> 
