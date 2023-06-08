Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBB6C7EE25
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jun 2023 06:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbjFHG1Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jun 2023 02:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234391AbjFHG1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 02:27:16 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B773D1FFE
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 23:27:14 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so111987a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jun 2023 23:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686205634; x=1688797634;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lWJErgnZOyiHy/BxxcAbz8HHaFSxmwVIPG0//Q5YWSc=;
        b=tdzw+RxYaWgIH378jUf7h/1qe/x7y9m5DsAcrQPdvFJ3Q5K861GaRR+IWWwfffCpKM
         yMEzlQ1LvUwPaaoqg15X6BswFuzhvc0K99gQsKJMo8DnTYrHr6lqIOFm+SkiiNyiT/4K
         IkrHdP37JRlBNVX7IYTMTxXwtOYdH2+j6GFGYJUkzDw/xQJiHpDo3jP7Irb7d8a+iRKF
         Ie6YDn2amxLcSoLFvF2uOrlnoz/e7onQrLzk2CtSUCdUhvC0EyF5M/pgPrVj8M4Axhel
         ZJPoeA2YvK0OpQLJHyZFTrJrkEfBqsJ7PmEehPM5TGZ8zoG+m9PyDfdYlgivxye2tZMf
         g/UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686205634; x=1688797634;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lWJErgnZOyiHy/BxxcAbz8HHaFSxmwVIPG0//Q5YWSc=;
        b=b/4mXIY8qpPUXmDDXkZft2v/x2ijmTmS8k5UJ18CxsaTxUHTSLr3JBomKkHNlIY7T0
         lo1npI5qd4YMH3vFZl8tQTC8bQcVjiNYRBGF3uqdf9EUriJ6Zt8DZzvRv7W6khqaQCRe
         EwigZko0yfV8wCltJnGHoiJzQH5rsNN/U05QEhfysKO9NVU3HZDHQcnkJ5O+sPISBH5T
         htq4UfnCuXeRmmoZH1uMYtFr3VRVgENcUNpAiGEMm7rI+HKT7noxsr7ujv22+np/2egX
         EZGJ7AbEK2JYLCtZ5dVkVX3640FvoQWEEW81IsL513Hr0e3puRc2GUShVeB5MD9S6orx
         raJA==
X-Gm-Message-State: AC+VfDxUfH3VFKaKKQj4YLj+EMFAfizPPHBHiNCA3+6F17XhFlsiKM7J
        bYS2Se/8mCKwf0zLV6XwimEfBh2wl5wzql6llNI=
X-Google-Smtp-Source: ACHHUZ7FV5WQlPW+0Jro+oyHNC3x/FfC5KF2JFjnx//JsyA5G1Fod40fM3qB9yLtYk46o9dH4OWNKA==
X-Received: by 2002:a17:902:da84:b0:1b2:507e:577f with SMTP id j4-20020a170902da8400b001b2507e577fmr4557662plx.64.1686205634117;
        Wed, 07 Jun 2023 23:27:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id iy2-20020a170903130200b001ae42480c82sm568804plb.226.2023.06.07.23.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 23:27:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q7970-009BnU-1X;
        Thu, 08 Jun 2023 16:27:10 +1000
Date:   Thu, 8 Jun 2023 16:27:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: fixes for 6.4-rc5
Message-ID: <ZIF0vl9b+x8gejIf@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Can you please pull the latest XFS updates fixes from the tag below?

These are a set of regression fixes discovered on recent kernels.  I
was hoping to send this to you a week and half ago, but events out
of my control delayed finalising the changes until early this week.

Whilst the diffstat looks large for this stage of the merge window,
a large chunk of it comes from moving the guts of one function from
one file to another i.e. it's the same code, it is just run in a
different context where it is safe to hold a specific lock.
Otherwise the individual changes are relatively small and straigtht
forward.

The code in the XFS branch merges cleanly with your tree as of
commit 5f63595ebd82 ("Merge tag 'input-for-v6.4-rc5' of
git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input"). Let me
know if you see something different or unexpected.

-Dave.

----------------------------------------------------------------

The following changes since commit 9561de3a55bed6bdd44a12820ba81ec416e705a7:

  Linux 6.4-rc5 (2023-06-04 14:04:27 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.4-rc5-fixes

for you to fetch changes up to d4d12c02bf5f768f1b423c7ae2909c5afdfe0d5f:

  xfs: collect errors from inodegc for unlinked inode recovery (2023-06-05 14:48:15 +1000)

----------------------------------------------------------------
xfs: fixes for 6.4-rc5

This update contains:
- Propagate unlinked inode list corruption back up to log recovery (regression
  fix).
- improve corruption detection for AGFL entries, AGFL indexes and XEFI extents
  (syzkaller fuzzer oops report).
- Avoid double perag reference release (regression fix).
- Improve extent merging detection in scrub (regression fix).
- Fix a new undefined high bit shift (regression fix).
- Fix for AGF vs inode cluster buffer deadlock (regression fix).

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: fix broken logic when detecting mergeable bmap records

Dave Chinner (9):
      xfs: buffer pins need to hold a buffer reference
      xfs: restore allocation trylock iteration
      xfs: defered work could create precommits
      xfs: fix AGF vs inode cluster buffer deadlock
      xfs: fix double xfs_perag_rele() in xfs_filestream_pick_ag()
      xfs: fix agf/agfl verification on v4 filesystems
      xfs: validity check agbnos on the AGFL
      xfs: validate block number being freed before adding to xefi
      xfs: collect errors from inodegc for unlinked inode recovery

Geert Uytterhoeven (1):
      xfs: Fix undefined behavior of shift into sign bit

 fs/xfs/libxfs/xfs_ag.c          |   5 +++-
 fs/xfs/libxfs/xfs_alloc.c       |  91 ++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_alloc.h       |   6 ++---
 fs/xfs/libxfs/xfs_bmap.c        |  10 ++++++--
 fs/xfs/libxfs/xfs_bmap_btree.c  |   7 ++++--
 fs/xfs/libxfs/xfs_ialloc.c      |  24 ++++++++++++-------
 fs/xfs/libxfs/xfs_log_format.h  |   9 ++++++-
 fs/xfs/libxfs/xfs_refcount.c    |  13 ++++++++---
 fs/xfs/libxfs/xfs_trans_inode.c | 113 +++++++---------------------------------------------------------------------------------
 fs/xfs/scrub/bmap.c             |  25 ++++++++++----------
 fs/xfs/scrub/scrub.h            |   8 +++----
 fs/xfs/xfs_buf_item.c           |  88 ++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_filestream.c         |   1 -
 fs/xfs/xfs_icache.c             |  46 +++++++++++++++++++++++++++++-------
 fs/xfs/xfs_icache.h             |   4 ++--
 fs/xfs/xfs_inode.c              |  20 +++++-----------
 fs/xfs/xfs_inode.h              |   2 +-
 fs/xfs/xfs_inode_item.c         | 149 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode_item.h         |   1 +
 fs/xfs/xfs_log_recover.c        |  19 +++++++--------
 fs/xfs/xfs_mount.h              |   1 +
 fs/xfs/xfs_reflink.c            |   4 +++-
 fs/xfs/xfs_super.c              |   1 +
 fs/xfs/xfs_trans.c              |   9 ++++++-
 24 files changed, 427 insertions(+), 229 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
