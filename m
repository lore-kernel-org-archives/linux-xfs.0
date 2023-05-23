Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47981C7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 07:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbjEWHcf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 03:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235481AbjEWHcU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 03:32:20 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557A7E6A
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 00:31:46 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64d426e63baso4003689b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 00:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684827087; x=1687419087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=APuX2p5bhA35X7Ck9w36HxjMpOW+s6J4VJtXCEFvd/U=;
        b=A3tvW/4EOZus1GX1auq1uj8Bwo9oEPxSy0XtFRwO+W+HjHwMw2zqD4DehExSsSJWYS
         RjRJ5HBNQdyZyJf3cZjGZd4j1rVZEqZraQmzEQ9/u1FXV8gQU82esKe2P7fFbpYKVwNS
         Z/Azp8OrrX7D7qp3wZ/8l/p7zhBrnNM7pFLw/7azS0KLxCEFfDbcInkbdljDta7Ay6X8
         92B71l4Qe8A48t5RV7X9FCp3aWLVsAcUBpN48qZG2s4ICeoA2GOdO935QM1Trq0KA3+n
         WF55kxnNGCiGoGpXmxtTgLUCXS7iAWfoP2ympaBx4Yuwj50jb/ACrCqSwB9sTe2F54th
         US/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684827087; x=1687419087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=APuX2p5bhA35X7Ck9w36HxjMpOW+s6J4VJtXCEFvd/U=;
        b=bfCJRJ6/dDvgn4zlL0CcLdcgLZ7I7ZkOF5lmxRZHaXdV0fPSyFrx+5XLr/5TKqvtgg
         EDoHyuGqjFGccwgJXAAAsFRKSoq3M7enmuOBopxFXH3AEAPR5tHxYCF4V2Az0260wkH3
         ylseauRNGMXzl1qdISVW1XcQtIxSnn7vSazo86VTHPuf3yBEJ6Cup2kYIZff9mMmBdTw
         A72bW2Z0vUxdz1U+dU/jdr/PvqqZgy3SZq45erb8RRfQ4/DTEmFVJiakdmShir3yrYN0
         iLF6Nhz9YtCT3xFwSUuQBvsjxYEl8U3L5E3PGvoJuH0q2pBhj32dD+T70k1rxN7BkeB6
         vIoA==
X-Gm-Message-State: AC+VfDz9jGTprFic4xcw2oXVn/KMxeMiMpugysLoytdqf+mpnzMck2kq
        n7C6uFj7XKYf5PAUFjvya4C91A==
X-Google-Smtp-Source: ACHHUZ42/kVK8jX6eXmVEtFb8hGw99FC+W6pMLMe2P2pNKHLYMMA9YUiCwk+omqMjpWorl1MJt+n7g==
X-Received: by 2002:a05:6a21:8dc4:b0:101:5743:fd01 with SMTP id ti4-20020a056a218dc400b001015743fd01mr10677920pzb.25.1684827087255;
        Tue, 23 May 2023 00:31:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id 19-20020aa79213000000b00639eae8816asm5160422pfo.130.2023.05.23.00.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 00:31:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q1MUN-002qhI-28;
        Tue, 23 May 2023 17:31:23 +1000
Date:   Tue, 23 May 2023 17:31:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Pengfei Xu <pengfei.xu@intel.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, heng.su@intel.com,
        dchinner@redhat.com, lkp@intel.com,
        Linux Regressions <regressions@lists.linux.dev>
Subject: Re: [Syzkaller & bisect] There is BUG: unable to handle kernel NULL
 pointer dereference in xfs_extent_free_diff_items in v6.4-rc3
Message-ID: <ZGxry4yMn+DKCWcJ@dread.disaster.area>
References: <ZGrOYDZf+k0i4jyM@xpf.sh.intel.com>
 <ZGsOH5D5vLTLWzoB@debian.me>
 <20230522160525.GB11620@frogsfrogsfrogs>
 <20230523000029.GB3187780@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523000029.GB3187780@google.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 12:00:29AM +0000, Eric Biggers wrote:
> On Mon, May 22, 2023 at 09:05:25AM -0700, Darrick J. Wong wrote:
> > On Mon, May 22, 2023 at 01:39:27PM +0700, Bagas Sanjaya wrote:
> > > On Mon, May 22, 2023 at 10:07:28AM +0800, Pengfei Xu wrote:
> > > > Hi Darrick,
> > > > 
> > > > Greeting!
> > > > There is BUG: unable to handle kernel NULL pointer dereference in
> > > > xfs_extent_free_diff_items in v6.4-rc3:
> > > > 
> > > > Above issue could be reproduced in v6.4-rc3 and v6.4-rc2 kernel in guest.
> > > > 
> > > > Bisected this issue between v6.4-rc2 and v5.11, found the problem commit is:
> > > > "
> > > > f6b384631e1e xfs: give xfs_extfree_intent its own perag reference
> > > > "
> > > > 
> > > > report0, repro.stat and so on detailed info is link: https://github.com/xupengfe/syzkaller_logs/tree/main/230521_043336_xfs_extent_free_diff_items
> > > > Syzkaller reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230521_043336_xfs_extent_free_diff_items/repro.c
> > > > Syzkaller reproduced prog: https://github.com/xupengfe/syzkaller_logs/blob/main/230521_043336_xfs_extent_free_diff_items/repro.prog
> > > > Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230521_043336_xfs_extent_free_diff_items/kconfig_origin
> > > > Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230521_043336_xfs_extent_free_diff_items/bisect_info.log
> > > > Issue dmesg: https://github.com/xupengfe/syzkaller_logs/blob/main/230521_043336_xfs_extent_free_diff_items/v6.4-rc3_reproduce_dmesg.log
> > > > 
> > > > v6.4-rc3 reproduced info:
> > 
> > Diagnosis and patches welcomed.
> > 
> > Or are we doing the usual syzbot bullshit where you all assume that I'm
> > going to do all the fucking work for you?
> > 
> 
> It looks like Pengfei already took the time to manually bisect this issue to a
> very recent commit authored by you.  Is that not helpful?

