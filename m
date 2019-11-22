Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7DDC43215
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 06:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84CA22068F
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 06:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574403063;
	bh=hwMKDedI4CD9yAqhIKGCn9TEnS8XMjv6ngS0mRYmE40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eeW3rE3w908XmHpsuiH5XIXyrQB4Vc/8/sI8AMQU1ZcoggSAVFeBaU0zRzdJ3Ootz
	 nuK2zRHjp7Mdi6pq+BLNHcAR6OnEn44/3z1MnymhSqtG9mLOIlzURehfzBVkmi6uqI
	 Ekj3I8NEvaCy9sDzSV/DC0ptoniq+4zdnU6dW/OI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbfKVF4k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 00:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729208AbfKVF4j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 860042070A;
        Fri, 22 Nov 2019 05:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402199;
        bh=hwMKDedI4CD9yAqhIKGCn9TEnS8XMjv6ngS0mRYmE40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrKwozowY3KGd/jtuFkk4LbezkvXfWmzrdv+Ulr+TIist9yVD1fo1w2KU/oUoaznu
         /drBO7OOGj/KA3ntEjZRwIpUoEwYB1rzOn8tuASLDoOPyv6SlTlA0iVrsXabAfcZP/
         HJfC4ipRGhO900XKrST7/0mnd2DA+tEUsF5nhJtU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Bowler <nbowler@draconx.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 048/127] xfs: Align compat attrlist_by_handle with native implementation.
Date:   Fri, 22 Nov 2019 00:54:26 -0500
Message-Id: <20191122055544.3299-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
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
index fa0bc4d46065a..d3c0e4b8bf421 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -347,6 +347,7 @@ xfs_compat_attrlist_by_handle(
 {
 	int			error;
 	attrlist_cursor_kern_t	*cursor;
+	compat_xfs_fsop_attrlist_handlereq_t __user *p = arg;
 	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
 	struct dentry		*dentry;
 	char			*kbuf;
@@ -381,6 +382,11 @@ xfs_compat_attrlist_by_handle(
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

