Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 964E8EB64D7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 22:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjFTWSG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 18:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjFTWSG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 18:18:06 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B1710CE
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 15:18:05 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6687446eaccso2543717b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 15:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687299485; x=1689891485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BkIl1UnQCwX0vIkJitry3Q7s1nMG6ac5106x/B7Gu6A=;
        b=RxJpP2fDAxX4kHVHLsbj7KIxVfOLFe1TLmOC3TUkOy2OVvS+7S8YUPhcq5zSZFV3Oz
         3UUa5VAKsbQR9DaCE523DZMQn0GAy5c4EATk5gGUQPs27DCuB2PJHSEV5ia+cdBV/ikj
         OQLCgtoAUpQh82wu9aZuqKs5FV7hsICVBDULCFQj4gXEs4zNZXIimBGfan0Yb+ko2fOB
         KFTTT22alKIub8qe9q2U6c8/d94NNnb0wrQcEMbgry6TdWrOMeVmTy2Lk0fEBN4sb2dX
         h40zzyL/gAgw29nOAmVkLe0PAkfwTSjZhPoYgKFDYaXgGx5rY7BAIlOYrSmV3gMhpxOE
         8vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687299485; x=1689891485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BkIl1UnQCwX0vIkJitry3Q7s1nMG6ac5106x/B7Gu6A=;
        b=A1i8X2HVuCaNo36DCiygHfjkH1jZH2vw/Nglislf5oOBUASo18+8EAYVhh+fyFqVu3
         Gpon5cxavXMlZK0z/jLCVoomYsjznxX68IlgylIZC8SxaWKzJ+GvaP7j0xQKQ/7M3Bqf
         xRJYlDOfZ7j4wUPSdMcH9cEFVpJrbnzQ7R49feVXkJdCNe+dCl85KO9I8K65emjHky6E
         GxE3Uf9qZpTQH4Pgh7+9IIvHIZHlQm1bfmuEg+GpjvK/fVUOaIezSGpJw7PcD2MTIOkL
         kgbe/a7/VPXIyplpCFfwz4RCSEGeNfcirlfI0BiIOJDmkyHjr6DOOt3XJ/t5U62gDawX
         Jrkw==
X-Gm-Message-State: AC+VfDzhxHauKlJO8hLa0jwEMq2YTRXu6wzcDkog6oJELVYHTl50PUJz
        /qmZZYgQt339+S14Y7WuZtLNYw==
X-Google-Smtp-Source: ACHHUZ70QnI6gUt911sDkuNKrf5SZ09GBowxFGcdpjzSt1FJDZwUCYlkK56a/dN3jIHvtxLT3lf8HA==
X-Received: by 2002:a05:6a00:1a56:b0:658:c1a9:becc with SMTP id h22-20020a056a001a5600b00658c1a9beccmr19560751pfv.12.1687299484711;
        Tue, 20 Jun 2023 15:18:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id s23-20020a634517000000b0053ba104c113sm1853368pga.72.2023.06.20.15.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 15:18:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qBjfl-00EDFG-10;
        Wed, 21 Jun 2023 08:18:01 +1000
Date:   Wed, 21 Jun 2023 08:18:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: don't block in busy flushing when freeing
 extents
Message-ID: <ZJIlmbuHIhu5BMG+@dread.disaster.area>
References: <20230620002021.1038067-1-david@fromorbit.com>
 <20230620002021.1038067-5-david@fromorbit.com>
 <87a5wumafo.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5wumafo.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 08:23:33PM +0530, Chandan Babu R wrote:
> On Tue, Jun 20, 2023 at 10:20:20 AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > If the current transaction holds a busy extent and we are trying to
> > allocate a new extent to fix up the free list, we can deadlock if
> > the AG is entirely empty except for the busy extent held by the
> > transaction.
....
> > @@ -577,10 +588,23 @@ xfs_extent_busy_flush(
> >  	DEFINE_WAIT		(wait);
> >  	int			error;
> >  
> > -	error = xfs_log_force(mp, XFS_LOG_SYNC);
> > +	error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
> >  	if (error)
> > -		return;
> > +		return error;
> >  
> > +	/* Avoid deadlocks on uncommitted busy extents. */
> > +	if (!list_empty(&tp->t_busy)) {
> > +		if (alloc_flags & XFS_ALLOC_FLAG_TRYFLUSH)
> > +			return 0;
> > +
> > +		if (busy_gen != READ_ONCE(pag->pagb_gen))
> > +			return 0;
> > +
> > +		if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
> > +			return -EAGAIN;
> > +	}
> 
> In the case where a task is freeing an ondisk inode, an ifree transaction can
> invoke __xfs_inobt_free_block() twice; Once to free the inobt's leaf block and
> the next call to free its immediate parent block.
> 
> The first call to __xfs_inobt_free_block() adds the freed extent into the
> transaction's busy list and also into the per-ag rb tree tracking the busy
> extent. Freeing the second inobt block could lead to the following sequence of
> function calls,
> 
> __xfs_free_extent() => xfs_free_extent_fix_freelist() =>
> xfs_alloc_fix_freelist() => xfs_alloc_ag_vextent_size()

Yes, I think you might be right. I checked inode chunks - they are
freed from this path via:

xfs_ifree
  xfs_difree
    xfs_difree_inobt
      xfs_difree_inobt_chunk
        xfs_free_extent_later
	  <queues an XEFI for deferred freeing>

And I didn't think about the inobt blocks themselves because freeing
an inode can require allocation of finobt blocks and hence there's a
transaction reservation for block allocation on finobt enabled
filesystems. i.e. freeing can't proceed unless there is some amount
of free blocks available, and that's why the finobt has an amount of
per-ag space reserved for it.

Hence, for finobt enabled filesystems, I don't think we can ever get
down to a completely empty AG and an AGFL that needs refilling from
the inode path - the metadata reserve doesn't allow the AG to be
completely emptied in the way that is needed for this bug to
manifest.

Yes, I think it is still possible for all the free space to be busy,
and so when online discard is enabled we need to do the busy wait
after the log force to avoid that. However, for non-discard
filesystems the sync log force is all that is needed to resolve busy
extents outside the current transaction, so this wouldn't be an
issue for the current patchset.

I suspect that is why I haven't seen issues on v5 filesystems,
though I also haven't seen issues on v4 filesystems that don't have
the finobt per-ag metadata reservation nor the space reservation at
transaction reservation time. I know that the fstests enospc group
is exercising the busy flush code, but I doubt that it was exercised
through the inode btree block freeing path...

I note that the refcount btree block freeing path also call
xfs_free_extent(). This might be OK, because refcount btree updates
get called from deferred intent processing, and hence the EAGAIN
will trigger a transaction roll and retry correctly.

I suspect, however, that both of these paths should simply call
xfs_free_extent_later() to queue an XEFI for deferred processing,
and that takes the entire extent freeing path out from under the
btree operations. 

I'll look into that. Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
