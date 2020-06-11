Return-Path: <SRS0=ihlG=7Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE930C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 18:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B203820836
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 18:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591898465;
	bh=ZvB6xGLGbaXd7GYLGjnjcoJ6qL/EFOX+NtFTVjvcGz8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=jGnGldRVXbjwkEMliGKGvoxM5RS8rofR7dOols/KT80uEg5yQvBrQb4rBNF8Mngo+
	 YuNUbwdPo193saood8G3T5kKSXlkO2825BOGBuqR4qUCr4zok8IpuWRg9g74pO4wra
	 1uk2BoMLpIaB48hj0QagayRExVQMIAQifA1MplMM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgFKSBF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 14:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgFKSBE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jun 2020 14:01:04 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C27DC03E96F
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2020 11:01:04 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id x22so4012992lfd.4
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2020 11:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BulRtyYimxYCM3JqpK8tF3IaJrXUR0A9VD3QaE4GUiU=;
        b=F+EXHlVbvkMTRVWWzv8ZcPEHGpfAID2Da8N5jJ9jwq/Sk5UFdV4BndnY890mbolBO3
         xJbuERV3mR0f+F5yKntH8xwiKR2kUGoUueLXNO5RnIgcO1PBh7DEHUydmD5yKAclq+vQ
         balMdqIjrUuK2NFsEurmgSTtX0E/N5pRMm69I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BulRtyYimxYCM3JqpK8tF3IaJrXUR0A9VD3QaE4GUiU=;
        b=hC9II7rQ30a+KsHfOEDpW7LmMiC0sG40evkMI4xpwIJ0EaGWZXG+GC93QzVGAUR5J2
         zKBNg6CEHlcXm2wVMYGJxLZksb4MyFbDgaug7PkiwUWURow0r/5zINgMNcJlHvuSJxnd
         h2OMTxac685vMr43dcQRm/m7yHDfq1oehDtus95WRDkKPF97HuoX3q3976qW9XtyypNF
         eOrfDj1ud+3kYz6IqVyappAu7BvPP2YLWUptlw9zc/uLkF/hDu8G8vEpP9Lah5cxNBEY
         j3w39SGTK/Fo2QBE0+iCHHs/6FsE88YSdnp0gWOM7qOmgzdka+5pSI/ylJ7vMz1fjTo1
         NC6Q==
X-Gm-Message-State: AOAM531FQo9iUmkAPa8ImzEiIYzrncbGWzfZ1scDioUBvEiUas6zHLFb
        Ai29WCIbK5OmHe/LSPWV6lSXx1q3SK4=
X-Google-Smtp-Source: ABdhPJw19yFnzvPCcVGb5XJzoGF68JW5yZJnE6hRqTpHsTxqoIanGcCani04ijwdF416E0MI+ZZsCw==
X-Received: by 2002:a05:6512:104c:: with SMTP id c12mr4890318lfb.200.1591898462133;
        Thu, 11 Jun 2020 11:01:02 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id f18sm990380lfh.49.2020.06.11.11.01.00
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 11:01:00 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id i27so7966291ljb.12
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2020 11:01:00 -0700 (PDT)
X-Received: by 2002:a2e:8e78:: with SMTP id t24mr4854187ljk.314.1591898459839;
 Thu, 11 Jun 2020 11:00:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200611024248.GG11245@magnolia>
In-Reply-To: <20200611024248.GG11245@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 Jun 2020 11:00:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgTMxCAHVgtKkbSJt=1pBm+86bz=RbZiZE-2sszwmcKvQ@mail.gmail.com>
Message-ID: <CAHk-=wgTMxCAHVgtKkbSJt=1pBm+86bz=RbZiZE-2sszwmcKvQ@mail.gmail.com>
Subject: Re: [GIT PULL] vfs: improve DAX behavior for 5.8, part 3
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 10, 2020 at 7:43 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> I did a test merge of this branch against upstream this evening and
> there weren't any conflicts.  The first five patches in the series were
> already in the xfs merge, so it's only the last one that should change
> anything.  Please let us know if you have any complaints about pulling
> this, since I can rework the branch.

I've taken this, but I hate how the patches apparently got duplicated.
It feels like they should have been a cleanly separated branch that
was just pulled into whoever needed them when they were ready, rather
than applied in two different places.

So this is just a note for future work - duplicating the patches like
this can cause annoyances down the line. No merge issues this time
(they often happen when duplicate patches then have other work done on
top of them), but things like "git bisect" now don't have quite as
black-and-white a situation etc etc.,

("git bisect" will still find _one_ of the duplicate commits if it
introduced a problem, so it's usually not a huge deal, but it can
cause the bug to be then repeated if people revert that one, but
nobody ever notices that the other commit that did the same thing is
still around and it gets back-ported to stable or whatever..)

So part of this is just in general about confusing duplicate history,
and part of it is that the duplication can then cause later confusion.

                Linus
