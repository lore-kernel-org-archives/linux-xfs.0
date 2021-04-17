Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA78C433B4
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Apr 2021 00:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB84C6134F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Apr 2021 00:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhDRAAa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Apr 2021 20:00:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230031AbhDRAAa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Apr 2021 20:00:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618704002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HLi8aIkmsV8v47NSHjA5YNJoWLdqHpxYHW9wooZF6DU=;
        b=bPfyVuPlAysBHib6MBkGjo62ZgGM7hFW+6dl32Fp2+ohbD2FhqDOgBlgS8+Nb1pDnsX4O+
        Xgbwgw8RejAqr3R1zPQJErwrawtyP3+n9YmqbZgfXMiwbTBhpdxaFHkLJfeAoJpqdmNkT/
        6hUeESYDWRlza30PSdAkQfkSx3/mDcY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-qaIFcI-mNTu6-ATz9YBBng-1; Sat, 17 Apr 2021 20:00:01 -0400
X-MC-Unique: qaIFcI-mNTu6-ATz9YBBng-1
Received: by mail-pj1-f70.google.com with SMTP id oa1-20020a17090b1bc1b02901507fafb74fso1582934pjb.7
        for <linux-xfs@vger.kernel.org>; Sat, 17 Apr 2021 17:00:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HLi8aIkmsV8v47NSHjA5YNJoWLdqHpxYHW9wooZF6DU=;
        b=MIzkEdtv+4g7Q2/SpvPh3+vRQy2qi9esm5qt4w+dkwxkBJiHPe19OZPm1dsfdzX0eS
         puAt5SLsgI46km57mcbvQvAK9nLjNNlU9kEkT6IvaiPsfbO0FfTLKhs6u01ViusF7TPS
         JLlleERqQ4oahT7erFfhvewQ3fd7eRa+52QcR5rjTyJEy+lh3pp+Xgb3wZxXSGhSGfo1
         AWUeJfa2Uq7IT7cGnnDyjRK5/f9i5njpWnoe/bqJ1kAjXVuxtCJKNzGrUKpnhQ3LVEEA
         ImXn2lwimHgPxPqkpzZtYGz8Je1pZCpChIw/thCxouaTo/cXjb4w6CwVGPOb4u0d/Anu
         Tcmw==
X-Gm-Message-State: AOAM533A1pdVqtaF2IkW05wiBSC6HwPl55beLCb6yAm/HNn5EIdZfI4d
        1H1I0yc1QsdiCdMNsUfO7yYz8/uGJ4sDRVjkqxMvrHWS0i8EY3ec61JaoVLpbVZvKb1abI1G7ix
        efmpTw6y7vr736QkIPEY4
X-Received: by 2002:aa7:908d:0:b029:250:81a5:2a3c with SMTP id i13-20020aa7908d0000b029025081a52a3cmr13236057pfa.33.1618703999800;
        Sat, 17 Apr 2021 16:59:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgK9V4x6t2b2vL8rmLG9cmR90rDs/8388kCe+OkOjE53LkWeF6ZmAPPDc5vtM9bpIQOJGcLQ==
X-Received: by 2002:aa7:908d:0:b029:250:81a5:2a3c with SMTP id i13-20020aa7908d0000b029025081a52a3cmr13236048pfa.33.1618703999480;
        Sat, 17 Apr 2021 16:59:59 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d12sm8436878pfl.179.2021.04.17.16.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 16:59:58 -0700 (PDT)
Date:   Sun, 18 Apr 2021 07:59:48 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Message-ID: <20210417235948.GB2266103@xiangao.remote.csb>
References: <20210416091023.2143162-1-hsiangkao@redhat.com>
 <20210416160013.GB3122264@magnolia>
 <20210416211320.GB2224153@xiangao.remote.csb>
 <20210417001941.GC3122276@magnolia>
 <20210417015702.GT63242@dread.disaster.area>
 <20210417022013.GA2266103@xiangao.remote.csb>
 <20210417223201.GU63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210417223201.GU63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Sun, Apr 18, 2021 at 08:32:01AM +1000, Dave Chinner wrote:
> On Sat, Apr 17, 2021 at 10:20:13AM +0800, Gao Xiang wrote:

...

