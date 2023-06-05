Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E6CC77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 05:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjFEFH1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 01:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjFEFH0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 01:07:26 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5D3B1
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 22:07:25 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id af79cd13be357-75eb918116aso47493785a.3
        for <linux-xfs@vger.kernel.org>; Sun, 04 Jun 2023 22:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685941644; x=1688533644;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y9kFoyjGYEZXSuPhYUVJHBFRMN3PMQZBxF2c6rHuWeI=;
        b=neTpWkAsq6dCVO1Mn+KejpP6LaouoPkAjVjcXLLCBsAUp+UT4Llngux8fkOnNGfc8T
         u3iRP5CWpdv5neWv1NTfs/Lr4GMqdjT6+DQr8W576EEIAoDdQdvZ5KKAlVsPh+KfOgug
         0SDzNkckHX78aeJyvy2Bn+ipKR0EkFuHv7I5CCu7i408syoYm+p2DrHIyBsyhYEWJJ4E
         qiOgHBUeA1oPQgnO4v46nAJjLVMkw4VpZq+iM2XMPCKFNIh4Scl7ee/f4A6EUcBuSiQx
         ly29hIAAWPQBsVU3bjAwAEUFUprndEMMLRwIqUkRCrCPSPsdpf/RQzfUrT+uH9jTo2xp
         ORVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685941644; x=1688533644;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9kFoyjGYEZXSuPhYUVJHBFRMN3PMQZBxF2c6rHuWeI=;
        b=hFJPmQ76k/2Kp1lPulIYqhmrV5S7rVco4xLL/TYrQen0awJmvjdiPnVS3WlK0+BASz
         pWN9xsM6RLH2lp6MXpuwHGSleFB95nzqsaU8sjcD9Ujjz6j7QesHbXE0BOQXmFl6ct31
         N19CnzxHHEd1rUGXcixaKu1D6U4yN4wfAI9XWBMjYmXq6Mi4GNbUmtdzeMMliXIkY+lO
         kmIa+2CQeXvC8MdFi6oYJMhUxo0soFg/CzqZWHcBvgV1oJIT8LvDoIgMbATfrL1XIe9g
         9lIz5Wi2JOcYIYgy/0rXpBq36UL4jQW1J8lJAx3jLeXKIqYRedKpCnFVF1ZWZmaPsBL3
         L08A==
X-Gm-Message-State: AC+VfDxB/oY8yk7oawVVSwDL5JN/kPbLedMMfCfY0hLc3FHuEt43VJtq
        drp9T268mZosCRRQuNclk+QLbvKhcdyjsFU7omM=
X-Google-Smtp-Source: ACHHUZ7IxYgcTHIlj8c0ZsHJdoqQM2OGslEiR6WT2SPlFb1pc6vPRI08EP1TLXx3M6b+8hiZSdn01Q==
X-Received: by 2002:a05:620a:219b:b0:75b:23a0:e7ac with SMTP id g27-20020a05620a219b00b0075b23a0e7acmr19843504qka.13.1685941644245;
        Sun, 04 Jun 2023 22:07:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090a3b4800b00246cc751c6bsm7225749pjf.46.2023.06.04.22.07.23
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 22:07:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q62R6-007y8d-1g
        for linux-xfs@vger.kernel.org;
        Mon, 05 Jun 2023 15:07:20 +1000
Date:   Mon, 5 Jun 2023 15:07:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs: for-next rebased to d4d12c02bf5f
Message-ID: <ZH1tiD4z4/revqp3@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I just rebased the for-next tree to correct a bad fixes tag in
the tree that was flags by a linux-next sanity check. The code is
the same, just a commit message needed rewriting, but that means all
the commit change and you'll need to do forced update if you pulled
the branch I pushed a few hours ago.

-Dave.

----------------------------------------------------------------

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

  Head Commit: d4d12c02bf5f768f1b423c7ae2909c5afdfe0d5f

  xfs: collect errors from inodegc for unlinked inode recovery (2023-06-05 14:48:15 +1000)

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
