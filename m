Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538BEC54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 11:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E39A2078C
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 11:55:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFjOP+xX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgELLzH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 07:55:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34142 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729378AbgELLzH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 07:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589284505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5Ab20QLAcf3COaWqTS69V2FBOPWFeXCenkwhT7yZOgY=;
        b=IFjOP+xX7zWZp+81FQfnvLjVPLQdRLsZrt5kond4yo0IDRRoE7Qo0cX8jiMpbWFlWl1bXH
        NQcI44aFu0r15rIXCXZm/dUvroTlk0IxP71BMpPpx3MJh4IjpqwmG1bGoe7zOsg93cbEms
        nrL8SIDUIX8TastQHpBSxsfLkjNPbME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-6zceKQBHNHy5uJ_XM6jhsQ-1; Tue, 12 May 2020 07:55:02 -0400
X-MC-Unique: 6zceKQBHNHy5uJ_XM6jhsQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96DEB872FEF;
        Tue, 12 May 2020 11:55:01 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F199D1D4;
        Tue, 12 May 2020 11:55:00 +0000 (UTC)
Date:   Tue, 12 May 2020 07:54:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     dchinner@redhat.com, sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH] xfs: ensure f_bfree returned by statfs() is non-negative
Message-ID: <20200512115459.GA36658@bfoster>
References: <20200511024524.132384-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511024524.132384-1-zhengbin13@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 11, 2020 at 10:45:24AM +0800, Zheng Bin wrote:
> Construct an img like this:
> 
> dd if=/dev/zero of=xfs.img bs=1M count=20
> mkfs.xfs -d agcount=1 xfs.img
> xfs_db -x xfs.img
> sb 0
> write fdblocks 0
> agf 0
> write freeblks 0
> write longest 0
> quit
> 
> mount it, df -h /mnt(xfs mount point), will show this:
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop0       17M  -64Z  -32K 100% /mnt
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---

Seems reasonable to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e80bd2c4c279..aae469f73efe 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -807,7 +807,8 @@ xfs_fs_statfs(
>  	statp->f_blocks = sbp->sb_dblocks - lsize;
>  	spin_unlock(&mp->m_sb_lock);
> 
> -	statp->f_bfree = fdblocks - mp->m_alloc_set_aside;
> +	/* make sure statp->f_bfree does not underflow */
> +	statp->f_bfree = max_t(int64_t, fdblocks - mp->m_alloc_set_aside, 0);
>  	statp->f_bavail = statp->f_bfree;
> 
>  	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
> --
> 2.26.0.106.g9fadedd
> 

