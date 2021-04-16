Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E43FC433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 21:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48ABB610E7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 21:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344460AbhDPVhE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 17:37:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235540AbhDPVhD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 17:37:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618608998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VZAjesK2z2R8VugmlCZytMnFJofl777hwBAWoU5UK5c=;
        b=cLB1DC/eWxYI2WKwXW4qKhSJDZAw6ufOL1RXb7JSbANDSttO1Nkgbzw18jiWiGMxW73AaE
        27c8yoi8TQ0IIgWQsMSyoAlncxEzkOkDjDqoYMdwJC+vAG4Wioen8y0Pb5dzWav/qFo4Qo
        Ejv+xEP3HoJOF6eTK7s5Ax4N3zb6cE8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-b1_T0Y80POi_gMpnCZLBNw-1; Fri, 16 Apr 2021 17:36:36 -0400
X-MC-Unique: b1_T0Y80POi_gMpnCZLBNw-1
Received: by mail-pg1-f197.google.com with SMTP id f2-20020a63c5020000b02901fc39812e44so3544504pgd.6
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 14:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VZAjesK2z2R8VugmlCZytMnFJofl777hwBAWoU5UK5c=;
        b=t5hnT0u/ADZvkInGyyPYDAUPp1PJniP2CS/pfMF1lw4AxSTNqbb6rD/2b8dLjP4XYs
         Pi9BJp3xJNaS60uXAhVn4m6tors+mb3SCKilhAPDVIvU0D3Ts5je+hw94YZMsGtLwnSh
         eSf/fkNMG5gpYMwn89Xlhg1Y/ZjtWvjMIbUsNJs7txoi+XBBdZ7XQQ1g5Jt9P/GQlpFk
         L57XJppv2TlJEbTmblLK146G7ZVs0yY+dy9FJDCmkojKtEfFZKvjkJ0LuXgSbwYEhcto
         RYsrFgAvMNoWB8DSj/JlicA5YjR/784CwtNoZsItizx3QmvTkxwmLTF2v80e85ViwLKa
         B3Hg==
X-Gm-Message-State: AOAM533bBCuNFlVv+rkOjyBg4MS2VsDtttKhtQlIk+bV0VxaXH3eKV/g
        rke3Cf+Qlac0KWHBI0xaK2BnKnE43qy8OwhPT6su4WGyoiTp7HoX/MpY9VtbVrndJLbOQEM22UQ
        3myqdFk5rzaLcxdyG80Xw
X-Received: by 2002:a63:f962:: with SMTP id q34mr940820pgk.22.1618608995455;
        Fri, 16 Apr 2021 14:36:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/LuRhBvb+3fbWQztPHVKamiRdrVkTXXw67InEUHs1P+wZj1dRp597kqMg+/6nvXhUSUjjmw==
X-Received: by 2002:a63:f962:: with SMTP id q34mr940802pgk.22.1618608995147;
        Fri, 16 Apr 2021 14:36:35 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 14sm5819482pgz.48.2021.04.16.14.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:36:34 -0700 (PDT)
Date:   Sat, 17 Apr 2021 05:36:25 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Message-ID: <20210416213625.GC2224153@xiangao.remote.csb>
References: <20210416091023.2143162-1-hsiangkao@redhat.com>
 <20210416160013.GB3122264@magnolia>
 <20210416211320.GB2224153@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210416211320.GB2224153@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 17, 2021 at 05:13:20AM +0800, Gao Xiang wrote:
