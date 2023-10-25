Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B21CC25B6B
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Oct 2023 20:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjJYUDG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 16:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJYUDF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 16:03:05 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBD693
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2023 13:03:03 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-564af0ac494so164610a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2023 13:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1698264183; x=1698868983; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RwMLm1UAsh3FUgsB7ohoo1KirAU+8qNuidBC1F2hLxM=;
        b=Qay29cS3aGcBKnA3iFzX3mD2cr/d8mQ+/Q+H52/wQqeFyswRbzxn78BEqhFKaCJSze
         cNAi2K/GW8oVIfsvNfmjo96j4BSSE1saCao4iXsu/ShG45fK2Np0K6lzljuCV9n0vMHr
         01e4/D6SGbxFi/70JcYMZm78BDvUyWPvApVFFLjWgsOReSJidH+x6S11MvgCe/34eqFo
         riQm9slNoGHTNhlVylrSukvqNxG/6FqtB3uhHjn++g7G9/UsCRzMzlLBQ4CurE72urIG
         Ky7y3UsboRCajRaJJbVN2IsyNTQ0V0fuySelpL55Ppj0j/IzoeKT2ImcD8OnCUx9zgmx
         O6kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698264183; x=1698868983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RwMLm1UAsh3FUgsB7ohoo1KirAU+8qNuidBC1F2hLxM=;
        b=SM26GpNJswgRzzWair01/UHDVgbwlwFHzj/75GANUk9t1/gIngaJ5sJpcuunduqssT
         60tZCOAoTfBZ6gKOYTQpODK1zmRRRAAczJn77x2qcsxJ7wnNMDMZxXsLyVMp/50JPR4i
         45zH+KKJZOdYsNlll8KadKzkxUJZbzMSDRD76+fSkXblxNIzW0WdbbNUUo2uEARUmE88
         36PY0XIiKobxIyZBy4POmP4iwFPU1RnNNXMMfq7GCINQmyILZXsf58R3gw4eQsvb6kGR
         SwtQvd/Tffho56Z7beJrmkwB4eTPBV/MJp3y1t4m4lNAVSNWQVtJKfEVhsx/C6sXG0I9
         YwZg==
X-Gm-Message-State: AOJu0YxFNGc4ruastjdM+Ni1+7Ai4mFOIoaQkOjWBbFaoloQEQzD094y
        5WCI9/Gf6rfaWGLjiepk4DD63AGDyEz+Q9bg8aU=
X-Google-Smtp-Source: AGHT+IFL/LsMBXgcNHbTcyDSEiSKPLw7r2GdyX8npZN4tqZdhUk2sxxjNemv6vPSLm7/Q+AhAmUbTQ==
X-Received: by 2002:a17:90b:8d7:b0:27d:7f1b:1bf1 with SMTP id ds23-20020a17090b08d700b0027d7f1b1bf1mr13688574pjb.32.1698264182597;
        Wed, 25 Oct 2023 13:03:02 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:500::6:9893])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a195e00b0027cfd582b51sm321911pjh.3.2023.10.25.13.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 13:03:02 -0700 (PDT)
Date:   Wed, 25 Oct 2023 13:03:00 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] xfs: fix internal error from AGFL exhaustion
Message-ID: <ZTl0dH7kztlRNFe/@telecaster>
References: <013168d2de9d25c56fe45ad75e9257cf9664f2d6.1698190191.git.osandov@fb.com>
 <ZTibBf0ef5PMcJiH@dread.disaster.area>
 <ZTikH67goprXtn1+@telecaster>
 <20231025155046.GF3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025155046.GF3195650@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2023 at 08:50:46AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 24, 2023 at 10:14:07PM -0700, Omar Sandoval wrote:
> > On Wed, Oct 25, 2023 at 03:35:17PM +1100, Dave Chinner wrote:
> > > On Tue, Oct 24, 2023 at 04:37:33PM -0700, Omar Sandoval wrote:
> > > > From: Omar Sandoval <osandov@fb.com>
> > > > Fix it by adding an extra block of slack in the freelist for the
> > > > potential leaf split in each of the bnobt and cntbt.
> 
> I see how the cntbt can split because changing the length of a freespace
> extent can require the record to move to a totally different part of the
> cntbt.  The reinsertion causes the split.
> 
> How does the bnobt split during a refresh of the AGFL?  Will we ever
> allocate a block from the /middle/ of a free space extent?

