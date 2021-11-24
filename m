Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABC2C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Nov 2021 03:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbhKXDzd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240518AbhKXDzc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Nov 2021 22:55:32 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A57C061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 19:52:23 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id z6so750184plk.6
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 19:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6zOlc/LjY/38MNl2fNjkOvdM3xFlyfeXQW77bsVPs7U=;
        b=lAK1cPsbcZgDOnzv+wRyX5hFeuNtWn74alyzSOfh2WTiCK6b1Gd9bfDzl0+LSFYqBx
         NFA78tBSHfT8IWLc76OROAypo1vlQiiVSp+deqPBmSErFfOP18cWXFbnZCxI9VIMHHuR
         rkB6XFn/xh99StS9siD+gMovD+TGGHheUMxQDm6Fs4TRxLl6LVPgdXFahdYzrs2kgHk1
         2vtAqiLmzKNsso+noEF/MbJXbTSUoUVvNEOcLZD7XraD8UxaJOkOnpqbEwEn6rei4bjJ
         t5MvTN9s/WuPOzLWfQKYxVJtbNdZgfs/23Dfq3WeRbXM/0WgTMF9HeylQ/9xSVmw3Fc5
         g5XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6zOlc/LjY/38MNl2fNjkOvdM3xFlyfeXQW77bsVPs7U=;
        b=1ydWCaqR4PWzxOsS4D69OyDVnOEDgwk6eAr5odnEAK2kyUGtPHMa4BcRGPAV5Rjfr0
         YnTQD1UN5egG71W/5M1G+/OlC82S4q3fGSP3kf9ZDFEV7ds/BZLH0a68L0T7RtyXcQ8a
         Ti1Pb69/vH0zHA6qAOZffh4ShDA/XOqlmk+o2CUSqx2rn5q4WK0ZscV97eQviHxjr0/C
         vRskhs/qPB/5fxJ73SK98veUjjxAxLcblr4lbGCNW0KHuyUPU6sX1KT6tN/QwwVtfhSS
         qVnKwuSNjtjvWre4rFlMoq2AXtgeigGhP4Y+6pN4L068LsqiTCx/hoHrvVv53Is0OBWz
         lfuA==
X-Gm-Message-State: AOAM530Denx5suczQIlnAqzDZEdKbwc0uci/s8ew/hmGnCgvjuBJ/N1t
        VpZZ+CrRR9oXFJmMSznoMiH1+HUhU5EJq16n4I1ELQ==
X-Google-Smtp-Source: ABdhPJymXNtj/xuoHYk/qKEwmz57TlRY6ykmrutCD2G8CDlG536bSV07F4JpqasRcpvkUcp5iE8OReW1Fq5UwnxXf/0=
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr10703847pjb.8.1637725942362;
 Tue, 23 Nov 2021 19:52:22 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-30-hch@lst.de>
In-Reply-To: <20211109083309.584081-30-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 23 Nov 2021 19:52:11 -0800
Message-ID: <CAPcyv4gNH1ex_6+pHmpv_pWGV8H8KomzWFtfMvtntNe++x8OBA@mail.gmail.com>
Subject: Re: [PATCH 29/29] fsdax: don't require CONFIG_BLOCK
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

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The file system DAX code now does not require the block code.  So allow
> building a kernel with fuse DAX but not block layer.

Looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
