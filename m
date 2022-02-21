Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A941C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Feb 2022 18:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiBUSkt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Feb 2022 13:40:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbiBUSil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Feb 2022 13:38:41 -0500
X-Greylist: delayed 942 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Feb 2022 10:38:17 PST
Received: from relay.sw.ru (unknown [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DC8C2A
        for <linux-xfs@vger.kernel.org>; Mon, 21 Feb 2022 10:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=tlS9GVyAwtLf0jhaq9JCh80sXEMylERk+MywO2YzoE0=; b=RFY+Y8nCLD8o
        liEjSeJK0hOpe7E60FvXusIdSK1gOSez+92ifn7C5zvq3CbcZYwdRTRw92Rbf4ZxZjOOJ7zKUCvX+
        SMa+CVOj9VsoXNhfaAnlMGVvAJZ9k0fTyEQfO2htLtdA1SEq3j0fD2yQDRXV42VXxwTH2/1sH1+lR
        f9ZQA=;
Received: from vz-out.virtuozzo.com ([185.231.240.5] helo=dptest2.perf.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1nMDKD-002wpF-0q; Mon, 21 Feb 2022 19:22:17 +0100
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     linux-xfs@vger.kernel.org
Cc:     christian.brauner@ubuntu.com, hch@lst.de, djwong@kernel.org
Subject: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Date:   Mon, 21 Feb 2022 21:22:18 +0300
Message-Id: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
X-Mailer: git-send-email 2.35.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_fileattr_set() handles idmapped mounts correctly and do not drop this
bits.
Unfortunately chown syscall results in different callstask:
i_op->xfs_vn_setattr()->...->xfs_setattr_nonsize() which checks if process
has CAP_FSETID capable in init_user_ns rather than mntns userns.

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 fs/xfs/xfs_iops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 09211e1d08ad..5b1fe635d153 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -774,7 +774,7 @@ xfs_setattr_nonsize(
 		 * cleared upon successful return from chown()
 		 */
 		if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
-		    !capable(CAP_FSETID))
+		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
 			inode->i_mode &= ~(S_ISUID|S_ISGID);
 
 		/*
-- 
2.35.0.rc2

