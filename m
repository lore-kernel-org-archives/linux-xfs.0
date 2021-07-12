Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E82C07E99
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E47161026
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbhGLLSN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 07:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbhGLLRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jul 2021 07:17:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04DAC0613DD
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jul 2021 04:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=YSrVPa0Z+SkpmmwZ8fiwgT+iUJFDUpyF82+OSNKBa8c=; b=orT2sh2pghDLk0o2nbHhB7mEdS
        PevzdAzeDWnN8IdXZmH++rWQkJYwdugyw91G1WMIDchNO5QH78CJzMJWjg+Wxu8/aFCaZNqd2Vnxc
        3cughiLeeKezTFxdbsVUEW4QQ7dq7YstKVmVdTndRmThFgSxp+VuZy4bTmiasxSFmHSDH8vqPJUw3
        V78/B2NVeQZNQv8YacBv6WIoYVqUNoLK0CfeIt4AWVzSMH6IeNlGf/EB1PfzzTgaYPRoMrfDi16cS
        cQXsrKB/+YxOkguTjsg8otyRUJ8dcPq0rgn40rjCgFdgbTB5dj40iUscjAchJfVMo28oMw/NkuneJ
        +LzFz96g==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2ttL-00HXNP-Js
        for linux-xfs@vger.kernel.org; Mon, 12 Jul 2021 11:14:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: don't allow disabling quota accounting on a mounted file system
Date:   Mon, 12 Jul 2021 13:14:23 +0200
Message-Id: <20210712111426.83004-1-hch@lst.de>
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
