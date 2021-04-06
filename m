Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A43C43460
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 14:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07242613C4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 14:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345275AbhDFOmu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 10:42:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51283 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345264AbhDFOmt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 10:42:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617720161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vkBEbLhyPGs09RfsW3DP/kjdpNx7yfh5e1R/2Zd04mc=;
        b=ajE9Ovna8tgvZXJ77eQEZ0cMdktHgjQwLz42KuDaMY4BiqWC8wYje/FXwe7+wBKwR5hGYd
        EbI6B6n8Ehb95hru3xGyJKER7cdOBiA3OAA2lUnIV5Pnt9VgOWJbwS3i3/CA+9xw1PwNLP
        rZiFtLxFmnmmsJJ0IkbMeaQvzgY+OUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-Xl2i46ivM6WA2V62pEQNUw-1; Tue, 06 Apr 2021 10:42:39 -0400
X-MC-Unique: Xl2i46ivM6WA2V62pEQNUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFFF9802B7E
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 14:42:38 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B33675D741
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 14:42:38 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/3] xfs: rework quotaoff to avoid log deadlock
Date:   Tue,  6 Apr 2021 10:42:35 -0400
Message-Id: <20210406144238.814558-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This series reworks the quotaoff algorithm to eliminate a log
reservation deadlock vector. v2 is primarily a rebase/repost of v1.

Note that this conflicts with the recently posted append ioend cleanup,
but this series is still based on for-next. I can post another rebased
series if either of these progress.

Brian

v2:
- Rebased to for-next.
v1: https://lore.kernel.org/linux-xfs/20201001150310.141467-1-bfoster@redhat.com/

Brian Foster (3):
  xfs: skip dquot reservations if quota is inactive
  xfs: transaction subsystem quiesce mechanism
  xfs: rework quotaoff logging to avoid log deadlock on active fs

 fs/xfs/xfs_aops.c        |   2 +
 fs/xfs/xfs_mount.h       |   3 +
 fs/xfs/xfs_qm_syscalls.c | 133 +++++++++++++++++++--------------------
 fs/xfs/xfs_super.c       |   8 +++
 fs/xfs/xfs_trans.c       |   4 +-
 fs/xfs/xfs_trans.h       |  20 ++++++
 fs/xfs/xfs_trans_dquot.c |  22 +++----
 7 files changed, 111 insertions(+), 81 deletions(-)

-- 
2.26.3

