Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EF8C25B48
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Oct 2023 20:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjJZU4u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Oct 2023 16:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbjJZU4t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2023 16:56:49 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3137B1A6
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2023 13:56:47 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6ba54c3ed97so1353039b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2023 13:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698353806; x=1698958606; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gE/K/t6oxF6zzwM//B8mKU5vSnn+ShbpVEcTx2ZgAs8=;
        b=SPXIt4OILl3I2QytiVaiz+PE5FmdyY8E8je8zojkNsNBhb7jTxbSTIXyrT3A0t1IMA
         MmV53kFRee/nqXmQ3roMncqjZlGIRldDickHspwP/Rl1KBCJPzzqrVIgylPUlEj/D+u8
         D1uxCtg7scuAcHAokYLOh0bVY3fisc++L5NWMWRa42P4MFLcGgEM1WtDKGNpIS8ZlOjm
         15NC8dTr8UxyuRWNI1XBlDYm0PVA5DPMUUPLQz/2cRVKwrEUQcka+auwfH1VM78kEncu
         dU6haM2mgBLaLawceLhX3ihlY7iMlfVk65EXu1sFQwjDL6jftn/6pm4Qm5b+pZ17Poio
         tE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698353806; x=1698958606;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gE/K/t6oxF6zzwM//B8mKU5vSnn+ShbpVEcTx2ZgAs8=;
        b=GPqMM7IyhWtFk6h9b/vhwQ/06BYjYo3QqDxcdaKMoaegE6MhzsFhnT8u4vFx5Uf0XX
         +I7jOxo6w8ZwmG1pR5iG5Uxz7mtOffM12e3d2Dy7jIxNKo6WqVyiYSRD4m0uvIau+Fc8
         wVhnOpxmrn4dGYj8xvNfnHIpiCWecxNpH5Yn47XwjSMlo7c9gvdcT6pjUL0Hd6+iK1uG
         R486H3epdfXvjnsD/LCR09KPzmKn6nGTwuP0zZeoPf8YDsiq8TEZN804rjiVC+eWJu6A
         sIxqUjCD/CtvRHz63rUI+Ynhl1L+gjWaArEP0r8V9m7VgyyBHSN6uxGBUwCaY7pOwsDt
         n/gQ==
X-Gm-Message-State: AOJu0YwwUYBNPuTk52ZPkmGXPdl1ce7aR8UT4TUAOy5ERhC7VF01pM7U
        UdbxA0tCKUKiiSZxi0EsbsRqUQ==
X-Google-Smtp-Source: AGHT+IHdqxpJeHPUAzRTuuiYWAwRQ3kMf7EcZJUcT05NSVcq4HrH5ZRjXJ7GOOTsA1I34X26Nygy1g==
X-Received: by 2002:a05:6a00:10ca:b0:6bd:4ab7:5f69 with SMTP id d10-20020a056a0010ca00b006bd4ab75f69mr717496pfu.12.1698353806607;
        Thu, 26 Oct 2023 13:56:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id x39-20020a056a000be700b00694f14a784bsm26120pfu.52.2023.10.26.13.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 13:56:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qw7PH-004KjW-1z;
        Fri, 27 Oct 2023 07:56:43 +1100
Date:   Fri, 27 Oct 2023 07:56:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] xfs: fix internal error from AGFL exhaustion
Message-ID: <ZTrSiwF7OAq0hJHn@dread.disaster.area>
References: <013168d2de9d25c56fe45ad75e9257cf9664f2d6.1698190191.git.osandov@fb.com>
 <ZTibBf0ef5PMcJiH@dread.disaster.area>
 <ZTikH67goprXtn1+@telecaster>
 <20231025155046.GF3195650@frogsfrogsfrogs>
 <ZTl0dH7kztlRNFe/@telecaster>
 <20231025223909.GG3195650@frogsfrogsfrogs>
 <ZTmmw7jDuEeBFbd3@dread.disaster.area>
 <20231026032102.GI3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026032102.GI3195650@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2023 at 08:21:02PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 26, 2023 at 10:37:39AM +1100, Dave Chinner wrote:
