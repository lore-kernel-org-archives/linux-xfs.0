Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA064C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DCA860EC0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhHBWcE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 18:32:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231920AbhHBWcD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 18:32:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627943513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4EVhT6i3eXXJjz3ahLl3R5UmsaRKu+vDRCucrxfPbqs=;
        b=g+h9mZQYkhEdz2dCkF2WuvNswyV5l8GeIPgllm6d/pZKzjGSP7p6QLW9xQQ//uqzM3FQwx
        IK2hxRVvi5raz9jEZLkaWSyD2m3xWNel9SKDmSFEsnlc2Btz8yLBpFp9zjK5NQFfBs0D+X
        3QSObk3kK2N9y5Vpaq0sDtvdDT27m2k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259--PIR41ZrNfCnpXreWbOy3g-1; Mon, 02 Aug 2021 18:31:51 -0400
X-MC-Unique: -PIR41ZrNfCnpXreWbOy3g-1
Received: by mail-wm1-f72.google.com with SMTP id k13-20020a05600c1c8db029025018ac4f7dso292376wms.2
        for <linux-xfs@vger.kernel.org>; Mon, 02 Aug 2021 15:31:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4EVhT6i3eXXJjz3ahLl3R5UmsaRKu+vDRCucrxfPbqs=;
        b=fiT3RTVltIa0yl7cLxGTuKAe5R3EBvOnl4MEXiiC6C5VZ+UWFmykjBFnYBGGHia/II
         PTQI+P+a0wBOSzUpcJAjQEnJ0DlA/3LWU2Yp6fchMNdjbKGR6Fw1AFXdh5e52XEkODCs
         FkUsVk8y7UD5tYdFJNC1vqj+1mS1XX8sXo1XQ3EReEDypQ/G+uI46jwC+xK9hHkeXqDX
         T1IYItG/svMVMfNOdx4i3YT2pr2D85i/6mzW4CN8keLOTbcx5G/Q9LSouZhJmyj2uzAD
         BZt4HTIa8jsMe+Kgly1X20o0qRz19p3PPZe+S6AO5JeBLVI+QtvQxL4oThjNNnARSGK5
         +34A==
X-Gm-Message-State: AOAM533y6S2E1FAB9m7rJ9rmrihrPA1FTMr3GgIsftrIXHlNJjAhTsgR
        O11jKM/aajtEOE18V443ZkiT31AmYK1GJyRBEM+7ktvSEp3Opc922l1BJhkyBYhImk6ZzJrCaaj
        q8lNLv5U6G1G1HejEx05MJJN7R4IQjchX0sv7
X-Received: by 2002:adf:dd07:: with SMTP id a7mr19254657wrm.377.1627943510794;
        Mon, 02 Aug 2021 15:31:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUHr36B5P/mt6E/dLhCWXX9iYzqcwuvGX7I402J27W+nWBdib/Y2RF3iSckApfuxD0i+HWk/ODRlxb6VjoIok=
X-Received: by 2002:adf:dd07:: with SMTP id a7mr19254644wrm.377.1627943510642;
 Mon, 02 Aug 2021 15:31:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210802221114.GG3601466@magnolia>
In-Reply-To: <20210802221114.GG3601466@magnolia>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 3 Aug 2021 00:31:39 +0200
Message-ID: <CAHc6FU5YAs-8HZAVeP-ZWRmvZ3mXDs37SgWXXOJC+uS=6hTVgw@mail.gmail.com>
Subject: Re: iomap 5.15 branch construction ...
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 3, 2021 at 12:11 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Hi everyone!
>
> iomap has become very popular for this cycle, with seemingly a lot of
> overlapping patches and whatnot.  Does this accurately reflect all the
> stuff that people are trying to send for 5.15?
>
> 1. So far, I think these v2 patches from Christoph are ready to go:
>
>         iomap: simplify iomap_readpage_actor
>         iomap: simplify iomap_add_to_ioend
>
> 2. This is the v9 "iomap: Support file tail packing" patch from Gao,
> with a rather heavily edited commit:
>
>         iomap: support reading inline data from non-zero pos
>
> Should I wait for a v10 patch with spelling fixes as requested by
> Andreas?  And if there is a v10 submission, please update the commit
> message.
>
> 3. Matthew also threw in a patch:
>
>         iomap: Support inline data with block size < page size
>
> for which Andreas also sent some suggestions, so I guess I'm waiting for
> a v2 of that patch?  It looks to me like the last time he sent that
> series (on 24 July) he incorporated Gao's patch as patch 1 of the
> series?
>
> 4. Andreas has a patch:
>
>         iomap: Fix some typos and bad grammar
>
> which looks more or less ready to go.
>
> 5. Christoph also had a series:
>
>         RFC: switch iomap to an iterator model
>
> Which I reviewed and sent some comments for, but (AFAICT) haven't seen a
> non-RFC resubmission yet.  Is that still coming for 5.15?
>
> 6. Earlier, Eric Biggers had a patchset that made some iomap changes
> ahead of porting f2fs to use directio.  I /think/ those changes were
> dropped in the latest submission because the intended use of those
> changes (counters of the number of pages undergoing reads or writes,
> iirc?) has been replaced with something simpler.  IOWs, f2fs doesn't
> need any iomap changes for 5.15, right?
>
> 7. Andreas also had a patchset:
>
>         gfs2: Fix mmap + page fault deadlocks
>
> That I've left unread because Linus started complaining about patch 1.
> Is that not going forward, then?

Still working on it; it's way nastier than expected.

> So, I /think/ that's all I've received for this next cycle.  Did I miss
> anything?  Matthew said he might roll some of these up and send me a
> pull request, which would be nice... :)
>
> --D
>

Andreas

