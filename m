Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C6AC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 03:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AC14613B3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 03:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhD0DQK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Apr 2021 23:16:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231363AbhD0DQJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Apr 2021 23:16:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619493326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mqkI03DJBDHfBoV9aSTyBe7B81TPSkBVgHUxmHq6yAo=;
        b=Rdsmuotz3UsO9nDbE/mJZjSPHDpPhkGiuaW/qPHPweZu5/fNvVHmNj6vXjIyt9gmVD4gyj
        9IVuGxo2ixcEflEWbg72uh4GSCR85xCLLSAlvAVJ48p70IK7vx+cmeiVd3gvAcuL2+E842
        1wlpt3HdeXWwGmgU6qhszUXoW7VIv+8=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-KkpebBPPM9yE1pzbayYlrQ-1; Mon, 26 Apr 2021 23:15:24 -0400
X-MC-Unique: KkpebBPPM9yE1pzbayYlrQ-1
Received: by mail-pf1-f199.google.com with SMTP id q18-20020a056a000852b02902766388a3c5so3022649pfk.4
        for <linux-xfs@vger.kernel.org>; Mon, 26 Apr 2021 20:15:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mqkI03DJBDHfBoV9aSTyBe7B81TPSkBVgHUxmHq6yAo=;
        b=My8kYqXJ859G3Pj1k02+bxQB0ihFeV9Pa1wjngEq8xCZUwVdKIi3cZcdwgfb8d9nys
         a4+wd8VpgdvnI2JRc8zaBWAWk4vBWQAycVdIsU0Zo/q3qwn2Xbp69e6YJ9Mo18KsRRIh
         /RBiURGSiVVpVVRH264A0PnG0Kv49fHXWnaZVwjinuZAuNSxfJL8IvYQIpBz0qTAPinn
         zU3qrwCxAD86ctV9KjxWN/13waIt1EC271kBjAEbE26v9/IwzQR18CnTMms09/2etnKr
         PbyZdINhNv6shcsSERpvwgwmqHn9aRJM33DePvRnRdCEkymS7FcfaTLhi3bM1cRsawfX
         qKFw==
X-Gm-Message-State: AOAM533PHseXy7doviEHlJlBMzvhdr2mGmhQPNCT/iWgY5C1g5uCJeww
        lUq5ae3PFKK+XrdP+xHXNGuI+d3i/QBO2NJ/iMiJ53ttqF+02AZVtXcn39MxkBsEvRfh/NSOVek
        PIGu5QoF7ArM+0SRyCqxS
X-Received: by 2002:a62:d14a:0:b029:265:f99e:74d with SMTP id t10-20020a62d14a0000b0290265f99e074dmr21375852pfl.28.1619493323544;
        Mon, 26 Apr 2021 20:15:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfoc/nAL9ieUl4uymW0OGeY9b1EtfjoLiNLqMpQ9DneHbRWrIzt1/yYO0YiOfrGMf4J2kkLg==
X-Received: by 2002:a62:d14a:0:b029:265:f99e:74d with SMTP id t10-20020a62d14a0000b0290265f99e074dmr21375831pfl.28.1619493323270;
        Mon, 26 Apr 2021 20:15:23 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 187sm882270pff.139.2021.04.26.20.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 20:15:22 -0700 (PDT)
Date:   Tue, 27 Apr 2021 11:15:12 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: update superblock counters correctly for
 !lazysbcount
Message-ID: <20210427031512.GA4191429@xiangao.remote.csb>
References: <20210427011201.4175506-1-hsiangkao@redhat.com>
 <20210427030715.GE1251862@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210427030715.GE1251862@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Mon, Apr 26, 2021 at 08:07:15PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 27, 2021 at 09:12:01AM +0800, Gao Xiang wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Keep the mount superblock counters up to date for !lazysbcount
