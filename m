Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7B7C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 19:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237812AbiCQT2O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 15:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237577AbiCQT2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 15:28:13 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B8C21794B
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 12:26:55 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id s25so10655141lfs.10
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 12:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kld44BtN3rNiFeHs8eqamOSFXSi6G0Opd+8/ljmh7IE=;
        b=aKUrlosQ/9HfOXQQwNdHeJfbdj6COyNpFJt+90/nk3eG+hm/7ahcfqx8JRd6Enx5Zd
         qbllDAtGaAxjsCoL0umx6EmEc9sKvG1fp+yQBmtND7UETKMwdzRSahFjsF1ERXx++3Qt
         87+Ue7rFm3KGaX8La/yPJQpzPxff/HSYVrV20=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kld44BtN3rNiFeHs8eqamOSFXSi6G0Opd+8/ljmh7IE=;
        b=mSR3IBIllK6LCiokZMmJrwopGCdRIhBNi91yZVATWPgvB8Uu1RbyYwLB3aNSHO1yjw
         6JCLHzVOFCczjWjVLnwubD0uGWf0BMBrj+2906aS4mVlrmo3sc5m1CAs4kR6HagSF5+H
         sOAN2IKnLzEJ6n7w9SZaNx9DZNjksNxdiiWy/TpVEmI++o1tE4pZFQIfOZMgr3b0Ywdq
         rLMI8u2fyEgK8n/ALSgu0w77UUa1N6MEUCkZN6t+qsqjNH08MSOsrguJW1Lll7yf2UQX
         JXqj5Z4ADxg8i0HiP3jzmXnr+yocDyOzttGPn4cNANI2P1vKqAO/OY3RSiaoDG35swxB
         L9kA==
X-Gm-Message-State: AOAM532AI/FRiplBCGdSjQ5Xsx2K5vTBkdtSNDzMqrXagwV+Xdq2TjE+
        jG8yM5qlJSS9bw+XWodmiWOd11t2TEMWAksEot8=
X-Google-Smtp-Source: ABdhPJx9421jUkWuDJh4rPxjOYjPR6zKALFYgpBUZNV6KvsTNsUCF63U1goF4W/Yy4vM/fHYnnddWQ==
X-Received: by 2002:a05:6512:1193:b0:448:96df:f2a4 with SMTP id g19-20020a056512119300b0044896dff2a4mr3751144lfr.479.1647545213562;
        Thu, 17 Mar 2022 12:26:53 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id z17-20020ac24191000000b004483a4d9a3esm512958lfh.152.2022.03.17.12.26.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 12:26:52 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id w7so10687504lfd.6
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 12:26:51 -0700 (PDT)
X-Received: by 2002:ac2:4f92:0:b0:448:7eab:c004 with SMTP id
 z18-20020ac24f92000000b004487eabc004mr3766610lfs.27.1647545211431; Thu, 17
 Mar 2022 12:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <YjDj3lvlNJK/IPiU@bfoster> <YjJPu/3tYnuKK888@casper.infradead.org>
 <CAHk-=wgPTWoXCa=JembExs8Y7fw7YUi9XR0zn1xaxWLSXBN_vg@mail.gmail.com> <YjNN5SzHELGig+U4@casper.infradead.org>
In-Reply-To: <YjNN5SzHELGig+U4@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 17 Mar 2022 12:26:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiZvOpaP0DVyqOnspFqpXRaT6q53=gnA2psxnf5dbt7bw@mail.gmail.com>
Message-ID: <CAHk-=wiZvOpaP0DVyqOnspFqpXRaT6q53=gnA2psxnf5dbt7bw@mail.gmail.com>
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

On Thu, Mar 17, 2022 at 8:04 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> So how about we do something like this:
>
>  - Make folio_start_writeback() and set_page_writeback() return void,
>    fixing up AFS and NFS.
>  - Add a folio_wait_start_writeback() to use in the VFS
>  - Remove the calls to set_page_writeback() in the filesystems

That sounds lovely, but it does worry me a bit. Not just the odd
'keepwrite' thing, but also the whole ordering between the folio bit
and the tagging bits. Does the ordering possibly matter?

That whole "xyz_writeback_keepwrite()" thing seems odd. It's used in
only one place (the folio version isn't used at all):

  ext4_writepage():

     ext4_walk_page_buffers() fails:
                redirty_page_for_writepage(wbc, page);
                keep_towrite = true;
      ext4_bio_write_page().

which just looks odd. Why does it even try to continue to do the
writepage when the page buffer thing has failed?

In the regular write path (ie ext4_write_begin()), a
ext4_walk_page_buffers() failure is fatal or causes a retry). Why is
ext4_writepage() any different? Particularly since it wants to keep
the page dirty, then trying to do the writeback just seems wrong.

So this code is all a bit odd, I suspect there are decades of "people
continued to do what they historically did" changes, and it is all
worrisome.

Your cleanup sounds like the right thing, but I also think that
getting rid of that 'keepwrite' thing would also be the right thing.
And it all worries me.

            Linus
