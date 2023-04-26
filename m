Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C32E5C7618E
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Apr 2023 23:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjDZXBm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Apr 2023 19:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjDZXBl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2023 19:01:41 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E57E2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2023 16:01:40 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64115eef620so802098b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2023 16:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682550100; x=1685142100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q1GjqbUr5uPuxpTPH2DZJPx9pQk8yCMCyOmJU4c6V/0=;
        b=BNvz9ENJPBbO3Q8OMTiekdGmNsWk481GGCaPKJpdlxTXDinpzhagO4lpMr0JvvcFqj
         6T6pdqK7Dbc6DxduoMohW3E1941rhybWAVz+WiGGb1q9UkSmvGr6umIQ6AE3hJYVmw+a
         eZMygJ4fGP94oJroC92v1p3jeuvjf6CWvyhUKj76rnddP8ReSeWkxrRD5jQ6mMhFCDNZ
         6n5EorAsTXOFIDXJva/7WNtjaFPkBHjiqX18Inufo/Y0/HOvDo1kOJm1nZqsdSaeMFq6
         dvnOsHGiXqxJ76q+5ZO7Wa9cuGbdIi8qrQ88O4TwMVucLIIkO2GR5LoXgw0F0DG2j9z1
         QaNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682550100; x=1685142100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1GjqbUr5uPuxpTPH2DZJPx9pQk8yCMCyOmJU4c6V/0=;
        b=OW++c165/RU0QAHGTMHKCYCnZWyg98RiYNfI05eEfzlSmIrwo8UjOQmvbSNPMbEFS5
         BCPj8g5nSQiylnud+2r6aNHnJjAExtCkBI4Byx0ma/faDqoz0ooZC45LvAtpc3ELuAhn
         LR3kvgTExVSv3MC728jRJj3HwckdJzGUH+aWfB6va54xS3e/rq+DaW/1FOhoVtEZlqOu
         Pao8mGziQZ/8Q5vUvH03XJdEg0fNngX7yrJ8DSToZ9nk550grjc9bTKHnZPYBkublm0r
         XCLrC9gL8hu5HYOWF7eW8GtXNmJQSw1xlfUJZsn+tZiZahSFMSrGUUeBsUkC106KwqDF
         Ac4A==
X-Gm-Message-State: AC+VfDylDv0Nk+rRg7SBVgDQncId9oWsVbq/YFI8OSjsAFSXUjLxf+QJ
        4klZX0K4gwByd3tEVwMwCVqiFg==
X-Google-Smtp-Source: ACHHUZ4wNZ4SIS1ySeHRqjvL8BO+boLWSrYkjWmHxA7UxB0ywg79yQ+ZGTZGFrHlCUEKyysENnpnvQ==
X-Received: by 2002:a17:902:f684:b0:1a6:9762:6eed with SMTP id l4-20020a170902f68400b001a697626eedmr4718297plg.22.1682550099861;
        Wed, 26 Apr 2023 16:01:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709028c8700b001a19bde435fsm10387110plo.65.2023.04.26.16.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 16:01:39 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pro8l-008GGh-GO; Thu, 27 Apr 2023 09:01:35 +1000
Date:   Thu, 27 Apr 2023 09:01:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] xfs: fix livelock in delayed allocation at ENOSPC
Message-ID: <20230426230135.GJ3223426@dread.disaster.area>
References: <20230421222440.2722482-1-david@fromorbit.com>
 <20230425152052.GT360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425152052.GT360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 25, 2023 at 08:20:52AM -0700, Darrick J. Wong wrote:
> On Sat, Apr 22, 2023 at 08:24:40AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > On a filesystem with a non-zero stripe unit and a large sequential
> > write, delayed allocation will set a minimum allocation length of
> > the stripe unit. If allocation fails because there are no extents
> > long enough for an aligned minlen allocation, it is supposed to
> > fall back to unaligned allocation which allows single block extents
> > to be allocated.
> > 
> > When the allocator code was rewritting in the 6.3 cycle, this
> > fallback was broken - the old code used args->fsbno as the both the
> > allocation target and the allocation result, the new code passes the
> > target as a separate parameter. The conversion didn't handle the
> > aligned->unaligned fallback path correctly - it reset args->fsbno to
> > the target fsbno on failure which broke allocation failure detection
> > in the high level code and so it never fell back to unaligned
> > allocations.
> > 
> > This resulted in a loop in writeback trying to allocate an aligned
> > block, getting a false positive success, trying to insert the result
> > in the BMBT. This did nothing because the extent already was in the
> > BMBT (merge results in an unchanged extent) and so it returned the
> > prior extent to the conversion code as the current iomap.
> > 
> > Because the iomap returned didn't cover the offset we tried to map,
> > xfs_convert_blocks() then retries the allocation, which fails in the
> > same way and now we have a livelock.
> > 
> > Reported-by: Brian Foster <bfoster@redhat.com>
> > Fixes: 85843327094f ("xfs: factor xfs_bmap_btalloc()")
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Insofar as this has revealed a whole ton of *more* problems in mkfs,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks, I've added this to for-next and I'll include it in the pull
req to Linus tomorrow because I don't want expose everyone using
merge window kernels to this ENOSPC issue even for a short while.

> Specifically: if I set su=128k,sw=4, some tests will try to format a
> 512M filesystem.  This results in an 8-AG filesystem with a log that
> fills up almost but not all of an entire AG.  The AG then ends up with
> an empty bnobt and an empty AGFL, and 25 missing blocks...

I used su=64k,sw=2 so I didn't see those specific issues. Mostly I
see failures due to mkfs warnings like this:

    +Warning: AG size is a multiple of stripe width.  This can cause performance
    +problems by aligning all AGs on the same disk.  To avoid this, run mkfs with
    +an AG size that is one stripe unit smaller or larger, for example 129248.

> ...oh and the new test vms that run this config failed to finish for
> some reason.  Sigh.

Yeah, I've had xfs_repair hang in xfs/155 a couple of times. Killing
the xfs_repair process allows everything to keep going. I suspect
it's a prefetch race/deadlock...

-Dave.

-- 
Dave Chinner
david@fromorbit.com
