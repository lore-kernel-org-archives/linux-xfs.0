Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0449C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 19:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbjKGT1n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 14:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbjKGT1m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 14:27:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2946610A
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 11:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699385215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KhVltzxTUgNwTVBGGCSdHtHwIpM3sIzdg58kbC5wd/E=;
        b=QUwOorOxyedmMRMi5Rx2NpZgKs6w0bAnPtlJLowuDCw/xYZMT8w9DSh+jFtyR+HrmWMbzp
        +QF+AU+/CsjSol9LkxMcEztafi0IdHy8bUx1Y5jCa+2GjUcJkiUhd2tfhZNFMnXHd4DcQR
        L3igd8D4LEX+O6tAtMQhZKpvwOwjWr8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-H2_j5JZgO-qPXckEwhdbAg-1; Tue,
 07 Nov 2023 14:26:49 -0500
X-MC-Unique: H2_j5JZgO-qPXckEwhdbAg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FA9D28237C0;
        Tue,  7 Nov 2023 19:26:49 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A2C3625C0;
        Tue,  7 Nov 2023 19:26:48 +0000 (UTC)
Date:   Tue, 7 Nov 2023 13:26:46 -0600
From:   Bill O'Donnell <bodonnel@redhat.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     chandan.babu@oracle.com, djwong@kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] xfs: Remove unused function
Message-ID: <ZUqPdhc4RQxL8TVB@redhat.com>
References: <20231103073040.649-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103073040.649-1-jiapeng.chong@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 03, 2023 at 03:30:40PM +0800, Jiapeng Chong wrote:
> The function are defined in the bitmap.c file, but not called
> elsewhere, so delete the unused function.
> 
> fs/xfs/scrub/bitmap.c:55:1: warning: unused function 'xbitmap_tree_iter_next'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7137
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Makes sense.
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>


> ---
>  fs/xfs/scrub/bitmap.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> index e0c89a9a0ca0..ba4b18e40faa 100644
> --- a/fs/xfs/scrub/bitmap.c
> +++ b/fs/xfs/scrub/bitmap.c
> @@ -48,10 +48,6 @@ static inline struct xbitmap_node *
>  xbitmap_tree_iter_first(struct rb_root_cached *root, uint64_t start,
>  			uint64_t last);
>  
> -static inline struct xbitmap_node *
> -xbitmap_tree_iter_next(struct xbitmap_node *node, uint64_t start,
> -		       uint64_t last);
> -
>  INTERVAL_TREE_DEFINE(struct xbitmap_node, bn_rbnode, uint64_t,
>  		__bn_subtree_last, START, LAST, static inline, xbitmap_tree)
>  
> -- 
> 2.20.1.7.g153144c
> 

