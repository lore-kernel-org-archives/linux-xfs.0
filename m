Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D128EB64D8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 05:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjFVF2n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 01:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjFVF2l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 01:28:41 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5E61BD7
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 22:28:33 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id 6a1803df08f44-6300510605bso43418676d6.0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 22:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687411712; x=1690003712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FmOvZkiveTat0Hb5KTWqYTJAttJOOPZMPqlM/HFO/uU=;
        b=gW/ZWshQ/iYjaqL2t83ZPnXUL3Lf+zDEPAveKziE0hr45U3mae51RrpdoElvFtrs5+
         eYDJ9JDxI4E1t3LO/FOE69bNQSKBsIQ13i0KrVEwXrFN3ZEFuMeNOBauat0Dmsv1tcOQ
         cgqba2eF8+EAzmdrxxhoq91xUkHrnbsmumeB8BiLpNwOPgDfkOE6h0V0+Hn9Dn1vHVtD
         xD06ME4hiZb/1b+S8k8+c5QXrSOXLCvWqi2BxCDm+RrF3S98sMpcccPMXIfQJSlGuiNZ
         RRa3WXC0Jb49zUNEk7ToHT3hkLFjuovh43z2WK/DdBARZlgBmwJbdDTznILRCUERX4Y6
         zziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687411712; x=1690003712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FmOvZkiveTat0Hb5KTWqYTJAttJOOPZMPqlM/HFO/uU=;
        b=elX5JrSYn/DzdUGHMbxEs2w/MtHlh0C8nEU2gYL5xhfdFF6DXA1AYtzVCe+SmYwwAo
         Y5k02FR3G+85KAhLrUFMirZv/RuCl7hOA3TJHVECniK3+wr7qCojdST+9YgKEraHq6mW
         Td3MroZE1lolM8X6Ot/BW1KvVCZd2PuFQHUQXrqJiP3d/SJ4NFW/6remMxgVRGRmxEb/
         y6WkMLVzWmc7XFMSZpN+h1otVVOEUdQ4foOe7pWJBoSn5KN+lTJphm/07xfkTLuF2Orl
         9fe/7HzJLFP1RJFfGAAxHp9DqBlCA0ycysecXsm1ybRIMiK6aiJanhOn24sspBobwqvK
         TVwA==
X-Gm-Message-State: AC+VfDziM9+ali1eGOjjlTdTEw0Zy9U7Nxoq3oVtNNJ5ZQH+nuv5MnZY
        aZiegcr1YBOg9QtbuKaxso5/rQ==
X-Google-Smtp-Source: ACHHUZ4ihpObpRfYDfVs7THDPzwB9zmAm/AKd3tYjpjeKVqfSdxSgUDN+Nt0xrzE/s5f+LtfR+HhZg==
X-Received: by 2002:a05:6214:d0b:b0:62d:e1ab:a43 with SMTP id 11-20020a0562140d0b00b0062de1ab0a43mr18741899qvh.42.1687411712070;
        Wed, 21 Jun 2023 22:28:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id e24-20020a656498000000b00553ad4ae5e5sm3646558pgv.22.2023.06.21.22.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 22:28:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qCCrs-00EjJD-2X;
        Thu, 22 Jun 2023 15:28:28 +1000
Date:   Thu, 22 Jun 2023 15:28:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: don't block in busy flushing when freeing
 extents
Message-ID: <ZJPb/OR1q68NHgm4@dread.disaster.area>
References: <20230620002021.1038067-1-david@fromorbit.com>
 <20230620002021.1038067-5-david@fromorbit.com>
 <87a5wumafo.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZJIlmbuHIhu5BMG+@dread.disaster.area>
 <87h6r0nnvy.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6r0nnvy.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 22, 2023 at 09:29:46AM +0530, Chandan Babu R wrote:
