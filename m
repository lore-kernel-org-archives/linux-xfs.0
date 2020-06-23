Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA356C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 19:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D16207E8
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 19:47:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IvWF1W/s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387420AbgFWTrv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 15:47:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59544 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733220AbgFWTrv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 15:47:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592941669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5RCUhT3+bHdeyKEuG4wz3jVY4UlEWG0x4f4cHn8cig4=;
        b=IvWF1W/sOIEqekaxHGROlaAqtJWXtqsK5KRGLDwGsYo2qGvOlauHXGFGvZSrQB83w/2iSD
        TwH4hsqPoWQZvKIPQ+soOEZ08azKsyKtPVlujYQ4M6mjSV25l4ogLRf6vAvGopFhjhAfqa
        v/qYXNQxzZeLWsZZ4Nkb5W39PaOpMS8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-8Ha2YXNkMV6GlG_erQi7mQ-1; Tue, 23 Jun 2020 15:47:47 -0400
X-MC-Unique: 8Ha2YXNkMV6GlG_erQi7mQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B54B8018A5;
        Tue, 23 Jun 2020 19:47:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 035775D9D3;
        Tue, 23 Jun 2020 19:47:45 +0000 (UTC)
Date:   Tue, 23 Jun 2020 15:47:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use MMAPLOCK around filemap_map_pages()
Message-ID: <20200623194744.GC56510@bfoster>
References: <20200623052059.1893966-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623052059.1893966-1-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 03:20:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The page faultround path ->map_pages is implemented in XFS via
> filemap_map_pages(). This function checks that pages found in page
> cache lookups have not raced with truncate based invalidation by
> checking page->mapping is correct and page->index is within EOF.
> 
> However, we've known for a long time that this is not sufficient to
> protect against races with invalidations done by operations that do
> not change EOF. e.g. hole punching and other fallocate() based
> direct extent manipulations. The way we protect against these
> races is we wrap the page fault operations in a XFS_MMAPLOCK_SHARED
> lock so they serialise against fallocate and truncate before calling
> into the filemap function that processes the fault.
> 
> Do the same for XFS's ->map_pages implementation to close this
> potential data corruption issue.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks reasonable:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7b05f8fd7b3d..4b185a907432 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1266,10 +1266,23 @@ xfs_filemap_pfn_mkwrite(
>  	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
>  }
>  
> +static void
> +xfs_filemap_map_pages(
> +	struct vm_fault		*vmf,
> +	pgoff_t			start_pgoff,
> +	pgoff_t			end_pgoff)
> +{
> +	struct inode		*inode = file_inode(vmf->vma->vm_file);
> +
> +	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +	filemap_map_pages(vmf, start_pgoff, end_pgoff);
> +	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +}
> +
>  static const struct vm_operations_struct xfs_file_vm_ops = {
>  	.fault		= xfs_filemap_fault,
>  	.huge_fault	= xfs_filemap_huge_fault,
> -	.map_pages	= filemap_map_pages,
> +	.map_pages	= xfs_filemap_map_pages,
>  	.page_mkwrite	= xfs_filemap_page_mkwrite,
>  	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
>  };
> -- 
> 2.26.2.761.g0e0b3e54be
> 

