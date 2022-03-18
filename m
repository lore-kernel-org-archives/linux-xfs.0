Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CE3C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 18:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240262AbiCRS55 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 14:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240043AbiCRS5r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 14:57:47 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00322217C44
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 11:56:27 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id m3so3519399lfj.11
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 11:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x0WpCPeJF/glvoQcLTwJKAKI6FncEVSy4Y2K6xPy2Y8=;
        b=f7MfvhR/cTZArrnZxlIv8GZbrzzOnswona1V4BXmQPljdWKur1uZmgcfw5Gov3BZTV
         +8oIobQjsXBFlocU280eAc/KMDRwR0QsHriW+A424ELUu54U5AF1TX4DGsG3wfztxp2c
         uc7bAxqjmBZAmgiEe/ZSRGk4oCxcgeO2gFlNQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x0WpCPeJF/glvoQcLTwJKAKI6FncEVSy4Y2K6xPy2Y8=;
        b=MtH14X9qo3H2Nb+//f5b8Oh5/TbW8DcaiSs6aEEZnA7OV3w1K+rPjqxQAa7akl3Oip
         NN1QodHJ8C/3XhD464qjh3MMfjnCmPNFpS1GABI4KIToqw6seZrukK6lEymURSg8XHYR
         qv4fHHoXbSu04NyEhQt4eDIa2N8sWEEYTfn6pgJ3rgz7eVBjzcajMtDb30irn+XlFGCR
         QALUJDVMK+6DH15eMEm59QFDpHRF6BAzJsRWpVEq6k87F3dBOz80GXrlr7RUuYMx//e/
         Alf+/tCLSzfaBrMcV8aLGQpmvMjH4timhQhUebS6KcH1t0byTN461eJQJToMUGQx6d3D
         bm9w==
X-Gm-Message-State: AOAM532iIbew7hxxWkPHBarKPbRaUs5Q2Wffq6WV6kEY+1b9+4/pqY5Y
        MkUGoKiCUd7ghc6nKEFe0Fw7IIDqRPSqo2HISZk=
X-Google-Smtp-Source: ABdhPJyuUgGo1pHTfN/8v9+6ZPQNtAp5YOhVl0l035PccZ6fNv5USKWgrxpSP7eFNvBYW0NZuZG0xA==
X-Received: by 2002:a05:6512:230d:b0:449:fa1f:cced with SMTP id o13-20020a056512230d00b00449fa1fccedmr5466993lfu.582.1647629784556;
        Fri, 18 Mar 2022 11:56:24 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id l4-20020a2e8344000000b00247e3be2e3csm1119821ljh.123.2022.03.18.11.56.21
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 11:56:22 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id w12so15474322lfr.9
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 11:56:21 -0700 (PDT)
X-Received: by 2002:a05:6512:2037:b0:448:92de:21de with SMTP id
 s23-20020a056512203700b0044892de21demr6661516lfs.52.1647629780934; Fri, 18
 Mar 2022 11:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <YjDj3lvlNJK/IPiU@bfoster> <YjJPu/3tYnuKK888@casper.infradead.org>
 <CAHk-=wgPTWoXCa=JembExs8Y7fw7YUi9XR0zn1xaxWLSXBN_vg@mail.gmail.com>
 <YjNN5SzHELGig+U4@casper.infradead.org> <CAHk-=wiZvOpaP0DVyqOnspFqpXRaT6q53=gnA2psxnf5dbt7bw@mail.gmail.com>
 <YjOlJL7xwktKoLFN@casper.infradead.org> <20220318131600.iv7ct2m4o52plkhl@quack3.lan>
In-Reply-To: <20220318131600.iv7ct2m4o52plkhl@quack3.lan>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 18 Mar 2022 11:56:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiky+cT7xF_2S94ToEjm=XNX73CsFHaQJH3tzYQ+Vb1mw@mail.gmail.com>
Message-ID: <CAHk-=wiky+cT7xF_2S94ToEjm=XNX73CsFHaQJH3tzYQ+Vb1mw@mail.gmail.com>
Subject: Re: writeback completion soft lockup BUG in folio_wake_bit()
To:     Jan Kara <jack@suse.cz>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 18, 2022 at 6:16 AM Jan Kara <jack@suse.cz> wrote:
>
> I agree with Dave that 'keep_towrite' thing is kind of self-inflicted
> damage on the ext4 side (we need to write out some blocks underlying the
> page but cannot write all from the transaction commit code, so we need to
> keep xarray tags intact so that data integrity sync cannot miss the page).
> Also it is no longer needed in the current default ext4 setup. But if you
> have blocksize < pagesize and mount the fs with 'dioreadlock,data=ordered'
> mount options, the hack is still needed AFAIK and we don't have a
> reasonable way around it.

I assume you meant 'dioread_lock'.

Which seems to be the default (even if 'data=ordered' is not).

Anyway - if it's not a problem for any current default setting, maybe
the solution is to warn about this case and turn it off?

IOW, we could simply warn about "data=ordered is no longer supported"
and turn it into data=journal.

Obviously *only* do this for the case of "blocksize < PAGE_SIZE".

If this ext4 thing is (a) obsolete and (b) causes VFS-level problems
that nobody else has, I really think we'd be much better off disabling
it than trying to work with it.

                 Linus
