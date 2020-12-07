Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E65EC4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 18:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B74C423899
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 18:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbgLGSbh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:31:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgLGSbh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 13:31:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607365810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JtKKf2hesg8i1jyW9VWrZ25X8+cX/poG4E0YcQgggYc=;
        b=MzzhM0hKPVTH1Et8w86Y4g0cYgqb9AkA/jRE2YSOF0ypaQKi90DnZNajPMvmEBz7NrQXty
        NbrhMy3hEFZ+TEXOYKF2Y5V8imuUYRa/KvL5gWXesojD+vJLTa7up5E+cETSIS0t4LRxPo
        4eN9NLVb44UZC812gmEfSpqIcip1xx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-DYFFLGTPP7utz-nFWmnK3A-1; Mon, 07 Dec 2020 13:30:09 -0500
X-MC-Unique: DYFFLGTPP7utz-nFWmnK3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09C9C801B12;
        Mon,  7 Dec 2020 18:30:08 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 98EC119C59;
        Mon,  7 Dec 2020 18:30:07 +0000 (UTC)
Date:   Mon, 7 Dec 2020 13:30:05 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3.1 09/10] xfs: validate feature support when recovering
 rmap/refcount intents
Message-ID: <20201207183005.GF1598552@bfoster>
References: <160729618252.1607103.863261260798043728.stgit@magnolia>
 <160729624155.1607103.14703148264133630631.stgit@magnolia>
 <20201207182623.GR629293@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207182623.GR629293@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 10:26:23AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The rmap, and refcount log intent items were added to support the rmap
> and reflink features.  Because these features come with changes to the
> ondisk format, the log items aren't tied to a log incompat flag.
> 
> However, the log recovery routines don't actually check for those
> feature flags.  The kernel has no business replayng an intent item for a
> feature that isn't enabled, so check that as part of recovered log item
> validation.  (Note that kernels pre-dating rmap and reflink already fail
> log recovery on the unknown log item type code.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3.1: drop the feature check for BUI validation for now
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_refcount_item.c |    3 +++
>  fs/xfs/xfs_rmap_item.c     |    3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index c24f2da0f795..937d482c9be4 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -423,6 +423,9 @@ xfs_cui_validate_phys(
>  	struct xfs_mount		*mp,
>  	struct xfs_phys_extent		*refc)
>  {
> +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> +		return false;
> +
>  	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
>  		return false;
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 6f3250a22093..9b84017184d9 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -466,6 +466,9 @@ xfs_rui_validate_map(
>  	struct xfs_mount		*mp,
>  	struct xfs_map_extent		*rmap)
>  {
> +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		return false;
> +
>  	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
>  		return false;
>  
> 

