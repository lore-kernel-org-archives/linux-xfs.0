Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C0BC77B7D
	for <linux-xfs@archiver.kernel.org>; Thu, 11 May 2023 02:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjEKCBY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 May 2023 22:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjEKCBP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2023 22:01:15 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306E7269E
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 19:01:11 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-643bb9cdd6eso5609449b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 19:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683770470; x=1686362470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EI0c6tOvbGYQJWs6SukkN8skDI10Rw06RlG6aV29GN0=;
        b=aDRptfungUFZUFY7iK7olUms0o3zcICRMBOhb4DfxKrFLFhieGDeBPreFWyqsloqR7
         0AFbGSWJ4wdNCdh0RBFFMl8huTk3tvLJcyJVumSXrkpt6o1dgLR95e502OdpZ6bg6Tp3
         bQP/p8GerbAr5BZoafMIzWXYr4O0r2Z+ocg9fmj2+BbOSvXnPm4HOogOMFXMXS17mfrQ
         i6g52Ej0dsMaMTDPpPX82fQuxdasn+2wyxRMTnSpaYfD4RxoOHJgROoUi6yeGlCXe1Dh
         ZyhtGeT0LAOJOUlt7jIXgEfqD2cd5ybFzOl1TQmOqDlMeuxvDljX79NSxaKjc9G2Sfwq
         yH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683770470; x=1686362470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EI0c6tOvbGYQJWs6SukkN8skDI10Rw06RlG6aV29GN0=;
        b=bG6Gd6mHugmIfMgNjAuVWx1hGxYA9LJUComeqzzfGwyYxtqyGJVSQnZ3rkX+a3Tjls
         7iK0Rfg5gA2Niup7iioCnZ+6NuJVR+vnyk/mx2Py/iOYklnfqhAnZ3EOR6TnoUxDg8dr
         Lmub4dqYVBrHGrklq5wtL7BqEbW4KLNg9C6zhNbQ3q56zwDQsQM54y7cp7Hw7FH+4hxO
         aTOE6IV0e/76Jnaq6ObgG1umfKdwEuLWj3ruyaqccTo+JaBL5NfRqSRUGI9dFQUJ/SJK
         EagQ1dNeBWlRfXG3kIKAfFBPnLVd6QtpSPc+ayVxQ63694jifBBLw3maRS116qtuXU+Q
         18OA==
X-Gm-Message-State: AC+VfDys571LcHOvmE2WOwaDVffQgLuW9SlU521J6eDKLPI3AtCg3ONs
        xIFS5/QKsgeU8UkOVkrjvw9BEQ==
X-Google-Smtp-Source: ACHHUZ4HrYXigdNQ6Cd7QK2kaCuFFYIGiPlPCZ/7gklSXX/PaF3WxBURUd6Zv8GPeLhTwGYhNaEC1g==
X-Received: by 2002:a05:6a20:7da1:b0:101:65a2:e06b with SMTP id v33-20020a056a207da100b0010165a2e06bmr9263938pzj.20.1683770470643;
        Wed, 10 May 2023 19:01:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id a15-20020aa7864f000000b00639a1f7b54fsm2663790pfo.60.2023.05.10.19.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 19:01:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pwvcB-00Dq8c-6p; Thu, 11 May 2023 12:01:07 +1000
Date:   Thu, 11 May 2023 12:01:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: bug fixes for 6.4-rc2
Message-ID: <20230511020107.GI2651828@dread.disaster.area>
References: <20230511015846.GH2651828@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511015846.GH2651828@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[ and now with the correct cc's. DOH! ]

Hi Linus,

Can you please pull the latest XFS updates fixes from the tag below?
The are largely minor bug fixes and cleanups, th emost important of
which are probably the fixes for regressions in the extent
allocation code. It merges cleanly with your current tree as of a
few minutes ago, so I don't expect you to see anything weird from
it.

The only thing worth noting is that turning off the counter scrub
code temporarily may produce a new warning about eliding unreachable
code on some compilers. I have not seen this myself (using gcc-12)
but it is harmless and will go away with the kernel-side exclusive
freeze infrastructure that we are hoping will get merged in the next
cycle.

Cheers,

Dave.

---

The following changes since commit 9419092fb2630c30e4ffeb9ef61007ef0c61827a:

  xfs: fix livelock in delayed allocation at ENOSPC (2023-04-27 09:02:11 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.4-rc1-fixes

for you to fetch changes up to 2254a7396a0ca6309854948ee1c0a33fa4268cec:

  xfs: fix xfs_inodegc_stop racing with mod_delayed_work (2023-05-02 09:16:14 +1000)

----------------------------------------------------------------
xfs: bug fixes for 6.4-rc2

o fixes for inode garbage collection shutdown racing with work queue
  updates
o ensure inodegc workers run on the CPU they are supposed to
o disable counter scrubbing until we can exclusively freeze the
  filesystem from the kernel
o Regression fixes for new allocation related bugs
o a couple of minor cleanups

----------------------------------------------------------------
Darrick J. Wong (9):
      xfs: don't unconditionally null args->pag in xfs_bmap_btalloc_at_eof
      xfs: set bnobt/cntbt numrecs correctly when formatting new AGs
      xfs: flush dirty data and drain directios before scrubbing cow fork
      xfs: don't allocate into the data fork for an unshare request
      xfs: fix negative array access in xfs_getbmap
      xfs: explicitly specify cpu when forcing inodegc delayed work to run immediately
      xfs: check that per-cpu inodegc workers actually run on that cpu
      xfs: disable reaping in fscounters scrub
      xfs: fix xfs_inodegc_stop racing with mod_delayed_work

 fs/xfs/libxfs/xfs_ag.c    | 19 +++++++++----------
 fs/xfs/libxfs/xfs_bmap.c  |  5 +++--
 fs/xfs/scrub/bmap.c       |  4 ++--
 fs/xfs/scrub/common.c     | 26 --------------------------
 fs/xfs/scrub/common.h     |  2 --
 fs/xfs/scrub/fscounters.c | 13 ++++++-------
 fs/xfs/scrub/scrub.c      |  2 --
 fs/xfs/scrub/scrub.h      |  1 -
 fs/xfs/scrub/trace.h      |  1 -
 fs/xfs/xfs_bmap_util.c    |  4 +++-
 fs/xfs/xfs_icache.c       | 40 +++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_iomap.c        |  5 +++--
 fs/xfs/xfs_mount.h        |  3 +++
 fs/xfs/xfs_super.c        |  3 +++
 14 files changed, 65 insertions(+), 63 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
