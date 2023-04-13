Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6641DC77B6E
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 21:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjDMVjF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 17:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjDMVjE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 17:39:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A08A5ED
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 14:39:01 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id hg12so2043789pjb.2
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 14:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1681421940; x=1684013940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7tuyQgaNHNLCxLHGw+XulX/gOlkkzgXcDHuYAr5NA/A=;
        b=skWsCA//dy0qAwO/OdkAzKb0t0/RIMtUcXhcN1v4j3bHKzf5QJ06AcSrRHD2Yw7C1m
         jH9UH5ApAJ0xBcqsq3vQDjHkuIr18hNkgdEdeBmZEmo/KEmf2xD1zULs3KII0lhLzNm9
         9WuyTu+DRcDpblTix1An8Jsq1Sdg+xXlyh23oPyjtH6esfV0ML+TDqCrqievLelzUkrm
         KFH7aoOD8WKiqNGCIKLKrqGIdlGMMINnw9L8TSnBwLtie1Hzpp/pKdlFjLyDWtUEIC1e
         1MzMdGoAdmhklFLyBImyjNqHGRUNU0m+ql5eRuiz5l/S3gpeQQGh2CjdeQIaKbrpkPKb
         bwjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681421940; x=1684013940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7tuyQgaNHNLCxLHGw+XulX/gOlkkzgXcDHuYAr5NA/A=;
        b=JK51A0/Y6D4M1be0lvvct6eXa9J1QOTnq/RYqEOa0YU6AFJdeeeVqZIh/6PJXkJt4G
         S+4hxRUwIJLw5Gjaveef6vWHy8pZuKTolY18zhOIw1mTFnLucXEwFVCaOn2zu5xjY92U
         wRW79w6aZmm8na1VYXY67AO59typKD5iagEQw5U34te6N7dRrSjTUn/u5iK6TwX5PHgH
         MGQUjUhCicLgAuqOMsOH+N5hM2zFCBXHU3Ir2QqeZ0cVlqK5pt7lSUMrTF9dKONOTLj9
         k5V1jSOsLFTHgP+B79bQdOYc47gdT59SXC6CBTywidPn5C0SHDxJTpmb3uowUnNmupQo
         r1Mw==
X-Gm-Message-State: AAQBX9ebAz3VAkObJB/Me4N0cRDwteOeJC/uhnNAbYCeCwZcl/6gVymq
        zZFcgTqVBJzEZxTSmtBTSBVEm4IxEBydOh865NIkrA==
X-Google-Smtp-Source: AKy350Z1ILrvQhzdsjFIB1XoH/qk0c0f0mrf5qDNLP43jQHLqF18jMLWWxArxInDyoPmvnD6MrJAkQ==
X-Received: by 2002:a17:90a:fa3:b0:237:3dfb:9095 with SMTP id 32-20020a17090a0fa300b002373dfb9095mr3198415pjz.6.1681421940640;
        Thu, 13 Apr 2023 14:39:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id ep13-20020a17090ae64d00b00246a7401d23sm1739456pjb.41.2023.04.13.14.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 14:39:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pn4ef-0032dc-Dg; Fri, 14 Apr 2023 07:38:57 +1000
Date:   Fri, 14 Apr 2023 07:38:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix AGFL allocation dead lock
Message-ID: <20230413213857.GP3223426@dread.disaster.area>
References: <20230330204610.23546-1-wen.gang.wang@oracle.com>
 <20230411020624.GY3223426@dread.disaster.area>
 <87mt3djwj9.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230412235915.GN3223426@dread.disaster.area>
 <87sfd4jcyn.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfd4jcyn.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2023 at 03:46:38PM +0530, Chandan Babu R wrote:
> On Thu, Apr 13, 2023 at 09:59:15 AM +1000, Dave Chinner wrote:
> > On Wed, Apr 12, 2023 at 01:53:59PM +0530, Chandan Babu R wrote:
> >> Processing each of the "struct xfs_refcount_intent" can cause two refcount
> >> btree blocks to be freed:
> >> - A high level transacation will invoke xfs_refcountbt_free_block() twice.
> >> - The first invocation adds an extent entry to the transaction's busy extent
> >>   list. The second invocation can find the previously freed busy extent and
> >>   hence wait indefinitely for the busy extent to be flushed.
> >> 
> >> Also, processing a single "struct xfs_refcount_intent" can require the leaf
> >> block and its immediate parent block to be freed.  The leaf block is added to
> >> the transaction's busy list. Freeing the parent block can result in the task
> >> waiting for the busy extent (present in the high level transaction) to be
> >> flushed.
> >
> > Yes, it probably can, but this is a different problem - this is an
> > internal btree update issue, not a "free multiple user extents in a
> > single transaction that may only have a reservation large enough
> > for a single user extent modification".
> >
> > So, lets think about why the allocator might try to reuse a busy
> > extent on the next extent internal btree free operation in the
> > transaction.  The only way that I can see that happening is if the
> > AGFL needs refilling, and the only way the allocator should get
> > stuck in this way is if there are no other free extents in the AG.
> 
> If the first extent that was freed by the transaction (and hence also marked
> busy) happens to be the first among several other non-busy free extents found
> during AGFL allocation, the task will get blocked waiting for the busy extent
> flush to complete. However, this can be solved if xfs_alloc_ag_vextent_size()
> is modified to traverse the rest of the free space btree to find other
> non-busy extents. Busy extents can be flushed only as a last resort when
> non-busy extents cannot be found.

Yes, exactly my point: Don't block on busy extents if there are
other free space candidates available to can be allocated without
blocking.

> 
> >
> > It then follows that if there are no other free extents in the AG,
> > then we don't need to refill the AGFL, because freeing an extent in
> > an empty AG will never cause the free space btrees to grow. In which
> > case, we should not ever need to allocate from an extent that was
> > previously freed in this specific transaction.
> >
> > We should also have XFS_ALLOC_FLAG_FREEING set, and this allows the
> > AGFL refill to abort without error if there are no free blocks
> > available because it's not necessary in this case.  If we can't find
> > a non-busy extent after flushing on an AGFL fill for a
> > XFS_ALLOC_FLAG_FREEING operation, we should just abort the freelist
> > refill and allow the extent free operation to continue.
> 
> I tried in vain to figure out a correct way to perform non-blocking busy
> extent flush. If it involves using a timeout mechanism, then I don't know as
> to what constitues a good timeout value. Please let me know if you have any
> suggestions to this end.

Why would a non-blocking busy extent flush sleep? By definition,
"non blocking" means "does not context switch away from the current
task".

IOWs, a non-blocking busy extent flush is effectively just log force
operation. We may need to sample the generation number to determine
if progress has been made next time we get back to the "all extents
are busy so flush the busy extents" logic again, but otherwise I
think all we need do here is elide the "wait for generation number
to change" logic.

Then, if we've retried the allocation after a log force, and we
still haven't made progress and we are doing an AGFL allocation in
XFS_ALLOC_FLAG_FREEING context, then we can simply abort the
allocation attempt at this point. i.e. if we don't have extents we
can allocate immediately, don't bother waiting for busy extents to
be resolved...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
