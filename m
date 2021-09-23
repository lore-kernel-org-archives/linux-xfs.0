Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5BCC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 23:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BD7761107
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 23:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243531AbhIWXCO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 19:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243492AbhIWXCN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Sep 2021 19:02:13 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6B1C061757
        for <linux-xfs@vger.kernel.org>; Thu, 23 Sep 2021 16:00:41 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id b82so930332ybg.1
        for <linux-xfs@vger.kernel.org>; Thu, 23 Sep 2021 16:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fooishbar-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tNi4Bos8lh7sJkc+jDcM0nJh0Q/L0O1bHURQWGbTkX4=;
        b=BSc1fqu6/Z/Rv3MnwMMeXb/jTCrjhoOWWYoqBAGDKtIkwZf5Ohw+67BmYf7iyGtKLw
         FGPyN7RfyoVb/tO3VZUYC67xDFTbdn2SvyUwiirIGqrO3ztPpmYSJ+QQoBVJAhPXsQzH
         JIgFfev54CDOz7nVU0ko5gEDaIniTuNVSzBdP3SUiz4wrhztbFrvVI617a+Qg7Q7GU2Y
         PxqWZ/Y4REdyQy8jB1fGjgCHPwZQe+RvBts8vdqPb14T84tyq1AgoglerVejtYa/hSrx
         TknyI/LcvKRi1Qa0viPfnd3bH164YUcPly4CFCQw61l9fehNp4BxbaO2AD8T1AQlkEkJ
         ygAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tNi4Bos8lh7sJkc+jDcM0nJh0Q/L0O1bHURQWGbTkX4=;
        b=1NyKQ0yWM993bczVNnkE4hDPO1TfHuF+71BUYY0MGoIzpc6jNoT0zZeX3qDPwCgSjj
         lmjUFUrZ0Sr04vu4qSarKVM6kIROlYi88JII9q5KmOjRNnpPAczxn7FeuH7fVGmlkBy0
         cbmMH2cd+CXx1IfAVhXDIzAfdC6Bly0qlvhPjGz9/Z7OPJlwoKb4r+caO3nyiY1rX/+O
         uxElmD68Izw3Q6re8O4WukFStYIHTr18cubcNsQqyYH9KLLC7izxZRo7Q5p/PT26NfSe
         wdHmn1Siy890Y1g7YeTruo8lOH1Q/2L17OYAK4qAkV4wEv/k5XiWTN2R3cZ8f18yB3uJ
         FsWA==
X-Gm-Message-State: AOAM532EkrhudGizrE8WyQ8fHWN2PLzpoM8Eaxl89zf8rWbMb1KQiau6
        Ipa0guCYp++SuXLbMpJSO1aYI9vfzYn90HI0v5Ee8Q==
X-Google-Smtp-Source: ABdhPJzVucE3eg4ogr+EckrLlTAcmioko3LFLfBIUNJScv90rQfbKQAJbN/ec8tKzwtaa08Bv8HD0UYl2BesVajSqx8=
X-Received: by 2002:a25:bb52:: with SMTP id b18mr9308175ybk.506.1632438040561;
 Thu, 23 Sep 2021 16:00:40 -0700 (PDT)
MIME-Version: 1.0
References: <23aeacb6-0cd9-d10f-76bc-3c9d33905daa@amd.com> <ca132183-e778-4a86-c81e-4d292e9d41a7@amd.com>
 <YUzl7qywbtVHipUT@casper.infradead.org>
In-Reply-To: <YUzl7qywbtVHipUT@casper.infradead.org>
From:   Daniel Stone <daniel@fooishbar.org>
Date:   Fri, 24 Sep 2021 00:00:29 +0100
Message-ID: <CAPj87rNqCuSvSZLuF=ULCXRpbDBQC+XAA+_Awa__4dvRkckamw@mail.gmail.com>
Subject: Re: BoF at LPC: Documenting the Heterogeneous Memory Model Architecture
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Felix Kuehling <felix.kuehling@amd.com>,
        Linux MM <linux-mm@kvack.org>, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Peter Zijlstra <peterz@infradead.org>,
        "Phillips, Daniel" <Daniel.Phillips@amd.com>,
        "Sierra Guiza, Alejandro (Alex)" <Alex.Sierra@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On Thu, 23 Sept 2021 at 21:40, Matthew Wilcox <willy@infradead.org> wrote:
> On Thu, Sep 23, 2021 at 04:25:08PM -0400, Felix Kuehling wrote:
> > Change of plan: Instead of a BoF, this is now a session in the "GPU/media/AI
> > buffer management and interop MC" micro conference. Thank you Daniel Stone
> > for making that happen.
> > https://linuxplumbersconf.org/event/11/contributions/1112/
> >
> > It is scheduled for tomorrow (Friday) 08:40-10:00 Pacific, 11:40-13:00
> > Eastern, 15:40-17:00 UTC.
>
> That's up against:
>
>  Direct map management
> Vlastimil Babka, Mike Rapoport, Rick Edgecombe  11:30-12:15.
>
> Seems like a lot of the same people would want to be in both sessions.
> Maybe one could be moved?

Good point, and thanks, but it's hard to keep the longer slot whilst
moving it later; I wonder if we could move direct map management to
the final slot?

Cheers,
Daniel
