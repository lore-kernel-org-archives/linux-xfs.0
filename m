Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF11C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 23:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347439AbiCPXgs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 19:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237131AbiCPXgs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 19:36:48 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11332167DB
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 16:35:33 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id w27so6299595lfa.5
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 16:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PUaRSZQS7aa+6y7Z0BXGANEI06keATxi49n2iARU7lI=;
        b=EKlOY+SlMv2j0eOUgqh3ARh4ND5wmiDDKtt3IIZB2Urcq6zLbFbsExxmvs2pRJIagQ
         T5/iBkJNAo7L4u6lyqVYxRKKUd2SrngFuYxld5zAO6g+XJE/gHRb031PUrlSDxugt6g6
         sXnTQP1qpiqJLmqZ1f6IVSLVb2p4BjMoqTklk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PUaRSZQS7aa+6y7Z0BXGANEI06keATxi49n2iARU7lI=;
        b=x3+x4PS0VkQg2k4PZGKGKPDFfWZ8ZIExXicGcRtidyEaIpsHarD6um27/m1WxrWEma
         kzh4u4VG74U1KnWTywfFQCOentMbb1Ww1Q2Ue1DJ1EfoxzZlXa75XsVyxcWHZMnPLr12
         47pIkC2j/RMce4UVGiuCtTDCbOBvnHIc/4oAjYHQZw+pxEk72b75qr8RjvWqyVQxZBuC
         rpFyx6oC2T0m54YJJI1musRtDXgjvT7OB5+r0YjnoHMxRzTPteOE30PXve7VkryTrEML
         cc04LEHWdSh2lWDaX6efyNPvm2b3cmPtExtu6DFfv2580LQIhzYJ6MzPmWurClC9sdTu
         HI8w==
X-Gm-Message-State: AOAM531UAtuBO7Q6dtCavow1Xn9LCmXnuEUNMPo3EhXK8jRiP2zQNQvJ
        giYx470WyXcr5zRRBlZFA+HU9twiwFm46PugqAg=
X-Google-Smtp-Source: ABdhPJzsb1qjzdkge88BEFSS/r5J80zh/jXzy9UMvkr3M2+xK8P1qpYpRmczKkCnQ0EQ+BAj4HA6Xg==
X-Received: by 2002:a05:6512:556:b0:448:b9de:8ad with SMTP id h22-20020a056512055600b00448b9de08admr1180359lfl.9.1647473729578;
        Wed, 16 Mar 2022 16:35:29 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id o1-20020a2e7301000000b002461808ad8bsm272190ljc.102.2022.03.16.16.35.26
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 16:35:28 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id w12so6273484lfr.9
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 16:35:26 -0700 (PDT)
X-Received: by 2002:ac2:4203:0:b0:448:8053:d402 with SMTP id
 y3-20020ac24203000000b004488053d402mr1106390lfh.687.1647473726276; Wed, 16
 Mar 2022 16:35:26 -0700 (PDT)
MIME-Version: 1.0
References: <YjDj3lvlNJK/IPiU@bfoster> <YjJPu/3tYnuKK888@casper.infradead.org>
In-Reply-To: <YjJPu/3tYnuKK888@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 16 Mar 2022 16:35:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgPTWoXCa=JembExs8Y7fw7YUi9XR0zn1xaxWLSXBN_vg@mail.gmail.com>
Message-ID: <CAHk-=wgPTWoXCa=JembExs8Y7fw7YUi9XR0zn1xaxWLSXBN_vg@mail.gmail.com>
Subject: Re: writeback completion soft lockup BUG in folio_wake_bit()
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 1:59 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> As I recall, the bookmark hack was introduced in order to handle
> lock_page() problems.  It wasn't really supposed to handle writeback,
> but nobody thought it would cause any harm (and indeed, it didn't at the
> time).  So how about we only use bookmarks for lock_page(), since
> lock_page() usually doesn't have the multiple-waker semantics that
> writeback has?

I was hoping that some of the page lock problems are gone and we could
maybe try to get rid of the bookmarks entirely.

But the page lock issues only ever showed up on some private
proprietary load and machine, so we never really got confirmation that
they are fixed. There were lots of strong signs to them being related
to the migration page locking, and it may be that the bookmark code is
only hurting these days.

See for example commit 9a1ea439b16b ("mm:
put_and_wait_on_page_locked() while page is migrated") which doesn't
actually change the *locking* side, but drops the page reference when
waiting for the locked page to be unlocked, which in turn removes a
"loop and try again when migration". And that may have been the real
_fix_ for the problem.

Because while the bookmark thing avoids the NMI lockup detector firing
due to excessive hold times, the bookmarking also _causes_ that "we
now will see the same page multiple times because we dropped the lock
and somebody re-added it at the end of the queue" issue. Which seems
to be the problem here.

Ugh. I wish we had some way to test "could we just remove the bookmark
code entirely again".

Of course, the PG_lock case also works fairly hard to not actually
remove and re-add the lock waiter to the queue, but having an actual
"wait for and get the lock" operation. The writeback bit isn't done
that way.

I do hate how we had to make folio_wait_writeback{_killable}() use
"while" rather than an "if". It *almost* works with just a "wait for
current writeback", but not quite. See commit c2407cf7d22d ("mm: make
wait_on_page_writeback() wait for multiple pending writebacks") for
why we have to loop. Ugly, ugly.

Because I do think that "while" in the writeback waiting is a problem.
Maybe _the_ problem.

                        Linus
