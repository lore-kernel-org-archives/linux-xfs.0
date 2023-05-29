Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B7BC7EE23
	for <linux-xfs@archiver.kernel.org>; Mon, 29 May 2023 02:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjE2C76 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 May 2023 22:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjE2C75 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2023 22:59:57 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DB5AF
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 19:59:54 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d2c865e4eso2125607b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 19:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685329194; x=1687921194;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=gq6u4fuVhhixsgabRqclhM4ISPN3VpjTu39o/Tgm5SY=;
        b=ImYV0ODsdU/zv6YAF/t1oyqIJR05DUHPRk06InufBCIqCXzATUaW5G3YMzAwjG9nEU
         ZSRWC1c3AjvpoqJdvri2J8AcjMcnTHK4Nroo/E2qZXVB/7xmNqHlt2m3qPHPcFp9Ycko
         Frj+ueA2nkv5ubJmymnWKTdnYZ4RSo8ScA+C32THblIEjur1y4SsvF2dTp+fOvPEZ9dL
         LpPD4b/ERfPmGvQkrp33dzyKUvXUFsFspnm3rynkqRYtgOh882BhCoTJxq0vFsmHqORE
         8EBybGJa85BsRSsAOyK0iY4GGtsEscqV1Bxai6IWlOgsdyFO2QiAKJJ+TGzck1aOozol
         0fww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685329194; x=1687921194;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gq6u4fuVhhixsgabRqclhM4ISPN3VpjTu39o/Tgm5SY=;
        b=dIvO+jl+QIFP35zTC8Xr7xbM9aNmVvqWdq+AGzeR9py4UG5A2NLsQmRbzHLvdFX0OR
         rDBM57MRlUTEZ0vBnoWbJB3gYL1eppE19fKONMBQ55fXfFcyOwAqeNRnSBBx+5ep3MHp
         ukem7KzIySRP+hVqS9ZqzgC2AcoVsql3Vs+/Md+xij9rR4xrVKNAxSDoWiPSxyucgTsF
         CNX+34ZgA+GR93xx874lMjiP4Xd46jx44KPoN71Aw7fCiFILwk+D+1xQMEM715VyOJbR
         jtfqS3rj6bVZ0CmvdS/A2qO1MbulXnEwj0DJeB5yzfARjIj7NVZMh2DQEyxWTtKsw5vL
         f6hA==
X-Gm-Message-State: AC+VfDz0REFGGtj9/NO7YP/KLEghaiTqxpsfH/MzlNlO3NwZarx31sKL
        EoCgvb8l8n3gY1kzucpm6TJ1ShBaC2pQ3UWnA1g=
X-Google-Smtp-Source: ACHHUZ76iepwdqKJObFb35ras9PfPLwy3XQUQeYZEESA/ngt9ge7dufnjV767u+C6g3xS8LkIDh/xA==
X-Received: by 2002:a05:6a20:3d1c:b0:10a:cbe6:69f0 with SMTP id y28-20020a056a203d1c00b0010acbe669f0mr8297099pzi.10.1685329194137;
        Sun, 28 May 2023 19:59:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id j4-20020aa783c4000000b0064f4aeedaa2sm5757518pfn.105.2023.05.28.19.59.53
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 19:59:53 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1q3T6t-005A3G-17
        for linux-xfs@vger.kernel.org;
        Mon, 29 May 2023 12:59:51 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1q3T6t-00CTKk-00
        for linux-xfs@vger.kernel.org;
        Mon, 29 May 2023 12:59:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix double xfs_perag_rele() in xfs_filestream_pick_ag()
Date:   Mon, 29 May 2023 12:59:50 +1000
Message-Id: <20230529025950.2972685-1-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_bmap_longest_free_extent() can return an error when accessing
the AGF fails. In this case, the behaviour of
xfs_filestream_pick_ag() is conditional on the error. We may
continue the loop, or break out of it. The error handling after the
loop cleans up the perag reference held when the break occurs. If we
continue, the next loop iteration handles cleaning up the perag
reference.

EIther way, we don't need to release the active perag reference when
xfs_bmap_longest_free_extent() fails. Doing so means we do a double
decrement on the active reference count, and this causes tha active
reference count to fall to zero. At this point, new active
references will fail.

This leads to unmount hanging because it tries to grab active
references to that perag, only for it to fail. This happens inside a
loop that retries until a inode tree radix tree tag is cleared,
which cannot happen because we can't get an active reference to the
perag.

The unmount livelocks in this path:

  xfs_reclaim_inodes+0x80/0xc0
  xfs_unmount_flush_inodes+0x5b/0x70
  xfs_unmountfs+0x5b/0x1a0
  xfs_fs_put_super+0x49/0x110
  generic_shutdown_super+0x7c/0x1a0
  kill_block_super+0x27/0x50
  deactivate_locked_super+0x30/0x90
  deactivate_super+0x3c/0x50
  cleanup_mnt+0xc2/0x160
  __cleanup_mnt+0x12/0x20
  task_work_run+0x5e/0xa0
  exit_to_user_mode_prepare+0x1bc/0x1c0
  syscall_exit_to_user_mode+0x16/0x40
  do_syscall_64+0x40/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Fixes: eb70aa2d8ed9 ("xfs: use for_each_perag_wrap in xfs_filestream_pick_ag")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 22c13933c8f8..2fc98d313708 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -78,7 +78,6 @@ xfs_filestream_pick_ag(
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
-			xfs_perag_rele(pag);
 			if (err != -EAGAIN)
 				break;
 			/* Couldn't lock the AGF, skip this AG. */
-- 
2.40.1

