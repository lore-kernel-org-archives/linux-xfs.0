Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AD5C43457
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 14:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41160247D5
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 14:11:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eDc1vhc0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388418AbgJMOLz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 10:11:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388308AbgJMOLz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 10:11:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602598314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eJt1qxyjHjoqSplZ7WlsaniJ4NULrSNGaHZsb5YaI0g=;
        b=eDc1vhc0xjK3kcz7laT5ODxovUcq21jHUWnI4+e0eu6pIqz5CO8ESm4DjLI1A1r4E3s9qT
        rtxgrCgYOb6apJ9MP+wyzYr/wtZb3p2QOCnLlihSJspr910Q7hoHV4JhUXS/jpRRSQbljj
        EosnfqKwXf7PZJT8NCBsXDQkyFaIRaU=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-ybtBsRj4MAiRySksWqFf7g-1; Tue, 13 Oct 2020 10:11:53 -0400
X-MC-Unique: ybtBsRj4MAiRySksWqFf7g-1
Received: by mail-pf1-f198.google.com with SMTP id x24so15045778pfi.18
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 07:11:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eJt1qxyjHjoqSplZ7WlsaniJ4NULrSNGaHZsb5YaI0g=;
        b=k5MYWxHwuF7THJIKLChloI0DGfmTOMGqrQtXTOYfHoQL8kgej3YS5MLMWzEnKK4Vgq
         H8uhSk0YKyzH7isDBghJ+H234VbkoKsgmSSxoskGncSVwOlyorvu8k5eVoZyoJmuLeQk
         K052aj1Cviy4+uYXEGRHXAvq1Iai4WTVpDkwWWV//fGpDwlXv+C9jLvc70oFtCI3h1bs
         oXFFxWuMGyeiHV1Q3jNQt0tIE5JabfPFIYAJ1M0DT2TslCJOySrdYXpBi1d5l7aUZ3E0
         Srn5QgVqYBey6AVjRjkbGtEVNv6b8pk8xGBizlcx7PgURTojiOT3oAhofDO49fJhTrtU
         VM6Q==
X-Gm-Message-State: AOAM533ExmQjmaR5W6IP+iS/aSsVKPD1tqWSvG7M2LLe9jFkRjsZbklW
        wk6yfDExwr3BdFsFuMZcXF6amqzyas1dwKTJRAlKgWLXQE+k7EaT0+fE7NFVb0Y1zCqID7XODXh
        Jg2mLwmcNaZOUETTZHwy6
X-Received: by 2002:a17:90a:7787:: with SMTP id v7mr157209pjk.104.1602598312003;
        Tue, 13 Oct 2020 07:11:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxntHbnOgCitkDyThptGweNR543qqRGKYpekWxVQeI+FRrxjbV5tvvaYm0+R7BnTgz332Y+3g==
X-Received: by 2002:a17:90a:7787:: with SMTP id v7mr157166pjk.104.1602598311672;
        Tue, 13 Oct 2020 07:11:51 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x22sm23405772pfp.181.2020.10.13.07.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 07:11:51 -0700 (PDT)
Date:   Tue, 13 Oct 2020 22:11:41 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: introduce xfs_validate_stripe_geometry()
Message-ID: <20201013141141.GC12025@xiangao.remote.csb>
References: <20201013034853.28236-1-hsiangkao@redhat.com>
 <20201013134411.GE966478@bfoster>
 <20201013135537.GB12025@xiangao.remote.csb>
 <20201013140726.GH966478@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013140726.GH966478@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 13, 2020 at 10:07:26AM -0400, Brian Foster wrote:
> On Tue, Oct 13, 2020 at 09:55:37PM +0800, Gao Xiang wrote:
> > Hi Brian,
> > 
> > On Tue, Oct 13, 2020 at 09:44:11AM -0400, Brian Foster wrote:
> > > On Tue, Oct 13, 2020 at 11:48:53AM +0800, Gao Xiang wrote:
> > > > Introduce a common helper to consolidate stripe validation process.
> > > > Also make kernel code xfs_validate_sb_common() use it first.
> > > > 
> > > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > > ---
> > > > v1: https://lore.kernel.org/r/20201009050546.32174-1-hsiangkao@redhat.com
> > > > 
> > > > changes since v1:
> > > >  - rename the helper to xfs_validate_stripe_geometry() (Brian);
> > > >  - drop a new added trailing newline in xfs_sb.c (Brian);
> > > >  - add a "bool silent" argument to avoid too many error messages (Brian).
> > > > 
> > > >  fs/xfs/libxfs/xfs_sb.c | 70 +++++++++++++++++++++++++++++++++++-------
> > > >  fs/xfs/libxfs/xfs_sb.h |  3 ++
> > > >  2 files changed, 62 insertions(+), 11 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > > index 5aeafa59ed27..9178715ded45 100644
> > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > @@ -360,21 +360,18 @@ xfs_validate_sb_common(
> > > >  		}
> > > >  	}
> > > >  
> > > > -	if (sbp->sb_unit) {
> > > > -		if (!xfs_sb_version_hasdalign(sbp) ||
> > > > -		    sbp->sb_unit > sbp->sb_width ||
> > > > -		    (sbp->sb_width % sbp->sb_unit) != 0) {
> > > > -			xfs_notice(mp, "SB stripe unit sanity check failed");
> > > > -			return -EFSCORRUPTED;
> > > > -		}
> > > > -	} else if (xfs_sb_version_hasdalign(sbp)) {
> > > > +	/*
> > > > +	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
> > > > +	 * would imply the image is corrupted.
> > > > +	 */
> > > > +	if (!sbp->sb_unit ^ !xfs_sb_version_hasdalign(sbp)) {
> > > 
> > > This can be simplified to drop the negations (!), right?
> > 
> > Thanks for the suggestion.
> > 
> > yet nope, honestly I don't think so, the reason is that sbp->sb_unit is
> > an integer here rather than a boolean, so negations cannot be
> > simplified and I think it's simpliest now... (some boolean algebra...)
> > 
> 
> Oh, right. So you'd actually need something like (!!sunit ^ hasdalign())
> to avoid the bit operation.

Agree, that expression looks better <nod>
I will switch to it then. Thanks!

Thanks,
Gao Xiang

> 
> Brian

