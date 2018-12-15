Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:37239 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeLOBWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Dec 2018 20:22:20 -0500
Received: by mail-it1-f196.google.com with SMTP id b5so12326808iti.2
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 17:22:19 -0800 (PST)
From: Nick Bowler <nbowler@draconx.ca>
Subject: [RFC PATCH v2 1/3] xfs: Align compat attrlist_by_handle with native implementation.
Date: Fri, 14 Dec 2018 20:22:57 -0500
Message-Id: <20181215012259.28358-2-nbowler@draconx.ca>
In-Reply-To: <20181215012259.28358-1-nbowler@draconx.ca>
References: <20181215012259.28358-1-nbowler@draconx.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

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
---
 fs/xfs/xfs_ioctl32.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index fba115f4103a..4c34efcbf7e8 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -336,6 +336,7 @@ xfs_compat_attrlist_by_handle(
 {
 	int			error;
 	attrlist_cursor_kern_t	*cursor;
+	compat_xfs_fsop_attrlist_handlereq_t __user *p = arg;
 	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
 	struct dentry		*dentry;
 	char			*kbuf;
@@ -370,6 +371,11 @@ xfs_compat_attrlist_by_handle(
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
2.16.1
