Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4F5C43215
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 06:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0B5820707
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 06:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574403439;
	bh=0VH8yrhi9GC0ENQNA7KNwTLpwZFqByhMisUPcy4OreE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gLgEtFTYzvSA+BwEs+ro57QvG3rBpg4/yc97Dt5YDBs8hqiBjfBvZVlx8owCu+6CB
	 mmj9UHIgqsvyPUgWkHlmY48zuDspjZF7HVEpBmKBXNqnTj3Xe1T83/5UWpP/ko6CRu
	 cxYduQlnkMG0NuerNHy/1Kjb3OcNUoke1xNfORpI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfKVGNf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 01:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbfKVGNe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A86E12071B;
        Fri, 22 Nov 2019 06:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403213;
        bh=0VH8yrhi9GC0ENQNA7KNwTLpwZFqByhMisUPcy4OreE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mn1QsmcN5+GgCKJ1TEQ4wrdCNpkYTNkONZQOIVXgjzLvgv/V7RlXQrBUNzZtOk+jI
         B2847hi/Jmw+yL60/N0t0uhObV1HwqT6r8P9b1itWBo7foA87od1KwSXTP0S1cNgFD
         Q5CKJyXFU96+kLvjKWJMw9bxvzknYbEcO/LLQ2YI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Bowler <nbowler@draconx.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 28/68] xfs: Align compat attrlist_by_handle with native implementation.
Date:   Fri, 22 Nov 2019 01:12:21 -0500
Message-Id: <20191122061301.4947-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Nick Bowler <nbowler@draconx.ca>

[ Upstream commit c456d64449efe37da50832b63d91652a85ea1d20 ]

While inspecting the ioctl implementations, I noticed that the compat
implementation of XFS_IOC_ATTRLIST_BY_HANDLE does not do exactly the
same thing as the native implementation.  Specifically, the "cursor"
does not appear to be written out to userspace on the compat path,
like it is on the native path.

This adjusts the compat implementation to copy out the cursor just
like the native implementation does.  The attrlist cursor does not
require any special compat handling.  This fixes xfstests xfs/269
on both IA-32 and x32 userspace, when running on an amd64 kernel.

Signed-off-by: Nick Bowler <nbowler@draconx.ca>
Fixes: 0facef7fb053b ("xfs: in _attrlist_by_handle, copy the cursor back to userspace")
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_ioctl32.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 1a05d8ae327db..e7372cef5ac33 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -346,6 +346,7 @@ xfs_compat_attrlist_by_handle(
 {
 	int			error;
 	attrlist_cursor_kern_t	*cursor;
+	compat_xfs_fsop_attrlist_handlereq_t __user *p = arg;
 	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
 	struct dentry		*dentry;
 	char			*kbuf;
@@ -380,6 +381,11 @@ xfs_compat_attrlist_by_handle(
 	if (error)
 		goto out_kfree;
 
+	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t))) {
+		error = -EFAULT;
+		goto out_kfree;
+	}
+
 	if (copy_to_user(compat_ptr(al_hreq.buffer), kbuf, al_hreq.buflen))
 		error = -EFAULT;
 
-- 
2.20.1