> > On Wed, Oct 25, 2023 at 03:39:09PM -0700, Darrick J. Wong wrote:
> > > On Wed, Oct 25, 2023 at 01:03:00PM -0700, Omar Sandoval wrote:
> > > > On Wed, Oct 25, 2023 at 08:50:46AM -0700, Darrick J. Wong wrote:
> > > > > The absolute maximum height of a free space btree is 7 blocks, according
> > > > > to xfs_db:
> > > > > 
> > > > > # xfs_db /dev/sda -c 'btheight -w absmax all'
> > > > > bnobt: 7
> > > > > cntbt: 7
> > > > > inobt: 6
> > > > > finobt: 6
> > > > > bmapbt: 14
> > > > > refcountbt: 6
> > > > > rmapbt: 10
> > > > > 
> > > > > The smallest AGFL is 62 records long (V4 fs, 512b blocks) so I don't
> > > > > think it's /that/ drastic.  For a filesystem with rmapbt (V5, 1k blocks)
> > > > > that minimum jumps to 121 blocks.
> > 
> > Yup. keep in mind this comment in xfs_alloc_fix_freelist():
> > 
> > 	 * XXX (dgc): When we have lots of free space, does this buy us
> >          * anything other than extra overhead when we need to put more blocks
> >          * back on the free list? Maybe we should only do this when space is
> >          * getting low or the AGFL is more than half full?
> > 
> > IOWs, I've previously mused about keeping the AGFL much fuller than
> > the absolute minimum. There doesn't seem to be any real gain to
> > keeping it at just the minimum size when we are nowhere near ENOSPC,
> > it just means we are doing lots of management operations like
> > reducing it immediately after a transaction that has released blocks
> > to the freelist, then only to have to extend it again when we do an
> > operation that consumes blocks from the free list.
> > 
> > i.e. should we add also hysteresis to limit the number of AGFL
> > size manipulations we need to do in mixed workloads? i.e. we don't free
> > blocks from the AGFL until it might get overfilled by an operation
> > (i.e. max size - max merge free blocks) or we are nearing ENOSPC,
> > and we don't fill till we are at the minimum. In either case, the
> > target for empty or fill operations is "half full"...
> 
> Hmm.   What if we kept the AGFL completely full?

It can't be kept that way - we have to have space to store blocks
that are released by tree merges. i.e. like a tree split requires a
minimum number blocks in the free list for it to succeed, a tree
merge needs a minimum number of free slots in the AGFL for it to
succeed.

> On that 512b-fsblock V4 filesystem, that'd use up 128 blocks instead of 7
> blocks.  128 blocks == 64K per AG.
> 
> On a 64K-fsblock V5 filesystem, that'd use up 16370 64K blocks per AG, or
> ~1GB per AG.  Ok, that might be too much.
> 
> On a 4K-fsblock V5 fs, that's 1010 4K blocks per AG, or ~4MB per AG.
> 
> A gigabyte is a bit ridiculous, but what if we always did the maximum
> bnobt/cntbt/rmapbt height instead of current_height + 1?

Yes, largely full AGFLs all the time doesn't make a whole lot of
sense, but just a max height reservation still doesn't cover the
case exposed by this fix. It would need to be 2 * max height
to cover the double split case we are talking about here.

Also, if we change from the current height to always use the
maximum, it re-introduces a bunch of ENOSPC issues resulting from
overcommitting user data space. That is, we must ensure that global
free space does not exhaust the free space that we need to refill
the AGFLs to enable an extent free at ENOSPC to proceed. i.e.
the mp->m_alloc_set_aside value (i.e. XFS_ALLOCBT_AGFL_RESERVE)
needs to reflect the fact this would change the minimum AGFL fill at
ENOSPC.

Further, changing to max reservation for the minimum fill fails to
recognoise that at ENOSPC, the free space trees are empty and so
will never split, and so a large minimum AGFL fill is completely
unnecessary - at most all we need is to have enough blocks in the
AGFL for the single level root split to occur (i.e. 2 blocks per
free space btree). That's waht the current XFS_ALLOCBT_AGFL_RESERVE
value is set to.

So, really, I don't see moving away from the variable minimum
reservation we currently have is a good idea. Adding a bit of
hysteresis to the AGFL fill/drain operations doesn't require
changing the min fill requirements, just picking a sensible target
above the current minimum fill...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
