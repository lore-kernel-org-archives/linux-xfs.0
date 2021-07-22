Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D066EC6377D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0CC260551
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhGVGqB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhGVGqA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 02:46:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35896C061575
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jul 2021 00:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=iO2MB6Vm5vXD1AkuiuIYj8Sev2GLHFREkUntIsd+0MU=; b=pINl9lbuDMu/WI957H9hzChDtd
        ALuII8qJF7zIoYusntR45hWtsDY5iwiVuJcpXsFmoNMdUiEY2tnKOp4sHPtCCc3Pqn3RCgLwNNH0k
        eWL43foZ3aYDqnj41b/h8u8dbLVEzvkxhXHpz0DPMhAfBQQ6GUebrUT/HGB72d3kd7FdQz6BPVRC5
        Dg29poou/bxGYEfJXHyNPHs5vdfx+XInz+L9x9iUn1iYoPHAImiKfuh7j/E8+v0a07Hn5CcGwxo2A
        XXRwMj3C4FBcg+zUvvbSU1Me2UI0fKNsdVHaoGg32JiuHLOSmeqn5G2DrwjU6ymEmOb6LEt4KmzlT
        JgizWw3Q==;
Received: from [2001:4bb8:193:7660:643c:9899:473:314a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6T5v-009zod-42
        for linux-xfs@vger.kernel.org; Thu, 22 Jul 2021 07:26:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: don't allow disabling quota accounting on a mounted file system v2
Date:   Thu, 22 Jul 2021 09:26:07 +0200
Message-Id: <20210722072610.975281-1-hch@lst.de>
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

Diffstat:
 libxfs/xfs_quota_defs.h |   30 -----
 libxfs/xfs_trans_resv.c |   30 -----
 libxfs/xfs_trans_resv.h |    2 
 scrub/quota.c           |    2 
 xfs_dquot.c             |    3 
 xfs_dquot_item.c        |  134 --------------------------
 xfs_dquot_item.h        |   17 ---
 xfs_ioctl.c             |    2 
 xfs_iops.c              |    4 
 xfs_mount.c             |    4 
 xfs_qm.c                |   44 +++-----
 xfs_qm.h                |    3 
 xfs_qm_syscalls.c       |  243 ++----------------------------------------------
 xfs_quotaops.c          |   30 +----
 xfs_super.c             |   51 ++++------
 xfs_trans_dquot.c       |   49 ---------
 16 files changed, 77 insertions(+), 571 deletions(-)
