Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC527C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85365206E2
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JflklIOA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbgCPNRV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:17:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50765 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731033AbgCPNRV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 09:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584364640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xt77JPjdalrswVNJPNwUmI94KJCRZQMkzoQjWdin/tM=;
        b=JflklIOAUM5Bh+4SVLiz+grZB++6oLhG7PgQYofl6cRhkm4Jkigk/RZ1dXoCJ6IyGh7LTR
        djxZs6rQejpi67WGX99bmS7e7uCCp3LvVC0mD9FYgMejPwo65K0kbOSSqhG3idhsxF6SpL
        YiyNNP6Kh4qvQoGfdl0GrM+bF6Zg4MY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408--LebTytFMum7lsWpj0Zlww-1; Mon, 16 Mar 2020 09:17:18 -0400
X-MC-Unique: -LebTytFMum7lsWpj0Zlww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 498A31005510;
        Mon, 16 Mar 2020 13:17:17 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 028D05C1B2;
        Mon, 16 Mar 2020 13:17:16 +0000 (UTC)
Date:   Mon, 16 Mar 2020 09:17:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: simplify a check in
 xfs_ioctl_setattr_check_cowextsize
Message-ID: <20200316131715.GG12313@bfoster>
References: <20200312142235.550766-1-hch@lst.de>
 <20200312142235.550766-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312142235.550766-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:22:33PM +0100, Christoph Hellwig wrote:
> Only v5 file systems can have the reflink feature, and those will
> always use the large dinode format.  Remove the extra check for the
> inode version.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 5a1d2b9cb05a..ad825ffa7e4c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1473,8 +1473,7 @@ xfs_ioctl_setattr_check_cowextsize(
>  	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
>  		return 0;
>  
> -	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
> -	    ip->i_d.di_version != 3)
> +	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
>  		return -EINVAL;
>  
>  	if (fa->fsx_cowextsize == 0)
> -- 
> 2.24.1
> 

