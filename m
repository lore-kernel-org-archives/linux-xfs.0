Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C250C83012
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F3A822244
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:20:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YygPdATF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390924AbgLAQUc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:20:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390911AbgLAQUb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 11:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606839545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Az4qDwCnDjWkQ03Dval1eJRYg/4UEWJOqXDXdOeUspg=;
        b=YygPdATFkhApSHomfELfIXNy2u8ttfYMwwcbz1X8sLUw0CtbnvH9Ch8NYTLqtTGTko10XA
        yD9oCz+qMf4IAk/RiKU98NvFoiMchMRuD1bE3qutTCtO2AYh5Lq7RkcOPhI1b+URg1+Jdr
        goJ8tJ+xSo3JKunMVLj9X3w322nKsqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-PB_DAzmJOAGbu3xmmy_Osg-1; Tue, 01 Dec 2020 11:19:03 -0500
X-MC-Unique: PB_DAzmJOAGbu3xmmy_Osg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 501A39CC20;
        Tue,  1 Dec 2020 16:19:02 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D607D60854;
        Tue,  1 Dec 2020 16:19:01 +0000 (UTC)
Date:   Tue, 1 Dec 2020 11:18:59 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: enable the needsrepair feature
Message-ID: <20201201161859.GE1205666@bfoster>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679385732.447856.1039349578089907881.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679385732.447856.1039349578089907881.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:37:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make it so that libxfs recognizes the needsrepair feature.  Note that
> the kernel will still refuse to mount these.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_format.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 5d8ba609ac0b..f64eed3ccfed 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -473,7 +473,8 @@ xfs_sb_has_ro_compat_feature(
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
>  		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
> -		 XFS_SB_FEAT_INCOMPAT_BIGTIME)
> +		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
> +		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> 

