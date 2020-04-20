Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6EDC3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 16:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D889C206F6
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 16:22:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E8+hk1xG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgDTQW1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 12:22:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41748 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725958AbgDTQW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 12:22:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587399746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=81L4llmpagk3KlCOnulJ0lNXz45T3fbIC16IjYxk/58=;
        b=E8+hk1xG+Vl1miz4Db3y0UgotVoV0QKK11wEJZC2EY+uZ8x7gNkPOdCMf7bWltkc7T3jzI
        j4o+Iumb3lCJNxIv2yrxRg6Bo1PzvSuo/AEmM0M2+XcxCSXcRGYou477Opc6jFJwBS7QvQ
        LWUKKuTU8Oh3vTrS08U4M/9+Cz+IeHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-mrTif7JQMXKemZdSMXbZKg-1; Mon, 20 Apr 2020 12:22:24 -0400
X-MC-Unique: mrTif7JQMXKemZdSMXbZKg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DAEE19057B2;
        Mon, 20 Apr 2020 16:22:21 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CDC627BD7;
        Mon, 20 Apr 2020 16:22:20 +0000 (UTC)
Date:   Mon, 20 Apr 2020 12:22:18 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove unnecessary check of the variable resblks in
 xfs_symlink
Message-ID: <20200420162218.GC27216@bfoster>
References: <1587187851-11130-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587187851-11130-1-git-send-email-kaixuxia@tencent.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 18, 2020 at 01:30:51PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Since the "no-allocation" reservations has been removed, the resblks
> value should be larger than zero, so remove the unnecessary check.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_symlink.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 13fb4b919648..973441992b08 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -243,8 +243,7 @@ xfs_symlink(
>  	 */
>  	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
>  
> -	if (resblks)
> -		resblks -= XFS_IALLOC_SPACE_RES(mp);
> +	resblks -= XFS_IALLOC_SPACE_RES(mp);
>  	/*
>  	 * If the symlink will fit into the inode, write it inline.
>  	 */
> @@ -265,8 +264,7 @@ xfs_symlink(
>  		if (error)
>  			goto out_trans_cancel;
>  
> -		if (resblks)
> -			resblks -= fs_blocks;
> +		resblks -= fs_blocks;
>  		ip->i_d.di_size = pathlen;
>  		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> -- 
> 2.20.0
> 

