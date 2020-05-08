Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACE0C38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 13:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30C4620870
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 13:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D7Mo6vzD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgEHNBW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 09:01:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29221 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728344AbgEHNBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 09:01:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588942867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8LX4Pb0ANl6RKqJTyCd8qP9kCXTYgf3LWk3RqFszl6E=;
        b=D7Mo6vzDj+WNa2NHfZcYtLGeV0lW6ATvj2UXrdfFhJKQRBZCtrDq35mAQZCwl9Xq6TaYzz
        WbrPl0hhZn5gPDXBoAO3E3A88agAwjkTxbJhCw7Dz2ratattq41bAytGPDCMOdvEojXi4J
        vZLniz/qkKde3vV3YY2pJAal/mW3joc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-dSsUHu00MsCcKX-zCHjbjA-1; Fri, 08 May 2020 09:01:05 -0400
X-MC-Unique: dSsUHu00MsCcKX-zCHjbjA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 659841009613
        for <linux-xfs@vger.kernel.org>; Fri,  8 May 2020 13:01:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 02B9B6F430;
        Fri,  8 May 2020 13:01:01 +0000 (UTC)
Date:   Fri, 8 May 2020 09:00:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: group quota should return EDQUOT when prj quota
 enabled
Message-ID: <20200508130059.GB27577@bfoster>
References: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
 <cb095532-b72b-6369-7304-3b589568f0fe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb095532-b72b-6369-7304-3b589568f0fe@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 10:38:33PM -0500, Eric Sandeen wrote:
> Long ago, group & project quota were mutually exclusive, and so
> when we turned on XFS_QMOPT_ENOSPC ("return ENOSPC if project quota
> is exceeded") when project quota was enabled, we only needed to
> disable it again for user quota.
> 
> When group & project quota got separated, this got missed, and as a
> result if project quota is enabled and group quota is exceeded, the
> error code returned is incorrectly returned as ENOSPC not EDQUOT.
> 
> Fix this by stripping XFS_QMOPT_ENOSPC out of flags for group
> quota when we try to reserve the space.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index e4eca607e512..47c6e88c9db6 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -757,7 +757,8 @@ xfs_trans_reserve_quota_bydquots(
>  	}
>  
>  	if (gdqp) {
> -		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
> +		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos,
> +					(flags & ~XFS_QMOPT_ENOSPC));
>  		if (error)
>  			goto unwind_usr;
>  	}
> 

