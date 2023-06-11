Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBED6C7EE2E
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Jun 2023 23:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbjFKXBZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Jun 2023 19:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjFKXBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Jun 2023 19:01:24 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CD2A8
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 16:01:23 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b24b34b59fso26407945ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 16:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686524483; x=1689116483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pmXtFKv+JfRkhcGq7fz8ClTYm46WX60n74yc/xAaEJY=;
        b=Fv+4VaC6ZUyyjmoHvwB12jiKADJruZtfnUq6sgMEJVRkrKmcSAWzdB2KTl2CGSt9XP
         MPK0vi3Ebs1KaqJQrTbml0FIlljcG7BYtfG/BlCAuu+SnFDEkMT5vNouwFzU1+V0gYnD
         91HgT7Z6BkoxHxbRGTp6yzSMPPYHY628pdbEbcy3q+UhfEpi6EOXkoYkoDg1MgQZY95b
         vu68Ue36rp08RZ4Ofo7MczzCSbkQ8itPiajEHo4tFXJzuKSSzIjiP0aD3x/iXdVPBOPe
         ufO+xOq2XhyvULsjzB0G1eUf+T2ofo798caImTHlFUTaFcLyVxDKaWl9vv/NIiIVlVeg
         aaDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686524483; x=1689116483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pmXtFKv+JfRkhcGq7fz8ClTYm46WX60n74yc/xAaEJY=;
        b=Vp9fiDV66DEwYHyVdT58Pt2Ii50Rn48vUdp3oVYy7c5WXFz9VcZ7xzrkBDtjfLDsuq
         uzSGhWxHDElGg92smXTDcN+bgV5HIgkVRCFM0SCC8cEEbvMgqC5aegot2I+8ZSf2VvCO
         Vq5vSCphMdSHv4QA6Kv6NIBJBv7AQBMMIp+14NsXHBeDDIbChWV7DUUQWxFUaJbd5zBJ
         PKM165z3k2WKNk7qDccrz7c3OHOTTRQfZihTekZws0DMDi82Bc5+LbNz3h4CLly5NvGJ
         HG8RWUJ5gXKOB2yS5fLXTK8nKUUH0MpUYpcvIbMKpdNDE7iTBeeVc2MA+sd/E69lgBRQ
         +N4w==
X-Gm-Message-State: AC+VfDx9sMRMVmH8Ileja4LfMPxn/E0G7B5VIgUKM8RWrvF4WxYoXUuO
        Mt3vlWTGFyQ0VyAR8MFEzxAjgw==
X-Google-Smtp-Source: ACHHUZ7TVH5qtRN/QrmMsDplYCjyXIy6aqDjfZz9edEg7L7IMMxZ4MWmE2zM8FltJTxItnyh8T2tww==
X-Received: by 2002:a17:902:6ac7:b0:1af:d724:63ed with SMTP id i7-20020a1709026ac700b001afd72463edmr5354365plt.42.1686524482661;
        Sun, 11 Jun 2023 16:01:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id d12-20020a170902654c00b001ac4d3d3f72sm6885730pln.296.2023.06.11.16.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 16:01:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q8U3j-00AeZJ-0i;
        Mon, 12 Jun 2023 09:01:19 +1000
Date:   Mon, 12 Jun 2023 09:01:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug report] fstests generic/051 (on xfs) hang on latest linux
 v6.5-rc5+
Message-ID: <ZIZSPyzReZkGBEFy@dread.disaster.area>
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 11, 2023 at 08:48:36PM +0800, Zorro Lang wrote:
> Hi,
> 
> When I tried to do fstests regression test this weekend on latest linux
> v6.5-rc5+ (HEAD=64569520920a3ca5d456ddd9f4f95fc6ea9b8b45), nearly all
> testing jobs on xfs hang on generic/051 (more than 24 hours, still blocked).
> No matter 1k or 4k blocksize, general disk or pmem dev, or any architectures,
> or any mkfs/mount options testing, all hang there.

Yup, I started seeing this on upgrade to 6.5-rc5, too. xfs/079
generates it, because the fsstress process is crashing when the
XFS filesystems shuts down (maybe a SIGBUS from a mmap page fault?)
I don't know how reproducable it is yet; these only showed up in my
thrusday night testing so I haven't had a chance to triage it yet.

> Someone console log as below (a bit long), the call trace doesn't contains any
> xfs functions, it might be not a xfs bug, but it can't be reproduced on ext4.

AFAICT, the coredump is being done on the root drive (where fsstress
is being executed from), not the XFS test/scratch devices that
fsstress processes are exercising. I have ext3 root drives for my
test machines, so at this point I'm not sure that this is even a
filesystem related regression. i.e. it may be a recent regression in
the coredump or signal handling code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
