Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2414DEB64DC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Jul 2023 20:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjGQUd7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jul 2023 16:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjGQUd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2023 16:33:56 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629421A8
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 13:33:42 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1bb1baf55f5so26933975ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 13:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1689626022; x=1692218022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AkJevMD95/gNmzm9RfOLDnsWQ2AOxREWdhb4PA5TdCQ=;
        b=gFKpu49en6D7S+2fV9UaZcBg/ySGLvIO2dpR2LKm0qJxRWkPZyo/t9O/MUK+yRqOtM
         /ZoW1G5EFdIw/KAFoVOd2k7H5Ok3zy7WUuxJtnmHluy/mi/5qs7GIbtXMlb99F/7jUvU
         upUyrtO3/gCHv3OTrPooFPMWBeG01maciImoqaRqclDlegQ77Vfmehs8s36qCGv10sRw
         dTBLvTMQUuSdNoL5/E7Kt8FVpGZN2K446yw+sBgOdI6ORBDfdp99JPZVJo2rlgtUt8OD
         dyX5RCT61pcKjj1MiZGVqXjVDZb9ehVEpR47DJZSPy3R94vM38rv9hZQ8pGXuLF9rL3+
         px4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689626022; x=1692218022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AkJevMD95/gNmzm9RfOLDnsWQ2AOxREWdhb4PA5TdCQ=;
        b=afpNIwqDJnq1zG4HTxS7kSWAl/yOeZJt+Luq6O0QbJis+FDNsYZhq6CzANWsHqsNwv
         ZrgfMZAcXs8Z8ei6qj6qzpJHmR/NYmrS+5nLnuy4eaunZaX5HuXc/GPcGKI0BCHbWxVA
         ZYB8/HloIFEZdaYSxkyCia0Wsp/Xg44b8cC382wL++qgBDLEjWnIj70aYT/cXsbfXtBY
         KZl9OsjZsmUwszYvciPFEONozZQjVREOKyXKW/8fVZW7dl9vm3oijn5fJXzBK/F9c0Ia
         V5LNDeSHjFtF5LY4HqfkSNpnpdV+NeH/x+q83NibHJO9x02JuF3PdehUu3MR9UMDOg/a
         wS3A==
X-Gm-Message-State: ABy/qLbeYK+llFGPJ5eIeY/Jg4LXelpg7RqYx4nqDXWvzXrTwxS8xqqi
        yPGPi3jaa+mc+uNpz1K27vwrNw==
X-Google-Smtp-Source: APBJJlGlHeOXVw+jaE8NduXsOvh/QZzJVMwcH+pw+RMnOAIo4ujEmEXJUPsh2EqfpQyqdL51oJH7eQ==
X-Received: by 2002:a17:902:dad2:b0:1b8:b3f7:4872 with SMTP id q18-20020a170902dad200b001b8b3f74872mr16409260plx.28.1689626021704;
        Mon, 17 Jul 2023 13:33:41 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:400::5:7a5c])
        by smtp.gmail.com with ESMTPSA id p15-20020a170902e74f00b001b9cea4e8a2sm257590plf.293.2023.07.17.13.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 13:33:41 -0700 (PDT)
Date:   Mon, 17 Jul 2023 13:33:39 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 4/6] xfs: limit maxlen based on available space in
 xfs_rtallocate_extent_near()
Message-ID: <ZLWlo46WoX/FDZPL@telecaster>
References: <cover.1687296675.git.osandov@osandov.com>
 <da373ada54c851b448cc7d41167458dc6bd6f8ea.1687296675.git.osandov@osandov.com>
 <20230712230159.GX108251@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712230159.GX108251@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 04:01:59PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 20, 2023 at 02:32:14PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > xfs_rtallocate_extent_near() calls xfs_rtallocate_extent_block() with
> > the minlen and maxlen that were passed to it.
> > xfs_rtallocate_extent_block() then scans the bitmap block looking for a
> > free range of size maxlen. If there is none, it has to scan the whole
> > bitmap block before returning the largest range of at least size minlen.
> > For a fragmented realtime device and a large allocation request, it's
> > almost certain that this will have to search the whole bitmap block,
> > leading to high CPU usage.
> > 
> > However, the realtime summary tells us the maximum size available in the
> > bitmap block. We can limit the search in xfs_rtallocate_extent_block()
> > to that size and often stop before scanning the whole bitmap block.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  fs/xfs/xfs_rtalloc.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index ba7d42e0090f..d079dfb77c73 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -488,6 +488,8 @@ xfs_rtallocate_extent_near(
> >  		 * allocating one.
> >  		 */
> >  		if (maxlog >= 0) {
> > +			xfs_extlen_t maxavail =
> > +				min(maxlen, ((xfs_extlen_t)1 << (maxlog + 1)) - 1);
> 
> There can be up to 2^52rtx (realtime extents) in the filesystem, right?
> xfs_extlen_t is a u32, which will overflow this calculation if the
> realtime volume is seriously huge.  IOWs, doesn't this need to be:
> 
> 	xfs_extlen_t maxavail = max_t(xfs_rtblock_t, maxlen,
> 			(1ULL << (maxlog + 1)) - 1);
> 
> (The rest of the patch looks ok)

min_t instead of max_t, but good catch, fixed.
