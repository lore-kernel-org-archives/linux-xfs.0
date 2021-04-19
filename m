Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE48FC433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 00:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE0860FD8
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 00:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbhDSAjF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Apr 2021 20:39:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231860AbhDSAjF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Apr 2021 20:39:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618792716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JoBqSEi9C4Ol+rHyxpIIzNXzvm2incoYu0YvMqB7TBw=;
        b=GK8YVcHcFaBRDXsw4hn5sf9C4zp+b178imfZhQljbEg2++ZNwT2giw4ayuu6F9k/vfmeYA
        vSzikWofym15r8A69CBZStEQyQ5DjYqP+m0ycNAx47FhZpUvxScvfgrK6CCqDl/mEVgE0U
        KDEPPf5N7rQjH8eSsZtxDwXxt4V086g=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-j4FYi_TzOy6dnenkoc4TbQ-1; Sun, 18 Apr 2021 20:38:34 -0400
X-MC-Unique: j4FYi_TzOy6dnenkoc4TbQ-1
Received: by mail-pj1-f70.google.com with SMTP id r12-20020a17090a454cb029014e931abf30so11420565pjm.7
        for <linux-xfs@vger.kernel.org>; Sun, 18 Apr 2021 17:38:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JoBqSEi9C4Ol+rHyxpIIzNXzvm2incoYu0YvMqB7TBw=;
        b=BUjUI8WX7EMIsclD4NVqpT9OcwCobdySbgqSuXsuPWOHHThjwuv/X7NkPx1JFccT8E
         eTfdJHydwBpREnBQg6VWYX3QyAT0tEORME8uzjMwcQVhjO7r2ruilt5sfYuZ3cNeI4lx
         bA0P81CBS5FWS23uNy3XKVtmxQ27jcYEWGjooweJVaVyMOypWN8Fvqv6jp+9KcPtnBSe
         qop/+D5R1nDW97jpr6ukHTcMavfSj6ysWMCf/hkvNbi3h4EEmP3YFDzeWbkNfUmeC4yx
         rgyp3PouC71Usn23DYad/qrifjokLi+Bhvg6lxxLqSLHuQMBWsfwYBFphOcjvpk35h1f
         KJIg==
X-Gm-Message-State: AOAM531zB4N6i8K+5YYO0QH+EjZe+JdeBrl73THgK6gmK+aedwpsC6al
        x3F1jNJTxa58azB9oJmnxmQG1nyE6UVm+avNU2v3jxcSkkGayRE2BunkvjtMhk3fpEiBb+/Iua3
        rPxUJlVT8dQ7c+vA0qDrz
X-Received: by 2002:a62:528e:0:b029:1f5:c5ee:a487 with SMTP id g136-20020a62528e0000b02901f5c5eea487mr17039831pfb.7.1618792713389;
        Sun, 18 Apr 2021 17:38:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPc9fBQDX1mN7jAAE2nLXruZSr9zgLWepdYCnrQkznGLukzKAiTD124cHZsDa380OtdczVjA==
X-Received: by 2002:a62:528e:0:b029:1f5:c5ee:a487 with SMTP id g136-20020a62528e0000b02901f5c5eea487mr17039811pfb.7.1618792713077;
        Sun, 18 Apr 2021 17:38:33 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f17sm11371129pgj.86.2021.04.18.17.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 17:38:32 -0700 (PDT)
Date:   Mon, 19 Apr 2021 08:38:22 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Message-ID: <20210419003822.GA2605141@xiangao.remote.csb>
References: <20210416091023.2143162-1-hsiangkao@redhat.com>
 <20210416160013.GB3122264@magnolia>
 <20210416211320.GB2224153@xiangao.remote.csb>
 <20210417001941.GC3122276@magnolia>
 <20210417015702.GT63242@dread.disaster.area>
 <20210417022013.GA2266103@xiangao.remote.csb>
 <20210417223201.GU63242@dread.disaster.area>
 <20210417235948.GB2266103@xiangao.remote.csb>
 <20210418220831.GV63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210418220831.GV63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 19, 2021 at 08:08:31AM +1000, Dave Chinner wrote:
