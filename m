Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E385C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 23:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiDLXlW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiDLXlC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 19:41:02 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2187A97BA5
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 16:22:46 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id k13so365831oiw.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 16:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cXG2uBz6lRa6SmsxOh4UHnvAS1v6j3gtk2oaRONS+x4=;
        b=VPl1Lq9jWUOfdQHl/1KZuWWM6wCjlya9ZIm56mGgKOGxFiC5BaCc1BSVeUdc1pyItB
         BIIRsGb7m/uTTFP7EQ9bwdIRf6Qc2mw3gELQG2VwZAg2xJ2tVel9MI1+ME9SUoGaJ8Ck
         Z8ts0Cz8Sv7S9Fzd/Im/JfbGqbs45u5Dpd4A8hT36LVn0vEKF5gJNhz9Xj3HxeT5GFx9
         3orzrVLxvjY3XUMpiLuJPsctZxiLUWVgCZp6UZHqMNblOrfxFCYbsUPAtL6PjFLKvIYv
         yR16Pm/ZW/nafNyxKUqk8z/2UQ0ECbaF4NEyEpOJWqi+m9FgHi5wKcizOSX3GGI9F65b
         O8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cXG2uBz6lRa6SmsxOh4UHnvAS1v6j3gtk2oaRONS+x4=;
        b=xjxhtqO4uKvdBgOokx7NSbQiwlDjQ40bD0htrDpe6T52/PHW8p9Cgr9sGjSpn0Lw+0
         g6o9NDpxkjPtdi/ztFI/dYDJGCKITY43mCQkFtjeqCaXyDuMLBe69P66QHWu1MJbRBcM
         6ikHwMxoH32JJw76OChWlT5K4rUYuW2eVyU2C+HYGlpjvh+rxEHgFY9cSr6I0ucXaPUK
         KDYz/hMvEn9h4OX8JS9Wlr9Vw9jNy34WJvStUF2Fuk7Oez45qgVnmwUb4JldjvPLQ2b7
         5VideyFRy9YRrS9ig9J2rxsrhLaU5JH2AUGybxItgoutHKoli8EefCk07ZLhwE64Iaul
         erbQ==
X-Gm-Message-State: AOAM530JsuO2tcmPqPOUjDgbS2r8lpOQ7ByLG8XAmogCg/uw7ePqNJ2c
        +6D5D8+AXUEsbTSnALfihxQmBVi50FCDHlAX/gDtRA==
X-Google-Smtp-Source: ABdhPJzEsDa0QPWqZoKnqzlrHygJjKtOSvpADAV6Jhisjm10RxdCfr8ioS/LCXNm6BQQZeX47QnFzwejPCzwj9rtzOk=
X-Received: by 2002:a05:6808:1154:b0:2da:2fbd:eba9 with SMTP id
 u20-20020a056808115400b002da2fbdeba9mr2979048oiu.133.1649805765445; Tue, 12
 Apr 2022 16:22:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com> <20220410160904.3758789-2-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220410160904.3758789-2-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 12 Apr 2022 16:22:34 -0700
Message-ID: <CAPcyv4iqHMR4Pee0Mjca2iM6Vhht8s=56-ZefYvpBmxuEi0Q6A@mail.gmail.com>
Subject: Re: [PATCH v12 1/7] dax: Introduce holder for dax_device
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 10, 2022 at 9:09 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> To easily track filesystem from a pmem device, we introduce a holder for
> dax_device structure, and also its operation.  This holder is used to
> remember who is using this dax_device:
>  - When it is the backend of a filesystem, the holder will be the
>    instance of this filesystem.
>  - When this pmem device is one of the targets in a mapped device, the
>    holder will be this mapped device.  In this case, the mapped device
>    has its own dax_device and it will follow the first rule.  So that we
>    can finally track to the filesystem we needed.
>
> The holder and holder_ops will be set when filesystem is being mounted,
> or an target device is being activated.
>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.wiliams@intel.com>

I am assuming this will be staged in a common DAX branch, but holler
now if this should go through the XFS tree.
