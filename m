Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF83C46467
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 20:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjASUVJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 15:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjASUVI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 15:21:08 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17C39B136
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 12:21:02 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so6990160pjm.1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 12:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BF5xUSO1mcnACkpkTONFacqceZP5pCMlotXC3KikvN8=;
        b=wdcXB9eY7WUfcn1kg0nbGRJY2GLLHTUNVnFlE2Sxx4w/Qp2FpDZYqZk/4YYhsoPOeF
         Xv3sqEFiCi3MnKAuwZSHXQdi7jPnv6/YHgFQzzUezA4Am3LHsy9or0Nn6CML+JjS4GYq
         2RK3kqbxzhVv0oIkpdZDBhlXnzw/wzz9w/+3nK/hpnJdYBxNx/yeWiBwQc3zIpRDdc3N
         J9qrZiFx91WJdgeijoakplQTDPOeTHRQIVF7aquB0Bh175txj0szGdHAW2Rme929LFmK
         1+Yn5ln+BgmZxt6P6hDRk0indT6rnkfqOl75yXJEU6o94ggdKU2+YtZAlxxsYgBbPZkH
         Fixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BF5xUSO1mcnACkpkTONFacqceZP5pCMlotXC3KikvN8=;
        b=zXzgHQN3ECe6sq8BydAl98G2xIdzdSpLfpCwem6INu3twVhXI4fJWAk6fmR76EIcS5
         3KYyFaZGB8XTq/QIAhzQIsP0d/ENOxUQqWvT6lBeVPdQx2wBKOXUYnbFpKrxMoEBDk6a
         2dDXlHHYvZKT01hl8eRJenqUO2+5Ma7L7gcVBCndM3IXpH1AoJC5vbgoMKRtggrSQ9Gx
         IcR4cOz/FADeTK4O4kJfWYTzKrObG6YU1P6/sJAykfbHsG9LLaRdUztxdhcBucmpMqS5
         pnUnbpL0UVqIMIns1UTJFkrGJaSnqvvT/Y2jFRIwB7lblCYJZSSWi4z+leZbCLXzeeH9
         pH7Q==
X-Gm-Message-State: AFqh2krCC7y0aKg1NYa2TbZ7OwIDiXYZKVz2vuLF0dsxr/NgMd/zSsfm
        pyHk7wq/1E1kSRGF3FmJ4//bkw==
X-Google-Smtp-Source: AMrXdXs/5pM5LkFfWznCwWvxG+PSkAMx0FC71kY5DrChBo0hh0/NoidcQya6LrHn7PlQf3YM8CE0Nw==
X-Received: by 2002:a17:902:bd95:b0:194:6d3b:3a68 with SMTP id q21-20020a170902bd9500b001946d3b3a68mr12228373pls.5.1674159662123;
        Thu, 19 Jan 2023 12:21:02 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090341ca00b00192f4fbdeb5sm12064819ple.102.2023.01.19.12.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 12:21:01 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pIbP8-0054Zj-GN; Fri, 20 Jan 2023 07:20:58 +1100
Date:   Fri, 20 Jan 2023 07:20:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't use BMBT btree split workers for IO completion
Message-ID: <20230119202058.GK360264@dread.disaster.area>
References: <20230119010334.1982938-1-david@fromorbit.com>
 <Y8mM9rdRUU98+HEW@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8mM9rdRUU98+HEW@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 10:33:26AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 19, 2023 at 12:03:34PM +1100, Dave Chinner wrote:
> > The other place we can be called for a BMBT split without a
> > preceeding allocation is __xfs_bunmapi() when punching out the
> > center of an existing extent. We don't remove extents in the IO
> > path, so these operations don't tend to be called with a lot of
> > stack consumed. Hence we don't really need to ship the split off to
> > a worker thread in these cases, either.
> 
> So I agree with the fix.  But the t_firstblock seems a bit opaque.
> We do have a lot of comments, which is good but it still feels
> a little fragile to me.  Is there a good reason we can't do an
> explicit flag to document the intent better?

I don't see any point in adding flags to high level allocation APIs
that expose deeply internal btree modification implementation
details. Caller have no business knowing about this, have no idea
how much stack they might need or consume, what context a btree split
might occur in, etc. So I don't think there's any reason at all for
exposing this btree split offload implementation detail to any other
code.

As for the "documentation" aspect of the change, see the patchset I
just posted for "per-ag centric allocation". That fixes all the
existing problems with tp->t_firstblock and also converts it to
store an agno (i.e. tp->t_highest_agno) to make it clear that an AG
access restriction has been placed on this transaction.

That's exactly the situation that this deadlock avoidance needs to
be aware of, so I don't see any real need to duplicate this
information given the rework of the t-firstblock infrastructure that
is out for review.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
