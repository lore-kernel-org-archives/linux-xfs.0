Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E57C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 13:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E94E20767
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 13:47:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PRk1Eesj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgIANro (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 09:47:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728253AbgIANrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 09:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598968051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oCf1QGobn460Drc7SJRWhqB/MEU+sW6uCK6zUFoOZho=;
        b=PRk1EesjIORwCEAChEK3NUGzP99X54tS6YZZY5WkgM8GZZR2z9z79Q1kc/yRiO6SOi0O8Y
        wzO9DE95/lWLyZ+m6vfTBKax59W2JckYgUzMghN7O0fS6pu8xIVI+7zOsPFTq0xiE98uxd
        DSTXK2A2I74SOa8FLYKjH+yo7F44H+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-nr6UoAV_PT-H7rTgf7GJ9Q-1; Tue, 01 Sep 2020 09:47:29 -0400
X-MC-Unique: nr6UoAV_PT-H7rTgf7GJ9Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D99BE80F044;
        Tue,  1 Sep 2020 13:47:28 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BEA218B59;
        Tue,  1 Sep 2020 13:47:28 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/3] fix up generic dmlogwrites tests to work with XFS
Date:   Tue,  1 Sep 2020 09:47:25 -0400
Message-Id: <20200901134728.185353-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This version removes the discard zeroing check as Christoph points out
that discard behavior is generally not predictable. The remaining
generic dm-logwrites tests are still updated to use dm-thinp such that
discards from the recovery tool clear block ranges reasonably reliably.
This allows the tests to function correctly on filesystems like XFS
while a more generic solution is investigated.

Brian

v3:
- Re-add dm-thinp changes.
- Drop discard checks (from v1) and XFS disablement (from v2).
- Use _require_scratch_nocheck in generic/470 to avoid spurious repair
  noise now that the test no longer runs mkfs on the scratch dev.
v2: https://lore.kernel.org/fstests/20200827145329.435398-1-bfoster@redhat.com/
- Drop all dmthinp changes. Unconditionally disable tests on XFS.
v1: https://lore.kernel.org/fstests/20200826143815.360002-2-bfoster@redhat.com/

Brian Foster (3):
  generic/455: use thin volume for dmlogwrites target device
  generic/457: use thin volume for dmlogwrites target device
  generic/470: use thin volume for dmlogwrites target device

 tests/generic/455 | 36 ++++++++++++++++++++++--------------
 tests/generic/457 | 33 +++++++++++++++++++++------------
 tests/generic/470 | 23 +++++++++++++++++------
 3 files changed, 60 insertions(+), 32 deletions(-)

-- 
2.25.4

