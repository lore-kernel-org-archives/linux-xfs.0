Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F103C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 00:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiKCAfV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 20:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiKCAfU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 20:35:20 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30C365B5
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 17:35:19 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q1so270770pgl.11
        for <linux-xfs@vger.kernel.org>; Wed, 02 Nov 2022 17:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ibEoqc8NPaItnKyZatTvKMcMItOe7BxWGhuQzD4jP+k=;
        b=x+v2STpJWZxp1gjmWzyT+yOBV5/urx1+a/YUfOhQWsF/dgZzR+93sBIScBkjU/bA5e
         R8m2FSam40wAc9Gtuu8qYVIZfF3R8OM+Gt8Hip1TXrx+zJeXJ4cFtC6rqlSq1x1hdsyU
         +GfPm0rV6BRDHGjiXM+WbC4c20hY+wwMnKiWq04JdtcfZQ12ATCAXUdJacmutey5bVwk
         7ia2IIIrIKVHCSVUO9brlkcCqoxmFz2e8VdmGGEHKLtLC5w5HWYJP+QH5Q9bO6sHtYDa
         i1dRYETdTGeWzWknrSd3XC3I04YbmHGRE+6499ZWueoMn50LcUgN9IzpubY6c1TNBkhM
         uEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibEoqc8NPaItnKyZatTvKMcMItOe7BxWGhuQzD4jP+k=;
        b=PLSR4xZQgIXsyKiHdfsWC8zNB/LeyEBh+0eoAUP9wXQBv3e4PUw9nVJgKaqb8ujlPF
         frF25w/NzaeJF8sJuMs+aHkhZCoa3JA+0nyEu9NmEgvI2QojANOdWB3/3ws7g4UtBQta
         94xvWBJS3RT+Z2L1pwmkWbnYOWO1Gfjc/BhQjpDM04yOQ/4dpeB/d1skMtmpOBHTTktx
         zWzK1aa6qIGaXsK5RlKsZG1f+M5OZF91CCfTQnrvnzm/ZbT220LQ+nTuCWGer7O3DKOm
         dQvpCcfd60aRrPWVXA274h1bdVBVpD+Hj2UhUCD0JEPQEytMnfhJy4flIquaAm8Z8XCy
         89Qw==
X-Gm-Message-State: ACrzQf1T/Vrt0Dt1a6I5TXZuRbQZCm8nm/VMyK/ombVJi3ScuhFuo9mt
        Xd0O0OIU8tr47wPT4uy70TA4XQ==
X-Google-Smtp-Source: AMsMyM7WmsCqjPJZWmtruvaJ0AZibUOLWr3kaovjVRUyf0c6W8Ys9e2WW9QxK7jyk1VXEFGT9HsaVg==
X-Received: by 2002:a05:6a00:8cb:b0:52c:6962:2782 with SMTP id s11-20020a056a0008cb00b0052c69622782mr27440443pfu.81.1667435719391;
        Wed, 02 Nov 2022 17:35:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id q8-20020a170902dac800b0017854cee6ebsm8979914plx.72.2022.11.02.17.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 17:35:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oqOCR-009ZxH-9m; Thu, 03 Nov 2022 11:35:15 +1100
Date:   Thu, 3 Nov 2022 11:35:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/7] iomap: write iomap validity checks
Message-ID: <20221103003515.GD3600936@dread.disaster.area>
References: <20221101003412.3842572-1-david@fromorbit.com>
 <20221101003412.3842572-6-david@fromorbit.com>
 <Y2IsGbU6bbbAvksP@infradead.org>
 <Y2KeSU6w1kMi6Aer@magnolia>
 <Y2KhurifaYbxkyNX@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2KhurifaYbxkyNX@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 02, 2022 at 09:58:34AM -0700, Darrick J. Wong wrote:
> On Wed, Nov 02, 2022 at 09:43:53AM -0700, Darrick J. Wong wrote:
> > On Wed, Nov 02, 2022 at 01:36:41AM -0700, Christoph Hellwig wrote:
> > > On Tue, Nov 01, 2022 at 11:34:10AM +1100, Dave Chinner wrote:
> > > > +	/*
> > > > +	 * Now we have a locked folio, before we do anything with it we need to
> > > > +	 * check that the iomap we have cached is not stale. The inode extent
> > > > +	 * mapping can change due to concurrent IO in flight (e.g.
> > > > +	 * IOMAP_UNWRITTEN state can change and memory reclaim could have
> > > > +	 * reclaimed a previously partially written page at this index after IO
> > > > +	 * completion before this write reaches this file offset) and hence we
> > > > +	 * could do the wrong thing here (zero a page range incorrectly or fail
> > > > +	 * to zero) and corrupt data.
> > > > +	 */
> > > > +	if (ops->iomap_valid) {
> > > > +		bool iomap_valid = ops->iomap_valid(iter->inode, &iter->iomap);
> > > > +
> > > > +		if (!iomap_valid) {
> > > > +			iter->iomap.flags |= IOMAP_F_STALE;
> > > > +			status = 0;
> > > > +			goto out_unlock;
> > > > +		}
> > > > +	}
> > > 
> > > So the design so far has been that everything that applies at a page (or
> > > now folio) level goes into iomap_page_ops, not iomap_ops which is just
> > > the generic iteration, and I think we should probably do it that way.
> > 
> > I disagree here -- IMHO the sequence number is an attribute of the
> > iomapping, not the folio.
> 
> OFC now that I've reread iomap.h I realize that iomap_page_ops are
> passed back via struct iomap, so I withdraw this comment.

My first thought was to make this a page op, but I ended up deciding
against that because it isn't operating on the folio at all.
Perhaps I misunderstood what "page_ops" was actually intended for,
because it seems that the existing hooks are to allow the filesystem
to wrap per-folio operations with an external context, not to
perform iomap-specific per-folio operations.

I guess if I read "pageops" as "operations to perform on each folio
in an operation", then validating the iomap is not stale once the
folio is locked could be considered a page op. I think we could
probably make that work for writeback, too, because we have the
folio locked when we call ->map_blocks....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
