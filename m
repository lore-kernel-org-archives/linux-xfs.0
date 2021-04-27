Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB08C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 19:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A468613F5
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 19:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238844AbhD0TlP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 15:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238804AbhD0TlM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 15:41:12 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6407C061574
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 12:40:27 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id j10so2299502lfb.12
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 12:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d1qy5wxeRoVOmQDNZKC3zuT1I7B8Wmbsg1PWKuM1gGo=;
        b=KQMj4gOjxXdq3F3sCekOUpnM5wUKPyax2VsvJVD3UzXPCmwhInGgQ3fsNWZv9jhWkS
         qBZ/uIkzoLhC494xEh1cVAGnDJC5c8kGoJZeHTrYfBs91mJHMHPmbcTgI3U2IIDIAWEt
         WCscorxAa8dU8ukT54NW+qyPhOwFaTMq+lo1M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d1qy5wxeRoVOmQDNZKC3zuT1I7B8Wmbsg1PWKuM1gGo=;
        b=gG7hKIHqL4oSpeP42vxjV7R8ci3aQLjl4iAzb19LKLcKGkOVUW7yfmu0y3qWL/3vuL
         DCyqo5KJTzppKghs2TEkaRdUMGZxadM14RJVsR7MXAAkRdw+WJgPVlDEEa3AGO51Ph07
         ZHSfdSF3sJf87EpcVEm+amnDoCitZ3KMcjHVhLqYVNcAtE25t3nK49rTMhm7a03srANL
         jFzugJYinNuyIoobOT4LuwTrNzocP3lT3yiFhvbwUR+DhxN/S7ebEu7soLGvkFcjraVs
         gIarXz3E0eYSgRj0FPxY6i7GakeC1V1uXxTfuC4MwgoyoStykaQoLhS/tuqfP8d0SNlS
         mW+Q==
X-Gm-Message-State: AOAM530z003tcVipqwmZqo+BjV5df5ygIH7mZGG5ni4IMytLja2Ntnv1
        UR24OhUlIsbEbsNmkkMbH1FJ/jsuIiaqmd6h
X-Google-Smtp-Source: ABdhPJwkJOscGqYS435iIHHXr9n4KDQLRjIodEg2Qu94dM6rAdl49Br5S1CWusHI+mQKNyZR4u47nA==
X-Received: by 2002:a19:7dc1:: with SMTP id y184mr17540893lfc.96.1619552426210;
        Tue, 27 Apr 2021 12:40:26 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id q14sm173768lfc.143.2021.04.27.12.40.25
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 12:40:25 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id d27so38634711lfv.9
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 12:40:25 -0700 (PDT)
X-Received: by 2002:a05:6512:a90:: with SMTP id m16mr17323063lfu.201.1619552425277;
 Tue, 27 Apr 2021 12:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210427025805.GD3122264@magnolia>
In-Reply-To: <20210427025805.GD3122264@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 27 Apr 2021 12:40:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj6XUGJCgsr+hx3rz=4KvBP-kspn3dqG5v-cKMzzMktUw@mail.gmail.com>
Message-ID: <CAHk-=wj6XUGJCgsr+hx3rz=4KvBP-kspn3dqG5v-cKMzzMktUw@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: new code for 5.13-rc1
To:     "Darrick J. Wong" <djwong@kernel.org>, Jia He <justin.he@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 26, 2021 at 7:58 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Please pull this single patch to the iomap code for 5.13-rc1, which
> augments what gets logged when someone tries to swapon an unacceptable
> swap file.  (Yes, this is a continuation of the swapfile drama from last
> season...)

Hmm. I've pulled this, but that "iomap_swapfile_fail()" thing seems a
bit silly to me.

We have '%pD' for printing a filename. It may not be perfect (by
default it only prints one component, you can do "%pD4" to show up to
four components), but it should "JustWork(tm)".

And if it doesn't, we should fix it.

So instead of having a kmalloc/kfree for the path buffer, I think you
should have been able to just do

    pr_err("swapon: file %pD4 %s\n", isi->file, str);

and be done with it.

And no, we don't have a ton of %pD users, so if it's ugly or buggy
when the file is NULL, or has problems with more (of fewer) than four
path components, let's just fix that (added Jia He and Al Viro to
participants, they've been the two people doing %pd and %pD - for
'struct dentry *' and 'struct file *' respectively).

                Linus
