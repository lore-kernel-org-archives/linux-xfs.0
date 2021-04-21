Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7E5C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 03:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CA2E61417
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 03:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbhDUDCt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 23:02:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234783AbhDUDCs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 23:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618974136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xB+vapgB9Hqc15tgs9vKMexEe1gq8RqlnDIJP8LPypM=;
        b=LLCMOe6Hq8XbIj8AbeEUPN+II7onVy3GyHXHhdsZQPLZ4AVmzfZZJDZ++rTQTu2vsV4J/Q
        SijOp35rJIVpP4ydoIzUNBJRj2E+lUAZMg9YFC60Y0CYRKiieSufcv+OhhOhMwlrr1x4Ug
        o6oQXGVV+/F0BDnuN87AQNTo8ZqJL00=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-jZzdp3OkOB2IwL2D12Pqag-1; Tue, 20 Apr 2021 23:01:42 -0400
X-MC-Unique: jZzdp3OkOB2IwL2D12Pqag-1
Received: by mail-pf1-f199.google.com with SMTP id 9-20020a056a000729b029025d0d3c2062so4596122pfm.1
        for <linux-xfs@vger.kernel.org>; Tue, 20 Apr 2021 20:01:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xB+vapgB9Hqc15tgs9vKMexEe1gq8RqlnDIJP8LPypM=;
        b=BfFKbZgRhChtLgi055CYq+kCVdGaQa4dpXBy2qOxk761C9ZFFnJ56nzbCP05bAb2Aw
         9T9ALN5+EpmhQiK03S0v2lkM60ciXHza+0q15fEz2kojBSnntmpLjowly3B+ugPvXs2w
         KvZL4dqcD3oAu/1NwVNB+0dnFY+A9otpXDaR3xUiGJIOadr1RLntUQi/aypa9VBtqITe
         HuheVbXklKNvkNfJ4vSSqGMBvrIvfTvetqTCUYwS6J1L4U64PwVZL4dOUVxBrhTmPLa2
         pDr3KI4+pt0+cOD/XCtrvWNBmXo5tpiAWUPycWbuu+LnDWhxeZp3XJwQ1xeU4t4EVQ3Y
         qcXA==
X-Gm-Message-State: AOAM531JNl2iY+mcbuIFr2d2yTVlA47hY8bCEm6U7VbIe/vzIEkbDsKp
        MzhslWXfGS8hfqQEFkMktvhNISwH6c+Mhv0eswQzuhaBqAYsEi4ex+EL4zZHp5b18Ybmow49Al7
        S2hyTBqCx2DdtFQaXN2/h
X-Received: by 2002:a17:90a:3e43:: with SMTP id t3mr8824193pjm.216.1618974101028;
        Tue, 20 Apr 2021 20:01:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2Qdoo9TtFIa7MYpAIS5QW6nVSyTppSXFDLlaEm783GOsckylI9E30mbjeizW7FAzTndwxiA==
X-Received: by 2002:a17:90a:3e43:: with SMTP id t3mr8824164pjm.216.1618974100728;
        Tue, 20 Apr 2021 20:01:40 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u21sm321612pfm.89.2021.04.20.20.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 20:01:40 -0700 (PDT)
Date:   Wed, 21 Apr 2021 11:01:29 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 1/2] xfs: don't use in-core per-cpu fdblocks for
 !lazysbcount
Message-ID: <20210421030129.GA3095436@xiangao.remote.csb>
References: <20210420110855.2961626-1-hsiangkao@redhat.com>
 <20210420212506.GW63242@dread.disaster.area>
 <20210420215443.GA3047037@xiangao.remote.csb>
 <20210421014526.GY63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210421014526.GY63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 11:45:26AM +1000, Dave Chinner wrote:
