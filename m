Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB29C83001
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43C00206D8
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F7q2NWzP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgD1PK4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:10:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53955 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727865AbgD1PKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 11:10:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588086654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pxjCnFFiC8cWsUfWlSv6qeI2n0sYYSqMk+sJjEKiPuk=;
        b=F7q2NWzPNTJ5DXN0DN/TV4sodJc3T0Xbt2ZvCsXdVFohmGSLD+OFfuCy+i2/+3297gqy/Q
        UKzK/nM9X/qoBNPRGeY7ZeF6MWFovO2RzFG+vlqEkP/ha3fE9JwgTjvwPXxfjjkhh/VqyI
        kpnH1qUxLvtG1aKOCysLhN67Iu/tDGc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-HAsfiu-dNz2nbx20nPmRdA-1; Tue, 28 Apr 2020 11:10:52 -0400
X-MC-Unique: HAsfiu-dNz2nbx20nPmRdA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06EB7108BD13;
        Tue, 28 Apr 2020 15:10:52 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A0B125D750;
        Tue, 28 Apr 2020 15:10:51 +0000 (UTC)
Date:   Tue, 28 Apr 2020 11:10:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: rename inode_list xlog_recover_reorder_trans
Message-ID: <20200428151049.GB27954@bfoster>
References: <20200427135229.1480993-1-hch@lst.de>
 <20200427135229.1480993-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427135229.1480993-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 03:52:29PM +0200, Christoph Hellwig wrote:
> This list contains pretty much everything that is not a buffer.  The
> comment calls it item_list, which is a much better name than inode
> list, so switch the actual variable name to that as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_recover.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 750a81b941ea4..33cac61570abe 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1847,7 +1847,7 @@ xlog_recover_reorder_trans(
>  	LIST_HEAD(cancel_list);
>  	LIST_HEAD(buffer_list);
>  	LIST_HEAD(inode_buffer_list);
> -	LIST_HEAD(inode_list);
> +	LIST_HEAD(item_list);
>  
>  	list_splice_init(&trans->r_itemq, &sort_list);
>  	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
> @@ -1883,7 +1883,7 @@ xlog_recover_reorder_trans(
>  		case XFS_LI_BUD:
>  			trace_xfs_log_recover_item_reorder_tail(log,
>  							trans, item, pass);
> -			list_move_tail(&item->ri_list, &inode_list);
> +			list_move_tail(&item->ri_list, &item_list);
>  			break;
>  		default:
>  			xfs_warn(log->l_mp,
> @@ -1904,8 +1904,8 @@ xlog_recover_reorder_trans(
>  	ASSERT(list_empty(&sort_list));
>  	if (!list_empty(&buffer_list))
>  		list_splice(&buffer_list, &trans->r_itemq);
> -	if (!list_empty(&inode_list))
> -		list_splice_tail(&inode_list, &trans->r_itemq);
> +	if (!list_empty(&item_list))
> +		list_splice_tail(&item_list, &trans->r_itemq);
>  	if (!list_empty(&inode_buffer_list))
>  		list_splice_tail(&inode_buffer_list, &trans->r_itemq);
>  	if (!list_empty(&cancel_list))
> -- 
> 2.26.1
> 

