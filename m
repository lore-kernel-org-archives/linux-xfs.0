Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15774C433B4
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Apr 2021 02:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9FB86115B
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Apr 2021 02:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhDQCU5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 22:20:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231997AbhDQCUx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 22:20:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618626027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cOJHhAAOZ16MrfsD9IvXugPoTdPDWFh7YYjEFp9wnOQ=;
        b=AdJ8/9Yf7fBBoYK0mRq9s7bOiiGiitDXMoUA4XhgapqgJS4vjizJV3hN+A+B2HwaxFJOuD
        /z+qIsE5GoY105TV6Ify6o1ML+YxYJ8xdvQsmH0ybgFaAh9WA7Tuqv1ZO1VWRReuSarPzH
        puSn4fnGNMOJEfYzAY3G/tXn5GmQA1Y=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-lHcnWDLSPVuUb9elmJmL7Q-1; Fri, 16 Apr 2021 22:20:24 -0400
X-MC-Unique: lHcnWDLSPVuUb9elmJmL7Q-1
Received: by mail-pg1-f199.google.com with SMTP id i5-20020a6322050000b0290209113e506aso1035590pgi.3
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 19:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cOJHhAAOZ16MrfsD9IvXugPoTdPDWFh7YYjEFp9wnOQ=;
        b=XrT9krUPfWpS91MUd6ToJk03bXuxj5+txtsZuHGzNEGmfnrQ804Pyq9kp9xFPwrW68
         2vmlyvlLpN7dncdQz4qx/TaRUPklJCQJN3thxGA2wX2wtGNDmbvX9Ms833meeY7ViSh1
         Q8uu2QSmaip5L+JhRXz0kHgp3626xxf2w6xhukrPKQYzv42JJl847DyridCaSqXEieYQ
         JSkAbWquwlT4qw+moBNYJsSa6pbd6xI+cmexXR6q/RRlNmNlZ3iTIG9r+QDcMseKeUNz
         1J+HmxR7J25lPNv0xxSDD/k4uZKjZvyhp2HNzv6uQ+PEVIXo/1YTlikCqnbc4twXJw8R
         oF1g==
X-Gm-Message-State: AOAM531mUr6P2dlZPbtbEOi7DkSRXG0Iibq9Kli1hZoaBrTUNFkg5mNL
        WzovzejCewD0GBr9gJQc/cHlOTqW6YBP5tUAOSyy62wBWv3tIvPqful7PQAAHeXrMp4I/wkXqJV
        KFkonlE/8nQUzjLRBgbZb
X-Received: by 2002:a17:90b:1e4d:: with SMTP id pi13mr12316556pjb.132.1618626023908;
        Fri, 16 Apr 2021 19:20:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwY5KksrQ4YU+EiGXHqUSF/GzAgKW1c1rB+ehMAwII6pwtH8OSWM3Q9D60JHx4mLNXQVDu5Yg==
X-Received: by 2002:a17:90b:1e4d:: with SMTP id pi13mr12316541pjb.132.1618626023707;
        Fri, 16 Apr 2021 19:20:23 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u20sm6427659pgl.27.2021.04.16.19.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 19:20:23 -0700 (PDT)
Date:   Sat, 17 Apr 2021 10:20:13 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Message-ID: <20210417022013.GA2266103@xiangao.remote.csb>
References: <20210416091023.2143162-1-hsiangkao@redhat.com>
 <20210416160013.GB3122264@magnolia>
 <20210416211320.GB2224153@xiangao.remote.csb>
 <20210417001941.GC3122276@magnolia>
 <20210417015702.GT63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210417015702.GT63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick and Dave,

On Sat, Apr 17, 2021 at 11:57:02AM +1000, Dave Chinner wrote:
> On Fri, Apr 16, 2021 at 05:19:41PM -0700, Darrick J. Wong wrote:
> > On Sat, Apr 17, 2021 at 05:13:20AM +0800, Gao Xiang wrote:

...

> 
> Nor is it necessary to fix the problem.
> 
> > > > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > > > index 60e6d255e5e2..423dada3f64c 100644
> > > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > > @@ -928,7 +928,13 @@ xfs_log_sb(
> > > > >  
> > > > >  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > > > >  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > > > -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > > > +	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > > > +		struct xfs_dsb	*dsb = bp->b_addr;
> > > > > +
> > > > > +		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);
> > 
> > Hmm... is this really needed?  I thought in !lazysbcount mode,
> > xfs_trans_apply_sb_deltas updates the ondisk super buffer directly.
> > So aren't all three of these updates unnecessary?
> 
> Yup, now I understand the issue, the fix is simply to avoid these
> updates for !lazysb. i.e. it should just be:
> 
> 	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> 		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> 	}
> 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);

I did as this because xfs_sb_to_disk() will override them, see:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/libxfs/xfs_sb.c#n629

...
	to->sb_icount = cpu_to_be64(from->sb_icount);
	to->sb_ifree = cpu_to_be64(from->sb_ifree);
	to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);

As an alternative, I was once to wrap it as:

xfs_sb_to_disk() {
...
	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
		to->sb_icount = cpu_to_be64(from->sb_icount);
		to->sb_ifree = cpu_to_be64(from->sb_ifree);
		to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
	}
...
}

Yet after I observed the other callers of xfs_sb_to_disk() (e.g. growfs
and online repair), I think a better modification is the way I proposed
here, so no need to update xfs_sb_to_disk() and the other callers (since
!lazysbcount is not recommended at all.)

It's easier to backport and less conflict, and btw !lazysbcount also need
to be warned out and deprecated from now.

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