> Hi Darrick,
> 
> On Fri, Apr 16, 2021 at 09:00:13AM -0700, Darrick J. Wong wrote:
> > On Fri, Apr 16, 2021 at 05:10:23PM +0800, Gao Xiang wrote:
> > > There are many paths which could trigger xfs_log_sb(), e.g.
> > >   xfs_bmap_add_attrfork()
> > >     -> xfs_log_sb()
> > > , which overrided on-disk fdblocks by in-core per-CPU fdblocks.
> > > 
> > > However, for !lazysbcount cases, on-disk fdblocks is actually updated
> > > by xfs_trans_apply_sb_deltas(), and generally it isn't equal to
> > > in-core fdblocks due to xfs_reserve_block() or whatever, see the
> > > comment in xfs_unmountfs().
> > > 
> > > It could be observed by the following steps reported by Zorro [1]:
> > > 
> > > 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> > > 2. mount $dev $mnt
> > > 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> > > 4. umount $mnt
> > > 5. xfs_repair -n $dev
> > > 
> > > yet due to commit f46e5a174655("xfs: fold sbcount quiesce logging
> > > into log covering"), xfs_sync_sb() will be triggered even !lazysbcount
> > > but xfs_log_need_covered() case when xfs_unmountfs(), so hard to
> > > reproduce on kernel 5.12+.
> > 
> > Um, I can't understand this(?), possibly because I can't get to RHBZ and
> > therefore have very little context to start from. :(
> 
> Very sorry about that.. I realized it doesn't access at all without some
> permission after sending out the patch. :(
> 
> > 
> > Are you saying that because the f46e commit removed the xfs_sync_sb
> > calls from unmountfs for !lazysb filesystems, we no longer log the
> > summary counters at unmount?  Which means that we no longer write the
> > incore percpu fdblocks count to disk at unmount after we've torn down
> > all the incore space reservations (when sb_fdblocks == m_fdblocks)?
> 
> Er.. I think that is by reverse, before commit f46e, we no longer logged
> the summary counters at unmount, due to 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/xfs_mount.c?h=v5.11#n1177
>   xfs_unmountfs
>     -> xfs_log_sbcount
>       -> !xfs_sb_version_haslazysbcount
>         -> return 0 (xfs_sync_sb bypassed).
> 
> So the only time we update the ondisk fdblocks was during transactions,
> but xfs_log_sb() corrupted this (due to no summary counters logging at
> unmount).
> 
> After f46e, it became
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/xfs_log.c?h=v5.12-rc2#n982
>   xfs_unmountfs
>     -> xfs_log_unmount
>       -> xfs_log_clean
>         -> xfs_log_cover
> 
> So if xfs_log_need_covered(mp) == true and
> !xfs_sb_version_haslazysbcount(&mp->m_sb),
> xfs_sync_sb() will be triggered to cover the log, So
> it's hard to reproduce on the current kernel (at least on my side.)
> 
> But I have no idea xfs_log_need_covered(mp) is always true at that time,
> and the patchset seems a bit large and (possibly) hard to backport...
> 

btw, after checking xfs_check_summary_counts(), I think by now,
sb_fdblocks won't be recalculated if !xfs_sb_version_haslazysbcount
when suddenly power outages (with dirty log...)

So for !xfs_sb_version_haslazysbcount cases, we really rely on the
correct on-disk sb_fdblocks all the time...

Anyway, I also think we should warn !lazysb fs deprecated runtimely
by now (even we have XFS_SUPPORT_V4 build config.)

> > 
> > So that means that for !lazysb fses, the only time we log the sb
> > counters is during transactions, and when we do log the counters we
> > actually log the wrong value, since the incore reservations should never
> > escape to disk?  Hence the fix below?
> 
> Yes
> 
> > 
> > And then by extension, is the reason that nobody noticed before is that
> > we always used to log the correct value at unmount, so fses with clean
> > logs always have the correct value, and fses with dirty logs will
> > recompute fdblocks after log recovery by summing the AGF free blocks
> > counts?
> 
> Nope, prior to 5.12-rc1, I think it was broken for a very long time...
> 
> > 
> > (Or possibly nobody uses !lazysb filesystems anymore?)
> > 
> 
> Zorro found this days ago on rhel 8 kernel (4.18, maybe he's doing
> some new testcases to cover this), and I think it was broken for much
> much long time (I don't know which version it was broken first), maybe
> it has little impact since it's just a freespace block counter.
> 
> So I think it should be backported to many stable kernel versions (?)
> But I have no idea when it was broken...
> 
> > I /think/ the code change looks ok, but as you might surmise from the
> > large quantity of questions, I'm not ready to RVB this yet.  The commit
> > message seems like a good place to answer those questions.
> > 
> > > After this patch, I've seen no strange so far on older kernels
> > > for the testcase above without lazysbcount.
> > > 
> > > [1] https://bugzilla.redhat.com/show_bug.cgi?id=1949515
> > 
> > This strangely <cough> doesn't seem to be accessible to the public at
> > large, since <cough> someone at RedHat decided to block all Oracle IPs
> > <cough>.
> 
> <cough> will get rid of it the next time...
> 
> Thanks,
> Gao Xiang
> 
> > 
> > --D
> > 
> > > 
> > > Reported-by: Zorro Lang <zlang@redhat.com>
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_sb.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index 60e6d255e5e2..423dada3f64c 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -928,7 +928,13 @@ xfs_log_sb(
> > >  
> > >  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > >  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > +	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > +		struct xfs_dsb	*dsb = bp->b_addr;
> > > +
> > > +		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);
> > > +	} else {
> > > +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > +	}
> > >  
> > >  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > >  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> > > -- 
> > > 2.27.0
> > > 
> > 

