Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EC8C43460
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 14:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20506613B9
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 14:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235835AbhDEO7Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Apr 2021 10:59:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26651 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237939AbhDEO7Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Apr 2021 10:59:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617634757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cFEi/VW56sN8eGKKm5lNLjYcrmY/WyYsHDImLPFbDIo=;
        b=f7RDiGvrycC1YEWcdbeeRdFI79Ku5NCkEyi41tB63UIaPi+S2nF3w0sihJYLn0dnbMmdoV
        1B65PaiLSH3w+I4rQWnqh5M0yXK7HzFz4Qs+mM8L3EypdHExNXhfgPbKhQzyXwGS5BqhhS
        oM73T6/rf5ydVyFWChUfAyvMNAs/qTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-VWpcJ5OEOfq_lh3Y1zkFCg-1; Mon, 05 Apr 2021 10:59:15 -0400
X-MC-Unique: VWpcJ5OEOfq_lh3Y1zkFCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56C7CA0CD3
        for <linux-xfs@vger.kernel.org>; Mon,  5 Apr 2021 14:59:04 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5D4F5D749
        for <linux-xfs@vger.kernel.org>; Mon,  5 Apr 2021 14:59:03 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] xfs: ioend batching log reservation deadlock
Date:   Mon,  5 Apr 2021 10:58:59 -0400
Message-Id: <20210405145903.629152-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series addresses the ioend completion batching log res deadlock
vector by removing the preallocated transaction from append ioends.
Instead, we continue to process append ioend completions via the
workqueue, but let the wq task allocate the transaction similar to other
ioend types.

Patch 1 makes the functional change and the remaining patches are
followon cleanups. Technically this could all be squashed down to a
single patch, if desired. Thoughts, reviews, flames appreciated.

Brian

RFD: https://lore.kernel.org/linux-xfs/YF4AOto30pC%2F0FYW@bfoster/

Brian Foster (4):
  xfs: drop submit side trans alloc for append ioends
  xfs: open code ioend needs workqueue helper
  xfs: drop unused ioend private merge and setfilesize code
  xfs: drop unnecessary setfilesize helper

 fs/xfs/xfs_aops.c | 129 ++++++----------------------------------------
 1 file changed, 15 insertions(+), 114 deletions(-)

-- 
2.26.3

