Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEA2C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 20:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343619AbhLFUVi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 15:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349479AbhLFUVi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 15:21:38 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF9AC061746
        for <linux-xfs@vger.kernel.org>; Mon,  6 Dec 2021 12:18:09 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1muKR5-0002YR-7A; Mon, 06 Dec 2021 20:18:07 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1000974: [PATCH xfsprogs-5.14.2 URGENT] libxfs: hide the drainbamaged fallthrough macro from xfslibs
Reply-To: Kees Cook <keescook@chromium.org>, 1000974@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1000974
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Keywords: 
References: <20211205174951.GQ8467@magnolia> <163839370805.58768.6385074074873965943.reportbug@zbuz.infomaniak.ch>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1000974-submit@bugs.debian.org id=B1000974.16388217069023
          (code B ref 1000974); Mon, 06 Dec 2021 20:18:06 +0000
Received: (at 1000974) by bugs.debian.org; 6 Dec 2021 20:15:06 +0000
Received: from mail-pg1-x52e.google.com ([2607:f8b0:4864:20::52e]:33533)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <keescook@chromium.org>)
        id 1muKOA-0002LE-Gb
        for 1000974@bugs.debian.org; Mon, 06 Dec 2021 20:15:06 +0000
Received: by mail-pg1-x52e.google.com with SMTP id f125so11601141pgc.0
        for <1000974@bugs.debian.org>; Mon, 06 Dec 2021 12:15:05 -0800 (PST)
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
        b=yDPwj8tEnuHwbaUZk9adD/JN4LljimRYuhMK1tE3cOHjdGw0F3u1zEbhWDU/XSU3OW
         suXT4sw+l04A+Jlhpu/HT+mkDB+kKWIX3MaQAevLn6IspxiKIbfvYVVROwcPxmGapsi1
         0LAPtgch8yE3wrBKD8ptNb2jaYS/5kqXfDzQ9i8QV5PF5yuvpyMlYkV+jGQxau4QjjQi
         pAb+CQ7GfkEgSfHJHrlNuhVLB45FeEx+C2JsFmBtd8vp3US92p9miUEwftUxpBY45GbG
         2iEos9n9cFTwWRFqc7dROEtjo0wJUxk7YzzE1Dho2afIVdx8qYwEEmo6hHtYT/Q/WLLb
         TW9g==
X-Gm-Message-State: AOAM530jJRl8FZRMTyw41bUulzGJL/TUi9ITgNcD1Ef1sIEL+fRnzT5F
        tWHrmHIkg94gOpsMUTiVVpO0JvKQ0RIxvw==
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
Message-ID: <202112061204.404658A87@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211205174951.GQ8467@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Message-ID: <20211206201503.t_7Jzb6Vj3kgd0ZEfmpvYORPTvDNdp1kped8LBa3rjQ@z>

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
