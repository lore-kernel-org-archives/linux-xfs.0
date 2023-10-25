Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B407C25B6F
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Oct 2023 14:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbjJYOKo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 10:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbjJYOKm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 10:10:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672F71AD;
        Wed, 25 Oct 2023 07:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=0YPa27INOC/N6qFWunK8b2Eoihh6tg8Tw/h1N8ujj4k=; b=e4mR/qwXL0HvoqDl3cYm8CxH26
        lVxa1WXl8CX5DSEaRG1++Fx3BahQbLCd5oF1jDTQWen90bRt5kTM/QL6Ds7fYMuCfL6kcVfqgPrl6
        mwZ/TBr4foZGzth1m10/v+sR2dvWZbJM9lHuSXaWQkR7QmFF6q7D4al59+kbg8nFXQp51bwOg1QsL
        gY6sfwkOXQt5mgrb+REtBuGG4nv2+cJ8FgVLSY24Q7FtXlRuN8LPwCzdOQV6WywoGk16BClk6rh3S
        LOAR5zSp6QbsEcD9+Kp58U2Wj961CkSDnszUYD8lsc0GjyVUg+c5dmV+ybllu/lchxSDQcrqi0AhJ
        X83a1C3Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qveac-00CTwB-34;
        Wed, 25 Oct 2023 14:10:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: add and use a per-mapping stable writes flag v2
Date:   Wed, 25 Oct 2023 16:10:16 +0200
Message-Id: <20231025141020.192413-1-hch@lst.de>
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

Changes since v1:
 - add a xfs cleanup patch

Diffstat:
 block/bdev.c            |    2 ++
 fs/inode.c              |    2 ++
 fs/xfs/xfs_inode.h      |    8 ++++++++
 fs/xfs/xfs_ioctl.c      |   30 ++++++++++++++++++++----------
 fs/xfs/xfs_iops.c       |    7 +++++++
 include/linux/pagemap.h |   17 +++++++++++++++++
 mm/page-writeback.c     |    2 +-
 7 files changed, 57 insertions(+), 11 deletions(-)
