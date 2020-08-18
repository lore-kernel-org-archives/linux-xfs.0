Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECAF1C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 11:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C827C206B5
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 11:08:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XushXTJJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgHRLIu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 07:08:50 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31945 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726391AbgHRLIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 07:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597748925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q3QUKlDhdr/h2ohkuJlNxVvsk7+HfJwaxMaeyH4iCAA=;
        b=XushXTJJyBmrp4QrAAn8cVj6ZPWnLndnuy8ygxZKoClQxg2Sycvv6GkAX1J31bJKYZETrO
        bamzxBvkh4d1qlbGwRsuSsThjzyo8i2sOsHlrcksELXqtSGrwRtyh/VL1cs+i4PrV0lILq
        ctPFm1cYqAiwC2Wl644oZbYeLFF3090=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-znyc265UPpuP1ni4MKFyDQ-1; Tue, 18 Aug 2020 07:08:43 -0400
X-MC-Unique: znyc265UPpuP1ni4MKFyDQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50EE751B6
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 11:08:42 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 156785B680
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 11:08:42 +0000 (UTC)
Date:   Tue, 18 Aug 2020 07:08:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: finish dfops on every insert range shift iteration
Message-ID: <20200818110840.GA94675@bfoster>
References: <20200713202151.64750-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713202151.64750-1-bfoster@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 04:21:51PM -0400, Brian Foster wrote:
> The recent change to make insert range an atomic operation used the
> incorrect transaction rolling mechanism. The explicit transaction
> roll does not finish deferred operations. This means that intents
> for rmapbt updates caused by extent shifts are not logged until the
> final transaction commits. Thus if a crash occurs during an insert
> range, log recovery might leave the rmapbt in an inconsistent state.
> This was discovered by repeated runs of generic/455.
> 
> Update insert range to finish dfops on every shift iteration. This
> is similar to collapse range and ensures that intents are logged
> with the transactions that make associated changes.
> 
> Fixes: dd87f87d87fa ("xfs: rework insert range into an atomic operation")
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---

Ping?

>  fs/xfs/xfs_bmap_util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index afdc7f8e0e70..feb277874a1f 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1165,7 +1165,7 @@ xfs_insert_file_space(
>  		goto out_trans_cancel;
>  
>  	do {
> -		error = xfs_trans_roll_inode(&tp, ip);
> +		error = xfs_defer_finish(&tp);
>  		if (error)
>  			goto out_trans_cancel;
>  
> -- 
> 2.21.3
> 

