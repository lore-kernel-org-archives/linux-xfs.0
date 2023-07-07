Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5983EB64D9
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Jul 2023 00:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjGGAgT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 20:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjGGAgT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2023 20:36:19 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412311990
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jul 2023 17:36:18 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b7e6512973so9155495ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jul 2023 17:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1688690178; x=1691282178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4GYppqdg4p8XG3PenGRJPoVGYW1mWF9SEVMjOUksyA=;
        b=jZTaP0Po9JGbgOVjxpIt29QHZIVLWP7B7lYpQo8Cxg0Jiuc9DtWRdvC1EfM6a94Qn4
         AI4z+BSJgeYYm85ECK7nxV054oRtnfTnHsh/gk4e0+FoOGX5xDAzG5LNyjmXYitI4CAV
         ZYbzP/UIzC+yuMmOJ5S9aHMWX8sDSJifBYi/QefmziC17cUIq8FqQVUttRxioxyLUa3/
         JN/QdcogYYkx7HjQrU3Tl4ap+QMAbLZ5Q0vrDw60eDKFJd4rp8gMEuLB6AXVYDIEmQV1
         tVZV69TKyicwaQ0Fv/h4840Cyzi1lEFkbeNSYDTrBY4xW11rz0bWmjwXdslLu/zBamde
         2iiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688690178; x=1691282178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y4GYppqdg4p8XG3PenGRJPoVGYW1mWF9SEVMjOUksyA=;
        b=X4fzJ71nVccQ9Z0rNZ1TUknKE/BSV3fnMLySxh12EHCr1NTy0UgG0zqqMaSqTzbL3t
         JC0NGhp0FlCRFP6X2q5fFzWOvBAXyzojr7zw9HpIHdvtP14AS3bvK1BSgAun1bMG1qiC
         1pK20VzuTRgAQCw8nN8/aAMmOVvdhARt7C0qmNDG8St2++Pk8lNaT5Sk49rR7xWo0jOx
         c/ckGRtxe9aJ5PWPhdxXyFXC5keAYMkOQ3pkX7J9/dQ9FlZufL7Z9jLCRaeJ7IOtAtug
         u6CD+R3bFH1b1ODxvKCea8yvQfiRmMphn9HX2rlfg11uVMlS0zjC0kBs+ZCtW8ghxUj3
         MtFw==
X-Gm-Message-State: ABy/qLaJEgTpx4kfbS6mLYKEWH+UED1z69Wj8U9y1B2C0o60y1PCscKG
        4TCK7vVo1LyZgvQKgT6QloQyAw==
X-Google-Smtp-Source: APBJJlHVfK6DeYScgy77OYV1aYW0gOqrcO02dUUzBFhI+SAz2cpby0tFKrwazPq1UxMOPHzorztJHw==
X-Received: by 2002:a17:903:32cf:b0:1b8:94e9:e7d2 with SMTP id i15-20020a17090332cf00b001b894e9e7d2mr3346227plr.0.1688690177763;
        Thu, 06 Jul 2023 17:36:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-214-123.pa.vic.optusnet.com.au. [49.186.214.123])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902bf4b00b001b84cd8814bsm1950192pls.65.2023.07.06.17.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 17:36:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qHZSI-0030hS-0w;
        Fri, 07 Jul 2023 10:36:14 +1000
Date:   Fri, 7 Jul 2023 10:36:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        kernel-team@fb.com, Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 0/6] xfs: CPU usage optimizations for realtime allocator
Message-ID: <ZKdd/ujQYG6yG3qw@dread.disaster.area>
References: <cover.1687296675.git.osandov@osandov.com>
 <ZKc0fCe9AtkRtDLB@telecaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKc0fCe9AtkRtDLB@telecaster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 06, 2023 at 02:39:08PM -0700, Omar Sandoval wrote:
> On Tue, Jun 20, 2023 at 02:32:10PM -0700, Omar Sandoval wrote:
> > Hello,
> > 
> > Our distributed storage system uses XFS's realtime device support as a
> > way to split an XFS filesystem between an SSD and an HDD -- we configure
> > the HDD as the realtime device so that metadata goes on the SSD and data
> > goes on the HDD.
> > 
> > We've been running this in production for a few years now, so we have
> > some fairly fragmented filesystems. This has exposed various CPU
> > inefficiencies in the realtime allocator. These became even worse when
> > we experimented with using XFS_XFLAG_EXTSIZE to force files to be
> > allocated contiguously.
> > 
> > This series adds several optimizations that don't change the realtime
> > allocator's decisions, but make them happen more efficiently, mainly by
> > avoiding redundant work. We've tested these in production and measured
> > ~10% lower CPU utilization. Furthermore, it made it possible to use
> > XFS_XFLAG_EXTSIZE to force contiguous allocations -- without these
> > patches, our most fragmented systems would become unresponsive due to
> > high CPU usage in the realtime allocator, but with them, CPU utilization
> > is actually ~4-6% lower than before, and disk I/O utilization is 15-20%
> > lower.
> > 
> > Patches 2 and 3 are preparations for later optimizations; the remaining
> > patches are the optimizations themselves.
> > 
> > This is based on Linus' tree as of today (commit
> > 692b7dc87ca6d55ab254f8259e6f970171dc9d01).
> > 
> > Thanks!
> > 
> > Omar Sandoval (6):
> >   xfs: cache last bitmap block in realtime allocator
> >   xfs: invert the realtime summary cache
> >   xfs: return maximum free size from xfs_rtany_summary()
> >   xfs: limit maxlen based on available space in
> >     xfs_rtallocate_extent_near()
> >   xfs: don't try redundant allocations in xfs_rtallocate_extent_near()
> >   xfs: don't look for end of extent further than necessary in
> >     xfs_rtallocate_extent_near()
> > 
> >  fs/xfs/libxfs/xfs_rtbitmap.c | 173 ++++++++++++++--------------
> >  fs/xfs/xfs_mount.h           |   6 +-
> >  fs/xfs/xfs_rtalloc.c         | 215 ++++++++++++++++-------------------
> >  fs/xfs/xfs_rtalloc.h         |  28 +++--
> >  4 files changed, 207 insertions(+), 215 deletions(-)
> 
> Gentle ping.

Sorry, I haven't had time to get to this yet. I've still got a
couple more bug reports to work through before I can really start
thinking about looking at anything else..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
