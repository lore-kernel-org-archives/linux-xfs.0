Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52405C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24FFE206C3
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dFo6tLzC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgEVMDs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:03:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45802 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728544AbgEVMDs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:03:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590149027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/pqiq92tUAaudKbvV2asazAQmfGDKob3VVCVlSUaSGM=;
        b=dFo6tLzCXYe2f/Zc6mHCXDY2hLduv9ape3VeJLkp+BkwFhqGqJ1lJKYDPCfk59XszxoV8B
        akOyLsiyFcflzi5TnHtqoRszpG/hCfOTLy2CL7jYVK+oxQsV788JDNMKGW0N3chGpfDaWT
        SMOQg5elgHai4VTYfokAnnShKOTwLYE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-HlTygS0fOnONCzjMvbJ2OA-1; Fri, 22 May 2020 08:03:45 -0400
X-MC-Unique: HlTygS0fOnONCzjMvbJ2OA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 279608B9806;
        Fri, 22 May 2020 12:03:31 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C546D10013D9;
        Fri, 22 May 2020 12:03:30 +0000 (UTC)
Date:   Fri, 22 May 2020 08:03:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: remove unused xfs_inode_ag_iterator function
Message-ID: <20200522120329.GD50656@bfoster>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
 <159011602645.77079.8961337594949586276.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011602645.77079.8961337594949586276.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:53:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Not used by anyone, so get rid of it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c |   11 -----------
>  fs/xfs/xfs_icache.h |    3 ---
>  2 files changed, 14 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index b1e2541810be..6aafb547f21a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -985,17 +985,6 @@ xfs_inode_ag_iterator_flags(
>  	return last_error;
>  }
>  
> -int
> -xfs_inode_ag_iterator(
> -	struct xfs_mount	*mp,
> -	int			(*execute)(struct xfs_inode *ip, int flags,
> -					   void *args),
> -	int			flags,
> -	void			*args)
> -{
> -	return xfs_inode_ag_iterator_flags(mp, execute, flags, args, 0);
> -}
> -
>  int
>  xfs_inode_ag_iterator_tag(
>  	struct xfs_mount	*mp,
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index c13bc8a3e02f..0556fa32074f 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -71,9 +71,6 @@ int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
>  void xfs_cowblocks_worker(struct work_struct *);
>  void xfs_queue_cowblocks(struct xfs_mount *);
>  
> -int xfs_inode_ag_iterator(struct xfs_mount *mp,
> -	int (*execute)(struct xfs_inode *ip, int flags, void *args),
> -	int flags, void *args);
>  int xfs_inode_ag_iterator_flags(struct xfs_mount *mp,
>  	int (*execute)(struct xfs_inode *ip, int flags, void *args),
>  	int flags, void *args, int iter_flags);
> 

