Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B5CC4727C
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 14:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDB4C207C3
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 14:51:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vd5+GRz1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbgI3Ovp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 10:51:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730107AbgI3Ovp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 10:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601477504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y29aqLvBuaBdQnAQ/f7xEfFTBpfbmU09H6uOxMi9E9Q=;
        b=Vd5+GRz10O7R8FeR6u+E1vpBHrk3sXuU5EmSxyJIfzJ+FvZGfFJIFrQYORg0JEwjXJrsX6
        5yRvRr0jgXN1mS9pBE7ZEL5QTspj9xHdU0nQ+jixNSvwcubNDFWgxyhioIi3YlroKFPxwW
        c2sSeGjEyYikZrk9jQWtTZ0O95iLEGM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-IlDw7ZQgP1azhDQ_Ntzcdw-1; Wed, 30 Sep 2020 10:51:42 -0400
X-MC-Unique: IlDw7ZQgP1azhDQ_Ntzcdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24BD41007464;
        Wed, 30 Sep 2020 14:51:41 +0000 (UTC)
Received: from bfoster (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BDBB100239A;
        Wed, 30 Sep 2020 14:51:40 +0000 (UTC)
Date:   Wed, 30 Sep 2020 10:51:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, nathans@redhat.com
Subject: Re: [PATCH 2/2] xfs: fix finobt btree block recovery ordering
Message-ID: <20200930145138.GA3882@bfoster>
References: <20200930063532.142256-1-david@fromorbit.com>
 <20200930063532.142256-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930063532.142256-3-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 30, 2020 at 04:35:32PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Nathan popped up on #xfs and pointed out that we fail to handle
> finobt btree blocks in xlog_recover_get_buf_lsn(). This means they
> always fall through the entire magic number matching code to "recover
> immediately". Whilst most of the time this is the correct behaviour,
> occasionally it will be incorrect and could potentially overwrite
> more recent metadata because we don't check the LSN in the on disk
> metadata at all.
> 
> This bug has been present since the finobt was first introduced, and
> is a potential cause of the occasional xfs_iget_check_free_state()
> failures we see that indicate that the inode btree state does not
> match the on disk inode state.
> 
> Fixes: aafc3c246529 ("xfs: support the XFS_BTNUM_FINOBT free inode btree type")
> Reported-by: Nathan Scott <nathans@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf_item_recover.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 24c7a8d11e1a..d44e8b4a3391 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -719,6 +719,8 @@ xlog_recover_get_buf_lsn(
>  	case XFS_ABTC_MAGIC:
>  	case XFS_RMAP_CRC_MAGIC:
>  	case XFS_REFC_CRC_MAGIC:
> +	case XFS_FIBT_CRC_MAGIC:
> +	case XFS_FIBT_MAGIC:
>  	case XFS_IBT_CRC_MAGIC:
>  	case XFS_IBT_MAGIC: {
>  		struct xfs_btree_block *btb = blk;
> -- 
> 2.28.0
> 

