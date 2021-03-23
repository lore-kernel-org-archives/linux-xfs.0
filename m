Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A912C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 09:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 465B3619B2
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 09:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhCWJIn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 05:08:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229666AbhCWJI0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 05:08:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616490505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TTtp1YUXJXRt4fQ4b6JkgD7LlzPK3W7zSa1yVCN2e8Y=;
        b=NeoUDEvQPREJO+wyNAV1RlmHHmqcOrHtivlP+HjlR7GlfOXLxxcRTmPgkYG50qaA23wu6y
        gByIWja4r1S/ErTgnpK1G0VNlkuhE2dOvCitstJ8l1LBNHOVfoypBt2pkthVVKdlPPv/3f
        o3Bnadq4WAlyHXXcqdnL7eraDm485Dk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-me2ZrdkVPZGYRwMXrcsw0A-1; Tue, 23 Mar 2021 05:08:24 -0400
X-MC-Unique: me2ZrdkVPZGYRwMXrcsw0A-1
Received: by mail-ed1-f69.google.com with SMTP id h5so644981edf.17
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 02:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=TTtp1YUXJXRt4fQ4b6JkgD7LlzPK3W7zSa1yVCN2e8Y=;
        b=idtqXQCm9eWiUIUDEPslGrsbH3X1vtV+5co+WHfVrO6S9D4XEokT7J9UPWrv7QRw6w
         FAxK+Sra1xbfxLkLIcPqZSWvyKU5MajmF6GVaAAK/u9QEn7UQU7ybwOZMVhqlr6dLmfB
         q6oVfza4coOxcmJLOv50ofuICaKcUJDvt223vs/go6ZoevLOk21wqRDcENTJSkKR0VSA
         XUWL0oMtf1v5jk3GGdaTa7+4GQJ5QCo4E8JH8s7tDBb1F0MjriYq6kTYJLXoReZdPrYt
         rfSa3B+S+TQJ2CeMJa8lj/sUNX5WHsY8s5f0CF2PG3/KXjO1zzMvXvd1uYNP6KTJstBn
         o94w==
X-Gm-Message-State: AOAM531chzyXxu3Zs9I6f6HNn8NeTEgWgdw9bv5tD4sZtH2PJSY9gexH
        QVglYntFZUYYZhfyFLpkMGTZN/OClyLB57GVOfDZAtstQ2DR8oPHIZFaXAWGVBpoWqti2NO1L62
        C+Sf8Tj8vZDLjRxb9SSoL
X-Received: by 2002:a17:906:e2d4:: with SMTP id gr20mr4016052ejb.432.1616490502908;
        Tue, 23 Mar 2021 02:08:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyw4ctB+tAHL2Caz5hOG9VJMejLeMC09oudDbvTVNxbr2hRoxqpOizAW8WCXYXM5jEcIea9+w==
X-Received: by 2002:a17:906:e2d4:: with SMTP id gr20mr4016038ejb.432.1616490502782;
        Tue, 23 Mar 2021 02:08:22 -0700 (PDT)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id z9sm13088505edr.75.2021.03.23.02.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 02:08:21 -0700 (PDT)
Date:   Tue, 23 Mar 2021 10:08:20 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_logprint: Fix buffer overflow printing quotaoff
Message-ID: <20210323090820.v7zfewtgpc4vymaq@andromeda.lan>
Mail-Followup-To: Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20210316090400.35180-1-cmaiolino@redhat.com>
 <0a4f390e-53d2-7be9-fc6b-6064f4f8249b@sandeen.net>
 <20210316141044.4myelroxkotnq57h@andromeda.lan>
 <20210316153604.GH22100@magnolia>
 <6f63215f-7ae5-b000-723c-92f54dd17ace@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f63215f-7ae5-b000-723c-92f54dd17ace@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 16, 2021 at 11:11:08AM -0500, Eric Sandeen wrote:
> On 3/16/21 10:36 AM, Darrick J. Wong wrote:
> > On Tue, Mar 16, 2021 at 03:10:44PM +0100, Carlos Maiolino wrote:
> >> On Tue, Mar 16, 2021 at 08:45:20AM -0500, Eric Sandeen wrote:
> >>> On 3/16/21 4:04 AM, Carlos Maiolino wrote:
> >>>> xlog_recover_print_quotaoff() was using a static buffer to aggregate
> >>>> quota option strings to be printed at the end. The buffer size was
> >>>> miscalculated and when printing all 3 flags, a buffer overflow occurs
> >>>> crashing xfs_logprint, like:
> >>>>
> >>>> QOFF: cnt:1 total:1 a:0x560530ff3bb0 len:160
> >>>> *** buffer overflow detected ***: terminated
> >>>> Aborted (core dumped)
> >>>>
> >>>> Fix this by removing the static buffer and using printf() directly to
> >>>> print each flag. 
> >>>
> >>> Yeah, that makes sense. Not sure why it was using a static buffer,
> >>> unless I was missing something?
> >>>
> >>>> Also add a trailling space before each flag, so they
> >>>
> >>> "trailing space before?" :) I can fix that up on commit.
> >>
> >> Maybe I slipped into my words here... The current printed format, did something
> >> like this:
> >>
> >> type: USER QUOTAGROUP QUOTAPROJECT QUOTA
> >>
> >> I just added a space before each flag string, to print like this:
> >>
> >> type: USER QUOTA GROUP QUOTA PROJECT QUOTA
> > 
> > Any reason we can't just shorten this to "type: USER GROUP PUOTA" ?
> 
> oh yeah, that's a good idea, but: "USER GROUP PROJECT"

Sorry late reply, I don't see why not too, I just followed the current
convention. I'll submit a V2

> 
> -Eric
> 

-- 
Carlos

