Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BB2C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2133022AB0
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgLDOBa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 09:01:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726986AbgLDOB3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 09:01:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607090403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mAznj9xs0RkiBkyELRt1Zws08S8OWf87MPXB6oJ8VfQ=;
        b=Jltuc75ZGM4BhHNl4gbXZmfnU1g5fOAlbHuGm6eCUOYMKztWbNKGSboggsiexwseGtwZoD
        p+2WVTFu+/NC/a5QWyCowPbHUU4Ua5wBl+W3vRsyJbTiBq7RtlBxDg6LhswS9nOOkwhRPV
        Gs1esiqE0EEpnKR2PiPO7rCN6HQ9cJI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-qdgRsp4aMMGu4TWauprrSA-1; Fri, 04 Dec 2020 09:00:01 -0500
X-MC-Unique: qdgRsp4aMMGu4TWauprrSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DE11858182;
        Fri,  4 Dec 2020 14:00:00 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFE725C230;
        Fri,  4 Dec 2020 13:59:59 +0000 (UTC)
Date:   Fri, 4 Dec 2020 08:59:58 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: improve the code that checks recovered rmap
 intent items
Message-ID: <20201204135958.GF1404170@bfoster>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704432023.734470.2330496983684892697.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704432023.734470.2330496983684892697.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 05:12:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The code that validates recovered rmap intent items is kind of a mess --
> it doesn't use the standard xfs type validators, and it doesn't check
> for things that it should.  Fix the validator function to use the
> standard validation helpers and look for more types of obvious errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_rmap_item.c |   30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index d77d104d93c6..f296ec349936 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -466,11 +466,9 @@ xfs_rui_validate_map(
>  	struct xfs_mount		*mp,
>  	struct xfs_map_extent		*rmap)
>  {
> -	xfs_fsblock_t			startblock_fsb;
> -	bool				op_ok;
> +	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
> +		return false;
>  
> -	startblock_fsb = XFS_BB_TO_FSB(mp,
> -			   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
>  	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
>  	case XFS_RMAP_EXTENT_MAP:
>  	case XFS_RMAP_EXTENT_MAP_SHARED:
> @@ -480,17 +478,25 @@ xfs_rui_validate_map(
>  	case XFS_RMAP_EXTENT_CONVERT_SHARED:
>  	case XFS_RMAP_EXTENT_ALLOC:
>  	case XFS_RMAP_EXTENT_FREE:
> -		op_ok = true;
>  		break;
>  	default:
> -		op_ok = false;
> -		break;
> +		return false;
>  	}
> -	if (!op_ok || startblock_fsb == 0 ||
> -	    rmap->me_len == 0 ||
> -	    startblock_fsb >= mp->m_sb.sb_dblocks ||
> -	    rmap->me_len >= mp->m_sb.sb_agblocks ||
> -	    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
> +
> +	if (!XFS_RMAP_NON_INODE_OWNER(rmap->me_owner) &&
> +	    !xfs_verify_ino(mp, rmap->me_owner))
> +		return false;
> +
> +	if (rmap->me_startoff + rmap->me_len <= rmap->me_startoff)
> +		return false;
> +
> +	if (rmap->me_startblock + rmap->me_len <= rmap->me_startblock)
> +		return false;
> +
> +	if (!xfs_verify_fsbno(mp, rmap->me_startblock))
> +		return false;
> +
> +	if (!xfs_verify_fsbno(mp, rmap->me_startblock + rmap->me_len - 1))
>  		return false;
>  
>  	return true;
> 

