Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3919C43217
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BB2961A62
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbhKSRYX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 12:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236555AbhKSRYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Nov 2021 12:24:22 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDBFC06173E
        for <linux-xfs@vger.kernel.org>; Fri, 19 Nov 2021 09:21:20 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b11so8602933pld.12
        for <linux-xfs@vger.kernel.org>; Fri, 19 Nov 2021 09:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2U/4HYKnAZR7qNMIeDCg5S//595luEluzFk14uv4gBU=;
        b=FQ6M7eMMvPf80QsdTpoBZi0VrX8bn7QeX7OvbRABdgkNvCMNjXzl7/FKjSfSUjRkzX
         F1usfPnFQYNtajLRg0QRwSSgzt8mzXj0XCG2cnk0+F0m/6Zhw3KmrGwYuAHqWjDxU8h7
         LoqDBYl4kQUeXb8kAZzT8ViJ+hkv5vLV1Goy6Yaluym7CVIoftX3Jldatma/nAYXl27p
         pclrbJHG5C0Blu/232w4rLGJUG53x/PsyFdu4/UMHnSQZ8XMlr5FFqwE0la2E0Wy9pBi
         QLaClBcQjJDmbuAEv+kCOvcY8AEg2J0pE5d377NWsFamWj8v0zJjbYMN2j8PjhK8WH2h
         Pe+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2U/4HYKnAZR7qNMIeDCg5S//595luEluzFk14uv4gBU=;
        b=ionHyyM9CnseIuEMYyjPNn+sKtF1uk6CNVKJV7rXm6K6jci3B+gY7ReBf2hWSy89+t
         ZQPZnuvEMFLujnduFSNmpjRl+MWKW/p7+CBe1Zb6QNvJ3GZYlVvRiAcJYWKwaijbJo5V
         ajPogk6Mi5C8fcKA8xwiq4XsEiBu9N65MRnqoS45wanreVH+AdSmpzy9KXR76a30LAkG
         /3xmL8pj8T6pGrHA15icqh5agCXI0WJYEOEAEXTwhneO0z72id7gVMqDhUtgcpNsCjtB
         y6t9ST3arBH/DoAnPGsEOof8WXBOPqCxpZP5DJM7b3VPLhsitDs05KMGftW2i+BAGzBp
         HCIA==
X-Gm-Message-State: AOAM533fGKi1VRaSwDFm3h5yauovTVmzzR53wOYbOQnCv/9B546Y5+H5
        v0Nprctr67Wgy8u9ct7LSfXXuYSAKdx/8/6i157uWw==
X-Google-Smtp-Source: ABdhPJxOTsb7kpZ1mbQBZyHvrw/GjkoPNdlC1Mnmi7QTa5v33P77eZ447VYbGdz8Hsj3aBiYzZhGTejFWOktm98P3BA=
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr1505670pjb.220.1637342480174;
 Fri, 19 Nov 2021 09:21:20 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-2-hch@lst.de>
 <CAPcyv4ijKTcABMs2tZEuPWo1WDOux+4XWN=DNF5v8SrQRSbfDg@mail.gmail.com> <20211119065645.GB15524@lst.de>
In-Reply-To: <20211119065645.GB15524@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 19 Nov 2021 09:21:09 -0800
Message-ID: <CAPcyv4iFG0n-vdaEi4h5ken6mPrgW6Kz6UXCTRfaHi-c99GBnw@mail.gmail.com>
Subject: Re: [PATCH 01/29] nvdimm/pmem: move dax_attribute_group from dax to pmem
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 18, 2021 at 10:56 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Nov 17, 2021 at 09:44:25AM -0800, Dan Williams wrote:
> > On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > dax_attribute_group is only used by the pmem driver, and can avoid the
> > > completely pointless lookup by the disk name if moved there.  This
> > > leaves just a single caller of dax_get_by_host, so move dax_get_by_host
> > > into the same ifdef block as that caller.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > Link: https://lore.kernel.org/r/20210922173431.2454024-3-hch@lst.de
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >
> > This one already made v5.16-rc1.
>
> Yes, but 5.16-rc1 did not exist yet when I pointed the series.
>
> Note that the series also has a conflict against 5.16-rc1 in pmem.c,
> and buildbot pointed out the file systems need explicit dax.h
> includes in a few files for some configurations.
>
> The current branch is here, I just did not bother to repost without
> any comments:
>
>    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-block-cleanup
>
> no functional changes.

Do you just want to send me a pull request after you add all the acks?