> > filesystems so that when we log the superblock they do not need
> > updating in any way because they are already correct.
> > 
> > It's found by what Zorro reported:
> > 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> > 2. mount $dev $mnt
> > 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> > 4. umount $mnt
> > 5. xfs_repair -n $dev
> > and I've seen no problem with this patch.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reported-by: Zorro Lang <zlang@redhat.com>
> > Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > 
> > As per discussion earilier [1], use the way Dave suggested instead.
> > Also update the line to
> > 	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
> > so it can fix the case above.
> > 
> > with XFS debug off, xfstests auto testcases fail on my loop-device-based
> > testbed with this patch and Darrick's [2]:
> > 
> > generic/095 generic/300 generic/600 generic/607 xfs/073 xfs/148 xfs/273
> > xfs/293 xfs/491 xfs/492 xfs/495 xfs/503 xfs/505 xfs/506 xfs/514 xfs/515
> 
> Hmm, with the following four patches applied:
> 
> https://lore.kernel.org/linux-xfs/20210427000204.GC3122264@magnolia/T/#u
> https://lore.kernel.org/linux-xfs/20210425225110.GD63242@dread.disaster.area/T/#t
> https://lore.kernel.org/linux-xfs/20210427011201.4175506-1-hsiangkao@redhat.com/T/#u
> https://lore.kernel.org/linux-xfs/20210427030232.GE3122264@magnolia/T/#u
> 
> I /think/ all the obvious problems with !lazysbcount filesystems are
> fixed.  The exceptions AFAICT are xfs/491 and xfs/492, which fuzz the
> summary counters; we'll deal with those later.

Yeah, I agree, some failure above may be due to my environment setting
and seems always failure (I use loop device). Also, it'd be better to
reconfirm on the Zorro's side.

I noticed xfs/491 and xfs/492, I think !lazysbcount filesystems just
blindly trust sb counters even with dirty log. So I think we might
just skip the testcase and that would be fine? (Or recalc with obvious
corrupted values...)

Thanks,
Gao Xiang

> 
> --D
> 
> > 
> > MKFS_OPTIONS="-mcrc=0 -llazy-count=0"
> > 
> > and these testcases above still fail without these patches or with
> > XFS debug on, so I've seen no regression due to this patch.
> > 
> > [1] https://lore.kernel.org/r/20210422030102.GA63242@dread.disaster.area/
> > [2] https://lore.kernel.org/r/20210425154634.GZ3122264@magnolia/
> > 
> >  fs/xfs/libxfs/xfs_sb.c | 16 +++++++++++++---
> >  fs/xfs/xfs_trans.c     |  3 +++
> >  2 files changed, 16 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 60e6d255e5e2..dfbbcbd448c1 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -926,9 +926,19 @@ xfs_log_sb(
> >  	struct xfs_mount	*mp = tp->t_mountp;
> >  	struct xfs_buf		*bp = xfs_trans_getsb(tp);
> >  
> > -	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > -	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > +	/*
> > +	 * Lazy sb counters don't update the in-core superblock so do that now.
> > +	 * If this is at unmount, the counters will be exactly correct, but at
> > +	 * any other time they will only be ballpark correct because of
> > +	 * reservations that have been taken out percpu counters. If we have an
> > +	 * unclean shutdown, this will be corrected by log recovery rebuilding
> > +	 * the counters from the AGF block counts.
> > +	 */
> > +	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > +		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > +		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > +	}
> >  
> >  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> >  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index bcc978011869..1e37aa8eca5a 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -629,6 +629,9 @@ xfs_trans_unreserve_and_mod_sb(
> >  
> >  	/* apply remaining deltas */
> >  	spin_lock(&mp->m_sb_lock);
> > +	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
> > +	mp->m_sb.sb_icount += idelta;
> > +	mp->m_sb.sb_ifree += ifreedelta;
> >  	mp->m_sb.sb_frextents += rtxdelta;
> >  	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
> >  	mp->m_sb.sb_agcount += tp->t_agcount_delta;
> > -- 
> > 2.27.0
> > 
> 

