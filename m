Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00807C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 21:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D96E4613CD
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 21:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhHWVXs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 17:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbhHWVXs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 17:23:48 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C198CC06175F
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 14:23:04 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id oc2-20020a17090b1c0200b00179e56772d6so357858pjb.4
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 14:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ShErwyspG88Bo4yVlFpB0fmc1BjfRh8zuGfu0CGRDeA=;
        b=rHIKZbBUCGl81JJDCGO2jSGr728UIVVQ13KxyIxc5kP6Wg5oWA9rRVWif9iIao5pL4
         L8JX62XyKt1eePLQ2AwBJuJrwPwVawP5zim6ZdRWmHiKv2kKR3fko7lTmbKjyT/aQtzo
         MEdxWwqwa1yVZo9MHkLO9AqBKKOAaM2gOsmwCUlHxgSNIJ8uSbFInX867fUxouhXCXBK
         gKKCWO53t3zw6Z8NYQly+wmZgIqWldfA/074D115o3Qsil+IMBtncqlvsQq8DAEwET7c
         V12Srx4AvkF0ONhtcsEFOppkKM7yNRBoaPdKFKb4agsQdX7D6hUMAsWrwA5FtIt/Kyou
         eNlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ShErwyspG88Bo4yVlFpB0fmc1BjfRh8zuGfu0CGRDeA=;
        b=Ji/dFDAudAKkcK5xoBom+m7uDpa9iOeCQujE4TxjlLQdX6kaYQRtOrUqUP1o2seRmV
         OyeZYnc7QHpc8PuoUACOd5tIdV6kowTTd0ozOO5EdpAWDtMbeWQu6zNGooUVYHfEUIbT
         0XdjUV9MZ/uulP5mwd3/MlIsbdI5HYCPFLnky6vs30fOEBqBJr+FUmwvV2yO2PL7zasv
         aavLTmTYWbShvsOEFdjufGfLe+WcEHXWcn+oRMy5cH5YSxiUkXPkfBUrUqp3EDPW3Mr2
         ShuGOXRF5Mw36A1pMIKMJNwtOG27GbWUXXDULpX9+BxSbtRCMDvdZON3xrkH9BUPqbBf
         rV3A==
X-Gm-Message-State: AOAM530YTUwTybDK+BJXuzvQRjTRDaarXA2iJNMqA5fD2TXfCBUjeBaw
        lKFPVH6mPOP5BesQLlkaw+0arhVk6flGt7ERYNZkYg==
X-Google-Smtp-Source: ABdhPJx42nu034KgnU+n5z3pwJcpAAmVm/tyH+LAY8tSKD1qwe5mGvbj3AXhqEGCH92DHgFtK8TvIT3ZBlghdPmQxgY=
X-Received: by 2002:a17:902:edd0:b0:135:b351:bd5a with SMTP id
 q16-20020a170902edd000b00135b351bd5amr2141894plk.52.1629753782818; Mon, 23
 Aug 2021 14:23:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-10-hch@lst.de>
In-Reply-To: <20210823123516.969486-10-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 23 Aug 2021 14:22:52 -0700
Message-ID: <CAPcyv4hNL+ohvTP7VK9zrPDhyVTbUZSD74=z2H2uveudaqi+=w@mail.gmail.com>
Subject: Re: [PATCH 9/9] dax: remove bdev_dax_supported
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

On Mon, Aug 23, 2021 at 5:45 AM Christoph Hellwig <hch@lst.de> wrote:
>
> All callers already have a dax_device obtained from fs_dax_get_by_bdev
> at hand, so just pass that to dax_supported() insted of doing another
> lookup.

Looks good, series passes regression tests:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

I can take this with an XFS ack, or if Darrick wants to carry it to
make Ruan's life easier that's ok with me.
