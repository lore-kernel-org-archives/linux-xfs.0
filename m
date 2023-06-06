Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C55C7EE43
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 22:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239803AbjFFWCn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237847AbjFFWCj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 18:02:39 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A8E170C
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 15:02:38 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d44b198baso4850318b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 06 Jun 2023 15:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686088957; x=1688680957;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q84P/Zpj4US01+iC9oxhz+4mQn9TmvaFzrXQHOhoFsI=;
        b=2t1oK2AUusaPWDyrc/bAkX09X3lnEYzFmaxyk172+GG0cOEWQmf6wECBZF6+Zp+gKf
         d3KHNOvi0ris9Zhy+trBvtmoay1bmS0vXYGhbohIc18FZ8CcoUAaKNIySqUBG3phAi/f
         HA+r0lNUAfKBh6C5NkCyeAptNErIRSShNhDoH3tqBFr/cgLZZV7UocP0M7p70JxxsVFM
         UXChm6PyU/uV8fWMUC55Bu3osIPvtlLamRBbxopA1FpM4A/bDeGLRCunyYY3kCl96buM
         envV9YQ8SSiEzeRqgSRZb93XH047c9f6kQdiO8TJtQvZ10t21DHCA0c+WMLiwiXo5qxt
         dSCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686088957; x=1688680957;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q84P/Zpj4US01+iC9oxhz+4mQn9TmvaFzrXQHOhoFsI=;
        b=Y6YhHNLoIVQ79hGJ3VP7S4tFRuMs1d+5ZJCkC8KrfUt+AP1s9c3qgf3xpqdsXLiwNv
         SQoJGTuoSafudkN5qA5opv5jmpSlTGzAAvoIcqLFEduMudTTjsteqLa7et2SKgxuYnMD
         Nc0VwiB2+XsSghp6JZOftNIOZuu8bF4qQKXIgDLc0+1kg/DLlHYu5fXaMg3Ehnho/y4W
         NtMi+EMaBr8Nzse+aa3LIBXqiPE9DjQrC9YoUY8xxsnHWI65anN9nO9r/RGzNPa7biwa
         vem6GN+MHLFBa7YbagCvvwBJwGU2dBU2fplY68tY5L653/A+vRA3tfH4vLc2FXfcw0fT
         OQpw==
X-Gm-Message-State: AC+VfDximT6qpISDlJAzya5mRFpv8l1lcf7d3XQD6OfxPvgDt1TDE1ih
        1AnR7g4inbRRhCw1+DRi4BYhDw==
X-Google-Smtp-Source: ACHHUZ7xLo3qxQtzWUeCkYrgCfEBLb/Py3jsG4y1l0xhkRqsxW/43h0D9tK1yS87PaV2qRPEinYD6Q==
X-Received: by 2002:a05:6a00:3316:b0:645:834c:f521 with SMTP id cq22-20020a056a00331600b00645834cf521mr4960797pfb.17.1686088957175;
        Tue, 06 Jun 2023 15:02:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b0064d47cd117esm7293989pfn.39.2023.06.06.15.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 15:02:36 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q6el7-008ePi-0l;
        Wed, 07 Jun 2023 08:02:33 +1000
Date:   Wed, 7 Jun 2023 08:02:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Kirill Tkhai <tkhai@ya.ru>
Cc:     akpm@linux-foundation.org, roman.gushchin@linux.dev,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, brauner@kernel.org,
        djwong@kernel.org, hughd@google.com, paulmck@kernel.org,
        muchun.song@linux.dev, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v2 0/3] mm: Make unregistration of super_block shrinker
 more faster
Message-ID: <ZH+s+XOI2HlLTDzs@dread.disaster.area>
References: <168599103578.70911.9402374667983518835.stgit@pro.pro>
 <ZH5ig590WleaH1Ed@dread.disaster.area>
 <ef1b0ecd-5a03-4256-2a7a-3e22b755aa53@ya.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef1b0ecd-5a03-4256-2a7a-3e22b755aa53@ya.ru>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 07, 2023 at 12:06:03AM +0300, Kirill Tkhai wrote:
> On 06.06.2023 01:32, Dave Chinner wrote:
> > On Mon, Jun 05, 2023 at 10:02:46PM +0300, Kirill Tkhai wrote:
> >> This patch set introduces a new scheme of shrinker unregistration. It allows to split
> >> the unregistration in two parts: fast and slow. This allows to hide slow part from
> >> a user, so user-visible unregistration becomes fast.
> >>
> >> This fixes the -88.8% regression of stress-ng.ramfs.ops_per_sec noticed
> >> by kernel test robot:
> >>
> >> https://lore.kernel.org/lkml/202305230837.db2c233f-yujie.liu@intel.com/
> >>
> >> ---
> >>
> >> Kirill Tkhai (2):
> >>       mm: Split unregister_shrinker() in fast and slow part
> >>       fs: Use delayed shrinker unregistration
> > 
> > Did you test any filesystem other than ramfs?
> > 
> > Filesystems more complex than ramfs have internal shrinkers, and so
> > they will still be running the slow synchronize_srcu() - potentially
> > multiple times! - in every unmount. Both XFS and ext4 have 3
> > internal shrinker instances per mount, so they will still call
> > synchronize_srcu() at least 3 times per unmount after this change.
> > 
> > What about any other subsystem that runs a shrinker - do they have
> > context depedent shrinker instances that get frequently created and
> > destroyed? They'll need the same treatment.
> 
> Of course, all of shrinkers should be fixed. This patch set just aims to describe
> the idea more wider, because I'm not sure most people read replys to kernel robot reports.
> 
> This is my suggestion of way to go. Probably, Qi is right person to ask whether
> we're going to extend this and to maintain f95bdb700bc6 in tree.
> 
> There is not much time. Unfortunately, kernel test robot reported this significantly late.

And that's why it should be reverted rather than trying to rush to
try to fix it.

I'm kind of tired of finding out about mm reclaim regressions only
when I see patches making naive and/or broken changes to subsystem
shrinker implementations without any real clue about what they are
doing.  If people/subsystems who maintain shrinker implementations
were cc'd on the changes to the shrinker implementation, this would
have all been resolved before merging occurred....

Lockless shrinker lists need a heap of supporting changes to be done
first so that they aren't reliant on synchronise_srcu() *at all*. If
the code was properly designed in the first place (i.e. dynamic
shrinker structures freed via call_rcu()), we wouldn't be in rushing
to fix weird regressions right now. 

Can we please revert this and start again with a properly throught
out and reveiwed design?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
