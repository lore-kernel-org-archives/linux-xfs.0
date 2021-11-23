Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2573EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 04:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhKWETU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 23:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhKWETU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 23:19:20 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02E4C061714
        for <linux-xfs@vger.kernel.org>; Mon, 22 Nov 2021 20:16:12 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so1036931pju.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Nov 2021 20:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g/ky7DkMfynxz93Jg1Thyokk1eZpzUf1Xl2rDhRoyWA=;
        b=wbQ/MsU1SlEZ9iPye0o5lHnBo9k9LahEnJdnyRzgTrQak+nTOXkgXVWM7OQWluPbzr
         HkVEy2FdigRG5kYOuK1opEJwN/rn7TguLqcAFU7ncMwpwdXChRFN2sqd+bTf3F8BInaK
         fFwg0qsn775RNQiqooEO5yKgWsV+2wtj+cp01Q2NasJFqL66eojelACeKHvYSEfu8Xag
         ROr6vP/wogp7HYAtlyseVafxuCM7Uz2wx46f9H1VqNuffEtgZng2NeCkac5Ick13DKCh
         KqqsG7JaJle4G2RoQ9CsAKmA2/ICYEEBHwUPSN/D+pEwjOibiGCRqmiwftUbhvO4xY/f
         BPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g/ky7DkMfynxz93Jg1Thyokk1eZpzUf1Xl2rDhRoyWA=;
        b=dxl49Cd/TbutfU9ebr+CFrQSUC1xaOUqTWiVLb2jLpxsjMM9EN1o6aw4LExDSzkcjh
         ttPjG94PcND7B3kBcrrbqdwH5sEAUPoCQd3S5oBOVl3jBu7cNFLYNYnUMhSxJ4Qx7hyW
         sUl78R9AnBAzAX5ANs+4mFyhnTfwfXtyMqWeGhG0HI2U93w1DLLXpBnQZk25CoAn8NF1
         cvyVtRdNt6wh2hm66Jt4MOKjLzoA6v+OZ+il3sn4mf+ruVxSqvdNd5ijaROWjHLdDAsL
         vK1205+N0HE8sBgnBGoJ33XWSG65qD8khTH12Jgs0C5aoqqpR3nWVs5OrMFiIrzuRpAo
         A3ww==
X-Gm-Message-State: AOAM531Ib9m1onPiVl48SUqz987yo2pL32cYRTIlU8ixq/XA+5zpaUf/
        GuPjHt582gTeHH4ddy0FI2wQl+qWsBGqs6Ch5RXaMg==
X-Google-Smtp-Source: ABdhPJxjpKB9AmBnKHF1Qu0JurlIqhEs9/usKwuqw/rWaPu+iQDfW+wdKRq+mST3BpRIgHuCjkJcQHKsTKAjjneenA4=
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr2831805pjb.220.1637640972493;
 Mon, 22 Nov 2021 20:16:12 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-12-hch@lst.de>
In-Reply-To: <20211109083309.584081-12-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 22 Nov 2021 20:16:01 -0800
Message-ID: <CAPcyv4hG7npC3K-5th7qFNHuNt=dT-atUwvMEwbH_DHqzVhi=Q@mail.gmail.com>
Subject: Re: [PATCH 11/29] dm-stripe: add a stripe_dax_pgoff helper
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
