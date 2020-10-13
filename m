Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019D3C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 13:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A80EA2478F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 13:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vd9mGJqk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387903AbgJMNzx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 09:55:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388142AbgJMNzx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 09:55:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602597351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BJEly3MbdwzStjglmF2y+qKzHhakIep/TGHzQAR6hdw=;
        b=Vd9mGJqkxZvV5aQ+ZpmSPRHM3+dTu8NTn0BbC93LU2Llvyznyfje5+Kf1fQqVqadKSELPu
        rEFG5nOymf3jIdGFBRz2BJr4/TawDcoUrdzu54/WFAZq2GtTw96KD/8mneC0ZwGOzAucu1
        V0X3UdezRVhQS6jUg+yaAZPOD9lul1Q=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-z5L1-dUTPhy8CaHmP_ZvNQ-1; Tue, 13 Oct 2020 09:55:49 -0400
X-MC-Unique: z5L1-dUTPhy8CaHmP_ZvNQ-1
Received: by mail-pg1-f199.google.com with SMTP id e13so14716718pgk.6
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 06:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BJEly3MbdwzStjglmF2y+qKzHhakIep/TGHzQAR6hdw=;
        b=DLog3UDTHLwue6s0dNVG08y8lDcP3p9b67vYRBtcrOQlZ0t0qRc4LaiNqGVd8MxKVJ
         mDXcjfJoz+HbvU/SZH0P/jYbE3fmBiIvjzPJQQxEZDRBXKQ0ZiLdunI1r4/4sh89JJ0T
         9IddmPAPsGwgLcXvEDG2tBpuCf5W1xm89Kp1t/LrYwKgJH/KmYFHBL9euqiQKaIv3M3X
         3HeNSNKW7s5Iv/oXLP7a3K6/QhKmbmn84wAiRxv9ycb7xc4NjLOXG+pWcEduzUsBv3m8
         HXHufFFm6UuD+5awzNQGlOC95SlYna3IT/Cc9fJntnfUNhAYTzPjX8wgcniTDGq3LRvk
         nAGA==
X-Gm-Message-State: AOAM5303pa3inC85R6JPcfxklo9DZd39DtcxW5yCSbsHwMUvITEqBSzh
        YbfgBhOEdD/UgY+PUyQDv2CJNeQm6zo30UfUlnYLMhtM/t3Ju4MEyepZps6IhKrXeAegCr/fuNY
        dlC1z+Qrhi6scW0ERc1b1
X-Received: by 2002:a17:90b:4a0c:: with SMTP id kk12mr12309pjb.207.1602597348265;
        Tue, 13 Oct 2020 06:55:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAgMOBKUlcSLH7OAGdgxrTbUdeoW/wP+ISeKDSGEDc58QTdxCsufRC/FgdAo66v5Mi6LSOCw==
X-Received: by 2002:a17:90b:4a0c:: with SMTP id kk12mr12287pjb.207.1602597347992;
        Tue, 13 Oct 2020 06:55:47 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w19sm22920783pfn.174.2020.10.13.06.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 06:55:47 -0700 (PDT)
Date:   Tue, 13 Oct 2020 21:55:37 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: introduce xfs_validate_stripe_geometry()
Message-ID: <20201013135537.GB12025@xiangao.remote.csb>
References: <20201013034853.28236-1-hsiangkao@redhat.com>
 <20201013134411.GE966478@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013134411.GE966478@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Tue, Oct 13, 2020 at 09:44:11AM -0400, Brian Foster wrote:
> On Tue, Oct 13, 2020 at 11:48:53AM +0800, Gao Xiang wrote:
> > Introduce a common helper to consolidate stripe validation process.
> > Also make kernel code xfs_validate_sb_common() use it first.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > v1: https://lore.kernel.org/r/20201009050546.32174-1-hsiangkao@redhat.com
> > 
> > changes since v1:
> >  - rename the helper to xfs_validate_stripe_geometry() (Brian);
> >  - drop a new added trailing newline in xfs_sb.c (Brian);
> >  - add a "bool silent" argument to avoid too many error messages (Brian).
> > 
> >  fs/xfs/libxfs/xfs_sb.c | 70 +++++++++++++++++++++++++++++++++++-------
> >  fs/xfs/libxfs/xfs_sb.h |  3 ++
> >  2 files changed, 62 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 5aeafa59ed27..9178715ded45 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -360,21 +360,18 @@ xfs_validate_sb_common(
> >  		}
> >  	}
> >  
> > -	if (sbp->sb_unit) {
> > -		if (!xfs_sb_version_hasdalign(sbp) ||
> > -		    sbp->sb_unit > sbp->sb_width ||
> > -		    (sbp->sb_width % sbp->sb_unit) != 0) {
> > -			xfs_notice(mp, "SB stripe unit sanity check failed");
> > -			return -EFSCORRUPTED;
> > -		}
> > -	} else if (xfs_sb_version_hasdalign(sbp)) {
> > +	/*
> > +	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
> > +	 * would imply the image is corrupted.
> > +	 */
> > +	if (!sbp->sb_unit ^ !xfs_sb_version_hasdalign(sbp)) {
> 
> This can be simplified to drop the negations (!), right?

Thanks for the suggestion.

yet nope, honestly I don't think so, the reason is that sbp->sb_unit is
an integer here rather than a boolean, so negations cannot be
simplified and I think it's simpliest now... (some boolean algebra...)

> 
> >  		xfs_notice(mp, "SB stripe alignment sanity check failed");

...

> > +	if (sectorsize && sunit % sectorsize) {
> > +		if (!silent)
> > +			xfs_notice(mp,
> > +"stripe unit (%lld) must be a multiple of the sector size (%d)",
> > +				   sunit, sectorsize);
> > +		return false;
> > +	}
> > +
> > +	if (sunit && !swidth) {
> > +		if (!silent)
> > +			xfs_notice(mp,
> > +"invalid stripe unit (%lld) and stripe width of 0", sunit);
> > +		return false;
> > +	}
> > +
> > +	if (!sunit && swidth) {
> > +		if (!silent)
> > +			xfs_notice(mp,
> > +"invalid stripe width (%lld) and stripe unit of 0", swidth);
> > +		return false;
> > +	}
> > +
> > +	if (sunit > swidth) {
> > +		if (!silent)
> > +			xfs_notice(mp,
> > +"stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
> > +		return false;
> > +	}
> > +
> > +	if (sunit && (swidth % sunit)) {
> 
> It might be good to use (or not) params consistently. I.e., the
> sectorsize check earlier in the function has similar logic structure but
> drops the params.

Yeah, that is due to the line was copied from somewhere else... so...
Anyway, I can resend a quick fix for this if needed. Wait a sec
for some potential feedback...

Thanks,
Gao Xiang

> 
> Those nits aside:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 

