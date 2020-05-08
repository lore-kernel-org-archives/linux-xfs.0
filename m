Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58BAC38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99B412173E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:06:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EKWas9an"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgEHPGO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 11:06:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55786 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728103AbgEHPGO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 11:06:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588950373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QMkroI+jcZbbJdQ2JCgaKQvst+UeDP+VGBiZSgslY8M=;
        b=EKWas9an2r3lBpfc5zCkDNZmG9yaz1hRequk44ApwOMRys26yn8l0uXM86jgZw+7Hc3TAm
        sPmqVsFZQBkjHypW/QjxmV9WGQte8Siv3TycvXUJl5Q5O3xhNYQbP2N3v/Q2MQ0YAp93OE
        hhF18ujtXLdljcdz9H2hliBIjG4pF7c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-VT8hOF0YOU-jmqME1IpwbA-1; Fri, 08 May 2020 11:06:10 -0400
X-MC-Unique: VT8hOF0YOU-jmqME1IpwbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC51C835B40;
        Fri,  8 May 2020 15:06:09 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FE1F6ACF9;
        Fri,  8 May 2020 15:06:09 +0000 (UTC)
Date:   Fri, 8 May 2020 11:06:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: remove the NULL fork handling in
 xfs_bmapi_read
Message-ID: <20200508150607.GI27577@bfoster>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-13-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:23AM +0200, Christoph Hellwig wrote:
> Now that we fully verify the inode forks before they are added to the
> inode cache, the crash reported in
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=204031
> 
> can't happen anymore, as we'll never let an inode that has inconsistent
> nextents counts vs the presence of an in-core attr fork leak into the
> inactivate code path.  So remove the work around to try to handle the
> case, and just return an error and warn if the fork is not present.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 76be1a18e2442..34518a6dc7376 100644
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
> @@ -3899,12 +3900,14 @@ xfs_bmapi_read(
>  	int			error;
>  	bool			eof = false;
>  	int			n = 0;
> -	int			whichfork = xfs_bmapi_whichfork(flags);
>  
>  	ASSERT(*nmap >= 1);
>  	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
>  
> +	if (WARN_ON_ONCE(!ifp))
> +		return -EFSCORRUPTED;
> +
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
>  	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
>  		return -EFSCORRUPTED;
> @@ -3915,21 +3918,6 @@ xfs_bmapi_read(
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
>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>  		error = xfs_iread_extents(NULL, ip, whichfork);
>  		if (error)
> -- 
> 2.26.2
> 

