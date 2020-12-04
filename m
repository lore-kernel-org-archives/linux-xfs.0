Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A07DC4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AEE422AB9
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbgLDOBo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 09:01:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726986AbgLDOBo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 09:01:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607090417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K40OxmU/K08JYI6iOiLAQ/rEhkzywn2zAQ4g0opEgfU=;
        b=hfxFko53KtSYc5KJG6PIBHSqnV2ufe98F9ZMdG46QpqAa4ftj4RVWbOEmhDlKeFaunttq1
        QotZ3P36GLva4DWZF+7wQNFZ86bGvTuNdh1svzBDMSSIkBXVU6clTYM0DegXWOUAZg9CAn
        8nW0LUqzX4QcsWRC5iq5mBdyLl3HPo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-vcXG6HkoO6qUEvzeK14ZSw-1; Fri, 04 Dec 2020 09:00:16 -0500
X-MC-Unique: vcXG6HkoO6qUEvzeK14ZSw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11536858180;
        Fri,  4 Dec 2020 14:00:15 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82BE66091A;
        Fri,  4 Dec 2020 14:00:14 +0000 (UTC)
Date:   Fri, 4 Dec 2020 09:00:12 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: improve the code that checks recovered
 refcount intent items
Message-ID: <20201204140012.GH1404170@bfoster>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704433239.734470.17983823126192826984.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704433239.734470.17983823126192826984.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 05:12:12PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The code that validates recovered refcount intent items is kind of a
> mess -- it doesn't use the standard xfs type validators, and it doesn't
> check for things that it should.  Fix the validator function to use the
> standard validation helpers and look for more types of obvious errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_refcount_item.c |   23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index a456a2fb794c..8ad6c81f6d8f 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -423,27 +423,26 @@ xfs_cui_validate_phys(
>  	struct xfs_mount		*mp,
>  	struct xfs_phys_extent		*refc)
>  {
> -	xfs_fsblock_t			startblock_fsb;
> -	bool				op_ok;
> +	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
> +		return false;
>  
> -	startblock_fsb = XFS_BB_TO_FSB(mp,
> -			   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
>  	switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
>  	case XFS_REFCOUNT_INCREASE:
>  	case XFS_REFCOUNT_DECREASE:
>  	case XFS_REFCOUNT_ALLOC_COW:
>  	case XFS_REFCOUNT_FREE_COW:
> -		op_ok = true;
>  		break;
>  	default:
> -		op_ok = false;
> -		break;
> +		return false;
>  	}
> -	if (!op_ok || startblock_fsb == 0 ||
> -	    refc->pe_len == 0 ||
> -	    startblock_fsb >= mp->m_sb.sb_dblocks ||
> -	    refc->pe_len >= mp->m_sb.sb_agblocks ||
> -	    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
> +
> +	if (refc->pe_startblock + refc->pe_len <= refc->pe_startblock)
> +		return false;
> +
> +	if (!xfs_verify_fsbno(mp, refc->pe_startblock))
> +		return false;
> +
> +	if (!xfs_verify_fsbno(mp, refc->pe_startblock + refc->pe_len - 1))
>  		return false;
>  
>  	return true;
> 

