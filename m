Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388436AbeGXTIS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jul 2018 15:08:18 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96F45308214A
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 18:00:40 +0000 (UTC)
Received: from Liberator-5.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 683911001F4E
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 18:00:40 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: properly handle free inodes in extent hint validators
Message-ID: <4203c670-0064-8735-0931-573fdbeeaa67@redhat.com>
Date: Tue, 24 Jul 2018 11:00:39 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

When inodes are freed in xfs_ifree(), di_flags is cleared (so extent size
hints are removed) but the actual extent size fields are left intact.
This causes the extent hint validators to fail on freed inodes which once
had extent size hints. 

This can be observed (for example) by running xfs/229 twice on a
non-crc xfs filesystem, or presumably on V5 with ikeep.

Fixes: 7d71a67 ("xfs: verify extent size hint is valid in inode verifier")
Fixes: 02a0fda ("xfs: verify COW extent size hint is valid in inode verifier")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 33dc34655ac3..30d1d60f1d46 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -731,7 +731,8 @@ xfs_inode_validate_extsize(
 	if ((hint_flag || inherit_flag) && extsize == 0)
 		return __this_address;
 
-	if (!(hint_flag || inherit_flag) && extsize != 0)
+	/* free inodes get flags set to zero but extsize remains */
+	if (mode && !(hint_flag || inherit_flag) && extsize != 0)
 		return __this_address;
 
 	if (extsize_bytes % blocksize_bytes)
@@ -777,7 +778,8 @@ xfs_inode_validate_cowextsize(
 	if (hint_flag && cowextsize == 0)
 		return __this_address;
 
-	if (!hint_flag && cowextsize != 0)
+	/* free inodes get flags set to zero but cowextsize remains */
+	if (mode && !hint_flag && cowextsize != 0)
 		return __this_address;
 
 	if (hint_flag && rt_flag)


