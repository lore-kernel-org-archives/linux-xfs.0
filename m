Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235C0C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 17:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0586561269
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 17:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239368AbhKQR04 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Nov 2021 12:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbhKQR04 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Nov 2021 12:26:56 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA12C061764
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 09:23:57 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b13so2787088plg.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 09:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B1Ni0fagjZGByTTcZKwa1vZXhbm3ZKX3g7qTKHJy/9Y=;
        b=ugoMYNkhm/G9Ix/5oCvQZm0YAcysEe7w+8Ut7tdQ1MFfrFb++jT//Ye1Xif9z6ocKL
         upYEOlPYxRg426dSTkVWYqWTkYaINK0U1vjW0pz5KiVAdk24VzI9knnC+oq6VqBtR51R
         JsxZQwr6hfjAqg3NR5DXPnxzqFiDdVPzmokHwBWYbFcA7C4C1b/5vK2dlQpMEeU3BunN
         ptnIlMbRnCC/lX9LzDScYnrYijxgLzkCxo7ONiPawkK0khOy+cYFezVV1WUfTrdZx19A
         ia0nC0GD3aEx0ZtVWJVu5+3TyvxHmXgSem7quozm86z+iCZ04tmZvCRneUg4q76UfdBV
         iVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B1Ni0fagjZGByTTcZKwa1vZXhbm3ZKX3g7qTKHJy/9Y=;
        b=XRLbokQ3nqcVBmMad1sWW30CwM/xJC8jaIlkBAgx9HHHtpUv98d1DU4SMq+eypRaZc
         /jcKVFqnybsQ9Yaek1AoxqOIUdG1jlK6VpjaGngvKAV24nLDnEZLoIL3QHcSPCVnskNM
         4eKBdSGOpYYxCtsyv1IR2U5Q9suZNcvA//ALFeL2YMBc51Igi574O6YzH67QZ7sxqM2f
         FmKorAwSjMWATnIGooyxRI7KvpZU7KJ5EjVRpWm8ZXfE9kPec55BKnUR0W4oPr5lo32o
         chQ1LonvomvFDnX9HTCoIgFOWHDD+DJqOVNTtOYF1z1ci7c4eK9qSO0PFAuNxQeBTbWN
         /WfA==
X-Gm-Message-State: AOAM532a0AOkHuRCwFygcNACT+5mrHKRduML9AAPzVm9mEhztuQwtfG9
        Qoq6RjVfN0255qZuI2kBviIV2G1QIA/MJc+F0S3sjQ==
X-Google-Smtp-Source: ABdhPJxkIf4IjyDIAL/AOyg+wZo8KXg00Li3POnr9FoL4MtTk7+2uk0M9RLmtvaFQhBaLJ5ZjvKGrbUA1Og0jd55rz0=
X-Received: by 2002:a17:902:7fcd:b0:142:8ab3:ec0e with SMTP id
 t13-20020a1709027fcd00b001428ab3ec0emr56745818plb.4.1637169837229; Wed, 17
 Nov 2021 09:23:57 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-3-hch@lst.de>
In-Reply-To: <20211109083309.584081-3-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 17 Nov 2021 09:23:44 -0800
Message-ID: <CAPcyv4iPOcD8OsimpSZMnbTEsGZKj-GqSY=cWC0tPvoVs6DE1Q@mail.gmail.com>
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

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The device mapper DAX support is all hanging off a block device and thus
> can't be used with device dax.  Make it depend on CONFIG_FS_DAX instead
> of CONFIG_DAX_DRIVER.  This also means that bdev_dax_pgoff only needs to
> be built under CONFIG_FS_DAX now.
>

Applied, fixed the spelling of 'dependent' in the subject and picked
up Mike's Ack from the previous send:

https://lore.kernel.org/r/YYASBVuorCedsnRL@redhat.com

Christoph, any particular reason you did not pick up the tags from the
last posting?
