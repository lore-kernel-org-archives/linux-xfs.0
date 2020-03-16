Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796F1C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 15:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CBB820674
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 15:41:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bKxIRJkI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731553AbgCPPlQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 11:41:16 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:31427 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731554AbgCPPlQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 11:41:16 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 11:41:15 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584373275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rJox+YAC71nmg8o3tib7ZfMynCiIb87OC8QRto74plE=;
        b=bKxIRJkIQCcpJVUNwImbpAMd5IMSrrP9TZHFDVOZorysYmlcBLE42KXQOoqm1SmrYrPUEL
        QY4Rb1hM3LEeld/uPih5a1VhjiesmdFKFH3J4FrSOgEHqxJSxwWrxAHBjWfXxe1UUnbdCl
        JWuG5s8BbDW725m6nRW2/fpz1+fP+8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-D97Oh0c-PxKUIDLX7N4vbQ-1; Mon, 16 Mar 2020 11:34:57 -0400
X-MC-Unique: D97Oh0c-PxKUIDLX7N4vbQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38AE18C628C;
        Mon, 16 Mar 2020 15:34:56 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D2AAB60BE2;
        Mon, 16 Mar 2020 15:34:55 +0000 (UTC)
Date:   Mon, 16 Mar 2020 11:34:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix incorrect test in xfs_alloc_ag_vextent_lastblock
Message-ID: <20200316153453.GA17967@bfoster>
References: <20200316153155.GE256767@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316153155.GE256767@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 08:31:55AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When I lifted the code in xfs_alloc_ag_vextent_lastblock out of a loop,
> I forgot to convert all the accesses to len to be pointer dereferences.
> 
> Coverity-id: 1457918
> Fixes: 5113f8ec3753ed ("xfs: clean up weird while loop in xfs_alloc_ag_vextent_near")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 337822115bbc..203e74fa64aa 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1514,7 +1514,7 @@ xfs_alloc_ag_vextent_lastblock(
>  	 * maxlen, go to the start of this block, and skip all those smaller
>  	 * than minlen.
>  	 */
> -	if (len || args->alignment > 1) {
> +	if (*len || args->alignment > 1) {
>  		acur->cnt->bc_ptrs[0] = 1;
>  		do {
>  			error = xfs_alloc_get_rec(acur->cnt, bno, len, &i);
> 

