Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0096C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 15:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90D3C207CD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 15:43:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T/WWFrfB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgHXPnQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 11:43:16 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26251 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728005AbgHXPll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 11:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598283694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IwR1yQh6hUs5GgiNecMh+H0JobUOMbbts2QOrqqlekg=;
        b=T/WWFrfBD4umCca0/vVeZBapJth/dsQmFYNYv6sSGs633CnICtJDBakSkDXxrtOVs1QpFI
        bur0ntfknz+mBXxWSgkdSlnk5M6fqA+p+eowjaLv48JQIDJiBvB7WTW4QFTHQfOgueakiK
        jpV+fqfPrh8OXUuhNNTXiq4fBaAH9TA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-cYJfzY99NBWexir5gO3j5A-1; Mon, 24 Aug 2020 11:41:32 -0400
X-MC-Unique: cYJfzY99NBWexir5gO3j5A-1
Received: by mail-pj1-f71.google.com with SMTP id gl22so5942600pjb.3
        for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2020 08:41:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IwR1yQh6hUs5GgiNecMh+H0JobUOMbbts2QOrqqlekg=;
        b=a6EzLNLlNQYfXu2aw28fWg78Csb69rSF4yswK0AImucoJs6HyPrPNGS/7Al5hOhIV4
         Yz90OKNxC5/D+HNqX/klRcaI7mDJ8dFXaJ2uvno3xWuU5MkrkIiz7WA5EOmuRbTsL4xB
         XNr6+GXJBTTBJ7wjMJsH+IYcVtjdIvTs/SZA4hPuDpVcrgBYDyjo9oQbhpBQfNJxmJ7D
         Wbzca28j+B4vItokNAmHBuaTCrsNxjVUsGHcFPkrz2WzR3tQveNOZSvj3Z9g3zVmHz+W
         ffx+jWm7/et6juz3fXtfeHmhHEKaKNslPSdw1BpDOHkTnG1cGUN9nLRJG7JGqf/6Nir+
         IM8A==
X-Gm-Message-State: AOAM532gqyUIyz+qiM+0oxm/zxxS5gpvYZOCyIhGM7bZYkoea92nWHQ0
        z4OEqvh+KylpPz2eI3di1zV3Az+TO0DJuhc41QviCGyQf5HfXk3hXy+BLAEmJ+xSomiH/Me0xz4
        qxqQVAZlc/4wKWL9phVym
X-Received: by 2002:a17:902:c408:: with SMTP id k8mr4112155plk.102.1598283690942;
        Mon, 24 Aug 2020 08:41:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDr/mn60flJjuBgtmjS6JkdFm5RCSnSI0IFRGn+OHbBtJ8L9OxuT2jm5lHkWA54Bjddn0zIA==
X-Received: by 2002:a17:902:c408:: with SMTP id k8mr4112123plk.102.1598283690480;
        Mon, 24 Aug 2020 08:41:30 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w82sm12229620pff.7.2020.08.24.08.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 08:41:29 -0700 (PDT)
Date:   Mon, 24 Aug 2020 23:41:20 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: use log_incompat feature instead of speculate
 matching
Message-ID: <20200824154120.GA23868@xiangao.remote.csb>
References: <20200823172421.GA16579@xiangao.remote.csb>
 <20200824081900.27573-1-hsiangkao@aol.com>
 <20200824083402.GB16579@xiangao.remote.csb>
 <20200824150832.GV6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824150832.GV6096@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 24, 2020 at 08:08:32AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 24, 2020 at 04:34:02PM +0800, Gao Xiang wrote:
> > On Mon, Aug 24, 2020 at 04:19:00PM +0800, Gao Xiang wrote:
> > > From: Gao Xiang <hsiangkao@redhat.com>
> > > 
> > > Use a log_incompat feature just to be safe.
> > > If the current mount is in RO state, it will defer
> > > to next RW remount.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > > 
> > > After some careful thinking, I think it's probably not working for
> > > supported V4 XFS filesystem. So, I think we'd probably insist on the
> > > previous way (correct me if I'm wrong)...
> > > 
> > > (since xfs_sb_to_disk() refuses to set up any feature bits for non V5
> > >  fses. That is another awkward setting here (doesn't write out/check
> > >  feature bits for V4 even though using V4 sb reserved fields) and
> > >  unless let V4 completely RO since this commit. )
> > > 
> > > Just send out as a RFC patch. Not fully tested after I thought as above.
> > 
> > Unless we also use sb_features2 for V4 filesystem to entirely
> > refuse to mount such V4 filesystem...
> > Some more opinions on this?
> 
> Frankly, V4 is pretty old, so I wouldn't bother.  We only build new
> features for V5 format.

Okay, let me go further with log_incompat (v5) and sb_features2 (v4)
later.

Thanks,
Gao Xiang

> 
> --D
> 
> > Thanks,
> > Gao Xiang
> > 
> 

