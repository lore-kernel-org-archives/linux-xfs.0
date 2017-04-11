Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751921AbdDKOMt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 10:12:49 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 0/2] xfsprogs: metadump/mdrestore warns about dirty journal
Date: Tue, 11 Apr 2017 16:12:35 +0200
Message-Id: <20170411141237.9274-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net, Jan Tulak <jtulak@redhat.com>

If we are exporting obfuscated metadata with a dirty journal, the journal is not obfuscated. So when we restore it and then replay a log, the obfuscated metadata can clash with what is in journal and corrupt the image. So, tell the user about this risk, both when exporting and importing the dump.


Git tree on github: https://github.com/jtulak/xfsprogs-dev/tree/metadump
Based on revision fc1d645

Jan Tulak (2):
  metadump: warn about corruption if log is dirty
  mdrestore: warn about corruption if log is dirty

 db/metadump.c             |  3 +-
 mdrestore/Makefile        |  4 +--
 mdrestore/xfs_mdrestore.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+), 3 deletions(-)

-- 
2.1.4

