Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A38C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 02:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhKWC52 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 21:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhKWC51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 21:57:27 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD4BC061574
        for <linux-xfs@vger.kernel.org>; Mon, 22 Nov 2021 18:54:20 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u11so15802963plf.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Nov 2021 18:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Al5JsM62A3tHtpfVSPPyo8ez+nZ96myx/BqVadpnmZE=;
        b=xC+R2Ze1hcDaIg+74cuixxadPvoKZHVUfRh3cG7NL6liGTAKRC1u/dtLV2Upl+DjCb
         lz8tF4p8hd5xqtUPL0FFIN4COIFn8gNO0kZEDg0AZkuF8D8jKwc0aEvQ7rx69yXQ0Onu
         ygsv6Lso/1XQ2tNifMHR6wKXy6FdeML5mJLZDRvnaAHvQPYqIVreOhkxmGyxQPa6SI/i
         eitCea7WNPUHw+NWqm+DDMhFpduBZks6zZt+EcfeE8ME4X0s0nFvXWdxr1dRMwydHs/r
         NeInAl4EFa9zlunOlALEVrXarilVx4ntLaJRr9tg/Qn0MoP7TxRpqBu+w38vRZVF2hEy
         GCPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Al5JsM62A3tHtpfVSPPyo8ez+nZ96myx/BqVadpnmZE=;
        b=lCkOFEUReWkR3EPSa4QpDPrAF/UPtZTSFy9yGJ5Mz5AxNQTrYrU7X/yO951iJEDdpo
         z2CEemMYn8xeUAL0/u/UTDKU5K1XH0yFepSiPrYLlR0kp7MezVFBolah7xaBmqQyA9XS
         FScBrVBGPytLOtvDGprfGbg1iS35mLgRKo9rxmEmNu/EsY4FmeE/6b7VH3VqN1jFxB8a
         B9ZYAtXQe6wXaNGwUAv48mzFna1VKJ35HwnL1It8ZSoLF5B4o26skGqiCCJsko2hM+T0
         EXQ3cOD/2jsZaBhsO6b2Z++Vwl1E0v4rbYrtDc9Pf0PwSdIUeICHfsOlnBGPqeoiT4N6
         z5vw==
X-Gm-Message-State: AOAM5303/cI85XddjeOHLBls2bJR3Sg2eWfTjIgkXwMThmGLRifkicq5
        QjH6mHJxyVLdjrnKlfo58NGUcSag69G7b0CZun1lXvcd4Lk=
X-Google-Smtp-Source: ABdhPJzVmbqwkteuXJ4hKBjAQTD1mqO5WV/z0skpRbQzjFZ3o+tEVCfuAJYtWwfPr8oZjtyH1KqF3yLKCjaZBtlyJ4k=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr2220703pjb.93.1637636060294;
 Mon, 22 Nov 2021 18:54:20 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-3-hch@lst.de>
 <CAPcyv4iPOcD8OsimpSZMnbTEsGZKj-GqSY=cWC0tPvoVs6DE1Q@mail.gmail.com> <20211119065457.GA15524@lst.de>
In-Reply-To: <20211119065457.GA15524@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 22 Nov 2021 18:54:09 -0800
Message-ID: <CAPcyv4iDujo8ZZp=8xNEhB3u6Vyc6nzq_THGiGRON7x3oi9enw@mail.gmail.com>
Subject: Re: [PATCH 02/29] dm: make the DAX support dependend on CONFIG_FS_DAX
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

On Thu, Nov 18, 2021 at 10:55 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Nov 17, 2021 at 09:23:44AM -0800, Dan Williams wrote:
> > Applied, fixed the spelling of 'dependent' in the subject and picked
> > up Mike's Ack from the previous send:
> >
> > https://lore.kernel.org/r/YYASBVuorCedsnRL@redhat.com
> >
> > Christoph, any particular reason you did not pick up the tags from the
> > last posting?
>
> I thought I did, but apparently I've missed some.

I'll reply with the ones I see missing that need carrying over and add
my own reviewed-by then you can send me a pull request when ready,
deal?
