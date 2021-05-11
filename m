Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49698C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 13:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 197FE61625
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 13:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhEKNyN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 09:54:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231650AbhEKNyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 09:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620741181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sHfJnv/ce/QTonEXo3+tJeHOLvP86fRTgT0Lqu1+eso=;
        b=AIdPUNLa49vu42r4XTIRhbOjBOBeLq+kMsipnnAq0cYQHZzdxW7w052scZtY4u9qhSYxV9
        4BUNGKCgJZtwIIBOyTcNUa/JI3k+qyjR9mhN2JuicZitX2B566tW5tXSC6hD2LhGMHw+Ee
        aYgeoqTvmUrHM05f/xv8FDCNFVq5Ppc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-Un8jgZqYPVuiF1JntLcj8w-1; Tue, 11 May 2021 09:52:58 -0400
X-MC-Unique: Un8jgZqYPVuiF1JntLcj8w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBFAC10066E5
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 13:52:57 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-80.rdu2.redhat.com [10.10.113.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8132C2B431
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 13:52:57 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: fix buffer use after free on unpin abort
Date:   Tue, 11 May 2021 09:52:55 -0400
Message-Id: <20210511135257.878743-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a proper v1 of the previously posted RFC to address a subtle
buffer use after free in the unpin abort sequence for buffer log items.
Dave had previously suggested that the underlying problem here is that
bli's are effectively used by the AIL unreferenced. While this makes a
lot of sense, this is a long standing design detail that subtly impacts
code related to log item processing, AIL processing, buffer I/O, as well
as potentially log recovery. In contrast, the immediate problem that
leads to the use after free is lack of a buffer hold in a context that
already explicitly acquires a hold for the problematic simulated I/O
failure sequence.

Given the significant cost/risk vs. benefit imbalance of a design
rework, I've opted to to make the minimal change to fix this bug and
defer broader rework to a standalone effort. Patch 1 basically reorders
the preexisting buffer hold to accommodate the flaw that the AIL does
not hold a reference to the bli (and thus does not maintain the
associated buffer hold). This preserves the existing isolation logic and
prevents the associated UAF. This survives an fstests run and is going
on 6k iterations of generic/019 (which previously reproduced the problem
in 2-3k iterations) without any explosions. Thoughts, reviews, flames
appreciated.

Brian

v1:
- Rework patch 1 to hold conditionally in the abort case and document
  the underlying design flaw.
- Add patch 2 to remove some unused code.
rfc: https://lore.kernel.org/linux-xfs/20210503121816.561340-1-bfoster@redhat.com/

Brian Foster (2):
  xfs: hold buffer across unpin and potential shutdown processing
  xfs: remove dead stale buf unpin handling code

 fs/xfs/xfs_buf_item.c | 57 +++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 35 deletions(-)

-- 
2.26.3