That's the case I was worried about for the bnobt. I see two ways that
can happen:

1. alignment, prod, or mod requirements, which the freelist doesn't
   have.
2. Busy extents. I don't know enough about XFS to say whether or not
   this is applicable, but at first glance I don't see why not.

> > > Hmmm. yeah - example given is 2->3 level split, hence only need to
> > > handle a single level leaf split before path intersection occurs.
> > > Yup, adding an extra block will make the exact problem being seen go
> > > away.
> > > 
> > > Ok, what's the general solution? 4-level, 5-level or larger trees?
> > > 
> > > Worst split after a full split is up to the level below the old root
> > > block. the root block was split, so it won't need a split again, so
> > > only it's children could split again. OK, so that's (height - 1)
> > > needed for a max split to refill the AGFL after a full height split
> > > occurred.
> > > 
> > > Hence it looks like the minimum AGFL space for any given
> > > allocation/free operation needs to be:
> > > 
> > > 	(full height split reservation) + (AGFL refill split height)
> > > 
> > > which is:
> > > 
> > > 	= (new height) + (new height - 2)
> > > 	= 2 * new height - 2
> > > 	= 2 * (current height + 1) - 2
> > > 	= 2 * current height
> > > 
> > > Ok, so we essentially have to double the AGFL minimum size to handle
> > > the generic case of AGFL refill splitting free space trees after a
> > > transaction that has exhausted it's AGFL reservation.
> > > 
> > > Now, did I get that right?
> > 
> > That sounds right, but I'll have to think about it more after some sleep
> > :)
> 
> I think that's correct, assuming that (2 * current_height) is the
> per-btree calcluation.

Agreed, except when the tree is already the maximum level. In that case,
the worst case is splitting up to but not including the root node twice,
which is 2 * height - 2 (i.e., stopping before Dave substituted new
height with current height + 1). So I think we want:

min_free = min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
			       mp->m_alloc_maxlevels) * 2 - 2;

> > Assuming that is correct, your LE search suggestion sounds kind of nice
> > rather than such a drastic change to the AGFL size.

Come to think of it, if there is nothing <= the desired size but there
is something >, we have no choice but to do the split, so that doesn't
work.

> The absolute maximum height of a free space btree is 7 blocks, according
> to xfs_db:
> 
> # xfs_db /dev/sda -c 'btheight -w absmax all'
> bnobt: 7
> cntbt: 7
> inobt: 6
> finobt: 6
> bmapbt: 14
> refcountbt: 6
> rmapbt: 10
> 
> The smallest AGFL is 62 records long (V4 fs, 512b blocks) so I don't
> think it's /that/ drastic.  For a filesystem with rmapbt (V5, 1k blocks)
> that minimum jumps to 121 blocks.
> 
> > > The rmapbt case will need this change, too, because rmapbt blocks
> > > are allocated from the free list and so an rmapbt update can exhaust
> > > the free list completely, too.
> > 
> > Ah, I missed where the rmapbt is updated since it was slightly removed
> > from the xfs_alloc_fixup_trees() code path I was looking at.
> 
> The rmapbt has its own accounting tricks (XFS_AG_RESV_RMAPBT) to ensure
> that there's always enough free space to refill the AGFL.  Is that why
> the testcase turns off rmapbt?

Nope, I turned it off in my test case because with the rmapbt enabled,
the freelist is larger. Therefore, for this bug to happen, the bnobt,
cntbt, and rmapbt all need a maximum split at the same time. This is
"easy" to do for just the bnobt and cntbt since they store the same
records, but it's a lot harder to get the rmapbt in on it, too.

Nevertheless, it seems possible, right? XFS_AG_RESV_RMAPBT only seems to
guarantee that there is space in the AG to refill the AGFL, but that
doesn't mean we won't need to split the rmapbt at an inopportune time?
