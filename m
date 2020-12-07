Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3267C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4C8621D42
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725918AbgLGRsB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:48:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbgLGRsB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:48:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607363195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4aSBzBzTYH/m/0Ai/KK67lPgo7Z4mhIXknY4aYtPeeY=;
        b=GHxT8yiTaw2I0aZ668DhdQG/2zqImC/E/sYZeCga26GxjQaP5gHgwcqfxR5OLQNIt5GN3b
        FQfrsu9nkBxIEtwlyEDmd9jEv3Yxpkd5a4+DqjMspWgw/v52275AyIkPy+hP/BTgfZqwOd
        9ZNKC3jUiMekXJEmFHKiwPyZXOsLUhc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-zYfg138lOCSKqjyz5cfD8w-1; Mon, 07 Dec 2020 12:46:33 -0500
X-MC-Unique: zYfg138lOCSKqjyz5cfD8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED73A800D55;
        Mon,  7 Dec 2020 17:46:31 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C4625D9D0;
        Mon,  7 Dec 2020 17:46:31 +0000 (UTC)
Date:   Mon, 7 Dec 2020 12:46:29 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: rename xfs_fc_* back to xfs_fs_*
Message-ID: <20201207174629.GE1598552@bfoster>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
 <160729627541.1608297.18095324548384560045.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729627541.1608297.18095324548384560045.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:11:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Get rid of this one-off namespace since we're done converting things to
> fscontext now.
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_super.c |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 36002f460d7c..12d6850aedc6 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1159,7 +1159,7 @@ suffix_kstrtoint(
>   * NOTE: mp->m_super is NULL here!
>   */
>  static int
> -xfs_fc_parse_param(
> +xfs_fs_parse_param(
>  	struct fs_context	*fc,
>  	struct fs_parameter	*param)
>  {
> @@ -1317,7 +1317,7 @@ xfs_fc_parse_param(
>  }
>  
>  static int
> -xfs_fc_validate_params(
> +xfs_fs_validate_params(
>  	struct xfs_mount	*mp)
>  {
>  	/*
> @@ -1386,7 +1386,7 @@ xfs_fc_validate_params(
>  }
>  
>  static int
> -xfs_fc_fill_super(
> +xfs_fs_fill_super(
>  	struct super_block	*sb,
>  	struct fs_context	*fc)
>  {
> @@ -1396,7 +1396,7 @@ xfs_fc_fill_super(
>  
>  	mp->m_super = sb;
>  
> -	error = xfs_fc_validate_params(mp);
> +	error = xfs_fs_validate_params(mp);
>  	if (error)
>  		goto out_free_names;
>  
> @@ -1660,10 +1660,10 @@ xfs_fc_fill_super(
>  }
>  
>  static int
> -xfs_fc_get_tree(
> +xfs_fs_get_tree(
>  	struct fs_context	*fc)
>  {
> -	return get_tree_bdev(fc, xfs_fc_fill_super);
> +	return get_tree_bdev(fc, xfs_fs_fill_super);
>  }
>  
>  static int
> @@ -1782,7 +1782,7 @@ xfs_remount_ro(
>   * silently ignore all options that we can't actually change.
>   */
>  static int
> -xfs_fc_reconfigure(
> +xfs_fs_reconfigure(
>  	struct fs_context *fc)
>  {
>  	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
> @@ -1795,7 +1795,7 @@ xfs_fc_reconfigure(
>  	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
>  		fc->sb_flags |= SB_I_VERSION;
>  
> -	error = xfs_fc_validate_params(new_mp);
> +	error = xfs_fs_validate_params(new_mp);
>  	if (error)
>  		return error;
>  
> @@ -1832,7 +1832,7 @@ xfs_fc_reconfigure(
>  	return 0;
>  }
>  
> -static void xfs_fc_free(
> +static void xfs_fs_free(
>  	struct fs_context	*fc)
>  {
>  	struct xfs_mount	*mp = fc->s_fs_info;
> @@ -1848,10 +1848,10 @@ static void xfs_fc_free(
>  }
>  
>  static const struct fs_context_operations xfs_context_ops = {
> -	.parse_param = xfs_fc_parse_param,
> -	.get_tree    = xfs_fc_get_tree,
> -	.reconfigure = xfs_fc_reconfigure,
> -	.free        = xfs_fc_free,
> +	.parse_param = xfs_fs_parse_param,
> +	.get_tree    = xfs_fs_get_tree,
> +	.reconfigure = xfs_fs_reconfigure,
> +	.free        = xfs_fs_free,
>  };
>  
>  static int xfs_init_fs_context(
> 

