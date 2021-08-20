Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3C3C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 23:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E15A36117A
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 23:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbhHTXrS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Aug 2021 19:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239503AbhHTXrS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Aug 2021 19:47:18 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84A3C061575
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 16:46:39 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y11so9959860pfl.13
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 16:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eHMEwcWn5S7G+chbvcpQTCNCdRCcbE/CWjRPjJXaV5I=;
        b=dV1qy1mgsEI4INkTjHHUKy2f7GSIBsf4O1+fXHWSy+kAEv3jYRCYAaMAoxshjnqkyG
         oT2A+bqzdhWPP7Nst6cJc+rRq8qjOqCAzweIkXIkoEgo8nuUUMoiRJVOkDK3YmorYY2a
         MiYIB0B/a9xDq85QpmZl/2OTACzF1vsdUrsmu7G3BBNzopmDSm3t3cTCYxalZF+EklbQ
         z/QBhrFGCRX/NdduCq4/gSDYTAIHTqZ63QqvdfDM9w8L08bZLCVJabVWF+5h1GcwWdBx
         g+Yx1heQOEc1eDGWC1flE3Y5YJQ9B8bHRxJIIM5h054uHHrScv9Gt6FUJTVHrhRhnuED
         x2EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eHMEwcWn5S7G+chbvcpQTCNCdRCcbE/CWjRPjJXaV5I=;
        b=ujWwqDB+CoGYj3XjqYPz4JOBfhJ4faflxLIvs1k/mSmxn08lIS+xiigJE5j0YPKZlU
         N/FMOl1K1G04Ryt6bYAt+441RG9UO7vl0CcN/V9aGwM1crhn6nic/ZIgzoLvWCLoTeuA
         UsNcn5P+q/uliMEyLGCZRFSh2zR6jEugg3RgF31VL8PvGr1xAah6xZRtwRIkHfyQLY5m
         hLMmQjaN1u19dz41jLX3sHLiUiZsrYtEB3ZRDp/GmNtI0o0ix3YJCM4VcnuqoGSvsHGD
         hRxP15gfepxJ6sGoNaNZm+X1MhChiUEQQGOk4sydQyouuwhsWTHVcHvJcLCwLrtFMe+2
         6oog==
X-Gm-Message-State: AOAM533tA3QZ0+QZppC4KPTkOGdM4Z1bdd6NoUvCqoE5/H3ASbN75bPp
        +nphsXiTLti0P+B4mXG8PGTwlSmn/fWkn0//kNj1Kg==
X-Google-Smtp-Source: ABdhPJzS5HGT6xJgqFrmEph3uz/ZG7OFdXOcKr3T36oL70Xxr6i57XBJUHqsj1rzOh9dfprsZA/boIS7GPxjc7UyUjw=
X-Received: by 2002:a62:3342:0:b029:3b7:6395:a93 with SMTP id
 z63-20020a6233420000b02903b763950a93mr21855818pfz.71.1629503199185; Fri, 20
 Aug 2021 16:46:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com> <20210730100158.3117319-8-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-8-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 20 Aug 2021 16:46:27 -0700
Message-ID: <CAPcyv4ic+LDagR8uF18tO3cCb6t=YTZNkAOK=vnsnERqY6Ze_g@mail.gmail.com>
Subject: Re: [PATCH RESEND v6 7/9] dm: Introduce ->rmap() to find bdev offset
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 30, 2021 at 3:02 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Pmem device could be a target of mapped device.  In order to find out
> the global location on a mapped device, we introduce this to translate
> offset from target device to mapped device.
>
> Currently, we implement it on linear target, which is easy to do the
> translation.  Other targets will be supported in the future.  However,
> some targets may not support it because of the non-linear mapping.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  block/genhd.c                 | 56 +++++++++++++++++++++++++++++++++++
>  drivers/md/dm-linear.c        | 20 +++++++++++++
>  include/linux/device-mapper.h |  5 ++++
>  include/linux/genhd.h         |  1 +
>  4 files changed, 82 insertions(+)

This might be where dax-device support needs to part ways with the block layer.

As Christoph has mentioned before the long term goal for dax-devices
(direct mapped byte-addressable media) is to have filesystems mount on
them directly and abandon block-layer entanglements. This patch goes
the opposite direct and adds more block layer infrastructure to
support a dax-device need. Now, I'm not opposed to this moving
forward, but I'm not sure block and DM maintainers will be excited
about this additional maintenance burden.

At the same time a lot of effort has been poured into dax-reflink and
I want that support to move forward. So, my proposal while we figure
out what to do about device-mapper rmap is to have
fs_dax_register_holder() fail on device-mapper dax-devices until we
get wider agreement amongst all involved that this is an additional
burden worth carrying. In the meantime XFS on PMEM will see
fs_dax_register_holder() succeed and DAX reflink support can be gated
on whether the dax-device allowed the notify failure handler to be
registered.

Now, there may be room to allow reflink on device-mapper-dax for
CONFIG_MEMORY_FAILURE=n builds, but that would collide with future
work to use notify_failure for more than memory_failure, but also
NVDIMM_REVALIDATE_POISON, and surprise memory-device-remove events.

The code in this patch looks ok to me, just not the direction the
dax-device layer was looking to go. It might be time to revive the
discussions around support for concatenation and striping in the pmem
driver itself, especially as the CXL label specification is already
adding support for physically discontiguous namespaces.

At a minimum if the patch set is organized to support XFS-reflink on
PMEM-DAX and later XFS-reflink on DM-DAX some progress can be made
without waiting for the whole set to be accepted.
