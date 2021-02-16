Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F7BAC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 12:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAAAB64DAF
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 12:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhBPMUE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Feb 2021 07:20:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32436 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230291AbhBPMTy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Feb 2021 07:19:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613477908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MZw8NeGU8syQpucJRH7QwZ2gykalHuEePBPp3HaKPKM=;
        b=PKn4q0N5ZeWsM3asYYQnBcLo5gkXyTCLAUWP2kWdIWfvOr9D4pv6zMIr7yTnZ/sZc/pniY
        lhypwBeg6lI4ybP8KemDMtBRijRK88mNG4S2e+0sXn1d6i2EMqPpfI7e2Kn2MS24bxkPyZ
        Fj+lWvk+nKi9geJHCY+mMg2cQ0COG7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-z0BGh6eXNW2kEn6WH4Spug-1; Tue, 16 Feb 2021 07:18:26 -0500
X-MC-Unique: z0BGh6eXNW2kEn6WH4Spug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 585071934101;
        Tue, 16 Feb 2021 12:18:25 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B90C550A8A;
        Tue, 16 Feb 2021 12:18:24 +0000 (UTC)
Date:   Tue, 16 Feb 2021 07:18:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/5] xfs_repair: allow upgrades to v5 filesystems
Message-ID: <20210216121822.GE534175@bfoster>
References: <161319522350.423010.5768275226481994478.stgit@magnolia>
 <161319523460.423010.11387475504369174814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161319523460.423010.11387475504369174814.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 12, 2021 at 09:47:14PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add some helper functions so that we can allow users to upgrade V5
> filesystems in a sane manner.  This just lands the boilerplate; the
> actual feature validation and whatnot will land in the next patches.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/phase2.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> 
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 952ac4a5..f654edcc 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -131,6 +131,40 @@ zero_log(
>  		libxfs_max_lsn = log->l_last_sync_lsn;
>  }
>  
> +/* Perform the user's requested upgrades on filesystem. */
> +static void
> +upgrade_filesystem(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_buf		*bp;
> +	bool			dirty = false;
> +	int			error;
> +
> +        if (no_modify || !dirty)
> +                return;
> +
> +        bp = libxfs_getsb(mp);
> +        if (!bp || bp->b_error) {
> +                do_error(
> +	_("couldn't get superblock for feature upgrade, err=%d\n"),
> +                                bp ? bp->b_error : ENOMEM);
> +        } else {
> +                libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> +
> +                /*
> +		 * Write the primary super to disk immediately so that
> +		 * needsrepair will be set if repair doesn't complete.
> +		 */
> +                error = -libxfs_bwrite(bp);
> +                if (error)
> +                        do_error(
> +	_("filesystem feature upgrade failed, err=%d\n"),
> +                                        error);
> +        }
> +        if (bp)
> +                libxfs_buf_relse(bp);
> +}
> +
>  /*
>   * ok, at this point, the fs is mounted but the root inode may be
>   * trashed and the ag headers haven't been checked.  So we have
> @@ -235,4 +269,10 @@ phase2(
>  				do_warn(_("would correct\n"));
>  		}
>  	}
> +
> +	/*
> +	 * Upgrade the filesystem now that we've done a preliminary check of
> +	 * the superblocks, the AGs, the log, and the metadata inodes.
> +	 */
> +	upgrade_filesystem(mp);
>  }
> 

