Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B62C001B0
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 18:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjHHSu3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 14:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjHHSt5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 14:49:57 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A6115C62
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 09:59:51 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 006d021491bc7-56c85b723cfso3580515eaf.3
        for <linux-xfs@vger.kernel.org>; Tue, 08 Aug 2023 09:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691513985; x=1692118785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3fio3RZkyZiKE/XQcrLQEahB6++/2ebRHZg1oFXPG/8=;
        b=5I3T1tJmiUiyNP/dJNrNzGd3JId9uSuD6bartq2mQCkjJRsp5WTdEHVXabu2gzmWfm
         xtsNmM+lN8Arn/BVREjutXXLLWXDYfFEXefvu29QP6LZLbfkZabZoGGddsm0txL789ks
         FxjvAj8KnX5VinmU5J6IXHpfr5o4yAdpMqo2CgXnQO/G89FgfKmoULvNp2AiDKeuIvsb
         zAwVPttAV15PRZYsinD2OC8+w5F0cuB/wWBRoTw2Bs/agzNvKl01k/QEV585t1ErWNdW
         guTvVzYt34sWygMcr72uULFD3QAuKmeNrl2pJy40Z3V94LmJ2+5jUgUu15qOvDOBxAlt
         n7+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691513985; x=1692118785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3fio3RZkyZiKE/XQcrLQEahB6++/2ebRHZg1oFXPG/8=;
        b=Uyku8npRAOb/uhvzRUbuWWriPA8Q5WbkI4bD2f/4Fw1bbRk4GtywewBZLnc3G2uGsI
         bi4ieyW8GtbVRlrEARea9VgMRkk8wrzGFYK3qum9VQJA9ie2A9ctPFoUt4OULi3sevwN
         xk8yrAkcsgZGdSP6YIVzILgoY5OCuwELGrTzXumNl/XNY1NI+iY5NuOsRYNwMO9cs2f9
         OpByoCw3ZhcCJAZMdfjy+F4MWvD/pZ81X4b/jlDgXA72qBRSngreia6ls80LJrP5Z5dc
         rY0BLr6sh62WqWYI517OGP+G9hyfHF0SUSRnzHa4X0hcbz/qyRMKuRkB7tN/tEb0/0c2
         8Gog==
X-Gm-Message-State: AOJu0YzM7pxck47Yshj9Ntv2dMLLVJOyFmQbHqbvGG24VhSy/7Z9QGvF
        CG629l7tdr9iQrLbDbIH3C08Z7dixbmuXhWpcS4=
X-Google-Smtp-Source: AGHT+IECqNsmg3ICRn/Pg1uu5AcxsaV1MJCJAUFS+u54G0Gw9t5tjZiUQzSSIBLYr6NsOHNfkdLf4g==
X-Received: by 2002:a17:902:cec7:b0:1bc:73bf:304c with SMTP id d7-20020a170902cec700b001bc73bf304cmr3045501plg.48.1691471844763;
        Mon, 07 Aug 2023 22:17:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id i14-20020a17090332ce00b001b9de2b905asm7847748plr.231.2023.08.07.22.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 22:17:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qTF5t-002Zzf-2A;
        Tue, 08 Aug 2023 15:17:21 +1000
Date:   Tue, 8 Aug 2023 15:17:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v26.0 0/9] xfs: fix online repair block reaping
Message-ID: <ZNHP4TqsOQPIpiqf@dread.disaster.area>
References: <20230727221158.GE11352@frogsfrogsfrogs>
 <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
 <ZNCM35YJ/yroXI/n@dread.disaster.area>
 <20230808004007.GM11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808004007.GM11352@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 07, 2023 at 05:40:07PM -0700, Darrick J. Wong wrote:
