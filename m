Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82FDEB64DB
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 03:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbjFODtQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 23:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240530AbjFODtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2023 23:49:08 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89048273B
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 20:48:58 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b3ce6607cbso34024185ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 20:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686800937; x=1689392937;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pa/fLPxyXVP0UBm20cOZEwQJu50yYgUkqjgCzPgz2QM=;
        b=yEQSF+W/5uoMakb/HLApFkRuUewKgDAOzLiYMBh8zS12Ib9fX/hJw9vwEPMrss9EfU
         l5rnxck4dbk8ExSACEIVZSyGuicHoQp1z41wL4yWmGxVMEiSrk4Qfk7mSWKEQ17SzwHV
         owbIIbAAGqPLLYv8IA05ZCu8YySRig62t5h8+NrjnL+pSbKd/44PmQ4mlAJxwzyT6l3X
         t5M5CtCF53KAUKQXaJhzEhLvPvXnyqu77PH+ddBPTAUIs5PiJC16cwgy4Vj6gbMp59Tq
         Te7b+xf6kv+d1sCETK2QzrSUc0SyZMYPxLh9npjjeszSyFPsFIcytYJ7GyJLBYZOICuG
         HCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686800937; x=1689392937;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pa/fLPxyXVP0UBm20cOZEwQJu50yYgUkqjgCzPgz2QM=;
        b=clNDDA/AvkBpUu63wHSFdzHUIcl6V2WaYqSNpEjyx8jfTk/2NBbF05rCZI1ZFsqcvG
         ghXVe+CEAshyGHzpMz9i1XqVPLhhOWoZcqPr+Q4aWPrK96D1bYHKPVgv22BmGwl2pXWz
         kH2FgwycoqTZ2D9OEQP3qpmimCG7F838zTisnt3gjiqrfRPJ5dgfbZS63qnj2TS/aNIg
         tl7uNiLIY4qRZRcs7xGOeCjYVgGPVpjS7fAHv2abw7INdsYuA1ANCKDOGbRnn/fqVNX1
         +l/yuPUtDqU0diPiE9JXWd444BneNjs/Uws1xMQOJtRlA0ogfkIphDhTdovVg7jJCqPj
         WsRA==
X-Gm-Message-State: AC+VfDyb3gBlJu4XUHDPkC8WraygOgn0iET1hapV4WsgKFCxuy5LMuMv
        lqoRssE6OMg87QYaOPKqSOQpwQ==
X-Google-Smtp-Source: ACHHUZ7Gf8HKYZ6cellnz+PsNEro18K3S9ffeyRZhUdScuYct9EST/nBA1Q23lusuSVvYbDnLqdcbw==
X-Received: by 2002:a17:902:f683:b0:1b0:577c:2cb with SMTP id l3-20020a170902f68300b001b0577c02cbmr17568760plg.25.1686800937168;
        Wed, 14 Jun 2023 20:48:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id jo23-20020a170903055700b001993a1fce7bsm12877606plb.196.2023.06.14.20.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 20:48:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q9dyg-00BvZC-1d;
        Thu, 15 Jun 2023 13:48:54 +1000
Date:   Thu, 15 Jun 2023 13:48:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        wen.gang.wang@oracle.com
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Message-ID: <ZIqKJgMvkil+6rNO@dread.disaster.area>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-2-david@fromorbit.com>
 <20230615033235.GL11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615033235.GL11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 14, 2023 at 08:32:35PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 15, 2023 at 11:41:59AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To avoid blocking in xfs_extent_busy_flush() when freeing extents
> > and the only busy extents are held by the current transaction, we
> > need to pass the XFS_ALLOC_FLAG_FREEING flag context all the way
> > into xfs_extent_busy_flush().
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 96 +++++++++++++++++++++------------------
> >  fs/xfs/libxfs/xfs_alloc.h |  2 +-
> >  fs/xfs/xfs_extent_busy.c  |  3 +-
> >  fs/xfs/xfs_extent_busy.h  |  2 +-
> >  4 files changed, 56 insertions(+), 47 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index c20fe99405d8..11bd0a1756a1 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -1536,7 +1536,8 @@ xfs_alloc_ag_vextent_lastblock(
> >   */
> >  STATIC int
> >  xfs_alloc_ag_vextent_near(
> > -	struct xfs_alloc_arg	*args)
> > +	struct xfs_alloc_arg	*args,
> > +	uint32_t		alloc_flags)
> 
> Is some bot going to complain about the uint32_t here vs the unsigned
> int in xfs_extent_busy_flush?

Huh. I thought I fixed that to use uint32_t all the way through.

Oooh, I fixed that in a later patch. Oops, my bad, I'll update it.

> Just to check my grokking here -- it's the ALLOC_FLAG_FREEING from
> xfs_free_extent_fix_freelist that we need to pass all the way to the
> bottom of the allocator?

Yes. It needs to propagate through xfs_alloc_fix_freelist() into
freelist block allocation...

> If the answers are 'no' and 'yes', then
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
