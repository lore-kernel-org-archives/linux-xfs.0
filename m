Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37B9C2BB55
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 991C921D7F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z5oSOeuE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgDFMgl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:36:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47463 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727951AbgDFMgk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586176599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Gv+WA8KVze5hIlbWfUIBcaEkVdQhSMsmdRBQ/Ebmv1k=;
        b=Z5oSOeuEonmen6ip5fPFM7VFr2V88Ur++kWAQzqF5XMlo63+1c3UYkGpyPw8vmzr7Lz1jy
        6a2MD2i3oOo+L/t6pklJo/k+5YHcNc46wvUn59v/cL2A5jT5c2v1xH3CC14wltYf/X7kR1
        /HbM5xKNK+SfU4yqkAqFILyb6F3utGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-sP-YKPnVNOuf3BbWzjzhHg-1; Mon, 06 Apr 2020 08:36:34 -0400
X-MC-Unique: sP-YKPnVNOuf3BbWzjzhHg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F03A8014D5
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:33 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56C8860BFB
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:33 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v6 PATCH 00/10] xfs: automatic relogging experiment
Date:   Mon,  6 Apr 2020 08:36:22 -0400
Message-Id: <20200406123632.20873-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a v6 of the automatic relogging RFC. The primary difference in
this version is a rework of the relog reservation model based on design
discussion on v5. Rather than roll existing transactions and initialize
a fixed size relog transaction, this version acquires worst case relog
reservation directly from the transactions that enable relog of log
items. This facilitates construction of arbitrary combinations of items
in the relog transaction without risk of deadlock due to log reservation
and/or lock ordering. See the associated commit log for further details
on the approach.

Beyond that, there are various other fixes and tweaks from v5. For
example, the log item relog callback is used unconditionally and
abstracts more of the reservation management code, buffer relogging is a
bit more restrictive and reliable, various helpers are refactored,
freeze is partly addressed, etc.

With regard to testing, this version survives a 1+ hour 80xcpu fsstress
workload with random buffer relogging enabled without any notable issues
and without observable reservation leaks. It also survives an fstests
auto run without regression.

Patches 1-5 are preparatory patches and core mechanism. Patch 6 uses
relogging to address the longstanding quotaoff deadlock problem. Patches
7-10 provide buffer relogging support and test code for DEBUG mode
kernels to stress the relog mechanism via random buffer relogging.

Thoughts, reviews, flames appreciated.

Brian

rfcv6:
- Rework relog reservation model.
- Drop unnecessary log ticket t_task fix.
- Use ->iop_relog() callback unconditionally.
- Rudimentary freeze handling for random buffer relogging.
- Various other fixes, tweaks and cleanups.
rfcv5: https://lore.kernel.org/linux-xfs/20200227134321.7238-1-bfoster@re=
dhat.com/
- More fleshed out design to prevent log reservation deadlock and
  locking problems.
- Split out core patches between pre-reservation management, relog item
  state management and relog mechanism.
- Added experimental buffer relogging capability.
rfcv4: https://lore.kernel.org/linux-xfs/20191205175037.52529-1-bfoster@r=
edhat.com/
- AIL based approach.
rfcv3: https://lore.kernel.org/linux-xfs/20191125185523.47556-1-bfoster@r=
edhat.com/
- CIL based approach.
rfcv2: https://lore.kernel.org/linux-xfs/20191122181927.32870-1-bfoster@r=
edhat.com/
- Different approach based on workqueue and transaction rolling.
rfc: https://lore.kernel.org/linux-xfs/20191024172850.7698-1-bfoster@redh=
at.com/

Brian Foster (10):
  xfs: automatic relogging item management
  xfs: create helper for ticket-less log res ungrant
  xfs: extra runtime reservation overhead for relog transactions
  xfs: relog log reservation stealing and accounting
  xfs: automatic log item relog mechanism
  xfs: automatically relog the quotaoff start intent
  xfs: prevent fs freeze with outstanding relog items
  xfs: buffer relogging support prototype
  xfs: create an error tag for random relog reservation
  xfs: relog random buffers based on errortag

 fs/xfs/libxfs/xfs_errortag.h |   4 +-
 fs/xfs/libxfs/xfs_shared.h   |   1 +
 fs/xfs/xfs_buf.c             |   4 +
 fs/xfs/xfs_buf_item.c        |  52 ++++++++++++-
 fs/xfs/xfs_dquot_item.c      |  26 +++++++
 fs/xfs/xfs_error.c           |   3 +
 fs/xfs/xfs_log.c             |  35 +++++++--
 fs/xfs/xfs_log.h             |   4 +-
 fs/xfs/xfs_log_cil.c         |   2 +-
 fs/xfs/xfs_log_priv.h        |   1 +
 fs/xfs/xfs_qm_syscalls.c     |  12 ++-
 fs/xfs/xfs_super.c           |   4 +
 fs/xfs/xfs_trace.h           |   4 +
 fs/xfs/xfs_trans.c           |  75 ++++++++++++++++--
 fs/xfs/xfs_trans.h           |  36 ++++++++-
 fs/xfs/xfs_trans_ail.c       | 146 ++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans_buf.c       |  73 ++++++++++++++++++
 fs/xfs/xfs_trans_priv.h      |  20 +++++
 18 files changed, 477 insertions(+), 25 deletions(-)

--=20
2.21.1

