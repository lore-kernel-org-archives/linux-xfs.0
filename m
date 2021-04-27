Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41A2C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 14:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7272601FC
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 14:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbhD0O0Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 10:26:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236358AbhD0O0V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 10:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619533537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VV1vs7m19WfPvDHvy3Gut/vp9pL2IlMno2ml4UlBI+c=;
        b=fKzVJ+Zff/IfULlLsQg99JMswAFkPeKliWMSa8D4657VQK0MqTDiDXACuSusQh0hWAhayR
        yVXz6EvHWGQS/wr0eBMVmX1VfcKffavwVVk+8WqNeig8Zf99bfNPUtZSClpf7K2DGghMrj
        pftIoqCmUeZlm/Q9wZw3kPuE0P4CVew=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-oq10KsTvPM-udhN_Ixilug-1; Tue, 27 Apr 2021 10:25:34 -0400
X-MC-Unique: oq10KsTvPM-udhN_Ixilug-1
Received: by mail-qv1-f70.google.com with SMTP id x15-20020a0ce0cf0000b029019cb3e75c62so26000477qvk.15
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 07:25:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VV1vs7m19WfPvDHvy3Gut/vp9pL2IlMno2ml4UlBI+c=;
        b=a1yj5VLURl1+WHO4AN3+Ucn+cqfiA0bT9md5vy0nbYmU0vfHS6I/1w+9++JkG+lafK
         RSo2pyH4S77ST96gDqE8VfNx5WzFurC6yY02BlgJ5Zm0QiDuTIRYz0T6cFJwHCgGOj21
         5FdRif0blhdfN2idv6BlE14mUajg90O9YUr2dkq9eH/XCDlK0Wen0n5fUZUmQquH/1DH
         9GiGqr7y40Yy5OeAwo/YhREgsoZJix4Dt3kcydXugcvyo5gETyJoywS6Wr2rGZ+tf86V
         jlvm6tqp0bmbcbwvjnK+nqAllOYalOB27HIvyoalxpVQEMxO327dfw845yTEbSINHbgN
         vMKA==
X-Gm-Message-State: AOAM533FfRRkqW4fHU5/UinLKMkgmYG0ahfHU4eWsy3Z/8VcICT4pc4p
        +mDovxiP80KHSNz/MM1zlvZTzsjvg2IJykyAwDJuLcbf14VXFV3gl4366RSnGblXsutoqF/VhxW
        o1Qyy79IFor/aAoEOOagv
X-Received: by 2002:ac8:470e:: with SMTP id f14mr22091567qtp.54.1619533534254;
        Tue, 27 Apr 2021 07:25:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzokPEczqMiAwkJKmSH1B6JswSwmExeMatbYDCbNW3s7WGAH6TdIGDE5Z21uunqQyPtF88p6Q==
X-Received: by 2002:ac8:470e:: with SMTP id f14mr22091546qtp.54.1619533533991;
        Tue, 27 Apr 2021 07:25:33 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id l16sm2958905qkg.91.2021.04.27.07.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 07:25:33 -0700 (PDT)
Date:   Tue, 27 Apr 2021 10:25:31 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: update superblock counters correctly for
 !lazysbcount
Message-ID: <YIge2/FRLy4Xjvcp@bfoster>
References: <20210427011201.4175506-1-hsiangkao@redhat.com>
 <YIgHoSvI4oj9bPER@bfoster>
 <20210427131318.GA103178@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427131318.GA103178@xiangao.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:13:18PM +0800, Gao Xiang wrote:
