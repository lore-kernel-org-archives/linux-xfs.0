Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685AFC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 04:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhKWEGB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 23:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhKWEGB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 23:06:01 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A849C061714
        for <linux-xfs@vger.kernel.org>; Mon, 22 Nov 2021 20:02:54 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so1015538pju.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Nov 2021 20:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g/ky7DkMfynxz93Jg1Thyokk1eZpzUf1Xl2rDhRoyWA=;
        b=sflh6j00R53ITli5bO2IoAwQaIa8VR/tllaujepF7nQ0McJ6iT2CSZUK7BuB1zU6If
         9CwhHY4WZipWFFT6wSgL9NXJHKzpWx4dzREV1QewVHPXAfe3nZ2ge9ayabqAClcoOtMT
         6CWsvm27gk7VLVryyb3GQ4RxleOrmnBmuKNS+T6GLom6VfHHQqPk8G9iMZiGpJfXA6jD
         WtPXA13msMgztdGrXOYIM1Tv6bLvkl2kjxHbaH2u8afmQwOPoz4TylpBWUlzjs7RiwZQ
         Q7dRhRXUS7ma5L6pdFg1NOadjevEswoXcEKlTQmOlLvpZ8ukBNqCZ65Zu45i5yf8msAV
         Rrgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g/ky7DkMfynxz93Jg1Thyokk1eZpzUf1Xl2rDhRoyWA=;
        b=aLIKq2YhNkrAHQ+8UCWD9VIjOan4xF6rbB0ZNSnCxT03x6he4oDv5CCfmNFKw1zTro
         ulpx0rFhii/Z11C05QdfP0q/5HqxQJIQfuY7rm90PEhpg42D0+zLAUdzwCcVRplFvrEv
         JQdk+HToGKPx0/iDfAr9ZSUJVx2xAgTeQflGXmiB1akO2dhAbLUMaJ2kAL6ksFzvQbJc
         gq+Sy87VK5c0Ww/11eVIUZ8dkQH9bnH4KhT92msTulg6BuVdtlB3tXXgCF0vZWWRM+DV
         +YVz8aKM/ySEQLfRDvDtW58v3Bis3gciCh6hY3b+N7tS04xCRLqiKrOMMu85qzNc2SOq
         dobA==
X-Gm-Message-State: AOAM533wLq8+6c6VJwaF8flt6keKT4wVEnA2xHFFtFcY/cKCBo8d2Lm1
        iSGXCzlB/ZI936e7bsZg8IPswMYCGNbBqljFnyrKcFSF10f7cw==
X-Google-Smtp-Source: ABdhPJxvSLmX3xye88c668D00uWDdnnCeZiY99i/tpK8E6hWm4PH0+Kg/6cCj46QhqqZS8+/hIjz2nKulq2NhEFbIuM=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr2663610pjb.93.1637640173575;
 Mon, 22 Nov 2021 20:02:53 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-11-hch@lst.de>
In-Reply-To: <20211109083309.584081-11-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 22 Nov 2021 20:02:42 -0800
Message-ID: <CAPcyv4hUSRSVBP_G6z7fPUwvb=3F2q4mrGhmD9A4nez=DrEdWQ@mail.gmail.com>
Subject: Re: [PATCH 10/29] dm-log-writes: add a log_writes_dax_pgoff helper
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
> Add a helper to perform the entire remapping for DAX accesses.  This
> helper open codes bdev_dax_pgoff given that the alignment checks have
> already been done by the submitting file system and don't need to be
> repeated.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Mike Snitzer <snitzer@redhat.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
