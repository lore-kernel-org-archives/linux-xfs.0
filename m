Return-Path: <SRS0=maQ1=AO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EC8C433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 21:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D4220782
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 21:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593811923;
	bh=12HoUnAnObPB1mx09APSYcuqlEl+FkuZnLvcO1zbS9Y=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=pQZsaafNNjxstilhT9/tT529tRLnLcrZwWbs3zJ70eRJCbRqG8cKY/WDryk496cg7
	 e9MF+peC8luuRt71ltTG7yXUjozunWWSS0p49jwMdIic+hWAuDPcvW0PZEhSN1hvsT
	 gG1a7k6IyWHGQ+KLlV4s4pcNMMyGFV6mM0y1R8ac=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgGCVb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jul 2020 17:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726856AbgGCVb6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Jul 2020 17:31:58 -0400
Received: from localhost (c-67-169-218-210.hsd1.or.comcast.net [67.169.218.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7255F20782;
        Fri,  3 Jul 2020 21:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593811918;
        bh=12HoUnAnObPB1mx09APSYcuqlEl+FkuZnLvcO1zbS9Y=;
        h=Date:From:To:Cc:Subject:From;
        b=Vn5JskN0tBDSaPDk/NSa7Q1v9Okrd+Q6RYCIw4AU//mdO2NBqFcSYfBHssGMJ8WmN
         lqvFrMp+MnbFAdv7eDv8blEVN6mSbHzfwmXIIZYHg/q1L5JJEaWabujy/V8IWEZJbO
         aqT56LosIoGQZrTMDR4utIqMBnLriRJLcyrBhalU=
Date:   Fri, 3 Jul 2020 14:31:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Subject: [GIT PULL] xfs: bug fixes for 5.8-rc4
Message-ID: <20200703213158.GF7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this single UAF bug fix for -rc4.

This branch merges cleanly with master as of a few minutes ago, so
please let me know if anything strange happens.

--D

The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.8-fixes-1

for you to fetch changes up to c7f87f3984cfa1e6d32806a715f35c5947ad9c09:

  xfs: fix use-after-free on CIL context on shutdown (2020-06-22 19:22:57 -0700)

----------------------------------------------------------------
Changes for 5.8-rc4:
- Fix a use-after-free bug when the fs shuts down.

----------------------------------------------------------------
Dave Chinner (1):
      xfs: fix use-after-free on CIL context on shutdown

 fs/xfs/xfs_log_cil.c  | 10 +++++-----
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)
