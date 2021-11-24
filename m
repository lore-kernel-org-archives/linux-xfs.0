Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1053EC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Nov 2021 02:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbhKXCw3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 21:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhKXCw0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Nov 2021 21:52:26 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8986EC061714
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 18:49:17 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id l190so783816pge.7
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 18:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w9SdtjSRKyAYQmT41K4AZZGwYb4w19IPMcYn2fMN2dE=;
        b=ic6A7wlPP4NKkUtI3F1gI85ivlPVa2/lSDRF8Q7wubnSu6f7h04uQc/NmShkxWWq1R
         5YVX5PyQS6icvNDeSu+Q5SAFIyD1yWrEohSPRHGAM0U80r/1UVrc1M5tkOzbuMom4O54
         1FLUzZRSXGaQAUxBGkDtbRBlcgI/X1q34NCzbxL0/h1k+OT0m2DEdJxNf5uYBo+yQUWi
         tmtbKwN0VhChOm0hu6sUiBfGI5twjAA/MYoygg7APmhPoWaH/03oMqUw/a4XtP1nLkRy
         COKRo5xekU2xjc7aQKQeECLQQpxXtktld4XRoPYuhnzVfHtuR3OjCxP0rbhzS8FBgJxr
         bd0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w9SdtjSRKyAYQmT41K4AZZGwYb4w19IPMcYn2fMN2dE=;
        b=2q3tEBmKJLF0EWrQ7uIuIsZE2lcEyHYk62Lh4JyjLAwCRGlrTZkwOJImdil+Vi06RE
         bg7S4U7IsO8kt/CChUu8BG2lEtpl3PYuhxY/1ExMY1RsnP0/fl8y6By4xvGpDtT1fFox
         qvqu1kzHJlbzAu2IqjtSpc4eDe1mE62QdPdCCtGP+rdh+JiTwTT+TopQiR0VSQod1Nxz
         snEXNNTKELidmySQgGhCfkvTeVe5ynoKIRulaD2SaGV2eZVpshth/fdkNif1YPUU0MaN
         nXrbQ6O5oBK+gqlVdcFLepBdpcFEToKcmAwFxUa0oZMrhWjSNCibHRMZAWQEP0BoH9jw
         S/TQ==
X-Gm-Message-State: AOAM531oPSwLPRVNjTfEOW8j5d4TTPIDQQlqR23uJQMaV5hoQwX8sazx
        gsAh8By7Z8Mh1YcnFbQF37sgIz78tLf0NbhebuhJvA==
X-Google-Smtp-Source: ABdhPJzS8LHGzaz1OBnNTW7y/EU5nRSgH9NtL2R6nqEjsoFplqiXZU89WIILPbZV7BRWoAlxpdKj2qQGIACFTFGS2MI=
X-Received: by 2002:a05:6a00:140e:b0:444:b077:51ef with SMTP id
 l14-20020a056a00140e00b00444b07751efmr2420437pfu.61.1637722157095; Tue, 23
 Nov 2021 18:49:17 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-24-hch@lst.de>
In-Reply-To: <20211109083309.584081-24-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 23 Nov 2021 18:49:06 -0800
Message-ID: <CAPcyv4gVTAddA2cGFKgt5yJVTozxfQgstj3kicZAk2mZX+E1Og@mail.gmail.com>
Subject: Re: [PATCH 23/29] xfs: use IOMAP_DAX to check for DAX mappings
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
> Use the explicit DAX flag instead of checking the inode flag in the
> iomap code.

It's not immediately clear to me why this is a net benefit, are you
anticipating inode-less operations? With reflink and multi-inode
operations a single iomap flag seems insufficient, no?
