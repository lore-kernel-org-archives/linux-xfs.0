Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DFFC433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A72722EBF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbhAZFSa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:18:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46014 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730306AbhAYPn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 10:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611589321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J6SR6h1sVJ4bXZHQwx2cYLljAFZKIfdHR5aeC3nMlsQ=;
        b=TTQYqAcNrGtB0G1EDi5Ybo4IS1FzV/s1UYDmNYBr72xVC/q3RfYXRCKxj86zCAVM4ovWOQ
        mvzuVDwJdjGgHJlhgfThNsTeO8ISItxnhzhS59auXBeaasoxhohFkk/coX9CJz3oq9LhbK
        hakrnvWgpWZYVVcAM8mFgs2RNvk8g+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-h4pi8v9hPfK-HWPK2BIrdg-1; Mon, 25 Jan 2021 10:17:25 -0500
X-MC-Unique: h4pi8v9hPfK-HWPK2BIrdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AAB7803620;
        Mon, 25 Jan 2021 15:17:24 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3D9C10013BD;
        Mon, 25 Jan 2021 15:17:23 +0000 (UTC)
Date:   Mon, 25 Jan 2021 10:17:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 4/4] xfs: clean up icreate quota reservation calls
Message-ID: <20210125151722.GF2047559@bfoster>
References: <161142789504.2170981.1372317837643770452.stgit@magnolia>
 <161142791730.2170981.16295389347749875438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142791730.2170981.16295389347749875438.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:51:57AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a proper helper so that inode creation calls can reserve quota
> with a dedicated function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_inode.c       |    8 ++++----
>  fs/xfs/xfs_quota.h       |   15 +++++++++++----
>  fs/xfs/xfs_symlink.c     |    4 ++--
>  fs/xfs/xfs_trans_dquot.c |   21 +++++++++++++++++++++
>  4 files changed, 38 insertions(+), 10 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 28b8ac701919..3315498a6fa1 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -804,6 +804,27 @@ xfs_trans_reserve_quota_nblks(
>  						nblks, ninos, flags);
>  }
>  
> +/* Change the quota reservations for an inode creation activity. */
> +int
> +xfs_trans_reserve_quota_icreate(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
> +	struct xfs_dquot	*udqp,
> +	struct xfs_dquot	*gdqp,
> +	struct xfs_dquot	*pdqp,
> +	int64_t			nblks)
> +{
> +	struct xfs_mount	*mp = dp->i_mount;
> +
> +	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> +		return 0;
> +
> +	ASSERT(!xfs_is_quota_inode(&mp->m_sb, dp->i_ino));
> +
> +	return xfs_trans_reserve_quota_bydquots(tp, dp->i_mount, udqp, gdqp,
> +			pdqp, nblks, 1, XFS_QMOPT_RES_REGBLKS);

Considering we can get mp from tp (and it looks like we always pass tp),
is it worth even passing in dp for an (unlikely) assert? That seems a
little odd anyways since nothing down in this path actually uses or
cares about the parent inode. Also, no need to pass dp->i_mount above if
we've already defined mp, at least.

Brian

> +}
> +
>  /*
>   * This routine is called to allocate a quotaoff log item.
>   */
> 

