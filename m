Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2F5C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 03:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC0242084C
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 03:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sw1RU+mJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgIWDNj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 23:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbgIWDNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 23:13:39 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107B5C061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 20:13:39 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gx22so16647447ejb.5
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 20:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JwvdgsXB402hrloVnojHYKMALos0UtGM6T39CX6f/Zc=;
        b=sw1RU+mJlhlQSThPiUtxpANH9pNW0bRSJVXQbT/dpjWQgWAPzne5pbfDLW57xPp9NF
         f7ARw+Ywc+AFCj/FB5yT8IAhle9XISP/36T1X4ThfPcZeQN84IJqUd17zgZgYSZmp/9i
         EE0LSRKmF0IosW6/916aoJgZ0Fh7XOnsZt/e7eBE7z94a7lo+22EVuZ6rzDoazpWjWGZ
         8KAWAMvCi01hv6vvPxK4u/cl+Io71vsuNAzJY0cdla0sIHA7tL46FMrgPydDfjJu2QPO
         W8qNuH1lQiMNk9F2N7Szy3iMpPU9nqpKTrvL1QFqjutBmWefAWIOt2P5bAd7DzWZUJ0h
         hivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JwvdgsXB402hrloVnojHYKMALos0UtGM6T39CX6f/Zc=;
        b=c0yHVvr3wvVOUtuuw5seRI6hdf4CYPUqERnSxD6JU7D/u29TdNtBPEJ5RBkZwJ6jfx
         8wcSXcz5o0lmqo2hkLXjf0W/6fz8M3a3PqiPHoi0b7+WGrqihn+jmNFP/5V/vfQn2PLi
         T/Vp+diPoPtEzM1d+QkEuowrEbGKUbpveK8zpr5pwvzyrVz3Kv7NRFGaN5FXddXW64Li
         vSlL3CS7m+sSmeEMn/Ucid5U/7Hpb7mC3AEB7TB9u1eeXaP/gi5DkLCj+nA3OcfSYVsT
         H+El4FC22iQRR/9EXTKisLAcWoIBV2fouDczOR8aXuo8ZRNrd6ug84ZpvrK03rwt5oc5
         76GQ==
X-Gm-Message-State: AOAM532F1KCn1qYyANQ4VXb3kNSHa2vUBzPRKH6IUP3VDm2SudCCCk3R
        yTfrk4HvCz2aduGKAJPXtB6xpjNL51QYDcFBQd4=
X-Google-Smtp-Source: ABdhPJy7LYxrjMz7sfeTel1Vf4avoRdpyqgkfZyRKxiUY2X7u+GqKRsTOQUKGksWwt+uIX4z6bJAIv6XX18OdMm5lTI=
X-Received: by 2002:a17:906:82c1:: with SMTP id a1mr8060907ejy.270.1600830817761;
 Tue, 22 Sep 2020 20:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <CADQqeeS9SWv_R5XNsNRq=pLiP-9r56-YyhCw7JP32-aR=jsK+w@mail.gmail.com>
 <20200921162404.GC7955@magnolia>
In-Reply-To: <20200921162404.GC7955@magnolia>
From:   Zheng Wu <zhengwu0330@gmail.com>
Date:   Wed, 23 Sep 2020 11:13:26 +0800
Message-ID: <CADQqeeRWXf_paFL+pzoiOsd_Vu_0NyYFxBvKZKdx1xHKo=av+A@mail.gmail.com>
Subject: Re: The feature of Block size > PAGE_SIZE support
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Okay, thanks.

Best Regards
Zheng Wu

On Tue, Sep 22, 2020 at 12:24 AM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> On Mon, Sep 21, 2020 at 11:12:54AM +0800, Zheng Wu wrote:
> > Hi experts,
> >
> > We know that the feature of Block size > PAGE_SIZE will be supported in XFS.
> > Just, I can't test successfully in the last version of Linux.
> >
> > When is this feature of  Block size > PAGE_SIZE available in upstream?
>
> It's not currently in upstream.  Some day, perhaps, after THP support
> gets added to iomap.
>
> --D
>
> > Thanks.
> >
> > Best Regards
> > Zheng Wu
