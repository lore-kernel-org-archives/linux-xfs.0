Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43646 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932261AbcJTOLW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Oct 2016 10:11:22 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BDBB34DB14
        for <linux-xfs@vger.kernel.org>; Thu, 20 Oct 2016 14:11:21 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9KEBLU1023310
        for <linux-xfs@vger.kernel.org>; Thu, 20 Oct 2016 10:11:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH] fiemap cow fork flag
Date: Thu, 20 Oct 2016 10:11:17 -0400
Message-Id: <1476972679-571-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is just something I slapped together when poking around and learning the
reflink cow fork stuff. E.g., I find it useful to see exactly what's going on
in certain situations, verify the background reclaim works, etc. I'm not sure
it's worthy of a generic fiemap flag since I believe the cow fork is a fairly
XFS-specific mechanism, it's limited to extra blocks that haven't been written,
and probably dumps information obtainable via other means (tracepoints). I'm
throwing it up on the list anyways for reference and/or archival purposes, if
nothing else. Thanks!

Brian

Brian Foster (1):
  xfs: fiemap support for cow fork

 fs/xfs/xfs_iomap.c          | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.h          |  1 +
 fs/xfs/xfs_iops.c           |  4 ++++
 include/uapi/linux/fiemap.h |  1 +
 4 files changed, 51 insertions(+)

-- 
2.7.4

