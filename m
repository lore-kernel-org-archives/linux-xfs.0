Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E9BC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 04:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbiDLFAF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 01:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237879AbiDLFAE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 01:00:04 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CA63335E
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 21:57:47 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y6so15763803plg.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 21:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8TleCaBIhpvoj6MzJmrMyC3ucMSm6WO1y+eL8xleJY4=;
        b=fkN36mDpM4Pd1sCv3rNuy9oyYD/gLOwueus4xphJV1YDbeNRSQ8IyujzwsptiZfgYe
         QUQIV9qghorMpdWWz6Mmsr/1DpHVZ96zqos/O3uhBAyz4TBRkDPpFJ5YoWKm0lCFZweQ
         RoEFhL/uQjowL2aggfNFdXl2Ztg3A9451oiIjvEilBdbF+7t1islEN8KsPhMNJASWFOK
         SUVweWmAjr6bfH/tyV4dylbfizqkoRZTCLZaofjld5K7oDzCT9ORDsz4TyjMGKUqQ8M4
         Qet/LWoJSVXRFpDjGoHVJDsMMopWIZP4HzpS68RD9q73tLwybQtTxPuEsqT+1brdIvEZ
         etIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8TleCaBIhpvoj6MzJmrMyC3ucMSm6WO1y+eL8xleJY4=;
        b=7ZCvSCcFigvtbc8Bjux5likz4gygwy4V4Zuor//M5Rnmu8CWUAw9w+nK1/s88el/W5
         eNkO8TJ5GRakOqJwECa+rur4713+w39CU9PDhpP9GRwzDIhASWfSp+l1m9JXk+V2VLzc
         Ro0ZcIiQl23VAO8EIIVIw8JhSi24kQ2wG869oYG7DT6PZdIR3VQAnHMLgFwMmgqT74Bj
         +IqeH0mUyyyRFNBDwMcBvMHjuv7Io8Y5H5Nnyzte+lJVHFxMcYF8Q/am5socw9LCqrel
         Sv/e450L/iZIVLbDsh8cGHuFYjWJKGrHrlRFqhY6f7WcLoj1IPrKozw1Yf9FAlS1tEwk
         ETiw==
X-Gm-Message-State: AOAM531C78qLhq1phKdoa9cojFK0EKSV3/6DsBT+sie/b993MJKG9F3C
        ZuSkH+lQ6mWtiIucMFurIvYJKoRxQq9dOKxRgRnK4w==
X-Google-Smtp-Source: ABdhPJxBATyoJAyblOakoZzlFS+GtSy3AbBTLdouj+8YmPDRCb1cpkksbCSmeWKkXDHtWwI5LR7XG/b+KrOX8AklXlQ=
X-Received: by 2002:a17:902:eb92:b0:158:4cc9:698e with SMTP id
 q18-20020a170902eb9200b001584cc9698emr12430897plg.147.1649739467468; Mon, 11
 Apr 2022 21:57:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com> <20220405194747.2386619-5-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-5-jane.chu@oracle.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 11 Apr 2022 21:57:36 -0700
Message-ID: <CAPcyv4jpOss6hzPgM913v_QsZ+PB6Jzo1WV=YdUvnKZiwtfjiA@mail.gmail.com>
Subject: Re: [PATCH v7 4/6] dax: add DAX_RECOVERY flag and .recovery_write dev_pgmap_ops
To:     Jane Chu <jane.chu@oracle.com>
Cc:     david <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Weiny, Ira" <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Introduce DAX_RECOVERY flag to dax_direct_access(). The flag is
> not set by default in dax_direct_access() such that the helper
> does not translate a pmem range to kernel virtual address if the
> range contains uncorrectable errors.  When the flag is set,
> the helper ignores the UEs and return kernel virtual adderss so
> that the caller may get on with data recovery via write.

It strikes me that there is likely never going to be any other flags
to dax_direct_access() and what this option really is an access type.
I also find code changes like this error prone to read:

 -       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
 +       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, 0, &kaddr, NULL);

...i.e. without looking at the prototype, which option is the nr_pages
and which is the flags?

So how about change 'int flags' to 'enum dax_access_mode mode' where
dax_access_mode is:

/**
 * enum dax_access_mode - operational mode for dax_direct_access()
 * @DAX_ACCESS: nominal access, fail / trim access on encountering poison
 * @DAX_RECOVERY_WRITE: ignore poison and provide a pointer suitable
for use with dax_recovery_write()
 */
enum dax_access_mode {
    DAX_ACCESS,
    DAX_RECOVERY_WRITE,
};

Then the conversions look like this:

 -       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
 +       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1,
DAX_ACCESS, &kaddr, NULL);

...and there's less chance of confusion with the @nr_pages argument.
