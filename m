Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF11C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A029D206C3
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:03:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RAfOOMvd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgEVMDg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:03:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49246 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728544AbgEVMDf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590149014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P/FG/jqEg6/g85xTZ6msUblUL9OptGG6hpTjp3HbO5A=;
        b=RAfOOMvdb1sZHohR+mZCfCg2BAbBxCOFNli8KXNwdAt+1npo3MBL7oMUEoddcVxVyAF3IQ
        wRY35OtQ241ZEYUyMI1dLibIO8TD9mu4OdIwfkVPCzl3z2W/4YqbPCkAhsxirjJB8QJdV9
        mWmKM6LPzNVLxWB2CC/dB6ty9J9MayI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-89LNK2soPXW9MKQr3Od0jw-1; Fri, 22 May 2020 08:03:29 -0400
X-MC-Unique: 89LNK2soPXW9MKQr3Od0jw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC2E9100CCE1;
        Fri, 22 May 2020 12:03:23 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 53C8110013D9;
        Fri, 22 May 2020 12:03:23 +0000 (UTC)
Date:   Fri, 22 May 2020 08:03:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: replace open-coded XFS_ICI_NO_TAG
Message-ID: <20200522120321.GC50656@bfoster>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
 <159011602013.77079.11614147766663587976.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011602013.77079.11614147766663587976.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:53:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use XFS_ICI_NO_TAG instead of -1 when appropriate.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0ed904c2aa12..b1e2541810be 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -815,7 +815,7 @@ xfs_inode_ag_walk(
>  
>  		rcu_read_lock();
>  
> -		if (tag == -1)
> +		if (tag == XFS_ICI_NO_TAG)
>  			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
>  					(void **)batch, first_index,
>  					XFS_LOOKUP_BATCH);
> @@ -973,8 +973,8 @@ xfs_inode_ag_iterator_flags(
>  	ag = 0;
>  	while ((pag = xfs_perag_get(mp, ag))) {
>  		ag = pag->pag_agno + 1;
> -		error = xfs_inode_ag_walk(mp, pag, execute, flags, args, -1,
> -					  iter_flags);
> +		error = xfs_inode_ag_walk(mp, pag, execute, flags, args,
> +				XFS_ICI_NO_TAG, iter_flags);
>  		xfs_perag_put(pag);
>  		if (error) {
>  			last_error = error;
> 

