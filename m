Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB674C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 06:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C604B60C51
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 06:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhHIHAM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 03:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbhHIHAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Aug 2021 03:00:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30610C0613CF
        for <linux-xfs@vger.kernel.org>; Sun,  8 Aug 2021 23:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=1u81vZN+SERzcKdTK+ZI+Yqg1v2/agnVfSacHxv0UHs=; b=fiKr0+ycRpCe/jdxhkYF43i83A
        QPbD1lCuourq1UTaVmxgkU8x52RrZLu5bFrOGqHanWXSbv4tK0cIOlTg6UY37TNpZcASWSS2phGxB
        NJVmM8ww8p+UvMVZOzcNWsxlXQg0g+E2jBSwiNeGEJ1h1Rv0C7+qC0FHt0Uc/ZwvPJa17uLTBlfvp
        PkJo0xSZtsRgcw7ZXWJKllmZUw5I+LUZ4mr58w/EcYB7CdywS0oTeFTOT+NHf/zHNwWne8hBkwdcN
        yr2vs55xVJi7vwDOZVC85Ic9uDx7COg2W4hB8eVLkbOYpdWwikALE2MYT5AwVszbO3PcxpO+Qme2T
        n6FEOT7A==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCzG6-00AjZb-Ia
        for linux-xfs@vger.kernel.org; Mon, 09 Aug 2021 06:59:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: don't allow disabling quota accounting on a mounted file system v2
Date:   Mon,  9 Aug 2021 08:59:34 +0200
Message-Id: <20210809065938.1199181-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

disabling quota accounting (vs just enforcement) on a running file system
is a fundamentally race and hard to get right operation.  It also has
very little practical use.

Note that the quotaitem log recovery code is left for to make sure we
don't introduce inconsistent recovery states.

A series has been sent to make xfstests cope with this feature removal.

Changes since v1:
 - fix a spelling mistake
 - add a new patch to remove xfs_dqrele_all_inodes

Diffstat:
 libxfs/xfs_quota_defs.h |   30 -----
 libxfs/xfs_trans_resv.c |   30 -----
 libxfs/xfs_trans_resv.h |    2 
 scrub/quota.c           |    2 
 xfs_dquot.c             |    3 
 xfs_dquot_item.c        |  134 --------------------------
 xfs_dquot_item.h        |   17 ---
 xfs_icache.c            |  107 ---------------------
 xfs_icache.h            |    6 -
 xfs_ioctl.c             |    2 
 xfs_iops.c              |    4 
 xfs_mount.c             |    4 
 xfs_qm.c                |   44 +++-----
 xfs_qm.h                |    3 
 xfs_qm_syscalls.c       |  243 ++----------------------------------------------
 xfs_quotaops.c          |   30 +----
 xfs_super.c             |   51 ++++------
 xfs_trans_dquot.c       |   49 ---------
 18 files changed, 78 insertions(+), 683 deletions(-)
