Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC53C3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 12:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 110F520828
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 12:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfH0Mm1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 08:42:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbfH0Mm1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Aug 2019 08:42:27 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 328083082B43;
        Tue, 27 Aug 2019 12:42:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E2F560BFB;
        Tue, 27 Aug 2019 12:42:26 +0000 (UTC)
Date:   Tue, 27 Aug 2019 08:42:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 07/15] xfs: mount-api - refactor xfs_fs_fill_super()
Message-ID: <20190827124224.GF10636@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652199438.2607.11044864070510345078.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156652199438.2607.11044864070510345078.stgit@fedora-28>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 27 Aug 2019 12:42:27 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 08:59:54AM +0800, Ian Kent wrote:
> Much of the code in xfs_fs_fill_super() will be used by the fill super
> function of the new mount-api.
> 
> So refactor the common code into a helper in an attempt to show what's
> actually changed.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |   65 ++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 42 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 7cdda17ee0ff..d3fc9938987d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
...
> @@ -1885,6 +1868,42 @@ xfs_fs_fill_super(
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
> +
> +	/*
> +	 * allocate mp and do all low-level struct initializations before we
> +	 * attach it to the super
> +	 */
> +	mp = xfs_mount_alloc(sb);
> +	if (!mp)
> +		goto out;
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
> +out:
> +	return error;

I know this is copied from the existing function, but there's really no
need for an out label here. We can just return -ENOMEM in the one user
above. Aside from that nit the rest looks fine to me.

Brian

> +}
> +
>  STATIC void
>  xfs_fs_put_super(
>  	struct super_block	*sb)
> 
