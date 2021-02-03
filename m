Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1B2C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 00:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA39564F74
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 00:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhBCArz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 19:47:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232540AbhBCArf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 19:47:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612313168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rBbZdQyDxthhAf/7YH1ENmhxKzCkGFUA0vBQ7btbTWI=;
        b=Vc1mJwF02MjXV5c8AaosZQ5RcbwAapsuhiUEy/z8iN/XcDvO/pHsFv/UukedUnyoPhdQGy
        Ye56TlagcdyHrLCPubXe+fAzoz1OYUOhmDTFUy3Nadpev7KFcw7od0pnS/jJjBaXjbdTMY
        MRGXlL87HEB3cSRH6CMQTBHo2sc59JY=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-GSF_ZA_CPU-jwP26SNuCKQ-1; Tue, 02 Feb 2021 19:46:07 -0500
X-MC-Unique: GSF_ZA_CPU-jwP26SNuCKQ-1
Received: by mail-pj1-f72.google.com with SMTP id p8so3498062pjg.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Feb 2021 16:46:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rBbZdQyDxthhAf/7YH1ENmhxKzCkGFUA0vBQ7btbTWI=;
        b=pwusqTPMn0J9aDCqix19UOlW+7LiSlAxO+SqKBckGhfOc13mpVN63da9FKajxhberM
         pUGypjiCr9xTRYc5SNg8M9HYRA4BIk8KMISnY32FxpnFKBN1fmdFiY241e/qR+E8R8bz
         UJgdH0Ucuos90G2ZLC2lKQ/FB4T2esNVSSrNUEcqmCS6ZrZT+/2eDvUbtQiIYn1HmWzA
         BpOj4qT0/oDLPekUTEfwQfJwh5vSp/JfOU7K19oW+pQX0v8rpDV+Hy5MOc5I1RLpUwQK
         idFeCmFNGFebMHVMXho8suvd3Qr9G8lYgcEj8BPKe7DG/h+5TYLeGzF1mxSQLwHjd5Sx
         PUQw==
X-Gm-Message-State: AOAM533/O5Tra46qlWA2VLHHEjAVmf5luM1RE3OBpmr51zmWLdKX5lyz
        IyzbJNaW+xqy4M9EKMoX28K4j7ecYEup9Q5xk08QrXliVeNUo3Nmadosxldjq3VEr58tQyqHWYp
        2H+O5VFJLvYgoKdlEJLyx
X-Received: by 2002:a17:90a:4548:: with SMTP id r8mr517839pjm.16.1612313166079;
        Tue, 02 Feb 2021 16:46:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznG0NKN62Ch3nMjdjDXCiwDOpyk/3oH7j0zShMUY4m5WKbK60tonPSNcUwIx4ADrRdM86laA==
X-Received: by 2002:a17:90a:4548:: with SMTP id r8mr517824pjm.16.1612313165845;
        Tue, 02 Feb 2021 16:46:05 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p68sm165114pfb.60.2021.02.02.16.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 16:46:05 -0800 (PST)
Date:   Wed, 3 Feb 2021 08:45:54 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 3/7] xfs: update lazy sb counters immediately for
 resizefs
Message-ID: <20210203004554.GC767509@xiangao.remote.csb>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-4-hsiangkao@redhat.com>
 <20210202193804.GN3336100@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210202193804.GN3336100@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Tue, Feb 02, 2021 at 02:38:04PM -0500, Brian Foster wrote:
> On Tue, Jan 26, 2021 at 08:56:17PM +0800, Gao Xiang wrote:
> > sb_fdblocks will be updated lazily if lazysbcount is enabled,
> > therefore when shrinking the filesystem sb_fdblocks could be
> > larger than sb_dblocks and xfs_validate_sb_write() would fail.
> > 
> > Even for growfs case, it'd be better to update lazy sb counters
> > immediately to reflect the real sb counters.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/xfs_fsops.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index a2a407039227..2e490fb75832 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -128,6 +128,14 @@ xfs_growfs_data_private(
> >  				 nb - mp->m_sb.sb_dblocks);
> >  	if (id.nfree)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> > +
> > +	/*
> > +	 * update in-core counters now to reflect the real numbers
> > +	 * (especially sb_fdblocks)
> > +	 */
> 
> Could you update the comment to explain why we do this? For example:
> 
> "Sync sb counters now to reflect the updated values. This is
> particularly important for shrink because the write verifier will fail
> if sb_fdblocks is ever larger than sb_dblocks."
> 

Thanks for the review/suggestion!

I updated the comment in "[PATCH v6 6/7] xfs: support shrinking unused
space in the last AG", since shrinking functionality is somewhat landed
after [PATCH 6/7]... If that looks worse than changing directly here,
I will shift/update the comment in the next version.

Thanks,
Gao Xiang

> Brian
> 

