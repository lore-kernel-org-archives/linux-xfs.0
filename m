Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A38C48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 00:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EC7B61153
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 00:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhFPAvG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Jun 2021 20:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhFPAvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jun 2021 20:51:05 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F4DC061574
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jun 2021 17:49:00 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id e7so234924plj.7
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jun 2021 17:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N705IiD7n6FnNdMOVPwQtLkiV4KgkJ6X1/De6zQZWwI=;
        b=Vdg0YlGJ8YdIQxJsskt857Kp1UiDME+54VPtdHVPVXgoShl4VVVAaR6LXE0dbZKVV2
         +W+U4JeT3w/znleh/vZYdYXLbeE/pb0HV5ZEWUPDcvLxO26mt2qXZgivFzn3uSvahElD
         IwGdaPoF4IcRH7qJIdQjXQmZCbal2lLL+QkYNIl2RRjAfHR9PYesk+uc+Sgyx5CZHFfl
         e2DUPodC5WlhmtLJUFdwdvpJ9eljMdTNGqS+3FoZy7nhDaFOgT1hWfV8NXRx6YQNwhKl
         h2XdYcERWOQAJ9xAgYdgl/J4fe3qT8u41yhXFC39k2ZstvQJHVRG9+iqruFGveOSagxS
         R4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N705IiD7n6FnNdMOVPwQtLkiV4KgkJ6X1/De6zQZWwI=;
        b=Z9IsvRE5dHMvATdHWyYbcATAup7enQ7DJKfvo6J7wHLmETkrqSjIeoiJtwJEQG1uAX
         TpmQSE9xRkz3XliK8n1reRdQO0AneZkUk/yqIyTA+uMNXp3nxlgLghOtSmvCEgRJhPlL
         ANoaCbSLxpVFonaKWeXjUYaU58qGnwGIzVwZrooAr+RpI6eZxNtt2LqX0MVRTEvFWlFD
         WJd/QyTrYXWwgSqiUcy0jPUvSBBJphfVulLb61HsAWATP8viDEmjHZxjgqxSOmDQlfNX
         rPx0RNyv78UPBLUM0B8RNNbAEN0e7DZrKiwZvqOxva6hp9X0Yljht33Bst4ofdDhNLed
         s4OQ==
X-Gm-Message-State: AOAM5322scxl5/rxaqlpF/NeMzLXMxuVfMPW6K0U8DWecukD+cF90u0z
        o+TSn2qUZ4Taz+YrDqeEShBtxe5v1otoA6VryHb5Ag==
X-Google-Smtp-Source: ABdhPJyPFTJSM7pJ7JUKFEZ8HQ+iir1f0oux2sr4aUWcOno+cjQdFNUvLXFLljz8kRS7NiWvMxxI/6TF54PHQ215JUQ=
X-Received: by 2002:a17:90a:8589:: with SMTP id m9mr7683966pjn.168.1623804539893;
 Tue, 15 Jun 2021 17:48:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com> <20210604011844.1756145-4-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210604011844.1756145-4-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 15 Jun 2021 17:48:49 -0700
Message-ID: <CAPcyv4h=bUCgFudKTrW09dzi8MWxg7cBC9m68zX1=HY24ftR-A@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] fs: Introduce ->corrupted_range() for superblock
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        david <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[ drop old linux-nvdimm@lists.01.org, add nvdimm@lists.linux.dev ]

On Thu, Jun 3, 2021 at 6:19 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Memory failure occurs in fsdax mode will finally be handled in
> filesystem.  We introduce this interface to find out files or metadata
> affected by the corrupted range, and try to recover the corrupted data
> if possiable.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  include/linux/fs.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c3c88fdb9b2a..92af36c4225f 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2176,6 +2176,8 @@ struct super_operations {
>                                   struct shrink_control *);
>         long (*free_cached_objects)(struct super_block *,
>                                     struct shrink_control *);
> +       int (*corrupted_range)(struct super_block *sb, struct block_device *bdev,
> +                              loff_t offset, size_t len, void *data);

Why does the superblock need a new operation? Wouldn't whatever
function is specified here just be specified to the dax_dev as the
->notify_failure() holder callback?
