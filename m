Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8318CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Feb 2022 22:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243930AbiBOWMA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 17:12:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243922AbiBOWL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 17:11:59 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257052657A
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 14:11:49 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id qe15so522916pjb.3
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 14:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dg8Bbqo8xrTURRSZr1gbJA1kXH+dR6Cfw/CPc1vh5OA=;
        b=JWDZBiIvBXJ+xyw/ssMlbLaY+HL0dGj6fRKKopQM/zAdOrPiEpBBbN0hIHBWPjTwv7
         phWt006J1z/OGnlE0pZ1IAr4MBG61MAESVtMLCJJLdN03Qgw5ph3ybjNDcm5KLD4H/Bn
         dWXl2k4tg6j6b6r3iLke/JjQOqtAWGhWjmz+5X/AmIsbrRbdPwocCDW6gnbjWLV+8CGP
         6XBgMZj2Vbtv7WovHLG8U9O+XTiFW1Esdpsq5PDNf7YwiqhlubKB9tjZcJrQw+cD3SxG
         3OYRHWmQVG+2jcAaW9y66JUIwQHgJwy+IQgpES3zBB50Hn7Ps4/BtqJ1QikahSxmXMbV
         ZLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dg8Bbqo8xrTURRSZr1gbJA1kXH+dR6Cfw/CPc1vh5OA=;
        b=EzjdnYgLc4wVAp8MrBXjijIZQ4yiOd31WQrX/OSSbPigwiwUyGDrZ0S+Ca8oSwF8aI
         Nzg6OC9hEIP/nFQJcGU0v0snZSOnRMGp4Xs/W5Ljg/I9rH6iP8aV9j14UIrX1aKy6XFs
         Lhjq8SgoknhUiTQ0w5gdomoiJs0NwJB+SkQBUPa/0tjRgKv/IUb+djYXFYjIL14PGH+W
         pG7ZbQ/tk+zYTzWDj8JcARPAImYeh2oI7Uojefa8fpKh/Y6woFuJ5q7n4K36WlaW4Ex9
         +oADTQjr/7MqGgHFG1B67XM0vqugstkhzi1SYyuUtgxVTobwp0lT5iMF4d8MwzOXXfSP
         ZC+A==
X-Gm-Message-State: AOAM5301ms43tDBGZcFnCT0seg/u9H3wuyPJchgwVmVwRxNTkj8mmDgM
        +jRkneaToRHL94XGnl+HnKEpKJnmM0tnjIGoUkJ5Vw==
X-Google-Smtp-Source: ABdhPJyiswDhX6qkwwQts1SFepTHj/P5w6WGlYQlgTjrpG3xns33VOfe9EvdjD9DCBoIscPBLRLRybo05bZTeUzOoys=
X-Received: by 2002:a17:90a:e7cb:: with SMTP id kb11mr1046139pjb.220.1644963108677;
 Tue, 15 Feb 2022 14:11:48 -0800 (PST)
MIME-Version: 1.0
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com> <20220127124058.1172422-3-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220127124058.1172422-3-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 15 Feb 2022 14:11:42 -0800
Message-ID: <CAPcyv4jMBm3ewWeQX7eZDaHT4aD8eOPcxYBiiZT1ZmaV9z-A2g@mail.gmail.com>
Subject: Re: [PATCH v10 2/9] mm: factor helpers for memory_failure_dev_pagemap
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jane Chu <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 27, 2022 at 4:41 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> memory_failure_dev_pagemap code is a bit complex before introduce RMAP
> feature for fsdax.  So it is needed to factor some helper functions to
> simplify these code.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
