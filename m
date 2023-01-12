Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4C9C46467
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Jan 2023 01:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbjALBpC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Jan 2023 20:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjALBpB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2023 20:45:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0C537509
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 17:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673487855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6oXZbX8QwsHNv2+GsJetpXD0w8CIK2eZYoWLFcYWqoo=;
        b=cGQiqPEYn2c6IDm48xCpFw6uti4WxdjZhWIu0F2MHUxh8JL2FrZ8Xi2NnG2LWCXc5x4kTA
        0FvMd3W7uGKjwD7rkSeUDbwbE1XaVttayjyjxmFlgOryvcOhzZaOCSfkzIN1NV2aW+skjF
        2V0fDK386+OE1O6/Ae2JPmf7fHyBuHI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-351-1xnceS7vM7ymhok1VsycmA-1; Wed, 11 Jan 2023 20:44:13 -0500
X-MC-Unique: 1xnceS7vM7ymhok1VsycmA-1
Received: by mail-wm1-f70.google.com with SMTP id j15-20020a05600c1c0f00b003d9ec0eaa74so2114681wms.1
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 17:44:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6oXZbX8QwsHNv2+GsJetpXD0w8CIK2eZYoWLFcYWqoo=;
        b=apYAV/Qv53N4dSJNg12TpB2GiMMTom7g6Gvw7DQa/lFjh7dVTX42hjQQ9riAtUsp3e
         gcferKsJAwKqJ07KP4Rda5WVfK/uzpTpvpLL5mWJppS6dFU7s0DqHySS/NQRqdg/nE0H
         GeXuc92QT7Vf4MpGzl8qItoLMGPGKdztdvKNvJv7RY53YRbbUpbw/d4Zv8chgEO9vQ7W
         +eDI8afAWz2Uwmev1z6lbo3mgvHyJcARufQRJdw8zPmuw5t8Nj5/FpY7fab1UooKf2Ly
         RKq5huWo7+vDyXu4hXRnIsM6CVpasgsVnqE+ifMpvltv7vgQh56nOpVOy5Yay2AnjqVH
         DqMg==
X-Gm-Message-State: AFqh2krExmxKHl//ePczJkWL6e+e3v3DEJ/NGSTXZjndFljfUwSZnOnK
        LWw2AeQ/gWMLQAXuAmtHrBNR132BuuSl5dfL1p3o2nroGRXpgdMje2vwWInzLAdV0SeNeE2Psxs
        mXCPqXIPxPDc4KNyCO46L
X-Received: by 2002:a05:600c:1f15:b0:3cf:98e5:f72 with SMTP id bd21-20020a05600c1f1500b003cf98e50f72mr57486886wmb.3.1673487851799;
        Wed, 11 Jan 2023 17:44:11 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvZUDhO4Z16UeEVkUdxlWpGIyH+OP6ij90zPU4LRfTf69DXsC/Q32G/Wxdhrx3RActJNZq+Mg==
X-Received: by 2002:a05:600c:1f15:b0:3cf:98e5:f72 with SMTP id bd21-20020a05600c1f1500b003cf98e50f72mr57486876wmb.3.1673487851544;
        Wed, 11 Jan 2023 17:44:11 -0800 (PST)
Received: from nixos ([2a00:1110:101:7789:849d:20c:6cb1:53b8])
        by smtp.gmail.com with ESMTPSA id f19-20020a1c6a13000000b003d9fb04f658sm6176102wmc.4.2023.01.11.17.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 17:44:10 -0800 (PST)
Date:   Thu, 12 Jan 2023 02:44:01 +0100
From:   Csaba Henk <chenk@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsdocs: add epub output
Message-ID: <20230112014401.ifwjtqx4jzbykeep@nixos>
References: <20230111081557.rpmcmkkat7gagqup@nixos>
 <20230111221027.GC360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230111221027.GC360264@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23-01-12 09:10:27, Dave Chinner wrote:
> On Wed, Jan 11, 2023 at 09:15:57AM +0100, Csaba Henk wrote:
> > ---
> >  .gitignore                               |  1 +
> >  admin/Makefile                           | 13 +++++++++++--
> >  admin/XFS_Performance_Tuning/Makefile    | 13 +++++++++++--
> >  design/Makefile                          | 13 +++++++++++--
> >  design/XFS_Filesystem_Structure/Makefile | 13 +++++++++++--
> >  5 files changed, 45 insertions(+), 8 deletions(-)
> 
> The change looks fine, but why do we need to build documentation in
> epub format? Empty commit messages are generally considered a bad

Well, we don't *need*; I just found we *can* (a2x spits it out in a
split second).

My perception is that epub has become the de facto standard portable
publication format for on-screen reading. So I thought it would be
beneficial to make it available.

If this is not a consensual stance, it's also a possibility to add
the epub target, but do not include it in default. Ie. make it
available on demand.

> thing - the commit message should explain to us why building epub
> format documentation is desired, what problem it solves, what new
> dependencies it introduces (e.g. build tools), how we should
> determine that the generated documentation is good, etc so that have
> some basis from which to evaluate the change from.

Sorry; I thought a mere subject suffices if it's obvious what's the
impact of the patch. I agree that giving context / rationale would be
useful. I'll add that, according to the approach we settle with (ie.
whether to include it in default).

Regards,
Csaba

