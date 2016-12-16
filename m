Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53026 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761614AbcLPP4k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Dec 2016 10:56:40 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FFB03F217
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2016 15:56:20 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uBGFuJWW022928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2016 10:56:19 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: don't indicate dirtiness if FSGEOMETRY fails
Message-ID: <fceea296-989c-a71d-a6e7-23560fd6db8b@redhat.com>
Date: Fri, 16 Dec 2016 09:56:19 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Today, pointing repair at an image hosted on a non-xfs
filesystem will result in a XFS_IOC_FSGEOMETRY_V1 failure,
but repair generally proceeds without further problems.

However, calling do_warn() sets fs_is_dirty to 1, so
xfs_repair -n exits with non-zero status, indicating
corruption.  This is incorrect.

Change the message to use do_log so that it does not
incorrectly indicate corruption.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--- 

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index d950a32..5c79fd9 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -696,7 +696,7 @@ main(int argc, char **argv)
 		struct xfs_fsop_geom_v1 geom = { 0 };
 
 		if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
-			do_warn(_("Cannot get host filesystem geometry.\n"
+			do_log(_("Cannot get host filesystem geometry.\n"
 		"Repair may fail if there is a sector size mismatch between\n"
 		"the image and the host filesystem.\n"));
 			geom.sectsize = BBSIZE;

