Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751788AbdF0Oki (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jun 2017 10:40:38 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 73B75C04D2A8
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2017 14:40:37 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5875585A4C
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2017 14:40:37 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/4] xfs: log recovery wrap and tail overwrite fixes
Date: Tue, 27 Jun 2017 10:40:32 -0400
Message-Id: <1498574436-57561-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's a first real stab at a fix for the log tail overwrite issue. The
general approach is similar to torn write detection: move the tail
forward when corruption is detected within the range of a possible tail
overwrite.

Patch 1 fixes an independent and spurious log recovery failure when a
log record header wraps around the end of the physical log. Patch 2 is a
semi-preparatory patch that unconditionally invokes log tail
verification rather than only after torn write detection at the head.
Patch 3 introduces the core fix to move the tail forward in the event of
corruption. Patch 4 introduces an error injection tag to force log item
pinning and facilitates the test that reliably reproduces the tail
overwrite problem.

This survives the latest variant of the xfstests test that reproduces
the tail overwrite condition and otherwise hasn't shown any regressions
in my testing so far (still ongoing). This also allows the metadump
images provided by Sweet Tea[1] to mount (though those images do still
show filesystem corruption after mount, so I suspect something more is
going on there).

One other slight change worth noting in log recovery behavior is that
tail overwrite detection causes earlier reporting of legitimate log CRC
or corruption errors. Before this series, a log corruption that is not
resolved by torn write/tail overwrite detection results in log recovery
failure after a partial recovery up to the point at which the corruption
is encountered. After this series, it is very likely that the corruption
is identified during tail verification and an error returned to
userspace before real recovery begins.

An xfs_repair is necessary in either case, but I'm curious if there is a
preference towards the old or newly proposed behavior. An alternative
I've considered to preserve the old behavior, for example, is to use the
tail verification CRC pass for tail fixing only (and otherwise consider
errors at this point as nonfatal). This means that we would fix up the
tail if possible, otherwise leave errors to the real recovery sequence
such that a partial recovery can occur before the (imminent) failure.
Thoughts?

Brian

v1:
- Add patch to fix log recovery header wrapping problem.
- Replace transaction reservation rfc with log recovery based fix.
- Replace custom log pinning sysfs knob with error injection tag.
rfc: http://www.spinics.net/lists/linux-xfs/msg07623.html

[1] http://www.spinics.net/lists/linux-xfs/msg07667.html


Brian Foster (4):
  xfs: fix recovery failure when log record header wraps log end
  xfs: always verify the log tail during recovery
  xfs: fix log recovery corruption error due to tail overwrite
  xfs: add log item pinning error injection tag

 fs/xfs/xfs_error.c       |   3 +
 fs/xfs/xfs_error.h       |   4 +-
 fs/xfs/xfs_log_recover.c | 150 +++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_trans_ail.c   |  17 +++++-
 4 files changed, 114 insertions(+), 60 deletions(-)

-- 
2.7.5

