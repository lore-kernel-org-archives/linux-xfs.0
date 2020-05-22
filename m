Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EC6C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51D4220759
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:23:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jfy/CoXE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgEVMXp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:23:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36602 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728409AbgEVMXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:23:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590150222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MHmdZVbqeIo85WFgwl/35ZhpTSwZ7PZcsBCRAJ0UM2k=;
        b=Jfy/CoXEX1j0Ksb+OIL3Y7n3V9LboIrHhHSiVA8U9ZFGf0fM3f/QkzkeYW63CMfv2DYKM7
        7s5NZ3+DJ4uXp62YNU1YzzFiDhVQPJ3KhYuEhdpIRJuH5lBaWdmN8BWls7v03AkoONv2ji
        4hhtoSGQy+BceO9u0A+nkn7M/zeoG6w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-wulRT1axNVymFgUiiiJXKw-1; Fri, 22 May 2020 08:23:40 -0400
X-MC-Unique: wulRT1axNVymFgUiiiJXKw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7586B107ACCA;
        Fri, 22 May 2020 12:23:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0848219167;
        Fri, 22 May 2020 12:23:38 +0000 (UTC)
Date:   Fri, 22 May 2020 08:23:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: use bool for done in xfs_inode_ag_walk
Message-ID: <20200522122337.GJ50656@bfoster>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
 <159011606568.77079.15373820626926543851.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011606568.77079.15373820626926543851.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:54:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This is a boolean variable, so use the bool type.
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
> index 31d85cc4bd8b..791544a1d54c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -803,11 +803,11 @@ xfs_inode_ag_walk(
>  	uint32_t		first_index;
>  	int			last_error = 0;
>  	int			skipped;
> -	int			done;
> +	bool			done;
>  	int			nr_found;
>  
>  restart:
> -	done = 0;
> +	done = false;
>  	skipped = 0;
>  	first_index = 0;
>  	nr_found = 0;
> @@ -859,7 +859,7 @@ xfs_inode_ag_walk(
>  				continue;
>  			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
>  			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
> -				done = 1;
> +				done = true;
>  		}
>  
>  		/* unlock now we've grabbed the inodes. */
> 

