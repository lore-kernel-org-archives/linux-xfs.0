Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9A2C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 10:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1317206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 10:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NwQOYPhR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgGIKgg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 06:36:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40558 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726298AbgGIKgg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 06:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594290994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dVwZExgR8YvAR5XJkr5HTnjhAQ838trVAVdllIXElMk=;
        b=NwQOYPhRrTeWatnL3toV0EeG9KKipyFLJc2y2zo7nwpvnDgKRlzGx7GKUtpJmLUkJUxPDu
        PEFukvavsUm7NOaIpN9BetmawZR1wIyBRnJbLeVU9L9UvnhRMTu6vI54MdtwSRiFAOX4Qb
        r3cqugOIZEki05Mb2WTh4qLxws/SafA=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-GuqhnZ6LPNONxvwkAi57jw-1; Thu, 09 Jul 2020 06:36:32 -0400
X-MC-Unique: GuqhnZ6LPNONxvwkAi57jw-1
Received: by mail-pg1-f198.google.com with SMTP id e127so1444044pgc.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jul 2020 03:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dVwZExgR8YvAR5XJkr5HTnjhAQ838trVAVdllIXElMk=;
        b=GSwaon9/NoLOY2OrUhYvrEUNCAfwE/6Alh7qdJ6qKZRaJdhIuWH0iSr4B+vGAYl3L3
         QRzzZsHmcpUJ6HcukiEETv7RP/UDEz+WjMx2TKRbsGxj2+Y8ccWkcVbZq4eFJCu+gRVK
         LnNs0/444U6+3zD8oDPomCS8Y4cNf8b5QgB+jAUiuDkUWxwE6q3gXSBxXn7tkyIJnAlD
         AEk+l6MW8sPdAlPHhwJLyxLvZSvyHzpwq1f/i8moYWCtUVSGFMeQwnhES1oMEsh9x/OE
         oNbfaIlW38Su4NbFaiwyt2iwmoi89u/mm06JQfUDSUufAnWPVmrKpuobedDHhfgNd/Ao
         UFqg==
X-Gm-Message-State: AOAM531UtCVc+ESOWyhj09UXIFot4fMjp7DTHOUGmb8EG78q0208/WMU
        94NHuWdUKawSKwdH2GLFsjpeYxmOd70IZiE3uqkDqZ1MC1l3lOw2cWNa7ciLw3UOdgsqGJxdoEZ
        wuuvNGd0il8tGsCcVDk9K
X-Received: by 2002:a17:90a:ea86:: with SMTP id h6mr13853430pjz.200.1594290991942;
        Thu, 09 Jul 2020 03:36:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfFVNUQgpsUHFQb9AYZW/L6qv9V495YuF8PhL8d+acpaEykPo4SUuSp7yXU24SEqRHNEcykA==
X-Received: by 2002:a17:90a:ea86:: with SMTP id h6mr13853420pjz.200.1594290991693;
        Thu, 09 Jul 2020 03:36:31 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u66sm2413464pfb.191.2020.07.09.03.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 03:36:31 -0700 (PDT)
Date:   Thu, 9 Jul 2020 18:36:21 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 2/2] xfs: don't access AGI on unlinked inodes if it
 can
Message-ID: <20200709103621.GD15249@xiangao.remote.csb>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200707135741.487-3-hsiangkao@redhat.com>
 <20200708233311.GP2005@dread.disaster.area>
 <20200709005526.GC15249@xiangao.remote.csb>
 <20200709023246.GR2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709023246.GR2005@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Thu, Jul 09, 2020 at 12:32:46PM +1000, Dave Chinner wrote:

...

> > > 	if (trylock AGI)
> > > 		return;
> > 
> > (adding some notes here, this patch doesn't use try lock here
> >  finally but unlock perag and take AGI and relock and recheck tail_empty....
> >  since the tail non-empty is rare...)
> 
> *nod*
> 
> My point was largely that this sort of thing is really obvious and
> easy to optimise once the locking is cleanly separated. Adding a
> trylock rather than drop/relock is another patch for the series :P

I thought trylock way yesterday as well...
Apart from that we don't have the AGI trylock method yet, it seems
not work as well...

Thinking about one thread is holding a AGI lock and wants to lock perag.
And another thread holds a perag, but the trylock will fail and the second
wait-lock will cause deadlock... like below:

Thread 1			Thread 2
 lock AGI
                                 lock perag
 lock perag
                                 trylock AGI
                                 lock AGI           <- dead lock here

And trylock perag instead seems not work well as well, since it fails
more frequently so we need lock AGI and then lock perag as a fallback.

So currently, I think it's better to use unlock, do something, regrab,
recheck method for now...

And yeah, that can be done in another patch if some better way. (e.g.
moving modifing AGI into pre-commit, so we can only take one per-ag
lock here...)

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

