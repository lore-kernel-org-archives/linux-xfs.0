Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36372C77B61
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 02:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344311AbjD1CNv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 22:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjD1CNu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 22:13:50 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11992D4C
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:13:49 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b62d2f729so7205545b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682648029; x=1685240029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EdjxSaCR/mSrd/J+TfNLQVW6vbx/fDl0vW5ytTPNm/w=;
        b=xKkUuZQFx1GHL+3gkMzuufO71oxJHsu1yw3DEHm1x/IknXSNsOBzUyflpBkKo0NIrc
         feq/nAi7HkRSGjepTn4X4WN/s4TDt2nAMUJ7FEpuaH4c+UjHxfGaELMx/Vik0EPAszem
         IWS2YJ6Ydgo1J4BqF0hzlJ/JsEP1SWh+jkk3I65FRGoy0taay6EVC4pExrTAMgztkWh7
         AdHBiAOIeIc2sFJgove20474afSn0Y5uVdn5xxoFAOIgqCqLtg3+HT4d6FG77i9j6cnq
         8QJYYNOwrmJNWBmFV4YTgQ2fSyeZlH0Dugoe1vG6EUOpLSAa3ytEroKS1h4d8lEKeVWw
         jKsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682648029; x=1685240029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EdjxSaCR/mSrd/J+TfNLQVW6vbx/fDl0vW5ytTPNm/w=;
        b=NkuMdCneOyGOE7Y8z1RL9ngc/E1bMK1u5+KG71QP9WquberYpIalo/m2vzr472b0Px
         o2VMihGER5dwJTmGKezM82px2xMhD8OfwJ86KnzcVTlg3m2Pz+dZyML67tp5eK4rNA7s
         m/+qIcy5d6J+Tn7fCAbo8kttmUgm1xpVojmo8PyvaBI2mFmmY6Lj5r/w+hAWZhDCOQEh
         jpslZwJI95XK508idXwTsJt3+3TaNsizzGO7uBrkLho8bfbTJae9iiBgFKKwIIXcGQxd
         yVFB9gnHhObDH5QQ6XniQZ//05fGAgPtKc2F22+QwuGHKB4DjUzOAJBWD5dZdZFpPVMN
         n52A==
X-Gm-Message-State: AC+VfDyeZ8M/lKUxU4z8p7GJ2UjiuddQrAEHyC4hTsoKnRyTsf8cR/Qr
        8twDUbNlUNf1S2xLgY/msWt/uA==
X-Google-Smtp-Source: ACHHUZ53p0oHzV7pWDPGmriHDSwsC3GTmHdLw5cKJmV2bEjLYryAae7YmwR9lTL7jwiJXvLCewzzhw==
X-Received: by 2002:a17:903:6c8:b0:1a6:6fef:62f6 with SMTP id kj8-20020a17090306c800b001a66fef62f6mr3117405plb.30.1682648029276;
        Thu, 27 Apr 2023 19:13:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id n13-20020a17090ac68d00b0023f8e3702c3sm13870497pjt.30.2023.04.27.19.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 19:13:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1psDcI-008hx5-Am; Fri, 28 Apr 2023 12:13:46 +1000
Date:   Fri, 28 Apr 2023 12:13:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: don't allocate into the data fork for an
 unshare request
Message-ID: <20230428021346.GQ3223426@dread.disaster.area>
References: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
 <168263575686.1717721.6010345741023088566.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168263575686.1717721.6010345741023088566.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 03:49:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For an unshare request, we only have to take action if the data fork has
> a shared mapping.  We don't care if someone else set up a cow operation.
> If we find nothing in the data fork, return a hole to avoid allocating
> space.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_iomap.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Looks ok, but I'm unsure of what bad behaviour this might be fixing.
Did you just notice this, or does it fix some kind of test failure?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
