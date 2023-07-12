Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F29EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 22:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbjGLWMx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 18:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjGLWMw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 18:12:52 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099E21FC7
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 15:12:48 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-668709767b1so62338b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 15:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689199968; x=1691791968;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F6BvRqPr4iuv3lk86iw2NXzW2J98gsxsW8yfepLX2YQ=;
        b=GWnxtYR3OU39d8ETwOEvvWaaGYJjF+B+WNWQQtEMqyrQDLS/UPnAVlosd9VHnRxsLR
         HhONxzZ009BdmbnyPg+IFwtWPRhoVDvlxD9SX5pvm9HjpMfo1/g/m8GBILK1PGJEprPL
         bLBbVTIQgR6epL2XbMc6ssUPmAeKYa9pKt/Si5oBUgWGZeNxZVYdIRe1rO4+Vo6taojD
         DWQ5iVUzFN6twzfqt7fuPWDYKabcLtbCJZEvAG2MmHutQky1Smo49fAMnr9hqEZ57AYS
         lYTZBTb/ust2kNxbyZXd5Se/RkeDGAZRHp2dG4+r4YYcCHhjO30YmZ9hBaAIcAOGxKJA
         MJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689199968; x=1691791968;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6BvRqPr4iuv3lk86iw2NXzW2J98gsxsW8yfepLX2YQ=;
        b=CA2IaPycVSP9PhJEdYRio2csbqMcp73DdFoC2MYba2qBJkaqjb06wqMPCBIE2xmH/U
         E955NtfrnPQgCmhBFRYVa6d1flZBbWWNw5zcD0m7Axo9MidBlzEWDvFoqpe+eXyuTCI+
         pBW6QTjlvwd9+56bRHgRNFygeTQMwLtPrw7xLbsEFNNO6iAOgrCwZ7ZjFHuYINHV9vrA
         zM4pUpp5blsnswJybeR2OBXSD7Zg7mU+qzvFAFH3lQy0Itc40hP5m2h8WryaMghlGvf5
         oOxpj7H6qs0H5s3fsWBIOuy7cpGzkKr1nGmVOx8TeUQlVf7PdVBfekoBvW3VdI5gXdXd
         WS3g==
X-Gm-Message-State: ABy/qLZyiaEplHCMmxr1QsKXDQ48+p7f16j8irH9bu6kRM6n+8HNmG7X
        JfS+3PZTd633y0KXefwEJzP1hC2G8vt4b1TOshE=
X-Google-Smtp-Source: APBJJlEz3XRnqoEs5K2JmxEWjSXneO4cniatKbMFLGLZLekcPhyJVnMJ3ASXxjd+RZdj1QY8nSiA1A==
X-Received: by 2002:a05:6a20:7290:b0:130:661c:613d with SMTP id o16-20020a056a20729000b00130661c613dmr17696947pzk.5.1689199968224;
        Wed, 12 Jul 2023 15:12:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id x22-20020aa793b6000000b006826c9e4397sm4090784pff.48.2023.07.12.15.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 15:12:47 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qJi4i-005Li7-0n;
        Thu, 13 Jul 2023 08:12:44 +1000
Date:   Thu, 13 Jul 2023 08:12:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] misc: remove bogus fstest
Message-ID: <ZK8lXMucaf1nS7Ks@dread.disaster.area>
References: <DNb0uIBsmTk-4VL37ZmBH-nqyWm2cSqdM-Zd_bAXcZPV1pCBQsbvInqpO9Y-wscHogOqvlrjO_98ujQlmB6EEg==@protonmail.internalid>
 <20230709223750.GC11456@frogsfrogsfrogs>
 <20230711132454.y4jmjlwyuhxmeylc@andromeda>
 <20230711145441.GB108251@frogsfrogsfrogs>
 <h8Qt0-HKorFHK6L7J-S372p9ryurQZbvCz9OlGiEWb1atBk5mzn54uniz5RFn2alUgb33Jm11S4BsEcKIxx71w==@protonmail.internalid>
 <ZK3r9Q1vLrRnfPE/@dread.disaster.area>
 <20230712071921.apdvx34iohqlqsmx@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712071921.apdvx34iohqlqsmx@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 09:19:21AM +0200, Carlos Maiolino wrote:
> On Wed, Jul 12, 2023 at 09:55:33AM +1000, Dave Chinner wrote:
> > On Tue, Jul 11, 2023 at 07:54:41AM -0700, Darrick J. Wong wrote:
> > > On Tue, Jul 11, 2023 at 03:24:54PM +0200, Carlos Maiolino wrote:
> > > > On Sun, Jul 09, 2023 at 03:37:50PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > >
> > > > > Remove this test, not sure why it was committed...
> > > > >
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  tests/xfs/999     |   66 -----------------------------------------------------
> > > > >  tests/xfs/999.out |   15 ------------
> > > > >  2 files changed, 81 deletions(-)
> > > > >  delete mode 100755 tests/xfs/999
> > > > >  delete mode 100644 tests/xfs/999.out
> > > >
> > > > Thanks for spotting it. I'm quite sure this was a result of my initial attempts
> > > > of using b4 to retrieve the xfsprogs patch from the list, and it ended up
> > > > retrieving the whole thread which included xfstests patches.
> > > >
> > > > Won't happen again, thanks for the heads up.
> > >
> > > Well I'm glad that /one/ of us now actually knows how to use b4, because
> > > I certainly don't.  Maybe that's why Konstantin or whoever was talking
> > > about how every patch should include a link to a gitbranch or whatever.
> > 
> > If all you want to do is pull stuff from the mailing list, then all
> > you need to know is this command:
> > 
> > 'b4 am -o - <msgid> | git am -s'
> > 
> > This pull the entire series from the thread associated with that
> > msgid into the current branch with all the rvb/sob tags updated. I
> > -think- this has all been rolled up into the newfangled 'b4 shazam'
> > command, but I much prefer to use the original, simple, obvious
> > put-the-pieces-together-yourself approach.
> 
> This was exactly the case, the problem is, both xfstests patch and its xfsprogs
> counterpart were sent under the same thread, which caused b4 to pull both of
> them.
> What I noticed (and haven't until I looked a bit deeper during my PTO) is that
> b4 has an option to pull the patches into quilt format, so, that will make
> things way easier.

I don't use that - I prefer to work from commits than mange patches
directly. What I do take the list of commits that it creates, then
run 'guilt import-commit <id range>' to pull the commits made from
the patches into a guilt maintained patch series in the git
repository. That generally requires checking that all the commits
that were pulled in were the ones that were wanted, but then I can
manage the branch as a "patch series in git commits" as needed.
That's far easier than managing patches by hand to build a series to
apply to the git tree....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
