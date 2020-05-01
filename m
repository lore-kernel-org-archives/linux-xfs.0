Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7B9C47257
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 15:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA60424953
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 15:58:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C+Qey2SS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgEAP63 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 11:58:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49399 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728495AbgEAP63 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 11:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588348707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZzFK+RpYkDYI/hZZOiXY8wtmQztV4fxamvUc3t2kbHs=;
        b=C+Qey2SSeqPK8xK2KretOabqV2D0RX9389/3IsRikd+ne9gU0133igEesyh03lYq7SEm9V
        QkHzDPuQZv7yNPg2TD/qzkzM9l/tPA9alDl7kduNlU+qIbKdZRaPJRpLUQlw+uzlhYFFrn
        Xy/YaDIjy0HN5j2A8IHD+rEVCybJzPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-71tAfkwTPiu5yuS4bswmeA-1; Fri, 01 May 2020 11:58:20 -0400
X-MC-Unique: 71tAfkwTPiu5yuS4bswmeA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A99AF107ACF3;
        Fri,  1 May 2020 15:58:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BBE65EE11;
        Fri,  1 May 2020 15:58:19 +0000 (UTC)
Date:   Fri, 1 May 2020 11:58:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: remove the NULL fork handling in
 xfs_bmapi_read
Message-ID: <20200501155817.GR40250@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501081424.2598914-13-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 10:14:24AM +0200, Christoph Hellwig wrote:
> Now that we fully verify the inode forks before they are added to the
> inode cache, the crash reported in
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=204031
> 
> can't happen anymore, as we'll never let an inode that has inconsistent
> nextents counts vs the presence of an in-core attr fork leak into the
> inactivate code path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 19 ++-----------------
>  1 file changed, 2 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 76be1a18e2442..4246f2fd5b144 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3891,7 +3891,8 @@ xfs_bmapi_read(
>  	int			flags)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_ifork	*ifp;
> +	int			whichfork = xfs_bmapi_whichfork(flags);
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	struct xfs_bmbt_irec	got;
>  	xfs_fileoff_t		obno;
>  	xfs_fileoff_t		end;
> @@ -3899,7 +3900,6 @@ xfs_bmapi_read(
>  	int			error;
>  	bool			eof = false;
>  	int			n = 0;
> -	int			whichfork = xfs_bmapi_whichfork(flags);
>  
>  	ASSERT(*nmap >= 1);
>  	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
> @@ -3915,21 +3915,6 @@ xfs_bmapi_read(
>  
>  	XFS_STATS_INC(mp, xs_blk_mapr);
>  
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	if (!ifp) {
> -		/*
> -		 * A missing attr ifork implies that the inode says we're in
> -		 * extents or btree format but failed to pass the inode fork
> -		 * verifier while trying to load it.  Treat that as a file
> -		 * corruption too.
> -		 */
> -#ifdef DEBUG
> -		xfs_alert(mp, "%s: inode %llu missing fork %d",
> -				__func__, ip->i_ino, whichfork);
> -#endif /* DEBUG */
> -		return -EFSCORRUPTED;
> -	}
> -

Well that addresses my thought on the previous patch, but I don't see
the value in removing the check entirely. It might be safe for the inode
from disk path, but that doesn't preclude current or future runtime bugs
associated with xattr removal (i.e. fork removal) or inappropriate use
of XFS_BMAPI_ATTRFORK, for example. In fact, I think it makes sense for
any inappropriate use of xfs_bmapi_read() due to lack of the associated
fork to return an error rather than explode.

Brian

>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>  		error = xfs_iread_extents(NULL, ip, whichfork);
>  		if (error)
> -- 
> 2.26.2
> 

