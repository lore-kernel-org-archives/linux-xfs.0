Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A760C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 14:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC5260201
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 14:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbhDBOYP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235535AbhDBOYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 10:24:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C60C0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 07:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=o8pSPyCz9/gXa1rPmFGiaEsNhZ/KORyntI1yWxhyrfs=; b=fLkPLmK6tgshgY09IkT7aPTSJG
        XSORbn+5LIDUu6gzouX9jBtu5TB7xPkSeD8IRaunngkzkeo/MwegAjcqROMS8W3f4qcNewyWQHFei
        NBZn1p55DzsNyXWhynnfjqvcdq5eO3NT+4NxFqg3K29jTzzWqnTn+7oB463yhPOptMy/3d7f+woG1
        geEXGvR2EBLqYlzuPSmBt6Or0Y1u/1EaMuNPeGY2FcNl3+hmiwtcC/eNtDBy9LA1cFpF1xk7E5kjm
        tHNLpajMpvS3pF7P+nycPu+D5Z2A5glpIkSoNwM5XlHt8fMW5H2IYkCgM0LjBVlwtZyQPDXZLgYub
        XNuqZUgw==;
Received: from [2001:4bb8:180:7517:6acc:e698:6fa4:15da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lSKia-00FA58-Ro
        for linux-xfs@vger.kernel.org; Fri, 02 Apr 2021 14:24:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: RFC: remove the if_flags field in struct xfs_ifork
Date:   Fri,  2 Apr 2021 16:24:02 +0200
Message-Id: <20210402142409.372050-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

given how much confusion the ifork flags cause I thought we'd better
off just removing them as all the information is available from other
fields in the ifork structure anyway.

Only very lightly tested so far and thus for conceptual review.  It will
need a rebase of the attr initialization fixes anyway.

Diffstat:
 libxfs/xfs_attr.c          |   53 ++++++++++------
 libxfs/xfs_attr.h          |    1 
 libxfs/xfs_attr_leaf.c     |   13 +---
 libxfs/xfs_bmap.c          |  141 +++++++++++++--------------------------------
 libxfs/xfs_bmap.h          |    1 
 libxfs/xfs_btree_staging.c |    1 
 libxfs/xfs_dir2_block.c    |    2 
 libxfs/xfs_dir2_sf.c       |   12 +--
 libxfs/xfs_inode_fork.c    |   22 +------
 libxfs/xfs_inode_fork.h    |   14 +---
 scrub/bmap.c               |   15 +---
 scrub/symlink.c            |    2 
 xfs_aops.c                 |    3 
 xfs_attr_list.c            |    2 
 xfs_bmap_util.c            |   20 ++----
 xfs_dir2_readdir.c         |   10 +--
 xfs_dquot.c                |    8 --
 xfs_inode.c                |    9 --
 xfs_ioctl.c                |    2 
 xfs_iomap.c                |   20 ++----
 xfs_iops.c                 |    4 -
 xfs_qm.c                   |    8 --
 xfs_reflink.c              |    8 --
 xfs_symlink.c              |    6 -
 24 files changed, 141 insertions(+), 236 deletions(-)
