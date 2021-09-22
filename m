Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C992CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 17:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AABBA60527
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 17:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbhIVR4m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Sep 2021 13:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236815AbhIVR4m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Sep 2021 13:56:42 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ADEC061756
        for <linux-xfs@vger.kernel.org>; Wed, 22 Sep 2021 10:55:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso2926719pjb.3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Sep 2021 10:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N8+jps3A14GynJSmzw6LICUadjrSD3zVUsUJsLV0rZk=;
        b=WEcDd3eyNLlpTBr5G2w6/U3ACRbzvqkURm/T54pVZ+ceKtWFyz/x6J/QBF0iuPstI0
         1j3TF0GlIoCp7/8Gtpg5SUC2Z8lXRey+3ZSd0qP+bgpH4hvRdZ1eOTYTnDA2kLhJV2cm
         GRk3lliL6TVYocTBnXxg+aM88nDKCNWeLAk17R3QoD1Ex6ff43CPVBz9J/umHz4iRr4t
         ujejwc7J+kLTEOfVRs4pdFl7ZL08fpR1kKMcT8dcabFhV/KeLTqixR4pnnJYCkPilrWu
         wqd+UZ0QdBW29D/8b95V/HVgg8egLQHf//AegMC/8d1bHR0TitPJsMVNEegYPonB3lP1
         +6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N8+jps3A14GynJSmzw6LICUadjrSD3zVUsUJsLV0rZk=;
        b=QIbXg+6Z1xEyQ3lW60OJdZxm/pqtb6/LdUm02HBKTNYIiZcVVil7/vdATEO87iaF1U
         dnEYzY9v2u+KqvZrinZ6wStsdjvxMCx+d+V5N5+yrN9mEZvbAgAFUv68cOiA+2jVWWzy
         mhIESRiR/+4rp5XY4e4ZqCFe3+La91jBfpuDVPywoO3uxq4eVgIW7SOk1EgUz8dmSr8x
         qSz91lM3VdmeRrlQ+jRmy5phVWxQrNIAOJT4wf/Mbm8J06TuAvBQFE85P9zPgTP0UL9T
         ZDxcI/rwywKnKGQGWnb2/2XOq0V2obQLeQ6FilYL9/oomPPaHGYus9bLDm7k0Msg8CrJ
         ybeQ==
X-Gm-Message-State: AOAM533BoXPwMcv8omGgUV8DCWZ06m6Os6da1F8kXIHoKgfgeZ2r7njf
        xS0RMUSAM6LXrwlXmeO+4ReK8mQzVd4nxg7vCVMH+Q==
X-Google-Smtp-Source: ABdhPJxDpETDisB1tJJJ3uVbr3cMcT+3v7yQjIsumtaYD7TRgjGOZKPn8Hi8Ai2wCoWFgFR5Pq9dPHOWjA1n+IRsAWM=
X-Received: by 2002:a17:90a:f18f:: with SMTP id bv15mr307453pjb.93.1632333311632;
 Wed, 22 Sep 2021 10:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210922173431.2454024-1-hch@lst.de>
In-Reply-To: <20210922173431.2454024-1-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 22 Sep 2021 10:55:01 -0700
Message-ID: <CAPcyv4jpTyzofDyUPi7ADbGcV+cJHSohctwxu5yDNTF34KWeOg@mail.gmail.com>
Subject: Re: dax_supported() related cleanups v2
To:     Christoph Hellwig <hch@lst.de>
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 22, 2021 at 10:37 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi all,
>
> this series first clarifies how to use fsdax in the Kconfig help a bit,
> and then untangles the code path that checks if fsdax is supported.
>
> Changes since v1:
>  - improve the FS_DAX Kconfig help text further
>  - write a proper commit log for a patch missing it
>

This looks like your send script picked up the wrong cover letter?

> Diffstat
>  drivers/dax/super.c   |  191 +++++++++++++++++++-------------------------------
>  drivers/md/dm-table.c |    9 --
>  drivers/md/dm.c       |    2
>  fs/Kconfig            |   21 ++++-
>  fs/ext2/super.c       |    3
>  fs/ext4/super.c       |    3
>  fs/xfs/xfs_super.c    |   16 +++-
>  include/linux/dax.h   |   41 +---------
>  8 files changed, 117 insertions(+), 169 deletions(-)
