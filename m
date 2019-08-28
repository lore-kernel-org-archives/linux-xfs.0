Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E79C3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 13:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3390020828
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 13:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfH1N2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 09:28:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbfH1N2p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Aug 2019 09:28:45 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 28C083D966;
        Wed, 28 Aug 2019 13:28:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 732C65D9E2;
        Wed, 28 Aug 2019 13:28:44 +0000 (UTC)
Date:   Wed, 28 Aug 2019 09:28:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 13/15] xfs: mount-api - dont set sb in
 xfs_mount_alloc()
Message-ID: <20190828132842.GF16389@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652202737.2607.3093583575197287887.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156652202737.2607.3093583575197287887.stgit@fedora-28>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 28 Aug 2019 13:28:45 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 09:00:27AM +0800, Ian Kent wrote:
> When changing to use the new mount api the super block won't be
> available when the xfs_mount info struct is allocated so move
> setting the super block in xfs_mount to xfs_fs_fill_super().
> 
> Also change xfs_mount_alloc() decalaration static -> STATIC.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 9976163dc537..d2a1a62a3edc 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1766,9 +1766,9 @@ xfs_destroy_percpu_counters(
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
>  }
>  
> -static struct xfs_mount *
> +STATIC struct xfs_mount *
>  xfs_mount_alloc(
> -	struct super_block	*sb)
> +	void)

No need to have the void on a separate line. With that fixed up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  {
>  	struct xfs_mount	*mp;
>  
> @@ -1776,7 +1776,6 @@ xfs_mount_alloc(
>  	if (!mp)
>  		return NULL;
>  
> -	mp->m_super = sb;
>  	spin_lock_init(&mp->m_sb_lock);
>  	spin_lock_init(&mp->m_agirotor_lock);
>  	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
> @@ -1990,9 +1989,10 @@ xfs_fs_fill_super(
>  	 * allocate mp and do all low-level struct initializations before we
>  	 * attach it to the super
>  	 */
> -	mp = xfs_mount_alloc(sb);
> +	mp = xfs_mount_alloc();
>  	if (!mp)
>  		goto out;
> +	mp->m_super = sb;
>  	sb->s_fs_info = mp;
>  
>  	error = xfs_parseargs(mp, (char *)data);
> 
