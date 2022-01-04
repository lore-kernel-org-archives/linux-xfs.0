Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826C1C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 22:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbiADWoU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 17:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235649AbiADWoU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 17:44:20 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FAEC061761
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 14:44:20 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 196so33465209pfw.10
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jan 2022 14:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kNI0FNXnZ92A9rcSSuTMSZWtPK6rcwK+FpLRa43srmk=;
        b=fOsqdC5v/Ljnlv2FEIyia5PEUe1s+e+1DuDDfE7u5MaVA4dXKJQHiE1mRK5iYBVsUJ
         /oowxIHxSAdxALfYzQ8kGvygGPJuCKMOHtF6DiXbqMs/059LnQCgFzEDESiTPsFxFWNn
         7Xesjj8J0CJQX2rv/u96W/GJ5UgdA6Vcv8mkPCkFc6h66hCg6QsUbB+sYNaSz3UzdXUB
         lpIWK+oGnTNcmd+TytJ0U91J0Sv00HD75sq8eRh6giDzO8BfqgCduSAOWJzJitKNXhRW
         Yz6dvrh+hntEc7AjvBGIeEmebsxBEkSVtpsKzv/uaTDYZj1X2da7fQ7LGbcS1ECRAlNl
         1k1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kNI0FNXnZ92A9rcSSuTMSZWtPK6rcwK+FpLRa43srmk=;
        b=DawZCsonoUsoxlbWFEBq6AtH4ULOZA/Heu2+di8SUf8aP8H5xdfVcVcbyKpmqq/XWf
         PtNInS5o7UqR/2nLh2bDReBMP9AW7+bwsSED8rM/JDrFbLxS7UZgoUQLuGrucwbCmmj3
         b2XGu4SmNdZ+6ljqRytFiIy6wUb7rcuGz82CCnRvzlAKN01/Zjgc4THwsxIjUONdDqLD
         n/rC7DLSUqff3yI/NqOoiCGcdPBQuXZjk+1zgkBIZZlA3cbcmDk7IzgD4zoOxWhT3ED2
         wfCIOPt7uP7tHglKksChAeLGKn4siee5nqW756zV1gOE40Pxs+8AzdjNIBZ73Hlo8LVU
         2G8A==
X-Gm-Message-State: AOAM532uyhhM6PrkEcTRPLumKfLyHBwTVjoR7T++lKwt6AeJ+ytSwPtZ
        rf+TLTvtmd8X7uIocBxqdWagJuVwruyuABqdnqFcT4lko8SqpA==
X-Google-Smtp-Source: ABdhPJyP9Z0MRBW2RS42p0axndXN+7aFakOWJ0+wGPrF9fRJBeJgr0Nw19jdOKV52TidJL0PgD7xQGTpsKPEnebLsUg=
X-Received: by 2002:a63:79c2:: with SMTP id u185mr876468pgc.74.1641336259609;
 Tue, 04 Jan 2022 14:44:19 -0800 (PST)
MIME-Version: 1.0
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com> <20211226143439.3985960-2-ruansy.fnst@fujitsu.com>
In-Reply-To: <20211226143439.3985960-2-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 4 Jan 2022 14:44:08 -0800
Message-ID: <CAPcyv4gkxuFRGh57nYrpS8mXo+5j-7=KGNn-gULgLGthZQPo2g@mail.gmail.com>
Subject: Re: [PATCH v9 01/10] dax: Use percpu rwsem for dax_{read,write}_lock()
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

On Sun, Dec 26, 2021 at 6:35 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> In order to introduce dax holder registration, we need a write lock for
> dax.

As far as I can see, no, a write lock is not needed while the holder
is being registered.

The synchronization that is needed is to make sure that the device
stays live over the registration event, and that any in-flight holder
operations are flushed before the device transitions from live to
dead, and that in turn relates to the live state of the pgmap.

The dax device cannot switch from live to dead without first flushing
all readers, so holding dax_read_lock() over the register holder event
should be sufficient. If you are worried about 2 or more potential
holders colliding at registration time, I would expect that's already
prevented by block device exclusive holder synchronization, but you
could also use cmpxchg and a single pointer to a 'struct dax_holder {
void *holder_data, struct dax_holder_operations *holder_ops }'. If you
are worried about memory_failure triggering while the filesystem is
shutting down it can do a synchronize_srcu(&dax_srcu) if it really
needs to ensure that the notify path is idle after removing the holder
registration.

...are there any cases remaining not covered by the above suggestions?
