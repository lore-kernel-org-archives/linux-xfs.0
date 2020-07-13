Return-Path: <SRS0=4kkz=AY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA99C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 09:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D5902067D
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 09:16:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KaZxsOkX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgGMJQR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 05:16:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26401 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726360AbgGMJQR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 05:16:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594631775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JD0j80MMVantEaiH8Wkoj42IhUvKLOr0oGI6F6c4fOM=;
        b=KaZxsOkX4qVtT0VftcZ9+TE+3tDmqPqp42whh7LE6X9A9TPvSnHSpY2CCnYNS87ab0bErV
        Kj/YEde2L9gixuYJ1sp3ssjDNrTEQjucv8tAqrPT93gUQGGi5RXjBdxhGNUgBc/qcekhto
        mIh86md14S3VW2fbNYBaf51/0zwmbyY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-rvG6htGrMTe16nEcO4t7Dg-1; Mon, 13 Jul 2020 05:16:14 -0400
X-MC-Unique: rvG6htGrMTe16nEcO4t7Dg-1
Received: by mail-ej1-f70.google.com with SMTP id yh3so18444423ejb.16
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2020 02:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=JD0j80MMVantEaiH8Wkoj42IhUvKLOr0oGI6F6c4fOM=;
        b=IVHKB4X1Jq1uaNpeIx+wU9NYqLkekRwLw/c8JnmN+nFCU1aZnAlOQaL6HmvxSgej9Z
         yE8czhWMA6qT428iD4kEvIMaxN20NyN4rMMmSr25ea8WH8Gek0xKe38W9Cs3F75Z2bIQ
         ubEjq3tzNzSkVsBeFR35LpXYP+pb9uHW2JwPM5RlNQxzLgYxK7TUBz7/lao81WXMw7u/
         8a4ou+aqkE2YqfKam4LC8E7rS4zQhkZS0F0yvcb8XdXqgJ0J0rH1Ibe2nALxx/AJ2r/j
         oNFryjocUe0eRfW7YntuYK8IoP6jTdpAQAVe8fMPAuy8u4wrB5QIWj/4kJCUNfwKFmQL
         07Ow==
X-Gm-Message-State: AOAM5321LjvIMmgSJsCHkGZO597JqwP1Q2PganEWF+bbl3Bp+NbGlUpI
        M3dOVKYSztJiRubH80Y1k+QKEElP9tyvrqQWlUGth8Mtj8kknOkmj9aonY7qaLANA2jdRgjGGMn
        Ehpi2NGK6jUsCaywXmfyz
X-Received: by 2002:a17:906:cd19:: with SMTP id oz25mr71240636ejb.36.1594631772740;
        Mon, 13 Jul 2020 02:16:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBdnI04dTM0/o4wrDJwPXNYoXHO2JBwFq6iajEKBaquLTMw904UQ1DKSi/WcscFE9gxycJKQ==
X-Received: by 2002:a17:906:cd19:: with SMTP id oz25mr71240622ejb.36.1594631772545;
        Mon, 13 Jul 2020 02:16:12 -0700 (PDT)
Received: from eorzea (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id ks27sm9223323ejb.7.2020.07.13.02.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 02:16:11 -0700 (PDT)
Date:   Mon, 13 Jul 2020 11:16:10 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 1/5] xfs: Remove kmem_zone_alloc() usage
Message-ID: <20200713091610.kooniclgd3curv73@eorzea>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-2-cmaiolino@redhat.com>
 <20200710160804.GA10364@infradead.org>
 <20200710222132.GC2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710222132.GC2005@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave, Christoph.

> > > -	ip = kmem_zone_alloc(xfs_inode_zone, 0);
> > > +
> > > +	if (current->flags & PF_MEMALLOC_NOFS)
> > > +		gfp_mask |= __GFP_NOFAIL;
> > 
> > I'm a little worried about this change in beavior here.  Can we
> > just keep the unconditional __GFP_NOFAIL and if we really care do the
> > change separately after the series?  At that point it should probably
> > use the re-added PF_FSTRANS flag as well.

> Checking PF_FSTRANS was what I suggested should be done here, not
> PF_MEMALLOC_NOFS...


No problem in splitting this change into 2 patches, 1 by unconditionally use
__GFP_NOFAIL, and another changing the behavior to use NOFAIL only inside a
transaction.

Regarding the PF_FSTRANS flag, I opted by PF_MEMALLOC_NOFS after reading the
commit which removed PF_FSTRANS initially (didn't mean to ignore your suggestion
Dave, my apologies if I sounded like that), but I actually didn't find any commit
re-adding PF_FSTRANS back. I searched most trees but couldn't find any commit
re-adding it back, could you guys please point me out where is the commit adding
it back?

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

-- 
Carlos

