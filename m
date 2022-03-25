Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF03BC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 07:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243353AbiCYHiw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 03:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353815AbiCYHiw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 03:38:52 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A85CA0C7
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 00:37:18 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z92so8199666ede.13
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 00:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0AnJ2JYyTGQ0CVEPe7z2hdI/bieCXgof28FPJMemlc0=;
        b=02qD0ZZX5swBPBs1VjsDnwpEflZ8D91JZQCSnRFmfctCGCQ/ljwUQSWJIxJakRX6HM
         AveioegV04gkhsgPfnpmUPd3CB5uyxW3O8eP3eOK9QiJe01quqEeKpVUOQ27YXDSXPCH
         llBZ3omSpVzIl1GvcdudJvD7Ut5uhdFh63KWa8a3/3h7ieuBlGhsovkLo71qYfofUQ5Z
         0wwVK+vLeG6lx9ldd8sqzL1yhBY0/Qq2ZcqaD0yOzh5VhuUJTcVKd7Y5uz+CkZ5tQRwW
         BUDUTZ669OSeIWXwKhVL5nNgDcMrzytw9NXDvPVAQiLZ4VKOcIee7FlyLIbgIqZBko3n
         4UlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0AnJ2JYyTGQ0CVEPe7z2hdI/bieCXgof28FPJMemlc0=;
        b=m5zWCq2VEJVN8kH1eFX9Z+TIpqR3t0fZHaxO0uq5DjQHsNG8SuIqyHb2hNoVg1KAMN
         gfrn2qj0htMg0Dmy38oMZBp9gbGE9XyBaYC1lAydBLanh/t5SdZ6981fS10CDK/3PkwH
         UWxBr95RlHz59b66wE2ozi2kD699orc2tnjHhXxJHDfF0Pop71X0Xc+VpBDA6N4Od8bQ
         TzF5uh8vljl2hs7ExyJMa78nKO2QqGWYZv04QzFb4t359XaxpLFVDkBRtdQQcga0mTq5
         23n77NueFTftmyKa5cNWRZng1ab73Bz3C4Gsm6vpV8wRQmlSO5xNv91qkyW3305B3btY
         hNFQ==
X-Gm-Message-State: AOAM530iJ/mg715EvfJRBi76any/cFhZBevcMy+HM+gTsjXdiosV1pPh
        kEvE+fPyKd/++6UgBsuL0WCGe5y5sTfuiZfyvX2w1m6iqmE/hQfl
X-Google-Smtp-Source: ABdhPJyBfGjKqOOW/IKFclBfBd1FmZGmU+2VQv+ahRf/04zloN84hglLQ5iAHpBJjSd75VtWoLvDhm1DmcLRkl8X/l4=
X-Received: by 2002:a05:6402:1388:b0:419:3d1a:9844 with SMTP id
 b8-20020a056402138800b004193d1a9844mr11341455edv.256.1648193837240; Fri, 25
 Mar 2022 00:37:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220321231123.73487-1-jof@thejof.com> <20220325011656.GP1544202@dread.disaster.area>
In-Reply-To: <20220325011656.GP1544202@dread.disaster.area>
From:   Jonathan Lassoff <jof@thejof.com>
Date:   Fri, 25 Mar 2022 00:37:06 -0700
Message-ID: <CAHsqw9syB0GE+mEiSAem8N2Swh-_n2-86BW1E=DKpg+OwCsopA@mail.gmail.com>
Subject: Re: [PATCH v1] Add XFS messages to printk index
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 24 Mar 2022 at 18:17, Dave Chinner <david@fromorbit.com> wrote:
> Hmmmm.  This is still missing a description of what "semi-stable"
> implies in terms of kernel/userspace ABI guarantees/constraints for
> the XFS codebase and developers.

I'll reword this in a followup patch.
The printk index just captures and exposes these strings from the
sources. Its design was chosen specifically because it places no new
constraints on kernel developers.
This functionality enables kernel developers to change format strings
at will, and when captured by the printk index, enables end users to
detect changes from release to release (and presumably trigger them to
update any relevant regexes on their end).

> However, change logs should not be part of the commit message - they
> go either in the cover message or below the "---" line as we don't
> record them in the git history when the code is merged.
>
> Most importantly, the patch is missing a Signed-off-by line.

I've got these fixed up now in my format-patch configuration and use
of notes. Sorry for the noise in this regard, I don't usually email
patches around.

> Now the kern_level comes from the high level macros, we don't need
> these constructors any more. This just results in identical functions
> that differ only by name. i.e. this constructor macro and the
> functions it builds can be replaced with a single function

This is a good suggestion for simplifying the existing functionality
and making the logical change to switch in printk indexing much
smaller.

> And then if you split this patch into two - the first patch
> reorganises the printf code, the second introduces the new printk
> functionality (i.e xfs_printk_index_wrap() macro) - then we can
> review and merge the cleanup patch independently of the fate of the
> second patch that may introduce ABI contraints....

Seems reasonable. I'll follow up with a PATCH v2 incorporating these
suggestions.

-- jof