> > > > Hmm... is this really needed?  I thought in !lazysbcount mode,
> > > > xfs_trans_apply_sb_deltas updates the ondisk super buffer directly.
> > > > So aren't all three of these updates unnecessary?
> > > 
> > > Yup, now I understand the issue, the fix is simply to avoid these
> > > updates for !lazysb. i.e. it should just be:
> > > 
> > > 	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > > 		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > 	}
> > > 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > 
> > I did as this because xfs_sb_to_disk() will override them, see:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/libxfs/xfs_sb.c#n629
> > 
> > ...
> > 	to->sb_icount = cpu_to_be64(from->sb_icount);
> > 	to->sb_ifree = cpu_to_be64(from->sb_ifree);
> > 	to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
> 
> > As an alternative, I was once to wrap it as:
> > 
> > xfs_sb_to_disk() {
> > ...
> > 	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > 		to->sb_icount = cpu_to_be64(from->sb_icount);
> > 		to->sb_ifree = cpu_to_be64(from->sb_ifree);
> > 		to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
> > 	}
> > ...
> > }
> 

...

> 
> That is, xfs_trans_apply_sb_deltas() only applies deltas to the
> directly to the in-memory superblock in the case of !lazy-count, so
> these counters are actually a correct representation of the on-disk
> value of the accounting when lazy-count=0.
> 
> Hence we should always be able to write the counters in mp->m_sb
> directly to the on-disk superblock buffer in the case of
> lazy-count=0 and the values should be correct. lazy-count=1 only
> updates the mp->m_sb counters from the per-cpu counters so that the
> on-disk counters aren't wildly inaccruate, and so that when we
> unmount/freeze/etc the counters are actually correct.
> 
> Long story short, I think xfs_sb_to_disk() always updating the
> on-disk superblock from mp->m_sb is safe to do as the counters in
> mp->m_sb are updated in the same manner during transaction commit as
> the superblock buffer counters for lazy-count=0....

Thanks for your long words, I have to say I don't quite get what's
your thought here, if my understanding is correct,
xfs_trans_apply_sb_deltas() for !lazy-count case just directly
update on-disk superblock (rather than in-memory superblock), see:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/xfs_trans.c?h=v5.12-rc2#n501

	if (!xfs_sb_version_haslazysbcount(&(tp->t_mountp->m_sb))) {
		if (tp->t_icount_delta)
			be64_add_cpu(&sbp->sb_icount, tp->t_icount_delta);
		if (tp->t_ifree_delta)
			be64_add_cpu(&sbp->sb_ifree, tp->t_ifree_delta);
		if (tp->t_fdblocks_delta)
			be64_add_cpu(&sbp->sb_fdblocks, tp->t_fdblocks_delta);
		if (tp->t_res_fdblocks_delta)
			be64_add_cpu(&sbp->sb_fdblocks, tp->t_res_fdblocks_delta);
	}

That is why I think in-memory mp->m_sb.sb_icount, mp->m_sb.sb_ifree,
mp->m_sb.sb_fdblocks are all outdated at all (kindly correct me if I'm wrong
here)... so xfs_sb_to_disk() will replace on-disk fields with outdated
in-memory counters.

> 
> > Yet after I observed the other callers of xfs_sb_to_disk() (e.g. growfs
> > and online repair), I think a better modification is the way I proposed
> > here, so no need to update xfs_sb_to_disk() and the other callers (since
> > !lazysbcount is not recommended at all.)
> 
> Yup that's the original reason for having a fields flag to do
> condition update of the on-disk buffer from the in-memory state.
> Different code has diferrent requirements, but it looked like this
> didn't matter for lazy-count filesystems because other checks
> avoided the update of m_sb fields. What was missed in that
> optimisation was the fact lazy-count=0 never updated the counters
> directly.
> 
> /me is now wondering why we even bother with !lazy-count anymore.
> 
> WE've updated the agr btree block accounting unconditionally since
> lazy-count was added, and scrub will always report a mismatch in
> counts if they exist regardless of lazy-count. So why don't we just
> start ignoring the on-disk value and always use lazy-count based
> updates?
> 
> We only added it as mkfs option/feature bit because of the recovery
> issue with not being able to account for btree blocks properly at
> mount time, but now we have mechanisms for counting blocks in btrees
> so even that has gone away. So we could actually just turn
> on lazy-count at mount time, and we could get rid of this whole
> set of subtle conditional behaviours we clearly aren't able to
> exercise effectively...

If my understanding of the words above is correct, maybe that could
be unfriendly when users turned back to some old kernels. But
considering lazysbcount has been landed for quite quite long time,
I think that is practical as 2 patches:
 1) fix sb counters for !lazysbcount;
 2) turn on lazysbcount at the mount time from now (and warn users).

> 
> > It's easier to backport and less conflict, and btw !lazysbcount also need
> > to be warned out and deprecated from now.
> 
> You have to use -m crc=0 to turn off lazycount, and the deprecation
> warning should come from -m crc=0...

Yes, but I think 2030 is too far for this !lazysbcount feature, since
it seems easy to cause potential bugs. I think maybe we could get rid
of it as soon as possible.

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

