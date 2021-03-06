Return-Path: <SRS0=wIC6=IE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DA0C433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Mar 2021 20:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A31B4650B5
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Mar 2021 20:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhCFUg7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 6 Mar 2021 15:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhCFUgq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Mar 2021 15:36:46 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729B9C06175F
        for <linux-xfs@vger.kernel.org>; Sat,  6 Mar 2021 12:36:45 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lr13so11556219ejb.8
        for <linux-xfs@vger.kernel.org>; Sat, 06 Mar 2021 12:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bVBJNOetXrqKceA6PQT3AoaWCMo1uBzTwNd40e3p5Mg=;
        b=DUH2TaJDmYKl3P+nqyQnZD/L+UUehgvGZ+JdR6f29HgDHqUZMlDctwBIl8mYEmOyr0
         N4JfiYpVnsK20wsamLI2lVHA89Wfq08BTq5pazwlWEnowiN+pvdoMlOFkXMkezTctVU6
         yLVLH/j9zqqOc1XXIzlPNblcwaWBnvPKoE+8ygaflWqyueqL8GQUxJqDZ0IOPsbLAq4D
         ClAITvBD9MRRxeIdqI+0cvIdl865zgrrN5mPPgRQlFQTjJcqKYMYzsPzMflqD2WkyucY
         yYqxvUtScFD3cWQ3k6qWXggCW2IBUYcSUf7R3K/wcLL0Zz3r5yXY54vMvwFWm819EQIv
         72nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bVBJNOetXrqKceA6PQT3AoaWCMo1uBzTwNd40e3p5Mg=;
        b=TShsSM1ZuOtnSFr8CfKLBHMyeqM7zU7f3A1hL0fCG/YoQsvq1QVFZ9mph2F+bE+mJZ
         0LAv04UTiZzep/DBd/Tvkt1bQLw4GDkkjvAMU7o2WV2IXv+8l+7Jr+t+oEpxhiHDPNBj
         icaeusog3oGzHm0HPbVJ7hrNQb/70CucSi9i/UYVmyxcRXdKeiYgjJOdOhkR+g9ygYi9
         SJRfMy58gN7reCDxe4Bbm7F3yQXwxjF9C3gkiQe5Y01tGSaQAzPcfpLocj77aJDutKAQ
         +9GjYfM8xMhJ7cFDw19f3XdEE/ArQpCxIWlrnZ+HXJSfl7FYOpOygghybXx3pJPVYL7e
         QDZA==
X-Gm-Message-State: AOAM530GwGH5p5Pa2c7GX4qJs4UbZMGEMZpuUGoYMpQng6A47bum+a36
        APnnKtBPnHlKahMTooYvloMe6VcGcCiXkMq3ninvTA==
X-Google-Smtp-Source: ABdhPJwWg5JZfa53VPl0WuQEKYMbCdynjlz48fz7pdzLNK+5tXI6itu2L3u8T4IRUn3/J6V3gGOhtuytQtomfVZ9FIo=
X-Received: by 2002:a17:906:2818:: with SMTP id r24mr8202331ejc.472.1615063004125;
 Sat, 06 Mar 2021 12:36:44 -0800 (PST)
MIME-Version: 1.0
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com> <20210208105530.3072869-2-ruansy.fnst@cn.fujitsu.com>
In-Reply-To: <20210208105530.3072869-2-ruansy.fnst@cn.fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Sat, 6 Mar 2021 12:36:39 -0800
Message-ID: <CAPcyv4jqEdPoF5YM+jSYJd74KqRTwbbEum7=moa3=Wyn6UyU9g@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] pagemap: Introduce ->memory_failure()
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        david <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>, qi.fuli@fujitsu.com,
        Yasunori Goto <y-goto@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 8, 2021 at 2:55 AM Shiyang Ruan <ruansy.fnst@cn.fujitsu.com> wrote:
>
> When memory-failure occurs, we call this function which is implemented
> by each kind of devices.  For the fsdax case, pmem device driver
> implements it.  Pmem device driver will find out the block device where
> the error page locates in, and try to get the filesystem on this block
> device.  And finally call filesystem handler to deal with the error.
> The filesystem will try to recover the corrupted data if possiable.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> ---
>  include/linux/memremap.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 79c49e7f5c30..0bcf2b1e20bd 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -87,6 +87,14 @@ struct dev_pagemap_ops {
>          * the page back to a CPU accessible page.
>          */
>         vm_fault_t (*migrate_to_ram)(struct vm_fault *vmf);
> +
> +       /*
> +        * Handle the memory failure happens on one page.  Notify the processes
> +        * who are using this page, and try to recover the data on this page
> +        * if necessary.
> +        */
> +       int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
> +                             int flags);
>  };

After the conversation with Dave I don't see the point of this. If
there is a memory_failure() on a page, why not just call
memory_failure()? That already knows how to find the inode and the
filesystem can be notified from there.

Although memory_failure() is inefficient for large range failures, I'm
not seeing a better option, so I'm going to test calling
memory_failure() over a large range whenever an in-use dax-device is
hot-removed.
