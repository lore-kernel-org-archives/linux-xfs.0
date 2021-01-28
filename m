Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790E4C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 15:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47E2064DF3
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 15:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhA1Pfp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 10:35:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54401 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231171AbhA1Pfp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 10:35:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611848058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8iTIHcurqnmQxoCwGXTOI5XEQjqkWZrT+XJVgPrBnf8=;
        b=fB1zwoV+PsASqoBAZQq1tz89EGX7ikh3/u7i2XjNwqE1GKu/niYgwKwLR9twIMl6LfLKVH
        +wmud9JlXrQftdVt+41Ts5kop2n3PQcR8JD0OrSF0lOYUtRKctfw4WohVSFMznseQH7rfg
        Eh4mS1Sw7wb7rQsVOGtMRR3qF+ktRiA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-tJAah06RNguNxAyYA5-hOw-1; Thu, 28 Jan 2021 10:34:15 -0500
X-MC-Unique: tJAah06RNguNxAyYA5-hOw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2768180A094;
        Thu, 28 Jan 2021 15:34:14 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 04F5A1A7C1;
        Thu, 28 Jan 2021 15:34:13 +0000 (UTC)
Date:   Thu, 28 Jan 2021 10:34:12 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org,
        allison.henderson@oracle.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] xfs: Fix 'set but not used' warning in
 xfs_bmap_compute_alignments()
Message-ID: <20210128153412.GD2599027@bfoster>
References: <20210127090537.2640164-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127090537.2640164-1-chandanrlinux@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 02:35:37PM +0530, Chandan Babu R wrote:
> With both CONFIG_XFS_DEBUG and CONFIG_XFS_WARN disabled, the only reference to
> local variable "error" in xfs_bmap_compute_alignments() gets eliminated during
> pre-processing stage of the compilation process. This causes the compiler to
> generate a "set but not used" warning.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
> This patch is applicable on top of current xfs-linux/for-next branch.
> 
>  fs/xfs/libxfs/xfs_bmap.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 2cd24bb06040..ba56554e8c05 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3471,7 +3471,6 @@ xfs_bmap_compute_alignments(
>  	struct xfs_mount	*mp = args->mp;
>  	xfs_extlen_t		align = 0; /* minimum allocation alignment */
>  	int			stripe_align = 0;
> -	int			error;
>  
>  	/* stripe alignment for allocation is determined by mount parameters */
>  	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> @@ -3484,10 +3483,10 @@ xfs_bmap_compute_alignments(
>  	else if (ap->datatype & XFS_ALLOC_USERDATA)
>  		align = xfs_get_extsz_hint(ap->ip);
>  	if (align) {
> -		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> -						align, 0, ap->eof, 0, ap->conv,
> -						&ap->offset, &ap->length);
> -		ASSERT(!error);
> +		if (xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> +			align, 0, ap->eof, 0, ap->conv, &ap->offset,
> +			&ap->length))
> +			ASSERT(0);

I was wondering if we should just make xfs_bmap_extsize_align() return
void and push the asserts down into the function itself, but it looks
like xfs_bmap_rtalloc() actually handles the error. Any idea on why we
might have that inconsistency?

Brian

>  		ASSERT(ap->length);
>  	}
>  
> -- 
> 2.29.2
> 

