Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750745AbdDMIN6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 04:13:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 853608E00A
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2017 08:13:57 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 0/2 v2] xfsprogs: metadump warns about dirty journal
Date: Thu, 13 Apr 2017 10:13:52 +0200
Message-Id: <20170413081354.22170-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Hi guys

Per the discussion in the previous patches, I'm sending this updated version.
It does nothing with mdrestore, only adds a bit more elaborate warning on
the dump side and adds the same info also to the man page for metadump.

Hopefully, this is ok for everyone and we can continue the discussion
if/what to do with mdrestore in the old thread.


This set is based on xfsprogs: 07a3e79 for-next branch,
git tree is https://github.com/jtulak/xfsprogs-dev/tree/metadump

Cheers,
Jan


Jan Tulak (2):
  metadump: warn about corruption if log is dirty
  xfsprogs: update man for metadump about dirty log/obfuscation issue

 db/metadump.c           | 4 +++-
 man/man8/xfs_metadump.8 | 6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

-- 
2.1.4

