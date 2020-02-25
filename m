Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A956C35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4124B2176D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SgMjqJFU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbgBYPNZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 10:13:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23627 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730794AbgBYPNZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 10:13:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582643604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fRF6t3rinwA+hm3xPtC8pVQJsbG3wujwH9mZZwatH2I=;
        b=SgMjqJFUilseK+fipovDhOB4f6DueerhAsi0s2nYECAkid4jZB0aQc66vC3aSs7cG/lo7q
        R+1Q+S83LvMv65XrTC37FgXwLb1yV80aflIee+udtGg7xv9x4KkawvxloyuHDrXI4k15VA
        MHS8JwHVoNkRC3S7sUQNrLLPaztesRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-8MBmOBEHMpmTjeGjT4fgzA-1; Tue, 25 Feb 2020 10:13:22 -0500
X-MC-Unique: 8MBmOBEHMpmTjeGjT4fgzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 738058018C2;
        Tue, 25 Feb 2020 15:13:21 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 17DF25DA2C;
        Tue, 25 Feb 2020 15:13:21 +0000 (UTC)
Date:   Tue, 25 Feb 2020 10:13:19 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] libxfs: zero the struct xfs_mount when unmounting
 the filesystem
Message-ID: <20200225151319.GD26938@bfoster>
References: <158258947401.451256.14269201133311837600.stgit@magnolia>
 <158258948007.451256.11063346596276638956.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258948007.451256.11063346596276638956.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:11:20PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since libxfs doesn't allocate the struct xfs_mount *, we can't just free
> it during unmount.  Zero its contents to prevent any use-after-free.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  libxfs/init.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index d4804ead..197690df 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -904,6 +904,7 @@ libxfs_umount(
>  	if (mp->m_logdev_targp != mp->m_ddev_targp)
>  		kmem_free(mp->m_logdev_targp);
>  	kmem_free(mp->m_ddev_targp);
> +	memset(mp, 0, sizeof(struct xfs_mount));
>  
>  	return error;
>  }
> 

