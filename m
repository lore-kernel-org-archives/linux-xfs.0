Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1537C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 15:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9729522C9F
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 15:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733114AbhAUPtO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 10:49:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387428AbhAUPq4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 10:46:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611243930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Yb8ZoUi3hPYVmkZ8JozEC1vN6WHPld0p+5EsfuTcAUw=;
        b=AoNTWluRJRBBMhpTH761m5Ncn976XY3MboC+X8r0C2YmfbcYfuw7mATIQxcQGQFtVxhqyd
        vUjKlIS+yXLGNBqaEZLxkxnww3hCA0zwXrF82/0LJswBc//GKRfeBdL3OktWJCV/7wE1kN
        pwsOztZFq7MmXvWgsTtR6GtXKxQYweU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-asYiAHFnPs-8AxKyIPdTgw-1; Thu, 21 Jan 2021 10:45:28 -0500
X-MC-Unique: asYiAHFnPs-8AxKyIPdTgw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B041107ACFC
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:45:27 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AAA219486
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:45:27 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/9] xfs: rework log quiesce to cover the log
Date:   Thu, 21 Jan 2021 10:45:17 -0500
Message-Id: <20210121154526.1852176-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a v2 of the log quiesce rework to introduce and reuse log
covering. This only has a couple minor tweaks from v1. Note again that
patch 1 is an isolated bug fix related to the lazy sb accounting bug
generic/388 was recently enhanced to reproduce. 

Brian

v2:
- Return bool from xfs_log_need_covered().
- Reword patch 1 commit log.
- Apply review tags.
v1: https://lore.kernel.org/linux-xfs/20210106174127.805660-1-bfoster@redhat.com/

Brian Foster (9):
  xfs: sync lazy sb accounting on quiesce of read-only mounts
  xfs: lift writable fs check up into log worker task
  xfs: separate log cleaning from log quiesce
  xfs: cover the log during log quiesce
  xfs: don't reset log idle state on covering checkpoints
  xfs: fold sbcount quiesce logging into log covering
  xfs: remove duplicate wq cancel and log force from attr quiesce
  xfs: remove xfs_quiesce_attr()
  xfs: cover the log on freeze instead of cleaning it

 fs/xfs/xfs_log.c   | 128 ++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_log.h   |   4 +-
 fs/xfs/xfs_mount.c |  34 +-----------
 fs/xfs/xfs_mount.h |   1 -
 fs/xfs/xfs_super.c |  38 +-------------
 5 files changed, 109 insertions(+), 96 deletions(-)

-- 
2.26.2

