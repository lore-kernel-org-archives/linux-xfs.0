Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C461C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 18:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0ACE206FA
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 18:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388965AbhATSqf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 13:46:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390374AbhATRkW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jan 2021 12:40:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611164334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vQExF8hba+wyyPUOefLsEShCcoVczw6WTxx3dmlpxrc=;
        b=Rv48YZGd/5RG+j2yV+XyIRafwLwXPHAE1DevmyN13Ud5qUJprvk8mzkH2iKM5VWX7xVUpA
        c06qlS8czqu5Yc3atDqLSTOw+2P+w/GhuoA/Sh1iILXk204VwtZ28XYizhxGULR6PyZbwV
        eZKcdVdUcapGjOo7mGi380PGjl+AEzI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-vGnxP0qmO4mrFijyWfgwgA-1; Wed, 20 Jan 2021 12:38:46 -0500
X-MC-Unique: vGnxP0qmO4mrFijyWfgwgA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84153EC1A4;
        Wed, 20 Jan 2021 17:38:45 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F28CD5C8AB;
        Wed, 20 Jan 2021 17:38:43 +0000 (UTC)
Date:   Wed, 20 Jan 2021 12:38:39 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/2] xfs_repair: fix unmount error message to have a
 newline
Message-ID: <20210120173839.GB1722880@bfoster>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
 <20210120043157.GY3134581@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120043157.GY3134581@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 19, 2021 at 08:31:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a newline so that this is consistent with the other error messages.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/xfs_repair.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 724661d8..9409f0d8 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1136,7 +1136,7 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
>  	error = -libxfs_umount(mp);
>  	if (error)
>  		do_error(
> -	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair."),
> +	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair.\n"),
>  				error);
>  
>  	libxfs_destroy(&x);
> 