> On Tue, Apr 27, 2021 at 08:46:25AM -0400, Brian Foster wrote:
> > On Tue, Apr 27, 2021 at 09:12:01AM +0800, Gao Xiang wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Keep the mount superblock counters up to date for !lazysbcount
> > > filesystems so that when we log the superblock they do not need
> > > updating in any way because they are already correct.
> > > 
> > > It's found by what Zorro reported:
> > > 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> > > 2. mount $dev $mnt
> > > 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> > > 4. umount $mnt
> > > 5. xfs_repair -n $dev
> > > and I've seen no problem with this patch.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Reported-by: Zorro Lang <zlang@redhat.com>
> > > Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > 
> > Could you provide a bit more detail on the problem in the commit log?
> > From the description and code change, it seems like there is some
> > problem with doing the percpu aggregation in xfs_log_sb() on
> > !lazysbcount filesystems. Therefore this patch reserves that behavior
> > for lazysbcount, and instead enables per-transaction updates in the
> > !lazysbcount specific cleanup path. Am I following that correctly?
> 
> This patch inherited from Dave's patch [1] (and I added reproduable
> steps),
> https://lore.kernel.org/r/20210422014446.GZ63242@dread.disaster.area
> 
> More details see my original patch v2:
> https://lore.kernel.org/r/20210420110855.2961626-1-hsiangkao@redhat.com
> 

Ok, thanks. So the bit about xfs_log_sb() is to avoid an incorrect
overwrite of the in-core sb counters from the percpu counters on
!lazysbcount. The xfs_trans_apply_sb_deltas() function already applies
the transaction deltas to the on-disk superblock buffer, so the change
to xfs_trans_unreserve_and_mod_sb() is basically to apply those same
deltas to the in-core superblock so they are consistent in the
!lazysbcount case... yes? If I'm following that correctly, this looks
good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Thanks,
> Gao Xiang
> 
> > 
> > Brian
> > 
> > > 
> > > As per discussion earilier [1], use the way Dave suggested instead.
> > > Also update the line to
> > > 	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
> > > so it can fix the case above.
> > > 
> > > with XFS debug off, xfstests auto testcases fail on my loop-device-based
> > > testbed with this patch and Darrick's [2]:
> > > 
> > > generic/095 generic/300 generic/600 generic/607 xfs/073 xfs/148 xfs/273
> > > xfs/293 xfs/491 xfs/492 xfs/495 xfs/503 xfs/505 xfs/506 xfs/514 xfs/515
> > > 
> > > MKFS_OPTIONS="-mcrc=0 -llazy-count=0"
> > > 
> > > and these testcases above still fail without these patches or with
> > > XFS debug on, so I've seen no regression due to this patch.
> > > 
> > > [1] https://lore.kernel.org/r/20210422030102.GA63242@dread.disaster.area/
> > > [2] https://lore.kernel.org/r/20210425154634.GZ3122264@magnolia/
> > > 
> > >  fs/xfs/libxfs/xfs_sb.c | 16 +++++++++++++---
> > >  fs/xfs/xfs_trans.c     |  3 +++
> > >  2 files changed, 16 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index 60e6d255e5e2..dfbbcbd448c1 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -926,9 +926,19 @@ xfs_log_sb(
> > >  	struct xfs_mount	*mp = tp->t_mountp;
> > >  	struct xfs_buf		*bp = xfs_trans_getsb(tp);
> > >  
> > > -	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > > -	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > +	/*
> > > +	 * Lazy sb counters don't update the in-core superblock so do that now.
> > > +	 * If this is at unmount, the counters will be exactly correct, but at
> > > +	 * any other time they will only be ballpark correct because of
> > > +	 * reservations that have been taken out percpu counters. If we have an
> > > +	 * unclean shutdown, this will be corrected by log recovery rebuilding
> > > +	 * the counters from the AGF block counts.
> > > +	 */
> > > +	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > +		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > > +		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > +	}
> > >  
> > >  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > >  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index bcc978011869..1e37aa8eca5a 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -629,6 +629,9 @@ xfs_trans_unreserve_and_mod_sb(
> > >  
> > >  	/* apply remaining deltas */
> > >  	spin_lock(&mp->m_sb_lock);
> > > +	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
> > > +	mp->m_sb.sb_icount += idelta;
> > > +	mp->m_sb.sb_ifree += ifreedelta;
> > >  	mp->m_sb.sb_frextents += rtxdelta;
> > >  	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
> > >  	mp->m_sb.sb_agcount += tp->t_agcount_delta;
> > > -- 
> > > 2.27.0
> > > 
> > 
> 

