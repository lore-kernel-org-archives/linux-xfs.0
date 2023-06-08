Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECFFC7EE25
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jun 2023 21:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjFHV6w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jun 2023 17:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjFHV6w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 17:58:52 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBC9272A
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 14:58:50 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b038064d97so1329755ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 08 Jun 2023 14:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686261530; x=1688853530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2/EUtx4ycp4mR6nPhVhDlxvnjzE+zvrfRKVHftXyUsQ=;
        b=cZPc7zSylxAT6FpIE4tHSHILj+81IHIUImhSd8x1ZEh9BfDo9ClhPAllJEIFmD3i9Z
         uNVf/KVDMMqXPqGfFx5jiiKabbZUnA2s0R0II2nJq5M/glD3LrAzYS+0OgWfXreFGBkC
         TG1jMPCIriroCZOIAcZFvO8mM0PqHw1mhENYRK2DbP44uA/FljkfwDXrum1S1yKOCh3H
         IJK3euKv7R22rYss/6OuXYIaivjw9MeRNiXoHKwPIYz14nw39r8LXPdbz8JzTyocMh76
         McmR72bUJqRzn2Vn2N13e6tQYVYxF5qxOH2zfFW+8TZgheIgz7osiJkYCRyzn3s9PHVq
         cJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686261530; x=1688853530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2/EUtx4ycp4mR6nPhVhDlxvnjzE+zvrfRKVHftXyUsQ=;
        b=ThjHX7Cn3TCRCOzjud8x3w5K1kXB4hIz+SgERfDEg8BiAaR7abBYxBPQK/ccg1amK0
         //M1c9u3XDoxonU4hCwS3jvMoFTsjo8RQp/viSERp4RfM4Me949rICkbuoYRg19tTwjC
         KJaYhbBqUU8mqsa01UlBRD8W+sfg07npRDyhyJ4aUJLypvyGu/bAREgM3EdCnlPIH8b4
         +P/pLTkEXctetFBwFFWZ11o2NjOIDD39hdWC0u/ASaah1yMkkVX9/VC2hus8kUJzexsJ
         ZymGjoV8UhMjwNmurHlTKwZUHrXooivNEkkvzBgu6PeAMq3XZQw6f2bdY/w5lT/5Vujs
         UYxw==
X-Gm-Message-State: AC+VfDwIWApSNWPoqngA/FqS6qQsAmJ8UVRjibSIx+e1o+tX+xRqSiUK
        lOGTunEEb6qnIEbvqRQMeJ7ABw==
X-Google-Smtp-Source: ACHHUZ4HayHnFpb+wxhgpMUZycBd+h1pMgzOPGOqp2bjrxn/nE2uyMC88SzBjmeIuSiMFNqtn8mg4g==
X-Received: by 2002:a17:902:c952:b0:1b0:3d03:4179 with SMTP id i18-20020a170902c95200b001b03d034179mr4073208pla.6.1686261529696;
        Thu, 08 Jun 2023 14:58:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902c14400b001b03d543549sm1892229plj.72.2023.06.08.14.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 14:58:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q7NeY-009Rru-0V;
        Fri, 09 Jun 2023 07:58:46 +1000
Date:   Fri, 9 Jun 2023 07:58:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Qi Zheng <qi.zheng@linux.dev>
Cc:     Kirill Tkhai <tkhai@ya.ru>, akpm@linux-foundation.org,
        roman.gushchin@linux.dev, vbabka@suse.cz, viro@zeniv.linux.org.uk,
        brauner@kernel.org, djwong@kernel.org, hughd@google.com,
        paulmck@kernel.org, muchun.song@linux.dev, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 0/3] mm: Make unregistration of super_block shrinker
 more faster
Message-ID: <ZIJPFuIxYpk1+TC5@dread.disaster.area>
References: <168599103578.70911.9402374667983518835.stgit@pro.pro>
 <ZH5ig590WleaH1Ed@dread.disaster.area>
 <ef1b0ecd-5a03-4256-2a7a-3e22b755aa53@ya.ru>
 <ZH+s+XOI2HlLTDzs@dread.disaster.area>
 <4176ef18-0125-dee8-f78a-837cb7a5c639@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4176ef18-0125-dee8-f78a-837cb7a5c639@linux.dev>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 07, 2023 at 10:51:35AM +0800, Qi Zheng wrote:
> From my personal point of view, I think it is worth sacrificing the
> speed of unregistration alone compared to the benefits it brings
> (lockless shrink, etc).

Nobody is questioning whether this is a worthwhile improvement. The
lockless shrinker instance iteration is definitely a good direction
to move in. The problem is the -process- that has been followed has
lead to a very sub-optimal result.

> Of course, it would be better if there is a more perfect solution.
> If you have a better idea, it might be better to post the code first for
> discussion. Otherwise, I am afraid that if we just revert it, the
> problem of shrinker_rwsem will continue for many years.

No, a revert doesn't mean we don't want the change; a revert means
the way the change was attempted has caused unexpected problems.
We need to go back to the drawing board and work out a better way to
do this.

> And hi Dave, I know you're mad that I didn't cc you in the original
> patch.

No, I'm not mad at you.

If I'm annoyed at anyone, it's the senior mm developers and
maintainers that I'm annoyed at - not informing relevant parties
about modifications to shrinker infrastructure or implementations
has lead to regressions escaping out to user systems multiple times
in the past. 

Yet here we are again....

> Sorry again. How about splitting shrinker-related codes into
> the separate files? Then we can add a MAINTAINERS entry to it and add
> linux-fsdevel@vger.kernel.org to this entry? So that future people
> will not miss to cc fs folks.

I don't think that fixes the problem, because the scope if much
wider than fs-devel:  look at all the different subsystems
that have a shrinker.

The whole kernel development process has always worked by the rule
that we're changing common infrastructure, all the subsystems using
that infrastructure need to be cc'd on the changes to the
infrastructure they are using. Just cc'ing -fsdevel isn't enough,
we've also got shrinkers in graphics driver infrastructure, *RCU*,
virtio, DM, bcache and various other subsystems.

And I'm betting most of them don't know that significant changes
have been made to how the shrinkers work....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
