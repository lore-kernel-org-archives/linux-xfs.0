Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30AA6C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 18:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDDDA22B3F
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 18:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbhAYSP7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 13:15:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32035 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731361AbhAYSPs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 13:15:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611598462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tc+doacmKffwzUPoJo+5Nf1/jA8bjSIqdlLte4cP4p4=;
        b=QOdVzuHothATu4i/MK4+VGYcB6gzAMuL4BI9nw6sNem5TGVzJGn1WEKyS4sMw0I80UTPtY
        rcc67IUWK4XHaeRzsEk9Oc4eOmG6JT6hAORAB+DqX0jf3VojXO1z7Z/Y1Xoye9/R8geNU8
        vXIqXlN9BOp0vqEgtafIzDamzn3OXeI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-8CEMbYGdM5CbIIasMUbvTw-1; Mon, 25 Jan 2021 13:14:18 -0500
X-MC-Unique: 8CEMbYGdM5CbIIasMUbvTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C79A6190A7A4;
        Mon, 25 Jan 2021 18:14:16 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F6205D9DC;
        Mon, 25 Jan 2021 18:14:15 +0000 (UTC)
Date:   Mon, 25 Jan 2021 13:14:14 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 03/11] xfs: xfs_inode_free_quota_blocks should scan
 project quota
Message-ID: <20210125181414.GI2047559@bfoster>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142793633.2171939.2299668448645740426.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142793633.2171939.2299668448645740426.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:52:16AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Buffered writers who have run out of quota reservation call
> xfs_inode_free_quota_blocks to try to free any space reservations that
> might reduce the quota usage.  Unfortunately, the buffered write path
> treats "out of project quota" the same as "out of overall space" so this
> function has never supported scanning for space that might ease an "out
> of project quota" condition.
> 
> We're about to start using this function for cases where we actually
> /can/ tell if we're out of project quota, so add in this functionality.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 89f9e692fde7..10c1a0dee17d 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1434,6 +1434,15 @@ xfs_inode_free_quota_blocks(
>  		}
>  	}
>  
> +	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
> +		dq = xfs_inode_dquot(ip, XFS_DQTYPE_PROJ);
> +		if (dq && xfs_dquot_lowsp(dq)) {
> +			eofb.eof_prid = ip->i_d.di_projid;
> +			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
> +			do_work = true;
> +		}
> +	}
> +
>  	if (!do_work)
>  		return false;
>  
> 

