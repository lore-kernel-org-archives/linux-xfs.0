Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84113C4363D
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F262074D
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eGbshoKq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390917AbgJLOEW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:04:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403773AbgJLODy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 10:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602511433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jtT8YVgg8rW+zJBwTtvzYMDWf/69tJh2n5OKKDjNoQw=;
        b=eGbshoKqLnZIXHcJSuoZj00igvQlFg0MSM4bXuqFp6Wx0HLzaB5ViKVK9S+Qnqx1OeQW28
        87Rvfy8MiruX6zZ1dplTLlvVm1BWOQQaj2pQ7S0lfVqhy7ayVl9EK+TnWl2uNxM+I7rLWc
        9E6Jy32KjTjHB+sUDALzYyc6p/1hhqo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-KwfY8z8jMyGFvAwAMnuJbA-1; Mon, 12 Oct 2020 10:03:52 -0400
X-MC-Unique: KwfY8z8jMyGFvAwAMnuJbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10E7064085;
        Mon, 12 Oct 2020 14:03:51 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7A4260C07;
        Mon, 12 Oct 2020 14:03:50 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] iomap: zero dirty pages over unwritten extents
Date:   Mon, 12 Oct 2020 10:03:48 -0400
Message-Id: <20201012140350.950064-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is an alternate/iomap based variant of the XFS fix posted here:

https://lore.kernel.org/linux-xfs/20201007143509.669729-1-bfoster@redhat.com/

This addresses a post-eof stale data exposure problem that can occur
when truncate down races with writeback of the new EOF page and the new
EOF block happens to be unwritten. Instead of explicitly flushing the
new EOF page in XFS, however, this variant updates iomap zero range to
check for and zero preexisting dirty pages over unwritten extents. This
reuses the dirty page checking that seek data/hole already implements
for unwritten extents. Patch 1 is technically not required, but fixes an
odd behavior I noticed when playing around with zero range. Without it,
a zero range (with patch 2) over a large, cached (but clean), unwritten
mapping would unnecessarily zero pages that aren't otherwise dirty. I
don't think this is actually a problem in practice today as most large
zero range requests are truncates over post-eof space (which shouldn't
have page cache), but it seemed odd regardless.

Thoughts, reviews, flames appreciated.

Brian

Brian Foster (2):
  iomap: use page dirty state to seek data over unwritten extents
  iomap: zero cached pages over unwritten extents on zero range

 fs/iomap/buffered-io.c | 39 +++++++++++++++++++++++++++++++++++++--
 fs/iomap/seek.c        |  7 ++++---
 include/linux/iomap.h  |  2 ++
 3 files changed, 43 insertions(+), 5 deletions(-)

-- 
2.25.4

