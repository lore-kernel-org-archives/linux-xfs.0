Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3221C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 11:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 717B8613D8
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 11:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbhD0Le0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 07:34:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230270AbhD0Le0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 07:34:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619523223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Tgrz3IDwaDw5v/4/tBZzSSzvwTI6bJBeDT7Ivy6eeY=;
        b=dg9RcNExGgSF7dXQ16tZS9UnU+ZyEeYtJ3P5QKu7LEdKirlB5W4iCUMfJWxV0X3EYazhZH
        uJYlMlmFUrEk3+frj1dgmhld7+EUzir4/BpWrvJRPY9kkuGGMSjqG9wWSbQM/zJsao6Sf1
        y8LfeXfwA7nPr8RY4vxct1+5CSIRa00=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-IG8QgVDMP8yLo4Pny25dmw-1; Tue, 27 Apr 2021 07:33:41 -0400
X-MC-Unique: IG8QgVDMP8yLo4Pny25dmw-1
Received: by mail-qk1-f199.google.com with SMTP id k12-20020a05620a0b8cb02902e028cc62baso22629205qkh.17
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 04:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Tgrz3IDwaDw5v/4/tBZzSSzvwTI6bJBeDT7Ivy6eeY=;
        b=epkhY/dwcSL45Pc1pQLj0KUBKXB9Ft8KWo5g6UtSy8xvcrv/Y9EZQ/pV4Up8Gq5Y7A
         2MAUnXQr4Mj9TvgAKZ5JLA7tnUSZfkBPxCRcPlqgtmHCVTPeLvMFeoZUVcxhEwa79Uzn
         ssZBrH9vHxYCVKvHbWUcbRLeCBYnA/LgOQr9RCxgHFrZRmcxhDeln1tP8EajW8gCwis0
         cpEw2z3YiT6rwmlj2aqJM1WQUSPrHePG4gXfbb4ucO+YEm83Yh59j6B0kTprE4uoSGIA
         Ihdz/gbLkf1scm1VS/D31P1hQw9O3u96dZ9Ov2jIIOky50tJoMK1aLGcwROOqSQ2lQRB
         e/2A==
X-Gm-Message-State: AOAM532bLmGlJycKnIPU0U1KMGNL+Znxt3jrSE3zhDad3TQHemKlgUi6
        gmzegLZm6G17lXnFz77XrCXwuPMnp74+2Xs5BfC4BLijpooIA4CiIs9A2t0BVOS5x72lsdLDO1V
        WNnli2nLfx+q/DRH2nwRI
X-Received: by 2002:a37:a545:: with SMTP id o66mr15124421qke.52.1619523220480;
        Tue, 27 Apr 2021 04:33:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMFRaKu1PYfmD80EkQkGfPQWX+qQqxZWCiw50rswiQBv2ovgXTg4dpFrzm4/EyUgMmcyJLmw==
X-Received: by 2002:a37:a545:: with SMTP id o66mr15124401qke.52.1619523220288;
        Tue, 27 Apr 2021 04:33:40 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id u126sm2579847qkd.80.2021.04.27.04.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 04:33:39 -0700 (PDT)
Date:   Tue, 27 Apr 2021 07:33:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 2/3] xfs: introduce in-core global counter of allocbt
 blocks
Message-ID: <YIf2kWK/mSx4V8Rc@bfoster>
References: <20210423131050.141140-1-bfoster@redhat.com>
 <20210423131050.141140-3-bfoster@redhat.com>
 <8735vcm37j.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735vcm37j.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 03:58:16PM +0530, Chandan Babu R wrote:
> On 23 Apr 2021 at 18:40, Brian Foster wrote:
> > Introduce an in-core counter to track the sum of all allocbt blocks
> > used by the filesystem. This value is currently tracked per-ag via
> > the ->agf_btreeblks field in the AGF, which also happens to include
> > rmapbt blocks. A global, in-core count of allocbt blocks is required
> > to identify the subset of global ->m_fdblocks that consists of
> > unavailable blocks currently used for allocation btrees. To support
> > this calculation at block reservation time, construct a similar
> > global counter for allocbt blocks, populate it on first read of each
> > AGF and update it as allocbt blocks are used and released.
> >
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
> >  fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
> >  fs/xfs/xfs_mount.h              |  6 ++++++
> >  3 files changed, 20 insertions(+)
> >
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index aaa19101bb2a..144e2d68245c 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -3036,6 +3036,7 @@ xfs_alloc_read_agf(
> >  	struct xfs_agf		*agf;		/* ag freelist header */
> >  	struct xfs_perag	*pag;		/* per allocation group data */
> >  	int			error;
> > +	uint32_t		allocbt_blks;
> >
> >  	trace_xfs_alloc_read_agf(mp, agno);
> >
> > @@ -3066,6 +3067,17 @@ xfs_alloc_read_agf(
> >  		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
> >  		pag->pagf_init = 1;
> >  		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
> > +
> > +		/*
> > +		 * Update the global in-core allocbt block counter. Filter
> > +		 * rmapbt blocks from the on-disk counter because those are
> > +		 * managed by perag reservation.
> > +		 */
> > +		if (pag->pagf_btreeblks > be32_to_cpu(agf->agf_rmap_blocks)) {
> 
> pag->pagf_btreeblks gets incremented everytime a block is allocated to refill
> AGFL (via xfs_alloc_get_freelist()). Apart from the allobt trees, blocks for
> Rmap btree also get allocated from AGFL. Hence pag->pagf_btreeblks must be
> larger than agf->agf_rmap_blocks.
> 

This function is actually to consume a block from the AGFL (as opposed
to refill it).

> Can you please describe the scenario in which pag->pagf_btreeblks has a value
> that is <= agf->agf_rmap_blocks?
> 

Ah, this was just an initialization quirk. I originally had an assert
here and based the logic on the assumption that pagf_btreeblks >=
agf_rmap_blocks, but alas:

# mkfs.xfs -f -mrmapbt <dev>
...
# xfs_db -c "agf 0" -c "p rmapblocks" -c "p btreeblks" <dev>
rmapblocks = 1
btreeblks = 0
#

Brian

> --
> chandan
> 

