Return-Path: <SRS0=wlCw=EG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4A1C388F7
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Oct 2020 04:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C59D3206D5
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Oct 2020 04:42:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UWwuuFEo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgJaEmZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 31 Oct 2020 00:42:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45771 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgJaEmZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 31 Oct 2020 00:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604119343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GfYNyn1vpMzUKO+X0OKLxosTvya7bIbRmm+4h7ilIes=;
        b=UWwuuFEor7RmbK17L+oEet/SOssTqQurp0huttGFconIq53Znl0sepHEs55fLui4JxcZGY
        0PK2o9n9SS6097LRZk8wsO6UeiFkIi6ZxCE2ymo9Zy8xSMEvxwiM3I058lE4nt9vdESU2j
        9DPOh6PGVR/5J5urrNmTuLIMEMN/4JY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-TA2WZRydMKqOyyw_vdmP_A-1; Sat, 31 Oct 2020 00:42:19 -0400
X-MC-Unique: TA2WZRydMKqOyyw_vdmP_A-1
Received: by mail-pg1-f197.google.com with SMTP id 19so5846956pgq.18
        for <linux-xfs@vger.kernel.org>; Fri, 30 Oct 2020 21:42:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GfYNyn1vpMzUKO+X0OKLxosTvya7bIbRmm+4h7ilIes=;
        b=KIwNx7dewjV9LEGTSRKd4rtmZOR+vpErqnrdZmyUnSs7UmZE0zjCLlv6IT+YzXAANj
         TLA7IfkI9jL1suEQ8vOfeW9+hG0UWWW8iJTcHxxPXoxKIiCoFduVwYYCThPPyTnZRJaL
         waE4Jl3XvYT4g6OPMRqCsfiY6eBxf+6hV6gG1aB4Ss2/rPWQ9IrXaggmgNMBULEa+TWL
         NNZJAdcy+/5ybzE3DqnFrfVHCEmWKbORS5LK4Gqk2VG4map0NcgzvKe+90y7ZyBWL/r0
         gJSslfwnjNOi2Q3M0XL+Rr/88SUS7i1+bjMt1JmNlRXPnA+b5iMKf3d3C4SkeBXs7GFZ
         chVw==
X-Gm-Message-State: AOAM533apozCOaGOcS5M9c1KRvXt8w744osYtcNi8bJLF6oHR2Dn4wO+
        IfoBp3+kNKDngWX1t2tP+m/Ixq/ysI1MCfoahkqJbvQ0/Oj4OLwhjrT+PrRa+eM3KWR+4iO4j6k
        MochYS+aknBfKYWA9F3VM
X-Received: by 2002:a63:4f5f:: with SMTP id p31mr2370326pgl.158.1604119338573;
        Fri, 30 Oct 2020 21:42:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyG7XW/mtIzOER2JCDdKKYJkBLeNiO3QPbixUANr1OOl4+C0BxvyTIdPRRD6aWw9t22CPZ31g==
X-Received: by 2002:a63:4f5f:: with SMTP id p31mr2370314pgl.158.1604119338361;
        Fri, 30 Oct 2020 21:42:18 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j15sm6775125pgn.32.2020.10.30.21.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 21:42:17 -0700 (PDT)
Date:   Sat, 31 Oct 2020 12:42:08 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH v2] xfs: support shrinking unused space in the last AG
Message-ID: <20201031044208.GA263178@xiangao.remote.csb>
References: <20201028231353.640969-1-hsiangkao@redhat.com>
 <20201030144740.GD1794672@bfoster>
 <20201030150259.GA156387@xiangao.remote.csb>
 <20201030175114.GF1794672@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030175114.GF1794672@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 30, 2020 at 01:51:14PM -0400, Brian Foster wrote:
> On Fri, Oct 30, 2020 at 11:02:59PM +0800, Gao Xiang wrote:

...

> > > 
> > > That said, this is still quite incomplete in that we can only reduce the
> > > size of the tail AG, and if any of that space is in use, we don't
> > > currently do anything to try and rectify that. Given that, I'd be a
> > > little hesitant to expose this feature as is to production users. IMO,
> > > the current kernel feature state could be mergeable but should probably
> > > also be buried under XFS_DEBUG until things are more polished. To me,
> > > the ideal level of completeness to expose something in production
> > > kernels might be something that can 1. relocate used blocks out of the
> > > target range and then possibly 2. figure out how to chop off entire AGs.
> > > My thinking is that if we never get to that point for whatever
> > > reason(s), at least DEBUG mode allows us the flexibility to drop the
> > > thing entirely without breaking real users.
> > 
> > Yeah, I also think XFS_DEBUG or another experimential build config
> > is needed.
> > 
> > Considering that, I think it would better to seperate into 2 functions
> > as Darrick suggested in the next version to avoid too many
> > #ifdef XFS_DEBUG #endif hunks.
> > 
> 
> Another option could be to just retain the existing error checking logic
> and wrap it in an ifdef. I.e.:
> 
> #ifndef DEBUG
> 	/* shrink only allowed in debug mode for now ... */
> 	if (nb < mp->m_sb.sb_dblocks)
> 		return -EINVAL;
> #endif
> 
> Then the rest of the function doesn't have to be factored differently
> just because of the ifdef.

Yeah, on the runtime side, that is ok. Yet the growfs expend common code
has been modified due to this patch so it might cause some potential
regression (but I don't think for now.) Either way is good to me.

Thanks,
Gao Xiang

> 
> Brian
> 

