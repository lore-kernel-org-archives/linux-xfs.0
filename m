Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996AEC38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 19:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbiJYTVA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 15:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiJYTU7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 15:20:59 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17931580AE
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 12:20:58 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id x3so1309692qtj.12
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 12:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XRU4yx13ey+qiqkDAd9/g8Rgj3Vasx9oyOtn3EmTBc8=;
        b=gKZF6zvogvMldm+oQGqXDVY4bW6AIdqPdY5Yn4DwG+Xuuy83aD4dQS3reVIM3aM9gd
         z1zx725HmKJKsQaeO7fAqhzBIHjjYcXHRF5TG4M1rjQN9A/mQe2zt+Cm4FO6dfErJZw0
         3AGUFX7DSSp8CLnQalePZ98bsgMtwgsL7+Y8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XRU4yx13ey+qiqkDAd9/g8Rgj3Vasx9oyOtn3EmTBc8=;
        b=f+GdF5ENco7tI7dB/M6/Lxh7GKgdljSRCbtIsobhnH3tkY8c0zPnl1VOtf2OnZNpwo
         54N1UdUAmE3MXzq/HkG7HWi8F3g6wf7ulZ2NbVbRQatNYLMTcrzh0TWV+kjucqY0VfkT
         fE2vlUrZDxVRJXWwNxZjIN2pulsJ/09T3k5htf0qHyuI+YAUYur+ntu/RBtu8xz5LY2H
         NQ+QegPxUIFWlIuYb+4xIjvjqmSnRqtvD2IA4oHU26rdgjZYFPaRaMAiyMxigO0vmFFo
         dWBn3+07hwfW4zKwADBdR5BnsZT/in8xLuBEbWT7n6l4OXwjlzB6mDVtrTXO9HgYYz+X
         2clQ==
X-Gm-Message-State: ACrzQf3+5Gu//UrWLr/rV14eCXWk3Zhkb4N70JnDoiN0jSktpnpxXhb6
        PKbm1qo8H6+4SIAOgMyZdyL2HoxWZ32q6Q==
X-Google-Smtp-Source: AMsMyM7p1/pctUPQTs/fcWkTv6bT8mvaE7xs7vkS/olUuoJHgeyZcwy/HnbPlvHoI/hX238GdkOVVg==
X-Received: by 2002:ac8:594c:0:b0:39c:fceb:cbe8 with SMTP id 12-20020ac8594c000000b0039cfcebcbe8mr29566017qtz.483.1666725656882;
        Tue, 25 Oct 2022 12:20:56 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id w5-20020a05620a444500b006e2d087fd63sm2566792qkp.63.2022.10.25.12.20.56
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 12:20:56 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id 63so15941100ybq.4
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 12:20:56 -0700 (PDT)
X-Received: by 2002:a25:5389:0:b0:6bc:f12c:5d36 with SMTP id
 h131-20020a255389000000b006bcf12c5d36mr34937084ybb.184.1666725655766; Tue, 25
 Oct 2022 12:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <YjDj3lvlNJK/IPiU@bfoster> <YjJPu/3tYnuKK888@casper.infradead.org>
 <YjM88OwoccZOKp86@bfoster> <YjSTq4roN/LJ7Xsy@bfoster> <YjSbHp6B9a1G3tuQ@casper.infradead.org>
 <CAHk-=wh6V6TZjjnqBvktbaho_wqfjZYQ9zcKJTV8EP2Kygn0uQ@mail.gmail.com>
 <6350a5f07bae2_6be12944c@dwillia2-xfh.jf.intel.com.notmuch>
 <CAHk-=wizsHtGa=7dESxXd6VNU2mdHqhvCv88FB3xcWb3o3iJMw@mail.gmail.com>
 <6356f1f74678c_141929415@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <CAHk-=wj7mRYuictrQjT+sacgj9_GrmRetE1KLTiz-nOk-H4DPQ@mail.gmail.com> <Y1g20GUTu6mOq+CJ@casper.infradead.org>
In-Reply-To: <Y1g20GUTu6mOq+CJ@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 25 Oct 2022 12:20:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wggaWpSRkJTG0Y78ne8MVOjNCuxf73HahrRefj=MoQTsw@mail.gmail.com>
Message-ID: <CAHk-=wggaWpSRkJTG0Y78ne8MVOjNCuxf73HahrRefj=MoQTsw@mail.gmail.com>
Subject: Re: writeback completion soft lockup BUG in folio_wake_bit()
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Brian Foster <bfoster@redhat.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        jesus.a.arechiga.lopez@intel.com, tim.c.chen@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 25, 2022 at 12:19 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> I've been carrying a pair of patches in my tree to rip out the wait
> bookmarks since March, waiting for me to write a userspace testcase to
> reproduce the problem against v4.13 and then check it no longer does so
> against v5.0.  Unfortunately, that hasn't happened.  I'm happy to add
> Arechiga's Tested-by, and submit them to Andrew and have him bring them
> into v6.2, since this doesn't seem urgent?

Ack, sounds good to me.

                  Linus
