Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C7DAC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 21:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbhKWVTM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 16:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240371AbhKWVTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Nov 2021 16:19:12 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A001BC06173E
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 13:16:03 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id iq11so541900pjb.3
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 13:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l+zpQrvL4Qxe/qyBBz6nO1x+ZudVJHE22cDmvcF/TOE=;
        b=3UTjzt/B58bzUMuj7IqqMnaCu5WYQAV5rK+fs5kaCfP78gUwTgy5Zlf3Be+wmIjr56
         TnFB+KlAOrzucg0BEhVOP/JXfiAUD2ftEQJXj4AikeXTgWe03Spusb/0TUld0hhFX8v6
         hoRoYhcMIe1fJGrizIl0u8fu7pfvZl0yQ6G/HZ/XblMR0kOZLIsIbaNzfqww2OtwK0QY
         M2kpeuFwFxk8ZGruQVPxMGdqTXvMTUs/jjMoa2NVuNjPrbZJxiRI6LrTQ3lIM/koJIif
         rP8I79qIKGLZ1fswpluH9sZNHRVBAzv8KTrCcmchw/ruDBCNrZVPKtgfRhQ9/KytnoiJ
         mPYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l+zpQrvL4Qxe/qyBBz6nO1x+ZudVJHE22cDmvcF/TOE=;
        b=DaLUnYPQgduQSIs6OH/9mI0zNzHWVj2hB7/lk+ea6pfGtL8k3ckGaK+IR/QE7rCX+m
         C5arghmk/Vo8Lw5DUm16TCkk3VC25q0tJ0nO3ZpYLZXFQcFQKviCAQCtPkzJvAAZXqm6
         gxyIIEkkc0vQQPPriQZ/BfiptDsDpquFiPvB58l7THk3ho5CCEPM6dkAGMDnkhewLnO8
         8Dpt25/8CrCQ58jSPrkKMjrY1Gbmnp9bFkWhIJ3f4K4gb0VQkNGgBrBzrT1Z5LDfgTPR
         2V1cM5Vs8NZ6Gbjadv1WUKoqyHHTKWd/xo45/2srzUS9xL+XLMvJzcLAIxiJD4i/SCq+
         pxxg==
X-Gm-Message-State: AOAM533GnuDbzLl68ivyTP/EbQwZZhW+wS1GeNAUYlQlZCRgN6AeB/Wr
        ZZaB4g7UKdti2I/ya1ahrK3aZFDgerUgNRm94blXGQ==
X-Google-Smtp-Source: ABdhPJxRRlv0NZQorv0M5t2wTRvBAaxVZY2wmbRu89506wlORAkd8KhXvCTyC5EAm4rzXSOWToX/mEdJ14fdPpKfw3k=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr494044pjb.93.1637702163126;
 Tue, 23 Nov 2021 13:16:03 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-16-hch@lst.de>
In-Reply-To: <20211109083309.584081-16-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 23 Nov 2021 13:15:52 -0800
Message-ID: <CAPcyv4jDqfNj4iAYoewj53QEZjXR41UuE0LN49CtC_2qjrbazg@mail.gmail.com>
Subject: Re: [PATCH 15/29] xfs: add xfs_zero_range and xfs_truncate_page helpers
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>
> Add helpers to prepare for using different DAX operations.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> [hch: split from a larger patch + slight cleanups]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
