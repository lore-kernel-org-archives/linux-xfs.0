Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9092C7EE2F
	for <linux-xfs@archiver.kernel.org>; Wed, 31 May 2023 09:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbjEaJPp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 05:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbjEaJPl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 05:15:41 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F337F124
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 02:15:39 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-969f90d71d4so787555166b.3
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 02:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1685524538; x=1688116538;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T/bYqGFJ4VOGoB5+32Mcq8JR70Vd1T1ITCSeV7/3ifk=;
        b=UZJgvu6uIJY01EjK7iQN8XWB6pp1lB8CKfw+N0J9F6PgtqlKRqH1SLE+0gJUsS//CY
         frv0e589K6FPUxK3WlywVEVU5EIXgi5CrlyDlCnTpxW2lWKTjmwY/duejSbBA4/xINGF
         cl9p3WvJMPfMA2wH+RIqqUtbNfejKb30vQfU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685524538; x=1688116538;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T/bYqGFJ4VOGoB5+32Mcq8JR70Vd1T1ITCSeV7/3ifk=;
        b=Fw94DogXsKr8ATnLT1n/QDshQYpK/XPIoJx1omyr1TXTn12QEQz8kMnPktC9m4ZmY9
         dSyCEJT2s/dJ5rvfIhPpXhvZynVOD4aoXCb6sIhRSwcJHBPP0tK1Ainaq0rD8ey6kz0t
         X6bWAtDcn8WKSE+49QTxgzPj1WcQAYqzqxGH3ANSeH/LhrWIp9bRzjCQxofdoJnm8V6E
         2XZJP5R3qQ+SgnBLV8xfKQaL6u5wgMvx5N7IjJaai/JAwBCwfzwGNNxw5rQi3DjCat72
         +/A3Yw81WHJn2gBRFIAZwfk/PPezdtA9B2KhsyvSKm4Msuow6MhkSVkmwnLpzI95aPcu
         IpRQ==
X-Gm-Message-State: AC+VfDwpA9ZIBjzvhJ665nQ2XxWLQr+6Ns3gkLoojZMAdVN6JtT1vNYi
        JpBxaHNKqm5S7l960zxPUU0MoXRG87TFIxAsm1ygCg==
X-Google-Smtp-Source: ACHHUZ4+FWciM8qyJY0wuGopESAGDBSeuypok3sj/I3YbiV8yhFjyVDeVyjcnaAR9QRVCUk4jCbe3rFAcVDPPt68Cvo=
X-Received: by 2002:a17:906:9756:b0:967:21:5887 with SMTP id
 o22-20020a170906975600b0096700215887mr4163471ejy.40.1685524538465; Wed, 31
 May 2023 02:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230531075026.480237-1-hch@lst.de> <20230531075026.480237-10-hch@lst.de>
In-Reply-To: <20230531075026.480237-10-hch@lst.de>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 31 May 2023 11:15:27 +0200
Message-ID: <CAJfpegtPM_=3uGdxxkb9xP8LVg5P0Lm-w4TNLYhw+MqcNi8c1g@mail.gmail.com>
Subject: Re: [PATCH 09/12] fs: factor out a direct_write_fallback helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Chao Yu <chao@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 31 May 2023 at 09:50, Christoph Hellwig <hch@lst.de> wrote:
>
> Add a helper dealing with handling the syncing of a buffered write fallback
> for direct I/O.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>