> On Mon, Aug 07, 2023 at 04:19:11PM +1000, Dave Chinner wrote:
> > On Thu, Jul 27, 2023 at 03:18:32PM -0700, Darrick J. Wong wrote:
> > > Hi all,
> > > 
> > > These patches fix a few problems that I noticed in the code that deals
> > > with old btree blocks after a successful repair.
> > > 
> > > First, I observed that it is possible for repair to incorrectly
> > > invalidate and delete old btree blocks if they were crosslinked.  The
> > > solution here is to consult the reverse mappings for each block in the
> > > extent -- singly owned blocks are invalidated and freed, whereas for
> > > crosslinked blocks, we merely drop the incorrect reverse mapping.
> > > 
> > > A largeish change in this patchset is moving the reaping code to a
> > > separate file, because the code are mostly interrelated static
> > > functions.  For now this also drops the ability to reap file blocks,
> > > which will return when we add the bmbt repair functions.
> > > 
> > > Second, we convert the reap function to use EFIs so that we can commit
> > > to freeing as many blocks in as few transactions as we dare.  We would
> > > like to free as many old blocks as we can in the same transaction that
> > > commits the new structure to the ondisk filesystem to minimize the
> > > number of blocks that leak if the system crashes before the repair fully
> > > completes.
> > > 
> > > The third change made in this series is to avoid tripping buffer cache
> > > assertions if we're merely scanning the buffer cache for buffers to
> > > invalidate, and find a non-stale buffer of the wrong length.  This is
> > > primarily cosmetic, but makes my life easier.
> > > 
> > > The fourth change restructures the reaping code to try to process as many
> > > blocks in one go as possible, to reduce logging traffic.
> > > 
> > > The last change switches the reaping mechanism to use per-AG bitmaps
> > > defined in a previous patchset.  This should reduce type confusion when
> > > reading the source code.
> > > 
> > > If you're going to start using this mess, you probably ought to just
> > > pull from my git trees, which are linked below.
> > > 
> > > This is an extraordinary way to destroy everything.  Enjoy!
> > > Comments and questions are, as always, welcome.
> > 
> > Overall I don't see any red flags, so from that perspective I think
> > it's good to merge as is. THe buffer cache interactions are much
> > neater this time around.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Thanks!
> 
> > The main thing I noticed is that the deferred freeing mechanism ifo
> > rbulk reaping will add up to 128 XEFIs to the transaction. That
> > could result in a single EFI with up to 128 extents in it, right?
> 
> Welllp... the defer ops code only logs up to 16 extents per EFI log item
> due to my, er, butchering of max_items.  So in the end, we log up to 8x
> EFI items, each of which has up to 16y EFIs...
> 
> > What happens when we try to free that many extents in a single
> > transaction loop? The extent free processing doesn't have a "have we
> > run out of transaction reservation" check in it like the refcount
> > item processing does, so I don't think it can roll to renew the
> > transaction reservation if it is needed. DO we need to catch this
> > and renew the reservation by returning -EAGAIN from
> > xfs_extent_free_finish_item() if there isn't enough of a reservation
> > remaining to free an extent?
> 
> ...and by my estimation, those eight items consume a fraction of the
> reservation available with tr_itruncate:
> 
> 16 x xfs_extent_64_t   = 256 bytes
> 1 x xfs_efi_log_format = 8 bytes
>                        = 272 bytes per EFI
> 
> 8 x EFI                = 2176 bytes

I'm not worried by the EFIs themselves when they are created and
committed, it's the processing of the XEFIs which are all done in a
single transaction unless a ->finish_item() call returns -EAGAIN.
i.e. it's the xfs_trans_free_extent() calls that are done one after
another, and potential log different AG metadata blocks on each
extent free operation....

And it's not just runtime we have to worry about - if we crash and
have to recover on of these EFIs with 16 extents in it, we have the
problem of processing a 16 extent EFI on a single transaction
reservation, right?

> So far, I haven't seen any overflows with the reaping code -- for the AG
> btree rebuilders, we end up logging and relogging the same bnobt/cntbt
> buffers over and over again.  tr_itruncate gives us ~320K per transaction,
> and I haven't seen any overflows yet.

I suspect it might be different with aged filesystems where the
extents being freed could be spread across many, many btree leaf
nodes...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
