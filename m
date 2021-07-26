Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72D5C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 20:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE7E060F6E
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 20:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbhGZUAW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 16:00:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232571AbhGZUAW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 16:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627332050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ADCPaVvnRwM6Nak3K92MMA+rOpDRZVyCIa8Kmkf4sAE=;
        b=CLk2bAVqg+EKdW7g7JM+mVtPYHde1Vs9wsAcAEzJjTDWBkjn/LGoWa+W7k5akB37hDg65a
        B0sZulBfl8HoPRnL/uUA/08P4t2okmop2gy2InFXZDACsfcEkazUgYhgXQiVyoFaKsxPLP
        lXqFPKgHl5i3DonD1k8MAQRuGlL/ghY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-j09i6x8hNNC_WKLl4DlH_g-1; Mon, 26 Jul 2021 16:40:48 -0400
X-MC-Unique: j09i6x8hNNC_WKLl4DlH_g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 070B13639F;
        Mon, 26 Jul 2021 20:40:48 +0000 (UTC)
Received: from redhat.com (unknown [10.22.17.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A4A1A19C59;
        Mon, 26 Jul 2021 20:40:43 +0000 (UTC)
Date:   Mon, 26 Jul 2021 15:40:41 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: drop experimental warnings for bigtime and
 inobtcount
Message-ID: <20210726204041.dufnxm66qtvek2zw@redhat.com>
References: <20210707002313.GG11588@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707002313.GG11588@locust>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 06, 2021 at 05:23:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> These two features were merged a year ago, userspace tooling have been
> merged, and no serious errors have been reported by the developers.
> Drop the experimental tag to encourage wider testing.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/xfs_super.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index cbc1f0157bcd..321e3590c6fe 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1539,10 +1539,6 @@ xfs_fs_fill_super(
>  	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
>  		sb->s_flags |= SB_I_VERSION;
>  
> -	if (xfs_sb_version_hasbigtime(&mp->m_sb))
> -		xfs_warn(mp,
> - "EXPERIMENTAL big timestamp feature in use. Use at your own risk!");
> -
>  	if (mp->m_flags & XFS_MOUNT_DAX_ALWAYS) {
>  		bool rtdev_is_dax = false, datadev_is_dax;
>  
> @@ -1598,10 +1594,6 @@ xfs_fs_fill_super(
>  		goto out_filestream_unmount;
>  	}
>  
> -	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
> -		xfs_warn(mp,
> - "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
> -
>  	error = xfs_mountfs(mp);
>  	if (error)
>  		goto out_filestream_unmount;
> 

