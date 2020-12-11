Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11BEC4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 16:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7DA823106
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 16:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393163AbgLKPud (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:50:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393096AbgLKPuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Dec 2020 10:50:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607701727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s5pfshPkAPec4xzR8SPi2NVyxecnYZ/M1xURDs+pMd0=;
        b=FwuOVIxtO3fzroQMkt1qFPFMtnc62gU84owc53kZMpseNwS7qJyTuE9g/Cjh7oiHfxUuUz
        cjLewJ5qMFWsp9Y1jvL8mPhtangwHoCAclewuBhdT3xUrmsmOceBHxdeULc1e5zgGW48ou
        +OVxUfvq1MqMj/uwpo8Unp3q7Wycx0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-hh4aM4R8PzC1DClsW3QpBg-1; Fri, 11 Dec 2020 10:48:45 -0500
X-MC-Unique: hh4aM4R8PzC1DClsW3QpBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D60619611B8;
        Fri, 11 Dec 2020 15:48:44 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B3AE6E418;
        Fri, 11 Dec 2020 15:48:43 +0000 (UTC)
Date:   Fri, 11 Dec 2020 10:48:41 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] fs/xfs: convert comma to semicolon
Message-ID: <20201211154841.GE2032335@bfoster>
References: <20201211084112.1931-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211084112.1931-1-zhengyongjun3@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 11, 2020 at 04:41:12PM +0800, Zheng Yongjun wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 2d25bab68764..51dbff9b0908 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4070,7 +4070,7 @@ xfs_btree_delrec(
>  	 * surviving block, and log it.
>  	 */
>  	xfs_btree_set_numrecs(left, lrecs + rrecs);
> -	xfs_btree_get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB),
> +	xfs_btree_get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB);
>  	xfs_btree_set_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
>  	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
>  
> -- 
> 2.22.0
> 