No. The bisect is completely meaningless.

The cause of the problem is going to be some piece of corrupted
metadata has got through a verifier check or log recovery and has
resulted in a perag lookup failing. The bisect landed on the commit
where the perag dependency was introduced; whatever is letting
unchecked corrupted metadata throught he verifiers has existed long
before this recent change was made.

I've already spent two hours analysing this report - I've got to the
point where I've isolated the transaction in the trace, I see the
allocation being run as expected, I see all the right things
happening, and then it goes splat after the allocation has committed
and it starts processing defered extent free operations. Neither the
code nor the trace actually tell me anything about the nature of the
failure that has occurred.

At this point, I still don't know where the corrupted metadata is
coming from. That's the next thing I need to look at, and then I
realised that this bug report *doesn't include a pointer to the
corrupted filesystem image that is being mounted*.

IOWs, the bug report is deficient and not complete, and so I'm
forced to spend unnecessary time trying to work out how to extract
the filesystem image from a weird syzkaller report that is basically
just a bunch of undocumented blobs in a github tree.

This is the same sort of shit we've been having to deal rigth from
teh start with syzkaller. It doesn't matter that syzbot might have
improved it's reporting a bit these days, we still have to deal with
this sort of poor reporting from all the private syzkaller bot crank
handles that are being turned by people who know little more than
how to turn a crank handle.

To make matters worse, this is a v4 filesystem which has known
unfixable issues when handling corrupted filesystems in both log
replay and in runtime detection of corruption. We've repeatedly told
people running syzkaller (including Pengfei) to stop running it on
v4 filesystems and only report bugs on V5 format filesystems. This
is to avoid wasting time triaging these problems back down to v4
specific format bugs that ican only be fixed by moving to the v5
format.

.....

And now after 4 hours, I have found several corruptions in the on
disk format that v5 filesystems will have caught and v4 filesystems
will not.

The AGFL indexes in the AGF have been corrupted. They are within
valid bounds, but first + last != count. On a V5 filesystem we catch
this and trigger an AGFL reset that is done of the first allocation.
v4 filesystems do not do this last - first = count validation at
all.

Further, the AGFL has also been corrupted - it is full of null
blocks. This is another problem that V5 filesystems can catch and
report, but v4 filesystems don't because they don't have headers in
the AGFL that enable verification.

Yes, there's definitely scope for further improvements in validation
here, but the unhandled corruptions that I've found still don't
explain how we got a null perag in the xefi created from a
referenced perag that is causing the crash.

So, yeah, the bisect is completely useless, and I've got half a day
into triage and I still don't have any clue what the corruption is
that is causing the kernel to crash....

----

Do you see the problem now, Eric?

Performing root-cause analysis of syzkaller based malicious
filesystem corruption bugs is anything but simple. It takes hours to
days just to work through triage of a single bug report, and we're
getting a couple of these sorts of bug reported every week.

People who do nothing but turn the bot crank handle throw stuff like
this over the wall at usi are easy to find. Bots and bot crank
turners scale really easily. Engineers who can find and fix the
problems, OTOH, don't.

And just to rub salt into the wounds, we now have people who turn
crank handles on other bots to tell everyone else how important
they think the problem is without having performed any triage at
all. And then we're expected to make an untriaged bug report our
highest priority and immediately spend hours of time to make sense
of the steaming pile that has just been dumped on us.

Worse, we've had people who track regressions imply that if we don't
prioritise fixing regressions ahead of anything else we might be
working on, then we might not get new work merged until the
regressions have been fixed. In my book, that's akin to extortion,
and it might give you some insight to why Darrick reacted so
vigorously to having an untriaged syzkaller bug tracked as a high
visibility, must fix regression.

What we really need is more people who are capable to triaging bug
reports like this instead of having lots of people cranking on bot
handles and dumping untriaged bug reports on the maintainer.
Further, if you aren't capable of triaging the bug report, then you
aren't qualified to classify it as a "must fix" regression.

It's like people don't have any common sense or decency anymore:
it's not very nice to classify a bug as a "must fix" regression
without first having consulted the engineers responsible for that
code. If you don't know what the cause of the bug is, then don't
crank handles that cause people to have to address it immediately!

If nothing changes, then the ever increasing amount of bot cranking
is going to burn us out completely. Nobody wins when that
happens....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
