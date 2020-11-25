Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78447C56202
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 22:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 059992075A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 22:09:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K6cXzXGO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731877AbgKYWJT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 17:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731719AbgKYWJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 17:09:19 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8E7C0613D4
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 14:09:18 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id s27so5285117lfp.5
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 14:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AHzxZjopdvwPb49v26gZFbNssQM0UPZ06yGo+z/tU6c=;
        b=K6cXzXGOWYp0YH8Ec/Cd6PHGW9EpUSbmb9ZLhiSPBPTgyeTuwWtAay+X+GE1FcohAq
         hcJeoMobg7GDcznqwyVEvp6b40v9HTHCqQ0yBJT4GDTt9n9UsIf+QJAhwPLCQk+aWHsg
         V4KTpIAvGlGRiVee5Cm69yvIVM2IWQyahDf98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AHzxZjopdvwPb49v26gZFbNssQM0UPZ06yGo+z/tU6c=;
        b=aWKcMpn+YrmwmI/xeVzgp0VjR82NSJziR/wzM1q4ohCA3J0PDCwF/FEvECEaFx0pnx
         biFMRAw9LQCTxbcnRTtUcbgvVGIqIllc/7yRPDRtWDn250j3gMUtrDWY6vRE/e3O+CBJ
         IbnbnUIBjXJ1tzFLvyJGODXKHeQP0+zmQpRrgmCOVvWY4kQ2BXPHaYPeWDrqYnRBlZmI
         ndg7ZlPEhgW7lwXU00ue1jRYQXB6fkWyB6+C379F/afxuB0Qy+WN768A4Lti5geX4lMd
         hN7rRCeIXzWJoLwq7awrqfkf91KolMS5zIJppvS40c2Fd7lio3XluQghP9r4qZw4wMIa
         S1Bg==
X-Gm-Message-State: AOAM530Ui7WNtxQ7TPo+/rYJ9vlZsaFXwiGlTHKkXT+saaobhGY7bIA0
        tmszJ0qoXVZv/szWnOZDgpviw97Il5SZbQ==
X-Google-Smtp-Source: ABdhPJz275+cxOJUqML6ZlcLKi+lZsAKsHhg7dS3ncf5cHVJYfzP87+9jvbDMfcCo9B83aAwvA06lQ==
X-Received: by 2002:ac2:5484:: with SMTP id t4mr99858lfk.600.1606342156834;
        Wed, 25 Nov 2020 14:09:16 -0800 (PST)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id z7sm387528ljm.126.2020.11.25.14.09.16
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 14:09:16 -0800 (PST)
Received: by mail-lj1-f181.google.com with SMTP id f18so65785ljg.9
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 14:09:16 -0800 (PST)
X-Received: by 2002:a19:ed0f:: with SMTP id y15mr92782lfy.352.1606341679142;
 Wed, 25 Nov 2020 14:01:19 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3a33205add2f7b2@google.com> <20200828100755.GG7072@quack2.suse.cz>
 <20200831100340.GA26519@quack2.suse.cz> <CAHk-=wivRS_1uy326sLqKuwerbL0APyKYKwa+vWVGsQg8sxhLw@mail.gmail.com>
 <alpine.LSU.2.11.2011231928140.4305@eggly.anvils> <20201124121912.GZ4327@casper.infradead.org>
 <alpine.LSU.2.11.2011240810470.1029@eggly.anvils> <20201124183351.GD4327@casper.infradead.org>
 <CAHk-=wjtGAUP5fydxR8iWbzB65p2XvM0BrHE=PkPLQcJ=kq_8A@mail.gmail.com>
 <20201124201552.GE4327@casper.infradead.org> <CAHk-=wj9n5y7pu=SVVGwd5-FbjMGS6uoFU4RpzVLbuOfwBifUA@mail.gmail.com>
 <alpine.LSU.2.11.2011241322540.1777@eggly.anvils> <CAHk-=wjiVtroOvNkuptH0GofVUvOMw4wmmaXdnGPPT8y8+MbyQ@mail.gmail.com>
 <CAHk-=wix0YNq1U8iroRLpx+fCUGE8RG3asY8Zm4vyH-g4UhbPg@mail.gmail.com>
In-Reply-To: <CAHk-=wix0YNq1U8iroRLpx+fCUGE8RG3asY8Zm4vyH-g4UhbPg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 25 Nov 2020 14:01:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiavm+uTti1SmuwvBQyu-0OC_6c3Y1v7kpunmPnjVRsSQ@mail.gmail.com>
Message-ID: <CAHk-=wiavm+uTti1SmuwvBQyu-0OC_6c3Y1v7kpunmPnjVRsSQ@mail.gmail.com>
Subject: Re: kernel BUG at fs/ext4/inode.c:LINE!
To:     Hugh Dickins <hughd@google.com>
Cc:     Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        syzbot <syzbot+3622cea378100f45d59f@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Linux-MM <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Nicholas Piggin <npiggin@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>, Qian Cai <cai@lca.pw>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        William Kucharski <william.kucharski@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 25, 2020 at 1:30 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm not sure I'm willing to write and test the real patch, but it
> doesn't look _too_ nasty from just looking at the code. The bookmark
> thing makes it important to only actually clear the bit at the end (as
> does the handoff case anyway), but the way wake_up_page_bit() is
> written, that's actually very straightforward - just after the
> while-loop. That's when we've woken up everybody.

Actually, there's a problem. We don't know if we've done the hand-off
or not, so we don't know if we should clear the bit after waking
everybody up or not.

We set that WQ_FLAG_DONE bit for the hand-0off case, but only the
woken party sees that - the waker itself doesn't know about it (and we
have no good way to return it in that call chain: wake_up_page_bit ->
__wake_up_locked_key_bookmark -> __wake_up_common ->
wake_page_function().

We could easily hide the flag in the "bookmark" wait queue entry, but
that smells a bit hacky to me.

So I don't think it's worth it, unless somebody really wants to give it a try.

But if it turns out that the page ref change from Hugh causes some
unexpected problem, we do have this model as a backup.

            Linus
