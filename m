Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47791C433E9
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 15:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D81864F6A
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 15:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbhBBPoK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 10:44:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30049 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235107AbhBBPk4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 10:40:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612280370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GZSGInIZpMS+pE4zUnSiXU7R6wPWpSm3gP0pj7ylNys=;
        b=ejdQIubBluGZuC+DT+ns+zCDlBNhe9L6btBzjwcCI/71kl5o1PRuoF6UWbIfh1ltjAI+a/
        rfI7zBWJsAuDmdPKQf7+rOBSMLE4hZSQySPWcpfGlwtMPlNYI8Umkil+Pi7rQhP/R/ODlj
        /dntJBWclyElGJQcKMFEKNcAxHj98K0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-l4LaM6b0NGygdutcyqJJdw-1; Tue, 02 Feb 2021 10:39:26 -0500
X-MC-Unique: l4LaM6b0NGygdutcyqJJdw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6B448049C9;
        Tue,  2 Feb 2021 15:39:24 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 444DE50A80;
        Tue,  2 Feb 2021 15:39:24 +0000 (UTC)
Date:   Tue, 2 Feb 2021 10:39:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 12/12] xfs: flush speculative space allocations when we
 run out of space
Message-ID: <20210202153922.GJ3336100@bfoster>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
 <161214519414.140945.335722903527111632.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214519414.140945.335722903527111632.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 31, 2021 at 06:06:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a fs modification (creation, file write, reflink, etc.) is unable to
> reserve enough space to handle the modification, try clearing whatever
> space the filesystem might have been hanging onto in the hopes of
> speeding up the filesystem.  The flushing behavior will become
> particularly important when we add deferred inode inactivation because
> that will increase the amount of space that isn't actively tied to user
> data.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_trans.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 3203841ab19b..973354647298 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -289,6 +289,17 @@ xfs_trans_alloc(
>  	tp->t_firstblock = NULLFSBLOCK;
>  
>  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> +	if (error == -ENOSPC) {
> +		/*
> +		 * We weren't able to reserve enough space for the transaction.
> +		 * Flush the other speculative space allocations to free space.
> +		 * Do not perform a synchronous scan because callers can hold
> +		 * other locks.
> +		 */
> +		error = xfs_blockgc_free_space(mp, NULL);
> +		if (!error)
> +			error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> +	}
>  	if (error) {
>  		xfs_trans_cancel(tp);
>  		return error;
> 

