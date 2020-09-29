Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F952C4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 14:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 662CA2145D
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 14:12:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZuYJh5Za"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgI2OMe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 10:12:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728327AbgI2OMd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 10:12:33 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601388753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wMAmcCZ+eeSwoc5Sk3PjjNp4YiJZbSJtRwnzg2/vqpg=;
        b=ZuYJh5ZayyeLb0eSaJSNaXvQkChBxXB19b4vZgQ5j9X7j29mNFMfDDyUvzmBz591D9sQtF
        0JkA5KCZlgc3Y4zwtX0cZmtLyl7QXOCuCrNmGrCFcvKTtvc/AB1ptM5SYe8y4Fa5w74v7x
        5F/O2OjlSJC60g11eeyBBkHId6D6pXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-DM-2ql81MyeQ10IEgyqbCg-1; Tue, 29 Sep 2020 10:12:30 -0400
X-MC-Unique: DM-2ql81MyeQ10IEgyqbCg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A3F0801AE1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2020 14:12:29 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-202.rdu2.redhat.com [10.10.113.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFBDA19C4F
        for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2020 14:12:28 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 0/3] xfs: rework quotaoff to avoid log deadlock
Date:   Tue, 29 Sep 2020 10:12:25 -0400
Message-Id: <20200929141228.108688-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's an RFC for the quotaoff rework (based on Dave's suggestion) to
incorporate a transaction subsystem quiesce to provide dquot log
ordering guarantees without creating a log deadlock vector. This is RFC
mainly due to patch 2, which was a quick hack to freeze the transaction
subsystem because I wanted to focus on the core approach/algorithm
first. If the general approach is acceptable, I'll go back and implement
something that doesn't abuse an external mechanism for transaction
freeze (perhaps just using a similar, internal percpu rwsem). Patch 1 is
a dependent bug fix to avoid logging dquots for inactive quota modes and
patch 3 reworks quotaoff as described. Thoughts, reviews, flames
appreciated.

Brian

Brian Foster (3):
  xfs: skip dquot reservations if quota is inactive
  xfs: temporary transaction subsystem freeze hack
  xfs: rework quotaoff logging to avoid log deadlock on active fs

 fs/xfs/xfs_qm_syscalls.c | 36 ++++++++++++++++--------------------
 fs/xfs/xfs_trans.c       | 16 ++++++++++++++++
 fs/xfs/xfs_trans.h       |  2 ++
 fs/xfs/xfs_trans_dquot.c | 22 +++++++++++-----------
 4 files changed, 45 insertions(+), 31 deletions(-)

-- 
2.25.4

