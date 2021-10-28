Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999AFC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Oct 2021 01:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85B0761184
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Oct 2021 01:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhJ1Biu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Oct 2021 21:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbhJ1Biu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Oct 2021 21:38:50 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92A1C061767
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 18:36:23 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id m14so4423570pfc.9
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 18:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h7Igm7cptJn/BPiAKOvXNcYjYvau2fVkwbEBPR40Qac=;
        b=nDN9pMycEij+MvvSNlzKvOXo8vpzX9jkSPwoFJ+o4gm3MZL73HDZVz6xJnzjMcbY/h
         uxqb8I8SZcSxzyFyBYzX7/LIRnqjurLkxyKCXt7vyn4OmQMNyDT08nPuKyqwzm30Iyl3
         YY7ptNRp5CFdB0o2rG3ZcydKtS+P5TBWxjp9noe/kCn6hPByhWq1BSGoPPpBqB7Delwx
         7OpBf+W0FVyg/SVq09iZbg3g6KwhgjDGpF6ftYJKhyxVAQrctr7Lax8JbvRVtA2fECbQ
         ljET309ufBhSYyMPecwX45v0eqgX6tTFFZvO7U3Ppi7VtOy0tKDgD/ePUmL2riKDB8uo
         7IaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h7Igm7cptJn/BPiAKOvXNcYjYvau2fVkwbEBPR40Qac=;
        b=S+RA+qpHSjgQvtjnOaXtLXrN9E83b3q2AnWuMLR7oT9NgfB08aRhEGT5fOSDc56Xbm
         6gOt4qi1/T4tm0V6DLQlCHOZgzYIu9lH7Det5/b5dDNlmL1WX+/C6hN22wRx+Y+4XJsx
         lHWzZ6JlpyUixZOMiC7r5RVzSAw2iw0sh2rBpykP+W9B6A61U6wm23T4W7EKTZymoWt0
         31zoFPQYTtk3362TueCb2mB4Fr1+LCqsKhUrIENTn1Af0ghFQSKXT3dBKjhkr1szvjOg
         D9KDg0AKso00+DjmfGBeUv1EUlZYMz1/lKgbddpwIvjoH9FaW8Y10rh4QbUTtLMmCIUn
         JeYg==
X-Gm-Message-State: AOAM531k0IZpd0O8XcQdd6Vb6ZX7Ui8wvEm2K1omR8yRdesq7YO6glK2
        0di+2lmO11lXbbOTdxjwFpi6IbmkNmTyGUjwRlYmwQ==
X-Google-Smtp-Source: ABdhPJyDv7rjKjhKzGrFppXBu1eyKYCO/S0EEDW+vfLySK20rv/agORLXNPU8PUP/nGzDZcfnIyFx3qV7wWhC+ogeBA=
X-Received: by 2002:a05:6a00:140e:b0:444:b077:51ef with SMTP id
 l14-20020a056a00140e00b00444b07751efmr1317245pfu.61.1635384983516; Wed, 27
 Oct 2021 18:36:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de> <20211018044054.1779424-10-hch@lst.de>
In-Reply-To: <20211018044054.1779424-10-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 27 Oct 2021 18:36:11 -0700
Message-ID: <CAPcyv4iaUPEo73+KsBdYhM72WqKqJpshL-YU_iWoujk5jNUhmA@mail.gmail.com>
Subject: Re: [PATCH 09/11] dm-log-writes: add a log_writes_dax_pgoff helper
To:     Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
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

On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Add a helper to perform the entire remapping for DAX accesses.  This
> helper open codes bdev_dax_pgoff given that the alignment checks have
> already been done by the submitting file system and don't need to be
> repeated.

Looks good.

Mike, ack?
