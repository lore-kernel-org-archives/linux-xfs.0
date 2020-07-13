Return-Path: <SRS0=4kkz=AY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1BCC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 09:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1A262067D
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 09:17:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KVGcb+A5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgGMJR7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 05:17:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27380 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726360AbgGMJR7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 05:17:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594631878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UF3rLa+RW9PuRXAQMg+MBlfsI3FfsHqEawNNq5k08hw=;
        b=KVGcb+A57yk7eAe/3jL2qu/gGAxyoLHqNXWmW/vSiw17Q39pp0XVJCnD451XpVV379hGcp
        P6/T9l5m6rx1ETdXHmSVQSQVWfM/w/UGq2n/XuxuZFJH23SWizKFFSHahabKnfBvKkTvnJ
        AXleH0nPQyF7ZKiLnpORJLoomcMCm3U=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-EmjewuK3O1KVX8AfNumepA-1; Mon, 13 Jul 2020 05:17:56 -0400
X-MC-Unique: EmjewuK3O1KVX8AfNumepA-1
Received: by mail-ed1-f71.google.com with SMTP id k25so19996825edx.23
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2020 02:17:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=UF3rLa+RW9PuRXAQMg+MBlfsI3FfsHqEawNNq5k08hw=;
        b=tFdkz1qRfB16NVJtr1ugrxw7hx146TpH3kYivr9wjB5MMYujaAmU37IQzwpvY4M6YF
         XB578Q3l4ouxVrG0yNWRodb2cr/OmB501Gm7MFPz4xtBhdqf9RZt9xJ+SZcRLXuSaV+b
         /S7Lo98ztJAtdFMCshpEIQfl0rKfL4qge4ib3xi+wUYA0lgKAQNgvAtPl57ZT2lC9vG4
         o2sf5s+UR0E1LXlPXLq1wRBCXnzY+0l7guz4k53K2W+HSB/56xsmoaSoJMlSandSMy8L
         tkGYTXuUpuR2ARTu7oO1HGvfkdPrO6UEe31JenkJEek0CteRuxntlryhr95MrxHqSmex
         +y4Q==
X-Gm-Message-State: AOAM530E0FljfThWsJV62EwGJBRS38PR7IOdAUlcoPkgjGuf9GdnAZXQ
        nb/NiKl6yIyWLhJZNyyFH4II0RcEh0UOhYc/MvVCwLXMuuHEn6V8vQe6Z4jTdK+U81E9Zp1NaU8
        wEtZqaDlp/Ad8NZ8uqrBM
X-Received: by 2002:a50:f418:: with SMTP id r24mr83699708edm.382.1594631875162;
        Mon, 13 Jul 2020 02:17:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnY/112UD2Lgudo+eTYcKIfbHB2NfYKg3vXEm3xWd6cB74Fgxmg0l+ExBPMOoIPPVKlXstrw==
X-Received: by 2002:a50:f418:: with SMTP id r24mr83699701edm.382.1594631874970;
        Mon, 13 Jul 2020 02:17:54 -0700 (PDT)
Received: from eorzea (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id j64sm11041287edd.61.2020.07.13.02.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 02:17:54 -0700 (PDT)
Date:   Mon, 13 Jul 2020 11:17:52 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: Remove xfs_da_state_alloc() helper
Message-ID: <20200713091752.lxdm2qn7be5jzji4@eorzea>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-6-cmaiolino@redhat.com>
 <20200710161111.GE10364@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710161111.GE10364@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 10, 2020 at 05:11:11PM +0100, Christoph Hellwig wrote:
> On Fri, Jul 10, 2020 at 11:15:36AM +0200, Carlos Maiolino wrote:
> > xfs_da_state_alloc() can simply be replaced by kmem_cache_zalloc()
> > calls directly. No need to keep this helper around.
> 
> Wouldn't it be nicer to keep the helper, and also make it setup
> ->args and ->mp?

Yup, sounds good, thanks for the suggestion, I'll update the patch accordingly.

-- 
Carlos

