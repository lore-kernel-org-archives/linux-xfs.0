Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C008C32771
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Sep 2022 06:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiIRGsX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Sep 2022 02:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiIRGsW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Sep 2022 02:48:22 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D210413F2B
        for <linux-xfs@vger.kernel.org>; Sat, 17 Sep 2022 23:48:20 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id w20so13148114ply.12
        for <linux-xfs@vger.kernel.org>; Sat, 17 Sep 2022 23:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=sb9az87a6soNtAqBuXanZOvNyMs0Du/wPED8qEjRZ3Q=;
        b=lDAU5tJVFDUVgVBKj+qeqiFBySNhqx+yGka97DZmIEpnC0f9H64cfAHwN0NU9rswGn
         M76vWKrJNhJpxctb031x5Zp8ss0PkwLZibsa1j1kmSwUO5xbM8ty6nvEhztaKSrA3bAO
         vPGBwPJxW8KXEEd7WDhK+cL7DRXdeUu0Axe2GseWNAaXSBuUYMlhPR+KYZe6022x0nWk
         24tz8a8YEC1NHSBxHBAk8sbzc4LFB9LwJgkw4oc45npKq7pgqO5BsZc7H3+OwSZwb6wP
         4wc9loRy73BTqeL16iCMREU+gMd9gpXd/T6ETr9iIf0DXUnmVpAeYMCrZ9k4qpavR3L4
         UE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=sb9az87a6soNtAqBuXanZOvNyMs0Du/wPED8qEjRZ3Q=;
        b=5h1R5Z1RW5vnqn1O+5mtAW+xWu3ZjQQX9dX7QhHHixQ1Swy+a+96FYtjqloeb2lB5K
         oc/N3FYQd2FE4D3rcO8noYRlyglPI/l1wZEJ5hN50cTcP/jzrQ7sicaiUazyJOrDSt7Q
         fUrCm/Rm2Gjp/iCxwTcQxSVaPN7zBY1WoPYMUnf+j64wVX06MivE0PzQpDHaxRfZ8ccV
         LKCYS3zd+2qEdb5drbuoPKX+KmIQX608Mlsc12ibih2YoT5av0zAh2calDTXYrdeQ9Di
         6LYTtk76TRDSmob9E3wziyHF9rKV9ughCl/qurwUtJcVZk50VkbwrT3Pw6F8ULxzcrZ4
         kumA==
X-Gm-Message-State: ACrzQf2qH7QUBF/VmApuWvNABv9S0RX/voRU53Hd2xr7Ix3u2IzQ4lH6
        ghWSSorRl4Ff+mxrSgO0Kv0=
X-Google-Smtp-Source: AMsMyM5njAUOZw5YDxYBU1rQN/31B0k8DpqHJChl5QcE+rsvlRo02ZyUVI5m7U/sMd9RTNMYC3q9Ew==
X-Received: by 2002:a17:90b:3e8b:b0:202:c85d:8ffa with SMTP id rj11-20020a17090b3e8b00b00202c85d8ffamr24999656pjb.155.1663483700218;
        Sat, 17 Sep 2022 23:48:20 -0700 (PDT)
Received: from localhost.localdomain ([165.154.253.46])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090264cf00b00176a47e5840sm17859757pli.298.2022.09.17.23.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 23:48:19 -0700 (PDT)
From:   Stephen Zhang <starzhangzsd@gmail.com>
X-Google-Original-From: Stephen Zhang <zhangshida@kylinos.cn>
To:     djwong@kernel.org, dchinner@redhat.com, chandan.babu@oracle.com,
        yang.guang5@zte.com.cn
Cc:     zhangshida@kylinos.cn, starzhangzsd@gmail.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: trim the mapp array accordingly in xfs_da_grow_inode_int
Date:   Sun, 18 Sep 2022 14:48:08 +0800
Message-Id: <20220918064808.1206441-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Take a look at the for-loop in xfs_da_grow_inode_int:
======
for(){
        nmap = min(XFS_BMAP_MAX_NMAP, count);
        ...
        error = xfs_bmapi_write(...,&mapp[mapi], &nmap);//(..., $1, $2)
        ...
        mapi += nmap;
}
=====
where $1 stands for the start address of the array,
while $2 is used to indicate the size of the array.

The array $1 will advance by $nmap in each iteration after
the allocation of extents.
But the size $2 still remains unchanged, which is determined by
min(XFS_BMAP_MAX_NMAP, count).

It seems that it has forgotten to trim the mapp array after each
iteration, so change it.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
Changes from v1:
- Using the current calculation to calculate the remaining number of
  blocks is enough, as suggested by Dave.
---
 fs/xfs/libxfs/xfs_da_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e7201dc68f43..e576560b46e9 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2192,8 +2192,8 @@ xfs_da_grow_inode_int(
 		 */
 		mapp = kmem_alloc(sizeof(*mapp) * count, 0);
 		for (b = *bno, mapi = 0; b < *bno + count; ) {
-			nmap = min(XFS_BMAP_MAX_NMAP, count);
 			c = (int)(*bno + count - b);
+			nmap = min(XFS_BMAP_MAX_NMAP, c);
 			error = xfs_bmapi_write(tp, dp, b, c,
 					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
 					args->total, &mapp[mapi], &nmap);
-- 
2.27.0

