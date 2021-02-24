Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB85C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 01:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED9464DAF
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 01:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhBXBIU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 20:08:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233951AbhBXBBJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 20:01:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614128353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jqos34HouoQI/ZPmTsvuld+fqWEA0Uyq9pVz25+GE8Y=;
        b=XmYwFvSlZxya5T0P10vBn+b2tw2DQj7Tvrn2EGRlN2/MB2GYMqo4FWOU3Hj6UtAvicgFoh
        0ENlkISPQ8BY9wIuZ55Zmyvx5iHhiWnw/3VfAmb2rbLpHpDmO9iyTia+VND9FOXQK9rMZ9
        DKKk/4PlQ7QYNu5XWlQwBFju2gaGCPw=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-Bx2JzHqAMraJ_-fD7brSLQ-1; Tue, 23 Feb 2021 19:55:34 -0500
X-MC-Unique: Bx2JzHqAMraJ_-fD7brSLQ-1
Received: by mail-pf1-f198.google.com with SMTP id t13so371287pfg.13
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 16:55:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Jqos34HouoQI/ZPmTsvuld+fqWEA0Uyq9pVz25+GE8Y=;
        b=JuthzeZJX1wnFMRmD1wOszL3VByJsjQ20447O4yGS0Ao5QufFCd5PjstOt1yij88Ip
         qTqCoXfWFLLTvfbflY+iaeebCgLaV/A/I4Hy8ymISf/4hIIK8DF7dFHJ98OjrkEUDQwv
         0oTaXBcA/m0ZqajJGuUw4VgyH1NZjTPcmDiCKwFkOOc3evqYtb4Dc1OC0yzaJ1hRUdIk
         PlzXLIArdxc9A/pP9CoeWRoE9SMlDDbmlsNrPAWYBYsUC03r6eCRNA0OReWBEhlUdno9
         /cqticQ4B6LW5wQpwqAQaF9c5XeOSn/XNthA9sssZzm+lX3ZBkvZmxPpGdyTw1I5Fj/6
         4UuQ==
X-Gm-Message-State: AOAM530JKzzx7dlRUy28Dd7buIq0/PcYgmIA4up7aV/+kiA3ngd9iXyP
        khiDbw1uVHzfoZWa111LOvRuKIWUq6Vuo17J0PZa/n6p8FSZYghmYavmSvNn8E0kOns8G6O5meD
        H7rFXvRtTItTzVV+Aut7k
X-Received: by 2002:a63:d20a:: with SMTP id a10mr25966270pgg.451.1614128133533;
        Tue, 23 Feb 2021 16:55:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQKx3AYZYLoMMmrLOFVgA2NnvRPRfaC5096C+pqWUZjWid6qejgjAgATTuCN9UpI4gHefXTw==
X-Received: by 2002:a63:d20a:: with SMTP id a10mr25966258pgg.451.1614128133331;
        Tue, 23 Feb 2021 16:55:33 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y7sm370591pfc.162.2021.02.23.16.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 16:55:32 -0800 (PST)
Date:   Wed, 24 Feb 2021 08:55:21 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 3/3] mkfs: make use of xfs_validate_stripe_geometry()
Message-ID: <20210224005521.GA1424840@xiangao.remote.csb>
References: <20201013040627.13932-4-hsiangkao@redhat.com>
 <20210219013734.428396-1-hsiangkao@redhat.com>
 <e703b458-63a5-e68c-aec3-5a28c5c0d27f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e703b458-63a5-e68c-aec3-5a28c5c0d27f@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 06:10:45PM -0600, Eric Sandeen wrote:
> On 2/18/21 7:37 PM, Gao Xiang wrote:
> > Check stripe numbers in calc_stripe_factors() by using
> > xfs_validate_stripe_geometry().
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 
> I think this is good to go now, thank you.
>

Sorry for my careless mistake at that time and
thanks for your review!

Thanks,
Gao Xiang

