Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5E8C2D0FA
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 13:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 110AD20657
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 13:29:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JHNv7SCN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbgEMN3K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 09:29:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29139 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729309AbgEMN3K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 09:29:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589376549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pOwx14FGJ6dB9UfzXjhZTHkoq20fuY/tcXO6FqODSMs=;
        b=JHNv7SCN4rEREmKKCcje6APF1dqjMipxmmayWhmHScPF57cRzp5ybI4/wSbzAhmzcLwiX0
        47GBbw9Yoe/EEFUZClm8+RDv3o4B4X5VUb2gXHiZJ8iit2Y6dHotk/58y+5dZtyDm9XV9N
        vF3kQt4BlkFR6ine6vB3ZDp5y/k60xs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-SbHmL0KBPOeZPb5Mi6dNBg-1; Wed, 13 May 2020 09:29:07 -0400
X-MC-Unique: SbHmL0KBPOeZPb5Mi6dNBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58DB41005512;
        Wed, 13 May 2020 13:29:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E693A6A963;
        Wed, 13 May 2020 13:29:05 +0000 (UTC)
Date:   Wed, 13 May 2020 09:29:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: fix error code in xfs_iflush_cluster()
Message-ID: <20200513132904.GE44225@bfoster>
References: <20200513094803.GF347693@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513094803.GF347693@mwanda>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 12:48:03PM +0300, Dan Carpenter wrote:
> Originally this function used to always return -EFSCORRUPTED on error
> but now we're trying to return more informative error codes.
> Unfortunately, there was one error path missed.  If this kmem_alloc()
> allocation fails then we need to return -ENOMEM instead of success.
> 
> Fixes: f20192991d79 ("xfs: simplify inode flush error handling")

This logic predates that patch, and I think it may be by design. Inode
cluster flushing is an optimization to flush other dirty inodes in the
same cluster we're about to queue for writeback. If the cluster flush
fails due to an operational error such as memory allocation failure, we
don't want to report an error because that would shutdown the fs when
otherwise the side effect would be that the other inodes in the cluster
would be flushed individually. This is distinct from failing to flush a
particular inode due to corruption, which is a fatal filesystem error.

Brian

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ab31a5dec7aab..63aeda7cbafb0 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3505,8 +3505,10 @@ xfs_iflush_cluster(
>  
>  	cilist_size = igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
>  	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
> -	if (!cilist)
> +	if (!cilist) {
> +		error = -ENOMEM;
>  		goto out_put;
> +	}
>  
>  	mask = ~(igeo->inodes_per_cluster - 1);
>  	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
> -- 
> 2.26.2
> 