> On Wed, Jun 21, 2023 at 08:18:01 AM +1000, Dave Chinner wrote:
> > On Tue, Jun 20, 2023 at 08:23:33PM +0530, Chandan Babu R wrote:
> >> On Tue, Jun 20, 2023 at 10:20:20 AM +1000, Dave Chinner wrote:
> >> > From: Dave Chinner <dchinner@redhat.com>
> >> >
> >> > If the current transaction holds a busy extent and we are trying to
> >> > allocate a new extent to fix up the free list, we can deadlock if
> >> > the AG is entirely empty except for the busy extent held by the
> >> > transaction.
> > ....
> >> > @@ -577,10 +588,23 @@ xfs_extent_busy_flush(
> >> >  	DEFINE_WAIT		(wait);
> >> >  	int			error;
> >> >  
> >> > -	error = xfs_log_force(mp, XFS_LOG_SYNC);
> >> > +	error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
> >> >  	if (error)
> >> > -		return;
> >> > +		return error;
> >> >  
> >> > +	/* Avoid deadlocks on uncommitted busy extents. */
> >> > +	if (!list_empty(&tp->t_busy)) {
> >> > +		if (alloc_flags & XFS_ALLOC_FLAG_TRYFLUSH)
> >> > +			return 0;
> >> > +
> >> > +		if (busy_gen != READ_ONCE(pag->pagb_gen))
> >> > +			return 0;
> >> > +
> >> > +		if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
> >> > +			return -EAGAIN;
> >> > +	}
> >> 
> >> In the case where a task is freeing an ondisk inode, an ifree transaction can
> >> invoke __xfs_inobt_free_block() twice; Once to free the inobt's leaf block and
> >> the next call to free its immediate parent block.
> >> 
> >> The first call to __xfs_inobt_free_block() adds the freed extent into the
> >> transaction's busy list and also into the per-ag rb tree tracking the busy
> >> extent. Freeing the second inobt block could lead to the following sequence of
> >> function calls,
> >> 
> >> __xfs_free_extent() => xfs_free_extent_fix_freelist() =>
> >> xfs_alloc_fix_freelist() => xfs_alloc_ag_vextent_size()
> >
> > Yes, I think you might be right. I checked inode chunks - they are
> > freed from this path via:
> >
> > xfs_ifree
> >   xfs_difree
> >     xfs_difree_inobt
> >       xfs_difree_inobt_chunk
> >         xfs_free_extent_later
> > 	  <queues an XEFI for deferred freeing>
> >
> > And I didn't think about the inobt blocks themselves because freeing
> > an inode can require allocation of finobt blocks and hence there's a
> > transaction reservation for block allocation on finobt enabled
> > filesystems. i.e. freeing can't proceed unless there is some amount
> > of free blocks available, and that's why the finobt has an amount of
> > per-ag space reserved for it.
> >
> > Hence, for finobt enabled filesystems, I don't think we can ever get
> > down to a completely empty AG and an AGFL that needs refilling from
> > the inode path - the metadata reserve doesn't allow the AG to be
> > completely emptied in the way that is needed for this bug to
> > manifest.
> >
> > Yes, I think it is still possible for all the free space to be busy,
> > and so when online discard is enabled we need to do the busy wait
> > after the log force to avoid that. However, for non-discard
> > filesystems the sync log force is all that is needed to resolve busy
> > extents outside the current transaction, so this wouldn't be an
> > issue for the current patchset.
> 
> Are you planning to post a new version of this patchset which would solve the
> possible cancellation of dirty transaction during freeing inobt blocks?  If
> not, I will spend some time to review the current version of the patchset.

I'm working on moving all the direct calls to xfs_free_extent to use
xfs_free_extent_later(). It will be a totally separate preparation
patch for the series, so everything else in the patchset should
largely remain unchanged.

I haven't finished the patch or tested it yet, but to give you an
idea of what and why, the commit message currently reads:

   xfs: use deferred frees for btree block freeing
   
   Btrees that aren't freespace management trees use the normal extent
   allocation and freeing routines for their blocks. Hence when a btree
   block is freed, a direct call to xfs_free_extent() is made and the
   extent is immediately freed. This puts the entire free space
   management btrees under this path, so we are stacking btrees on
   btrees in the call stack. The inobt, finobt and refcount btrees
   all do this.
   
   However, the bmap btree does not do this - it calls
   xfs_free_extent_later() to defer the extent free operation via an
   XEFI and hence it gets processed in deferred operation processing
   during the commit of the primary transaction (i.e. via intent
   chaining).
   
   We need to change xfs_free_extent() to behave in a non-blocking
   manner so that we can avoid deadlocks with busy extents near ENOSPC
   in transactions that free multiple extents. Inserting or removing a
   record from a btree can cause a multi-level tree merge operation and
   that will free multiple blocks from the btree in a single
   transaction. i.e. we can call xfs_free_extent() multiple times, and
   hence the btree manipulation transaction is vulnerable to this busy
   extent deadlock vector.
   
   To fix this, convert all the remaining callers of xfs_free_extent()
   to use xfs_free_extent_later() to queue XEFIs and hence defer
   processing of the extent frees to a context that can be safely
   restarted if a deadlock condition is detected.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
