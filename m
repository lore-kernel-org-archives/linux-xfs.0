Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FED9C54E8D
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 15:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D885206CC
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 15:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dt9cNQgV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgELPbq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 11:31:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36496 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726492AbgELPbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 11:31:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589297504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QFm2N5CigqKIsBsaCJUdtV91mvVmM8Uc7K1w3NWVD/E=;
        b=Dt9cNQgVyGxR9OWIfT+VRKVJjAUAwdTxLPNaAuCc0AC0s+NcgbYhtdtrX4CzOfz1ijsZvI
        Yn1Y8i4QLQmsZ3VlywwjPcSbYJb2H1sVGNq/O/aP5mHXVUphPU+BS0yWARc1KRqC/9x/Ii
        fpGt1+W4pFF+8gkw0pRSemVaq0eytR4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-oztw0L_MMrGVZdlPgB3HAA-1; Tue, 12 May 2020 11:31:42 -0400
X-MC-Unique: oztw0L_MMrGVZdlPgB3HAA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3B64EC1A3;
        Tue, 12 May 2020 15:31:41 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 99EFB1002395;
        Tue, 12 May 2020 15:31:41 +0000 (UTC)
Date:   Tue, 12 May 2020 11:31:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: remove the XFS_DFORK_Q macro
Message-ID: <20200512153139.GF37029@bfoster>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510072404.986627-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 10, 2020 at 09:24:00AM +0200, Christoph Hellwig wrote:
> Just checking di_forkoff directly is a little easier to follow.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_format.h    | 5 ++---
>  fs/xfs/libxfs/xfs_inode_buf.c | 6 +++---
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 045556e78ee2c..3cc352000b8a1 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -964,13 +964,12 @@ enum xfs_dinode_fmt {
>  /*
>   * Inode data & attribute fork sizes, per inode.
>   */
> -#define XFS_DFORK_Q(dip)		((dip)->di_forkoff != 0)
>  #define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
>  
>  #define XFS_DFORK_DSIZE(dip,mp) \
> -	(XFS_DFORK_Q(dip) ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
> +	((dip)->di_forkoff ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
>  #define XFS_DFORK_ASIZE(dip,mp) \
> -	(XFS_DFORK_Q(dip) ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
> +	((dip)->di_forkoff ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
>  #define XFS_DFORK_SIZE(dip,mp,w) \
>  	((w) == XFS_DATA_FORK ? \
>  		XFS_DFORK_DSIZE(dip, mp) : \
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 05f939adea944..5547bbb3cf945 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -265,7 +265,7 @@ xfs_inode_from_disk(
>  	error = xfs_iformat_data_fork(ip, from);
>  	if (error)
>  		return error;
> -	if (XFS_DFORK_Q(from)) {
> +	if (from->di_forkoff) {
>  		error = xfs_iformat_attr_fork(ip, from);
>  		if (error)
>  			goto out_destroy_data_fork;
> @@ -435,7 +435,7 @@ xfs_dinode_verify_forkoff(
>  	struct xfs_dinode	*dip,
>  	struct xfs_mount	*mp)
>  {
> -	if (!XFS_DFORK_Q(dip))
> +	if (!dip->di_forkoff)
>  		return NULL;
>  
>  	switch (dip->di_format)  {
> @@ -538,7 +538,7 @@ xfs_dinode_verify(
>  		return __this_address;
>  	}
>  
> -	if (XFS_DFORK_Q(dip)) {
> +	if (dip->di_forkoff) {
>  		fa = xfs_dinode_verify_fork(dip, mp, XFS_ATTR_FORK);
>  		if (fa)
>  			return fa;
> -- 
> 2.26.2
> 

