Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80645C432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 06:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 424A92070E
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 06:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574402830;
	bh=bd+l4JctyoeYXCZJ2Dfc0BfpyirtBreCT9vLJuWcGOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=f+YEp5tmWRzMv+rGi4qae/CNEVrPHkVouIfG+/DvzgxxkkBDRUacqlzSpEqK8m/k2
	 k16OYeqQoG6ab8AmG4iMo03I4SF9D5MMIF5/KBKOQOTrekibTHlboUK3YKeAravs97
	 cCYts9sFPS+RNFPvn4sFd9y6SKyUEIV8viABPVEQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbfKVGCH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 01:02:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729263AbfKVGCH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADE572068F;
        Fri, 22 Nov 2019 06:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402526;
        bh=bd+l4JctyoeYXCZJ2Dfc0BfpyirtBreCT9vLJuWcGOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVrrcnjMZ49CwyBUeyWZD0CZU1yaN1DIyNxY5GZZHQjXEaADZaNvMQ6HPh/fWAZDe
         9VUPqAb6h2ike9kGsfE6apVxQIkkMqIPum/7L+Re7iyWyiTCj+mQVEilEzsim24jW4
         IWlP/Tz5a7LJ+ssO8HslqRNl6IpuHHS2bzJ5XiSU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Bowler <nbowler@draconx.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 34/91] xfs: Align compat attrlist_by_handle with native implementation.
Date:   Fri, 22 Nov 2019 01:00:32 -0500
Message-Id: <20191122060129.4239-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
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
index 321f57721b922..8f18756ee405e 100644
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