> On Wed, Apr 21, 2021 at 05:54:43AM +0800, Gao Xiang wrote:
> > Hi Dave,
> > 
> > On Wed, Apr 21, 2021 at 07:25:06AM +1000, Dave Chinner wrote:
> > > On Tue, Apr 20, 2021 at 07:08:54PM +0800, Gao Xiang wrote:
> > > > There are many paths which could trigger xfs_log_sb(), e.g.
> > > >   xfs_bmap_add_attrfork()
> > > >     -> xfs_log_sb()
> > > > , which overrides on-disk fdblocks by in-core per-CPU fdblocks.
> > > > 
> > > > However, for !lazysbcount cases, on-disk fdblocks is actually updated
> > > > by xfs_trans_apply_sb_deltas(), and generally it isn't equal to
> > > > in-core per-CPU fdblocks due to xfs_reserve_blocks() or whatever,
> > > > see the comment in xfs_unmountfs().
> > > > 
> > > > It could be observed by the following steps reported by Zorro:
> > > > 
> > > > 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> > > > 2. mount $dev $mnt
> > > > 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> > > > 4. umount $mnt
> > > > 5. xfs_repair -n $dev
> > > > 
> > > > yet due to commit f46e5a174655 ("xfs: fold sbcount quiesce logging
> > > > into log covering"), xfs_sync_sb() will also be triggered if log
> > > > covering is needed and !lazysbcount when xfs_unmountfs(), so hard
> > > > to reproduce on kernel 5.12+ for clean unmount.
> > > > 
> > > > on-disk sb_icount and sb_ifree are also updated in
> > > > xfs_trans_apply_sb_deltas() for !lazysbcount cases, however, which
> > > > are always equal to per-CPU counters, so only fdblocks matters.
> > > > 
> > > > After this patch, I've seen no strange so far on older kernels
> > > > for the testcase above without lazysbcount.
> > > > 
> > > > Reported-by: Zorro Lang <zlang@redhat.com>
> > > > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > > ---
> > > > changes since v1:
> > > >  - update commit message.
> > > > 
> > > >  fs/xfs/libxfs/xfs_sb.c | 8 +++++++-
> > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > > index 60e6d255e5e2..423dada3f64c 100644
> > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > @@ -928,7 +928,13 @@ xfs_log_sb(
> > > >  
> > > >  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > > >  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > > -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > > +	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > > +		struct xfs_dsb	*dsb = bp->b_addr;
> > > > +
> > > > +		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);
> > > > +	} else {
> > > > +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > > +	}
> > > 
> > > THis really needs a comment explaining why this is done this way.
> > > It's not obvious from reading the code why we pull the the fdblock
> > > count off disk and then, in  xfs_sb_to_disk(), we write it straight
> > > back to disk.
> > > 
> > > It's also not clear to me that summing the inode counters is correct
> > > in the case of the !lazysbcount for the similar reasons - the percpu
> > > counter is not guaranteed to be absolutely accurate here, yet the
> > > values in the disk buffer are. Perhaps we should be updating the
> > > m_sb values in xfs_trans_apply_sb_deltas() for the !lazycount case,
> > > and only summing them here for the lazycount case...
> > 
> > But if updating m_sb values in xfs_trans_apply_sb_deltas(), we
> > should also update on-disk sb counters in xfs_trans_apply_sb_deltas()
> > and log sb for !lazysbcount (since for such cases, sb counter update
> > should be considered immediately.)
> 
> I don't follow - xfs_trans_apply_sb_deltas() already logs the
> changes to the superblock made in the transaction.
> 
> xfs_trans_unreserve_and_mod_sb() does the in-memory counter updates
> after xfs_trans_apply_sb_deltas() applies them to the on-disk
> superblock in the buffer and logs them.
> 
> But nowhere on a !lazysbcount setup are mp->m_sb.sb_fdcount/ifree/
> icount values being updated, and hence they are not valid at any
> time except for during log quiesce where all the in memory
> reservations have been removed and the per-cpu counters are synced
> to mp->m_sb.
> 
> I'm suggesting that xfs_trans_unreserve_and_mod_sb() also updates
> the mp->m_sb.sb_fdcount/ifree/icount values for !lazysbcount, as we
> currently do not do this and this will keep them uptodate for any
> caller of xfs_sb_to_disk().
> 
> i.e. we have three choices:
> 
> 1. avoid writing the counters in xfs_sb_to_disk() for !lazycount.
> 2. read them from the buffer before writing them back to the buffer.
> 3. keep them up to date correctly via xfs_trans_unreserve_and_mod_sb.
> 
> #1 is bad because there are cases where we want to write the
> counters even for !lazysbcount filesystems (e.g. mkfs, repair, etc).
> 
> #2 is essentially a hack around the fact that mp->m_sb is not kept
> up to date in the in-memory superblock for !lazysbcount filesystems.
> 
> #3 keeps the in-memory superblock up to date for !lazysbcount case
> so they are coherent with the on-disk values and hence we only need
> to update the in-memory superblock counts for lazysbcount
> filesystems before calling xfs_sb_to_disk().
> 
> #3 is my preferred solution.
> 
> > That will indeed cause more modification, I'm not quite sure if it's
> > quite ok honestly. But if you assume that's more clear, I could submit
> > an alternative instead later.
> 
> I think the version you posted doesn't fix the entire problem. It
> merely slaps a band-aid over the symptom that is being seen, and
> doesn't address all the non-coherent data that can be written to the
> superblock here.

As I explained on IRC as well, I think for !lazysbcount cases, fdblocks,
icount and ifree are protected by sb buffer lock. and the only users of
these three are:
 1) xfs_trans_apply_sb_deltas()
 2) xfs_log_sb()

So I've seen no need to update sb_icount, sb_ifree in that way (I mean
my v2, although I agree it's a bit hacky.) only sb_fdblocks matters.

But the reason why this patch exist is only to backport to old stable
kernels, since after [PATCH v2 2/2], we can get rid of all of
!lazysbcount cases upstream.

But if we'd like to do more e.g. by taking m_sb_lock, I've seen the
xfs codebase quite varies these years. and I modified some version
like http://paste.debian.net/1194481/

and I'm not sure if we be64_add_cpu() on-disk sb counters in
xfs_trans_apply_sb_deltas() and then mp->m_sb.sb_fdblocks +=
tp->t_fdblocks_delta again in xfs_trans_unreserve_and_mod_sb()
seems much better.

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

