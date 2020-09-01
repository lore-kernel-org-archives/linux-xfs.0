Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED61C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B53802137B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fg3L5Dd/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgIAON4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:13:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728288AbgIAONu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 10:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598969629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jf5yG0PZro7cmIhKmGXIng++78MYkp945pYe3ACO57Y=;
        b=Fg3L5Dd/MuK7c3gNQ7H15axnU07cLAP5/joxjFq6LZpzyRcVEnSW+gJP7oDGqW0rtABeKV
        +9OTAtlc5Yhe3DnSJtkR+9oQYTJI22oujQGK4y5IbX7P5i2E3kMOWjQNTJzoXTNOUUv3aK
        +XBrhf9CLKO9MtLO/jrDVO6/OMERFCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-u50_sXMuO-OTjdOmC6mTog-1; Tue, 01 Sep 2020 10:13:48 -0400
X-MC-Unique: u50_sXMuO-OTjdOmC6mTog-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67180807336
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 14:13:46 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01A135C1A3;
        Tue,  1 Sep 2020 14:13:43 +0000 (UTC)
Date:   Tue, 1 Sep 2020 10:13:41 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: add inline helper to convert from data fork to
 xfs_attr_shortform
Message-ID: <20200901141341.GB174813@bfoster>
References: <20200901095919.238598-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901095919.238598-1-cmaiolino@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 11:59:19AM +0200, Carlos Maiolino wrote:
> Hi folks, while working on the attr structs cleanup, I've noticed there
> are so many places where we do:
> 
> (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> 
> So, I thought it would be worth to add another inline function to do
> this conversion and remove all these casts.
> 
> To achieve this, it will be required to include xfs_inode.h header on
> xfs_attr_sf.h, so it can access the xfs_inode definition. Also, if this
> patch is an acceptable idea, it will make sense then to keep the
> xfs_attr_sf_totsize() function also inside xfs_attr_sf.h (which has been
> moved on my series to avoid the additional #include), so, I thought on
> sending this RFC patch to get comments if it's a good idea or not, and,
> if it is, I'll add this patch to my series before sending it over.
> 
> I didn't focus on check if this patch is totally correct (only build
> test), since my idea is to gather you guys opinions about having this
> new inline function, so don't bother on reviewing the patch itself by
> now, only the function name if you guys prefer some other name.
> 
> Also, this patch is build on top of my clean up series (V2), not yet
> sent to the list, so it won't apply anyway.
> 
> Cheers.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      |  4 ++--
>  fs/xfs/libxfs/xfs_attr_leaf.c | 16 ++++++++--------
>  fs/xfs/libxfs/xfs_attr_sf.h   |  6 ++++++
>  fs/xfs/xfs_attr_list.c        |  2 +-
>  4 files changed, 17 insertions(+), 11 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> index 540ad3332a9c8..a51aed1dab6c1 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -3,6 +3,8 @@
>   * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
>   */
> +
> +#include "xfs_inode.h"

FWIW, I thought we tried to avoid including headers from other headers
like this. I'm also wondering if it's an issue that we'd be including a
a header that is external to libxfs from a libxfs header. Perhaps this
could be simplified by passing the xfs_ifork pointer to the new helper
rather than the xfs_inode and/or moving the helper to
libxfs/xfs_inode_fork.h and putting a forward declaration of
xfs_attr_shortform in there..?

Brian

>  #ifndef __XFS_ATTR_SF_H__
>  #define	__XFS_ATTR_SF_H__
>  
> @@ -47,4 +49,8 @@ xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep) {
>  					    xfs_attr_sf_entsize(sfep));
>  }
>  
> +static inline struct xfs_attr_shortform *
> +xfs_attr_ifork_to_sf(struct xfs_inode *ino) {
> +	return (struct xfs_attr_shortform *)ino->i_afp->if_u1.if_data;
> +}
>  #endif	/* __XFS_ATTR_SF_H__ */
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 8f8837fe21cf0..7c0ebdeb43567 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -61,7 +61,7 @@ xfs_attr_shortform_list(
>  	int				error = 0;
>  
>  	ASSERT(dp->i_afp != NULL);
> -	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> +	sf = xfs_attr_ifork_to_sf(dp);
>  	ASSERT(sf != NULL);
>  	if (!sf->hdr.count)
>  		return 0;
> -- 
> 2.26.2
> 

