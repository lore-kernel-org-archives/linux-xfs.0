Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EA0C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 17 May 2021 17:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1D1860FD8
	for <linux-xfs@archiver.kernel.org>; Mon, 17 May 2021 17:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhEQRSp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 May 2021 13:18:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53055 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235931AbhEQRSo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 May 2021 13:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621271847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rwUi4tSQ4PHz2iLzaWyR4muXzjdcrEITtsZgU3Lfc/c=;
        b=M1X25YOtXmibIrW6ZGHxqIU+GZeMqxyx3g62LGZqI207DaSTElfymhC45p+GqfVp3NAjaE
        LuZ0ZmmccRJM2LUtheCIygFcpreyfbB3OFk6qCywjSfRIOBnCLV6V9qUsNRt6/VZVvcodB
        LzmQtCPqbE7DgGF5OGESLhne7wbrFOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-Wfuj2vPPPZ2gBM3KUVJ4XQ-1; Mon, 17 May 2021 13:17:24 -0400
X-MC-Unique: Wfuj2vPPPZ2gBM3KUVJ4XQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA732107ACE3;
        Mon, 17 May 2021 17:17:23 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-80.rdu2.redhat.com [10.10.113.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63D375D9F2;
        Mon, 17 May 2021 17:17:23 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 0/3] iomap: avoid soft lockup warnings on large ioends
Date:   Mon, 17 May 2021 13:17:19 -0400
Message-Id: <20210517171722.1266878-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There's been a bit more feedback on v2 of this series so here's a v3
with some small changes. Patch 1 is unchanged and just allows iomap
ioend completion to reschedule when invoked from non-atomic context.
Matthew Wilcox argued that ioends larger than the 256kB-1MB or so range
should probably be processed outside of bio completion context, so patch
2 updates XFS to queue completion of ioends >=1MB (based on 4k pages) to
the same workqueue used for processing ioends that require post I/O
metadata changes. Finally, there's been some debate around whether we
should continue to construct somewhat arbitrarily large ioends from a
latency perspective, independent of the soft lockup warning that's been
reproduced when processing ioends with tens of GBs worth of pages. Dave
Chinner had proposed an ioend size limit of ~16MB, so patch 3 is an RFC
for that change (and includes a comment written by Dave on the
explanation).

This series survives fstests and I've run some basic fio buffered write
(overwrites only) performance testing to measure the potential latency
hit at the size threshold. fio shows an average latency increase of
~20us with 1MB random writes at a reduction of ~10iops while 4k random
writes show basically no change (as expected). I'm happy to run further
tests on request. Thoughts, reviews, flames appreciated.

Brian

v3:
- Rebase.
- Change wq completion size threshold to 1MB.
- Append RFC for 16MB ioend size limit.
v2: https://lore.kernel.org/linux-xfs/20201005152102.15797-1-bfoster@redhat.com/
- Fix type in macro.
v1: https://lore.kernel.org/linux-xfs/20201002153357.56409-1-bfoster@redhat.com/
rfc: https://lore.kernel.org/linux-fsdevel/20200825144917.GA321765@bfoster/

Brian Foster (3):
  iomap: resched ioend completion when in non-atomic context
  xfs: kick large ioends to completion workqueue
  iomap: bound ioend size to 4096 pages

 fs/iomap/buffered-io.c | 21 +++++++++++++--------
 fs/xfs/xfs_aops.c      | 18 +++++++++++++++---
 include/linux/iomap.h  | 28 +++++++++++++++++++++++++++-
 3 files changed, 55 insertions(+), 12 deletions(-)

-- 
2.26.3

