Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A477C25B47
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 06:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbjJXGo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 02:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjJXGo1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 02:44:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7F1111;
        Mon, 23 Oct 2023 23:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=mWJbrqGyOWZeG8arA3kiVOL37IHuK2xpDuB998/3rz0=; b=z/koJWZinP93IY3dpVf4azl6nx
        9ZjZXmOm83+5dIu6+Hdiqeiv2fLG6s+3JktdHxcWCNgsG/9EO9bUQuV5dKZKOXCBWhCe3i0zSeCMH
        lDoagtXHwO7U9dEf2seHBV5hBW0BuYDeDDmNenjcbDxBX/ONdDW5egCa8h2+iXRKr55TW13TC7+Iz
        UmL4FW4g8FLWJQ3kWws+XwRuLd7FYluXIuvR5dijb6jEijG5RocFccb0TOgik5oH5LlBnhV4uwZKE
        /aTGfJ7EeD8pauHT2HSIi/g3MAA2SaAKK7J4BRJg+jDxyDESVUYZnUHNsQ47Za5cWo43AX4884xQ2
        FlGywEMQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qvB9I-0090RP-18;
        Tue, 24 Oct 2023 06:44:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: add and use a per-mapping stable writes flag
Date:   Tue, 24 Oct 2023 08:44:13 +0200
Message-Id: <20231024064416.897956-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all

A while ago Ilya pointer out that since commit 1cb039f3dc16 ("bdi:
replace BDI_CAP_STABLE_WRITES with a queue and a sb flag"), the stable
write flag on the queue wasn't used for writes to the block devices
nodes any more, and willy suggested fixing this by adding a stable write
flags on each address_space.  This series implements this fix, and also
fixes the stable write flag when the XFS RT device requires it, but the
main device doesn't (which is probably more a theoretical than a
practical problem).

Diffstat:
 block/bdev.c            |    2 ++
 fs/inode.c              |    2 ++
 fs/xfs/xfs_inode.h      |    8 ++++++++
 fs/xfs/xfs_ioctl.c      |    9 +++++++++
 fs/xfs/xfs_iops.c       |    7 +++++++
 include/linux/pagemap.h |   17 +++++++++++++++++
 mm/page-writeback.c     |    2 +-
 7 files changed, 46 insertions(+), 1 deletion(-)
