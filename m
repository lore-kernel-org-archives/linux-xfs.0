Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D6DC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 14:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E490610A8
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 14:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354806AbhESOxk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 10:53:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354196AbhESOxk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 10:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621435939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9K4dmBQW5mNDLAKvbaAcsseV90GgNQIe7ZrAMNCE0S8=;
        b=REgNDTvOJyeVM2mUSHC6aetduUimrTBoV9/FnGwtBUdqQmgm23olI5bV/Gt4fDou7WvdEi
        l5flHayz5pl75awKF78T9ZJrG+yDiw6B0DQr7JXwgWwskKnxnMda6opVCa9Jj7Po27Ad7b
        jriQkVi0uPMIWGhT+dCJMbRw/0bnb9c=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-DlJKITF-NjOQZNjfS27FEw-1; Wed, 19 May 2021 10:52:18 -0400
X-MC-Unique: DlJKITF-NjOQZNjfS27FEw-1
Received: by mail-qt1-f199.google.com with SMTP id a7-20020a05622a02c7b02901fbef073c99so3523273qtx.15
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 07:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9K4dmBQW5mNDLAKvbaAcsseV90GgNQIe7ZrAMNCE0S8=;
        b=IZ/KXCaGU0T0Ft0OZKAlub8WWUN4q7CQWLZpJ/atSCDzSvyQZrlN6RgM9RuHAd4KRK
         PfsjeNjyVYtSg1GYFKXbW2WGmCweKa1ojdV1A/rbPlhO6mHndwTTNh+W/8MMbvZErWn9
         rSG/URB+YtxbeJlXdYbvFWGKWtF2EYdPwoEzrJBbdCeDjGaUsDJK0V39CepNjLytXX9r
         hJdnO7Q8yfzOnTQW6TERsNzqMODyx4Ey8Bh16Hh/P8GIfr2osnD2bEaZNQYq9x2cZ69y
         G7UHKwYSBt2qZ14H0ERvBPZOtO3rctopB4XYhHub7VF6mXcPy2cS1EtHpyit42Yu4qqR
         k6mQ==
X-Gm-Message-State: AOAM530a3XgzdV56RBUGrKO5lLSMITFITPhMvTI14RWl22D+KyNhRROf
        Z648+p3Wc0YHKzmZhq2RDyNmQND/f/7uG4YGedeCuBKIP8/GH9cxFr/jCA9/so/VJh42Z7cbZxG
        wBCgDA24KLFjDe0riS/F1
X-Received: by 2002:ac8:5553:: with SMTP id o19mr11743484qtr.308.1621435937728;
        Wed, 19 May 2021 07:52:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOsigTUtmhANU4r4qDK1p3Br78jsKHKdzZdzxlM1WEqxA+fxQJwLJhQMkImuRMd+zRZXqoXg==
X-Received: by 2002:ac8:5553:: with SMTP id o19mr11743467qtr.308.1621435937546;
        Wed, 19 May 2021 07:52:17 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id y8sm15814488qtn.61.2021.05.19.07.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:52:17 -0700 (PDT)
Date:   Wed, 19 May 2021 10:52:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 3/3] iomap: bound ioend size to 4096 pages
Message-ID: <YKUmH+JubDFH1jAH@bfoster>
References: <20210517171722.1266878-1-bfoster@redhat.com>
 <20210517171722.1266878-4-bfoster@redhat.com>
 <YKUSh4DVMCTzlSOE@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKUSh4DVMCTzlSOE@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 02:28:39PM +0100, Christoph Hellwig wrote:
> On Mon, May 17, 2021 at 01:17:22PM -0400, Brian Foster wrote:
> > The iomap writeback infrastructure is currently able to construct
> > extremely large bio chains (tens of GBs) associated with a single
> > ioend. This consolidation provides no significant value as bio
> > chains increase beyond a reasonable minimum size. On the other hand,
> > this does hold significant numbers of pages in the writeback
> > state across an unnecessarily large number of bios because the ioend
> > is not processed for completion until the final bio in the chain
> > completes. Cap an individual ioend to a reasonable size of 4096
> > pages (16MB with 4k pages) to avoid this condition.
> 
> Note that once we get huge page/folio support in the page cache this
> sucks as we can trivially handle much larger sizes with very little
> iteration.
> 
> I wonder if both this limit and the previous one should be based on the
> number of pages added instead.  And in fact maybe if we only want the
> limit at add to ioend time and skip the defer to workqueue part entirely.
> 

Both limits are already based on pages. I imagine they could change to
folios when appropriate.

The defer to workqueue part was based on your suggestion[1]. The primary
purpose of this series is to address the completion processing soft
lockup warning, so I don't have a strong preference on whether we do
that by capping ioend size, processing (and yielding) from non-atomic
context, or both.

Brian

[1] https://lore.kernel.org/linux-fsdevel/20200917080455.GY26262@infradead.org/

