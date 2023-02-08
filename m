Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA73C636D3
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 22:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbjBHWVL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 17:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbjBHWVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 17:21:10 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCBA8680
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 14:21:08 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id a5so62666pfv.10
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 14:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RmQSKRvOZNLKNIp8wvOZst6rBIGB46qyfihC7bBU32Q=;
        b=rLq3UBVk6nJPxhXp34TzVWHEE48v95KB3mhYapTC4h5el9KHUKa3I8mtqk2g7DnMQy
         18QkEuvgodLQTwoI0/NIsx3Fw2/n+LGzeaLI/TC6Z8VOYVTMEO4PnAxZYn2rc8JZIegu
         FXRq/0BrS6wBpRD6HA9N5Q4TNETZ3fgKC5huuOvt21mr04aKCvCeEegpUEN4VuVcphDL
         KjGVdb2WKC3l7JDw59Qji4fUd5MgbzJxGuPHYelGEieWjTX4k9lQf4Evgvv/Ym3fg6Ws
         DzOv28FALmr3Mkr/20aORWQ3Ih+GqPRQIkspP9jc2XQ6lHQYVc5pWIjldwVNnEACXbY7
         42ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RmQSKRvOZNLKNIp8wvOZst6rBIGB46qyfihC7bBU32Q=;
        b=gsqwGsMY5xAH/R4Jj/Zh+Bzp6AKDZgfb9hBn9qW6k+6jhdDDqoc8HjCWSw8as7BBSr
         NzlM6NRRelHg16+0cR8q/CRzGPAkwY1pcgLrBtKyh+KhRa7P0zPlDIqOvfGnVkjKoXgX
         JyDuQYlWLC1EsisW6AebEiqLiQmlMC5OOBsL4zfV5mxQmpbMDx6L1YcPhCW0bvmACDA9
         dr8X1bBa/+/94Un2pTCw/vyXzzG/4Pfkq881bUONBu5zrghkn9TNYDGUW5pmNi9j7ZYP
         X03fYQB8owBOU7z7gRhYFfUIeT1709SPD4d0Ds8v/kOK+RdcXCNwNVPLxTMKcdprvkOa
         kkAg==
X-Gm-Message-State: AO0yUKVF0Z8H3mWsL+lLZDasX8RUFTphB3MtoLAqSRag/O+3ADOtn0eP
        5QEkAoiQvVbgkfhoz4G+CZXAGQ==
X-Google-Smtp-Source: AK7set/YA+xbUO7aJk/v4E64OL8XmWJhuB3zgHyP4cbAqAoxogm61Ae0IS+E1u574SH9FI0mCxY2yg==
X-Received: by 2002:a62:1ec7:0:b0:592:5e1d:c7d2 with SMTP id e190-20020a621ec7000000b005925e1dc7d2mr6032957pfe.23.1675894868422;
        Wed, 08 Feb 2023 14:21:08 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id v14-20020aa7850e000000b005a81885f342sm2272220pfn.21.2023.02.08.14.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 14:21:08 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pPsoK-00Czvv-M8; Thu, 09 Feb 2023 09:21:04 +1100
Date:   Thu, 9 Feb 2023 09:21:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
        Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE 00/10] more xfs fixes for 5.15
Message-ID: <20230208222104.GD360264@dread.disaster.area>
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
 <CAOQ4uxgmHzWcxBDrzRb19ByCnNoayhha_MZ_eYN0YMC=RGTeMw@mail.gmail.com>
 <Y+P6y81Wmf4L66LC@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+P6y81Wmf4L66LC@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 08, 2023 at 11:40:59AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 08, 2023 at 09:02:58PM +0200, Amir Goldstein wrote:
> > On Wed, Feb 8, 2023 at 7:52 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> > >
> > > Hello again,
> > >
> > > Here is the next batch of backports for 5.15.y. Testing included
> > > 25 runs of auto group on 12 xfs configs. No regressions were seen.
> > > I checked xfs/538 was run without issue as this test was mentioned
> > > in 56486f307100. Also, from 86d40f1e49e9, I ran ran xfs/117 with
> > > XFS compiled as a module and TEST_FS_MODULE_REOLOAD set, but I was
> > > unable to reproduce the issue.
> > 
> > Did you find any tests that started to pass or whose failure rate reduced?
> 
> I wish Leah had, but there basically aren't any tests for the problems
> fixed in this set for her to find. :(
.....
> > There are very few Fixes: annotations in these commits so it is hard for
> > me to assess if any of them are relevant/important/worth the effort/risk
> > to backport to 5.10.
> 
> <nod> Dave's fixpatches rarely have Fixes tags attached.  It's difficult
> to get him to do that because he has so much bad history with AUTOSEL.
> I've tried to get him to add them in the past, but if I'm already
> stressed out and Dave doesn't reply then I tend to merge the fix and
> move on.

In my defense, all the "fixes" from me in this series (except for
the one with a fixes tag on it) date back so long ago it was
difficult to identify what commit actually introduced the issue.
Once we're talking about "it's been there for at least a decade" -
espcially for fuzzer issues - identifying the exact commit is time
consuming and often not possible, nor really useful for anything.

I'm also not going to tag a patch with "fixes commit xyz" when
commit xyz isn't actually the cause of the problem just so that
someone can blindly use that as a "it's got a fixes tag on it, we
should back port it" trigger.

That's the whole problem with AUTOSEL - blindly applying anything
with a fixes tag on it that merges cleanly into an older kernel -
and the whole point of having a human actually manage the stable
kernel backports.

The stable XFS kernel maintainer is supposed to be actively looking
at the commits that go into the upstream kernel to determine if they
are relevant or not to the given stable kernel, regardless of
whether they address fstests failures, have fixes/stable tags on
them, etc. If all we needed stable maintainers to do is turn a crank
handle, then we'd be perfectly OK with AUTOSEL and the upstream
stable kernel process....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
