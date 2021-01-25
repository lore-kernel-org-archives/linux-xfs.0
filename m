Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9594DC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53BBE22273
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731686AbhAZFSQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:18:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20584 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730069AbhAYPij (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 10:38:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611589031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cfGGj8BGBOiClxwtSoFcfv8TZ4J5WZpGO4xb9jloAog=;
        b=gEeB7DAGlyjkNDSQuPfUzu14x/FSnAs1NJMJ1JF3G4SBfKWTN16AqXV4n/iMQQraVHYrk3
        848DhjW/PHH+Ri8FG9d1h1jAABnLUYL+PC+ATX8Yzio6iVyYJJfPQVwj0odgKiDIcPEzAq
        5bAku9qUXkuRc7m2rSBQJ4cTkkCPUTA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-SN49PsToP-ybjwtYZ1VW0w-1; Mon, 25 Jan 2021 10:13:56 -0500
X-MC-Unique: SN49PsToP-ybjwtYZ1VW0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5C291009446;
        Mon, 25 Jan 2021 15:13:54 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B2D960C0F;
        Mon, 25 Jan 2021 15:13:54 +0000 (UTC)
Date:   Mon, 25 Jan 2021 10:13:52 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 2/4] xfs: clean up quota reservation wrappers
Message-ID: <20210125151352.GD2047559@bfoster>
References: <161142789504.2170981.1372317837643770452.stgit@magnolia>
 <161142790628.2170981.7372348604132126587.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142790628.2170981.7372348604132126587.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:51:46AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace a couple of quota reservation macros with properly typechecked
> static inline functions ahead of more restructuring in the next patches.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_quota.h |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index 5a62398940d0..bd28d17941e7 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -151,8 +151,13 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
>  #define xfs_qm_unmount_quotas(mp)
>  #endif /* CONFIG_XFS_QUOTA */
>  
> -#define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
> -	xfs_trans_reserve_quota_nblks(tp, ip, -(nblks), -(ninos), flags)
> +static inline int
> +xfs_trans_unreserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
> +		int64_t nblks, long ninos, unsigned int flags)
> +{
> +	return xfs_trans_reserve_quota_nblks(tp, ip, -nblks, -ninos, flags);
> +}
> +
>  #define xfs_trans_reserve_quota(tp, mp, ud, gd, pd, nb, ni, f) \
>  	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
>  				f | XFS_QMOPT_RES_REGBLKS)
> 

