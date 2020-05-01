Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07C7C47258
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 13:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96A2C2054F
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 13:55:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FUM3K2VM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgEANz1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 09:55:27 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44512 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729328AbgEANd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 09:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588340034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t9D2JZPJ+Pw2/8tYLdIGsWmapimHns09dJ634nWvJYs=;
        b=FUM3K2VMhxhw+62N/RVpEQwAZxUOQ03BOemzlDMXgCWJWR6tfI/+IZz5MFZuH8WYS3c803
        7AcCPpvgcX9r70Ol1waIhepPXwP+NckAFeoUO186nDlvMEL3P4GvcW1YfCUyE+g/yvBOZ0
        ivCsF6UsKQBGS5DzLj/xTGMaUpZiGSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-Rv-MlDdRMTGg_oVn5TRFXA-1; Fri, 01 May 2020 09:33:53 -0400
X-MC-Unique: Rv-MlDdRMTGg_oVn5TRFXA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AD558018AC;
        Fri,  1 May 2020 13:33:52 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA1986084C;
        Fri,  1 May 2020 13:33:51 +0000 (UTC)
Date:   Fri, 1 May 2020 09:33:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: xfs_bmapi_read doesn't take a fork id as the
 last argument
Message-ID: <20200501133349.GH40250@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501081424.2598914-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 10:14:13AM +0200, Christoph Hellwig wrote:
> The last argument to xfs_bmapi_raad contains XFS_BMAPI_* flags, not the
> fork.  Given that XFS_DATA_FORK evaluates to 0 no real harm is done,
> but let's fix this anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index f42c74cb8be53..9498ced947be9 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -66,7 +66,7 @@ xfs_rtbuf_get(
>  
>  	ip = issum ? mp->m_rsumip : mp->m_rbmip;
>  
> -	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, XFS_DATA_FORK);
> +	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, 0);
>  	if (error)
>  		return error;
>  
> -- 
> 2.26.2
> 

