Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00767C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C91D620866
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:07:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FoUGdzIn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbgHaTH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:07:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727993AbgHaTH0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 15:07:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598900845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LTPwOZwYOLA/07WZQ1G2FxDCTGYHF8PyWt0i8ueqjOw=;
        b=FoUGdzIn6/l0CGX8avs4D/+n578+TyBJ+4+q4FLZ8itI5sydd8BEBGZ7JCndXiClrTL1+y
        0p1vY7aq48vf6z6A4ZVpqz83iUHU4wj/acVzu2ZLfGvEaz9Na+kCSP49IfjPCutvYsMk3J
        0Ewmb2fN8sL3N02j4O/ZQ4qBKgQi80w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-hNuEC-fdM6y5ea2EfQmcbQ-1; Mon, 31 Aug 2020 15:07:23 -0400
X-MC-Unique: hNuEC-fdM6y5ea2EfQmcbQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 632411888A16;
        Mon, 31 Aug 2020 19:07:22 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 124AC60C04;
        Mon, 31 Aug 2020 19:07:21 +0000 (UTC)
Date:   Mon, 31 Aug 2020 15:07:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: enable new inode btree counters feature
Message-ID: <20200831190720.GG12035@bfoster>
References: <159858219107.3058056.6897728273666872031.stgit@magnolia>
 <159858222199.3058056.17495955382261687992.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159858222199.3058056.17495955382261687992.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 07:37:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Enable the new inode btree counters feature.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_format.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 03cbedb7eafc..fe129fe16d5f 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -453,7 +453,8 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
>  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> -		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
> +		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
> +		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
>  #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
>  static inline bool
>  xfs_sb_has_ro_compat_feature(
> 

