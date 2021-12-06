Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1A7C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 20:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349398AbhLFUSe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 15:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349378AbhLFUSd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 15:18:33 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6557C061746
        for <linux-xfs@vger.kernel.org>; Mon,  6 Dec 2021 12:15:04 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 133so11489908pgc.12
        for <linux-xfs@vger.kernel.org>; Mon, 06 Dec 2021 12:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xj+DELkhOblvzQopIj8ntNBacOz9m9Kzrou2+3x4Y54=;
        b=eNdT0ymDKEgHHn8ekiAYPZrO9K6JQ/N7Zb1mKfnZ2tVagy0dBiFqzMa77aK/1NET/e
         q8LwdVkQOEUDPgsltiOtlXPtAOz7ZHsbU4Ebh7vqpjLSSO1aJnYoTzWMF8W9PpmsRZkA
         7LUeJrANZwXyt/2RbVFyx1guDU+dx4FvVTInI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xj+DELkhOblvzQopIj8ntNBacOz9m9Kzrou2+3x4Y54=;
        b=MzfkneHp9sRp1RPMCPwyOkKSTXGfoHtN7Z8PWwZRZUflSf1gzfoTkU7q3Ct9ymxMa/
         FTYcT1FiuW9vebObjsPhCU4ZoXKSO3GjRUDubchKmq0Dog9gakUImCoZKDO4KPFK0Y/L
         hqmBHn/GhMpAe5UMOspez7YUOjlXBZVwOVY0G78TBNWQEn/Qf+NiKkjTpBD4YB5ijRtD
         lKBGQEQjv82WLFdllO2cQoGC5ijwJVFxPrOxeReimV5OEa3CQ9ehxiLQfsgNqIQq6KJw
         xM7irqTEW2o4pIFbBuzj/h2qWhvWs+WB4Zwl0ie5acSK1nRYxaonbcT2v1ueGSOpnx2B
         TYqw==
X-Gm-Message-State: AOAM532cdu30WBdkIFZUMIWzQvpFGw0lQITPDY61Uo4PVwEZuHNwDetf
        dClqrd1SREpnOjM0b38o0HcCwg==
X-Google-Smtp-Source: ABdhPJwp+/shrxotTBbfsV46abK50S1X7kv89Rvnez7rxC5+4aQV/3iGw1Tc/YNOf7uowW7derArkA==
X-Received: by 2002:a05:6a00:1822:b0:49f:c55b:6235 with SMTP id y34-20020a056a00182200b0049fc55b6235mr38245006pfa.66.1638821704311;
        Mon, 06 Dec 2021 12:15:04 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c81sm12795271pfb.166.2021.12.06.12.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 12:15:04 -0800 (PST)
Date:   Mon, 6 Dec 2021 12:15:03 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Thomas Goirand <zigo@debian.org>, 1000974@bugs.debian.org,
        Giovanni Mascellani <gio@debian.org>,
        xfslibs-dev@packages.debian.org, xfs <linux-xfs@vger.kernel.org>,
        gustavoars@kernel.org
Subject: Re: [PATCH xfsprogs-5.14.2 URGENT] libxfs: hide the drainbamaged
 fallthrough macro from xfslibs
Message-ID: <202112061204.404658A87@keescook>
References: <20211205174951.GQ8467@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211205174951.GQ8467@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 05, 2021 at 09:49:51AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Back in mid-2021, Kees and Gustavo rammed into the kernel a bunch of
> static checker "improvements" that redefined '/* fallthrough */'
> comments for switch statements as a macro that virtualizes either that
> same comment, a do-while loop, or a compiler __attribute__.  This was
> necessary to work around the poor decision-making of the clang, gcc, and
> C language standard authors, who collectively came up with four mutually
> incompatible ways to document a lack of branching in a code flow.
> 
> Having received ZERO HELP porting this to userspace, Eric and I

Look, I know you don't like this feature, but claiming that you received
no help with it is just false. I explicitly offered to help with xfsprogs,
and even sent a first-attempt at a patch to do so[1], which looks very
similar to what you've got here, almost 6 months later. I even went
through and changed all the comments to an explicitly XFS-specific
macro when you made it clear you hated the statement-like "fallthrough"
macro name.

I continue to be baffled about this whole saga. We're all trying to help
make Linux better, and I went out of my way to help with xfsprogs too to
minimize the impact on you (since you said you wanted to have nothing to
do with it), yet Gustavo and I got continually flamed by yourself and
Dave, including even now in this very misleading commit log.

What is going on here?

-Kees

[1] https://lore.kernel.org/lkml/202105280915.9117D7C@keescook/

-- 
Kees Cook
