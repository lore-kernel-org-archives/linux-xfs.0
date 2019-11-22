Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40861C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 18:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A7A52071B
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 18:19:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EqoQRIL8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKVSTa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 13:19:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58019 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726638AbfKVSTa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 13:19:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574446768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kx1K0I2yCWEDzAdcDeV8+4w+xvVEI4oDO3dMwgG3tW4=;
        b=EqoQRIL86SUFNyfb8AacRWEKicS/24J6UwVlhN+JMhSGQ3VKw5a94Tnt3zhVU8r+B9ZpFM
        sE0knXNheau1jc4qSqYTU3eeiaSxH0/Cv66+hplPbRqFcGmbN1+E2QLOWqkngmv6f1Vnoh
        MU/d+eIWWBEPQIJ7YZvLUt8j7x0LWQA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-HQWnXiRvOGaT9CIr-nZYHg-1; Fri, 22 Nov 2019 13:19:27 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78CA7107ACC9
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 18:19:26 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F8209F47
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 18:19:26 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v2 PATCH 0/3] xfs: automatic relogging experiment
Date:   Fri, 22 Nov 2019 13:19:24 -0500
Message-Id: <20191122181927.32870-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: HQWnXiRvOGaT9CIr-nZYHg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a second pass at the automatic relogging experiment. The first
pass tagged the log item for relog and stole reservation from unrelated
transactions to opportunistically relog items, all within the log
subsystem. The primary feedback to that approach was to consider a
transaction function callback and concerns about reservation stealing.
This version somewhat accommodates those concerns, but still leaves some
open questions around broader usage.

In short, this version introduces a separate workqueue context for
committing and rolling transactions for relogged items and a hook to
trigger a relog based on the item being committed to the AIL. The relog
state (including log reservation for the relog) is tracked via the log
item. Only the log ticket from the caller transaction is regranted and
tracked to avoid processing open transactions through separate contexts.
This is essentially an open-coded transaction roll without the need for
a duplicate transaction.

While this seems to work reasonably well for the simple case of
quotaoff, there are still some open issues to resolve around formalizing
such a mechanism for broader use. Firstly, the quotaoff patch just ties
into the existing ->iop_committed() callback since that is currently
unused, but the queue relog call could just as easily be made directly
from the AIL commit code. IOW, the whole callback thing seems kind of
like a solution looking for a problem in this context. With external
tracking of relogged items, all we really need here fundamentally is a
notification that the CIL context has committed.

Another caveat is that this approach seems much more cumbersome and
inefficient with respect to batching relogs of unrelated items. Rather
than collect all unrelated items in a single transaction, we'd have a
separate tracking structure, log ticket (which regrants the caller's
entire reservation) and independent roll/regrant for each potential set
of items. I can see value in the simplicity and flexibility of use in
terms of being able to potentially register an already constructed
transaction for automatic relogging, but I question whether that suits
our use case(s).

All in all, I think this is still pretty raw and needs some more thought
on the design (or perhaps requirements) front. I could see this going
anywhere from something more low level like the previous version where
we could have a relogged items list (RIL) associated with the CIL and
require initial transactions donate real relog reservation to something
more like this approach where we have some separate context
queueing/rolling relog transactions based on log subsystem events. I
suspect there are capability considerations for either end of that
spectrum. For example, it might be harder to auto relog anything but
intents with the RIL approach where there is no transaction to own item
locks, etc., but do we currently have a use case to relog anything
besides QUOTAOFF and EFIs? If not, I lean more toward the more simple,
low level approach (at least for now), but I could be convinced
otherwise.

Thoughts on any of this appreciated.

Brian

rfcv2:
- Different approach based on workqueue and transaction rolling.
rfc: https://lore.kernel.org/linux-xfs/20191024172850.7698-1-bfoster@redhat=
.com/

Brian Foster (3):
  xfs: set t_task at wait time instead of alloc time
  xfs: prototype automatic intent relogging mechanism
  xfs: automatically relog quotaoff start intent

 fs/xfs/Makefile                |   1 +
 fs/xfs/libxfs/xfs_trans_resv.c |   3 +-
 fs/xfs/xfs_dquot_item.c        |  13 ++++
 fs/xfs/xfs_log.c               |  11 ++-
 fs/xfs/xfs_log_priv.h          |   1 +
 fs/xfs/xfs_qm_syscalls.c       |   9 ++-
 fs/xfs/xfs_trans.c             |   2 +-
 fs/xfs/xfs_trans.h             |  13 ++++
 fs/xfs/xfs_trans_relog.c       | 130 +++++++++++++++++++++++++++++++++
 9 files changed, 179 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/xfs_trans_relog.c

--=20
2.20.1

