Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDDFC433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Apr 2022 12:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbiDCMDS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Apr 2022 08:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiDCMDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Apr 2022 08:03:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921652E9D2
        for <linux-xfs@vger.kernel.org>; Sun,  3 Apr 2022 05:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=RwaqCeJ1MizC/0zpFf2q6DpKXk1A25nvZ12lxEcHWIs=; b=fRVaDywD+Of4K7eUXkXZXC1uzC
        ov/gxLbxk41TJ8693+VUdwmYHgG18RmMxJ0cYdtRIk3+JYYJaqrfefOYRAlOasKXjEV0VDtUG+GHc
        KCnmj+pX+0Y3DqXjdnZriTk1X5Z25K52oXZfrmIEFAJVXKyZw4xu4K0sb+EubY33pb/rVom9A4rxO
        eRlHYgrW13BF7DQdcWF3v+LrCkQF9EPalJ4IrnklnrpMbO3D6gI9RlCOxJiOnHQ8KTFtJngXYRke/
        gwCBT9u1XV9Av1mDtVPa09QnVwuLbPN50PckA6eDcWtd9Dh52t9SPZi/SZl13Z+LJSRsG2/WRrvlk
        UrEYBECQ==;
Received: from [2001:4bb8:184:7553:31f9:976f:c3b1:7920] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nayv4-00BK15-FO; Sun, 03 Apr 2022 12:01:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: lockless and cleaned up buffer lookup
Date:   Sun,  3 Apr 2022 14:01:14 +0200
Message-Id: <20220403120119.235457-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series cleans up the slight mess that the buffer cache hash
lookup and allocation path is before applying a now much simplified
(and split up) version of "xfs: lockless buffer lookup" from Dave.

Let me know what you think.

Diffstat:
 libxfs/xfs_attr_remote.c |    8 -
 libxfs/xfs_sb.c          |    2 
 scrub/repair.c           |    6 -
 xfs_buf.c                |  253 ++++++++++++++++++++++-------------------------
 xfs_buf.h                |    9 -
 xfs_qm.c                 |    6 -
 6 files changed, 134 insertions(+), 150 deletions(-)
