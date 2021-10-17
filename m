Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD17C433FE
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Oct 2021 18:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 737F860FED
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Oct 2021 18:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhJQSXM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Oct 2021 14:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344035AbhJQSXL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Oct 2021 14:23:11 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F236EC06161C
        for <linux-xfs@vger.kernel.org>; Sun, 17 Oct 2021 11:21:01 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id om14so10690136pjb.5
        for <linux-xfs@vger.kernel.org>; Sun, 17 Oct 2021 11:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bXbtM9w7wtLoZs3T6qJjqX2Ty4EbqqViT4Y7xCCz9a0=;
        b=2Tgma9fVZq0U5pzB5d+36fugnRWpKAv/vv+rd8TY+x55UKPcedrr3mcNfc9HXBvbun
         uQlo9RXfQ+zSC64+hvaj39yB4RzfudhW8ebr5TZUjs8P6f8o/iY3/E3pBSw+FmZg9r5H
         yrKODUnTdxhNkmkAk/E1YHkypi6Sv3jbpIibkuVlTjnnQeieoFMENC1NLaSK2u4SlvST
         ec4bQfrye0G7/+vvWyyX4A1WiflmgrwjfFh+W2cGmx0+/DneG46gr0nh4gtOHwTEyWHX
         64cN+swwvB62EGxeYvejuxtdCUCu6ZdwbaLZUn9QkYSKwCOSEQt5XvyOcToZImgWm8HS
         LudQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bXbtM9w7wtLoZs3T6qJjqX2Ty4EbqqViT4Y7xCCz9a0=;
        b=J9nrtAV9X5N0mrQckY+EbBNfIDOBJWLGjrDpKhPJzWNwJ7RR8loOh+3Lh2HoslM80U
         PkwTOK0k5kKt8F3ZKh2O5VrntHcaKUIYjkiP4YYTanUfZk+fdwRK0DvrtVzBxvQZl2Xn
         UVtdR69kCyWb0447ynFZejGuSWfuTYQ9/Fu/EKCcDjfE6sR53RIHhW/9aE9Yj6JhaA5Q
         /Q+IfBEGU5FgTPbyfXW0WgLnl+mMWddtaHxUu4GCDZpcj0iDPcXm1tjmjX+P2Ct6maxp
         4f26W4qBcOB8ELbSAvrNiVhj3GaKPzLfllDmzdghrV1Ub5LdIQcp7vDfvF/RCj1azmRe
         egsQ==
X-Gm-Message-State: AOAM5321EJW/VxLf5FyvFqXC8mTEcc52AeCpsbtjqnMiWzTDSzLdivs2
        AzC6ZUOFJMLWYmCi1PWNm+B65Bg618QRtVruOYVmGg==
X-Google-Smtp-Source: ABdhPJzU8zZ6l/YLNPvyqrKueTnR9hmDhm8Moze9Nm8sl5P7aCcyYqLsiPIbKOBjjU/+LKabzjZnafwYKZQAKYl1LZI=
X-Received: by 2002:a17:902:8a97:b0:13e:6e77:af59 with SMTP id
 p23-20020a1709028a9700b0013e6e77af59mr22550921plo.4.1634494860987; Sun, 17
 Oct 2021 11:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <20211014153928.16805-1-alex.sierra@amd.com> <20211014153928.16805-3-alex.sierra@amd.com>
 <20211014170634.GV2744544@nvidia.com> <YWh6PL7nvh4DqXCI@casper.infradead.org>
 <CAPcyv4hBdSwdtG6Hnx9mDsRXiPMyhNH=4hDuv8JZ+U+Jj4RUWg@mail.gmail.com>
 <20211014230606.GZ2744544@nvidia.com> <CAPcyv4hC4qxbO46hp=XBpDaVbeh=qdY6TgvacXRprQ55Qwe-Dg@mail.gmail.com>
 <20211016154450.GJ2744544@nvidia.com> <YWsAM3isdPSv2S3E@casper.infradead.org>
In-Reply-To: <YWsAM3isdPSv2S3E@casper.infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Sun, 17 Oct 2021 11:20:53 -0700
Message-ID: <CAPcyv4h-KxpwJtrM4VV64J7EPk9JCPeW27jtPXyArarfeo9noA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm: remove extra ZONE_DEVICE struct page refcount
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Sierra <alex.sierra@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        Linux MM <linux-mm@kvack.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, Christoph Hellwig <hch@lst.de>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 16, 2021 at 9:39 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sat, Oct 16, 2021 at 12:44:50PM -0300, Jason Gunthorpe wrote:
> > Assuming changing FSDAX is hard.. How would DAX people feel about just
> > deleting the PUD/PMD support until it can be done with compound pages?
>
> I think there are customers who would find that an unacceptable answer :-)

No, not given the number of end users that ask for help debugging PMD support.