> On Sun, Apr 18, 2021 at 07:59:48AM +0800, Gao Xiang wrote:
> > Hi Dave,
> > 
> > On Sun, Apr 18, 2021 at 08:32:01AM +1000, Dave Chinner wrote:
> > > On Sat, Apr 17, 2021 at 10:20:13AM +0800, Gao Xiang wrote:
> > 
> > ...
> > 
> > > > > > Hmm... is this really needed?  I thought in !lazysbcount mode,
> > > > > > xfs_trans_apply_sb_deltas updates the ondisk super buffer directly.
> > > > > > So aren't all three of these updates unnecessary?
> > > > > 
> > > > > Yup, now I understand the issue, the fix is simply to avoid these
> > > > > updates for !lazysb. i.e. it should just be:
> > > > > 
> > > > > 	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > > > 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > > > > 		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > > > 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > > > 	}
> > > > > 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > > > 
> > > > I did as this because xfs_sb_to_disk() will override them, see:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/libxfs/xfs_sb.c#n629
> > > > 
> > > > ...
> > > > 	to->sb_icount = cpu_to_be64(from->sb_icount);
> > > > 	to->sb_ifree = cpu_to_be64(from->sb_ifree);
> > > > 	to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
> > > 
> > > > As an alternative, I was once to wrap it as:
> > > > 
> > > > xfs_sb_to_disk() {
> > > > ...
> > > > 	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > > 		to->sb_icount = cpu_to_be64(from->sb_icount);
> > > > 		to->sb_ifree = cpu_to_be64(from->sb_ifree);
> > > > 		to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
> > > > 	}
> > > > ...
> > > > }
> > > 
> > 
> > ...
> > 
> > > 
> > > That is, xfs_trans_apply_sb_deltas() only applies deltas to the
> > > directly to the in-memory superblock in the case of !lazy-count, so
> > > these counters are actually a correct representation of the on-disk
> > > value of the accounting when lazy-count=0.
> > > 
> > > Hence we should always be able to write the counters in mp->m_sb
> > > directly to the on-disk superblock buffer in the case of
> > > lazy-count=0 and the values should be correct. lazy-count=1 only
> > > updates the mp->m_sb counters from the per-cpu counters so that the
> > > on-disk counters aren't wildly inaccruate, and so that when we
> > > unmount/freeze/etc the counters are actually correct.
> > > 
> > > Long story short, I think xfs_sb_to_disk() always updating the
> > > on-disk superblock from mp->m_sb is safe to do as the counters in
> > > mp->m_sb are updated in the same manner during transaction commit as
> > > the superblock buffer counters for lazy-count=0....
> > 
> > Thanks for your long words, I have to say I don't quite get what's
> > your thought here, if my understanding is correct,
> > xfs_trans_apply_sb_deltas() for !lazy-count case just directly
> > update on-disk superblock (rather than in-memory superblock), see:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/xfs_trans.c?h=v5.12-rc2#n501
> > 
> > 	if (!xfs_sb_version_haslazysbcount(&(tp->t_mountp->m_sb))) {
> > 		if (tp->t_icount_delta)
> > 			be64_add_cpu(&sbp->sb_icount, tp->t_icount_delta);
> > 		if (tp->t_ifree_delta)
> > 			be64_add_cpu(&sbp->sb_ifree, tp->t_ifree_delta);
> > 		if (tp->t_fdblocks_delta)
> > 			be64_add_cpu(&sbp->sb_fdblocks, tp->t_fdblocks_delta);
> > 		if (tp->t_res_fdblocks_delta)
> > 			be64_add_cpu(&sbp->sb_fdblocks, tp->t_res_fdblocks_delta);
> > 	}
> 
> Yeah, I think I misread this jumping between diffs, commits, the
> historic tree, etc. got tangled up in the twisty, gnarly branches of
> the code...
> 
> > > /me is now wondering why we even bother with !lazy-count anymore.
> > > 
> > > WE've updated the agr btree block accounting unconditionally since
> > > lazy-count was added, and scrub will always report a mismatch in
> > > counts if they exist regardless of lazy-count. So why don't we just
> > > start ignoring the on-disk value and always use lazy-count based
> > > updates?
> > > 
> > > We only added it as mkfs option/feature bit because of the recovery
> > > issue with not being able to account for btree blocks properly at
> > > mount time, but now we have mechanisms for counting blocks in btrees
> > > so even that has gone away. So we could actually just turn
> > > on lazy-count at mount time, and we could get rid of this whole
> > > set of subtle conditional behaviours we clearly aren't able to
> > > exercise effectively...
> > 
> > If my understanding of the words above is correct, maybe that could
> > be unfriendly when users turned back to some old kernels. But
> > considering lazysbcount has been landed for quite quite long time,
> > I think that is practical as 2 patches:
> >  1) fix sb counters for !lazysbcount;
> >  2) turn on lazysbcount at the mount time from now (and warn users).
> 
> Yup, that seems reasonable to me - getting rid of all the
> lazysbcount checks everywhere except the mount path would simplify
> the code a lot...

Okay, let me investigate to turn on lazysb feature today as well, so
clean up all the code.

Thanks,
Gao Xiang

> 
> > > You have to use -m crc=0 to turn off lazycount, and the deprecation
> > > warning should come from -m crc=0...
> > 
> > Yes, but I think 2030 is too far for this !lazysbcount feature, since
> > it seems easy to cause potential bugs. I think maybe we could get rid
> > of it as soon as possible.
> 
> Yeah, that's why I think we just turn it on unconditionally. It's
> already deprecated, and all supported long term kernels support lazy
> counters, so there's no reason for needing lazy-count=0 anymore...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

