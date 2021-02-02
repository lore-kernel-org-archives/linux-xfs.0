Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2393EC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD4D264F4D
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239980AbhBBTjz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:39:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239909AbhBBTjm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 14:39:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612294695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=apQRbKjaMsrqhFnbfMwfDTMpfexpbyhPEIV1Epqv9TY=;
        b=jJxI0abA8ejvqmNb27KKe4rvYmGdp8JM441e3yRt/50h+QAMW/748U7oVlHtBo8aD5swt9
        O/FZtCrK4doWo7HcfuxakfluQWEVKUs+5cajMSR3qAiOn9bleelrLlkFk7mnBbyG6DyemN
        kOpqGFuohNRo7QyW6GCn+4MO/Mq9/jI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-cuBeqKfjNGS79BEKqHgUCQ-1; Tue, 02 Feb 2021 14:38:12 -0500
X-MC-Unique: cuBeqKfjNGS79BEKqHgUCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFCFC189DF4E;
        Tue,  2 Feb 2021 19:38:10 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F25965D749;
        Tue,  2 Feb 2021 19:38:06 +0000 (UTC)
Date:   Tue, 2 Feb 2021 14:38:04 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 3/7] xfs: update lazy sb counters immediately for
 resizefs
Message-ID: <20210202193804.GN3336100@bfoster>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126125621.3846735-4-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 26, 2021 at 08:56:17PM +0800, Gao Xiang wrote:
> sb_fdblocks will be updated lazily if lazysbcount is enabled,
> therefore when shrinking the filesystem sb_fdblocks could be
> larger than sb_dblocks and xfs_validate_sb_write() would fail.
> 
> Even for growfs case, it'd be better to update lazy sb counters
> immediately to reflect the real sb counters.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index a2a407039227..2e490fb75832 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -128,6 +128,14 @@ xfs_growfs_data_private(
>  				 nb - mp->m_sb.sb_dblocks);
>  	if (id.nfree)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> +
> +	/*
> +	 * update in-core counters now to reflect the real numbers
> +	 * (especially sb_fdblocks)
> +	 */

Could you update the comment to explain why we do this? For example:

"Sync sb counters now to reflect the updated values. This is
particularly important for shrink because the write verifier will fail
if sb_fdblocks is ever larger than sb_dblocks."

Brian

> +	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> +		xfs_log_sb(tp);
> +
>  	xfs_trans_set_sync(tp);
>  	error = xfs_trans_commit(tp);
>  	if (error)
> -- 
> 2.27.0
> 

