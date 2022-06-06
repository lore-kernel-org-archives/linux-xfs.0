Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55D2CCA481
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 16:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241446AbiFFQFv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 12:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241574AbiFFQFt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 12:05:49 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD3218704B;
        Mon,  6 Jun 2022 09:05:48 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id d5-20020a05600c34c500b0039776acee62so7381669wmq.1;
        Mon, 06 Jun 2022 09:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W7N6pO0rh2CjNPFiLrKJmnvgIh81H+k7QbzdUR3EZ8g=;
        b=AkeN8kHYe/hERiEdVxjnygy38s1kthqzY2nRpwIPprA049lx1ECTvaNJYPdgljWCeT
         wXbeBF3vF4EJjheaSiqkCS52NG6xDJs1B2f4VY46KjYgPb0TmjjeGUOGeccEs2NOldVL
         IBwTMmr7C/YY15CKaC9OIEJR0CcMMpG/uRfA5SWb2ew3d4fPtZ/3DNu/gXYHxTCbAcl5
         tWpLAeGw3lmBTvnuCPjXV1uxGMigMtEw8SGfiU8G1CGXZlCDlTzy82RyJn/dtwG37ESL
         U2vj47xtqA3qhDoAvKW13LtvMwRelEeUa5hFLazJN5LpQl81tsQ53zIcLs0RE3H0MCf3
         BCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W7N6pO0rh2CjNPFiLrKJmnvgIh81H+k7QbzdUR3EZ8g=;
        b=MOQKs5QfkERDQDFwnjCv3jqi0C+f0p4Qi2tEu5Yz+txHgNGuKlElqznyCwc9dh3QML
         Vly7ice498DocBdzbPnEPwBooFB3bWLEzIYmOaUwU5eUo/NRC4MM39CKlbP0Zc9Tfq7P
         GPRziNfqRsMFFKgHwmTb29H/6hQYL6LbWtVgF6qkI+DoCsbQtCenctJ188W2bxjcBKEp
         J/dwoP1sVBaWfEYxkN5Ldn4h8Tae4MYyQJXqR4uVSfTaJSXZwRqh5xO/OK1sExWiospY
         oUxmOmmuQJWeUwQczaEvqvFLvPO6UqBzcB+EitQGHwgllmETVTqsoTJrmrcKfy+N0OnF
         C9vA==
X-Gm-Message-State: AOAM5330pkflPQi0oQbp0LCkEXVy8E6o9RWejdvqZR681hCn9dYR3RpV
        kFdpBvS8W5JYQdwFlPIXNgizRGrTfwMJvg==
X-Google-Smtp-Source: ABdhPJy0C8GbtwPgqqkwUqyQpDVA1ZYcXMAROFeRjqmALW+kgBTBrI8uvkrbgy4VE0ZxAw6/tEIT5w==
X-Received: by 2002:a1c:7901:0:b0:39c:4252:d7f1 with SMTP id l1-20020a1c7901000000b0039c4252d7f1mr15983423wme.178.1654531546781;
        Mon, 06 Jun 2022 09:05:46 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c3b9600b00397342e3830sm25681327wms.0.2022.06.06.09.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 09:05:46 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 0/7] xfs stable candidate patches for 5.10.y (part 3)
Date:   Mon,  6 Jun 2022 19:05:30 +0300
Message-Id: <20220606160537.689915-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all!

This is the 3rd part of a collection of stable patch candidates that
I collected from xfs releases v5.11..v5.18.

Part #1 is already in 5.10.120 and part #2 has been posted to stable.

The patches in this part are from circa v5.12..v5.13.

They have been soaking in kdevops for over a week with no regressions
from baseline observed.

There are four user visible fixes in this part, one patch for dependency
("rename variable mp") and two patches to improve testability of LTS.

Specifically, I selected the fix ("use current->journal_info for
detecting transaction recursion") after I got a false positive assert
while testing LTS kernel with XFS_DEBUG and at another incident, it
helped me triage a regression that would have been harder to trace
back to the offending code otherwise.

It is worth noting that one patch from v5.13 did cause a regression
and was removed from the stable candidates queue during early testing -
0fe0bbe00a6f ("xfs: bunmapi has unnecessary AG lock ordering issues").

When I did a post mortem on a patch that I missed for part #2, I started
off on the wrong foot with Dave, so it is important for me to say this:
Although I had wrongly selected this fix, all the information I needed
to make the right decision was in the commit message, I just did not
understand it at the time that I selected the patch.

But when my tests had detected hangs on test xfs/299, that quickly lead
me to the mention of xfs/299 in the commit message and then I understood
that the fix was incorrect without "deferred inode inactivation" series
from 5.13-rc1.

I would like to thank Samsung and Luis for the resources and efforts
that make this work possible.

Your inputs on these stable candidates are most welcome!

Thanks,
Amir.


Anthony Iliopoulos (1):
  xfs: fix xfs_trans slab cache name

Darrick J. Wong (1):
  xfs: fix xfs_reflink_unshare usage of filemap_write_and_wait_range

Dave Chinner (2):
  xfs: use current->journal_info for detecting transaction recursion
  xfs: update superblock counters correctly for !lazysbcount

Gao Xiang (1):
  xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX

Pavel Reichl (2):
  xfs: rename variable mp to parsing_mp
  xfs: Skip repetitive warnings about mount options

 fs/iomap/buffered-io.c    |   7 ---
 fs/xfs/libxfs/xfs_btree.c |  12 +++-
 fs/xfs/libxfs/xfs_sb.c    |  16 ++++-
 fs/xfs/xfs_aops.c         |  17 +++++-
 fs/xfs/xfs_error.c        |   2 +
 fs/xfs/xfs_reflink.c      |   3 +-
 fs/xfs/xfs_super.c        | 120 +++++++++++++++++++++-----------------
 fs/xfs/xfs_trans.c        |  23 +++-----
 fs/xfs/xfs_trans.h        |  30 ++++++++++
 9 files changed, 148 insertions(+), 82 deletions(-)

-- 
2.25.1

