Return-Path: <SRS0=GEoz=YA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E317DC47404
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 11:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 845892173B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 11:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfJGLwJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 07:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50476 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbfJGLwJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Oct 2019 07:52:09 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F242B7BDA9;
        Mon,  7 Oct 2019 11:52:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A8C635D6D0;
        Mon,  7 Oct 2019 11:52:06 +0000 (UTC)
Date:   Mon, 7 Oct 2019 07:52:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 15/17] xfs: mount-api - dont set sb in
 xfs_mount_alloc()
Message-ID: <20191007115204.GC22140@bfoster>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
 <157009839813.13858.13423160432971704368.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157009839813.13858.13423160432971704368.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 07 Oct 2019 11:52:09 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 03, 2019 at 06:26:38PM +0800, Ian Kent wrote:
> When changing to use the new mount api the super block won't be
> available when the xfs_mount info struct is allocated so move
> setting the super block in xfs_mount to xfs_fs_fill_super().
> 
> Also change xfs_mount_alloc() decalaration static -> STATIC.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_super.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 4f2963ff9e06..919afd7082b7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1772,9 +1772,8 @@ xfs_destroy_percpu_counters(
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
>  }
>  
> -static struct xfs_mount *
> -xfs_mount_alloc(
> -	struct super_block	*sb)
> +STATIC struct xfs_mount *
> +xfs_mount_alloc(void)
>  {
>  	struct xfs_mount	*mp;
>  
> @@ -1782,7 +1781,6 @@ xfs_mount_alloc(
>  	if (!mp)
>  		return NULL;
>  
> -	mp->m_super = sb;
>  	spin_lock_init(&mp->m_sb_lock);
>  	spin_lock_init(&mp->m_agirotor_lock);
>  	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
> @@ -1996,9 +1994,10 @@ xfs_fs_fill_super(
>  	 * allocate mp and do all low-level struct initializations before we
>  	 * attach it to the super
>  	 */
> -	mp = xfs_mount_alloc(sb);
> +	mp = xfs_mount_alloc();
>  	if (!mp)
>  		return -ENOMEM;
> +	mp->m_super = sb;
>  	sb->s_fs_info = mp;
>  
>  	error = xfs_parseargs(mp, (char *)data);
> 
