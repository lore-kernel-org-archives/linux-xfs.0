Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E4DC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 11:28:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC3326191F
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 11:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCVL1w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 07:27:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230055AbhCVL1j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 07:27:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616412458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KsqmzWyXpLgnMPRE5oV2kLHzwKn8EP5k6pXY8SMLuLk=;
        b=TuhhLX1rMVgGtpffm8Pxb0q4dt01ypI3KDuEyYhuaQdYemBM9L+OdCHH9+PTDy55Azu6/z
        S6iUY03nZyiSvyVon5QbdN6Lbou5p7ffcsKEury0HbVrm5iMjJKRhx7aeDRzPqwIImxoiq
        9O1uCxt/zll2JqaUeXIoiaufq0KCT6Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-GJgjC0dyOm2I2_2oSomorQ-1; Mon, 22 Mar 2021 07:27:35 -0400
X-MC-Unique: GJgjC0dyOm2I2_2oSomorQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C976A81A281;
        Mon, 22 Mar 2021 11:27:33 +0000 (UTC)
Received: from bfoster (ovpn-112-29.rdu2.redhat.com [10.10.112.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F06F26A8EC;
        Mon, 22 Mar 2021 11:27:28 +0000 (UTC)
Date:   Mon, 22 Mar 2021 07:27:27 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 1/5] xfs: update lazy sb counters immediately for
 resizefs
Message-ID: <YFh/H/5hXCNRNWWJ@bfoster>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305025703.3069469-2-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 10:56:59AM +0800, Gao Xiang wrote:
> sb_fdblocks will be updated lazily if lazysbcount is enabled,
> therefore when shrinking the filesystem sb_fdblocks could be
> larger than sb_dblocks and xfs_validate_sb_write() would fail.
> 
> Even for growfs case, it'd be better to update lazy sb counters
> immediately to reflect the real sb counters.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_fsops.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index a2a407039227..9f9ba8bd0213 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -128,6 +128,15 @@ xfs_growfs_data_private(
>  				 nb - mp->m_sb.sb_dblocks);
>  	if (id.nfree)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> +
> +	/*
> +	 * Sync sb counters now to reflect the updated values. This is
> +	 * particularly important for shrink because the write verifier
> +	 * will fail if sb_fdblocks is ever larger than sb_dblocks.
> +	 */
> +	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> +		xfs_log_sb(tp);
> +
>  	xfs_trans_set_sync(tp);
>  	error = xfs_trans_commit(tp);
>  	if (error)
> -- 
> 2.27.0
> 

