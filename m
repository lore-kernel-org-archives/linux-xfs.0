Return-Path: <SRS0=YpFG=EF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17824C4363A
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 15:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A44762075E
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 15:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aBA/d2Mi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgJ3PDP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 11:03:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbgJ3PDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Oct 2020 11:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604070193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nlckONhxf/l/URgGVVc8E/JH+EXKWkyfVj3q2cNWn9M=;
        b=aBA/d2Miq8fHKETBzMdnOKawHQXUQ3nNAnxKjKXDX4NRbSTHLtkLqkYfvWB1nDB2dr0KVU
        wecSWjRRv5VFi4JSSGJrCV26aJR4ZQY9F90WcqtLJMk0zRz9tTe0Gm44kxfvZcTe4NmPyF
        XexhdkN6+G5OEA5D8M/TqoGSwn+0o9E=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-sjKlLPdaNcS6ZR67PFYvhg-1; Fri, 30 Oct 2020 11:03:11 -0400
X-MC-Unique: sjKlLPdaNcS6ZR67PFYvhg-1
Received: by mail-pg1-f199.google.com with SMTP id u4so4823627pgg.14
        for <linux-xfs@vger.kernel.org>; Fri, 30 Oct 2020 08:03:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nlckONhxf/l/URgGVVc8E/JH+EXKWkyfVj3q2cNWn9M=;
        b=tf2Gq/N6OGNPIt9+Vf8MlnBExlRiyC+Q8q9voi/qPNaljfiIaQFW/ZorFUVozDRxGL
         N812yB5FcbJMmhHrqnb9KKBdb07zYH/FeDoIn7pDQg0VgG3mA5CPrixF35BakKVZblkD
         rcFHr8Um88E4Fz0Y9+VgYWidOEBvyv5fy7jOtyku29V7d45Fu9/pjiWgNHYhvdByUgZ2
         z9DAvBTD6LlK/noLINWSnMveUZiw5fz+KpRxQKPHdL9uT/BQP8ENhE+XJkorYsZjpZ09
         6/JhcJYnwW2wqQG+fK5oTwEyWdU/bKzx39jm9r6zPneklWFuQEsr1R3qY6MgGaGO0KuA
         wiRQ==
X-Gm-Message-State: AOAM5337wr2zLR1Cksf7KETUjav8N4cYgCBcg1Eazn9LkPvkrFCYMJ0g
        K1izF8sltjyn+Q3n8PedWYYlhYimBVC4xWZJhLEvup4YNG4J4hjbfMgG6WV81aMlKUVwHap4KMd
        4WcnXtjlZzk3f4ZsEtY3E
X-Received: by 2002:a17:902:b497:b029:d5:c01a:f06b with SMTP id y23-20020a170902b497b02900d5c01af06bmr9668488plr.13.1604070189663;
        Fri, 30 Oct 2020 08:03:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqiGwENRjGYgXkq5TnoU0lGuoJZ+ZUevDTYREjSNIkHZNjNOGINR269AAm3srhaCyii48jhA==
X-Received: by 2002:a17:902:b497:b029:d5:c01a:f06b with SMTP id y23-20020a170902b497b02900d5c01af06bmr9668463plr.13.1604070189303;
        Fri, 30 Oct 2020 08:03:09 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z16sm6435623pfq.33.2020.10.30.08.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 08:03:08 -0700 (PDT)
Date:   Fri, 30 Oct 2020 23:02:59 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH v2] xfs: support shrinking unused space in the last AG
Message-ID: <20201030150259.GA156387@xiangao.remote.csb>
References: <20201028231353.640969-1-hsiangkao@redhat.com>
 <20201030144740.GD1794672@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030144740.GD1794672@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Fri, Oct 30, 2020 at 10:47:40AM -0400, Brian Foster wrote:
> On Thu, Oct 29, 2020 at 07:13:53AM +0800, Gao Xiang wrote:

...

> >  out_trans_cancel:
> > +	if (extend && (tp->t_flags & XFS_TRANS_DIRTY)) {
> > +		xfs_trans_commit(tp);
> > +		return error;
> > +	}
> 
> Do you mean this to be if (!extend && ...)?

Yeah, you are right.

> 
> Otherwise on a quick read through this seems mostly sane to me. Before
> getting into the implementation details, my comments are mostly around
> patch organization and general development approach. On the former, I
> think this patch could be split up into multiple smaller patches to
> separate refactoring, logic cleanups, and new functionality. E.g.,
> factoring out the existing growfs code into a helper, tweaking existing
> logic to prepare the shared grow/shrink path, adding the shrinkfs
> functionality, could all be independent patches. We probably want to
> pull the other patch you sent for the experimental warning into the same
> series as well.

ok.

> 
> On development approach, I'm a little curious what folks think about
> including these opportunistic shrink bits in the kernel and evolving
> this into a more complete feature over time. Personally, I think that's
> a reasonable approach since shrink has sort of been a feature that's
> been stuck at the starting line due to being something that would be
> nice to have for some folks but too complex/involved to fully implement,
> all at once at least. Perhaps if we start making incremental and/or
> opportunistic progress, we might find a happy medium where common/simple
> use cases work well enough for users who want it, without having to
> support arbitrary shrink sizes, moving the log, etc.

My personal thought is also incremental approach. since I'm currently
looking at shrinking a whole unused AG, but such whole modification
is all over the codebase, so the whole shrink function would be better
to be built step by step.

> 
> That said, this is still quite incomplete in that we can only reduce the
> size of the tail AG, and if any of that space is in use, we don't
> currently do anything to try and rectify that. Given that, I'd be a
> little hesitant to expose this feature as is to production users. IMO,
> the current kernel feature state could be mergeable but should probably
> also be buried under XFS_DEBUG until things are more polished. To me,
> the ideal level of completeness to expose something in production
> kernels might be something that can 1. relocate used blocks out of the
> target range and then possibly 2. figure out how to chop off entire AGs.
> My thinking is that if we never get to that point for whatever
> reason(s), at least DEBUG mode allows us the flexibility to drop the
> thing entirely without breaking real users.

Yeah, I also think XFS_DEBUG or another experimential build config
is needed.

Considering that, I think it would better to seperate into 2 functions
as Darrick suggested in the next version to avoid too many
#ifdef XFS_DEBUG #endif hunks.

Thanks,
Gao Xiang

> 
> Anyways, just some high level thoughts on my part. I'm curious if others
> have thoughts on that topic, particularly since this might be a decent
> point to decide whether to put effort into polishing this up or to
> continue with the RFC work and try to prove out more functionality...
> 
> Brian
> 
> >  	xfs_trans_cancel(tp);
> >  	return error;
> >  }
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index c94e71f741b6..81b9c32f9bef 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -419,7 +419,6 @@ xfs_trans_mod_sb(
> >  		tp->t_res_frextents_delta += delta;
> >  		break;
> >  	case XFS_TRANS_SB_DBLOCKS:
> > -		ASSERT(delta > 0);
> >  		tp->t_dblocks_delta += delta;
> >  		break;
> >  	case XFS_TRANS_SB_AGCOUNT:
> > -- 
> > 2.18.1
> > 
> 

