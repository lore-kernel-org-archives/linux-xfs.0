Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAB4C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 18:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiFLSpS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 14:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234221AbiFLSoY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 14:44:24 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FDB5C84D
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 11:44:23 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id n203so1744235vke.7
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 11:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QCktWd+n5KgBQynLnBWE6RqZZ6FNqdKAToR40bXnybk=;
        b=rE4ZKOj9G5jD2nQ2CRonznQYOzu8A5GJ78TYm6TMyjo/YSz1Ke2AwnEVVmeUxKnSOs
         VU/PnveGAuCXod1sYTPGF4SYY8Kayhou1MRw9NRbhAp0Vs8rJ40+iNxr80I3A/bPOSSB
         XoFDipXokhUzLcWqJF7Zu8Uwr9IsUndy2MMK73MNeo15l2oLqBbu+vxpxNojHhWOTb8Z
         3ZZ38lETVABRQispRTHE7nDOwCPrm7B0YGH0RBwW3xdOdgnfhWn91GJMKXDPxvEMusZa
         CghG+0ks70Y5Xz1TD3ibb9iy2EdpA9EEKYosomjlT7bknvtajQYIP5zCK183nPtzrdiS
         jC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QCktWd+n5KgBQynLnBWE6RqZZ6FNqdKAToR40bXnybk=;
        b=TMNdeXt+rMvESogY7ROurMtEhhGdDri/MSc0W8EwcNbn7yLdGK9FjCUUj1gIq9Rn0+
         SNQgtU9XMCIkpxA0SeJ51ijgmz6IJxubSct4WbakyUTms7EU6Y0Jkq/Jck+PWCkzo9lA
         eencjWTnESE+Km425EoYdh8C7L1zS6IRZvRg7seQ5ib8G7F7SCYF3q1ZV8GdQOuOMOuh
         /YhGhJXYayJ5S2sEiKOe1JLFwLhZur0vc4PZ/8C8BKNb56Sw3aZERgc6BTYOWJPVSxtD
         GMYcsgVu9CnVolCkFuUZ9pSWCaw92ybP8pH3XBBeeQTYQ7JtA3ZlVOeZNDv4/TYRG1oS
         IFEg==
X-Gm-Message-State: AOAM532WOdDct+2DcT5xMmAU+ATSZH34T2gVAXM7xvR1nIbi47cug92+
        xIDEa1AuZxxDzKcPuQl0BAiF9xDDemX/zc4JVDsU4w==
X-Google-Smtp-Source: ABdhPJzZ/47s2snJvZ7uwTxgvT6BhXeoHrhBRaplai/C7kYtFaFHZUC6p8rFmt5CyUlbVZ4GknNgi/R9kqTEL6R3Zxk=
X-Received: by 2002:a1f:a504:0:b0:35e:4fd4:d3bf with SMTP id
 o4-20020a1fa504000000b0035e4fd4d3bfmr12696376vke.7.1655059462057; Sun, 12 Jun
 2022 11:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <bug-216073-27@https.bugzilla.kernel.org/> <20220606151312.6a9d098c85ed060d36519600@linux-foundation.org>
 <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220608021922.n2izu7n4yoadknkx@zlang-mailbox> <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220612044230.murerhsa765akogj@zlang-mailbox> <YqXU+oU7wayOcmCe@casper.infradead.org>
 <YqXkGMY9xtUvPR5D@pc638.lan> <YqYh0xyJvoNsSOpy@casper.infradead.org>
 <CAOUHufbBkcjChkMfF8exh3=6=JM09-GCU71KXhUGmz4UdOhUmg@mail.gmail.com> <YqYq846zFUInllTw@casper.infradead.org>
In-Reply-To: <YqYq846zFUInllTw@casper.infradead.org>
From:   Yu Zhao <yuzhao@google.com>
Date:   Sun, 12 Jun 2022 12:43:45 -0600
Message-ID: <CAOUHufan8+uombVMSSrKra-8Cu5pSJj80LVa6QrGbFzBmUQHxg@mail.gmail.com>
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n o area'
 (offset 0, size 1)!
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Uladzislau Rezki <urezki@gmail.com>, Zorro Lang <zlang@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 12, 2022 at 12:05 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sun, Jun 12, 2022 at 11:59:58AM -0600, Yu Zhao wrote:
> > Please let me know if there is something we want to test -- I can
> > reproduce the problem reliably:
> >
> > ------------[ cut here ]------------
> > kernel BUG at mm/usercopy.c:101!
>
> The line right before cut here would have been nice ;-)

Right.

$ grep usercopy:
usercopy: Kernel memory exposure attempt detected from vmalloc (offset
2882303761517129920, size 11)!
usercopy: Kernel memory exposure attempt detected from vmalloc (offset
8574853690513436864, size 11)!
usercopy: Kernel memory exposure attempt detected from vmalloc (offset
7998392938210013376, size 11)!
...

> https://lore.kernel.org/linux-mm/YqXU+oU7wayOcmCe@casper.infradead.org/
>
> might fix your problem, but I can't be sure without that line.

Thanks, it worked!
