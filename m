Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23B8C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A62A82071C
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:17:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZReUDrz3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731129AbgCPNRa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:17:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45240 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731033AbgCPNRa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 09:17:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584364649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fkGPUnsHseBux0zASM72VuJHK9518vlQC09rkOXZwW0=;
        b=ZReUDrz3nrBSdp7i3evWv6NPCO7ZPIOuV315JbARkssKKlLd8+/WGo4lW+h6WjQARdHBL7
        e7KlMgdoG8XcFDib3JmRungLm6zYxNz0GL7/V4B33pAZXjsKTEVHszPYvb/4P7CCSyMrZX
        vTbBvFSW5pVKNV7UFQv4bU0S2ZHWeS4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-u3kzIS-zNVqEfSk3MUxMSA-1; Mon, 16 Mar 2020 09:17:27 -0400
X-MC-Unique: u3kzIS-zNVqEfSk3MUxMSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A063800D55;
        Mon, 16 Mar 2020 13:17:26 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D5115C1B5;
        Mon, 16 Mar 2020 13:17:26 +0000 (UTC)
Date:   Mon, 16 Mar 2020 09:17:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: simplify di_flags2 inheritance in xfs_ialloc
Message-ID: <20200316131724.GH12313@bfoster>
References: <20200312142235.550766-1-hch@lst.de>
 <20200312142235.550766-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312142235.550766-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:22:34PM +0100, Christoph Hellwig wrote:
> di_flags2 is initialized to zero for v4 and earlier file systems.  This
> means di_flags2 can only be non-zero for a v5 file systems, in which
> case both the parent and child inodes can store the filed.  Remove the

filed?

> extra di_version check, and also remove the rather pointless local
> di_flags2 variable while at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Otherwise seems fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index addc3ee0cb73..ebfd8efb0efa 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -907,20 +907,13 @@ xfs_ialloc(
>  
>  			ip->i_d.di_flags |= di_flags;
>  		}
> -		if (pip &&
> -		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
> -		    pip->i_d.di_version == 3 &&
> -		    ip->i_d.di_version == 3) {
> -			uint64_t	di_flags2 = 0;
> -
> +		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
>  			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
> -				di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> +				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
>  			}
>  			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
> -				di_flags2 |= XFS_DIFLAG2_DAX;
> -
> -			ip->i_d.di_flags2 |= di_flags2;
> +				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
>  		}
>  		/* FALLTHROUGH */
>  	case S_IFLNK:
> -- 
> 2.24.1
> 

