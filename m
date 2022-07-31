Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B702C00140
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Jul 2022 15:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbiGaPDe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jul 2022 11:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbiGaPDd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Jul 2022 11:03:33 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EBCDEDF
        for <linux-xfs@vger.kernel.org>; Sun, 31 Jul 2022 08:03:33 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 130so635058pfv.13
        for <linux-xfs@vger.kernel.org>; Sun, 31 Jul 2022 08:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=CqarRD0qBma+nkDvEq8uD5MNW2b7at7eSJRZBX+iSRg=;
        b=c+Lg4tTvxwhoOwnitw/8esS0JfRoc7588NH7ZMpcW3trPL7rLOUSI9E/7Fn9wyoTXR
         iqvu1jS9uH0faNEStn9gcKsXTyKXNAgsmqpYhSSGq9GPLziCD8YhniqMqEL1C6pEj1Pc
         x9DXY+9k/GIkN2xA3bfpjoUIqEL1v+nOIPfPx9A9YlQ8ZOTf+/wTMeWJr3nIvhmK/fud
         w0zhCeQpGtOBIYB1QuxuCw0VwqqN8reqSThtHucdOm3MJ+N4+sE+KafHGvTugfal/DqZ
         x1kOttY8idYKSHL64B/VsfAAZl6tTrvgoFWOsuvLGlEz36VhHp0nZOeUxRm7XFFOTKE3
         96PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=CqarRD0qBma+nkDvEq8uD5MNW2b7at7eSJRZBX+iSRg=;
        b=XYx0T71q3IfKwP6MpnM5/rV24OgFS3i3+ffy2jUQAFM6w3TMTfJfw7bNRignt32FIq
         IU5i6M2ThMiRFdVJ7zLNO/g754SQn81e8l5Af6m/r/KI8WRTUeqHFbkgSLiOd4DD4Yut
         elctgJZaGo9vyx5/O4AiO9NDnckq+bVzxQkC7iIV9oSVwzWVf3/PHSjKz4L/ZTwPQz/s
         KlwqdJ31psbuVwnZt5WH7RVVy97hEXqH3SphScM6E5tKcn8XUhG+rWDL43Vl4aNM5uKD
         Wac/QgBAqhNTvsWKR4ba32D8SsO2SfLu1RWgTbpMDmfY2NmEuDLHx6CZiJ7JyG4sc89Q
         Cvsw==
X-Gm-Message-State: AJIora+8I4uxuIZOn73UMbbDVKZ9YrcHlfyxHfxGadulZ03hXsRzxAFC
        xvAFD5/ptYSs0RsOccVb38QiGA==
X-Google-Smtp-Source: AGRyM1sbh/JldyhtTyQMu6gVq6HNWLs7pK2HOedzv2yx6vukYAF9/lxIclfHNmb5/Hjseat7ThTgNA==
X-Received: by 2002:a63:eb0d:0:b0:41b:7a15:1fbb with SMTP id t13-20020a63eb0d000000b0041b7a151fbbmr10085682pgh.511.1659279812442;
        Sun, 31 Jul 2022 08:03:32 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u17-20020a170903125100b0016d33b8a231sm7582928plh.270.2022.07.31.08.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jul 2022 08:03:32 -0700 (PDT)
Message-ID: <c737af00-e879-fe01-380c-ba95b555f423@kernel.dk>
Date:   Sun, 31 Jul 2022 09:03:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring support for buffered writes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

On top of the core io_uring changes for 5.20, this pull request contains
support for buffered writes, specifically for XFS. btrfs is in progress,
will be coming in the next release.

io_uring does support buffered writes on any file type, but since the
buffered write path just always -EAGAIN (or -EOPNOTSUPP) any attempt to
do so if IOCB_NOWAIT is set, any buffered write will effectively be
handled by io-wq offload. This isn't very efficient, and we even have
specific code in io-wq to serialize buffered writes to the same inode to
avoid further inefficiencies with thread offload.

This is particularly sad since most buffered writes don't block, they
simply copy data to a page and dirty it. With this pull request, we can
handle buffered writes a lot more effiently. If balance_dirty_pages()
needs to block, we back off on writes as indicated.

This improves buffered write support by 2-3x.

Jan Kara helped with the mm bits for this, and Stefan handled the
fs/iomap/xfs/io_uring parts of it.

Please pull!


The following changes since commit f6b543fd03d347e8bf245cee4f2d54eb6ffd8fcb:

  io_uring: ensure REQ_F_ISREG is set async offload (2022-07-24 18:39:18 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.20/io_uring-buffered-writes-2022-07-29

for you to fetch changes up to 0dd316ba8692c2374fbb82cce57c0b23144f2977:

  mm: honor FGP_NOWAIT for page cache page allocation (2022-07-24 18:39:32 -0600)

----------------------------------------------------------------
for-5.20/io_uring-buffered-writes-2022-07-29

----------------------------------------------------------------
Jan Kara (3):
      mm: Move starting of background writeback into the main balancing loop
      mm: Move updates of dirty_exceeded into one place
      mm: Add balance_dirty_pages_ratelimited_flags() function

Jens Axboe (2):
      io_uring: fix issue with io_write() not always undoing sb_start_write()
      mm: honor FGP_NOWAIT for page cache page allocation

Stefan Roesch (11):
      iomap: Add flags parameter to iomap_page_create()
      iomap: Add async buffered write support
      iomap: Return -EAGAIN from iomap_write_iter()
      fs: add a FMODE_BUF_WASYNC flags for f_mode
      fs: add __remove_file_privs() with flags parameter
      fs: Split off inode_needs_update_time and __file_update_time
      fs: Add async write file modification handling.
      io_uring: Add support for async buffered writes
      io_uring: Add tracepoint for short writes
      xfs: Specify lockmode when calling xfs_ilock_for_iomap()
      xfs: Add async buffered write support

 fs/inode.c                      | 168 +++++++++++++++++++++++++++++-----------
 fs/iomap/buffered-io.c          |  67 ++++++++++++----
 fs/read_write.c                 |   4 +-
 fs/xfs/xfs_file.c               |  11 ++-
 fs/xfs/xfs_iomap.c              |  11 ++-
 include/linux/fs.h              |   4 +
 include/linux/writeback.h       |   7 ++
 include/trace/events/io_uring.h |  25 ++++++
 io_uring/rw.c                   |  41 ++++++++--
 mm/filemap.c                    |   4 +
 mm/page-writeback.c             |  89 +++++++++++++--------
 11 files changed, 323 insertions(+), 108 deletions(-)

-- 
Jens Axboe

