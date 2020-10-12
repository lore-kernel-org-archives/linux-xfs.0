Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D7EC433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 16:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BE012087E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 16:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HGrMvM32"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389885AbgJLQDb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 12:03:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389555AbgJLQDb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 12:03:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602518610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uRDGj2RVqIZPE5ebzMOEOh7a7tNn7UKz4S7zcqFOH9M=;
        b=HGrMvM32wty3g9cOlpuKP+1nyOHqtmjG7v/1nAUdQXNJHC1MZ7YU9oPymKK87AmnG0t8ye
        eOxa8lyOkNeFRCdNSZHcozuEAFMHPDbyBJzwRPofmRNpvo0zaMAoWNgOdxV9dLSvHYs/7v
        7Mcwlk4xbtVukSwxwwZKCu9/C2odZEg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-FtdUfH8fM6SkQK5BHHYCdg-1; Mon, 12 Oct 2020 12:03:28 -0400
X-MC-Unique: FtdUfH8fM6SkQK5BHHYCdg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB6BE879517
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 16:03:27 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 469E975261;
        Mon, 12 Oct 2020 16:03:27 +0000 (UTC)
Date:   Mon, 12 Oct 2020 12:03:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 3/4] xfs: xfs_isilocked() can only check a single
 lock type
Message-ID: <20201012160325.GJ917726@bfoster>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-4-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009195515.82889-4-preichl@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 09:55:14PM +0200, Pavel Reichl wrote:
> In its current form, xfs_isilocked() is only able to test one lock type
> at a time - ilock, iolock, or mmap lock, but combinations are not
> properly handled. The intent here is to check that both XFS_IOLOCK_EXCL
> and XFS_ILOCK_EXCL are held, so test them each separately.
> 
> The commit ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents") ORed the
> flags together which was an error, so this patch reverts that part of
> the change and check the locks independently.
> 
> Fixes: ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents")
> 
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ced3b996cd8a..ff5cc8a5d476 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5787,7 +5787,8 @@ xfs_bmap_collapse_extents(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>  		error = xfs_iread_extents(tp, ip, whichfork);
> @@ -5904,7 +5905,8 @@ xfs_bmap_insert_extents(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>  		error = xfs_iread_extents(tp, ip, whichfork);
> -- 
> 2.26.2
> 

