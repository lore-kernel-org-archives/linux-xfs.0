Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C42C433E3
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C474A2078A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jo1JP8ob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732559AbgGAQv1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 12:51:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55588 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732462AbgGAQvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 12:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593622279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PKta3TO5I28ynq9hJZhEVxdEVRor/aY4TjjKbi6IVq8=;
        b=Jo1JP8obbieq698SQY/uJp35dp55EUx0Xj05ypD8oL6Tv3/Rm1VJBrmJ31rvGW/s8qrEHT
        5VjM9b6xA//9o76xFVvpy+OPNLlM++MRX6aK6SxmlANk/mP1Cte51sEzE5Utke72XK+Vbh
        qOkoI1gAPx6udOK6qyJozcZwcLp9DIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-KTgM6wDpPmixJ23WlpZgPQ-1; Wed, 01 Jul 2020 12:51:17 -0400
X-MC-Unique: KTgM6wDpPmixJ23WlpZgPQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E54D804001
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:17 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEB6C5C3FD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:16 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/10] xfs: automatic relogging
Date:   Wed,  1 Jul 2020 12:51:06 -0400
Message-Id: <20200701165116.47344-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a v1 (non-RFC) version of the automatic relogging functionality.
Note that the buffer relogging bits (patches 8-10) are still RFC as I've
had to hack around some things to utilize it for testing. I include them
here mostly for reference/discussion. Most of the effort from the last
rfc post has gone into testing and solidifying the functionality. This
now survives a traditional fstests regression run as well as a test run
with random buffer relogging enabled on every test/scratch device mount
that occurs throughout the fstests cycle. The quotaoff use case is
additionally tested independently by artificially delaying completion of
the quotaoff in parallel with many fsstress worker threads.

The hacks/workarounds to support the random buffer relogging enabled
fstests run are not included here because they are not associated with
core functionality, but rather are side effects of randomly relogging
arbitrary buffers, etc. I can work them into the buffer relogging
patches if desired, but I'd like to get the core functionality and use
case worked out before getting too far into the testing code. I also
know Darrick was interested in the ->iop_relog() callback for some form
of generic feedback into active dfops processing, so it might be worth
exploring that further.

Thoughts, reviews, flames appreciated.

Brian

v1:
- Rebased to latest for-next.
- Push handling logic tweaks.
- Rework and document the relog reservation calculation.
rfcv6: https://lore.kernel.org/linux-xfs/20200406123632.20873-1-bfoster@redhat.com/
- Rework relog reservation model.
- Drop unnecessary log ticket t_task fix.
- Use ->iop_relog() callback unconditionally.
- Rudimentary freeze handling for random buffer relogging.
- Various other fixes, tweaks and cleanups.
rfcv5: https://lore.kernel.org/linux-xfs/20200227134321.7238-1-bfoster@redhat.com/
- More fleshed out design to prevent log reservation deadlock and
  locking problems.
- Split out core patches between pre-reservation management, relog item
  state management and relog mechanism.
- Added experimental buffer relogging capability.
rfcv4: https://lore.kernel.org/linux-xfs/20191205175037.52529-1-bfoster@redhat.com/
- AIL based approach.
rfcv3: https://lore.kernel.org/linux-xfs/20191125185523.47556-1-bfoster@redhat.com/
- CIL based approach.
rfcv2: https://lore.kernel.org/linux-xfs/20191122181927.32870-1-bfoster@redhat.com/
- Different approach based on workqueue and transaction rolling.
rfc: https://lore.kernel.org/linux-xfs/20191024172850.7698-1-bfoster@redhat.com/

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
 fs/xfs/xfs_buf_item.c        |  61 ++++++++++++--
 fs/xfs/xfs_dquot_item.c      |  26 +++++-
 fs/xfs/xfs_error.c           |   3 +
 fs/xfs/xfs_log.c             |  35 ++++++--
 fs/xfs/xfs_log.h             |   4 +-
 fs/xfs/xfs_log_cil.c         |   2 +-
 fs/xfs/xfs_log_priv.h        |   1 +
 fs/xfs/xfs_qm_syscalls.c     |  12 ++-
 fs/xfs/xfs_super.c           |   4 +
 fs/xfs/xfs_trace.h           |   4 +
 fs/xfs/xfs_trans.c           |  75 +++++++++++++++--
 fs/xfs/xfs_trans.h           |  44 +++++++++-
 fs/xfs/xfs_trans_ail.c       | 152 ++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans_buf.c       |  80 ++++++++++++++++++
 fs/xfs/xfs_trans_priv.h      |  28 +++++++
 18 files changed, 512 insertions(+), 28 deletions(-)

-- 
2.21.3

