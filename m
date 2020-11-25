Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A123C6379D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 18:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7E2B2075A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 18:17:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=fooishbar-org.20150623.gappssmtp.com header.i=@fooishbar-org.20150623.gappssmtp.com header.b="2RcIEuqt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733044AbgKYSQz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 13:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732471AbgKYSQz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 13:16:55 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA6DC061A51
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 10:16:54 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id r3so2857990wrt.2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 10:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fooishbar-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5gTn7rnt46vXkbVABsd/nLFo1oDvs2e/sre8ZiKqDQ=;
        b=2RcIEuqtZY++KbyHHJ/8Al35LHvGEMfjFhX1wg6Sx1lnUQGdB99z0SrLom14WDlOHC
         JzFjfP0tNkkwXcu6XzC6NAhOhzQoKp7yho7CnvBk07fTG44rTUd8izJ5QltWtboAdbOs
         aCwthm9Lwh07mqfBhvxEgEy62qR7qdqH+QrYogMcZX0700fvS9sUweRgeTkiom3OxL5l
         QQq2a/7Luu4pPuoc8nmOoPM+g7UUK1JTIHbOZYOZsTOa1alHfkhxBDNUi3/IBmDcpRRF
         G0Vssw/bwybi4EgR5nUVohtKi/g9Eh+ZHJX4b7hFPGkxVT5uexQ6SNfhT0tVKhkKie1I
         gk9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5gTn7rnt46vXkbVABsd/nLFo1oDvs2e/sre8ZiKqDQ=;
        b=Hy0gfYSjsmTXc5ycK99IPmh4k1vjsYt/ChAFwuTGsHp8rC8bkb/zXKGNmH5GHREZRe
         jFzWOQVqhFN9kaXsSf5TPTnp0j6sgWuUQE20ye22OYuqAzou5pPuGEkso+a2KkeW6CJt
         Gc5oEd8C7Zp7HYjGbeQ+cUZcOSTwjc/8LES9Ag/PMVlNUAeR6VlbYUKUBaQha5WVeV2A
         WUnvkmNZQqIXMuA9JeDqBIm13ujYzhHuYAExTAzLAL3azq3lDzb4X+NhohzOfbkTmchI
         iVycALq9H29VI6d+XcNT63sdX2dcUMnKQB+YSnekItdAz4T5yEhVPHWLV55afSRRHFU6
         7xHA==
X-Gm-Message-State: AOAM531By7Sn7J5eIN2UHvitM2jkt1U2L0BdIdhfPMWuzABZrXaOpnu0
        rLND36shxHvH833zu6x9XXFpUduPeWsXU0SCmlqRCg==
X-Google-Smtp-Source: ABdhPJwQ8WelxJodfMPdFHmQdz1O8TGE9MrvKPhhxxXuE5dHnylhfXIpx/XMn0moXpHiTw1HBA2/nw6OzXt+/ScISSw=
X-Received: by 2002:adf:e509:: with SMTP id j9mr5578411wrm.354.1606328213209;
 Wed, 25 Nov 2020 10:16:53 -0800 (PST)
MIME-Version: 1.0
References: <20201125162532.1299794-1-daniel.vetter@ffwll.ch>
 <20201125162532.1299794-5-daniel.vetter@ffwll.ch> <CAKMK7uGXfqaPUtnX=VgA3tFn3S+Gt9GV+kPguakZ6FF_n8LKuA@mail.gmail.com>
 <20201125180606.GQ5487@ziepe.ca>
In-Reply-To: <20201125180606.GQ5487@ziepe.ca>
From:   Daniel Stone <daniel@fooishbar.org>
Date:   Wed, 25 Nov 2020 18:16:42 +0000
Message-ID: <CAPj87rP-=yXjdPc48WrwiZj8pYVfZsMhzsAqt-1MrrV2LoOPMQ@mail.gmail.com>
Subject: Re: [PATCH] drm/ttm: don't set page->mapping
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Linux MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On Wed, 25 Nov 2020 at 18:06, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Wed, Nov 25, 2020 at 05:28:32PM +0100, Daniel Vetter wrote:
> > Apologies again, this shouldn't have been included. But at least I
> > have an idea now why this patch somehow was included in the git
> > send-email. Lovely interface :-/
>
> I wrote a bit of a script around this because git send-email just too
> hard to use
>
> The key workflow change I made was to have it prepare all the emails
> to send and open them in an editor for review - exactly as they would
> be sent to the lists.
>
> It uses a empty 'cover-letter' commit and automatically transforms it
> into exactly the right stuff. Keeps track of everything you send in
> git, and there is a little tool to auto-run git range-diff to help
> build change logs..

This sounds a fair bit like patman, which does something similar and
also lets you annotate commit messages with changelogs.

But of course, suggesting different methods of carving patches into
stone tablets to someone who's written their own, is even more of a
windmill tilt than rDMA. ;)

Cheers,
Daniel
