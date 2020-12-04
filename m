Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79726C4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4195522AB0
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgLDOB6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 09:01:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726986AbgLDOB6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 09:01:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607090432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VKU6M/+spIePwwr7+xa/mYI8Oe00gVzAPVP3aFuUGfI=;
        b=gVb/jhoWbO2n34elurER/+ppiAd67rolCmit4G3oqneaNYSTndRcV+A2lgYeE8q314Mj1T
        WKnqxvKwSNGYzNLPTIWMszTiQ48LzCnCoe8uAm/41PI9+gWtjv3zxAEFSSArHR2mR0HPUF
        sjquS7yXnNzZiQ8tAWRN7HTeqThirD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-CVANHaO9OF-Vrk2rhDskkg-1; Fri, 04 Dec 2020 09:00:31 -0500
X-MC-Unique: CVANHaO9OF-Vrk2rhDskkg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9150107ACE3;
        Fri,  4 Dec 2020 14:00:29 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 79A1560873;
        Fri,  4 Dec 2020 14:00:29 +0000 (UTC)
Date:   Fri, 4 Dec 2020 09:00:27 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs: improve the code that checks recovered
 extent-free intent items
Message-ID: <20201204140027.GJ1404170@bfoster>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704434468.734470.4218774098966086059.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704434468.734470.4218774098966086059.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 05:12:24PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The code that validates recovered extent-free intent items is kind of a
> mess -- it doesn't use the standard xfs type validators, and it doesn't
> check for things that it should.  Fix the validator function to use the
> standard validation helpers and look for more types of obvious errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_extfree_item.c |   13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 5e0f0b0a6c83..e5356ed879a0 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -584,14 +584,13 @@ xfs_efi_validate_ext(
>  	struct xfs_mount		*mp,
>  	struct xfs_extent		*extp)
>  {
> -	xfs_fsblock_t			startblock_fsb;
> +	if (extp->ext_start + extp->ext_len <= extp->ext_start)
> +		return false;
>  
> -	startblock_fsb = XFS_BB_TO_FSB(mp,
> -			   XFS_FSB_TO_DADDR(mp, extp->ext_start));
> -	if (startblock_fsb == 0 ||
> -	    extp->ext_len == 0 ||
> -	    startblock_fsb >= mp->m_sb.sb_dblocks ||
> -	    extp->ext_len >= mp->m_sb.sb_agblocks)
> +	if (!xfs_verify_fsbno(mp, extp->ext_start))
> +		return false;
> +
> +	if (!xfs_verify_fsbno(mp, extp->ext_start + extp->ext_len - 1))
>  		return false;
>  
>  	return true;
> 

