Return-Path: <SRS0=2RH+=XM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BODY_QUOTE_MALF_MSGID,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE7CC4CECD
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Sep 2019 15:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CC5321881
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Sep 2019 15:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568733702;
	bh=wpzbNHazTaZFk4ufsoQVUeBGVtbQGktyi+fGFo9LDxA=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=EniJxsCvh68UajsSG7XljPCgMzRDfIaX5Krb2xQcaP7S6IGHW14jLSoNso3PZ6xVS
	 CRrAF1NCuqm79IUzkvbZ7/hC5ke6MOlTPyah2U7fWoIFq1UMKfjBgyla0+Sf7aQME5
	 FttaPAiOcSsdTsO1Gm4xHu6Y+/vlR6h9MLVfzpqU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfIQPVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Sep 2019 11:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbfIQPVl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Sep 2019 11:21:41 -0400
Received: from localhost (c-67-169-218-210.hsd1.or.comcast.net [67.169.218.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53E1F2171F;
        Tue, 17 Sep 2019 15:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568733700;
        bh=wpzbNHazTaZFk4ufsoQVUeBGVtbQGktyi+fGFo9LDxA=;
        h=Date:From:To:Cc:Subject:From;
        b=qW9mDyWYB7KlMPnnl9SXmaxZt+brxj9yMmZlQ4Z/tI5Iu6ef8vDTZQ+ODciGSUjod
         KZ14r4+/i7BBWrf1z3Qj/stOyAgESheg3g3r5aUUc3Cp3t7myWQkxGXL9ic8ltszss
         6QRSa1d8z+PpJKaE6g40sTOzggjwYJYUzHbf5pvA=
Date:   Tue, 17 Sep 2019 08:21:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de, agruenba@redhat.com,
        rpeterso@redhat.com, cluster-devel@redhat.com
Subject: [GIT PULL] iomap: new code for 5.4
Message-ID: <20190917152140.GU2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this series containing all the new iomap code for 5.4.  The
biggest change here is porting some of XFS' writeback code to iomap so
that we can share it with other filesystems; and making some adjustments
to the iomap directio code in preparation for other filesystems starting
to use it.  In 5.5 we hope to finish converting XFS to iomap and to
start converting a few other filesystems.

The branch merges cleanly against this morning's HEAD and survived a
couple of weeks' worth of xfstests.  The merge was completely
straightforward, so please let me know if you run into anything weird.

--D

The following changes since commit 609488bc979f99f805f34e9a32c1e3b71179d10b:

  Linux 5.3-rc2 (2019-07-28 12:47:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.4-merge-4

for you to fetch changes up to 68494b8e248fe8a7b6e9f88edd9a87661760ddb9:

  iomap: move the iomap_dio_rw ->end_io callback into a structure (2019-09-03 08:28:22 -0700)

----------------------------------------------------------------
New code for 5.4:
- Port the XFS writeback code to iomap with the eventual goal of
  converting XFS to use it.
- Clean up a few odds and ends in xfs writeback and convert the xfs
  ioend code to use list_pop and friends.
- Report both io errors and short io results to the directio endio
  handler.
- Allow directio callers to pass an ops structure to iomap_dio_rw.

----------------------------------------------------------------
Andreas Gruenbacher (1):
      iomap: Fix trivial typo

Christoph Hellwig (9):
      list.h: add list_pop and list_pop_entry helpers
      iomap: copy the xfs writeback code to iomap.c
      iomap: add tracing for the address space operations
      iomap: warn on inline maps in iomap_writepage_map
      xfs: set IOMAP_F_NEW more carefully
      iomap: zero newly allocated mapped blocks
      xfs: initialize iomap->flags in xfs_bmbt_to_iomap
      xfs: refactor the ioend merging code
      iomap: move the iomap_dio_rw ->end_io callback into a structure

Matthew Bobrowski (1):
      iomap: split size and error for iomap_dio_rw ->end_io

Randy Dunlap (1):
      tracing: fix iomap.h build warnings

 fs/iomap/buffered-io.c       | 575 ++++++++++++++++++++++++++++++++++++++++++-
 fs/iomap/direct-io.c         |  24 +-
 fs/xfs/xfs_aops.c            |  70 +++---
 fs/xfs/xfs_file.c            |  14 +-
 fs/xfs/xfs_iomap.c           |  35 ++-
 fs/xfs/xfs_iomap.h           |   2 +-
 fs/xfs/xfs_pnfs.c            |   2 +-
 include/linux/iomap.h        |  53 +++-
 include/linux/list.h         |  33 +++
 include/trace/events/iomap.h |  87 +++++++
 10 files changed, 824 insertions(+), 71 deletions(-)
 create mode 100644 include/trace/events/iomap.h
