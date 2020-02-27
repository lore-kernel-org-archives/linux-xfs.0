Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF035C3F34B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 13:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 875D620578
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 13:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cwlJWVZk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgB0NnZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 08:43:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50326 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729959AbgB0NnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 08:43:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582811004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TkKfVV7G+Vs2UGrfYwDiftY9UvcWuVayAJHlz5jGDYY=;
        b=cwlJWVZkCgubd32myi6z4nZXvE495UqktOd1Zlnmt6cHHq1pZeyb5NIkAfovlgM0l1iJ7F
        TFHt4lc9TXwB34uLCp02qerOZQfUETosP7qH9itcu2oSdANg95Qk54nop1i3dSdPJrVjBn
        jvz62506V2sSAH2NYfWlrgD4LfgFOP8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-ICN6BJEPPbinvOkMKxLALw-1; Thu, 27 Feb 2020 08:43:22 -0500
X-MC-Unique: ICN6BJEPPbinvOkMKxLALw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D80858017DF
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:21 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0A265DA7C
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:21 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v5 PATCH 0/9] xfs: automatic relogging experiment
Date:   Thu, 27 Feb 2020 08:43:12 -0500
Message-Id: <20200227134321.7238-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a v5 RFC of the automatic item relogging experiment. Firstly,
note that this is still a POC and experimental code with various quirks.
Some are documented in the code, others might not be (such as abusing
the AIL lock, etc.). The primary purpose of this series is still to
express and review a fundamental design. Based on discussion on the last
version, there is specific focus towards addressing log reservation and
pre-item locking deadlock vectors. While the code is still quite hacky,
I believe this design addresses both of those fundamental issues.
Further details on the design and approach are documented in the
individual commit logs.

In addition, the final few patches introduce buffer relogging capability
and test infrastructure, which currently has no use case other than to
demonstrate development flexibility and the ability to support arbitrary
log items in the future, if ever desired. If this approach is taken
forward, the current use cases are still centered around intent items
such as the quotaoff use case and extent freeing use case defined by
online repair of free space trees.

On somewhat of a tangent, another intent oriented use case idea crossed
my mind recently related to the long standing writeback stale data
exposure problem (i.e. if we crash after a delalloc extent is converted
but before writeback fully completes on the extent). The obvious
approach of using unwritten extents has been rebuffed due to performance
concerns over extent conversion. I wonder if we had the ability to log a
"writeback pending" intent on some reasonable level of granularity (i.e.
something between a block and extent), whether we could use that to
allow log recovery to zero (or convert) such extents in the event of a
crash. This is a whole separate design discussion, however, as it
involves tracking outstanding writeback, etc. In this context it simply
serves as a prospective use case for relogging, as such intents would
otherwise risk similar log subsystem deadlocks as the quotaoff use case.

Thoughts, reviews, flames appreciated.

Brian

rfcv5:
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

Brian Foster (9):
  xfs: set t_task at wait time instead of alloc time
  xfs: introduce ->tr_relog transaction
  xfs: automatic relogging reservation management
  xfs: automatic relogging item management
  xfs: automatic log item relog mechanism
  xfs: automatically relog the quotaoff start intent
  xfs: buffer relogging support prototype
  xfs: create an error tag for random relog reservation
  xfs: relog random buffers based on errortag

 fs/xfs/libxfs/xfs_errortag.h   |   4 +-
 fs/xfs/libxfs/xfs_shared.h     |   1 +
 fs/xfs/libxfs/xfs_trans_resv.c |  24 +++-
 fs/xfs/libxfs/xfs_trans_resv.h |   1 +
 fs/xfs/xfs_buf_item.c          |   5 +
 fs/xfs/xfs_dquot_item.c        |   7 ++
 fs/xfs/xfs_error.c             |   3 +
 fs/xfs/xfs_log.c               |   2 +-
 fs/xfs/xfs_qm_syscalls.c       |  12 +-
 fs/xfs/xfs_trace.h             |   3 +
 fs/xfs/xfs_trans.c             |  79 +++++++++++-
 fs/xfs/xfs_trans.h             |  13 +-
 fs/xfs/xfs_trans_ail.c         | 216 ++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans_buf.c         |  35 ++++++
 fs/xfs/xfs_trans_priv.h        |   6 +
 15 files changed, 399 insertions(+), 12 deletions(-)

--=20
2.21.1

