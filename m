Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE5DEFA3740
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbiJ0VLU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236892AbiJ0VLG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:11:06 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F87296218
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:07:06 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 20so2830586pgc.5
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ESZwImWNJRFfWy12TZN+RNhNp2YvZKVY9HTDgpLWqk=;
        b=Gcjlnh9/ArweqpHqBdRsxrcRtmf6Gbh4QzML5xlQKwDqkCDvBzX4P642GoSUfB/qFj
         +S0k+8z8N9yt9IPqiVkUoqenQ/GyHtREn7wxCudD6LmtrE70MsBZsQouh09O4WXP3ao4
         UhYG6SwSm3uWdUGle19AkTDpCHb8CYlAS3rO+k2yKpBpD0cx6L+rf8NL4L+NDXNP8Dep
         jgteFFBFQJB4imAwEzs0aBdyFwzQQ2D0EZKGBg/aox4ZnMeftTm6X3yCuR4sikOMNF48
         oQ/2EFWmhKmhnk2KJlVFIMQ2zuBTHqedueYim5UcaiqV9Zto/UGvSz4cI8SYUPTTKSRg
         OnHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ESZwImWNJRFfWy12TZN+RNhNp2YvZKVY9HTDgpLWqk=;
        b=f0Dxj36cAxVSzrhBogU4qJwbu8/Wfcc/8IXQZcQwk+Rpul7CF4JnwL5vHfrM7/Okbl
         TSGnpUAshHkpkU5+mb4d1XLM9GpjTxNNecPZrfZnYPGwlRt/K6+Q3894RE96iH9gB5vF
         F4J0uq3MdyLJBpvvpQCq8qEI/3/XLVxbKi5HZ42OZMIJ+6ZQRkVIL2H6EggQxfB2ZcPc
         tGlTqzWSEcFFuJg34MfuFjVWfcN6nCkJqSK8LZ8WYyOikSSdia9kn30ixfun5fvrdAQe
         yd2z/vsxIOoIvG+pqUDQiVwY2yTJ7/YlTCpgFJbu9my3SLwF/knIt5SiMGR/lXt34oWJ
         pkng==
X-Gm-Message-State: ACrzQf3roD4VNWqExVKmfpYhgAxFmetC7j/pIfTfpRAB2Yl4NPnzlKm3
        Fac0v4TG+8VV+9yiyQ2vdluGA8uKN27/bw==
X-Google-Smtp-Source: AMsMyM5xlz5+gLojr4Bd1dkgyQysbkqFgvVjgAC/rp/sVNivYvVg2P1Pn1hxTfxPg1N9DX/qG6Tm+w==
X-Received: by 2002:a65:6e0d:0:b0:42d:707c:94ee with SMTP id bd13-20020a656e0d000000b0042d707c94eemr42474746pgb.260.1666904825657;
        Thu, 27 Oct 2022 14:07:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id 77-20020a630350000000b0044046aec036sm1426687pgd.81.2022.10.27.14.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:07:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ooA5e-0079di-0R; Fri, 28 Oct 2022 08:07:02 +1100
Date:   Fri, 28 Oct 2022 08:07:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: refactor domain and refcount checking
Message-ID: <20221027210702.GU3600936@dread.disaster.area>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689088265.3788582.15184390909746101694.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166689088265.3788582.15184390909746101694.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 10:14:42AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a helper function to ensure that CoW staging extent records have
> a single refcount and that shared extent records have more than 1
> refcount.  We'll put this to more use in the next patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |    5 +----
>  fs/xfs/libxfs/xfs_refcount.h |   12 ++++++++++++
>  fs/xfs/scrub/refcount.c      |   10 ++++------
>  3 files changed, 17 insertions(+), 10 deletions(-)

Nice cleanup - just a little change but it really improves the
readability of this code.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
